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

func test__tight_loop () {
  print (__FUNCTION__)

  var acc : Int64 = 0

  for outer in 1...10000 {
    acc +=
      from_start (1, toEnd: outer + 1)
      |> fold (0) { $0 + $1 }
  }

  print (acc)
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//                         ---==> TEST RUNNER <==--
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

let test_cases =
  [
      test__tight_loop
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
