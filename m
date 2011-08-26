From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: RAID1, changed disk, 2nd has errors ...
Date: Fri, 26 Aug 2011 13:46:41 +0200
Message-ID: <4E5787A1.7080807@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Please help:

Today I removed a defective hdd out of a RAID1-array and swapped in a
new hdd instead.

3 arrays, to be true, md[012]

0 and 1 synced fine, in the process of syncing md2 the old sda threw
errors (in sda4):

md/raid1:md2: sda: unrecoverable I/O read error for block 643686144
md: md2: recovery done.

[...]

md/raid1:md2: sda: unrecoverable I/O read error for block 643686272

----

Did the system stop syncing or is "recovery done" the indication that
md2 was fully recovered BEFORE the system threw sda4 out of the array??

I hope for the second!

See:

# mdadm -D /dev/md2
/dev/md2:
        Version : 0.90
  Creation Time : Thu Feb 11 19:40:11 2010
     Raid Level : raid1
     Array Size : 962454080 (917.87 GiB 985.55 GB)
  Used Dev Size : 962454080 (917.87 GiB 985.55 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Fri Aug 26 13:40:55 2011
          State : clean, degraded
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1

           UUID : 0ee7bbc7:fc6b0172:d195d856:5f94e963
         Events : 0.1833443

    Number   Major   Minor   RaidDevice State
       0       8        4        0      active sync   /dev/sda4
       1       0        0        1      removed

       2       8       20        -      spare   /dev/sdb4

# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sdb3[1] sda3[0]
      13679232 blocks [2/2] [UU]

md2 : active raid1 sdb4[2](S) sda4[0]
      962454080 blocks [2/1] [U_]

md0 : active raid1 sdb1[1] sda1[0]
      128384 blocks [2/2] [UU]

unused devices: <none>

----

The system seems to work OK, md2 which is a PV in a LVM-volumegroup is
there, etc

I just wonder if should somehow re-add sda4 or not touch a thing until I
have a new hdd at hand??

Can/should I somehow test the integrity of md2?

Pls help me to relax in this case ...

btw:

Linux version 2.6.36-gentoo-r5
mdadm-3.1.4

Thanks in advance, Stefan!


