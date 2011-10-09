#!/bin/bash
set -e

sh spec/fixture.sh

fail_test() {
  echo FAIL: $*
  exit 1
}
(
  cd spec/test-repo
  [ `../../bin/find_fattest_objects.sh -n 5 | wc -l` == "6" ] || fail_test "Didn't get expected number of output lines for find_fattest_objects.sh -n 5"
  [ `../../bin/find_fattest_objects.sh -n 3 | wc -l` == "4" ] || fail_test "Didn't get expected number of output lines for find_fattest_objects.sh -n 3"
  [ `../../bin/find_fattest_objects.sh | grep 4c89b197.*true | wc -l` == "1" ] || fail_test "Didn't show that 4c89 exists in the repo"
  [ `../../bin/find_fattest_objects.sh | grep ff456dc4.*true | wc -l` == "0" ] || fail_test "Showed that ff45 exists in the repo"
  [ `../../bin/find_fattest_objects.sh -d | wc -l` == "4" ] || fail_test "Didn't get expected number of output lines for find_fattest_objects.sh -d"
  [ `../../bin/find_fattest_objects.sh -d | grep ff456dc4 | grep 'file_1.txt' | wc -l` == "1" ] || fail_test "Didn't find expected object in find_fattest_objects.sh -d"
  [ `../../bin/find_fattest_objects.sh -df | grep ff456dc4 | grep 'file_1.txt' | wc -l` == "0" ] || fail_test "Found SHA in find_fattest_objects.sh -df"
  [ `../../bin/find_fattest_objects.sh -df | grep 'file_1.txt' | wc -l` == "1" ] || fail_test "Didn't find expected object in find_fattest_objects.sh -df"
  echo OK!
)