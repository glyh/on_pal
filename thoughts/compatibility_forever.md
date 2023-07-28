Let's face the truth: language dies. I recently watched the talk [Can C++ be 10x Simpler & Safer by Herb Sutter](https://www.youtube.com/watch?v=ELeZAKCN4tY). It seems quite interesting and is quite inspiring for me to develop a language.

What's more interesting is that, as time goes. People will find better syntax, and better semantic for a language. Yet on the other end, people wants compatibility. This post is intended to solve that issue. 

I really like Perl's solution, where each script declare the version it should use. This contains both syntax and semantic the script should stick to. 

In Yula, because we have arbitrary syntax extension, it should be splitted from semantic evolution. Here is how you approach it: 

```
mod module_name
  
  # this is a shortcut for all of the following.
  compat yula.1
  
  syntax yula_syntax.1
  # the above is shortcut for: 
  # syntax multiline_string, ufcs, etc

  semantic yula_semantic.1
  # shortcut for:
  semantic first_class_type

  stdlib yula_std.1
end

```

Thus, no guarantee of semantic compatibility and syntax compatibility exists. This free the language from the issue of finally growing into a junk pile.

Yula 's verson number is of form `a.b.c.d`, where:
- `a` is the major incompatible semantic number.
- `b` is the major incompatible syntax number.
- `c` is the feature number.
- `d` is the fix number.

In general, a script should stick to `a.b.c` and the compiler uses the highest available `d`

This is just a proposal, I have no clue how it would workout. But what I'm implying here is that we should admit the limitation of our foresight and there's simply stuff we can't foresee. The `compat` mechanic is just a safety net, preventing us going into the dead end languages like C++ reaches.

