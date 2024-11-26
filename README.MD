# Step 0

## Make sure `moshy`, `aviglitch` and `ffmpeg` are installed

# Step 1

## Convert to .avi

`ffmpeg -i input.mp4 -vcodec libxvid -qscale 1 -g 100 -me_method epzs -bf 0 -mbd 0 -aspect 16:9 -acodec copy output.avi`

## Run datamosh

`datamosh input.avi -o output.avi`

## Run moshy

`moshy -m bake -i input.avi -o output.avi`

## Convert back to .mp4

`ffmpeg -i input.avi -strict -2 output.mp4`

## Zsh Script

```zsh
#!/bin/zsh

# Step 0: Make sure `moshy`, `aviglitch` and `ffmpeg` are installed
if ! command -v moshy &> /dev/null || ! command -v aviglitch &> /dev/null || ! command -v ffmpeg &> /dev/null
then
	echo "Please make sure 'moshy', 'aviglitch', and 'ffmpeg' are installed."
	exit 1
fi

# Step 1: Convert to .avi
ffmpeg -i input.mp4 -vcodec libxvid -qscale 1 -g 100 -me_method epzs -bf 0 -mbd 0 -aspect 16:9 -acodec copy output.avi

# Step 2: Run datamosh
datamosh output.avi -o datamoshed.avi

# Step 3: Run moshy
moshy -m bake -i input.avi -o output.avi

# Step 4: Convert back to .mp4
ffmpeg -i input.avi -strict -2 output.mp4
```
