From: Sean Harris <sean@backblaze.com>
Subject: Converting a .90 raid superblock to version 1.0 and whether--size parameter is needed
Date: Tue, 17 Mar 2015 15:49:36 -0700
Message-ID: <149825A6-89BC-4804-915B-5241EEB15300@backblaze.com>
References: <21CFD7CC-7A05-4298-BD77-E1287B9F78D5@backblaze.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21CFD7CC-7A05-4298-BD77-E1287B9F78D5@backblaze.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Hi Neil and company,

I have roughly a hundred machines that are still on Debian 5 that are slated for OS upgrades, and a great many of those are running software raid with the 00.90 version superblock. I even have a few machines on debian 7 with the .90 superblock because the boot drive for the machine had been replaced at some point.

I would like to explore the idea of upgrading/converting the raid superblock on many of those machines to version 1.0, mostly to keep the environment as uniform as possible, and standardize training for my SysAdmins on re-assembling failed raid arrays.
But I am not sure if it is a safe and necessary, or even a worthwhile endeavor.

I wanted to test this on a few non-production machines, but I am not quite sure if I need to specify the --size parameter in the create statement in the attempt.

I have a bit of a mixed environment, but very early on, the machines initialized with the .90 superblock were all created in the same way ie:

/sbin/mdadm --create /dev/md10 --bitmap=internal --auto=yes -l 6 -n 15 /dev/sd{b,e,h,k,n,q,t,w,z,ac,af,ai,al,ao,ar}1


Most of the machines I am interested in upgrading are running Debian 5, with LVM and ext4 volumes.
Some machines use drive partitions, but we stopped using them some time ago and went with the simple notion that if a drive brand was marketed as 1TB, we assumed a size of 1,000,000,000,000 bytes and created the array with that size. That way, any drive manufacturer could be used as a replacement spare without worrying about the variation of their respective drive sizes.

I think it is safe to upgrade the superblock from .90 to 1.0 because from what I have read, it is the same size, and in the same place as the .90 superblock.
But I don't know if having drives with or without partitions would make a difference, or if the conversion would need a specific version of mdadm utilized.
(My hunch is that any layers on top of the raid array are irrelevant to the superblock conversion).

All arrays are raid 6 with the same number of devices.
I think what I need to run is something akin to

/sbin/mdadm --create /dev/md10 -l6  -c64 --metadata=1.0 --assume-clean -n 15 /dev/sd{b,e,h,k,n,q,t,w,z,ac,af,ai,al,ao,ar}1

Where md10 is the array, the raid level is 6, 64k chunk size, assume-clean (for a known good pre-existing array), 15 devices (all specified in order), and a metadata of 1.0.

But I am not sure if I need to insure that --size is calculated and included in the conversion, or if the re-creation of the superblock simply takes care of it.

The reason I am unsure on this point is that with version 1.0 superblock arrays, I always include the --size parameter when re-creating the array with a specified list of devices, which is normally the Used_Dev_Size of the array, divided by 2, (since the value reported by mdadm is 512 byte sectors).

I am including some information from my test pod. In the case below, there are only 9 devices per array. (But all of my production conversions will be with 15 devices).

So here are my questions:
Am I correct in presuming the conversion will work and simply put-in-place an upgraded superblock?
Also, that it is unnecessary to specify --size for the create command (in this case).
And also, that I need not worry about the version of mdadm used for the conversion? (in my case it will almost exclusively be version v2.6.7.2 on Debian 5 , or mdadm - v3.2.5 - 18th May 2012 on Debian 7.)
Other than reading the superblock version after the conversion, is there any other way of verifying the conversion was successful without causing harm?
(my thoughts were to run FULL raid checks and filesystem checks, and some crc checks to some files).

Also, assuming I am on the right track and nothing can go wrong, are there any specific recommendations you have for going ahead with the conversions? Or even a recommendation to avoid this endeavor?

Thanks for your feedback,

Sean Harris 


Example from my test machine:

debian_version
5.0.10
proc/version 
Linux version 2.6.32-bpo.5-amd64 (Debian 2.6.32-35~bpo50+1) (norbert@tretkowski.de) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Wed Jul 20 09:10:04 UTC 2011
mdadm -V
mdadm - v2.6.7.2 - 14th November 2008


mdadm -D /dev/md10
/dev/md10:
        Version : 00.90
  Creation Time : Tue Jul 26 14:59:59 2011
     Raid Level : raid6
     Array Size : 6768384448 (6454.83 GiB 6930.83 GB)
  Used Dev Size : 966912064 (922.12 GiB 990.12 GB)
   Raid Devices : 9
  Total Devices : 9
Preferred Minor : 10
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Mar 11 15:23:13 2015
          State : active
 Active Devices : 9
Working Devices : 9
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 64K

           UUID : fed610e8:0c049d1e:5ab03808:ccff85b7
         Events : 0.137116

    Number   Major   Minor   RaidDevice State
       0       8      161        0      active sync   /dev/sdk1
       1      65      145        1      active sync   /dev/sdz1
       2      65       65        2      active sync   /dev/sdu1
       3      65      241        3      active sync   /dev/sdaf1
       4      66       65        4      active sync   /dev/sdak1
       5       8       81        5      active sync   /dev/sdf1
       6       8      241        6      active sync   /dev/sdp1
       7      66      145        7      active sync   /dev/sdap1
       8       8        1        8      active sync   /dev/sda1

mdadm -E /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : fed610e8:0c049d1e:5ab03808:ccff85b7
  Creation Time : Tue Jul 26 14:59:59 2011
     Raid Level : raid6
  Used Dev Size : 966912064 (922.12 GiB 990.12 GB)
     Array Size : 6768384448 (6454.83 GiB 6930.83 GB)
   Raid Devices : 9
  Total Devices : 9
Preferred Minor : 10

    Update Time : Wed Mar 11 17:24:13 2015
          State : clean
Internal Bitmap : present
 Active Devices : 9
Working Devices : 9
 Failed Devices : 0
  Spare Devices : 0
       Checksum : b88cefe6 - correct
         Events : 137124

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     8       8        1        8      active sync   /dev/sda1

   0     0       8      161        0      active sync   /dev/sdk1
   1     1      65      145        1      active sync   /dev/sdz1
   2     2      65       65        2      active sync   /dev/sdu1
   3     3      65      241        3      active sync   /dev/sdaf1
   4     4      66       65        4      active sync   /dev/sdak1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8      241        6      active sync   /dev/sdp1
   7     7      66      145        7      active sync   /dev/sdap1
   8     8       8        1        8      active sync   /dev/sda1

 smartctl -i /dev/sda
smartctl 5.41.patched_20110818 2011-06-09 r3365 [x86_64-linux-2.6.32-bpo.5-amd64] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Green
Device Model:     WDC WD10EACS-65D6B0
Serial Number:    WD-WCAU42439281
LU WWN Device Id: 5 0014ee 201f62eb1
Firmware Version: 01.01A01
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Wed Mar 11 17:28:06 2015 PDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

fdisk -l /dev/sda

WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1      120375   966912156   fd  Linux raid autodetect

lvscan
  ACTIVE            '/dev/vg0070035/lv0070035' [6.30 TB] inherit
  ACTIVE            '/dev/vg0070034/lv0070034' [6.30 TB] inherit
  ACTIVE            '/dev/vg0070033/lv0070033' [6.30 TB] inherit
  ACTIVE            '/dev/vg0070032/lv0070032' [6.30 TB] inherit
  ACTIVE            '/dev/vg0070031/lv0070031' [6.30 TB] inherit