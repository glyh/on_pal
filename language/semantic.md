## [HVM](https://github.com/HigherOrderCO/HVM)
I notice that there's a functional VM called HVM, which is pretty interesting as 
parallization is automatically ensured. I expect this language to be statically 
typed with opt-in dyn type and functional. More info can be found around HVM.

## Pattern matching
  There's no assignment in Pal lang, only pattern matching and bindings

## Algebraic effects
  ala. `Result<Ok, Err>`, reference: [Koka](https://koka-lang.github.io/)

## Dependent Type
  Types should be first class citizen, reference: [Idris](https://www.idris-lang.org/). As you see I'm trying to include every programming concept in this language so they are programmable by the programmer, you. That's how we achieve extensibility.

## Languge is available all the time.
  Take a look at [Lux](https://github.com/LuxLang/lux) language to see their language state is available at runtime.
  Just like in [Common lisp](https://lisp-lang.org/) you're allowed to write code at runtime, you can dump a core image just like in common lisp.
  I expect the following should be possible in pal langauge.
  - send code between machine to execute the code
  - modify the software itself when it's running
  - automatic C-FFI

## Macros

I want this language to be extensible, so I decide to implement the two:

1. read macro like in Commmon Lisp. comments, sigils should be possible to implement 
with this system. read macros emit tokens. I call this sigil because it looks like sigil in elixir.
e.g. ~s is the splice read macro, it converts the collection to a list and generate a sequence of tokens
~r is the regex read macro. One of the challenge is that exposing both lexer and parser to user seems hard.

2. macro like in [Honu](https://dl.acm.org/doi/10.1145/2371401.2371420). macro emits syntax objects.

## Auto memoinization like in skip

## Functional

many interesting ideas in this area, I need to take some look.

## Data oriented error handling
I need to check [how functional programming achieves no runtime exceptions](https://softwareengineering.stackexchange.com/questions/420872/how-functional-programming-achieves-no-runtime-exceptions) and [elm error handling](https://guide.elm-lang.org/error_handling/)

## Design on the type monoid hierarchy
- https://stackoverflow.com/questions/49829666/why-has-haskell-decided-against-using-for-string-list-concatenation
- https://old.reddit.com/r/haskell/comments/151xadm/what_are_some_of_the_more_pragmatic_names_for/
- Curry lang use "Addable" for Monoid, that's a good start, I'll check.
