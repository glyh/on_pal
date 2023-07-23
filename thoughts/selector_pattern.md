# Data transformation langugage in Pal: the Selector Pattern

<!-- ## Rationale -->

<!-- The motivation is simple: functional programming is good in its guarantee but rather than its appearance. O.w. there's no reason for Scala, Haskell, etc to mimic the imperative features, like do-notation, monad-comphrehension, etc. -->

One of the crucial task in functional programming is the transformation of data structure, which is done in most language by retrieving all the relavant part and then piece the data structure back together. This is both inefficient and complicated. [Specter](https://github.com/redplanetlabs/specter) solved this issue, and I want to leverage it in my language as well, but with better syntax. The final result is that we can write something like this:

```ruby
a.f(b) g= c
```
where a is a complicated data structure, f is a selecter, b is the paramaters passed to the selecter, and g is the function applied onto the selected values, c is the applied value. Seems pretty complicated right? But read this, feel how elegant it is:

```ruby
l = [-4, -3, -2, -1, 0, 1, 2, 3]
l.filter($ < 0) *= -1 
# l = [4, 3, 2, 1, 0, 1, 2, 3]
```
How many loc you have to write in your awesome programming language to achieve this? Moreover it's a general way to apply data transformation!

## Generalized Update Syntax

Before introducing the new concept I want to introduce a syntax sugar that make our life simpler here. 

We all know `a += 1` and `a = a + 1` are equivalent in any sane language. But how about take it to the next level? That's what generalized update syntax do here. 

For any function `f` with the following signature:
```ruby
f :: (a, b).To(a)
# Or in Haskell language: a -> b -> a
```

We allow user to write:
```ruby
a = f(a, b)
```
as this:
```ruby
a f= b
```

So we have:

```ruby
a = 3
a max= 4 # a = 4, because max(a, 4) = 4

```

That's it! Now back to the original topic. 

## Imperative is more intuitive

In a functional language, we retrieve part of the collection by function. And that's just what we call "getter" in OOP languages. But where's the setters? There isn't a setter in functional language because it doesn't mutate state. 

However, it's a common thing that rebinding is allowed and eagerly recommended in many language, as it doesn't make sense to make up a lot of meaningless intermediate state during the transformation of the data structure.

Take an example, the following code:

```ruby
a = 1 
a = a + 1
```

So what you explain is that: `a` is first bind to value `1`, and then rebind to value `a + 1` which is `2`. But we all see the language is just trying to mimic imperative language, but there's nothing to feel shame about because it's more intuitive!

## Selector: setter counter part to getter in functional language

The above code is not so interesting, and we're really not hitting the sweet spot of imperative language: update a portion of the data structure.

In your everyday language you just write:

```ruby
a.b.c = d

```

But in a functional language, you write this:

```ruby
a = {{b = { c = d | a.b } } | a}
# here, {c = d | a.b } means take a.b, and update it with field c replaced by d.
```
Which is nonsense to me. And it's natural for me to crave for a better solution: the Selector Pattern.

What is a Selector Pattern? A selector pattern is a function with the following signature: 

```ruby
# Here ... is omitted and means potentially a lot of parameters
f :: Functor(M) => (M(a), ..., a.To(a)).To(M(a)) 
# Or in Haskell language: 
# f :: Functor M => M a -> ... -> (a -> a) -> M a
```

It's hard to understand it in theory, let me make some examples:

Note that here I assume indexing always succeed, which is not true in real life, for the sake of simplicity

```haskell
at :: List a -> Int -> (a -> a) -> List a
at :: List a -> Range -> (a -> a) -> List a
```

Take an example, suppose `l = [1, 2, 3, 4]` and we have the following: `l.at(0)`.

With the benefit from UFCS, the language may decide which argument is the primary slot. This case it's `l`. So this expression is a selector pattern on l, when being matched, it will replaced the corresponding values and rebind the new value to `l`.

We have the following:
```ruby
l = [1, 2, 3, 4]
l.at(0) = 3 # l = [3, 2, 3, 4]
# .. is the full range in Pal
l.at(..) = 0 # l = [0, 0, 0, 0]
```

Here's another example:

```haskell 
filter :: List a -> (a -> Bool) -> (a -> a) -> List a
```

```ruby
l = [-4, -3, -2, -1, 0, 1, 2]
l.filter($ < 0) = 99 # l = [99, 99, 99, 99, 0, 1, 2]
l.at(..) -= 50 # l = [49, 49, 49, 49, -50, -49, -48]
l.filter($ < 0) *= -1 # l = [49, 49, 49, 49, 50, 49, 48]
```

We succeeded in make functional language looks imperative without sacrificing its pros! And we can also make it nestable:

```ruby
l = [[1, 2, 3], []]
l.at(0).at(1) = 10
# the above compiled to:
# tmp = l.at(0)
# tmp.at(1) = 10
# l.at(0) = tmp
# we have the result: [[1, 10, 3], []]
```

## Why?
You may criticise that I ruin everything you appreciate as functional language because this is ultimately mutability. I argue that nobody cares about your elegant theory, they just want to get the job done. selector pattern is an elegant way to allow you to write both terse and readable code.

I was deceived that functional language can make your code more terse and intuitive. But no, that's wrong. That's only true under certain circustances. Some functional languages' feature are to the extent for its own sake. They push the feature so hard, just to boast how smart the people using them are. I really hate this kind of elite culture. 

There's a good saying, that expert's code can be understand by every lay person. And that's what I expect Pal to be like: Readablility first. 
