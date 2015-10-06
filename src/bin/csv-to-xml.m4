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

#HELP:COMMAND_NAME: convert a CSV file into an XML document
#HELP:Usage: COMMAND_NAME --input-file=$in.csv (--output-file=$out.csv)?

set -o nounset -o errexit -o pipefail

root_dir=$(dirname "$0")/..
. "$root_dir"/share/wrtools-core/opt_help.bash
. "$root_dir"/share/wrtools-core/opt_verbose.bash
. "$root_dir"/share/wrtools-core/fail.bash
. "$root_dir"/share/wrtools-core/temp.bash

#HELP:Options:
#HELP:  --help | -h: Print this help
#HELP:  --keep-temps | -k: Don't delete temporary files
#HELP:  --verbose, -v: Print additional diagnostics

#HELP: --input-file=$input.csv | -i $input.csv: Read from source CSV file
unset input_file
opt_input_file () {
    (( $# == 1 )) || fail_assert "$FUNCNAME: need 1 arg (got $#)"
    [[ is-set != ${input_file+is-set} ]] || fail "option --input-file can only be called once"
    [[ -f $1 ]] || fail "arg to --input-file must be a file ($1)"
    [[ -r $1 ]] || fail "arg to --input-file must be readable ($1)"
    input_file=$1
}

#HELP: --output-file=$output.csv | -o $output.csv: Write to destination XML file
#HELP:      Default is to output to stdout
unset output_file
opt_output_file () {
    (( $# == 1 )) || fail_assert "$FUNCNAME: need 1 arg (got $#)"
    [[ is-set != ${input_file+is-set} ]] || fail "option --output-file can only be called once"
    output_file=$1
}

OPTIND=1
while getopts :hi:ko:v-: option
do case "$option" in
       h ) opt_help;;
       i ) opt_input_file "$OPTARG";;
       k ) opt_keep_temps;;
       o ) opt_output_file "$OPTARG";;
       v ) opt_verbose;;
       - ) case "$OPTARG" in
               help ) opt_help;;
               input-file=* ) opt_input_file "${OPTARG#*=}";;
               keep-temps ) opt_keep_temps;;
               output-file=* ) opt_output_file "${OPTARG#*=}";;
               verbose ) opt_verbose;;
               input-file | output-file ) fail "Long option \"$OPTARG\" requires argument";;
               help=* \
                 | keep-temps=* \
                 | verbose=* ) fail "Long option \"${OPTARG%%=*}\" has unexpected argument";;
               * ) fail "Unknown long option \"${OPTARG%%=*}\"";;
            esac;;
        '?' ) fail "Unknown short option \"$OPTARG\"";;
        : ) fail "Short option \"$OPTARG\" missing argument";;
        * ) fail_assert "Bad state in getopts (OPTARG=\"$OPTARG\")";;
   esac
done
shift $((OPTIND-1))

(( $# == 0 )) || fail "expected no args (got $#)"

[[ is-set = ${input_file+is-set} ]] || fail "option --input-file=$in.csv is required"

if [[ is-set = ${output_file+is-set} ]]
then exec 4>"$output_file"
else exec 4>&1
fi

awk_bin=$(type -p gawk) || awk_bin=$(type -p awk) || fail "Can't find program \"gawk\" or \"awk\""

csv_to_xml_awk="$root_dir"/'M_SHARE_DIR_REL'/csv-to-xml.awk
[[ -f $csv_to_xml_awk ]] || fail "Can't find awk script \"$csv_to_xml_awk\""

file_type=$(file --brief "$input_file")
case $file_type in
    "ASCII text, with CR line terminators" )
        exec 3< <(tr $'\r' $'\n' < "$input_file");;
    "ASCII text, with CRLF line terminators" )
        exec 3< <(sed -e 's/'$'\r''$//' < "$input_file");;
    "ASCII text" )
        exec 3< "$input_file";;
    * )
        fail "Unknown input file type ($file_type)";;
esac

"$awk_bin" -f "$csv_to_xml_awk" <&3 >&4
