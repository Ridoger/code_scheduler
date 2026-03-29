#include "DAGBuilder.h"

#include <iomanip>
#include <iostream>
#include <set>

std::vector<DAGNode> DAGBuilder::build(const std::vector<Instruction>& instructions) {

    // Declaration
    std::vector<DAGNode> nodes;
    std::map<std::string, std::vector<int>> readers;
    std::map<std::string, int> writer;

    // Initialize nodes
    nodes.resize(instructions.size());

    // Traverse instructions to detect
    for (int i = 0; i < static_cast<int>(instructions.size()); ++i) {

        // Set instruction index for debugging and output
        nodes[i].inst_index = i;

        auto& inst = instructions[i];

        // detect RAW
        std::set<std::string> unique_srcs;
        for (const auto& src : inst.src_regs) {

            if (unique_srcs.find(src) != unique_srcs.end()) {
                continue;  // Skip duplicate sources
            }
            unique_srcs.insert(src);

            auto it = writer.find(src);
            if (it != writer.end()) {
                addEdge(nodes, it->second, i, DependencyType::RAW, src);
            }
            readers[src].push_back(i);
            
        }

        // detect WAR & WAW
        if (inst.hasDestReg()) {

            for (const auto& reader : readers[inst.dest_reg]) {
                if (reader != i) {  // Avoid self-dependency
                    addEdge(nodes, reader, i, DependencyType::WAR, inst.dest_reg);
                }
            }
            readers[inst.dest_reg].clear();  // New reads depend on new write

            auto it = writer.find(inst.dest_reg);
            if (it != writer.end()) {
                addEdge(nodes, it->second, i, DependencyType::WAW, inst.dest_reg);
            }

            // Update last writer
            writer[inst.dest_reg] = i;
        }

        // Update unscheduled predecessors count
        nodes[i].unscheduled_predecessors = static_cast<int>(nodes[i].predecessors.size());

    }

    return nodes;

}

void DAGBuilder::addEdge(
    std::vector<DAGNode>& nodes, int from, int to, DependencyType type, const std::string& reg) {
    // By the construction, no duplicate edges will be generated,
    // hence we skip the check for performance.

    // from -> to
    nodes[from].successors.emplace_back(to, type, reg);
    // to <- from
    nodes[to].predecessors.emplace_back(from, type, reg);
}

void DAGBuilder::printDAG(const std::vector<DAGNode>& nodes,
                          const std::vector<Instruction>& instructions,
                          std::ostream& os) {
    os << "\n";
    os << "Dependency Graph (DAG)\n";
    os << "  [ <- ] Predecessors (instructions that must be completed first):\n";
    os << "  [ -> ] Successors (instructions that depend on this instruction):\n";
    os << "\n";

    for (size_t i = 0; i < nodes.size(); i++) {
        const auto& node = nodes[i];
        os << "Instruction " << i << ": " << instructions[i].raw_text << "\n";

        if (!node.predecessors.empty()) {
            for (const auto& edge : node.predecessors) {
                os << "   <- [" << edge.target_node << "] " << dependencyTypeToString(edge.type)
                   << " on " << edge.reg << "\n";
            }
        }

        if (!node.successors.empty()) {
            for (const auto& edge : node.successors) {
                os << "    -> [" << edge.target_node << "] " << dependencyTypeToString(edge.type)
                   << " on " << edge.reg << "\n";
            }
        }

        if (node.predecessors.empty() && node.successors.empty()) {
            os << "  (no dependencies)\n";
        }

        os << "\n";
    }
}
