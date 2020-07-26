#!/bin/sh  
VLC_PORT=8088
VLC_USER=vlc
VLC_IP=10.11.99.1
VLC_PASWD=changeme
find /home/anyfesto/content/Radio -name '*.mp3'>/home/anyfesto/content/playlist.m3u
chmod a+rwx /home/anyfesto/content/playlist.m3u
cvlc -I http --http-password $VLC_PASWD --http-host $VLC_IP --http-port $VLC_PORT --sout-keep --sout='#duplicate{dst=rtp{mux=ts,dst=10.11.99.1:8086},dst=gather:std{access=http,mux=mpeg1,dst=:8085},dst=display,select="novideo"}' -LZ /home/anyfesto/content/playlist.m3u &
