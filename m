From: John McNulty <johnmcn1@googlemail.com>
Subject: mirrors not forming at reboot (sometimes)
Date: Wed, 4 Nov 2009 15:36:55 +0000
Message-ID: <ab50889f0911040736j4be43d4eq686402ab0f467126@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'd like some advise please on how to troubleshoot this further.   I
have 4 x HP DL580 servers configured with dual P400 smart array
controller cards and I'm using MD Raid to mirror two partitions for
/boot and the LVM system volume group across both controllers.
They're all running kernel 2.6.18-128.1.14.el5 and mdadm-2.6.4-1.el5.
Their hardware and patch levels are identical.

3 of the servers are fine, but one of them will occasionally fail to
construct the mirrors on reboot and I'm scratching my head as to why.
It's always the disk partitions from the same controller that are
missing.  They add in afterwards ok and then everything runs fine
until the system reboots.  The systems aren't out of development and
in production just yet, so they get rebooted more frequently than they
would normally.

Lacking any evidence as to why this might be I've bumped up the kernel
logging level at boot time to as high as it will go so I can see the
following.   The first example - from another system - is what it
should look like when it works properly.


On sdorac2a  (good)

Nov  4 13:49:52 sdorac2a kernel: md: Autodetecting RAID arrays.
Nov  4 13:49:52 sdorac2a kernel: md: autorun ...
Nov  4 13:49:52 sdorac2a kernel: md: considering cciss/c1d0p2 ...
Nov  4 13:49:52 sdorac2a kernel: md:  adding cciss/c1d0p2 ...
Nov  4 13:49:52 sdorac2a kernel: md: cciss/c1d0p1 has different UUID
to cciss/c1d0p2
Nov  4 13:49:52 sdorac2a kernel: md:  adding cciss/c0d0p2 ...
Nov  4 13:49:52 sdorac2a kernel: md: cciss/c0d0p1 has different UUID
to cciss/c1d0p2
Nov  4 13:49:52 sdorac2a kernel: md: created md1
Nov  4 13:49:52 sdorac2a kernel: md: bind<cciss/c0d0p2>
Nov  4 13:49:52 sdorac2a kernel: md: bind<cciss/c1d0p2>
Nov  4 13:49:52 sdorac2a kernel: md: running: <cciss/c1d0p2><cciss/c0d0p2>
Nov  4 13:49:52 sdorac2a kernel: raid1: raid set md1 active with 2 out
of 2 mirrors
Nov  4 13:49:52 sdorac2a kernel: md: considering cciss/c1d0p1 ...
Nov  4 13:49:52 sdorac2a kernel: md:  adding cciss/c1d0p1 ...
Nov  4 13:49:52 sdorac2a kernel: md:  adding cciss/c0d0p1 ...
Nov  4 13:49:52 sdorac2a kernel: md: created md0
Nov  4 13:49:52 sdorac2a kernel: md: bind<cciss/c0d0p1>
Nov  4 13:49:52 sdorac2a kernel: md: bind<cciss/c1d0p1>
Nov  4 13:49:53 sdorac2a kernel: md: running: <cciss/c1d0p1><cciss/c0d0p1>
Nov  4 13:49:53 sdorac2a kernel: raid1: raid set md0 active with 2 out
of 2 mirrors
Nov  4 13:49:53 sdorac2a kernel: md: ... autorun DONE.


And then the same for the system displaying the problem

On sdorac4b   (bad)

Nov  4 10:53:09 sdorac4b kernel: md: Autodetecting RAID arrays.
Nov  4 10:53:09 sdorac4b kernel: md: autorun ...
Nov  4 10:53:09 sdorac4b kernel: md: considering cciss/c0d0p2 ...
Nov  4 10:53:09 sdorac4b kernel: md:  adding cciss/c0d0p2 ...
Nov  4 10:53:09 sdorac4b kernel: md: cciss/c0d0p1 has different UUID
to cciss/c0d0p2
Nov  4 10:53:09 sdorac4b kernel: md: created md1
Nov  4 10:53:09 sdorac4b kernel: md: bind<cciss/c0d0p2>
Nov  4 10:53:09 sdorac4b kernel: md: running: <cciss/c0d0p2>
Nov  4 10:53:09 sdorac4b kernel: raid1: raid set md1 active with 1 out
of 2 mirrors
Nov  4 10:53:09 sdorac4b kernel: md: considering cciss/c0d0p1 ...
Nov  4 10:53:09 sdorac4b kernel: md:  adding cciss/c0d0p1 ...
Nov  4 10:53:09 sdorac4b kernel: md: created md0
Nov  4 10:53:09 sdorac4b kernel: md: bind<cciss/c0d0p1>
Nov  4 10:53:09 sdorac4b kernel: md: running: <cciss/c0d0p1>
Nov  4 10:53:09 sdorac4b kernel: raid1: raid set md0 active with 1 out
of 2 mirrors
Nov  4 10:53:09 sdorac4b kernel: md: ... autorun DONE.

It doesn't seem to even attempt to sniff out the md devices on
cciss/c1 at all.   When booted mdadm shows the missing device as being
removed.

[root@sdorac4b ~]# mdadm -QD /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Tue Jun 30 15:56:16 2009
     Raid Level : raid1
     Array Size : 305088 (297.99 MiB 312.41 MB)
  Used Dev Size : 305088 (297.99 MiB 312.41 MB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Nov  4 10:52:23 2009
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           UUID : 1e7d74f0:e7a63d85:bf9c3cc3:a1716192
         Events : 0.100

    Number   Major   Minor   RaidDevice State
       0     104        1        0      active sync   /dev/cciss/c0d0p1
       1       0        0        1      removed


But the UUID number for the missing device is the same, so surely when
it sniffs around for this UUID at boot time it should find and try the
missing device too:

#  mdadm -Esb /dev/cciss/c1d0p1
ARRAY /dev/md0 level=raid1 num-devices=2
UUID=1e7d74f0:e7a63d85:bf9c3cc3:a1716192


Same for the second raid device ...

[root@sdorac4b ~]# mdadm -QD /dev/md1
/dev/md1:
        Version : 00.90.03
  Creation Time : Tue Jun 30 15:55:49 2009
     Raid Level : raid1
     Array Size : 143026624 (136.40 GiB 146.46 GB)
  Used Dev Size : 143026624 (136.40 GiB 146.46 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Wed Nov  4 15:27:03 2009
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           UUID : 38ea2ec7:eb1ea6b1:0fb9225f:defc1e17
         Events : 0.622028

    Number   Major   Minor   RaidDevice State
       0     104        2        0      active sync   /dev/cciss/c0d0p2
       1       0        0        1      removed


# mdadm -Esb /dev/cciss/c1d0p2
ARRAY /dev/md1 level=raid1 num-devices=2
UUID=38ea2ec7:eb1ea6b1:0fb9225f:defc1e17


Can anyone suggest anything else I can set/try to get more
information, or have insights based on previous experience?

Thanks,

John
