#!/usr/bin/env bash

    # Get filename and extension
FILENAME="$1";
EXTENSION="${FILENAME##*.}";

if [ "$EXTENSION" != "epub" ]; then
    echo "File is not an epub";
    exit;
fi

    # Create original copy
BASENAME="${FILENAME%.*}";
cp "$1" "$BASENAME-original.epub";

    # Copy and extract epub file in a tmp directory
TMPDIR="$(mktemp -d)";
cp "$1" "$TMPDIR/file.epub";
mkdir $TMPDIR/epubfiles;
unzip $TMPDIR/file.epub -d $TMPDIR/epubfiles >> /dev/null;

SRCDIR="$(pwd)"
cd $TMPDIR/epubfiles;

    # Contrast up the individual images
for FILE in $(find -name '*.jpg' -or -name '*.jpeg' -or -name '*.png'); do
    echo $FILE;
    IMGEXTENSION="${FILE##*.}";
    LOWERCASEEXT="$(echo $IMGEXTENSION | tr '[:upper:]' '[:lower:]')";
    mogrify -format $LOWERCASEEXT -brightness-contrast 0x50 $FILE;
done

    # Change directory so zip file keeps correct directory structure
zip -r ../newepub.epub . >> /dev/null;
cd $SRCDIR;
cp $TMPDIR/newepub.epub "$1";

    # Clean up
rm -r "$TMPDIR";
echo "Done!"
