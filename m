From: Lars Gaarden <lar-gaar@online.no>
Subject: HighPoint Rocket 1540 hang driver load (Was: Re: Which raid card
 to buy for Sarge)
Date: Wed, 21 Apr 2004 13:28:44 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40865AEC.8040604@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is ironic. I found this thread just after reporting this:
http://bugme.osdl.org/show_bug.cgi?id=2555

Nick Maynard <nick@tastycake.net> writes:

>>> I'm running four disks off a RocketRAID 1540 SATA card with Linux
>>> software RAID since kernel 2.6.0.  The driver included with the kernel
>>> works just fine.  Any card using the hpt374 chip should work, whatever
>>> the name on the box happens to be.
>> Yea.  You should note that I have a Rocket 1540, not a RocketRAID
>> 1540.  There's a difference

>More than the box and the BIOS?

The PCB layout is different, at least.
http://www.highpoint-tech.com/image/Product/r1540-pix.gif
http://www.highpoint-tech.com/image/Product/rr1540pix-1.jpg

Also, loading a RocketRAID BIOS on a Rocket card doesn't work
very well. If any drives are connected, it will cause a hard
hang when the card probes for drives during POST.

>> - shown particularly by the fact that Highpoint release open drivers
>> for the RocketRAID and not the Rocket.

HPT does indeed provide 'open source' drivers for both the Rocket 1540
and the RocketRAID 1540. You just need to look around a bit.

http://www.highpoint-tech.com/374drivers_down.htm
http://www.highpoint-tech.com/hpt374-opensource-v111.tgz

>I wouldn't use those drivers, having looked briefly at the source code
>they do release.  It wasn't pretty.

IANA driver programmer, so I can't comment on the quality. But using
that v111 from above compiled with NON_RAID=1 and some boot trickery
(boot with no drives connected to the controller, so the BIOS on the
card isn't loaded. Then connect drives before loading driver) seems to
be the only way for me to make the card work properly.

Using the same trick with the hpt366 driver cause slow data rates
and drive_cmd: status=0x58 { DriveReady SeekComplete DataRequest }
status error: status=0x58 { DriveReady SeekComplete DataRequest }
errors,

>> Should doesn't necessarily mean does, unfortunately.

>Could the onboard bios be messing with you? Can it be disabled?

Probably. All the drivers i have tried (except for the official binary
drivers) will lock the computer hard if any drives are connected to the
controller at BOOT/POST.

I have found no other way of disabling the BIOS.

Anyway, I have the time and hardware to do testing if someone has
the time to take a look at it.

-- 
LarsG
