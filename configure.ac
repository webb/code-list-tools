# -*-autoconf-*-
# Process this file with autoconf to produce a configure script.

# Copyright 2015 Georgia Tech Research Corporation (GTRC). All rights reserved.

# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.

# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.

# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.

AC_PREREQ([2.69])
AC_INIT([code-list-tools], [0.1], [wr@gatech.edu])
AC_COPYRIGHT

# Checks for programs.
AC_PROG_INSTALL
AC_PROG_MKDIR_P
AC_PROG_SED
AC_PROG_AWK

dnl WR_check_prog( $command-name )
dnl   e.g., WR_check_prog(bash) will set @bash@
AC_DEFUN([WR_check_prog],[AC_PATH_PROG($1,$1)
  test "x$[]$1" = "x" && AC_MSG_ERROR([$1 not found])])dnl

dnl WR_check_prog_options( $command-short-name, $command-name-options ... )
dnl   e.g., WR_check_prog_options(cat, gcat cat) will set @cat@
AC_DEFUN([WR_check_prog_options],[AC_PATH_PROGS($1,$2)
  test "x$[]$1" = "x" && AC_MSG_ERROR([$1 not found])])dnl

WR_check_prog(bash)
WR_check_prog(m4)
WR_check_prog(saxon)
WR_check_prog(schematron)
WR_check_prog(touch)
WR_check_prog(xmllint)
WR_check_prog(xsdvalid)

AC_PATH_PROG(check_simple_xsd,check-simple-xsd)

AC_PATH_PROGS(stow,stow,stow)

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_CONFIG_FILES([Makefile], [chmod 444 Makefile])
AC_CONFIG_FILES([stow.mk], [chmod 444 stow.mk])
AC_OUTPUT
