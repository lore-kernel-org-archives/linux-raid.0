From: Paul Chambers <paul@bod.org>
Subject: Fwd: problems attempting to grow raid5 to raid6 - advice sought
Date: Fri, 24 Nov 2017 18:54:43 -0800
Message-ID: <CALfMqR5DVqMOwNQwTPwb3y3OH7S-mKy-i=N1_SgvWfbRxbtarw@mail.gmail.com>
References: <CALfMqR47A=5usN-=6v3vUHAPYe-dFQ1Zxhuef0zZzRhXPcQQnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALfMqR47A=5usN-=6v3vUHAPYe-dFQ1Zxhuef0zZzRhXPcQQnQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(all the detailed info is at the end of this email)

I could use some expert help...

I started with a RAID-5 array of 5 x 6TB WD RED drives, and 1 x 6TB
Seagate Ironwolf drive. This has been running well for a long time as
a 5-drive array, and was grown to a 6 drive array a few months ago by
the addition of the ironwolf drive. No known issues.

  ### devices in order: 0   1   2   3   4   5
  DRIVES="sdj sdg sdf sdq sdc sdh"

I purchased 3 x 8TB WD Red drives, and used parted to set them up as
GPT, with a single partition that fills the drive.

I then added them to the array in the usual fashion:

~# mdadm --add /dev/md0 /dev/sdi /dev/sdk /dev/sdl

so now I had an array with three spares:

### device in order:
###      0   1   2   3   4   5   S   S   S
DRIVES="sdj sdg sdf sdq sdc sdh sdl sdi sdk"

I thought it was time to move from RAID-5 to RAID-6, given the
increasing number of drives. So I did:

~# mdadm --grow --level=6 --raid-devices=7 --backup-file=/root/raid5backup

so now 7 active and 2 spares, and the reshape starts:

### device in order:
###      0   1   2   3   4   5   6   S   S
DRIVES="sdj sdg sdf sdq sdc sdh sdl sdi sdk"

However, the reshape comes to a screeching halt at about 2.9GB in,
with the reshape process consuming 100% of one thread (on a 16 thread
box), but otherwise not apparently doing anything useful. After
several hours, nothing had changed, so time to intervene. I rebooted
it and restarted the reshape:

~# mdadm --grow --continue --backup-file=/root/raid5backup

looking at /proc/mdstat, mdadm --examine and --detail output showed no
activity again (over time). Checking the status of
mdadm-grow-continue@md0.service shows it had failed and wasn't
running, so I guess that's not surprising.

