#!/usr/bin/env bash

# https://git.jonathanh.co.uk/jab2870/Dotfiles/src/branch/master/bin/.bin/emails/convert-multipart#
# https://github.com/anufrievroman/Neomutt-File-Picker/blob/master/filepicker
# https://github.com/neomutt/neomutt/issues/3229
# https://unix.stackexchange.com/questions/612134/neomutt-run-command-to-attach-file-on-macro-key-press/612194#612194

# NOTE: Has to be the same as in neomutt config:
TMPDIR="$HOME/.cache/neomutt-custom/convert_multipart" 
mkdir -p "$TMPDIR"

COMMANDS_FILE="$TMPDIR/neomutt-commands"
MARKDOWN_FILE="$TMPDIR/neomutt-markdown"
HTML_FILE="$TMPDIR/neomutt.html"

cat - > "${MARKDOWN_FILE}.orig"
echo -n "push " > "$COMMANDS_FILE"

cp "${MARKDOWN_FILE}.orig" "$MARKDOWN_FILE"

# Replace each inline image with an unique cid:
grep -Eo '!\[[^]]*\]\([^)]+' "$MARKDOWN_FILE" | cut -d '(' -f 2 |
grep -Ev '^(cid:|https?://)' | while read -r file; do
    extended_file="${file/#\~/$HOME}"  # To allow ~ in file name
    id="cid:$(md5sum "$extended_file" | cut -d ' ' -f 1 )"
    sed -i "s#$file#$id#g" "$MARKDOWN_FILE"
done
# Detach the old markdown file as the names have changed and attach the new one:
if [ "$(grep -Eo '!\[[^]]*\]\([^)]+' "$MARKDOWN_FILE" | cut -d '(' -f 2  | grep -c '^cid:')" -gt 0 ]; then
    echo -n "<attach-file>\"$MARKDOWN_FILE\"<enter><toggle-disposition><toggle-unlink><first-entry><detach-file>" >> "$COMMANDS_FILE"
fi

# Generate the HTML:
pandoc -f markdown -t html5 --standalone --template ~/.config/neomutt/multipart.html "$MARKDOWN_FILE" > "$HTML_FILE"

{
    # Attach the html file
    echo -n "<attach-file>\"$HTML_FILE\"<enter>"
    # Set it as inline
    echo -n "<toggle-disposition>"
    # Tell neomutt to delete it after sending
    echo -n "<toggle-unlink>"
    # Select both the html and markdown files
    echo -n "<tag-entry><previous-entry><tag-entry>"
    # Group the selected messages as alternatives
    echo -n "<group-alternatives>"
} >> "$COMMANDS_FILE"

# Attach the inline attachments
grep -Eo '!\[[^]]*\]\([^)]+' "${MARKDOWN_FILE}.orig" | cut -d '(' -f 2 |
grep -Ev '^(cid:|https?://)' | while read -r file; do
    extended_file="${file/#\~/$HOME}"  # To allow ~ in file name
    id="$(md5sum "$extended_file" | cut -d ' ' -f 1 )"
    {
        echo -n "<attach-file>\"$file\"<enter>"
        echo -n "<toggle-disposition>"
        echo -n "<edit-content-id>^u\"$id\"<enter>"
        echo -n "<tag-entry>"
    } >> "$COMMANDS_FILE"
done

# Select the first entry (the multipart alternative we’ve already created), tag it and mark everything tagged as multipart related
if [ "$(grep -Eo '!\[[^]]*\]\([^)]+' "$MARKDOWN_FILE" | cut -d '(' -f 2 | grep -c '^cid:')" -gt 0 ]; then
    echo -n "<first-entry><tag-entry><group-related>" >> "$COMMANDS_FILE"
fi

find "${TMPDIR:?}" -mtime +1 -type f -delete
