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

= Problem 2

(a) Both load and store instructions use multiple cycles, but at most of time there's no need to wait for store to finish. We can run the next instrucion immediately, even the store is still in progress. 

(b) A static latency model may be not precise, but it is better than having no model at all. It can help us optimize the code at least in some extent.

= Problem 3

(a) As long as the value of a register is not changed, then the order of different instructions that read the register does not matter. Regardless of the order, they will read the same value.

(b) The graph should be directed to show the time order of instructions. 

The graph should be acyclic, otherwise every instruction in the cycle will have an unstarted instruction as its dependency, and all instrucions in the cycle cannot ever start.

= Problem 4

(a) The latter instruction doesn't need the result of the former one.

#link("https://chatgpt.com/share/69c8d1f7-a2b4-8325-8010-28d1eec856a0")[ChatGPT conversation about WAW hazard]

(c) #link("https://chatgpt.com/share/69c92e93-64c0-8326-89f1-f886789b693b")[ChatGPT conversation about deleting elements in a vector]
