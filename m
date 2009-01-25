From: "GeneralNMX" <generalmx@gmail.com>
Subject: Properly setting up partitions and verbose boot
Date: Sun, 25 Jan 2009 11:18:31 -0500
Message-ID: <001401c97f08$91205150$b360f3f0$@com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
References: 
In-Reply-To: 
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Currently I have a very stupid setup on my home server (not a production
machine). I have four hard drives with three different types of RAID
(1,5,10) on them setup through mdadm. I've been using this for a while and,
as you can guess, I/O Wait is a big issue for me, especially when moving
from different RAID types. I ordered four new hard drives to setup a proper
RAID10 by itself and I'm scrapping the RAID1, instead just consolidating /
into the RAID10. /boot gets its own tiny IDE HDD in a hotswap bay. The RAID5
will consume the 4 old hard drives. 

With my stupid setup, each partition gets its own /dev/mdX device. This is
the only way I know how to do it. On the RAID10, I will need at least two
partitions: / and swap. This means it cannot simply partition the entire
disk Would this cause sub-optimal performance? Is there a way to make an
underlying single RAID10 partition and place the file partitions on top?

I also have a second question. When the disks need to be synced on boot,
mdadm just sits there and does the sync without outputting anything to the
boot log. If I didn't notice the activity lights going off on the SATA
controllers, I would think it's in some infinite loop. Is there a way to
make mdadm more verbose? I'm not running my kernel on "quiet" or "quietboot"
of course. I had to use SysRq just to make sure it was really doing
something and not in some infinite I/O loop.

Matt


