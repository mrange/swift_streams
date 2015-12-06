// ----------------------------------------------------------------------------------------------
// Copyright 2015 Mårten Rånge
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// ----------------------------------------------------------------------------------------------

// -----------------------------------------------------------------------------

public struct Source<T> {
  public let f: (T -> Bool) -> Void
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//                           ---==> SOURCES <==--
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

/// Creates a `Source<T>` from a generator function `Void -> T?`
///
/// - Complexity: O(1).
public func from_generator<T> (generator : Void -> T?) -> Source<T> {
  return Source<T> { c in
    while true {
      let ov = generator ()
      if let v = ov {
        if (!c (v)) {
          break;
        }
      } else {
        break;
      }
    }
  }
}

/// Creates a `Source<T>` from a `[T]`
///
/// - Complexity: O(1).
public func from_array<T> (vs : [T]) -> Source<T> {
  return Source<T> { c in
    for v in vs {
      if (!c (v)) {
        break;
      }
    }
  }
}

/// Creates a `Source<Character>` from a `String`
///
/// - Complexity: O(1).
public func from_string (s : String) -> Source<Character> {
  return Source<Character> { c in
    for cs in s.characters {
      if (!c (cs)) {
        break;
      }
    }
  }
}

/// Creates a `Source<T>` from a `Range<T>`
///
/// - Complexity: O(1).
public func from_range<T> (vs : Range<T>) -> Source<T> {
  return Source<T> { c in
    for v in vs {
      if (!c (v)) {
        break;
      }
    }
  }
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//                            ---==> PIPES <==--
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

/// Creates a functor that maps elements in `Source<T>` to `Source<U>`
/// using `mapper` function
///
/// - Complexity: O(1).
public func map<T, U> (mapper : T -> U) -> (Source<T> -> Source<U>) {
  return { s in
    return Source<U> { c in
      s.f { v in
        return c (mapper (v))
      }
    }
  }
}

/// Creates a function that filters elements in `Source<T>`
/// using `filter` function
///
/// - Complexity: O(1).
public func filter<T> (filter : T -> Bool) -> (Source<T> -> Source<T>) {
  return { s in
    return Source<T> { c in
      s.f { v in
        if filter (v) {
          return c (v)
        } else {
          return true
        }
      }
    }
  }
}

/// Creates a function that takes elements in `Source<T>`
/// until it has taken `atMost` elements. It then cancels the iteration
///
/// - Complexity: O(1).
public func take<T> (atMost : Int) -> (Source<T> -> Source<T>) {
  return { s in
    return Source<T> { c in
      var remaining = atMost
      s.f { v in
        if remaining > 0 {
          --remaining
          return c (v)
        } else {
          return false
        }
      }
    }
  }
}

/// Creates a function that skips elements in `Source<T>`
/// until it has skipped `atLeast` elements. It then proceeds as a normal Source<T>
///
/// - Complexity: O(1).
public func skip<T> (atLeast : Int) -> (Source<T> -> Source<T>) {
  return { s in
    return Source<T> { c in
      var remaining = atLeast
      s.f { v in
        if remaining > 0 {
          --remaining
          return true
        } else {
          return c (v)
        }
      }
    }
  }
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//                            ---==> SINKS <==--
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

/// Creates a function that folds elements in `Source<T>`
/// using an initial value and a folder function
///
/// - Complexity: O(n).
public func fold<T, U> (initial : U, folder : (U, T) -> U) -> (Source<T> -> U) {
  return { s in
    var r = initial

    s.f {
      r = folder (r, $0)
      return true
    }

    return r
  }
}

/// Creates a function that folds elements in `Source<T>`
/// into a `[T]`
///
/// - Complexity: O(n).
public func to_array<T> () -> (Source<T> -> [T]) {
  return { s in
    var r = [T] ()

    s.f { r.append ($0); return true }

    return r
  }
}

/// Creates a function that folds elements in `Source<Character>`
/// into a `String`
///
/// - Complexity: O(n).
public func to_string () -> (Source<Character> -> String) {
  return { s in
    var r = ""

    s.f { r.append ($0); return true }

    return r
  }
}

/// Creates a function that gets the first element in `Source<T>`
/// and returns it. If `Source<T>` is empty `first` returns `nil`
///
/// - Complexity: O(1).
public func first<T> () -> (Source<T> -> T?) {
  return { s in
    var r : T?

    s.f { r = $0; return false }

    return r
  }
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//                           ---==> INFIXES <==--
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

infix operator |> { associativity left precedence 80 }
infix operator <| { associativity right precedence 70 }

/// "Pipes" left to right (f (l))
public func |><T, U> (l : T, f : T -> U) -> U {
  return f (l)
}

/// "Pipes" right into left (f (l))
public func <|<T, U> (f : T -> U, l : T) -> U {
  return f (l)
}

// -----------------------------------------------------------------------------
