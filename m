From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: Question about recovery via mdadm
Date: Thu, 13 Feb 2003 07:43:45 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D627@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Neil Brown' <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

I've seen this issue several times, and it seems most acute with the RedHat
8.0 kernel (2.4.18-14).

Situation: 
I did a hotswap of sda, with:  mdadm -f, raidhotremove, then raidhotadd.
The md kernel messages indicate that the removal, hotadd, and bind occurred,
then it has the raid printout of the status before the recovery, but never
starts the recovery/resync.  Sometimes it will explicitly say that it is
hot-adding the disk as a spare, sometimes not.  

# cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 sda6[2] sdb6[1]
      289024 blocks [2/1] [U_]

md1 : active raid1 sda2[2] sdb2[1]
      64192 blocks [2/1] [U_]

md0 : active raid1 sda5[2] sdb5[1]
      5293312 blocks [2/1] [U_]

unused devices: <none>
#
The superblock mdadm --examine shows that nd=2, wd=2, but 1 disk is active
and the other (sda) is a  spare.

Question:
Solving why I got into this is another issue, but:
Is there any way, once I'm in this predicament, to force a recovery to the
spare, from userland (via mdadm)?  

Andy

