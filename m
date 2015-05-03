From: Stephen Burke <steve.burke.56@gmail.com>
Subject: drive failing on same bus every couple weeks
Date: Sun, 3 May 2015 19:46:32 -0400
Message-ID: <CAAugdn6aaXZ45pbODiUp+3E74fXsgxWHKd6Dc7tuy77dqxhMNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So I have had 3 faulty drives so far in the last 6 mo.  For the first
2 I have swapped them out and rebuilt fine, figured I was unlucky and
didn't think about it.  The latest one I noticed that it's the same
bus that is failing every time.  /dev/sdb  I am suspecting that the
drives themselves haven't been faulty & something else is going wrong.

I'm thinking that I should hook up the drive to another bus & rebuild
& see if that fails again.  Will I be able to just swap the cable to a
new bus & rebuild just like if I was swapping out a failed drive?
What are the commands for that?

Any ideas as to what could be going wrong?  The only other thing I can
think of hardware wise is I have a small power supply from a different
computer.  It seems to run everything fine.  I'm wondering if that
doesn't have enough power would random drive failures occur like this
or would they not power on?

Any help would be appreciated.  Here's some info on the raid and what
I could find in the log.

root@ht-pc:/home/sburke# mdadm --detail /dev/md0

/dev/md0:
        Version : 1.2
  Creation Time : Fri Dec 13 01:18:13 2013
     Raid Level : raid5
     Array Size : 3906763776 (3725.78 GiB 4000.53 GB)
  Used Dev Size : 1953381888 (1862.89 GiB 2000.26 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent
   Update Time : Sun May  3 19:09:01 2015
          State : clean, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K
          Name : ht-pc:0  (local to host ht-pc)
           UUID : 508cb42f:d2c1ea9c:e62b4121:c3d9cbc3
         Events : 2506
    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       33        1      active sync   /dev/sdc1
       3       8       65        2      active sync   /dev/sde1
       4       8       16        -      faulty spare   /dev/sdb


/var/log/syslog

May  3 00:02:12 ht-pc kernel: [533073.515788] ata2.00: exception Emask
0x50 SAct 0x40 SErr 0x280900 action 0x6 frozen
May  3 00:02:12 ht-pc kernel: [533073.515799] ata2.00: irq_stat
0x08000000, interface fatal error
May  3 00:02:12 ht-pc kernel: [533073.515809] ata2: SError: {
UnrecovData HostInt 10B8B BadCRC }
May  3 00:02:12 ht-pc kernel: [533073.515819] ata2.00: failed command:
READ FPDMA QUEUED
May  3 00:02:12 ht-pc kernel: [533073.515835] ata2.00: cmd
60/08:30:58:18:c7/00:00:04:00:00/40 tag 6 ncq 4096 in
May  3 00:02:12 ht-pc kernel: [533073.515838]          res
40/00:34:58:18:c7/00:00:04:00:00/40 Emask 0x50 (ATA bus error)
May  3 00:02:12 ht-pc kernel: [533073.515846] ata2.00: status: { DRDY }
May  3 00:02:12 ht-pc kernel: [533073.515856] ata2: hard resetting link
May  3 00:02:13 ht-pc kernel: [533074.004085] ata2: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
May  3 00:02:13 ht-pc kernel: [533074.005165] ata2.00: configured for UDMA/133
May  3 00:02:13 ht-pc kernel: [533074.020088] ata2: EH complete
May  3 00:02:29 ht-pc kernel: [533090.498230] ata2.00: exception Emask
0x50 SAct 0x20000000 SErr 0x280900 action 0x6 frozen
May  3 00:02:29 ht-pc kernel: [533090.498242] ata2.00: irq_stat
0x08000000, interface fatal error
May  3 00:02:29 ht-pc kernel: [533090.498252] ata2: SError: {
UnrecovData HostInt 10B8B BadCRC }
May  3 00:02:29 ht-pc kernel: [533090.498262] ata2.00: failed command:
READ FPDMA QUEUED
May  3 00:02:29 ht-pc kernel: [533090.498277] ata2.00: cmd
60/08:e8:b0:52:ae/00:00:02:00:00/40 tag 29 ncq 4096 in
May  3 00:02:29 ht-pc kernel: [533090.498281]          res
40/00:ec:b0:52:ae/00:00:02:00:00/40 Emask 0x50 (ATA bus error)
May  3 00:02:29 ht-pc kernel: [533090.498289] ata2.00: status: { DRDY }
May  3 00:02:29 ht-pc kernel: [533090.498298] ata2: hard resetting link
May  3 00:02:30 ht-pc kernel: [533090.988061] ata2: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
May  3 00:02:30 ht-pc kernel: [533090.989184] ata2.00: configured for UDMA/133
May  3 00:02:30 ht-pc kernel: [533091.004093] ata2: EH complete

-- 
Steve
www.stayathomedevs.com

Game Data Editor Unity Plugin
