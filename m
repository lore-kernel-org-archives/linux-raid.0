From: Rich Walker <rw@shadowrobot.com>
Subject: Removing devices from RAID-5
Date: Thu, 14 Jun 2007 19:13:57 +0100
Message-ID: <m3ejkel7yy.fsf@shadow.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

I've been having some problems with a machine, and now want to reduce
the number of drives in the array.

It started out as an array of 160GB drives, but over time they have
mostly been replaced by 250GB drives:

/dev/md1:
        Version : 00.90.03
  Creation Time : Thu Jan 20 21:01:23 2005
     Raid Level : raid5
     Array Size : 638904576 (609.31 GiB 654.24 GB)
    Device Size : 159726144 (152.33 GiB 163.56 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu Jun 14 19:07:11 2007
          State : active
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 32K

           UUID : 6b8b4567:327b23c6:643c9869:66334873
         Events : 0.26772242

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1      34        2        1      active sync   /dev/hdg2
       2      33        2        2      active sync   /dev/hde2
       3      57        2        3      active sync   /dev/hdk2
       4      56        2        4      active sync   /dev/hdi2

The array is used as a single PV/VG for LVM.

What I want to do is to
(a) reduce the PV/VG so it would fit in 160*3 rather than 160*4
(b) remove the last 160GB drive, (hdi), taking the array from 4+1 to 4+0
(c) rearrange the array from 4+0 to 3+1
(d) grow the array to 250*3
(e) enlarge the PV/VG again.

I would think that
 mdadm --grow --raid-devices=4 -z max /dev/md1 /dev/hdg2 /dev/hde2 /dev/sda2 /dev/hdk2
would do steps (b),(c),(d) in one go - is this correct?

The linux kernel version running is 2.6.21.3 SMP.


cheers, Rich.




-- 
rich walker         |  Shadow Robot Company | rw@shadow.org.uk
technical director     251 Liverpool Road   |
need a Hand?           London  N1 1LX       | +UK 20 7700 2487
www.shadowrobot.com/hand/overview.shtml

