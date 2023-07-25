### Sugar
- Record Initialization
```haskell
pUri :: Parser Uri
pUri = do 
    uriScheme <- pScheme
    _ <- char ':'
    uriAuthority <- optional . try $ do
      _ <- string "//"
      authUser <- optional . try $ do 
        user <- T.pack <$> some alphaNumChar
        _ <- char ':'
        password <- T.pack <$> some alphaNumChar
        _ <- char '@'
        return (user, password)
      authHost <- T.pack <$> some (alphaNumChar <|> char '.')
      authPort <- optional (char ':' *> L.decimal)
      return Authority {..}
    return Uri {..}
```
Note: I think rust's version is better. and also I can't make it to my language

### Effects 
- Debugging Effect 
I want to provide an effect called debug. What it does is allowing printting to debug (file handle 2) when debug mode is enabled, and this effect can be ignored. In release mode, however, any debug effect is ignored.

### Logic

#### Logic Comprehension
Curry has a nice feature, where logic unification may return multiple values. I'm suspecting we may drop the for comprehension as a whole, and just use logicl unification for them.  

Imagined Syntax:

```ruby
# Here, x in [1, 2, 3] is a boolean expression.
# x is a logic variable.
# unification solves all value for x and in the for-comphrehension we may use them.

for x in [1, 2, 3]
  yield x+1
end

# returns [2, 3, 4]
# this is suprisingly readable. Don't know why people design 
# Haskell to be unreadable in the first place.

# and you can do this and all fancy stuff because of logic programming!

for [x, 2] in [[1, 2], [2, 1], [3, 2]]
  yield x
end # [1, 3]

# TODO: investigate relation between this and datalog

```
Note that I expect `for {logic expression}: {yield expression}`. 
But for syntax elegancy, boolean expression is also allowed. 

So the above is actually a sugar for:
```
for (x in [1, 2, 3] is True)
  yield x + 1
end
```
Here, `x in [1, 2, 3] is True` is the full logic statement. Also, any undefined variables automatically coerce to logic variable.
This(logic comphrehension) is tremendously useful, btw.

I need some other effect to designate that a function may yield different solution.
