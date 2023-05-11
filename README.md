# mp3voladj
* Use ffmpeg to adjust the volume of mp3 files in EBU_R128 standard.
* (I made this roughly, so I'm sure there will be problems...)

## Tested Environments
* macOS

## Preparation
* Install Docker
* Install jq command
* (Optional) Pull the docker image jrottenberg/ffmpeg (not mandatory as it will be fetched by docker run command)

## Script Overview
* This script uses ffmpeg from the jrottenberg/ffmpeg docker image to encode mp3 files according to the EBU_R128 standard.
* It takes two arguments:
    * Argument 1: Full path of the input mp3 file
    * Argument 2: Full path of the output mp3 file

## Execution Example

```
# [Before] Directory Structure
# /your/target/dir
#               ├input
#               │   ├── sample1.mp3
#               │   ├── sample2.mp3
#               │   └── sample3.mp3
#               └output

# Execute script.
$ INPUT_FILE_NAME='/your/target/dir/input/sample1.mp3'
$ OUTPUT_FILE_NAME='/your/target/dir/output/encoded_sample1.mp3'
$ mp3voladj ${INPUT_FILE_NAME} ${OUTPUT_FILE_NAME}


# [After] Directory Structure
# /your/target/dir
#               ├input
#               │   ├── sample1.mp3
#               │   ├── sample2.mp3
#               │   └── sample3.mp3
#               └output
#                    └── encoded_sample1.mp3
```

## Explanation of ffmpeg Options Used
* loudnorm
    * A filter used to normalize the volume
    * Automatically adjusts the volume using an algorithm based on the EBU R128 standard.
* I
    * Specifies the target average volume
    * -23 is a common target volume.
* LRA
    * Specifies the target volume range
    * 7 is a common value.
* TP
    * Specifies the target peak volume
    * -2.0 is a common value.
* measured_I
    * Specifies the measured average volume
* measured_LRA
    * Specifies the measured volume range
* measured_TP
    * Specifies the measured peak volume
* linear
    * Specifies whether to perform volume normalization in linear mode
    * If set to true, it processes in linear mode, which results in lossless volume conversion.
* print_format
    * Specifies the output format of the result
    * summary: Output in a concise format.

* -codec:a libmp3lame
    * Option to specify the audio codec of the output file
    * In this case, libmp3lame, an MP3 encoder, is specified.
* -q:a 2
    * Option to specify the audio quality
    * 2 is an option to specify the quality of the audio.
        * 2 provides relatively high quality while significantly reducing file size.
    * Can be specified in the range of 0 to 9.
        * 0: Highest quality
        * 9: Lowest quality
