From: Graham King <linuxraid@tremagi.org.uk>
Subject: Q. Recovering concatenated array from disk images?
Date: Sat, 10 May 2008 00:07:09 +0100
Message-ID: <1210374429.27262.679.camel@oberon.tremagi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm trying to recover data for a friend from a failed external device
that appears to have used md to concatenate two 500GB drives.

Having extracted disk images from the failed device, and associated them
using losetup with /dev/loop0 and /dev/loop1, I'm now at the stage of
trying to concatenate the images.  As a newcomer to mdadm, I have some
concerns and would welcome good advice:

1) There appears to be a superblock on only one of the devices, so I
assume that I'll need to mdadm --build (rather than --assemble).
However --build comes with a dire warning in the man page...
Is --build the way to proceed?
Do I need any special options?

2) The output below refers to /dev/sd{a2,b}.  That was probably correct
for the device from which the disk images were gathered, but the Fedora
8 machine on which I'm trying to recover the data already has /dev/sda
and /dev/sdb.  I don't want to take any risks with the real disks.  How
can I ensure that mdadm reconstructs the array from /dev/loop0
and /dev/loop1 ?

Grateful for any light you can shed on this
-- Graham



[root@localhost ~]# mdadm --examine /dev/loop[01]
mdadm: No md superblock detected on /dev/loop0.
/dev/loop1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 163218f3:299b9ccc:3c666c38:60539313
  Creation Time : Fri Dec 31 19:00:02 1999
     Raid Level : linear
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Fri Dec 31 19:00:02 1999
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f6918bbe - correct
         Events : 0.1

       Rounding : 256K

      Number   Major   Minor   RaidDevice State
this     1       8       16        1      active sync   /dev/sdb

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       16        1      active sync   /dev/sdb

