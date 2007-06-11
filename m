From: simon redfern <simon@musicpictures.com>
Subject: what is the best approach for fixing a degraded RAID5 (one drive
 failed) using mdadm?
Date: Mon, 11 Jun 2007 15:34:09 +0200
Message-ID: <466D4F51.40009@musicpictures.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Folks,

Greetings from Berlin.

We have a RAID5 (originally with 4 drives) - but it seems 1 drive has 
failed although it still appears in lsscsi.
Of the remaining 3 drives, 2 have the correct Event that matches the 
Array Event.

My question is: what is the best way to get the array to a readable 
state? Do we need to replace the failed drive or should we be able to 
recover with the remaining 3 drives?

Here is some more info:

At boot we have messages like the following:

raid5 failed to run raid set md0
....
mdadm: failed to RUN_ARRAY
......
could not bd_claim sda2
......
md0 already running, cannot run sdb2
.......

here is our mdadm.conf:

cat /etc/mdadm.conf

/dev/md0 <- the raid

/dev/sda2 <- the raid members.
/dev/sdb2
/dev/sdc2
/dev/sdd2


and our mdstat:

cat /proc/mdstat

Personalities : [raid5]
md0 : inactive sda2[0] sdd2[3] sdc2[2]
a-number blocks

unused devices <none>

Thus it seems we are missing sdb2[1] from the array.


mdadm --detail /dev/md0

Device Site: 288.47 GB
Raid Devices: 4
Total Devices: 3
Preferred Minor : 0
Persistance: Superblock is persistent

Update Time: Jun 1 2004 (note: system date is june 17 2007)
State: active, degraded
Active devices: 3
Working devices: 3
Failed Devices: 0
Spare Devices: 0
Layout: left-symetric
Chunk Size: 128K

UUID: a-long-char-string.
Events: 0.35025133


Number     Major    Minor     RaidDevice     State
0        8        2        0            active sync     /dev/sda2
1        0        0        -            removed   
2        8        34        2            active sync     /dev/sdc2
3        8        50        3            active sync     /dev/sdd2

------------------ 

It seems that the array is both dirty and degraded. Only two of the drives have the same "Event" 
and one would hope that at least 3 (in a 4 drive array) would have the same "Event" number.
Guess this is the number of operations on each drive since they (all) joined the raid.

this is discovered thus:

mdadm -E /dev/sd[b-i]1 | grep Event


Events : 0.32012979 <- different!
Events : 0.35025133
Events : 0.35025133

However, lsscsi shows all 4 drives (as ATA drives)

Any suggestions much appreciated!

cheers,

Simon.


