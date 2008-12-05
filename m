From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: raid1 and write-mostly
Date: Fri, 5 Dec 2008 10:40:56 -0600
Message-ID: <cccedfc60812050840g70dcf94vd3740c5ff863b678@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I built a level1 raid using a real local device and a network block device.
I specified --bitmap=internal and --write-mostly, --write-behind for
the network block device.
However, when stracing the nbd-server process for this network block
device, I see *reads* more than periodically. One way to get lots of
reads sent to the nbd0 is to fsck /dev/md10.

Why? I know it's called write *mostly* but still it's doing more reads
that I expected (more than 0).

kernel: 2.6.25.18-0.2-default on x86_64, openSUSE 11.0 fully up-to-date.

Here is my --detail:

/dev/md10:
        Version : 00.90.03
  Creation Time : Fri Dec  5 07:44:41 2008
     Raid Level : raid1
     Array Size : 78123968 (74.50 GiB 80.00 GB)
  Used Dev Size : 78123968 (74.50 GiB 80.00 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 10
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Fri Dec  5 10:20:49 2008
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 542a0986:dd465da6:b224af07:ed28e4e5
         Events : 0.378

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/sdd1
       1      43        0        1      active sync   /dev/nbd0

and the result of mdadm --examine-bitmap /dev/nbd0

        Filename : /dev/nbd0
           Magic : 6d746962
         Version : 4
            UUID : 542a0986:dd465da6:b224af07:ed28e4e5
          Events : 378
  Events Cleared : 378
           State : OK
       Chunksize : 256 KB
          Daemon : 5s flush period
      Write Mode : Allow write behind, max 256
       Sync Size : 78123968 (74.50 GiB 80.00 GB)
          Bitmap : 305172 bits (chunks), 0 dirty (0.0%)


-- 
Jon
