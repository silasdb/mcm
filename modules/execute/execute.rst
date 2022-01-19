execute - execute a command or shell script
===========================================

Introduction
------------

``execute`` module executes a command or shell script.  It runs the content of
the ``test`` parameter as the test phase, i.e., if the execution of the
``test`` parameter is successful (exit status ``0``), the task is marked as
``[ok]``, if not, then it runs the content of the ``execute`` parameter and
the task is marked as ``[changed]`` (unless an error occurs).

The parameter ``shell`` specifies whether the command should be executed by a
shell or not.

This module is usually a good choice for quick stuff that can be later turn
into a module itself.

Example
-------

The execute phase for the following task will always be marked as
``[changed]`` (unless no error occurs)::

    task execute -execute 'rm -f /tmp/foo'

The following task mounts ``/mnt`` only if it is not mounted yet.  So, it can
be marked either as ``[changed]`` or ``[ok]`` (unless an error occurs)::

    task execute \
        -shell yes \
        -test 'mount | grep -q "^/mnt"' 
        -execute 'mount /mnt'

Parameters
----------

``execute`` (optional, default: not set)
    String.  The command or shell script to be executed for the execute phase
    of the task.  If not set, it is equivalent to ``exit 0``.

``shell`` (optional, default: ``no``)
    Boolean.  Defines if the execute and test phases will be read by a shell
    or not.

``test`` (optional, defaul: not set)
    String.  The command or shell script to be executed for the test phase of
    the task.  If not set, it is equivalent to ``exit 1``.
