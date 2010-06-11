From: Dave W <dave+gmane@wuertele.com>
Subject: How does kernel decide that a drive is "spare"?
Date: Fri, 11 Jun 2010 05:18:48 +0000 (UTC)
Message-ID: <loom.20100611T070945-23@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a fileserver with a RAID6 on five 2TB drives.  It appeared to be working
fine before I rebooted it, but now it is complaining

mdadm: /dev/md0 assembled from 2 drives and 3 spares - not enough to start the \
array.

That's strange... I never configured any spare drives.  There should be five
active drives in this array.  I checked /proc/mdstat:

[root@fileserver ~]# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : inactive sdd1[2](S) sdb1[7](S) sdc1[6](S) sdf1[5](S) sde1[3](S)
      9767559680 blocks

[root@fileserver ~]# mdadm -A /dev/md0 -fv /dev/sd[bcdef]1
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
mdadm: /dev/md0 assembled from 2 drives and 3 spares - not enough to start the \
array.

Why are three drives assumed to be spares?  Is there a way for me to recover
this array?

Thanks,
Dave

