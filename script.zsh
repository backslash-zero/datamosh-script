#!/bin/zsh

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
	echo "Usage: $0 <input_file> <output_file>"
	exit 1
fi

INPUT_FILE=$1
OUTPUT_FILE=$2

# Step 0: Make sure `moshy`, `aviglitch` and `ffmpeg` are installed
# if ! command -v moshy &> /dev/null || ! command -v datamosh &> /dev/null || ! command -v ffmpeg &> /dev/null
# then
# 	echo "Please make sure 'moshy', 'aviglitch', and 'ffmpeg' are installed."
# 	exit 1
# fi

# Step 1: Convert to .avi
echo "Converting to .avi..."
if ! ffmpeg -i "$INPUT_FILE" -vcodec libxvid -qscale 1 -g 100 -me_method epzs -bf 0 -mbd 0 -aspect 16:9 -acodec copy output.avi; then
	echo "Error: Failed to convert to .avi"
	exit 1
fi

# Step 2: Run datamosh
echo "Running datamosh..."
if ! datamosh output.avi -o datamoshed.avi; then
	echo "Error: Datamosh failed"
	exit 1
fi

# Step 3: Run moshy
echo "Running moshy..."
if ! moshy -m bake -i datamoshed.avi -o datamoshed-cleaned.avi; then
	echo "Error: Moshy failed"
	exit 1
fi

# Step 4: Convert back to .mp4
echo "Converting back to .mp4..."
if ! ffmpeg -i datamoshed-cleaned.avi -strict -2 "$OUTPUT_FILE"; then
	echo "Error: Failed to convert back to .mp4"
	exit 1
fi

# remove intermediate files
rm output.avi datamoshed.avi datamoshed-cleaned.avi