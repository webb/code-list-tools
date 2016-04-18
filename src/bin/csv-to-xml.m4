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
#HELP:Usage: COMMAND_NAME (--output-file=$out.xml)? $in.csv

set -o nounset -o errexit -o pipefail

root_dir=$(dirname "$0")/..
. "$root_dir"/share/wrtools-core/opt_help.bash
. "$root_dir"/share/wrtools-core/opt_verbose.bash
. "$root_dir"/share/wrtools-core/fail.bash
. "$root_dir"/share/wrtools-core/paranoia.bash

share_dir=$root_dir/'M_SHARE_DIR_REL'

#HELP:Options:
#HELP:  --help | -h: Print this help
#HELP:  --verbose, -v: Print additional diagnostics
#HELP:  --not-paranoid: Omit basic/foundational validations

#HELP: --output-file=$output.csv | -o $output.csv: Write to destination XML file
#HELP:      Default is to output to stdout
output_file=/dev/fd/1
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

(( $# == 1 )) || fail "expected 1 argument (got $#)"
input_file=$1
vecho "input_file is $input_file"
! is_paranoid || [[ -f $input_file && -r $input_file ]] || fail "file must be a readable file: $1"

file_type=$(file --brief "$input_file")
vecho "file type is $file_type"

case $file_type in
    'ASCII text' \
      | 'ASCII English text, with very long lines' \
      | 'ASCII English text' \
      | 'ASCII text, with very long lines' )
        true ;;
    'ASCII text, with CR line terminators' \
      | 'ASCII English text, with very long lines, with CR line terminators' \
      | 'ASCII text, with very long lines, with CR line terminators' )
        exec 3< <(tr $'\r' $'\n' < "$input_file")
        input_file=/dev/fd/3;;
    'ASCII text, with CRLF line terminators' )
        exec 3< <(sed -e 's/'$'\r''$//' < "$input_file")
        input_file=/dev/fd/3;;
    'ISO-8859 English text, with CR line terminators' \
      | 'ISO-8859 text, with CR line terminators' )
        exec 3< <(tr $'\r' $'\n' < "$input_file" \
                  | iconv -f iso-8859-1 -t ascii --unicode-subst='-unicode-value-%u-')
        input_file=/dev/fd/3;;
    'ISO-8859 English text' )
        exec 3< <(iconv -f iso-8859-1 -t ascii --unicode-subst='-unicode-value-%u-' "$input_file")
        input_file=/dev/fd/3;;
    'ISO-8859 English text, with CRLF line terminators' )
        exec 3< <(tr -d $'\r' < "$input_file" \
                       | iconv -f iso-8859-1 -t ascii --unicode-subst='-unicode-value-%u-')
        input_file=/dev/fd/3;;
        
    # Put additional conversions here!
    # Maybe use iconv
    * )
        fail "Unknown type for input file (file is $input_file; type is $file_type)";;
esac

! is_paranoid || type -p awk > /dev/null || fail "Can't find program (awk)"

csv_to_xml_awk=$share_dir/csv-to-xml.awk
! is_paranoid || [[ -f $csv_to_xml_awk ]] || fail "Can't find awk script ($csv_to_xml_awk)"

awk -f "$csv_to_xml_awk" "$input_file" > "$output_file"

if is_paranoid
then stat=$(stat -c%F "$output_file")
     case $stat in
         "fifo" ) vecho "skipping xml schema validation on output for file type $stat";;
         * ) xs-validate --catalog="$share_dir"/xml-catalog.xml "$output_file";;
     esac
fi
