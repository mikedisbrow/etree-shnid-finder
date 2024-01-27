#!/usr/bin/env bash

# shellcheck disable=SC1001
# set -x

# requirements:
# macOS     - use Homebrew (https://brew.sh)
# wget      - brew install wget
# grep, tail, sed, awk are probably already available, but can also be
# installed with `brew install grep tail sed awk`
#
# This script can be run on a single specific file, or in the root of many
# directories containing FLAC files.

# $ `md5-getter.sh` in a folder with many subdirectories will use the first hash
# for the first file listed in the first *.md5 file in each directory and search
# etreedb.org for a matching shn ID# and download the zip for any / all matches

if [ $# -eq 0 ]
  then
  for dir in *; do
    files=("$dir"/*.md5)
      md5file=${files[0]}
      # echo "$md5file"
      checksum=$( grep -oE "^([A-Za-z0-9]+)" "$md5file" | head -1 )
      # echo "$checksum"
      hash=${checksum[0]}
      # echo "$hash"
      # search etreedb.org for fingerprint string, print SHN ID to stdout
      shnid=$(wget -qO- https://etreedb.org/md5_lookup.php\?md5\="$hash" \
        | grep -A 1 '<td>Source #</td>' | tail -n 1 | sed -e 's/\(<[^<][^<]*>\)//g' \
        | awk '{print $1}')
      if [[ $? -ne 0 ]]; then
        echo "No match in etreedb for md5 $hash"
      else
        # grab unique portion of URL for shn ID
      result=$(wget -qO- https://etreedb.org/md5_lookup.php\?md5\="$hash" \
        | grep -oE "\/shn_downloadzip\.php\?shnid\=[0-9]+")
      # print relatively unimportant info to stdout
        # echo file: "$track"
        echo downloading zip for "$shnid" to "$dir"
        # echo "$dir" matches shnid: "$shnid"
        # echo shnid: "$shnid"
        # echo result: "$result"
      for link in $result; do
        # assemble URL for each .zip and download them here
        wget -q --content-disposition --trust-server-names https://etreedb.org"$link" -P "$dir"
      done
    fi
  done
fi
