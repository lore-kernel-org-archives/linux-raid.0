From: "Kevin M. Shortt" <shortt@cgicafe.com>
Subject: RAID 0 to RAID 1
Date: Fri, 26 Mar 2004 14:10:59 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0403261402370.22530-100000@cappuccino.cgicafe.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hi all,

I've just built a box with Fedora Core 1 and used disk druid
to create many partitions (during the install) set up as RAID 1.

Through all the clicking a redundant creations, I accidentally
created one partition as RAID 0. I would like to convert this
to RAID 1.

The filesystem is unmountable. I have not installed mdadm (yet).
These are the steps I did do to change the partition from RAID 0
to RAID 1. They have not worked. Any advise and insight is greatly
appreciated. Thanks in advance..


/proc/mdstat entry appears as such.
-------------------------------------
   md8 : active raid0 hda8[0] hdc8[1]
      6136576 blocks 64k chunks
-------------------------------------

- umount /mountpoint
- raidstop /dev/md8
# I verified that /dev/md8 was removed from /proc/mdstat.


# I then edited /etc/raidtab to change the "raid-level" entry
# for /dev/md8 to be "1" and not "0".
- vi /etc/raidtab
- raidstart /dev/md8
# The /proc/mdstat entry was still indicating RAID 0.




-k


