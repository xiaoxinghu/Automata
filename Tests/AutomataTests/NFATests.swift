//
//  NFATests.swift
//  AutomataTests
//
//  Created by xhu on 14/12/17.
//

import XCTest
@testable import Automata

class NFATests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testNFA() {
        let nfas: [NFA<String, String>] = [NFA("H"), NFA("E"), NFA("L")]
//        nfa = nfa.concat(NFA("E"))
        let nfa = NFA<String, String>.merge(nfas)
        
        let dfa = nfa.toDFA()
        let nfaGraph = nfa.graphviz()
        try! nfaGraph.write(toFile: "/Users/xhu/Documents/nfa.dot", atomically: false, encoding: .utf8)
        
        let dfaGraph = dfa.graphviz()
        try! dfaGraph.write(toFile: "/Users/xhu/Documents/dfa.dot", atomically: false, encoding: .utf8)

        
    }
    
}
