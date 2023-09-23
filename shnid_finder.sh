#!/usr/bin/env bash

# shellcheck disable=SC1001
set -euo pipefail

# requirements:
# macOS     - use Homebrew (https://brew.sh)
# metaflac  - brew install flac
# wget      = brew install wget
# grep, tail, sed, awk are probably already available, but can also be
# installed with `brew install grep tail sed awk`
# 
# This script can be run on a single specific file, or in the root of many 
# directories containing FLAC files.
# 
# $ `shnid_finder.sh somefile.flac` search etreedb.org for a matching shn ID#
# and download the zip for any / all matches
# 
# $ `shnid_finder.sh` in a folder with many subdirectories will use the first 
# FLAC file in each folder for the search and download the zip to each directory

if [ $# -eq 0 ]
  then
    for dir in *; do
      files=("$dir"/*.flac)
      track=${files[0]}
      # read fingerprint from flac file header
      fingerprint=$(metaflac --show-md5sum "$track")
      # search etreedb.org for fingerprint string, print SHN ID to stdout
      shnid=$(wget -qO- https://etreedb.org/md5_lookup.php\?md5\="$fingerprint" | grep -A 1 '<td>Source #</td>' | tail -n 1 | sed -e 's/\(<[^<][^<]*>\)//g' | awk '{print $1}')
      # grab unique portion of URL for shn ID
      result=$(wget -qO- https://etreedb.org/md5_lookup.php\?md5\="$fingerprint"  | grep -oE "\/shn_downloadzip\.php\?shnid\=[0-9]+")
      # print relatively unimportant info to stdout
        echo file: "$track"
        echo fingerprint: "$fingerprint"
        echo shnid: "$shnid"
        echo result: "$result"
      for link in $result; do
        # assemble URL for each .zip and download them here
        wget --content-disposition --trust-server-names https://etreedb.org"$link" -P "$dir"
      done
    done
  else
    # read fingerprint from flac file header
    fingerprint=$(metaflac --show-md5sum "$1")
    # search etreedb.org for fingerprint string, print SHN ID to stdout
    shnid=$(wget -qO- https://etreedb.org/md5_lookup.php\?md5\="$fingerprint" | grep -A 1 '<td>Source #</td>' | tail -n 1 | sed -e 's/\(<[^<][^<]*>\)//g' | awk '{print $1}')
    # grab unique portion of URL for shn ID
    result=$(wget -qO- https://etreedb.org/md5_lookup.php\?md5\="$fingerprint"  | grep -oE "\/shn_downloadzip\.php\?shnid\=[0-9]+")
    # print relatively unimportant info to stdout
      echo file: "$1"
      echo fingerprint: "$fingerprint"
      echo shnid: "$shnid"
      echo result: "$result"
    for link in $result; do
      # assemble URL for each .zip and download them here
      wget --content-disposition --trust-server-names https://etreedb.org"$link" -P "$dir"
    done
  fi

