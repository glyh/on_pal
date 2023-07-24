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
infixr 4 .~~
(.~~) :: 
  ((a -> Identity b) -> s -> Identity t)
  -> b 
  -> s 
  -> t

(.~~) l b s
  = runIdentity (l (\_ -> return b) s)

-- toy implementation of %~
infixr 4 %~~
(%~~) :: 
    ((a -> Identity b) -> s -> Identity t)
    -> (a -> b)
    -> s
    -> t

(%~~) l f s 
  = runIdentity (l (return . f) s)

infixl 8 ^.~
(^.~) :: 
  s 
  -> ((a -> Const a b) -> s -> Const a t)
  -> a

(^.~) s l
  = getConst (l (\a -> Const a) s)

name' :: Functor f => (Text -> f Text) -> User -> f User
name' f u@User{_name} = 
  u <$ (f _name)
