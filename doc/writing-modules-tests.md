# Writing modules tests

Testing is something we take too serious.  The following sections explain
different types of tests to make mcm as trustful as possible.

## Running tests locally

To run tests locally (in opposite to run it in a sandbox), one should have to
use the script available in `mcm/tests/modules/run-modules-tests.sh`, like:

    $ cd mcm
    $ sh tests/modules/run-modules-tests.sh modules/file/tests/*

In this example we are running all the tests written for the "file" module.
We can pass only one or a specific number of tests.  We can even run every
test from every module:

    $ sh tests/modules/run-modules-tests.sh modules/*/tests/*

## Introduction on test writing

A module tree directory looks like this:

    my_module/
        my_module.doc.{rst,md,txt}
        my_module.execute.sh
        my_module.verity.sh
        tests/
            a_test/
                a_test.mcm.in
                a_test.pre-local.sh.in
                a_test.sh.in
            another_test/
                another_test.mcm.in
                another_test.sh.in

All modules must have a "tests" directory.   This directory lives alongside
with other files of the module.  Inside the "tests" directory, there should
be other directories, one per test.  In the example above we see two tests:
"a_test" and "another_test".

## Main test files: .mcm.in and .out

Inside each test directory, we should have two obligatory files.  Suppose we
have a test directory called "foo".  The obligatory files are:

* foo.mcm.in
* foo.out

But there is also optional files:

* foo.sh.in
* foo.pre-local.sh.in

The purpose of ".pre-local.sh.in" files we explain later.

Realized the ".in" suffix in each file?  It means that, before being executed,
these files are preprocessed by a simple sed program inside the test
framework.  This sed program replaces all ocurrences of "@testdir@" for the
actual temporary test directory (that is created with mktemp and is something
like "/tmp/.mcm.testdir.XXXX").  So you should always use "@testdir@" when
writing your test files.

So, things work like this:

1. before anything else, if "foo.pre-local.sh.in" exists, the test framework
   preprocess it, and pipes it to the shell.

2. then, the test framework preprocess "foo.mcm.in" file and pipes it to mcm
   (no intermediate file is created).

3. mcm executes the mcm file.

4. mcm leaves the "@testdir@" in a state to be checked by the sh script.

5. if file "foo.sh"in" exists, the test framework preprocess it and pipes it
   to the shell (no intermediate file is created).

6. the shell execute the script that should check whether mcm leave
   "@testdir@" in the correct state.

The test writer should not have to worry about removing "@testdir@" at the end
of the test, since the directory is automatically removed.

Now, let's show up an example.  For the file_ module, we'll create a simple
test.  So, let's first decide where our files should dwell.  Since we are
creating tests for the file module, these files should be below "file/tests"::

    file/
        tests/
            our_test/
                our_test.mcm.in
                our_test.sh.in

In this test, we'll check two cases:

1. whether or not mcm created a directory

2. whether or not mcm created a file with a given content

"our_test.mcm.in" file looks like this::

    file:
            *name: case 1: directory creation
            path: @testdir@/dir1
            type: directory

    file:
            *name: case 2: file creation
            path: @testdir@/our_file
            contents: Hello World!

Realize that we did specify the target directory simply as "@testdir@".  The
test framework takes care of replacing it by the real directory name.

"our_test.mcm.sh" looks like this::

    #!/bin/sh

    # case 1: Check whether the directory was created
    test -d @testdir@/dir1

    # case 2: Check whether the file was created
    test -f @testdir@/our_file
    echo 'Hello World!' > @testdir@/our_file.check
    diff -u @testdir@/our_file @testdir@/our_file.check

The test shell script just have to check whether or not the "@testdir@" script
is in the desired state.  In this case we are checking if "dir1" directory
exists, if "our_file" exists, then we create another temporary file with the
expected content and compare both files with diff (that does not output
anything and exit with success status if both are equal).  See that we do not
have to worry about deleting any file we've created inside "@testdir@".

Note that we do not need to explicitly exit the test script.  We run it with
shell "set -e" flag so we try to catch errors early.

We can now run it::

    $ cd mcm      # the root of the mcm source distribution
    $ sh tests/modules/run-modules-tests.sh modules/file/tests/our_test

And we'll get the following result::

    > case 1: directory creation
      [Changed]
    > case 2: file creation
      [Changed]
    OK: 0        Changed: 2        Skipped: 0
    :-) file/tests/our_test passed
    Failed: 0        Passed: 1

Anything you print on the test shell script file will show up on the output
(because the test framework executes mcm with the -v flag).  You can use it
for debugging.

## File .pre-local.sh.in and mock creation

There is also an optional file which extension is ".pre-local.sh".  As the
name suggests (after being preprocessed by the test framework like other files
ending in ".in"), this script will be executed before running the mcm file.
It should be used to prepare the environment inside "@testdir@", specially for
creating mocks.

The test above is simple really doesn't change the environment.  After you run
the test, it will remove "@testdir@" and all the temporary files you just
created.  This is because files are isolated in a separated hierarquical
namespace called "the directory tree".  But imagine you have to test a module
that creates users in the system.  You cannot just add a user with "useradd"
program and remove it later, because you don't know whether or not this user
already exists on the system.  Even a random name like "LcN1oAq4nG" can lead
to name clashing.

Our idea is to test whether our module works, not the program "useradd".  So
we can "fake" "usermod" command by creating a script that does nothing (or
does something only inside "@testdir@").  We can then create a "usermod"
script so it fakes "usermod" for our test.

Imagine we have a module "user" that handles user accounts on the system that
is organized like the following tree::

    user/
        user.doc.{rst,md,txt}
        user.execute.sh
        user.verity.sh
        tests/
            a_test/
                a_test.mcm.in
                a_test.pre-local.in
                a_test.sh.in

The "user.execute.sh" script uses "useradd" to add users to the system.
"a_test" have to test this feature.  The "a_test.sh.in" will create necessary
mocks.  Its contents is::

    #!/bin/sh

    mkdir '@testdir@/mocks'

    echo '
    #!/bin/sh
    exit 0
    ' > '@testdir@/mocks/useradd'

    chmod 755 '@testdir@/mocks/useradd'

What this script does?  It:

1. creates the "@testdir@/mocks" directory;

2. creates an "useradd" script that does nothing (returns success);

3. set the right permissions so the "useradd" script can be executed.

If the "@testdir@/mocks" directory exists, it will be prepended in "$PATH" by
our framework just before all other directories.  So it is pretty easy to
create mocks for our tests.

One does not need to clean the "mocks" directory because, as we told before,
"@testdir@" is ripped out after test finishes, an so is everything inside it,
including mocks.

Although the ".pre-local.sh.in" script was thought specially for creating
mocks, it can be used for anything regarding preparing the environment for
testing.

## Running tests in a sandbox

Besides local testing (with optional ".pre-local.sh.in" script and mocks) it
is possible to perform a sandbox test.  In a sandbox test, the test framework
runs the test in another machine through ssh.  This machine can be anything
that accepts ssh, like a virtual machine or a qemu emulated machine.

Sandbox tests are useful for testing modules that can have side-effects on the
system, like when installing a package or creating a user account on the
system.

To run tests in a sandbox, you should also use
"mcm/tests/modules/run-modules-tests.sh", but pass other parameters to it::

    $ cd mcm
    $ sh tests/modules/run-modules-tests.sh \
        -s \
        tests/modules/qemu-sandbox-create.sh \
        tests/modules/qemu-sandbox-destroy.sh \
        modules/file/tests/*

The "-s" flag tells the "run-modules-test.sh" script to run in sandbox mode.
In this mode, we should pass two more parameters to it: the former is the path
to a script that creates our sandbox; the later is another script that
destroys the sandbox when the test finishes.  Inside the mcm distribution, in
the "tests/modules" directory, there are two files I keep that create and
destroy qemu images: "qemu-sandbox-create.sh" and "qemu-sandbox-destroy.sh"
but you are free to use any script and sandbox types other than qemu.

Despite running in a sandbox, it works exactly like normal tests, but it
doesn't execute the ".pre-local.mcm.in" script before running them.  It
wouldn't make sense to create something like "mocks" if the idea of a sandbox
environment is to freely make tests that have side-effects.
