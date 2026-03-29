#set document(
    title: "Assignment 3 Report",
    author: "Haoyu Ren 124090521",
    date: auto,
)


#set par(
    justify: true,
)

#set raw(lang: "cpp")

#set enum(
    numbering: "a.",
    indent: 2em
)

#show link: lk => {
    set text(fill: blue);
    underline(lk)
}

#align(center)[#title() - by ridoger, Haoyu Ren 124090521]

= Bonus 

`DAGBuilder::build()` is implemented as a solitary function.

= Static Latency Model

(a) Both load and store instructions use multiple cycles, but at most of time there's no need to wait for store to finish. We can run the next instrucion immediately, even the store is still in progress. 

(b) A static latency model may be not precise, but it is better than having no model at all. It can help us optimize the code at least in some extent.

= Dependency Detection

(a) As long as the value of a register is not changed, then the order of different instructions that read the register does not matter. Regardless of the order, they will read the same value.

(b) The graph should be directed to show the time order of instructions. 

The graph should be acyclic, otherwise every instruction in the cycle will have an unstarted instruction as its dependency, and all instrucions in the cycle cannot ever start.

= Priority Calculation 

(a) The latter instruction doesn't need the result of the former one.

#link("https://chatgpt.com/share/69c8d1f7-a2b4-8325-8010-28d1eec856a0")[ChatGPT conversation about WAW hazard]

(c) #link("https://chatgpt.com/share/69c92e93-64c0-8326-89f1-f886789b693b")[ChatGPT conversation about deleting elements in a vector]

= Tie-Breaking Policies

(a) MOST_CHILD makes more instructions get ready when meets a tie, which provides more opportunities for parallelism.

For instance: ```assemly
            mul    t0, a0, a1       # A, CPL = 10 + 3 = 13
            mul    t1, a1, a2       # B, CPL = 10 + 3 = 13
            div    t2, t1, x1       # C, depends only on B, CPL = 10
            div    t3, t0, t1       # D, depends on A and B, CPL = 10
```

Obey MOST_CHILD, the schedule result will be BACD, cost 14 cycles in total.
Otherwise, the schedule result will be ABCD, cost 15 cycles in total.

(b) When there are multiple parallel chain of instructions where some have long chain of low latency instructions and some have short chain of high latency instructions, then LPT will be a better choice.

= Complexity Analysis

(a) We ignore the time cost of `selectBestNode()` since ready set is much smaller than the universal set which is going to be traversed each time `Scheduler::getReadyNodes()` is called.

There will be $O(n)$ cycles, in each cycle we call `getReadyNodes()` which is $O(n)$. This results in time complexity is $O(n^2)$.

Besides, in each cycle we visit the best node's successors to update their dependency counts. Throughout the process every edge is visited for once, which results in time complexity $O(e)$.

Hence, the overall time complexity is $O(n^2 + e)$.

(b) $O(n+e)$. Since we use memorized algorithm, priority for each node is computed exactly once, then every time we visit the same node, the priority will be reused. Also, each edge is visited exactly once.
