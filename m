From: Andrew Burgess <aab@cichlid.com>
Subject: Re: Poor RAID6 performance on frankenstein server
Date: Sun, 25 Dec 2005 09:23:46 -0800
Message-ID: <200512251723.jBPHNkPl030993@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>I'm not sure if this is a kernel-ide-disk issue or a raid issue, so I'm 
>trying here first:

Its an audio issue :-)

>Works great... except for during heavy disk access my MythTV recordings
>will get somewhat glitchy audio.  Stop the disk access and the audio
>returns to normal.  Even with moderate disk access it's ok.  It's just
>when it's heavy.  And the glitches are usually every few seconds unless
>it's really heavy where the audio gets nearly unintelligible for 10 secs
>or so.

What does the audio do exactly? Popping, crackles, dropouts or...
Does MythTV report XRUNS? Using ALSA or OSS?
Can you increase audio buffer sizes in MythTV?

>Anything else I can try tuning to fix this nagging issue?  Any ideas on 
>what's biting me here?

You can try pci latency. Turn it way up for the audio device, way down for
everything else.

I use this at bootup (edited a bit so I hope I didn't break it :-)

# make default 16
latency=10 # hex
echo set default pci latency to 0x$latency
setpci -d *:* latency_timer=$latency # expects hex

# find multimedia devices
pcis=$(lspci -v | grep Multimedia | awk '{ print $1; }')
if test -z "$pcis"; then
  echo WARNING: no multimedia devices found on pci bus
else
  for p in $pcis; do
    echo set latency timer for $p
    setpci -s $p latency_timer=ff
  done
fi

This reduced some audio pops for me but didn't eliminate them...

You can google for pci latency but basically it controls how long a device
holds the bus when another device requests it. If your disk controllers
don't let go soon enough then streaming devices lose.

