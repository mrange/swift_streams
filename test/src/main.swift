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

func expect_eq<T : Equatable> (lno : Int, e : T, a : T) -> Bool {
  if (e == a) {
    return true
  } else {
    ++errors
    print ("expect_eq \(lno): \(e) == \(a)")
    return false
  }
}

func expect_eq<T : Equatable> (lno : Int, e : [T], a : [T]) -> Bool {
  if (e == a) {
    return true
  } else {
    ++errors
    print ("expect_eq \(lno): \(e) == \(a)")
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
  expect_eq (__LINE__, e: e0, a: a0)

  let e1 : [Int] = some_array
  let a1 : [Int] = from_array (some_array) |> to_array ()
  expect_eq (__LINE__, e: e1, a: a1)
}

func test__from_range () {
  print (__FUNCTION__)

  let e0 : [Int] = [Int] (empty_range)
  let a0 : [Int] = from_range (empty_range) |> to_array ()
  expect_eq (__LINE__, e: e0, a: a0)

  let e1 : [Int] = [Int] (some_range)
  let a1 : [Int] = from_range (some_range) |> to_array ()
  expect_eq (__LINE__, e: e1, a: a1)
}

func test__from_string () {
  print (__FUNCTION__)

  let e0 : String = empty_string
  let a0 : String = from_string (empty_string) |> to_string ()
  expect_eq (__LINE__, e: e0, a: a0)

  let e1 : String = some_string
  let a1 : String = from_string (some_string) |> to_string ()
  expect_eq (__LINE__, e: e1, a: a1)
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//                            ---==> PIPES <==--
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//                            ---==> SINKS <==--
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------


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
  expect_eq (__LINE__, e: e0, a: a0)

  let e1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  let a1 =
    to_array ()
    <| take (10)
    <| from_range (1...10000000)
  expect_eq (__LINE__, e: e1, a: a1)
}

func run_test (test : Void -> Void) -> Void {
  // TODO: Catch exceptions
  return test ()
}

run_test (test__from_range)
run_test (test__from_string)
run_test (test__use_cases)

if errors == 0 {
  print ("All tests passed!")
} else {
  print ("\(errors) test(s) failed!")
}
