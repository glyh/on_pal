### Some sugars in mind:
- list splicing works
```
let a = [5, 6]
let [1, 2, 3, 4, 5, 6] = [1, 2, ~[3, 4] | a]
```
- pattern matching works in function arguments, ala function argument destructure, as in elixir.
- pipe operator(elixir)/threading macros(clojure) 
