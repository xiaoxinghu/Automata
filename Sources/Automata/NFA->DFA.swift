//  Created by xhu on 28/07/17.

import Foundation

extension NFA {
    func epsClosure(_ states: Int...) -> [Int] {
        return epsClosure(states)
    }
    
    func epsClosure(_ _states: [Int]) -> [Int] {
        var stack = Set<Int>(_states)
        var ec = stack
        
        while let s = stack.popFirst() {
            states[s].epsilons.forEach {
                ec.insert($0)
                stack.insert($0)
            }
        }
        return Array(ec)
    }
    
    func move(from states: [Int], with input: InputType) -> [Int] {
        return states.reduce([Int]()) { accu, current in
            return accu + move(from: current, with: input)
        }
    }
    
    func move(from state: Int, with input: InputType) -> [Int] {
        let state = states[state]
        return state.transitions[input] ?? []
    }
    
    func getAllInputs() -> [InputType] {
        let allInputs: [InputType] = states.reduce([]) { all, state in
            return all + state.transitions.keys
        }
        
        return Array(Set(allInputs))
    }
    
    func toDFA() -> DFA<AttachedType, InputType> {
        var stateMap = [Set(epsClosure(initial))]
        let dfa = DFA<AttachedType, InputType>()
        var unmarked = [dfa.initial]

        while let s = unmarked.popLast() {
            
            let nfaStates = stateMap[s]
            
            let f = nfaStates.intersection(finals)
            if f.count > 0 {
                dfa.states[s].isEnd = true
                dfa.states[s].data = states[f.first!].data
            }
            
            for i in getAllInputs() {
                let u = epsClosure(move(from: Array(nfaStates), with: i))
                let nextStateSet = Set(u)
                if nextStateSet.isEmpty { continue }
                var nState: Int!
                
                if !stateMap.contains(nextStateSet) {
                    nState = dfa.newState()
                    stateMap.insert(nextStateSet, at: nState)
                    unmarked.append(nState)
                    
                } else {
                    nState = stateMap.index(of: nextStateSet)!
                }
                
                for (g, edges) in captures.enumerated() {
                    for e in edges {
                        if nfaStates.contains(e.from) && nextStateSet.contains(e.to) {
                            dfa.states[s].captures[nState] = g
                        }
                    }
                }
                dfa.transition(from: s, to: nState, with: i)
            }
        }
        
        return dfa
    }
}

