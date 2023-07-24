So selector pattern is similar to Scala's [monocle](https://www.optics.dev/Monocle/) or [chimney](https://github.com/scalalandio/chimney) after taking a look, but I think my approach is more elegant and composable.

Just realize that this is just lenses in haskell but with a nicer syntax

# here's a list of possible selector pattern's signature

```haskell
-- updating
f :: Functor M => M a -> ... -> (a -> Bool) -> (a -> a) -> M a
-- this can be used for ALL, ATOM, FIRST
-- additonal predicates may be composed into the last param

-- bulk updating
--                              predicate      transformer     output type
f :: Functor M => M a -> ... -> (a -> Bool) -> (N a -> N a) -> M a
-- this may support range deletion, it's a generalized case for previous case, 
-- but previous case should always be preferred when available due to efficiency
-- Note that the problem with the previous case is that it's not nestable.
-- but here it is. note that M and N is not necessarily the same

```
```clojure
(transform [ALL :a even?]
              inc
              [{:a 1} {:a 2} {:a 4} {:a 3}])
; [{:a 1} {:a 3} {:a 5} {:a 3}]
```
but the above could be implemented automatically with a wrapper that wraps the mapping function, so the last params is actually not crucial.

```haskell

-- predicate 
f :: a -> Bool
-- used after another selector to make the range tighter

-- inserting
f :: Functor M => M a -> ... -> a -> M a
-- this can be used for BEFORE-ELEM
-- not necessary, we can always select interested structure and insert 

-- inserting a whole collection
f :: Functor M => M a -> ... -> M a -> M a
-- this can be used for BEGINNING, and requires the functor to be addable
-- not necessary, we can always select interested structure and insert 

-- -- deleting
-- -- still don't know if there's a good syntax, I tend to use _ to indicating the value should be dropped
-- f :: Functor M => M a -> ... -> () -> M a
-- not necessary, we can always select them apply a deleteAt function

-- shuffling
-- INDEXED-VALS
-- don't know how to implement, but why not implement a specific shuffle function?  
```
```ruby
a = [1, 2, 3, 4]
a = a.swap(0, 1)
# IDEA: how good is allow this to be rewrite as:
a swap= 0, 1
# yeah it's pretty good but unreadable
```
