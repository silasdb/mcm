line - add a line to a file
===========================

Introduction
------------

``line`` module adds lines to a file.  If the file doesn't exist, it creates
it.

.. important::

    Currently it is not possible to specify where line module adds the line,
    so it appends it to the end of the file.

Example
-------

Appends a line to ``/tmp/a_file``::

    task line -path /tmp/a_file -line 'this is a line'

Parameters
----------

``line`` (required)
    String.  The line to be appended to the file.

``path`` (required)
    String.  File path.
