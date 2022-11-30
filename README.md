# Mastodon-Capture-Emoji-Library

# john@mcmahon.engineering
# https://github.com/JohnFuzzFaceMcMahon/Mastodon-Capture-Emoji-Library

A simple routine to capture the Emoji Library from a Mastodon server

Downloads into the current directory.

awk -f GetEmojisFromMastodon.awk Instance-Name

FindDuplicates.awk will run a shasum on all the files in the current directory.
Any exact duplicates will be renamed DUPLICATE.original.file.name.

The Work directory is a selection of emojis downloaded from various servers. 
Exact duplicates have been weeded out.

Post No Bills.
