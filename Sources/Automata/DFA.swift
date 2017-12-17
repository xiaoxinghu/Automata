//  Created by xhu on 25/07/17.

import Foundation

public struct DFAState<InputType> where InputType : Hashable {
    public var transitions: [InputType : Int] = [:]
    public var isEnd: Bool = false
    public var captures: [Int : Int] = [:]
}

open class DFA<InputType> where InputType : Hashable {
    
    public var states = [DFAState<InputType>()]
    public var initial: Int = 0
    
    public func transition(from: Int, to: Int, with input: InputType) {
        var fromState = states[from]
        fromState.transitions[input] = to
        states[from] = fromState
    }
    
    public func newState() -> Int {
        states.append(DFAState())
        return states.count - 1
    }
}

extension DFA: Automata {
    public var finals: [Int] {
        return states.enumerated().filter { $0.element.isEnd }.map { $0.offset }
    }
    
    public var size: Int {
        return states.count
    }
    
    public var transitions: [(input: String, from: Int, to: Int)] {
        var all = [(input: String, from: Int, to: Int)]()
        for i in 0..<size {
            let trans = states[i].transitions.map { (input: "\($0.key)", from: i, to: $0.value) }
            all.append(contentsOf: trans)
        }
        return all
    }
}


