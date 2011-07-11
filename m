From: "Sandra Escandor" <sescandor@evertz.com>
Subject: RE: Resolving mdadm built RAID issue
Date: Mon, 11 Jul 2011 13:37:30 -0400
Message-ID: <C70A636B101FD44999B82525C3E92AFAD8CCF1@otis.burlington.evertz.tv>
References: <C70A636B101FD44999B82525C3E92AFAD8CB1E@otis.burlington.evertz.tv> <1310152936.3079.5.camel@baal> <C70A636B101FD44999B82525C3E92AFAD8CC6C@otis.burlington.evertz.tv> <1310402589.2958.14.camel@baal>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <1310402589.2958.14.camel@baal>
Sender: linux-raid-owner@vger.kernel.org
To: "Tyler J. Wagner" <tyler@tolaris.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This RAID was built using the intel matrix storage manager metadata. It
was created using the commands: 

1. "sudo mdadm -A /dev/md0 /dev/sd[b-g]"
2. "sudo mdadm -I /dev/md0" (in order to build the actual raid devices
inside the container).


-----Original Message-----
From: Tyler J. Wagner [mailto:tyler@tolaris.com] 
Sent: Monday, July 11, 2011 12:43 PM
To: Sandra Escandor
Cc: linux-raid@vger.kernel.org
Subject: RE: Resolving mdadm built RAID issue

On Mon, 2011-07-11 at 11:04 -0400, Sandra Escandor wrote:
> I've been looking into this issue, and from what I've read on other
> message boards with similar ata error warnings (their failed command
is
> READ FPDMA QUEUED and mine is WRITE), it could be a RAID member disk
> failure - but, wouldn't /proc/mdstat output show that a RAID member
disk
> can no longer be used if it has write errors? Please correct me if I'm
> wrong.

If the disk has errors, /proc/mdstat will show it as failed, and it will
appear to be out of the array. However, an error on one part of the disk
(say, partition 1) may cause the raid array using partition 1 to show a
failure, but not another array using partition 2, even though that
entire disk may be suspect.

Which takes us to what is odd about your setup: 

> Personalities : [raid10]
> 
> md126 : active raid10 sdb[3] sdc[2] sdd[1] sde[0]
> 
>       1465144320 blocks super external:/md127/0 64K chunks 2
near-copies
> [4/4] [UUUU]
> 
>  
> 
> md127 : inactive sdb[3](S) sdc[2](S) sdd[1](S) sde[0](S)
> 
>       9028 blocks super external:imsm

I've never seen this before. It seems to indicate you are using 1.x
metadata, with the superblock for md126 stored in another array, md127,
which is inactive.

I have no idea how that can be created, nor what it will mean now.
Anybody?

Tyler

-- 
"If I had a robohand, I'd totally bling that shit out with neon ground
effects and integrated flashlights and bottle openers. My hand would
blink
'12:00' after a power failure."
   -- Jamie Zawinski

