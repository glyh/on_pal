-- https://williamyaoh.com/posts/2019-04-25-lens-exercises.html
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

import Data.Text
import Control.Lens

data User = User
  { _name     :: Text
  , _userid   :: Int
  , _metadata :: UserInfo
  }
  deriving (Show)

data UserInfo = UserInfo
  { _numLogins     :: Int
  , _associatedIPs :: [Text]
  }
  deriving (Show)

makeLenses ''User
makeLenses ''UserInfo

user1 = User
  { _name = "qiao.yifan"
  , _userid = 103
  , _metadata = UserInfo
    { _numLogins = 20
    , _associatedIPs =
      [ "52.39.193.61"
      , "52.39.193.75"
      ]
    }
  } 

-- type Lens s t a b = 
-- forall f. Functor f => (a -> f b) -> s -> f t

-- toy implementation of .~
-- `.~` is the field updater. For example:
-- user1 & metadata.numLogins .~ 0 
-- This will update the `metadata.numsLogins` field of `user1` to `0`
infixr 4 .~~
(.~~) :: 
  ((a -> Identity b) -> s -> Identity t)
  -> b 
  -> s 
  -> t

(.~~) l b s
  = runIdentity (l (\_ -> return b) s)

-- toy implementation of %~
-- `%~` is the field mapper. For example:
-- user1 & metadata.associatedIPs %~ ("192.168.0.2" :)
-- This will update the metadata.associatedIPs by applying the function `("192.168.0.2" :)` to it

infixr 4 %~~
(%~~) :: 
    ((a -> Identity b) -> s -> Identity t)
    -> (a -> b)
    -> s
    -> t

-- l is the lense, f is the applied function, s is the data structure.
(%~~) l f s 
  = runIdentity (l (return . f) s)

-- `^.` is the filed accessor. For example: 
-- user1 ^. numLogins.metadata will take the numLogins.metadata field from user1

infixl 8 ^.~
(^.~) :: 
  s 
  -> ((a -> Const a b) -> s -> Const a t)
  -> a

(^.~) s l
  = getConst (l (\a -> Const a) s)

name' :: Functor m => (Text -> m Text) -> User -> m User
name' f u@User{_name} = 
  u <$ (f _name)
