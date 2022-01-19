mcm - idempotent shell script generator for configuration management
====================================================================

mcm is a shell script generator that generates idempotent scripts to be used
for configuration management.

mcm and its modules are written in ``/bin/sh`` and use common Unix tools, so
it doesn't require anything special neither on the host nor on the target
side.

For reference, the URL https://purl.org/net/mcm will always point to the mcm
webpage or repository.  Use it if you want to cite mcm.

Example
-------

Documentation
-------------

Modules
-------

Currently supported modules follows.  All modules work in all `supported
operating systems`_, unless stated.

* execute_ - execute a command or shell script
* file_ - create regular files
* line_ - add a line to a file

.. _execute: modules/execute/execute.rst
.. _file: modules/file/file.rst
.. _line: modules/line/line.rst

Project Goals
-------------

* Provide a configuration manager that follow the `KISS principle`_.  It
  should be be as simple as possible.  We favour simplicity over features.

* Trust completely in `POSIX Bourne Shell`_ (the only non-POSIX feature we use
  are the ``local`` keyword for local variables).

* Favour `POSIX utilities`_ over non-standardized tools and extensions.

* mcm can be run as a normal user, so it is possible to use mcm for ``$HOME``
  configuration or something that don't require root privileges.

What mcm doesn't do
-------------------

* mcm default modules doesn't perform any kind of "negative deployment", like
  making sure a file or a user does not exist (this decision made the logic
  much simpler).  If you need something specific, you are encouraged to
  `develop your own module`_ or use the execute_ module.

* mcm generated script doesn't perform any kind of terminal handling (this
  means that it is impossible to pass password to utilities like su or sudo).

* mcm cannot embed binary files to the generated script because of some shell
  limitations that cannot contain the null byte on strings.  The user is
  recommended to build wrappers around mcm to overcome this and other
  limitations.

Supported operating systems
---------------------------

mcm should virtually run in any Unix-like operating system.  But mcm and all
its official modules are fully tested on the following shell and operating
systems:

.. csv-table::
    :header: "Host OS", "Target OS", /bin/sh, bash, dash

    NetBSD_ 9, NetBSD 9, OK, OK, OK
    NetBSD_ 9, `CentOS GNU/Linux`_ 7, OK, OK, OK

* NetBSD_ 8 and 9 (with NetBSD /bin/sh)
* `CentOS GNU/Linux`_ (with /bin/sh)

Documentation
-------------

.. _mcm: https://purl.org/net/mcm

.. _KISS principle: https://en.wikipedia.org/wiki/KISS_principle
.. _POSIX Bourne Shell: http://pubs.opengroup.org/onlinepubs/9699919799/
.. _POSIX utilities: http://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html

.. _develop your own module: TODO
.. _execute: TODO

.. _NetBSD: http://www.netbsd.org/
.. _CentOS GNU/Linux: TODO
