From: John Crisp <john@reetspetit.net>
Subject: RAID 1 partition with hot spare shows [UUU] ?
Date: Wed, 18 Apr 2012 00:42:54 +0200
Message-ID: <4F8DF1EE.70402@reetspetit.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Sorry to trouble people, and I am sure you have better things to do, but
I can't find an answer to the following and don't know where else to go.

I have been struggling with this problem for weeks and having read all I
can I still don't know the answer.

I have a server running a version of CentOS 5.x   Yes, mdadm is old at
2.6.9 but it isn't possible to update it currently.

A year or so ago I clean installed with a software RAID 1 array using
/dev/sda & /dev/sdb and two partitions, md1 & md2 configure
automatically on install.

I restored data to the RAID and then added manually added a third drive
/dev/sdc as a spare.

All appeared hunky dory, but whilst trying to figure a slightly
different problem on a different machine, I went back to the first one
to check how it was configured. Although I am sure all looked normal
when I had last looked, this time is looked a bit strange.

Unfortunately I don't have an exact copy of things before I started
messing about but it looked something like this :


cat /proc/mdstat revealed :

Personalities : [raid1]
md1 : active raid1 sdc1[2] sdb1[1] sda1[0]
      104320 blocks [3/3] [UUU]

md2 : active raid1 sdc2(S) sdb2[1] sda2[0]
      244091520 blocks [2/2] [UU]

unused devices: <none>


I don't understand how md1 shows [UUU] ??


On my other machine which has a similar configuration it shows the
following which I expect :

Personalities : [raid1]
md1 : active raid1 sda1[2](S) hdc1[1] hda1[0]
      104320 blocks [2/2] [UU]

md2 : active raid1 sda2[2](S) hdc2[1] hda2[0]
      312464128 blocks [2/2] [UU]

unused devices: <none>

I thought I could fail and remove the drive, dd/fdisk/reformat, sfdisk
and then try to re add it back to the array effectively as a new drive.
No joy.

If I just fail and remove it md1 shows as [UU_]

I have tried checking mdadm.conf which has the following :

DEVICE partitions
ARRAY /dev/md1 level=raid1 num-devices=2
uuid=8833ba3d:ca592541:20c7be04:42cbbdf1 spares=1
ARRAY /dev/md2 level=raid1 num-devices=2
uuid=43a5b70d:9733da5c:7dd8d970:1e476a26 spares=1

Somewhere along the line the RAID is remembering the earlier
configuration but having changed stuff left right and Cambridge, I can't
seem to get it to forget.

I have tried different variations of mdadm.conf, and tried to rebuild
initrd but that didn't fix it and I am clean out of ideas where to go
next. mdadm.conf seems to be ignored.

Undoubtedly it will take some clever tweaking and I'm scared witless at
trashing the array as I am in a different country from the hardware and
would struggle to get back to fix it !

Any advice on how to put it back to RAID 1 with a 'hot' spare would be
appreciated.

B. Rgds
John
