#!/bin/sh

# Make sure that, if we use the module more than one time, it will be included
# only once.

count="$(echo '
task dummy_module -test_ret 0
task dummy_module -test_ret 0
task dummy_module -test_ret 0
task dummy_module -test_ret 0
task dummy_module -test_ret 0
' \
| ../../mcm -M modules \
| grep -c -F -x 'MCM_module_dummy_module_test ()')"

test "$count" -eq 1 || {
	echo "\$count is $count, should be 1"
	exit 1
}
