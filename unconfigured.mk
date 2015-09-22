
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

.PHONY: all # create everything that can be generated pre-configure
all: install-sh
	autoreconf --install --verbose

.PHONY: help # print this help
help:
	@ echo Not doing anything. Maybe you wanted one of these targets:
	@ sed -e 's/^.PHONY: *\([^ #]*\) *\# *\(.*\)$$/  \1: \2/p;d' unconfigured.mk

.PHONY: clean # remove everything that can be generated
clean: 
	$(RM) -r .gradle autom4te.cache out tmp
	$(RM) Makefile stow.mk configure
	$(RM) autm4te.cache autoscan.log config.log configure 
	$(RM) config.guess config.sub config.status install-sh ltmain.sh
	$(RM) depcomp missing aclocal.m4 
	find . -type f -name '*~' -delete

install-sh:
	glibtoolize -icf
	$(RM) ltmain.sh config.guess config.sub

