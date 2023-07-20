## Architecture
- Two parts
  - The JITed interpreter: for runtime code generation
  - The optimized compiler: for AOT.
- Self-hosting
  - There's no plan for self-hosting because it doesn't make sense for a language targeting HVM: they are using different calculation model, it's possible but it's doom to be a mess.
## Prototype
- Just glue everything together. Frontend language doesn't matter. 
- We can reuse HVM for most part as backend. I personally prefer Clojure for frontend.

## Real compiler
### Choice of langauge: Zig
- low level implies good enough performance.
- even more portable than C, and easy integration with C library.
- comptime can help me keep code clean.

### Against Rust
- Too hard to work with.
- VM is not safe inherently. We have to write a bunch of unsafe code, and we're not benefiting a lot from rust by doing that.
- I expect tight integration with C ecosystem and Zig host, rust is a no-go, because it will complicate my work with its own type system.
