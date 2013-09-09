From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Mixing WD red with older seagates
Date: Sun, 08 Sep 2013 20:41:29 -0700
Message-ID: <522D4369.80404@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

well, another drive going down. This time sdc. I have a vdr system with 
2 pairs of seagate 500Gb drives set up as mirrors. a/b are boot, swap, 
and data. c/d are single partition data. I have done at least 4 rma's on 
these drives and warranty was nearly up on the last one to go down just 
6 months ago. So warranty or not, I'm done with seagate. I only have 
about $100 saved up (was saving for something else:( ). I'd like to get 
a WD red 1Tb drive and set it up to act as a 3rd for a/b and replace sdc 
mirroring sdd. Then at some point remove sda or b (maybe in another 6 
months when one of them goes).

I read that the red line WD's had some problems with the 1Gb drives when 
they first come out. Anyone get any lately know if they are reliable 
now? Also, any problems pairing one of these with the seagates?

Any red flags in these that will cause problems? I have to refigure all 
this stuff out each time.

------------------------------------------------
menu.lst: http://pastebin.com/7WWHajsc
------------------------------------------------
device.map:

(fd0)    /dev/fd0
(hd0)    /dev/disk/by-id/ata-ST3500413AS_Z3T69GCE
(hd1)    /dev/disk/by-id/ata-ST3500418AS_5VMJ49P1
(hd2)    /dev/disk/by-id/ata-ST3500320AS_9QM35MY5
(hd3)    /dev/disk/by-id/ata-ST3500820AS_9QM6V6JF
------------------------------------------------
I know there was some command to auto update device.map, but I forget 
what it was.
