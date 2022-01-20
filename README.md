# mcm - idempotent shell script generator for configuration management

mcm is a shell script generator that generates idempotent scripts to be used
for configuration management.

mcm and its modules are written in `/bin/sh` and use common Unix tools, so
it doesn't require anything special neither on the host nor on the target
side.

## Example

TODO

## Documentation

TODO

## Modules

TODO

## Project Goals

* Provide a configuration manager that follow the [KISS principle](https://en.wikipedia.org/wiki/KISS_principle).
It should be be as simple as possible.  We favour simplicity over features.

* Trust completely in [POSIX Bourne Shell](http://pubs.opengroup.org/onlinepubs/9699919799/)
(the only non-POSIX feature we use are the ``local`` keyword for local
variables).

* Favour [POSIX utilities](http://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html)
over non-standardized tools and extensions.

* mcm can be run as a normal user, so it is possible to use mcm for `$HOME`
  configuration or something that don't require root privileges.

### What mcm doesn't do

* mcm default modules doesn't perform any kind of "negative deployment", like
  making sure a file or a user does not exist (this decision made the logic
  much simpler).  If you need something specific, you are encouraged to
  develop your own module or use the `execute` module.

* mcm generated script doesn't perform any kind of terminal handling (this
  means that it is impossible to pass password to utilities like su or sudo).

* mcm cannot embed binary files to the generated script because of some shell
  limitations that cannot contain the null byte on strings.  The user is
  recommended to build wrappers around mcm to overcome this and other
  limitations.

## Supported operating systems

TODO
