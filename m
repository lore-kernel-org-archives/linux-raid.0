From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: very strange behavior with RAID1 arrays on Ubuntu 12.04 (kernel 3.2)
Date: Tue, 12 Jun 2012 17:08:20 -0400
Message-ID: <4FD7AFC4.1020707@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

On Ubuntu 12.04 with a standard kernel (3.2) we've been seeing very 
strange behavior with our RAID1 sets, both with superblock 1.2, and with 
0.9. The system has been instructed to come up with a degraded array in 
initrd, in case this is relevant. Here is an example of what is 
happening. We have 5 RAID1 sets on a server. They live on partitions on 
/dev/sda and /dev/sdb. The sever comes up with 2 out of 5 sets degraded, 
and the others just fine.

Trying to re-add or add the partitions into the arrays fails like this:

# mdadm /dev/md2 --re-add /dev/sda6
mdadm: --re-add for /dev/sda6 to /dev/md2 is not possible

# mdadm /dev/md2 --add /dev/sda6
mdadm: /dev/sda6 reports being an active member for /dev/md2, but a 
--re-add fails.
mdadm: not performing --add as that would convert /dev/sda6 in to a spare.
mdadm: To make this a spare, use "mdadm --zero-superblock /dev/sda6" first.

Here is some more information from /proc/mdstat, dmesg, and syslog.

# cat /proc/mdstat
md2 : active raid1 sdb6[1]
       20479872 blocks [2/1] [_U]

md3 : active raid1 sdb7[0]
       10239872 blocks [2/1] [U_]

# dmesg | grep md2
[    4.087037] md/raid1:md2: active with 1 out of 2 mirrors
[    4.087147] md2: detected capacity change from 0 to 20971388928
[    4.119168]  md2: unknown partition table
[   12.383035] EXT4-fs (md2): mounted filesystem with ordered data mode. 
Opts: (null)

# dmesg | grep md3
[    4.083084] md/raid1:md3: active with 1 out of 2 mirrors
[    4.083230] md3: detected capacity change from 0 to 10485628928
[    4.180986]  md3: unknown partition table
[    9.631814] EXT4-fs (md3): mounted filesystem with ordered data mode. 
Opts: (null)

# ls -l /dev/sda6
brw-rw---- 1 root disk 8, 6 Jun 12 16:54 /dev/sda6
# ls -l /dev/sda7
brw-rw---- 1 root disk 8, 7 Jun 12 16:54 /dev/sda7

# grep md2 /var/log/syslog
Jun 12 16:54:32 ps2 kernel: [    4.087037] md/raid1:md2: active with 1 
out of 2 mirrors
Jun 12 16:54:32 ps2 kernel: [    4.087147] md2: detected capacity change 
from 0 to 20971388928
Jun 12 16:54:32 ps2 kernel: [    4.119168]  md2: unknown partition table
Jun 12 16:54:32 ps2 kernel: [   12.383035] EXT4-fs (md2): mounted 
filesystem with ordered data mode. Opts: (null)
Jun 12 16:54:38 ps2 mdadm[1181]: DegradedArray event detected on md 
device /dev/md2
