From: Frederick Gnodtke <FGnodtke@cronosx.de>
Subject: Help with failed raid 5
Date: Sat, 04 May 2013 18:51:33 +0200
Message-ID: <51853C95.5030008@cronosx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I hope someone can help me with this as I am struggling with it since 
this morning.

The following scenario: I have a softwareraid 5 created using mdadm.
It consisted out of 5 Disks, each of them 2000GB with one as spare-drive.
The original mdadm.conf looked like this:

# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks.
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0666 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays

# This file was auto-generated on Mon, 19 Nov 2012 09:30:14 -0800
# by mkconf 3.1.4-1+8efb9d1+squeeze1
ARRAY /dev/md/0 metadata=1.2 spares=1 name=CronosR:0 
UUID=c008e97a:aacc7745:c8c49a31:08312d4e


Everything was fine until this morning I tried to open a file and got an 
I/O-Error. I rebooted the computer, stopped the raid, did an smartctl -t 
long on all drives belonging to the raid, but they all seem to run quiet 
well.
Reassembling it using mdadm --assemble --scan --force did not lead to 
anything so I tried to recreate it using "mdadm --create /dev/md0 
--assume-clean --raid-devices=5 --level=5 /dev/sd[abdef]
It created an array but there was no filesystem to mount.
fsck could not detect an filesystem and I didn't relocate any "bad 
blocks" as I was afraid this might reduce my chance to repair the raid 
to zero.

The original Superblocks of all disks befor recreating the array looked 
like this (The raid already failed when I captured this):

/dev/sdb:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : c008e97a:aacc7745:c8c49a31:08312d4e
            Name : CronosR:0  (local to host CronosR)
   Creation Time : Mon Nov 12 10:27:52 2012
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
      Array Size : 15628103680 (7452.06 GiB 8001.59 GB)
   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : eec2e852:30e9cbcf:d90a5e2c:e176ee4b

     Update Time : Sat May  4 02:48:00 2013
        Checksum : 4479154a - correct
          Events : 0

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : spare
    Array State : .AA.A ('A' == active, '.' == missing)
/dev/sdc:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : c008e97a:aacc7745:c8c49a31:08312d4e
            Name : CronosR:0  (local to host CronosR)
   Creation Time : Mon Nov 12 10:27:52 2012
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
      Array Size : 15628103680 (7452.06 GiB 8001.59 GB)
   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 703f0adc:b164366b:50653ead:7072d192

     Update Time : Sat May  4 02:48:00 2013
        Checksum : 30c86354 - correct
          Events : 0

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : spare
    Array State : .AA.A ('A' == active, '.' == missing)
/dev/sdd:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : c008e97a:aacc7745:c8c49a31:08312d4e
            Name : CronosR:0  (local to host CronosR)
   Creation Time : Mon Nov 12 10:27:52 2012
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
      Array Size : 15628103680 (7452.06 GiB 8001.59 GB)
   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 3995e1e8:3188f2a6:f2afb876:9e024359

     Update Time : Sat May  4 02:48:00 2013
        Checksum : 9537952 - correct
          Events : 836068

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 4
    Array State : .AA.A ('A' == active, '.' == missing)
/dev/sde:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : c008e97a:aacc7745:c8c49a31:08312d4e
            Name : CronosR:0  (local to host CronosR)
   Creation Time : Mon Nov 12 10:27:52 2012
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
      Array Size : 15628103680 (7452.06 GiB 8001.59 GB)
   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 27b14550:17bf2abe:14352207:93c20bd3

     Update Time : Sat May  4 02:48:00 2013
        Checksum : 9222113a - correct
          Events : 836068

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : .AA.A ('A' == active, '.' == missing)
/dev/sdf:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : c008e97a:aacc7745:c8c49a31:08312d4e
            Name : CronosR:0  (local to host CronosR)
   Creation Time : Mon Nov 12 10:27:52 2012
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
      Array Size : 15628103680 (7452.06 GiB 8001.59 GB)
   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 4bc817b1:8ac80143:798031df:caba2a52

     Update Time : Sat May  4 02:48:00 2013
        Checksum : cef9756a - correct
          Events : 836068

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : .AA.A ('A' == active, '.' == missing)

Is there any chance to recover the raid?
Has anybody any idea?
As I am just a poor student I didn't quiet have the money to do backups 
so my private data would be lost if the raid failed.

I would really appreciate your help!

Thank you all in advance,
Frederick Gnodtke

