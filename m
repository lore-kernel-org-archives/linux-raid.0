From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: What do these SATA errors mean / kernel 2.6.25.6 (DRDY ERR/ICRC
 ABRT)
Date: Wed, 11 Jun 2008 06:14:55 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0806110608080.7726@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755256AbYFKKPO@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Never had a single error so far, powered down my host, powered it back up,
and now with kernel 2.6.25.6:

Jun 11 05:23:24 p34 kernel: [   67.118632] mtrr: no more MTRRs available
Jun 11 05:46:23 p34 kernel: [ 1445.288619] ata12.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
Jun 11 05:46:23 p34 kernel: [ 1445.288626] ata12.00: irq_stat 0x00060002, device error via D2H FIS
Jun 11 05:46:23 p34 kernel: [ 1445.288632] ata12.00: cmd 35/00:f8:47:dc:35/00:03:02:00:00/e0 tag 0 dma 520192 out
Jun 11 05:46:23 p34 kernel: [ 1445.288634]          res 51/84:f8:47:dc:35/00:03:02:00:00/e0 Emask 0x10 (ATA bus error)
Jun 11 05:46:23 p34 kernel: [ 1445.288637] ata12.00: status: { DRDY ERR }
Jun 11 05:46:23 p34 kernel: [ 1445.288639] ata12.00: error: { ICRC ABRT }
Jun 11 05:46:23 p34 kernel: [ 1445.288649] ata12: hard resetting link
Jun 11 05:46:25 p34 kernel: [ 1447.419983] ata12: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
Jun 11 05:46:25 p34 kernel: [ 1447.429612] ata12.00: configured for UDMA/100
Jun 11 05:46:25 p34 kernel: [ 1447.429628] ata12: EH complete
Jun 11 05:46:25 p34 kernel: [ 1447.813910] sd 11:0:0:0: [sdl] Write Protect is off
Jun 11 05:46:25 p34 kernel: [ 1447.813912] sd 11:0:0:0: [sdl] Mode Sense: 00 3a 00 00
Jun 11 05:46:25 p34 kernel: [ 1447.813928] sd 11:0:0:0: [sdl] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jun 11 06:00:32 p34 kernel: [ 2293.491350] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
Jun 11 06:00:32 p34 kernel: [ 2293.491360] ata1.00: cmd 35/00:02:43:90:7d/00:00:12:00:00/e0 tag 0 dma 1024 out
Jun 11 06:00:32 p34 kernel: [ 2293.491362]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun 11 06:00:32 p34 kernel: [ 2293.491365] ata1.00: status: { DRDY }
Jun 11 06:00:32 p34 kernel: [ 2293.794295] ata1: soft resetting link
Jun 11 06:00:32 p34 kernel: [ 2293.947277] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jun 11 06:00:32 p34 kernel: [ 2294.614206] ata1.00: configured for UDMA/133
Jun 11 06:00:32 p34 kernel: [ 2294.614227] ata1: EH complete
Jun 11 06:00:32 p34 kernel: [ 2294.335647] sd 0:0:0:0: [sda] Write Protect is off
Jun 11 06:00:32 p34 kernel: [ 2294.335650] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jun 11 06:00:32 p34 kernel: [ 2294.348472] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

Nothing was broken in any of the arrays and all seems to be functioning 
now but albeit at lower speeds as you see above UDMA/100 and UDMA/133. 
Could there be a bug with the new Veliciraptors and the drivers in the 
kernel?  I never saw this happen/occur with my old raptor 150s or 74s. 
Also, I stress tested all of these drives for 8hours+ and they never had a 
problem before so it makes the problem rather peculiar.

# cat /proc/mdstat 
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] 
md1 : active raid1 sdb2[1] sda2[0]
       136448 blocks [2/2] [UU]

md2 : active raid1 sdb3[1] sda3[0]
       276109056 blocks [2/2] [UU]

md3 : active raid5 sdl1[9] sdk1[8] sdj1[7] sdi1[6] sdh1[5] sdg1[4] sdf1[3] sde1[2] sdd1[1] sdc1[0]
       2637296640 blocks level 5, 1024k chunk, algorithm 2 [10/10] [UUUUUUUUUU]

md0 : active raid1 sdb1[1] sda1[0]
       16787776 blocks [2/2] [UU]

unused devices: <none>

I am using the same cables/configuration, just new disks.  The smart tests
also show as good, is this a kernel problem?

/dev/sda:

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%       108         -
# 2  Short offline       Completed without error       00%       103         -
# 3  Short offline       Completed without error       00%        79         -
# 4  Short offline       Completed without error       00%        56         -
# 5  Extended offline    Completed without error       00%        32         -
# 6  Short offline       Completed without error       00%         8         -

SMART Error Log Version: 1
No Errors Logged

/dev/sdl:

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%       111         -
# 2  Short offline       Completed without error       00%       107         -
# 3  Short offline       Completed without error       00%        83         -
# 4  Short offline       Completed without error       00%        59         -
# 5  Extended offline    Completed without error       00%        36         -
# 6  Short offline       Completed without error       00%        11         -

Does/the kernel handle the ATA v8 protocol properly?
ATA Version is:   8

Justin.
