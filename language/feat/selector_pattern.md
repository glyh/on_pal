So selector pattern is similar to Scala's [monocle](https://www.optics.dev/Monocle/) or [chimney](https://github.com/scalalandio/chimney) after taking a look, but I think my approach is more elegant and composable.
# here's a list of possible selector pattern's signature

```haskell
-- updating
f :: Functor M => M a -> ... -> (a -> a) -> (a -> Bool) -> M a
-- this can be used for ALL, ATOM, FIRST
-- the last param is the predicate indicating whether we should apply the operation, 
-- so something like this works:
-- 
```
```clojure
(transform [ALL :a even?]
              inc
              [{:a 1} {:a 2} {:a 4} {:a 3}])
; [{:a 1} {:a 3} {:a 5} {:a 3}]
```
but the above could be implemented automatically with a wrapper that wraps the mapping function, so the last params is actually not crucial.

```haskell

-- inserting
f :: Functor M => M a -> ... -> a -> M a
-- this can be used for BEFORE-ELEM

-- inserting a whole collection
f :: Functor M => M a -> ... -> M a -> M a
-- this can be used for BEGINNING, and requires the functor to be addable

-- deleting
-- still don't know if there's a good syntax, I tend to use _ to indicating the value should be dropped
f :: Functor M => M a -> ... -> () -> M a

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
