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
  - [Lua](https://www.lua.org/)
  - [Applescript](https://macosxautomation.com/applescript/)
  - [Basic](https://en.wikipedia.org/wiki/BASIC)
- With sh-like syntax
  - [Powershell](https://learn.microsoft.com/en-us/powershell/)

## Keywords

- Ruby-like
- Elixir-like Pattern matching
- First class array, map, atoms(in elixir, or keywords in clojure)
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
(list = [first, second .. rest], (uname: uname, fruit)) = ([1, 2, 3, 4], (uname: "Linux", fruit: "Apple"));
# list == [1, 2, 3, 4], first == 1, second == 2, rest == [3, 4], uname == "Linux", fruit == "Apple"

[a, a] = [1, 1] # only binds if the two values are the same, just like in Elixir
a = 3
^a = 3 # only binds if the rhs matches the original value of lhs, just like in Elixir
(a, a) = (1, 2) # this will fail

# if you want to return the value instead of dropping it, leave the comma just as in rust

# Basic Types

# Strings

wow = "string"

formatted = ~f"1 + 1 = {1 + 1}\n" # this is a f-string
raw = ~r"This is a \r\a\w string" # raw strings

s = 
  \\ This is 
    \\ a series
      ~f\\ of multiline {wow}
        \\ Note that it is indentation insignificant
# And I borrow this from Zig
# Don't know if there's a more beautiful symbol for this tho.

# in general, if you see a `~` it implies that the following is a sigil(concept borrowed from elixir).

# Built-in containers

# Brackets denote homongenious, while braces denote heterogeneous
[abc: "foo", def: "bar"] # we have growable homongeneous map
# it should be note that, this is just the short form for:
[:abc -> "foo", :def -> "bar"]
# just as in elixir, and yes we have atoms like elixir(or keyword in clojure)
:abc
# `\` is line continuation
(a: "ads", b: 1, "hell" -> :yeah) \
of Tuple(a: Str, b: Int, "hell" -> Atom)
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
a = [1, 2, 3, 4]
(a.at(0), a.at(3)) = (3, 9) # modifying the array
# a == [3, 2, 3, 9]
# Note that this is not mutability, it's just rebinding a to a new array

# Mutability:
counter of Ref(Int) = &0 # creates an atom just as in clojure. we just use c-like syntax here
counter.swap(_ + 1) # BTW here we're using something similar to scala's anonymous function
*counter = *counter + 1
# Or: 
print(f"{*counter}\n") # dereferencing an atom we get the underlying value
swap(counter, fn(x): x + 1) # I need to reassure the colon rule works the same as in elixir

# Function definition: 
sum = fn(x, y, z): x + y + z of (Float, Float, Float).To(Float)
# Or
sum of (Float, Float, Float).To(Float) = fn(x, y, z): x + y + z
# or (we also make it public in this case) 
pub sum = fn(x: float, y: float, z: float) float: x + y + z

# or just:
fn sum(x, y, z): x + y + z

# vararg version of sum, along with pattern matching
# note that semicolon maybe omitted here.
# `...` is the shorthand for `.. ...`, its value depends on the context
# if `...` is inside a pattern, it means `.. ...`
# o.w. it's just a binded value
fn sum(...)
  case ... # any do at the end of line of a construct is omittable
    [] -> 0
    [first ...]  -> apply(sum, ...) + first
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
# UFCS also works for operators:
1.+(3).*(4)
# thus we don't allow any operator that starts with an dot

# Partial application
4.sum(3) of Float.To(Float)
4.sum(3)(1) # yields 8

# note that due to partial application, the following is True:
(float, float, float).to(float) = (float, float).to(float.to(float)) = float.to(float.to(float.to(float)))

# Modules are just heterogenious maps
abc:def() # a qualified call
# Note that above is actually just a syntax sugar for accessing fields in a map
1 = (abc: 1):abc = (abc: 1).at(:abc)

# Types

# `ok?` is defined as below:
# _ means we don't care the thing within in pattern matching
fn ok?(r: Result(_, _)) Bool do
  match r do
    Ok(_) -> True
    Err(_) -> False
  end
end

# or it can mean an anonymous function in expression:
_.sum(3, 4) of (float ...).to(float)
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

# and the above is actually this, because do's are omitted:

if (a = b = c).ok? do 
  3 + 4
else: if c == d do 
  9 * 8
else do 
  "a" ++ "b"
end

if true: 3 + 4 else: 3 - 4

# I need more elaboration on how `do ... end` and `:` works 

# We have control structures
# they have an imperative interface but can be used functionally
# I may need to take a look at Common Lisp, Scala, Zig, F# and Hy lang to decide how to desig them precisely.
# here the syntax is similar to what we have in zig.
i = do
  break 1
end

# abusing UFCS

# ranges (BTW probably it's better to replace this with list-comprehension )
1.up_to(10) # [1, 2, 3, 4, 5, 6, 7, 8, 9]
1.up_to(10).step(3) # [1, 4, 7]
1.through(10).step(3) # [1, 4, 7, 10]
```
