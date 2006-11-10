From: Jacob Schmidt Madsen <jacob@mungo.dk>
Subject: How to recover from massive disk failure
Date: Fri, 10 Nov 2006 01:50:39 +0100
Message-ID: <200611100150.39878.jacob@mungo.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey

I have a 2 controllers: Promise SATA150 TX4 and Promise SATA300 TX4.

2 disks are connected to the SATA150 and 4 disks are connected to SATA300.

The 6 disks are part of a raid5 array.

Today the SATA300 controller failed and the 4 disks were excluded from the 
array.

The array was inactive the moment the 4 disks were excluded. After rebooting 
all controllers and disks are online again.

But now i have trouble starting the array and i could really use some input 
from smarter minds on this list.

Here's some output i gathered:

# cat /proc/mdstat:
md5 : active raid5 sdg1[6](F) sdf1[7](F) sde1[8](F) sdd1[9](F) sdc1[5] sdb1[4]
1562842880 blocks level 5, 64k chunk, algorithm 2 [6/2] [____UU]

The 4 failed disks are the ones connected to the failed controller.

The following is after the reboot.

# cat /proc/mdstat:
md5 : inactive sdb1[4] sdc1[5] sdg1[3] sdf1[2] sde1[1] sdd1[0]
1875411456 blocks

I then did the following in hope that it would help:

# mdadm -S /dev/md5
mdadm: stopped /dev/md5
# mdadm -As /dev/md5
mdadm: /dev/md5 assembled from 2 drives - not enough to start the array.

No luck!

What can i do to get it up and running again?

Thanks!
