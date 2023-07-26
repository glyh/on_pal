1. Start up time. That's a big factor affecting whether people will choose your language or not.
2. Built-in C-FFI & Zig-FFI: so that it's easier to extend the language if you feel you're being constrained by it.
   I expect close integration between Yula and zig, that's another reason for choosing zig because it's type system is relatively simple and they don't have a ownership system.
   while the downside maybe that I have to implement any type that zig may represent in my language, the upside is that the integration is free.

3. Type Safety: I want to ensure macro expansion is type safe. There seem to be some paper related, I need to take a look on them. 
