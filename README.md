# Streams for Swift

Streams is a functional data pipeline library that uses `Push` semantics, it is used like this:

```
let a : [Int] =
  from_range (1...10000000)
  |> skip (10)
  |> filter { $0 % 2 == 0 }
  |> take (10)
  |> map { $0 + 1 }
  |> to_array ()

print ("Array \(a)")
```

Push pipelines often has performance benefits over pull (lazy) because: 

1. The code that drives the push pipeline is a for loop `for x in xs`. For loops in most languages is the most efficient way to iterate over collection.
1. Minimizes end-of-stream checks to the loop that drives the pipeline (refined push pipelines detects if the pipelines will always iterate to the end and in those cases uses a specialized code path without end-of-stream checks)

Then of course there's the question how efficient `Push` streams can be implemented in Swift. Can Swift (like C++) inline the closures or do they create closure objects? This is one of the motivations for this library, to investigate how to write efficient functional  libraries in Swift.

This library is inspired by the [F# Streams](http://nessos.github.io/Streams/) which in turn was inpired by Java 8 Streams.

Push pipelines have drawbacks compared to pull pipelines

1. Once started they will run to the end (F# Streams manages this by introducing a more complex pipeline definition)
2. Certain operators such as `order_by/then_by` are difficult to implement

TODO
====

1. Extend the `test_suite`
2. Implement the most obvious pipeline operators
3. Package `swift_streams` in a way that's easily consumable
