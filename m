From: maarten <maarten@ultratux.net>
Subject: lilo boot problems
Date: Wed, 25 Aug 2004 14:58:46 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408251458.46575.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi list,

I've got bitten by the recent bug(?) that lilo seems to have with 2.6.x 
kernels where, upon install, it prints:

Fatal: Trying to map files from unnamed device 0x0000

I've tried everything I could think of in lilo.conf to no avail.  Using google 
there are several (but not many) threads about this specific error but I've 
not seen a solution anywhere yet.

A "raid-extra-boot" line doesn't help any, neither do any other options.

At this point, I'm not even sure where the error comes from as even trying to 
install a normal non-raid lilo.conf now fails.

As an aside, this is what I'm trying to accomplish:
I have a SATA boot drive /dev/sda with the root fs being /dev/sda2.  I have a 
degraded raid1 device consisting of /dev/sdb1, /dev/sdc1, dev/sdd1.  
(I realize this is badly chosen; had the partition number been 2 instead of 1 
I probably would've been able to boot after changing the physical order of 
the drives without any changes...  But as it is, I can't.)
I'm trying to swap sdb and sda so it will boot off the raid1 device (or else 
just of any of the 3 simple partitions that form the raid1 device...) so I 
can then add the former /dev/sda to the array to complete it. 

Any insights...?

Maarten

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

