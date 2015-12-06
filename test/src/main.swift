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

var errors = 0

func expect_eq<T : Equatable> (fname : String = __FILE__, lno : Int = __LINE__ , e : T, a : T) -> Bool {
  if (e == a) {
    return true
  } else {
    ++errors
    print ("\\E[31;40m\(fname)(\(lno)) expect_eq: \(e) == \(a)")
    return false
  }
}

func expect_eq<T : Equatable> (fname : String = __FILE__, lno : Int = __LINE__ , e : T?, a : T?) -> Bool {
  if (e == a) {
    return true
  } else {
    ++errors
    print ("\(fname)(\(lno)) expect_eq: \(e) == \(a)")
    return false
  }
}
func expect_eq<T : Equatable> (fname : String = __FILE__, lno : Int = __LINE__, e : [T], a : [T]) -> Bool {
  if (e == a) {
    return true
  } else {
    ++errors
    print ("\(fname)(\(lno)) expect_eq: \(e) == \(a)")
    return false
  }
}

let empty_range   = 1..<1
let some_range    = 1...10

let empty_array   = [Int] (1..<1)
let some_array    = [Int] (10...20)

let empty_string  = ""
let some_string   = "19740531"

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//                           ---==> SOURCES <==--
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

func test__from_array () {
  print (__FUNCTION__)

  let e0 : [Int] = empty_array
  let a0 : [Int] = from_array (empty_array) |> to_array ()
  expect_eq (e: e0, a: a0)

  let e1 : [Int] = some_array
  let a1 : [Int] = from_array (some_array) |> to_array ()
  expect_eq (e: e1, a: a1)
}

func test__from_range () {
  print (__FUNCTION__)

  let e0 : [Int] = [Int] (empty_range)
  let a0 : [Int] = from_range (empty_range) |> to_array ()
  expect_eq (e: e0, a: a0)

  let e1 : [Int] = [Int] (some_range)
  let a1 : [Int] = from_range (some_range) |> to_array ()
  expect_eq (e: e1, a: a1)
}

func test__from_start () {
  print (__FUNCTION__)

  let e0 : [Int] = [Int] (empty_range)
  let a0 : [Int] = from_start (0, toEnd: 0) |> to_array ()
  expect_eq (e: e0, a: a0)

  let e1 : [Int] = [Int] (1..<10)
  let a1 : [Int] = from_start (1, toEnd: 10) |> to_array ()
  expect_eq (e: e1, a: a1)
}

func test__from_string () {
  print (__FUNCTION__)

  let e0 : String = empty_string
  let a0 : String = from_string (empty_string) |> to_string ()
  expect_eq (e: e0, a: a0)

  let e1 : String = some_string
  let a1 : String = from_string (some_string) |> to_string ()
  expect_eq (e: e1, a: a1)
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//                            ---==> PIPES <==--
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

func test__filter () {
  print (__FUNCTION__)

  let e0 : [Int] = []
  let a0 : [Int] =
    from_array (empty_array)
    |> filter { $0 % 2 == 0 }
    |> to_array ()
  expect_eq (e: e0, a: a0)

  let e1 : [Int] = some_array.filter { $0 % 2 == 0 }
  let a1 : [Int] =
    from_array (some_array)
    |> filter { $0 % 2 == 0 }
    |> to_array ()
  expect_eq (e: e1, a: a1)
}

func test__map () {
  print (__FUNCTION__)

  let e0 : [String] = []
  let a0 : [String] =
    from_array (empty_array)
    |> map { "\($0)" }
    |> to_array ()
  expect_eq (e: e0, a: a0)

  let e1 : [String] = some_array.map { "\($0)" }
  let a1 : [String] =
    from_array (some_array)
    |> map { "\($0)" }
    |> to_array ()
  expect_eq (e: e1, a: a1)
}

func test__take () {
  print (__FUNCTION__)

  for variant in [0 , 3 ,some_array.count] {
    let e0 : [Int] = []
    let a0 : [Int] =
      from_array (empty_array)
      |> take (variant)
      |> to_array ()
    expect_eq (e: e0, a: a0)

    let e1 : [Int] = Array (some_array[0..<variant])
    let a1 : [Int] =
      from_array (some_array)
      |> take (variant)
      |> to_array ()
    expect_eq (e: e1, a: a1)
  }
}

func test__skip () {
  print (__FUNCTION__)

  for variant in [0 , 3 ,some_array.count] {
    let e0 : [Int] = []
    let a0 : [Int] =
      from_array (empty_array)
      |> skip (variant)
      |> to_array ()
    expect_eq (e: e0, a: a0)

    let e1 : [Int] = Array (some_array[variant..<some_array.count])
    let a1 : [Int] =
      from_array (some_array)
      |> skip (variant)
      |> to_array ()
    expect_eq (e: e1, a: a1)
  }
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//                            ---==> SINKS <==--
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

func test__fold () {
  print (__FUNCTION__)

  let e0 : Int = 1
  let a0 : Int = from_range (empty_range) |> fold (1) { $0 + $1 }
  expect_eq (e: e0, a: a0)

  let e1 : Int = 55
  let a1 : Int = from_range (some_range) |> fold (0) { $0 + $1 }
  expect_eq (e: e1, a: a1)
}

func test__to_array () {
  print (__FUNCTION__)

  let e0 : [Int] = empty_array
  let a0 : [Int] = from_range (empty_range) |> to_array ()
  expect_eq (e: e0, a: a0)

  let e1 : [Int] = [Int] (some_range)
  let a1 : [Int] = from_range (some_range) |> to_array ()
  expect_eq (e: e1, a: a1)
}

func test__to_string () {
  print (__FUNCTION__)

  let e0 : String   = empty_string
  let a0 : String   = from_string (empty_string) |> to_string ()
  expect_eq (e: e0, a: a0)

  let e1 : String   = some_string
  let a1 : String   = from_string (some_string) |> to_string ()
  expect_eq (e: e1, a: a1)
}

func test__find () {
  print (__FUNCTION__)

  let e0 : Int? = nil
  let a0 : Int? = from_range (empty_range) |> first ()
  expect_eq (e: e0, a: a0)

  let e1 : Int? = some_array[0]
  let a1 : Int? = from_array (some_array) |> first ()
  expect_eq (e: e1, a: a1)
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//                          ---==> USE CASES <==--
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

func test__use_cases () {
  print (__FUNCTION__)

  let e0 = [13, 15, 17, 19, 21, 23, 25, 27, 29, 31]
  let a0 =
    from_range (1...10000000)
    |> skip (10)
    |> filter { $0 % 2 == 0 }
    |> take (10)
    |> map { $0 + 1 }
    |> to_array ()
  expect_eq (e: e0, a: a0)

  let e1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  let a1 =
    to_array ()
    <| take (10)
    <| from_range (1...10000000)
  expect_eq (e: e1, a: a1)
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//                         ---==> TEST RUNNER <==--
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

let test_cases =
  [
   // Sources
      test__from_array
    , test__from_range
    , test__from_start
    , test__from_string
   // Pipes
    , test__filter
    , test__map
    , test__take
    , test__skip
    , test__use_cases
   // Sinks
    , test__fold
    , test__to_array
    , test__to_string
    , test__find
  ]

for test_case in test_cases {
  // TODO: Catch exceptions
  test_case ()
}

if errors == 0 {
  print ("All tests passed!")
} else {
  print ("\(errors) test(s) failed!")
}

// -----------------------------------------------------------------------------
