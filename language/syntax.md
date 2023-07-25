## Classification
Pal's syntax is strongly influenced by [Rust](https://www.rust-lang.org/).

## List of readable languages

Here's a list of language I found pretty readable to human:
- With algol-like syntax
  - [Zig](https://ziglang.org/)
  - [Scala](https://www.scala-lang.org/)
  - [Groovy](https://groovy-lang.org/)
- With basic-like syntax
  - [Ruby](https://www.ruby-lang.org/)
  - [Lua](https://www.lua.org/) [Applescript](https://macosxautomation.com/applescript/)
  - [Basic](https://en.wikipedia.org/wiki/BASIC)
- With sh-like syntax
  - [Powershell](https://learn.microsoft.com/en-us/powershell/)

## Keywords

- Ruby-like
- Elixir-like Pattern matching
- First class array, table(hashmap, use this term so it doesn't clash with the function map), keywords(as in clojure)
- UFCS
- List comprehension & for yield(not yet)

## A taste of Pal

Here's some code that maybe of interest: 

```
# Specify the dialect information for this source file, this is similar to racket's #lang tag
lang
  use multline_string
end

# Pattern matching:
name of Str = "Corvo" # pattern matching, the semantic is similar to that of elixir
(x of Float, l = [y .. rest] of List(Float)) = (9.0, [9.2, 10, 13])
average = 0.5 * (x + y) # type annotation is optional
average_works_as_well = 0.5 * (x + y) of Float # type annotation is optional
(list = [first, second .. rest], (uname: uname, fruit)) = ([1, 2, 3, 4], (uname: "Linux", fruit: "Apple"))
# list == [1, 2, 3, 4], first == 1, second == 2, rest == [3, 4], uname == "Linux", fruit == "Apple"

[a, a] = [1, 1] # only binds if the two values are the same, just like in Elixir
a = 3
^a = 3 # only binds if the rhs matches the original value of lhs, just like in Elixir
(a, a) = (1, 2) # this will fail

# if you want to return the value instead of dropping it, leave the comma just as in rust

# Basic Types

# Numbers
123
123_456_789
1e3 # this can be both int and float
0x123 # radix 16
0o123 # radix 8

# Strings

wow = "string"

formatted = ~f"1 + 1 = {1 + 1}\n" # this is a f-string
raw = ~raw"This is a \r\a\w string" # raw strings
[[String supports alternative string delimiter just as in Lua]]
~a/in sigil you can also use slash/and-pass-another-arg-if-needed
~a(you can use brace)note-that-no-space
~a[bracket]is-allowed
~a{moustache}here
~a[=[And of course the lua like deliminater is also supported]=]so-fancy
~r/default.format.[a-z]+for regex/i # pass additional param to regex
~t(2020-01-07 04:01:21) # default format for date literal and all other literals

s = 
  \\ This is 
    ~r\\ a \s\e\r\i\e\s
      ~f\\ of multiline {wow}
        \\ Note that it is indentation insignificant
# And I borrow this from Zig
# Don't know if there's a more beautiful symbol for this tho.

# in general, if you see a `~` it implies that the following is a sigil(concept borrowed from elixir).

# Built-in containers

# Brackets denote homongenious, while braces denote heterogeneous
[abc: "foo", def: "bar"] # we have growable homongeneous table
# it should be note that, this is just the short form for:
[:abc => "foo", :def => "bar"]
# just as in elixir, and yes we have keywords(clojure)
:abc
# `\` is line continuation
(a: "ads", b: 1, "hell" => :yeah) \
of Tuple(a: Str, b: Int, "hell" => Keyword)
# we have heterogeneous ungroable named tuple(i.e. struct)
[1, 2, 3, 4] # we have homogeneous growable list 
(1, "a", True, 4) # we have heterogenious ungrowable tuple
~set[1, 2, 3, 4] # and we have set
() # we have unit i.e. empty tuple
(True, False) # we have booleans
# typed tuple should be playable at runtime via something like [milessabin/shapeless](https://github.com/milessabin/shapeless)
[1, 2, 3, 4].at(0) # accessing array 

# Bindable pattern(setter)
# This is inspired by [redplanetlabs/specter](https://github.com/redplanetlabs/specter)

# pub sum = fn(x: Float, y: Float, z: Float) Float: x + y + z

# in Pal, cons cell is represented with `->` 
1 -> 2 -> 3
# yes this is the same construct used to represent type of function type
# designed trait & impl syntax

trait Mappable(M)
end

# we may declare a variable then implement it: 
at :: M(:a) -> (:a -> :a) -> M(:a) forall Mappable(M) 
at = (omitted here)

# TODO: figure out how to pattern match on function type

a = [1, 2, 3, 4]
(a.at(0), a.at(3)) = (3, 9) # modifying the array
# a == [3, 2, 3, 9]

# this is not support, explicitly
# if True: a.at(0) else: a.at(1) = 7

# this is supported instead
a.at(if True: 0 else: 1) = 7
# a = [7, 2, 3, 9]

# broadcasting
l = [1, 2, 3, 4, 5]
# note this is just Generalized Update Syntax
l.at(..) += 1 # l = [1, 2, 3, 4, 5]
# this is just an interesting application of setter semantic
# related: https://developer.hashicorp.com/terraform/language/expressions/splat
# and it's clear that we don't need map in our std, horay!
# it should be noted that at is polymorphic, as it accepts both index and range

# Note the following is ugly, need a better syntax
# also it's possible to incapsulate the selector pattern to a new function: 
l.{.at(..) + 1}
# equivalent to l.map($ + 1)
# or do l.at(..) += 1; l end
# note that the new scope forbids l escaping, so they're technically same
# note that this doesn't have any side effect
# and it's chainable
l.{.at(..) + 1}.{.at(0) = 3}
l.swap{ |l| l.at(..) += 1; l }

# how to make this shorter? a = f(a) 
a swap= f

swap :: :a -> (:a -> :b) -> :b

10.times{ puts "love" }

# here {at(..) += 1} is just the sugar: 
# fn(x) x.at(..) += 1; x end
# so the following works but are nonsense
l.(fn(x) x.at(..) += 1; x end)

# Note that semicolon is used to discard the first result

# Note that this is not mutability, it's just rebinding a to a new array

# Mutability:
counter of Atom(Int) = ref(0) # creates an atom just as in clojure.
counter.deref += 1 
# swaping the atom with selector pattern syntax
# Or: 
print(f"{counter.deref()}\n") # dereferencing an atom we get the underlying value
swap(counter, fn(x): x + 1) # I need to reassure the colon rule works the same as in elixir

# Function definition: 
sum = fn(x, y, z): x + y + z of Float -> Float -> Float -> Float
# I expect pattern matching to be working on types so there's job to be done lol
a -> Float -> Float -> b = typeof(sum)

# Or
sum of Float -> Float -> Float -> Float = fn(x, y, z): x + y + z
# or (we also make it public in this case) 
pub sum = fn(x: Float, y: Float, z: Float) Float: x + y + z

# or just:
fn sum(x, y, z): x + y + z

# vararg version of sum, along with pattern matching
# `...` is the shorthand for `.. ...`, its value depends on the context
# if `...` is inside a pattern, it means `.. ...`
# o.w. it's just a binded value
fn sum(...)
  case ... # any do at the end of line of a construct is omittable
    [] => 0
    [first ...]  => apply(sum, ...) + first
    # note the difference:
    # say we have ... = (1, 2, 3)
    # (1 ...) = (1, 2, 3)
    # (1, ...) = (1, (2,3))
  end
end

# `_` discard the values 
[_ .. rest] = [1, 2, 3, 4] # rest = [2, 3, 4]

# `?abc` requires compiler to query the type of the hole
?abc = 1 # compiler will yield: ?abc of Int 

# the compiler prevents read from `_` and `?abc` 
# the compiler prevents write to `...`

# Calling a function
sum(4, z: 3, y: 1) # yields 8, note that positional arguments must appear before keyword arguments
# We follow UFCS(Universal Function Call Syntax)
4.sum(3, 1) # yields 8

# Partial application
4.sum(3) of Float -> Float
# BTW this function is actually still polymorhic because it's vararg, but we can 
# coerce it to a specific type
4.sum(3)(1) # yields 8

# Applying to a tuple: 
a.(1) # equivalent to a((1))

# Modules are just heterogenious tables
abc.def() # a qualified call
# there's also an alternative syntax: 
# abc:def, so that you can use functions from another module with UFCS
# Note that above is actually just a syntax sugar for accessing fields in a table
1 = (abc: 1).abc = (abc: 1).at(:abc)
# nim supports both UFCS and fields so it should be possible for us to do this too.

# Types

# `ok?` is defined as below:
# _ means we don't care the thing within in pattern matching
fn ok?(r: Result(_, _)) Bool do
  match r do
    Ok(_) -> True
    Err(_) -> False
  end
end
# WARN: we don't allow omitting (), so we can distinguish function call from functions.

# $ mean an anonymous function in expression, just like in clojure:
$.sum(3, 4) of (float ...).to(float)
# we can have $1, $2 ... for positional arguments
# TODO: design a workable type signature for varargs

# you can chain statements in the same line: 
# every statement is itself an expression so we use `,`
(1, 2, 3, 4)

# The following if-expression has type int | string

if (a = b = c).ok? 
  # pattern matches! 
  # you can call a function without parens! (only works for dot notation)
  # ok? of Result(_, _).to(Bool)
  3 + 4
elif c == d
  9 * 8
else
  "a" ++ "b"
end

# `elif` is just `else: if` (could be a reader macro here)
# we also have `elmatch`, which is equivalently `else: match`

# and the above is actually this, because do's are omitted:

if (a = b = c).ok? do 
  3 + 4
else: if c == d do 
  9 * 8
else do 
  "a" ++ "b"
end

if True: 3 + 4 else: 3 - 4

# I need more elaboration on how `do ... end` and `:` works 

# We have control structures
# they have an imperative interface but can be used functionally
# I may need to take a look at Common Lisp, Scala, Zig, F# and Hy lang to decide how to desig them precisely.
# here the syntax is similar to what we have in zig.
i = do
  break 1
end
# a hard problem: inferencing type for do block

forever
end # infinite loop

forever: nop # infinite loop with nothing done

# for comprehension
# a <- b is multi-pattern matching
# this is only allowed in for expression
for: [a .. b] <- [1, 2, 3]
  (a, b)
end # [([], [1, 2, 3]), ([1], [2, 3]), ([1, 2], [3]), ([1, 2, 3], [])]

for: i <- 1..=4, j <- 5..=8
  # note that for the following block, result should be () | a, we allow skipping the loop
  yield i + j
end

# or: 
for 
  i <- 1..=4
  j <- 5..=8
do
  yield i + j
end

# ranges, l-inclusive, r-exclusive by default
1..10 # [1, 2, 3, 4, 5, 6, 7, 8, 9]
1,4..10 # [1, 4, 7]
1,4..=10 # [1, 4, 7, 10]

..9,10 # this only works if we have a right bounded range

# from rust:
1..2  # std::ops::Range
3..   # std::ops::RangeFrom
..4   # std::ops::RangeTo
..    # std::ops::RangeFull
5..=6 # std::ops::RangeInclusive
..=7  # std::ops::RangeToInclusive

# Chained Try
# I want to introduce effect system
# assert: Result(_, _) -> excepton ()
try 
  response = fetch_from_network(resource_id)
  assert(response.network_success)
  value = response.value
catch e try
  print(e)
  assert(resource_id.in(offline_cache))
  value = offline_cache.at(resource_id)
catch try
  print("Failed to get resource. Use manual value?")
  response = user_input("Resource override: ")
  assert(not response:cancelled)
  value = response:value
else
  raise Error('Network not available and ID {resource_id} not in offline cache.')
end
```
