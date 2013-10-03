From: Wakko Warner <wakko@animx.eu.org>
Subject: imsm identification problem.  mdadm 3.3
Date: Wed, 2 Oct 2013 22:23:19 -0400
Message-ID: <20131003022319.GA28770@animx.eu.org>
Reply-To: Wakko Warner <wakko@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Please keep me in CC.

I compiled v3.3 to see if the problem was still there.  It is.  The problem. 
I setup an imsm array with 2 volumes.  a 200mb raid10 volume, and a raid5 on
the remaining space.  This was done from the bios.

mdadm detected the array and volumes ok, but the names are wrong.  the 200mb
was named EFI and the other was named ani.

/dev/md127 is the imsm container.
       126 is the volume ani. (This is about 7tb.  disks are 3tb each and
still initializing)
       125 is the volume EFI.

According to --examine /dev/md127,
[EFI] UUID is ad256dcf:38ff8fed:8c27647e:24f61d81
[ani] UUID is 9fe3c18a:0e9e2d4f:613456ca:b9989dcc

However --detail --export /dev/md125 shows the name as ani with UUID
ad256dcf:38ff8fed:8c27647e:24f61d81 and --detail --export /dev/md126 shows
the name EFI with UUID 9fe3c18a:0e9e2d4f:613456ca:b9989dcc.

I did manually bring these up using mdadm 3.2.5-5 (Debian).  I don't remember
the exact commands off the top of my head, but they should be in my history if
needed.

Here's some output of various commands using mdadm 3.3:
# ./mdadm --detail --export /dev/md126
MD_LEVEL=raid5
MD_DEVICES=4
MD_CONTAINER=/dev/md127
MD_MEMBER=1
MD_UUID=9fe3c18a:0e9e2d4f:613456ca:b9989dcc
MD_DEVNAME=EFI
MD_DEVICE_sda_ROLE=0
MD_DEVICE_sda_DEV=/dev/sda
MD_DEVICE_sdb_ROLE=1
MD_DEVICE_sdb_DEV=/dev/sdb
MD_DEVICE_sdc_ROLE=2
MD_DEVICE_sdc_DEV=/dev/sdc
MD_DEVICE_sdd_ROLE=3
MD_DEVICE_sdd_DEV=/dev/sdd
# ./mdadm --detail --export /dev/md125
MD_LEVEL=raid10
MD_DEVICES=4
MD_CONTAINER=/dev/md127
MD_MEMBER=0
MD_UUID=ad256dcf:38ff8fed:8c27647e:24f61d81
MD_DEVNAME=ani
MD_DEVICE_sda_ROLE=0
MD_DEVICE_sda_DEV=/dev/sda
MD_DEVICE_sdb_ROLE=1
MD_DEVICE_sdb_DEV=/dev/sdb
MD_DEVICE_sdc_ROLE=2
MD_DEVICE_sdc_DEV=/dev/sdc
MD_DEVICE_sdd_ROLE=3
MD_DEVICE_sdd_DEV=/dev/sdd
# ./mdadm --detail --export /dev/md127
MD_LEVEL=container
MD_DEVICES=4
MD_METADATA=imsm
MD_UUID=201ddcce:1db6911a:255409fa:5d10b453
MD_DEVICE_sda_ROLE=spare
MD_DEVICE_sda_DEV=/dev/sda
MD_DEVICE_sdb_ROLE=spare
MD_DEVICE_sdb_DEV=/dev/sdb
MD_DEVICE_sdc_ROLE=spare
MD_DEVICE_sdc_DEV=/dev/sdc
MD_DEVICE_sdd_ROLE=spare
MD_DEVICE_sdd_DEV=/dev/sdd
# ./mdadm --examine /dev/md127
/dev/md127:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.3.00
    Orig Family : a644757f
         Family : a644757f
     Generation : 00000041
     Attributes : All supported
           UUID : 201ddcce:1db6911a:255409fa:5d10b453
       Checksum : b634b595 correct
    MPB Sectors : 2
          Disks : 4
   RAID Devices : 2

  Disk01 Serial : 9XK0FE2B
          State : active
             Id : 00000001
    Usable Size : 5860526862 (2794.52 GiB 3000.59 GB)

[EFI]:
           UUID : ad256dcf:38ff8fed:8c27647e:24f61d81
     RAID Level : 10
        Members : 4
          Slots : [UUUU]
    Failed disk : none
      This Slot : 1
     Array Size : 417792 (204.03 MiB 213.91 MB)
   Per Dev Size : 209160 (102.15 MiB 107.09 MB)
  Sector Offset : 0
    Num Stripes : 816
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : idle
      Map State : normal
    Dirty State : clean

[ani]:
           UUID : 9fe3c18a:0e9e2d4f:613456ca:b9989dcc
     RAID Level : 5 <-- 5
        Members : 4 <-- 4
          Slots : [UUUU] <-- [UUUU]
    Failed disk : none
      This Slot : 1
     Array Size : 16701927424 (7964.10 GiB 8551.39 GB)
   Per Dev Size : 5567309576 (2654.70 GiB 2850.46 GB)
  Sector Offset : 213256
    Num Stripes : 21747302
     Chunk Size : 128 KiB <-- 128 KiB
       Reserved : 0
  Migrate State : initialize
      Map State : normal <-- uninitialized
     Checkpoint : 505646 (1024)
    Dirty State : clean

  Disk00 Serial : 9XK0FBJA
          State : active
             Id : 00000000
    Usable Size : 5860526862 (2794.52 GiB 3000.59 GB)

  Disk02 Serial : 9XK0DQLC
          State : active
             Id : 00000002
    Usable Size : 5860526862 (2794.52 GiB 3000.59 GB)

  Disk03 Serial : 9XK0FFYD
          State : active
             Id : 00000003
    Usable Size : 5860526862 (2794.52 GiB 3000.59 GB)
#

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
