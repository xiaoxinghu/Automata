//  Created by xhu on 31/07/17.

import Foundation

protocol Automata {

    var transitions: [(input: String, from: Int, to: Int)] { get }
    var initial: Int { get }
    var finals: [Int] { get }
    var size: Int { get }
    
}

extension Automata {
    func graphviz() -> String {
        var nodes = [String]()
        var trans = [String]()
        
        for i in (0..<size) {
            var attributes: [String : String] = [
                "label": "S\(i)",
                "minlen": "50",
                "shape": "circle",
                "style": "filled",
                "fillcolor": "none",
                ]
            
            if i == initial {
                attributes["xlabel"] = "Start"
                attributes["fillcolor"] = "yellow"
            }
            
            if finals.contains(i) {
                attributes["shape"] = "doublecircle"
                attributes["fillcolor"] = "green"
            }
            
            let attrs = attributes.map { "\($0.key)=\($0.value)" }.joined(separator: " ")
            
            nodes.append("S\(i) [\(attrs)]")
        }
        
        trans = transitions.map { input, from, to in
            return "S\(from) -> S\(to) [label=\"\(input)\"]"
        }
        
        return """
        digraph {
        rankdir=TB;
        \(nodes.joined(separator: "\n"))
        \(trans.joined(separator: "\n"))
        }
        """
    }
}
