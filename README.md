# etree-shnid-finder

Kind of hacky, but a pretty niche use-case. At the moment this only reads `*.flac` but at some point I intend to read `*.md5` files to also support `.shn`

This script can be run on a single specific file, or in the root of many
directories containing FLAC files.

$ `shnid_finder.sh somefile.flac` will read the ffp from that file, search [etreedb.org](https://etreedb.org) and display info like filename, ffp, and shn ID#, and download the zip from [etreedb.org](https://etreedb.org) for that shn ID.

$ `shnid_finder.sh` in a folder like for a specific year or band with a bunch
of subdirectories, the script will enter into each folder, find the first FLAC
file, read its ffp, search [etreedb.org](https://etreedb.org), and download the zip file,
placing it inside each directory next to the FLAC file used for the search.

### Requirements:
not complicated, for macOS - [Homebrew](https://brew.sh) 
- [flac / metaflac](https://xiph.org/flac/documentation_tools_metaflac.html) `brew install flac`
- wget, grep, tail, sed, awk are probably already available, but can also be
installed with `brew install wget grep tail sed awk`

Copy this file to somewhere in your $PATH and make it executable
`chmod +x /path/to/your/shnid_finder.sh` or `chmod 755 /path/to/your/shnid_finder.sh`

By checking just one file from each directory, [etreedb.org](https://etreedb.org) doesn't get hit with ~20 searches for the same shn ID.

The trade-off is the possibility of matching more than one shn ID. In this case, the zip for each matching shn ID will be downloaded.

When no matches are found, just move on to the next directory. There is no logging of errors. If there's no zip in the folder, there was no match found.

It's pretty verbose, prints a lot of text but makes quick work of sorting through hundreds of filesets. One day I'll make it pretty.

```
file: ph2000-06-29.B&K.Vandecar.90593/ph2000-06-29d1t01.flac
fingerprint: be76b5c3bf939423422f2c9c6199b848
shnid: 90593
result: /shn_downloadzip.php?shnid=90593
--2023-08-12 10:57:19--  https://etreedb.org/shn_downloadzip.php?shnid=90593
Resolving etreedb.org (etreedb.org)... 172.67.188.30, 104.21.7.247, 2606:4700:3037::ac43:bc1e, ...
Connecting to etreedb.org (etreedb.org)|172.67.188.30|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [application/octet-stream]
Saving to: ‘ph2000-06-29.B&K.Vandecar.90593/ph2000-06-29.90593.zip’

ph2000-06-29.90593.zip            [ <=>                                              ]   2.53K  --.-KB/s    in 0.006s

2023-08-12 10:57:19 (444 KB/s) - ‘ph2000-06-29.B&K.Vandecar.90593/ph2000-06-29.90593.zip’ saved [2593]
```
