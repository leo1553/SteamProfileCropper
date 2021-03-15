@ECHO OFF
SETLOCAL EnableDelayedExpansion

:: -------------------------------------------------------------------
:: crop-background.bat
:: Crops images for a steam background.
:: Please configure inputs before executing.
:: Reference:
::   https://steamcommunity.com/sharedfiles/filedetails/?id=2142202319
:: -------------------------------------------------------------------

:: -------------------------
:: Input and output settings
:: -------------------------
:: background → path to the background file without extension
SET "background={0}"
:: source → extension of the background file
SET "source={1}"
:: output_directory → directory to the generated files
SET "output_directory={2}"
:: target → extension of the output file
SET "target={3}"
:: keep_temp → whether or not to keep temporary files
SET "keep_temp={4}"

:: -------------
:: Crop settings
:: -------------
:: to_be_cropped → parts to be cropped, sepatared by space
SET "to_be_cropped=avatar main side full main_small side_small"
:: {part}_position_x → crop position x
:: {part}_position_y → crop position y
:: {part}_size_x → crop witdh
:: {part}_size_y → crop height
:: ~ Avatar settings
SET "avatar_position_x=500"
SET "avatar_position_y=32"
SET "avatar_size_x=184"
SET "avatar_size_y=184"
:: ~ Main settings
SET "main_position_x=494"
SET "main_position_y=256"
SET "main_size_x=506"
SET "main_size_y=808"
:: ~ Side settings
SET "side_position_x=1010"
SET "side_position_y=256"
SET "side_size_x=100"
SET "side_size_y=808"
:: ~ Full settings
SET "full_position_x=494"
SET "full_position_y=256"
SET "full_size_x=630"
SET "full_size_y=824"
:: ~ Main Small settings
SET "main_small_position_x=%main_position_x%"
SET "main_small_position_y=%main_position_y%"
SET "main_small_size_x=%main_size_x%"
SET "main_small_size_y=382"
:: ~ Side Small settings
SET "side_small_position_x=%side_position_x%"
SET "side_small_position_y=%side_position_y%"
SET "side_small_size_x=%side_size_x%"
SET "side_small_size_y=382"

:: --------------
:: Other settings
:: --------------
SET "image_extensions=.jpg .png"
SET "is_image=0"
SET "video_extensions=.mp4 .webm .webp"
SET "is_video=1"
SET "gif_extensions=.gif"
SET "is_gif=2"

:: ----
:: Crop
:: ----
FOR %%a IN (%to_be_cropped%) DO (
    CALL :Crop "%background%" "%source%" "%output_directory%%%a" "%target%" "%%a"
)
EXIT /B 0

:: ----------------------
:: Crop function
::   Crops and convert an image or video
:: Params
::   %~1 Source file
::   %~2 Source extension
::   %~3 Output file
::   %~4 Output extension
::   %~5 Part name
:: ----------------------
:Crop
CALL :JustCrop "%~1" "%~2" "%~3" "%~2" "%~5"
IF "%~2" Neq "%~4" (
    CALL :GetType "%~4" "_output_extension"
    IF "!_output_extension!"=="%is_image%" (
            CALL :ConvertImage "%~1" "%~2" "%~3" "%~4" "%~5"
    ) ELSE (
        IF "!_output_extension!"=="%is_video%" (
            CALL :ConvertVideo "%~1" "%~2" "%~3" "%~4" "%~5"
        ) ELSE (
            IF "!_output_extension!"=="%is_gif%" (
                CALL :ConvertGif "%~1" "%~2" "%~3" "%~4" "%~5"
            )
        )
    )
    IF "%keep_temp%" Neq "1" (
        IF EXIST "%~3%~2" (
            DEL "%~3%~2"
        )
    )
)
EXIT /B 0

:: ----------------------
:: JustCrop function
::   Crop a video or image
:: Params
::   %~1 Source file
::   %~2 Source extension
::   %~3 Output file
::   %~4 Output extension
::   %~5 Part name
:: ----------------------
:JustCrop
START /WAIT /B ffmpeg -i "%~1%~2" -filter:v "crop=!%~5_size_x!:!%~5_size_y!:!%~5_position_x!:!%~5_position_y!" -lossless 1 -y "%~3%~4"
EXIT /B 0

:: ----------------------
:: ConvertVideo function
::   Converts a video or image to a video format
:: Params
::   %~1 Source file
::   %~2 Source extension
::   %~3 Output file
::   %~4 Output extension
::   %~5 Part name
:: ----------------------
:ConvertVideo
START /WAIT /B ffmpeg -i "%~3%~2" -crf 16 -c:v libx264 -y "%~3%~4"
EXIT /B 0

:: ----------------------
:: ConvertImage function
::   Converts a video or image to an image format
:: Params
::   %~1 Source file
::   %~2 Source extension
::   %~3 Output file
::   %~4 Output extension
::   %~5 Part name
:: ----------------------
:ConvertImage
START /WAIT /B ffmpeg -i "%~3%~2" -frames:v 1 -lossless 1 -y "%~3%~4"
EXIT /B 0

:: ----------------------
:: ConvertGif function
::   Converts a video or image to gif format
:: Params
::   %~1 Source file
::   %~2 Source extension
::   %~3 Output file
::   %~4 Output extension
::   %~5 Part name
:: ----------------------
:ConvertGif
START /WAIT /B ffmpeg -i "%~3%~2" -vf palettegen -y "%~3_palette.png"
START /WAIT /B ffmpeg -i "%~3%~2" -i "%~3_palette.png" -filter_complex paletteuse -r 30000/1001 -y "%~3%~4"
IF "%keep_temp%" Neq "1" (
    IF EXIST "%~3_palette.png" (
        DEL "%~3_palette.png"
    )
)
EXIT /B 0

:: ----------------------
:: GetType function
::   Gets the extension type
::   Returns 0 for image, 1 for video, 2 for gif or -1 for unknown
:: Params
::   %~1 Extension
::   %~2 Output
:: ----------------------
:GetType
CALL :IsType "%~1" "%image_extensions%"
IF "%ERRORLEVEL%"=="1" (
    SET "%~2=%is_image%"
    EXIT /B 0
)
CALL :IsType "%~1" "%video_extensions%"
IF "%ERRORLEVEL%"=="1" (
    SET "%~2=%is_video%"
    EXIT /B 0
)
CALL :IsType "%~1" "%gif_extensions%"
IF "%ERRORLEVEL%"=="1" (
    SET "%~2=%is_gif%"
    EXIT /B 0
)
SET "%~2=-1"
EXIT /B -1

:: ----------------------
:: IsType function
::   Checkes if extension is in the specified list
::   Exits 1 if true, 0 if false.
:: Params
::   %~1 Extension
::   %~2 List
:: ----------------------
:IsType
FOR %%a IN (%~2) DO (
    IF "%%a"=="%~1" (
        EXIT /B 1
    )
)
EXIT /B 0
