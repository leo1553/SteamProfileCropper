# SteamProfileCropper

A simple and reconfigurable batch script to crop steam profile backgrounds as [Steam Design](https://steam.design/) does.

## Getting started

[FFmpeg](https://www.ffmpeg.org/) is responsible to crop video and images. It must be present in the system's PATH or in the same folder as the batch script.

#### Setting up

For the script to work, it is necessary to set your needs in its variables. Open `crop-background.bat` with a text editor, find and edit the following lines:
- `SET "background={0}"`: Replace `{0}` with the path to your background file **without extension**.
- `SET "source={1}"`: Replace `{1}` with the extension of your background file.
- `SET "output_directory={2}"`: Replace `{2}` with the path to your output files, the recommended value is `output\`.
- `SET "target={3}"`: Replace `{3}` with your desired output extension.
- `SET "keep_temp={4}"` Replace `{4}` with `0` if you do not intend to keep temporary files, otherwise `1`, the recommended value is `0`.

Save and execute.

###### Example
Crop the .mp4 background found at `C:\Crop\background.mp4` as `.gif` files:
```batch
SET "background=`C:\Crop\background"
SET "source=.mp4"
SET "output_directory=output\"
SET "target=.gif"
SET "keep_temp=0"
```

#### Specifying crops

It is possible to specify the crop positions and lengths. Open `crop-background.bat` with a text editor, find and edit the following lines:
- `SET "to_be_cropped={0}"`: Replace `{0}` with the desired crop names to be cropped, **separated by space**.

**Default crops:** avatar, main, side, full, main_small, side_small.

Save before executing.

##### Creating new crops:

It is possible to specify new crop positions and lengths. Open `crop-background.bat` with a text editor, add new lines after the line `SET "to_be_cropped...` as follows:
- `SET "{0}_position_x={1}"`: Replace `{0}` with your crop name, replace `{1}` with the x position of your crop.
- `SET "{0}_position_y={2}"`: Replace `{0}` with your crop name, replace `{2}` with the y position of your crop.
- `SET "{0}_size_x={3}"`: Replace `{0}` with your crop name, replace `{3}` with the width of your crop.
- `SET "{0}_size_y={4}"`: Replace `{0}` with your crop name, replace `{4}` with the height of your crop.

Remember to add your crop name at the `to_be_cropped` list as shown at *Specifying crops*.

Save before executing.

###### Example
The main crop is defined as follows:
```batch
SET "main_position_x=494"
SET "main_position_y=256"
SET "main_size_x=506"
SET "main_size_y=808"
```

## References 

[How to crop Animated Profile Backgrounds for Artworks](https://steamcommunity.com/sharedfiles/filedetails/?id=2142202319)

[How to Upload Long Images for Showcases [Featured works]](https://steamcommunity.com/sharedfiles/filedetails/?id=748624905)

## Thanks

A special thanks to @DanGM96 for providing the references.
