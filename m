From: "max power" <zouookmoetenwerken@gmail.com>
Subject: flagging a disk faulty during raid-5 reshape/grow operation
Date: Mon, 3 Nov 2008 16:48:51 +0100
Message-ID: <e6c4d5060811030748n4f612d8bme2d8d8c05509a7b7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list,

This morning, I tried to resize our raid-5 array from 3 to 4 disks.
Immediately after issuing the 'mdadm --grow -n 4' command, I found out
that the new disk is actually 'faulty'.  There are no unrecoverable
errors yet, but my smartctl shows a lot of hardware ECC and seek
errors going on. The read errors are causing the whole array to
perform very poorly, and the resize is said to take another 2-3 days
(according to mdstat).

Is it safe to mark the new drive as faulty before the reshape
operation finishes, or is there a risk that this will corrupt the
raid?

I'm using kernel version 2.6.24-21-generic #1 SMP Mon Aug 25 17:32:09
UTC 2008 i686 GNU/Linux (Ubuntu Intrepid), and mdadm version mdadm -
v2.6.7 - 6th June 2008.

output from mdadm  --detail:

/dev/md2:
        Version : 00.91
  Creation Time : Mon Nov 19 14:04:02 2007
     Raid Level : raid5
     Array Size : 535173120 (510.38 GiB 548.02 GB)
  Used Dev Size : 267586560 (255.19 GiB 274.01 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Mon Nov  3 16:34:08 2008
          State : clean, recovering
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

 Reshape Status : 1% complete
  Delta Devices : 1, (3->4)

           UUID : 36b972e8:26bae0a4:de6b0f36:
485dee50
         Events : 0.6496

    Number   Major   Minor   RaidDevice State
       0       8        7        0      active sync   /dev/sda7
       1       8       39        1      active sync   /dev/sdc7
       2       8       55        2      active sync   /dev/sdd7
       3       8       23        3      active sync   /dev/sdb7



Thanks in advance,
Jorik
