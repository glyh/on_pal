## Classification
Pal's surface syntax is strongly influenced by Ruby, however given the fact it's a functional language. It actually looks more similar to [Elixir](https://elixir-lang.org/). 


## List of readable languages

Here's a list of language I found pretty readable to human:
- [Ruby](https://www.ruby-lang.org/)
- [Lua](https://www.lua.org/)
- [Python](https://www.python.org/)
- [Groovy](https://groovy-lang.org/)

## A taste of Pal

Here's some code that maybe of interest: 

```

# Pattern matching:
let name :: string = "Corvo" # `let` creates a pattern matching, the semantic is similar to that of elixir
let (x :: float, l = [y | rest] :: list(float)) = (9.0, [9.2, 10, 13]) # type annotation is optional
let average = 0.5 * (x + y)
let (list = [first, second | rest], {uname: uname, fruit }) ([1, 2, 3, 4], {uname: "Linux", fruit: "Apple"}) 
# list == [1, 2, 3, 4], first == 1, second == 2, rest == [3, 4], uname == "Linux", fruit == "Apple"

[a, a] = [1, 1] # only binds if the two values are the same
a = 3
^a = 3 # only binds if the rhs matches the original value of lhs
(a, a) = (1, 2) # this will fail

# Basic Types

# Strings

let str = 
  #| This is 
    #| a series
      #| of multiline string
        #| Note that it is indentation insignificant

let formatted = ~f"1 + 1 = {1 + 1}%n" # this is a f-string

# Built-in containers

# Brackets denote homongenious, while braces denote heterogeneous
[abc: "foo", def: "bar"] # we have growable homongeneous map, borrowed from elixir
# it should be note that, this is just the short form for:
[:abc => "foo", :def => "bar"]
# just as in elixir, and yes we have keywords
:abc
(a: "ads", b: 1) # we have heterogeneous ungroable named tuple(i.e. struct)
[1, 2, 3, 4] # we have homogeneous growable list 
(1, "a", true, 4) # we have heterogenious ungrowable tuple
~set[1, 2, 3, 4] # and we have set
() # we have unit i.e. empty tuple
(true, false) # we have booleans
# typed tuple should be playable at runtime via something like milessabin/shapeless
[1, 2, 3, 4].at(0) # accessing array 

# Bindable pattern
# This is inspired by redplanetlabs/specter
a = [1, 2, 3, 4]
let (a.at(0), a.at(3)) = (3, 9) # modifying the array
# a == [3, 2, 3, 9]

# Mutability:
let counter :: mut[int] = ref 0 # creates an atom just as in clojure.
counter.swap(_ + 1) # or: 
swap(counter, fn(x) x + 1 end) 

# Function definition: 
let sum = fn(x, y, z) :: float -> float -> float -> float
  x + y + z
end
# Or just:
fn sum(x, y, z) x + y + z end

# Calling a function
sum(4, z = 3, y = 1) # yields 8, note that positional arguments must appear before keyword arguments
# We follow UFCS(Universal Function Call Syntax)
4.sum(3, 1) # yields 8

# Partial application
4.sum(3) :: (float -> float)
4.sum(3)(1) # yields 8

# Modules 
abc:def() # a qualified call

# Types

# The following if-expression has type int | string
if let a = b
  # pattern matches!
  3 + 4
elif c == d
  9 * 8
else
  # pattern matching failed!
  "a" ++ "b"
end

```

