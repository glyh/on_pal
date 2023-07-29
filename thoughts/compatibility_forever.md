Let's face the truth: language dies. I recently watched the talk [Can C++ be 10x Simpler & Safer by Herb Sutter](https://www.youtube.com/watch?v=ELeZAKCN4tY). It seems quite interesting and is quite inspiring for me to develop a language.

What's more interesting is that, as time goes. People will find better syntax, and better semantic for a language. Yet on the other end, people wants compatibility. This post is intended to solve that issue. 

I really like Perl's solution, where each script declare the version it should use. This contains both syntax and semantic the script should stick to. 

In Yula, because we have arbitrary syntax extension, it should be splitted from semantic evolution. Here is how you approach it: 

```
mod module_name
  
  # this is a shortcut for all of the following.
  lang yula.1
  
end

```

Yula language follows [semver](https://semver.org/): `a.b.c`:

> Given a version number MAJOR.MINOR.PATCH, increment the:

> - MAJOR version when you make incompatible API changes
> - MINOR version when you add functionality in a backward compatible manner
> - PATCH version when you make backward compatible bug fixes

> Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

In general, a script should stick to `a.b` and the compiler uses the highest available `c`

This is just a proposal, I have no clue how it would workout. But what I'm implying here is that we should admit the limitation of our foresight and there's simply stuff we can't foresee. The `compat` mechanic is just a safety net, preventing us going into the dead end languages like C++ reaches.

It should be note that, semvers are just alias. Internally, the language is rolling released, and some released hash is tagged with a semver.

Thus, there's no compatibility issues. The limitation of this approach is that you can't backport.

I don't know if the lockfile approach is also good enough. It worths a look.
