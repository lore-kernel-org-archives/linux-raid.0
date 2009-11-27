From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Question for Neil/Superblocks
Date: Fri, 27 Nov 2009 16:27:27 -0500 (EST)
Message-ID: <alpine.DEB.2.00.0911271624450.30813@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

A couple of things, recently I tried to make a new system (MDADM/latest/SW 
RAID1) and noticed that GRUB & LILO still only support 0.90 superblocks. 
This leads me to my next question.

Will the newer superblocks be supported? I ask this due to my final 
question.

With 0.90 superblocks, I have never seen any array (raid1,raid5,raid6) try 
to correct a read-error, but when I made an array with 1.2 superblocks 
(not the boot volume of course) using VelociRaptors, great for testing 
crap disks that don't work in read, I did see it try to correct read 
errors!  I was wondering if that is only applicable to superblocks >= 
1.x+?

I know you can build yourself an initrd/miniroot so/on/so forth but its 
nice when you can just build a kernel, run lilo and have it auto-detect 
the raid1 volumes and boot accordingly (as you can with 0.90 superblocks).

Justin.
