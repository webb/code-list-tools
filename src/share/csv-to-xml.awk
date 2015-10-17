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

BEGIN {
  printf "<?xml version=\"1.0\" encoding=\"US-ASCII\" standalone=\"yes\"?>\n"
  printf "<table xmlns=\"http://wr.gatech.edu/namespace/table/\">\n"
  FPAT = "[^,]*|(\"([^\"]|(\"\"))*\")"
  RS = "\n"
}

{
  printf "<row>\n"
  for (i = 1; i <= NF; i++) {
    if (match($i, /^"(.*)"$/, array))
      $i = array[1]
    gsub(/&/, "\\&amp;", $i)
    gsub(/</, "\\&lt;", $i)
    gsub(/>/, "\\&gt;", $i)
    gsub(/""/, "\\&quot;", $i)
    gsub(/'/, "\\&apos;", $i)
    $i = gensub(/-unicode-value-([0-9]+)-/, "\\&#\\1;", "g", $i)
    printf("  <column>%s</column>\n", $i)
  }
  printf "</row>\n"
}

END {
  printf "</table>\n"
}
