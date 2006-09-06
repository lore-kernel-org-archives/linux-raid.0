From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: checking state of RAID (for automated notifications)
Date: Wed, 06 Sep 2006 10:44:24 +0200
Message-ID: <44FE8A68.8060306@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I would like to have RAID status monitored by nagios.

This sounds like a simple script, but I'm not sure what approach is correct.


Considering, that the "health" status of /proc/mdstat looks like this:

# cat /proc/mdstat
Personalities : [raid1] [raid10]
md2 : active raid10 sda2[4] sdd2[3] sdc2[2] sdb2[1]
       779264640 blocks super 1.0 64K chunks 2 near-copies [4/4] [UUUU]

md1 : active raid1 sdd1[1] sdc1[0]
       1076224 blocks [2/2] [UU]

md0 : active raid1 sdb1[1] sda1[0]
       1076224 blocks [2/2] [UU]

unused devices: <none>


What my script should be checking?

Does the number of "U" (8 for this host) letters indicate that RAID is 
healthy?
Or should I count "in_sync" in "cat /sys/block/md*/md/rd*/state"?
Perhaps the two approaches are the same, though.


What's the best way to determine that the RAID is running fine?


-- 
Tomasz Chmielewski
http://wpkg.org
