Dummy module
============

Introduction
------------

The ``dummy_module`` is a module created with the sole purpose of testing
mcm_.  It basically is a "echo" module, i.e., it returns what is passed to it
by parameters.

Example
-------

::

    task dummy_module \
        .name 'just a test' \
        -test_ret 1 \
        -execute_ret 0 \
        -execute_out output

Executing it will yield the following results::

    $ mcm example.mcm | MCM_OPTIONS='-v' sh 
    > just a test
      [nok]
    ok: 0	nok: 1	skipped: 0

    $ mcm example.mcm | MCM_OPTIONS='-vx' sh 
    > just a test
    output
      [changed]
    ok: 0	changed: 1	skipped: 0

Parameters
----------

``test_ret`` (required)
    Integer. Set the return value for the test phase.

``test_out`` (optional, default: not set)
    String.  Set the value for standard output of the *test* phase (visible
    when passing the ``-v`` flag to the resulting script).

``test_err`` (optional, default: not set)
    String.  Set the value for standard error of the *test* phase (visible
    when passing the ``-v`` flag to the resulting script).

``test_ret`` (optional, default: ``0``)
    Integer. Set the return value for the test phase

``execute_out`` (optional, default: not set)
    String.  Set the value for standard output of the *execute* phase (visible
    when passing the ``-v`` flag to the resulting script or if there is an
    error).

``execute_err`` (optional, default: not set)
    String.  Set the value for standard error of the *execute* phase (visible
    when passing the ``-v`` flag to the resulting script or if there is an
    error).

.. _mcm: https://purl.org/net/mcm
