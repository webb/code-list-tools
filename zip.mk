
SHELL = /bin/bash

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

describe := ${shell git describe --tags 2> /dev/null}
ifeq (${describe},)
dist_name = code-list-tools-LATEST
else
dist_name = code-list-tools-${describe}
endif

.SECONDARY:

zip_dir = tmp/zip
root_dir = ${zip_dir}/${dist_name}
override root_dir_abs = ${shell mkdir -p ${root_dir} && cd ${root_dir} && pwd}
repos_dir= ${zip_dir}/repos
tokens_dir = ${zip_dir}/token

# stages are:
# * sync
# * configure
# * make
# * install = make install

packages = self wrtools_core saxon_cli xalan_cli schematron_cli 

wrtools_core_repo = https://github.com/webb/wrtools-core.git
saxon_cli_repo    = https://github.com/webb/saxon-cli.git
xalan_cli_repo    = https://github.com/webb/xalan-cli.git
schematron_cli_repo    = https://github.com/webb/schematron-cli.git

.PHONY: all
all: ${packages:%=${tokens_dir}/make/%}

.PHONY: install
install: ${packages:%=${tokens_dir}/install/%}

.PHONY: sync
sync: ${packages:%=${tokens_dir}/sync/%}

.PHONY: resync
resync:
	${RM} -r ${tokens_dir}/sync
	${MAKE} -f unconfigured.mk sync

.PHONY: clean
clean:
	${RM} -r ${zip_dir}

.PHONY: zip
zip: ${packages:%=${tokens_dir}/install/%}
	${RM} ${zip_dir}/${dist_name}.zip
	cd ${zip_dir} && zip -9r ${dist_name}.zip ${dist_name}

#############################################################################
# self

${tokens_dir}/sync/self:
	mkdir -p ${repos_dir}/self
	tar cf - $$(git ls-files) | ( cd ${repos_dir}/self && tar xf -)
	mkdir -p ${dir $@} && touch $@

#############################################################################
# defaults

${tokens_dir}/sync/%:
	if [[ -d ${repos_dir}/$* ]]; \
	then cd ${repos_dir}/$* && git pull; \
	else mkdir -p ${repos_dir} \
	     && cd ${repos_dir} \
	     && git clone ${$*_repo} $*; \
	fi
	mkdir -p ${dir $@} && touch $@

${tokens_dir}/configure/%: ${tokens_dir}/sync/%
	cd ${repos_dir}/$* && ./configure --prefix=${root_dir_abs}
	mkdir -p ${dir $@} && touch $@

${tokens_dir}/make/%: ${tokens_dir}/configure/%
	make -C ${repos_dir}/$*
	mkdir -p ${dir $@} && touch $@

${tokens_dir}/install/%: ${tokens_dir}/make/%
	make -C ${repos_dir}/$* install
	mkdir -p ${dir $@} && touch $@