So I stopped the array and rebooted again. After consulting Google,
stopping the array and reassembling it was the next thing to try. It
did reassemble, but complained about the absence of metadata, despite
being passed the /root/raid5backup file. Turns out it's 20975616 bytes
of zeros. Great :(    Trying --invalid backup gave the same result.

After some more reading, the advice at this point was not to panic,
and to seek expert help on linux-raid mailing list. so here I am.

As you'll see below, all drives, superblocks, et al. appear to be in a
consistent state. No drives have failed. I seem to have the correct
mapping of raid device -> linux block device (and it 'looks
familiar'). The superblocks on the partitions appear to be consistent
with having started a reshape to go to RAID-6. Just looks like the
reshape process choked and span its wheels, and the 'backup file'
mechanism also failed.

What should I try next?

Thanks for reading this far. A little sage advice would be greatly appreciated.

- Paul

p.s. I've done large reshapes before without issue; has mdadm
regressed, or did I hit a corner case I haven't hit before?


Following this script is its output on the system in question. It's
missing the output of lsdrv (sorry), but it has multiple problems
running on my system, and I'm not proficient enough with python to fix
them all.

___________________the script___________________

#!/bin/sh

### in active device order:
###      0   1   2   3   4   5   6   S   S
DRIVES="sdj sdg sdf sda sdc sdh sdl sdi sdk"

echo "####### /etc/mdadm/mdadm.conf ######\n"
cat /etc/mdadm/mdadm.conf

echo "\n####### /proc/mdstat ######\n"
cat /proc/mdstat

for drive in ${DRIVES}
do
echo "\n###### /dev/${drive} ######\n"

smartctl -H -i -l scterc "/dev/${drive}"

mdadm --examine "/dev/${drive}"
mdadm --examine "/dev/${drive}1"
done

# multiple problems running this - skipped
# /opt/lsdrv/lsdrv

___________________the script's output follows___________________

####### /etc/mdadm/mdadm.conf ######

# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default (built-in), scan all partitions (/proc/partitions) and all
# containers for MD superblocks. alternatively, specify devices to scan, using
# wildcards if desired.
#DEVICE partitions containers

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays
ARRAY /dev/md/md0  metadata=1.2
UUID=a8ef01be:af3b5d36:1960b7fa:0e32129d name=vm.bod.org:md0
   spares=2

####### /proc/mdstat ######

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : inactive sdc1[5](S) sda1[4](S) sdl1[9](S) sdj1[0](S) sdg1[1](S)
sdf1[3](S) sdh1[6](S) sdk1[8](S) sdi1[7](S)
      58604036751 blocks super 1.2

unused devices: <none>

###### /dev/sdj ######

smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.13.4-1-pve] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD60EFRX-68MYMN1
Serial Number:    WD-WX11D741AYF7
LU WWN Device Id: 5 0014ee 260273712
Firmware Version: 82.00A82
User Capacity:    6,001,175,126,016 bytes [6.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5700 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Nov 24 18:01:48 2017 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdj:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : a8ef01be:af3b5d36:1960b7fa:0e32129d
           Name : vm.bod.org:md0
  Creation Time : Fri Mar 27 18:40:27 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720782848 (5588.90 GiB 6001.04 GB)
     Array Size : 29301957120 (27944.52 GiB 30005.20 GB)
    Data Offset : 259072 sectors
   Super Offset : 8 sectors
   Unused Space : before=258984 sectors, after=0 sectors
          State : clean
    Device UUID : 9db8972b:f327ed02:242644ce:d35bf0b1

  Reshape pos'n : 2332160 (2.22 GiB 2.39 GB)
     New Layout : left-symmetric

    Update Time : Thu Nov 23 21:15:35 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 47a6c9eb - correct
         Events : 3750549

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

###### /dev/sdg ######

smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.13.4-1-pve] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD60EFRX-68MYMN1
Serial Number:    WD-WX21DC43DJ8A
LU WWN Device Id: 5 0014ee 260e6a07e
Firmware Version: 82.00A82
User Capacity:    6,001,175,126,016 bytes [6.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5700 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Nov 24 18:01:48 2017 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdg:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : a8ef01be:af3b5d36:1960b7fa:0e32129d
           Name : vm.bod.org:md0
  Creation Time : Fri Mar 27 18:40:27 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720782848 (5588.90 GiB 6001.04 GB)
     Array Size : 29301957120 (27944.52 GiB 30005.20 GB)
    Data Offset : 259072 sectors
   Super Offset : 8 sectors
   Unused Space : before=258984 sectors, after=0 sectors
          State : clean
    Device UUID : 135b79f2:63b03889:73715d53:849f3f07

  Reshape pos'n : 2332160 (2.22 GiB 2.39 GB)
     New Layout : left-symmetric

    Update Time : Thu Nov 23 21:15:35 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 6f3c83d2 - correct
         Events : 3750549

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

###### /dev/sdf ######

smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.13.4-1-pve] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD60EFRX-68MYMN1
Serial Number:    WD-WX11DC4492K0
LU WWN Device Id: 5 0014ee 20b915d20
Firmware Version: 82.00A82
User Capacity:    6,001,175,126,016 bytes [6.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5700 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Nov 24 18:01:48 2017 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdf:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : a8ef01be:af3b5d36:1960b7fa:0e32129d
           Name : vm.bod.org:md0
  Creation Time : Fri Mar 27 18:40:27 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720782848 (5588.90 GiB 6001.04 GB)
     Array Size : 29301957120 (27944.52 GiB 30005.20 GB)
    Data Offset : 259072 sectors
   Super Offset : 8 sectors
   Unused Space : before=258984 sectors, after=0 sectors
          State : clean
    Device UUID : 205362ca:a06c7b99:5df2ee68:27e9dbe2

  Reshape pos'n : 2332160 (2.22 GiB 2.39 GB)
     New Layout : left-symmetric

    Update Time : Thu Nov 23 21:15:35 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 489602ac - correct
         Events : 3750549

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

###### /dev/sda ######

smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.13.4-1-pve] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD60EFRX-68MYMN1
Serial Number:    WD-WX21DC4D58C2
LU WWN Device Id: 5 0014ee 26111dd45
Firmware Version: 82.00A82
User Capacity:    6,001,175,126,016 bytes [6.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5700 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Nov 24 18:01:48 2017 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sda:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : a8ef01be:af3b5d36:1960b7fa:0e32129d
           Name : vm.bod.org:md0
  Creation Time : Fri Mar 27 18:40:27 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720782848 (5588.90 GiB 6001.04 GB)
     Array Size : 29301957120 (27944.52 GiB 30005.20 GB)
    Data Offset : 259072 sectors
   Super Offset : 8 sectors
   Unused Space : before=258984 sectors, after=0 sectors
          State : clean
    Device UUID : 572e4560:6fc1ce66:1f0f1b7b:8e9df63a

  Reshape pos'n : 2332160 (2.22 GiB 2.39 GB)
     New Layout : left-symmetric

    Update Time : Thu Nov 23 21:15:35 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 161303db - correct
         Events : 3750549

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

###### /dev/sdc ######

smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.13.4-1-pve] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD60EFRX-68MYMN1
Serial Number:    WD-WX11D15P33U3
LU WWN Device Id: 5 0014ee 2b739eeb3
Firmware Version: 82.00A82
User Capacity:    6,001,175,126,016 bytes [6.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5700 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Nov 24 18:01:48 2017 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdc:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : a8ef01be:af3b5d36:1960b7fa:0e32129d
           Name : vm.bod.org:md0
  Creation Time : Fri Mar 27 18:40:27 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720784015 (5588.91 GiB 6001.04 GB)
     Array Size : 29301957120 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720782848 (5588.90 GiB 6001.04 GB)
    Data Offset : 259072 sectors
   Super Offset : 8 sectors
   Unused Space : before=258984 sectors, after=1167 sectors
          State : clean
    Device UUID : 60fbc9d6:a0517f17:ee7a0f58:fb840ee7

  Reshape pos'n : 2332160 (2.22 GiB 2.39 GB)
     New Layout : left-symmetric

    Update Time : Thu Nov 23 21:15:35 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : c654b8e1 - correct
         Events : 3750549

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

###### /dev/sdh ######

smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.13.4-1-pve] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     ST6000VN0041-2EL11C
Serial Number:    ZA17VNX4
LU WWN Device Id: 5 000c50 0a330cb02
Firmware Version: SC61
User Capacity:    6,001,175,126,016 bytes [6.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-3 T13/2161-D revision 5
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Nov 24 18:01:48 2017 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdh:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : a8ef01be:af3b5d36:1960b7fa:0e32129d
           Name : vm.bod.org:md0
  Creation Time : Fri Mar 27 18:40:27 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 11720784015 (5588.91 GiB 6001.04 GB)
     Array Size : 29301957120 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720782848 (5588.90 GiB 6001.04 GB)
    Data Offset : 259072 sectors
   Super Offset : 8 sectors
   Unused Space : before=258984 sectors, after=1167 sectors
          State : clean
    Device UUID : dd6af6cd:48ac806f:49237934:2d449928

  Reshape pos'n : 2332160 (2.22 GiB 2.39 GB)
     New Layout : left-symmetric

    Update Time : Thu Nov 23 21:15:35 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 3376ea94 - correct
         Events : 3750549

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

###### /dev/sdl ######

smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.13.4-1-pve] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD80EFAX-68LHPN0
Serial Number:    7SGJPL7C
LU WWN Device Id: 5 000cca 252c796fa
Firmware Version: 83.H0A83
User Capacity:    8,001,563,222,016 bytes [8.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Nov 24 18:01:48 2017 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdl:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdl1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x6
     Array UUID : a8ef01be:af3b5d36:1960b7fa:0e32129d
           Name : vm.bod.org:md0
  Creation Time : Fri Mar 27 18:40:27 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 15627791360 (7451.91 GiB 8001.43 GB)
     Array Size : 29301957120 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720782848 (5588.90 GiB 6001.04 GB)
    Data Offset : 259072 sectors
   Super Offset : 8 sectors
Recovery Offset : 932864 sectors
   Unused Space : before=258984 sectors, after=3907008512 sectors
          State : clean
    Device UUID : 6afad6f7:6aa5ebe8:87fe3863:9ba36f10

  Reshape pos'n : 2332160 (2.22 GiB 2.39 GB)
     New Layout : left-symmetric

    Update Time : Thu Nov 23 21:15:35 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : d6471d66 - correct
         Events : 3750549

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

###### /dev/sdi ######

smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.13.4-1-pve] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD80EFAX-68LHPN0
Serial Number:    7SGJRABC
LU WWN Device Id: 5 000cca 252c799c7
Firmware Version: 83.H0A83
User Capacity:    8,001,563,222,016 bytes [8.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Nov 24 18:01:48 2017 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdi:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : a8ef01be:af3b5d36:1960b7fa:0e32129d
           Name : vm.bod.org:md0
  Creation Time : Fri Mar 27 18:40:27 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 15627791360 (7451.91 GiB 8001.43 GB)
     Array Size : 29301957120 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720782848 (5588.90 GiB 6001.04 GB)
    Data Offset : 259072 sectors
   Super Offset : 8 sectors
   Unused Space : before=258984 sectors, after=3907008512 sectors
          State : clean
    Device UUID : dcbd0263:4a2714f4:9cf669af:815c5a9e

  Reshape pos'n : 2332160 (2.22 GiB 2.39 GB)
     New Layout : left-symmetric

    Update Time : Thu Nov 23 21:15:35 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 26a8d7b0 - correct
         Events : 3750549

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : spare
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

###### /dev/sdk ######

smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.13.4-1-pve] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD80EFAX-68LHPN0
Serial Number:    7SGJREUC
LU WWN Device Id: 5 000cca 252c79a32
Firmware Version: 83.H0A83
User Capacity:    8,001,563,222,016 bytes [8.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Nov 24 18:01:48 2017 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdk:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdk1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : a8ef01be:af3b5d36:1960b7fa:0e32129d
           Name : vm.bod.org:md0
  Creation Time : Fri Mar 27 18:40:27 2015
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 15627791360 (7451.91 GiB 8001.43 GB)
     Array Size : 29301957120 (27944.52 GiB 30005.20 GB)
  Used Dev Size : 11720782848 (5588.90 GiB 6001.04 GB)
    Data Offset : 259072 sectors
   Super Offset : 8 sectors
   Unused Space : before=258984 sectors, after=3907008512 sectors
          State : clean
    Device UUID : 15bac9fb:a0b5d9bf:3c038d69:6741e885

  Reshape pos'n : 2332160 (2.22 GiB 2.39 GB)
     New Layout : left-symmetric

    Update Time : Thu Nov 23 21:15:35 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 2ce653c6 - correct
         Events : 3750549

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : spare
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)


--
http://about.me/paul.chambers
