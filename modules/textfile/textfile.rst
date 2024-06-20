file - create regular files
===========================

Introduction
------------

``file`` module is used to create and change attributes of text files.  The
``file`` module don't handle binary data because of shell limitations.

Example
-------

Creates ``/home/username/file1.txt`` and sets the file owner and group::

    task file \
        -path /home/user/file1.txt \
        -content 'this file has a single line'
        -owner username \
        -group usergroup

Creates ``/etc/file.conf`` by embedding its content from a local file::

    task file -path /etc/file.conf +content ./local/file.conf

Parameters
----------

``content`` (optional, default: not set)
    String.  File content.

``force`` (optional, default: ``yes``)
    Boolean (``yes`` or ``no``).  If the file already exist, it will be
    overwritten.

``group`` (optional, default: not set)
    String.  File group.  It is passed to ``chgrp``.

``mode`` (optional, default: not set)
    String.  File mode.  Any string that ``chmod`` accepts is valid.
    Internally, ``chmod`` is called with the ``-h`` flag so if ``file`` is a
    symlink, the link mode is changed, not the target file.

``owner`` (optional, default: not set)
    String.  File owner.  It is passed to ``chown``.

``path`` (required)
    String. The path for the file.

