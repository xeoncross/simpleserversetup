#!/bin/bash

# Debian (therefore ubuntu) stopped packaging ffmpeg sometime after the libav fork.
# However, future debian will be adding ffmpeg back in because it's moving faster than libav.
# In the mean time, https://launchpad.net/~jon-severinsson/+archive/ubuntu/ffmpeg
apt-add-repository ppa:jon-severinsson/ffmpeg --yes

# Reload the sources
apt-get update

# And finally, install it
apt-get -qq --assume-yes install ffmpeg > /dev/null


#######################
# Sample commands:
#
# MP3 to AAC
# ffmpeg -i input.mp3 -strict -2 -acodec aac output.aac
#
# Flash to H.264/AAC (for HTML5 video)
# ffmpeg -i flash.flv -vcodec mpeg4 -strict -2 -acodec aac output.mp4
#
# Both need "-strict -2" because AAC is an "experimental" codec