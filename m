From: "Carl Jones" <lists@outervoid.net>
Subject: 2.4 and --grow?
Date: Fri, 14 Oct 2005 16:13:17 +1300 (NZDT)
Message-ID: <61204.60.234.162.14.1129259597.squirrel@mail.react.net.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have an md0 device that looks like this:

# ./mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Fri Jun 17 17:17:14 2005
     Raid Level : raid1
     Array Size : 104320 (101.88 MiB 106.82 MB)
    Device Size : 104320 (101.88 MiB 106.82 MB)
   Raid Devices : 1
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Oct 13 19:55:44 2005
          State : active
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1

           UUID : b14b31de:655cdb2c:07606b49:92d6caf2
         Events : 0.60

    Number   Major   Minor   RaidDevice State
       0       3        1        0      active sync   /dev/hda1

       1       3       65        1      spare   /dev/hdb1

I want to make the spare device active. I'm using:

./mdadm --grow /dev/md0 --raid-disks=2

I'm using mdadm 1.9.0 (compiled from source). Kernel is 2.4.21-15.0.3.EL.

Am I using the proper command line options? Will I need a 2.6 kernel?

Any help much appreciated.

Regards,

Carl

