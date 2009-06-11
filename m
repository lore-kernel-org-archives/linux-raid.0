From: Jim Paris <jim@jtan.com>
Subject: Assembly problems with kernel 2.6.30?
Date: Thu, 11 Jun 2009 03:25:38 -0400
Message-ID: <20090611072538.GA7841@psychosis.jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am running Debian with my root filesystem on /dev/md1.
At boot, hook scripts in initramfs-tools run:

mdadm --assemble --scan --run --auto=yes /dev/md1

with the following /etc/mdadm/mdadm.conf:

DEVICE partitions
ARRAY /dev/md0 level=raid1 num-devices=6 UUID=dece84f3:a8f8be71:ea9d9fee:21fd5f90
ARRAY /dev/md1 level=raid1 num-devices=2 UUID=0598d2ea:f6c0185f:614fa502:109d1a5d
ARRAY /dev/md2 level=raid5 num-devices=4 UUID=eed65e3878:f4e6e055:198bdcfe:77de48

For the record:
/dev/md0 uses /dev/sd[abcdef]1
/dev/md1 uses /dev/sd[ab]2
/dev/md2 uses /dev/sd[cdef]2

On kernel 2.6.27.3, this worked fine.  After upgrading to 2.6.30, the
initrams failed with the error:

  mdadm: superblock on /dev/sdc2 doesn't match others - assembly aborted

The solution was to change the /etc/mdadm/mdadm.conf to specifically
list the metadata format:

DEVICE partitions
ARRAY /dev/md0 level=raid1 num-devices=6 UUID=dece84f3:a8f8be71:ea9d9fee:21fd5f90
ARRAY /dev/md1 level=raid1 num-devices=2 UUID=0598d2ea:f6c0185f:614fa502:109d1a5d
ARRAY /dev/md2 level=raid5 metadata=1.0 num-devices=4 UUID=eed65e3878:f4e6e055:198bdcfe:77de48

This was tested with Debian mdadm packages 2.6.7.2-1 and 2.6.9-3 -- no
difference.

So, is this a bug?  Kernel or mdadm?  If user error, why did it work
before?  Also, why does the metadata on /dev/md2 matter for assembling
/dev/md1?

This is a live system that I can't reboot easily.  Superblocks (from
the booted system) on /dev/md1 and /dev/md2 devices are below.

-jim

/dev/sda2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 0598d2ea:f6c0185f:614fa502:109d1a5d
  Creation Time : Fri Sep 22 06:18:16 2006
     Raid Level : raid1
  Used Dev Size : 976631424 (931.39 GiB 1000.07 GB)
     Array Size : 976631424 (931.39 GiB 1000.07 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Thu Jun 11 03:25:09 2009
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : e0ef73c6 - correct
         Events : 252219


      Number   Major   Minor   RaidDevice State
this     1       8        2        1      active sync   /dev/sda2

   0     0       8       18        0      active sync   /dev/sdb2
   1     1       8        2        1      active sync   /dev/sda2
/dev/sdb2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 0598d2ea:f6c0185f:614fa502:109d1a5d
  Creation Time : Fri Sep 22 06:18:16 2006
     Raid Level : raid1
  Used Dev Size : 976631424 (931.39 GiB 1000.07 GB)
     Array Size : 976631424 (931.39 GiB 1000.07 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Thu Jun 11 03:25:09 2009
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : e0ef73d4 - correct
         Events : 252219


      Number   Major   Minor   RaidDevice State
this     0       8       18        0      active sync   /dev/sdb2

   0     0       8       18        0      active sync   /dev/sdb2
   1     1       8        2        1      active sync   /dev/sda2
/dev/sdc2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : eed65e38:78f4e6e0:55198bdc:fe77de48
           Name : 2
  Creation Time : Thu Feb 22 02:28:12 2007
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953262752 (931.39 GiB 1000.07 GB)
     Array Size : 5859788160 (2794.16 GiB 3000.21 GB)
  Used Dev Size : 1953262720 (931.39 GiB 1000.07 GB)
   Super Offset : 1953263008 sectors
          State : active
    Device UUID : 407cf6b0:3d180e0b:e5be6dc0:e6bcf953

    Update Time : Thu Jun 11 03:25:09 2009
       Checksum : a59a2510 - correct
         Events : 10783

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 5 (failed, failed, failed, failed, 3, 0, 1, 2)
   Array State : Uuuu 4 failed
/dev/sdd2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : eed65e38:78f4e6e0:55198bdc:fe77de48
           Name : 2
  Creation Time : Thu Feb 22 02:28:12 2007
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953262752 (931.39 GiB 1000.07 GB)
     Array Size : 5859788160 (2794.16 GiB 3000.21 GB)
  Used Dev Size : 1953262720 (931.39 GiB 1000.07 GB)
   Super Offset : 1953263008 sectors
          State : clean
    Device UUID : df17e349:186715a7:3f7bd3f9:a53ce15d

    Update Time : Thu Jun 11 03:25:09 2009
       Checksum : 1ddb4ba4 - correct
         Events : 10782

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 6 (failed, failed, failed, failed, 3, 0, 1, 2)
   Array State : uUuu 4 failed
/dev/sde2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : eed65e38:78f4e6e0:55198bdc:fe77de48
           Name : 2
  Creation Time : Thu Feb 22 02:28:12 2007
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953262752 (931.39 GiB 1000.07 GB)
     Array Size : 5859788160 (2794.16 GiB 3000.21 GB)
  Used Dev Size : 1953262720 (931.39 GiB 1000.07 GB)
   Super Offset : 1953263008 sectors
          State : clean
    Device UUID : 324c496c:2a4a57c4:04a65638:0b9606c5

    Update Time : Thu Jun 11 03:25:09 2009
       Checksum : 32be735 - correct
         Events : 10782

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 7 (failed, failed, failed, failed, 3, 0, 1, 2)
   Array State : uuUu 4 failed
/dev/sdf2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : eed65e38:78f4e6e0:55198bdc:fe77de48
           Name : 2
  Creation Time : Thu Feb 22 02:28:12 2007
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953262752 (931.39 GiB 1000.07 GB)
     Array Size : 5859788160 (2794.16 GiB 3000.21 GB)
  Used Dev Size : 1953262720 (931.39 GiB 1000.07 GB)
   Super Offset : 1953263008 sectors
          State : clean
    Device UUID : 4d0e18c4:92574d6d:798f2111:18c93628

    Update Time : Thu Jun 11 03:25:09 2009
       Checksum : 3febd336 - correct
         Events : 10782

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 4 (failed, failed, failed, failed, 3, 0, 1, 2)
   Array State : uuuU 4 failed

