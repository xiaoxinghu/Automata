//  Created by xhu on 25/07/17.

import Foundation

struct DFAState<AttachedType, InputType> where InputType : Hashable {
    var transitions: [InputType : Int] = [:]
    var isEnd: Bool = false
    var data: AttachedType? = nil
    var captures: [Int : Int] = [:]
}

class DFA<AttachedType, InputType> where InputType : Hashable {
    
    var states: [DFAState<AttachedType, InputType>] = []
    var initial: Int = 0
    
    func transition(from: Int, to: Int, with input: InputType) {
        var fromState = states[from]
        fromState.transitions[input] = to
        states[from] = fromState
    }
    
    func newState() -> Int {
        states.append(DFAState())
        return states.count - 1
    }
}

extension DFA: Automata {
    var finals: [Int] {
        return states.enumerated().filter { $0.element.isEnd }.map { $0.offset }
    }
    
    var size: Int {
        return states.count
    }
    
    var transitions: [(input: String, from: Int, to: Int)] {
        var all = [(input: String, from: Int, to: Int)]()
        for i in 0..<size {
            let trans = states[i].transitions.map { (input: "\($0.key)", from: i, to: $0.value) }
            all.append(contentsOf: trans)
        }
        return all
    }
}


