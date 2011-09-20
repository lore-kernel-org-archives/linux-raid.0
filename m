From: Jim Schatzman <james.schatzman@futurelabusa.com>
Subject: Re: RAID1 with MBR and GPT fails to auto-assemble during boot
Date: Mon, 19 Sep 2011 18:28:05 -0600
Message-ID: <20110920002808.C0308581F7A@mail.futurelabusa.com>
References: <CAC_HdUr9DHt9uQGj=zJcgGvTknckfhyykDBX11XgX+wgOhHQUg@mail.gmail.com>
 <6385457414268580907@unknownmsgid>
 <CAC_HdUrFADb1G-5cos4foKohv8B=B0-pA=O8nbGnSX4z7mWcKg@mail.gmail.com>
 <j52fep$jj2$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j52fep$jj2$1@dough.gmane.org>
References: <CAC_HdUr9DHt9uQGj=zJcgGvTknckfhyykDBX11XgX+wgOhHQUg@mail.gmail.com>
 <6385457414268580907@unknownmsgid>
 <CAC_HdUrFADb1G-5cos4foKohv8B=B0-pA=O8nbGnSX4z7mWcKg@mail.gmail.com>
 <j52fep$jj2$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a RAID1 array with 2 partitions. One partition is on an MBR drive and one is on a GPT drive.

When I reboot, only the MBR drive has been assembled.

Using

mdadm /dev/md1 --add /dev/sdc1

mdadm reports that the drive is "readded" and syncing proceeds without difficulty. Reboot, and the array again
shows up with only one drive.

This array contains an LVM containing the system partition.  mdadm.conf contains
--------------------------------------------------------
#
# PLEASE DO NOT MODIFY THIS CONFIGURATION FILE!
#   This configuration file was auto-generated
#   by Openfiler. Please do not modify it.
#
# Generated at: Sun Nov 1 19:28:17 MST 2009
#

DEVICE partitions
ARRAY /dev/md8 UUID=066bd3ee:b35a0f59:d111a4d2:91b551e6
ARRAY /dev/md7 UUID=8245e0c8:aeb40213:7d63f449:7e79d5c0
ARRAY /dev/md6 UUID=78d87cc4:4e8dfa53:6da2eef9:a1dfa4c3
ARRAY /dev/md5 UUID=b282fd35:d6ce1cb8:9747d521:9d1e8e97
ARRAY /dev/md1 UUID=21b91d6f:e97bf1e3:ef6fdcec:d6c4a58e
PROGRAM /opt/openfiler/bin/mdalert 
--------------------------------------------------------------

dmesg shows

[    5.415275] md: Autodetecting RAID arrays.
[    5.415509] md: Scanned 1 and added 1 devices.
[    5.415514] md: autorun ...
[    5.415519] md: considering sda1 ...
[    5.415535] md:  adding sda1 ...
[    5.415541] md: created md1
[    5.415546] md: bind<sda1>
[    5.415572] md: running: <sda1>
[    5.416220] raid1: raid set md1 active with 1 out of 2 mirrors
[    5.416395] md: ... autorun DONE.
[    5.416861] md: Autodetecting RAID arrays.
[    5.416867] md: Scanned 0 and added 0 devices.
[    5.416872] md: autorun ...
[    5.416876] md: ... autorun DONE.
[    5.417349] md: Autodetecting RAID arrays.
[    5.417357] md: Scanned 0 and added 0 devices.
[    5.417362] md: autorun ...
[    5.417365] md: ... autorun DONE.
[    5.417829] md: Autodetecting RAID arrays.
[    5.417836] md: Scanned 0 and added 0 devices.
[    5.417840] md: autorun ...
[    5.417844] md: ... autorun DONE.
[    5.418296] md: Autodetecting RAID arrays.
[    5.418303] md: Scanned 0 and added 0 devices.
[    5.418307] md: autorun ...
[    5.418311] md: ... autorun DONE.


Later on, it assembles /dev/md5 to /dev/md8 without difficulty, even though one of the disk partitions from each is on the GPT drive.

This is Openfiler with kernel 2.6.29.6 and mdadm version 2.6.4.

Previously, when /dev/sdc was partitioned MBR, there was no problem with assembling the RAID1 array.

Output of mdadm -E for /dev/sda1 and /dev/sdc1 is

/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 21b91d6f:e97bf1e3:ef6fdcec:d6c4a58e
  Creation Time : Sat Oct 31 14:27:53 2009
     Raid Level : raid1
  Used Dev Size : 9767424 (9.31 GiB 10.00 GB)
     Array Size : 9767424 (9.31 GiB 10.00 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Mon Sep 19 18:22:14 2011
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 148e96a2 - correct
         Events : 0.6224


      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       33        1      active sync   /dev/sdc1




/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 21b91d6f:e97bf1e3:ef6fdcec:d6c4a58e
  Creation Time : Sat Oct 31 14:27:53 2009
     Raid Level : raid1
  Used Dev Size : 9767424 (9.31 GiB 10.00 GB)
     Array Size : 9767424 (9.31 GiB 10.00 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Mon Sep 19 18:24:14 2011
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 148e973c - correct
         Events : 0.6224


      Number   Major   Minor   RaidDevice State
this     1       8       33        1      active sync   /dev/sdc1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       33        1      active sync   /dev/sdc1


Why does Linux fail to auto-assemble /dev/md1 during boot and how do I fix the problem?


Thanks!

Jim



