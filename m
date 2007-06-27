From: Andrew Burgess <aab@cichlid.com>
Subject: Re: raid=noautodetect is apparently ignored?
Date: Wed, 27 Jun 2007 08:48:49 -0700
Message-ID: <200706271548.l5RFmn5x026702@cichlid.com>
References: <1_07062612032611867@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>> Odd....
>>>  Maybe you have an initrd which is loading md as a module, then
>>>  running "raidautorun" or similar?
..
>I suspect that the last comment is the clue, after pivotroot I bet it 
>runs another init, not from the boot/initrd images, but from the init.d 
>in the root filesystem. 

One quick way to test this is to boot with "init=/bin/sh"
This lets all the initrd stuff run but nothing from the
root filesystem.

I had a similar problem and found that Fedora's /etc/rc.d/rc.sysinit was
starting up the raid arrays -- that script should probably look
for "raid=noautodetect" in /proc/cmdline.

HTH

