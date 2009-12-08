From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: invalid bitmap magic on *just removed* device
Date: Tue, 8 Dec 2009 10:46:38 -0600
Message-ID: <cccedfc60912080846k6cdf4813j1017f3a480c1dc3b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I added a device, /dev/nbd0, to a level1 software raid.
After it was done recovering, I --failed and --remove the device.
Now mdadm -X claims the device has an invalid bitmap:


turnip:~ # mdadm -X /dev/nbd0
        Filename : /dev/nbd0
           Magic : 00007fee
mdadm: invalid bitmap magic 0x7fee, the bitmap file appears to be corrupted
         Version : 524288
mdadm: unknown bitmap version 524288, either the bitmap file is
corrupted or you need to upgrade your tools
turnip:~ #

kernel 2.6.31.5, openSUSE 11.2, mdadm 3.0.2 (25 Sep 09)

I seem to have encountered this before - as I recall, the remove and
then re-add the bitmap to the device while all components were
present.
NOTE: after the recovery finished, all 2 of 2 devices were present.

mdadm -X /dev/sde (the other device in the raid) looks like this:

        Filename : /dev/sde
           Magic : 6d746962
         Version : 4
            UUID : 75e9d8ba:47cfeb96:431070f1:84d3b1f3
          Events : 109186
  Events Cleared : 104694
           State : OK
       Chunksize : 256 KB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 72612988 (69.25 GiB 74.36 GB)
          Bitmap : 283645 bits (chunks), 4481 dirty (1.6%)


and mdadm --detail /dev/md12 looks like this:

/dev/md12:
        Version : 1.01
  Creation Time : Wed Jun 17 12:09:11 2009
     Raid Level : raid1
     Array Size : 72612988 (69.25 GiB 74.36 GB)
  Used Dev Size : 72612988 (69.25 GiB 74.36 GB)
   Raid Devices : 2
  Total Devices : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Tue Dec  8 10:41:20 2009
          State : active, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : turnip:12  (local to host turnip)
           UUID : 75e9d8ba:47cfeb96:431070f1:84d3b1f3
         Events : 109186

    Number   Major   Minor   RaidDevice State
       0       8       64        0      active sync   /dev/sde
       1       0        0        1      removed


Ideas?

-- 
Jon
