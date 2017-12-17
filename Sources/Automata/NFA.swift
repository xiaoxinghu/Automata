//  Created by xhu on 28/07/17.

import Foundation

public struct NFAState<InputType> where InputType : Hashable {
    public var transitions: [InputType : [Int]] = [:]
    public var epsilons: [Int] = []
}

public struct Edge<T> {
    public var from: Int
    public var to: Int
    public var input: T
    
    public init(from: Int, to: Int, input: T) {
        self.from = from
        self.to = to
        self.input = input
    }
}

extension Edge {
    func shift(offset: Int) -> Edge {
        return Edge(from: from + offset, to: to + offset, input: input)
    }
}

open class NFA<InputType> where InputType : Hashable {
    
    public var states: [NFAState<InputType>] = []
    public var initial: Int
    public var finals: [Int]
    
    public var captures: [[Edge<InputType>]] = []
    
    public init(_ input: InputType) {
        states = [NFAState(), NFAState()]
        initial = 0
        finals = [1]
        transition(from: 0, to: 1, with: input)
    }
    
    public init() {
        initial = -1
        finals = []
    }
    
    public func epsilon(from: Int, to: Int) {
        var fromState = states[from]
        fromState.epsilons.append(to)
        states[from] = fromState
    }
    
    public func newState() -> Int {
        let ns = NFAState<InputType>()
        states.append(ns)
        return states.count - 1
    }
    
    public func transition(from: Int, to: Int, with input: InputType) {
        var fromState = states[from]
        if fromState.transitions[input] == nil {
            fromState.transitions[input] = []
        }
        fromState.transitions[input]!.append(to)
        states[from] = fromState
    }
    
    public func shift(offset: Int) {
        initial += offset
        finals = finals.map { $0 + offset }
        captures = captures.map { $0.map { $0.shift(offset: offset) } }
        states = states.map {
            var newState = $0
            newState.transitions = newState.transitions.mapValues { $0.map { $0 + offset } }
            newState.epsilons = newState.epsilons.map { $0 + offset }
            return newState
        }
    }
}

extension NFA: Automata {
    public var size: Int {
        return states.count
    }
    
    public var transitions: [(input: String, from: Int, to: Int)] {
        var all = [(input: String, from: Int, to: Int)]()
        for i in 0..<size {
            let state = states[i]
            for (input, dests) in state.transitions {
                let trans = dests.map { (input: "\(input)", from: i, to: $0) }
                all.append(contentsOf: trans)
            }

            all.append(contentsOf: state.epsilons.map { (input: "ε", from: i, to: $0) })
        }
        return all
    }
    
}

extension NFA {
    public class func merge(_ nfas: NFA<InputType>...) -> NFA<InputType> {
        return _merge(nfas)
    }
    
    public class func merge(_ nfas: [NFA<InputType>]) -> NFA<InputType> {
        return _merge(nfas)
    }
}

private func _merge<InputType>(_ nfas: [NFA<InputType>]) -> NFA<InputType> {
    let root = NFA<InputType>()
    root.initial = root.newState()
    for nfa in nfas {
        nfa.shift(offset: root.size)
        root.states += nfa.states
        root.finals += nfa.finals
        root.epsilon(from: root.initial, to: nfa.initial)
        while root.captures.count < nfa.captures.count {
            root.captures.append([])
        }
        for (i, c) in nfa.captures.enumerated() {
            root.captures[i].append(contentsOf: c)
        }
    }
    return root
}
