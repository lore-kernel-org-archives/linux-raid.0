From: Dave W <dave+gmane@wuertele.com>
Subject: How do I determine which drive should be in which slot?
Date: Sat, 26 Jun 2010 05:32:08 +0000 (UTC)
Message-ID: <loom.20100626T070913-497@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After making some changes in the bios to my boot order, my 5-drive RAID6
stopped assembling.  Three of the five known-good drives suddenly stopped
getting added to the right slots.  There are no disk errors in the logs and
I can read from the drives with no problems.

# mdadm --stop /dev/md0
mdadm: stopped /dev/md0
# mdadm -v -Af /dev/md0 /dev/sd[bcdef]1
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 7.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 6.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 5.
mdadm: no uptodate device for slot 0 of /dev/md0
mdadm: no uptodate device for slot 1 of /dev/md0
mdadm: added /dev/sde1 to /dev/md0 as 3
mdadm: no uptodate device for slot 4 of /dev/md0
mdadm: added /dev/sdf1 to /dev/md0 as 5
mdadm: added /dev/sdc1 to /dev/md0 as 6
mdadm: added /dev/sdb1 to /dev/md0 as 7
mdadm: added /dev/sdd1 to /dev/md0 as 2
mdadm: /dev/md0 assembled from 2 drives and 3 spares - not enough to start the
array.
# 

Reading the thread at http://thread.gmane.org/gmane.linux.raid/17774, I think
that a command like this:

   mdadm -C /dev/md0 -l6 -n5 /dev/sd[bcdef]1

would tell mdadm to rewrite the superblock with the disks in the right slots.
Does the order on the command line determine the slot allocations?  How can I
tell that my disks will get put in the right slots?  Is it safe to just try
this order?

Thanks,
Dave

