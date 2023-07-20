### Some sugars in mind:
- list splicing works
```
let a = [5, 6]
let [1, 2, 3, 4, 5, 6] = [1, 2, ~[3, 4] | a]
```
- pattern matching works in function arguments, ala function argument destructure, as in [Elixir](https://elixir-lang.org/).
- <del>pipe operator(elixir)/threading macros(clojure) </del> This is replaced by [UFCS](https://en.wikipedia.org/wiki/Uniform_Function_Call_Syntax)
