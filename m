From: Nathanial Byrnes <nate@qabal.org>
Subject: RAID5 recovery trouble, bd_claim failed?
Date: Sat, 15 Apr 2006 09:01:30 -0400
Message-ID: <1145106091.18173.18.camel@nemo.qabal.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,
	Recently I lost a disk in my raid5 SW array. It seems that it took a
second disk with it. The other disk appears to still be funtional (from
an fdisk perspective...). I am trying to get the array to work in
degraded mode via failed-disk in raidtab, but am always getting the
following error:

md: could not bd_claim hde.
md: autostart failed!

When I try to raidstart the array. Is it the case tha I had been running
in degraded mode before the disk failure, and then lost the other disk?
if so, how can I tell. 

I have been messing about with mkraid -R and I have tried to
add /dev/hdf (a new disk) back to the array. However, I am fairly
confident that I have not kicked off the recovery process, so I am
imagining that once I get the superblocks in order, I should be able to
recover to the new disk?

My system and raid config are:
Kernel 2.6.13.1
Slack 10.2
RAID 5 which originally looked like:
/dev/hde
/dev/hdg
/dev/hdi
/dev/hdk

but when I moved the disks to another box with fewer IDE controllers
/dev/hde
/dev/hdf
/dev/hdg
/dev/hdh

How should I approach this?

Below is the output of mdadm --examine /dev/hd*

Thanks in advance,
Nate

/dev/hde:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 38081921:59a998f9:64c1a001:ec534ef2
  Creation Time : Fri Aug 22 16:34:37 2003
     Raid Level : raid5
    Device Size : 78150656 (74.53 GiB 80.03 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Wed Apr 12 02:26:37 2006
          State : active
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 165c1b4c - correct
         Events : 0.37523832

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     1      33        0        1      active sync   /dev/hde

   0     0       0        0        0      removed
   1     1      33        0        1      active sync   /dev/hde
   2     2      34       64        2      active sync   /dev/hdh
   3     3      34        0        3      active sync   /dev/hdg

/dev/hdf:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 38081921:59a998f9:64c1a001:ec534ef2
  Creation Time : Fri Aug 22 16:34:37 2003
     Raid Level : raid5
    Device Size : 78150656 (74.53 GiB 80.03 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Wed Apr 12 02:26:37 2006
          State : active
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 165c1bc5 - correct
         Events : 0.37523832

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     3      33       64       -1      sync   /dev/hdf

   0     0       0        0        0      removed
   1     1      33        0        1      active sync   /dev/hde
   2     2      34       64        2      active sync   /dev/hdh
   3     3      33       64       -1      sync   /dev/hdf
/dev/hdg:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 38081921:59a998f9:64c1a001:ec534ef2
  Creation Time : Fri Aug 22 16:34:37 2003
     Raid Level : raid5
    Device Size : 78150656 (74.53 GiB 80.03 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Wed Apr 12 06:12:58 2006
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 3
  Spare Devices : 0
       Checksum : 1898e1fd - correct
         Events : 0.37523844

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     3      34        0        3      active sync   /dev/hdg

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2      34       64        2      active sync   /dev/hdh
   3     3      34        0        3      active sync   /dev/hdg
/dev/hdh:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 38081921:59a998f9:64c1a001:ec534ef2
  Creation Time : Fri Aug 22 16:34:37 2003
     Raid Level : raid5
    Device Size : 78150656 (74.53 GiB 80.03 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Wed Apr 12 06:12:58 2006
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 3
  Spare Devices : 0
       Checksum : 1898e23b - correct
         Events : 0.37523844

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     2      34       64        2      active sync   /dev/hdh

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2      34       64        2      active sync   /dev/hdh
   3     3      34        0        3      active sync   /dev/hdg


