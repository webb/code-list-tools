#!/usr/bin/env bash

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

#HELP:COMMAND_NAME: convert a CSV file into a Genericode XML document
#HELP:Usage: COMMAND_NAME (--output-file=$out.xml)? $codes.csv $genericode-header.xml

set -o nounset -o errexit -o pipefail

root_dir=$(dirname "$0")/..
. "$root_dir"/share/wrtools-core/opt_help.bash
. "$root_dir"/share/wrtools-core/opt_verbose.bash
. "$root_dir"/share/wrtools-core/fail.bash
. "$root_dir"/share/wrtools-core/paranoia.bash
. "$root_dir"/share/wrtools-core/temp.bash

share_dir=$root_dir/'M_SHARE_DIR_REL'

#HELP:Options:
#HELP:  --help | -h: Print this help
#HELP:  --verbose, -v: Print additional diagnostics
#HELP:  --not-paranoid: Omit basic/foundational validations

#HELP:  --output-file=$output.csv | -o $output.csv: Write to destination XML file
#HELP:      Default is to output to stdout
unset output_file
opt_output_file () {
    (( $# == 1 )) || fail_assert "$FUNCNAME: need 1 arg (got $#)"
    output_file=$1
}

OPTIND=1
while getopts :ho:v-: option
do case "$option" in
       h ) opt_help;;
       o ) opt_output_file "$OPTARG";;
       v ) opt_verbose;;
       - ) case "$OPTARG" in
               help ) opt_help;;
               not-paranoid ) opt_not_paranoid;;
               output-file=* ) opt_output_file "${OPTARG#*=}";;
               verbose ) opt_verbose;;
               output-file ) fail "Long option \"$OPTARG\" requires argument";;
               help=* \
                 | not-paranoid=* \
                 | verbose=* ) fail "Long option \"${OPTARG%%=*}\" has unexpected argument";;
               * ) fail "Unknown long option \"${OPTARG%%=*}\"";;
            esac;;
        '?' ) fail "Unknown short option \"$OPTARG\"";;
        : ) fail "Short option \"$OPTARG\" missing argument";;
        * ) fail_assert "Bad state in getopts (OPTARG=\"$OPTARG\")";;
   esac
done
shift $((OPTIND-1))

vecho "output_file is $output_file"

(( $# == 2 )) || fail "expected 2 arguments (got $#)"
codes_file=$1
header_file=$2

vecho "codes file is $codes_file"
vecho "header file is $header_file"

! is_paranoid || [[ -f $codes_file && -r $codes_file ]] || fail "codes file must be a readable file: $codes_file"

! is_paranoid || [[ -f $header_file && -r $header_file ]] || fail "header file must be a readable file: $header_file"

temp_make_file table_file

csv-to-xml --output-file="$table_file" "$codes_file"

command=(saxon --in="$header_file" --xsl="$share_dir"/csv-to-gc.xsl)
if [[ is-set = ${output_file+is-set} ]]
then command+=(--out="$output_file")
fi
command+=(-- +code-list="$table_file")

vrun "${command[@]}"

! is_paranoid || [[ is-set != ${output_file+is-set} ]] || check-genericode "$output_file"
