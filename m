From: Turbo Fredriksson <turbo@bayour.com>
Subject: Re: Which (physical) disk is broken?
Date: Fri, 24 Dec 2004 12:09:39 +0100
Message-ID: <874qic2brg.fsf@pumba.bayour.com>
References: <200412221639.iBMGdH911479@www.watkins-home.com>
	<874qie3qvy.fsf@pumba.bayour.com>
	<16841.64683.581049.327577@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16841.64683.581049.327577@cse.unsw.edu.au> (Neil Brown's
 message of "Thu, 23 Dec 2004 10:00:59 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Neil" == Neil Brown <neilb@cse.unsw.edu.au> writes:

    Neil> On Wednesday December 22, turbo@bayour.com wrote:
    >> >>>>> "Guy" == Guy <bugzilla@watkins-home.com> writes:
    >> 
    Guy> If you access your array, every disk in it will have disk
    Guy> activity.
    >>  He. That's one way I guess... I was more hoping for some
    >> support for this in mdadm...

    Neil> Would be nice....  but until disks have little blue lights
    Neil> that can be turned on and off under software control, and
    Neil> the linux block-device layer has an interface to access this
    Neil> control, there isn't much mdadm can usefully do.

I was more thinking on the 'magic'. When I created the array, I included
this broken disk. I later removed it, but there should still (?) be a
record of it in the super block (or wherever mdadm checks).

It knows how many disks there SHOULD be, and it knows how many is working.

----- s n i p -----
aurora:~# mdadm -D /dev/md1
/dev/md1:
        Version : 00.90.01
  Creation Time : Wed Oct 27 08:12:44 2004
     Raid Level : raid5
     Array Size : 141483520 (134.93 GiB 144.88 GB)
    Device Size : 17685440 (16.87 GiB 18.11 GB)
   Raid Devices : 9
  Total Devices : 8
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Fri Dec 24 11:45:11 2004
          State : clean, degraded
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 32K

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/scsi/host3/bus0/target4/lun0/part1
       1       8       81        1      active sync   /dev/scsi/host3/bus0/target8/lun0/part1
       2       8       97        2      active sync   /dev/scsi/host3/bus0/target9/lun0/part1
       3       8      241        3      active sync   /dev/scsi/host4/bus0/target4/lun0/part1
       4      65        1        4      active sync   /dev/scsi/host4/bus0/target5/lun0/part1
       5      65       17        5      active sync   /dev/scsi/host4/bus0/target8/lun0/part1
       6      65       33        6      active sync   /dev/scsi/host4/bus0/target9/lun0/part1
       7      65      113        7      active sync   /dev/scsi/host4/bus0/target14/lun0/part1
       8       0        0       -1      removed
           UUID : d0b4e775:290f5785:2e6ad7d1:5a66178b
         Events : 0.1005733
----- s n i p -----


Maybe it's to late now, but can't mdadm write a 'tag' somehow that 'this disk
have broken down' and/or 'this disk have been removed from the array'?

I don't know how the (software) RAID works on kernel/hardware level, only
how I, as a user/admin uses it :)

But if I check one of the disks scsi4:4:part1 for example:

----- s n i p -----
aurora:~# mdadm -E /dev/scsi/host4/bus0/target4/lun0/part1
/dev/scsi/host4/bus0/target4/lun0/part1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : d0b4e775:290f5785:2e6ad7d1:5a66178b
  Creation Time : Wed Oct 27 08:12:44 2004
     Raid Level : raid5
    Device Size : 17685440 (16.87 GiB 18.11 GB)
   Raid Devices : 9
  Total Devices : 8
Preferred Minor : 1

    Update Time : Fri Dec 24 11:49:46 2004
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 0
       Checksum : b038c0d3 - correct
         Events : 0.1005753

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     3       8      241        3      active sync   /dev/scsi/host4/bus0/target4/lun0/part1
   0     0       8       49        0      active sync   /dev/scsi/host3/bus0/target4/lun0/part1
   1     1       8       81        1      active sync   /dev/scsi/host3/bus0/target8/lun0/part1
   2     2       8       97        2      active sync   /dev/scsi/host3/bus0/target9/lun0/part1
   3     3       8      241        3      active sync   /dev/scsi/host4/bus0/target4/lun0/part1
   4     4      65        1        4      active sync   /dev/scsi/host4/bus0/target5/lun0/part1
   5     5      65       17        5      active sync   /dev/scsi/host4/bus0/target8/lun0/part1
   6     6      65       33        6      active sync   /dev/scsi/host4/bus0/target9/lun0/part1
   7     7      65      113        7      active sync   /dev/scsi/host4/bus0/target14/lun0/part1
   8     8       0        0        8      faulty removed
----- s n i p -----

It (mdadm?) know exactly what md it belongs to etc... If I check
the disk that i THINK is the 'faulty removed' one, it 'knows nothing':

----- s n i p -----
aurora:~# mdadm -E /dev/scsi/host4/bus0/target15/lun0/part1
mdadm: No super block found on /dev/scsi/host4/bus0/target15/lun0/part1 (Expected magic a92b4efc, got 00000000)
----- s n i p -----

So, IF this is the disk, then what did mdadm do when it was removed?
Did it clear the super block? Couldn't it write something else instead?
Or at least keep the UUID?

Hmm, looking trough the code (I do that freely, before someone throws
it at me :) i see that all mdadm do is a ioctl() so I guess it's something
that have to be done in the kernel (?)...

But how come mdadm knows that there's one removed? Common sence? There's
9 raid devices (how come it knows that?) and 8 total devices, hence one
must be/have been removed?


Looking at md.c in the kernel, I see that it don't write to the disk
(when removing a device from an array) when persistent super blocks
is used (which I don't). There don't seem to be an option in mdadm
for this (I do remember using it with raidtools long ago)..


Am I way of? It's early on christmas eve, and my blood to coffein ratio
is high... :)
-- 
Iran arrangements [Hello to all my fans in domestic surveillance]
Kennedy pits 767 Peking Clinton assassination Cocaine PLO Ft. Meade
killed $400 million in gold bullion kibo
[See http://www.aclu.org/echelonwatch/index.html for more about this]
