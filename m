From: Reuben Farrelly <reuben-lkml@reub.net>
Subject: Oopsing with md in 2.6.14-rc5-mm1
Date: Fri, 04 Nov 2005 17:17:22 +1300
Message-ID: <436AE0D2.3080000@reub.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

Hi,

After some minor dramas with one of the disks in my raid1 array deciding to not 
be seen by the bios on reboot, I managed to get it back, but had to manually 
re-add the partitions to the array.  Every time an md device finished resyncing, 
I would get this on the console, although things did keep working:

ov  4 14:21:21 tornado kernel: md: md10: sync done.
Nov  4 14:21:21 tornado kernel: md: syncing RAID array md6
Nov  4 14:21:21 tornado kernel: md: minimum _guaranteed_ reconstruction speed: 1
000 KB/sec/disc.
Nov  4 14:21:21 tornado kernel: md: using maximum available idle IO bandwidth (b
ut not more than 200000 KB/sec) for reconstruction.
Nov  4 14:21:21 tornado kernel: md: using 128k window, over a total of 104320 bl
ocks.
Nov  4 14:21:21 tornado kernel: RAID1 conf printout:
Nov  4 14:21:21 tornado kernel: md: delaying resync of md3 until md6 has finishe
d resync (they share one or more physical units)
Nov  4 14:21:21 tornado kernel:  --- wd:2 rd:2
Nov  4 14:21:21 tornado kernel:  disk 0, wo:0, o:1, dev:sda10
Nov  4 14:21:21 tornado kernel:  disk 1, wo:0, o:1, dev:sdb10
Nov  4 14:21:21 tornado kernel: Debug: sleeping function called from invalid con
text at include/asm/semaphore.h:102
Nov  4 14:21:21 tornado kernel: in_atomic():0, irqs_disabled():1
Nov  4 14:21:21 tornado kernel:  [<c0103a20>] dump_stack+0x17/0x19
Nov  4 14:21:24 tornado kernel:  [<c011a1c4>] __might_sleep+0x9d/0xae
Nov  4 14:21:24 tornado kernel:  [<c018e4b3>] sysfs_hash_and_remove+0x2c/0x124
Nov  4 14:21:24 tornado kernel:  [<c01901ba>] sysfs_remove_link+0xb/0xd
Nov  4 14:21:24 tornado kernel:  [<c0297cde>] super_90_sync+0x209/0x480
Nov  4 14:21:24 tornado kernel:  [<c0298ecf>] sync_sbs+0x2c/0x47
Nov  4 14:21:24 tornado kernel:  [<c0298f53>] md_update_sb+0x69/0x1a9
Nov  4 14:21:24 tornado kernel:  [<c029d4fd>] md_check_recovery+0x133/0x42b
Nov  4 14:21:24 tornado kernel:  [<c02957a4>] raid1d+0x1f/0x3b8
Nov  4 14:21:24 tornado kernel:  [<c029bcfe>] md_thread+0x59/0x109
Nov  4 14:21:24 tornado kernel:  [<c012f547>] kthread+0x99/0x9d
Nov  4 14:21:24 tornado kernel:  [<c01010b5>] kernel_thread_helper+0x5/0xb
Nov  4 14:21:24 tornado kernel: md: md6: sync done.

I noticed a heap of patches out today from NeilB, are these likely to solve this 
problem?

Reuben
