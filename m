From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: raid1 + writemostly
Date: Mon, 15 Dec 2008 12:30:31 -0600
Message-ID: <cccedfc60812151030y630bb6c3g40a926bced2b1c09@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

According to the manpage for mdadm, --write-mostly can only be used
add build, create, or add time.  How does one set write-mostly devices
*after* they've been added?

mdadm /dev/mdX --write-mostly /dev/someDevice
succeeds but does nothing.

According to Documentation/md.txt, writing writemostly into
/sys/block/mdX/md/dev-someDevice/state
should do it, and it sort of appears to:

turnip:~ # mdadm --detail /dev/md11
/dev/md11:
        Version : 01.00.03
  Creation Time : Mon Dec 15 07:06:13 2008
     Raid Level : raid1
     Array Size : 78123988 (74.50 GiB 80.00 GB)
  Used Dev Size : 156247976 (149.01 GiB 160.00 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 11
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Mon Dec 15 12:21:20 2008
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : turnip:11
           UUID : cf24d099:9e174a79:2a2f6797:dcff1420
         Events : 3840

    Number   Major   Minor   RaidDevice State
       2      43        0        0      active sync   /dev/nbd0
       3       8        0        1      active sync   /dev/sda
turnip:~ # echo writemostly > /sys/block/md11/md/dev-nbd0/state
turnip:~ # mdadm --detail /dev/md11
/dev/md11:
        Version : 01.00.03
  Creation Time : Mon Dec 15 07:06:13 2008
     Raid Level : raid1
     Array Size : 78123988 (74.50 GiB 80.00 GB)
  Used Dev Size : 156247976 (149.01 GiB 160.00 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 11
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Mon Dec 15 12:23:05 2008
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : turnip:11
           UUID : cf24d099:9e174a79:2a2f6797:dcff1420
         Events : 3840

    Number   Major   Minor   RaidDevice State
       2      43        0        0      active sync writemostly   /dev/nbd0
       3       8        0        1      active sync   /dev/sda
turnip:~ # mdadm --examine-bitmap /dev/nbd0
        Filename : /dev/nbd0
           Magic : 6d746962
         Version : 4
            UUID : cf24d099:9e174a79:2a2f6797:dcff1420
          Events : 3840
  Events Cleared : 3840
           State : OK
       Chunksize : 4 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 78123988 (74.50 GiB 80.00 GB)
          Bitmap : 19074 bits (chunks), 0 dirty (0.0%)
turnip:~ #


Why doesn't --examine-bitmap show the right mode?

Also, removing the bitmap from the array does not zero out the bitmap
on the actual device. Shouldn't it do that?
turnip:~ # mdadm --grow /dev/md11 --bitmap=none
turnip:~ # mdadm --examine-bitmap /dev/nbd0
        Filename : /dev/nbd0
           Magic : 6d746962
         Version : 4
            UUID : cf24d099:9e174a79:2a2f6797:dcff1420
          Events : 3841
  Events Cleared : 3841
           State : OK
       Chunksize : 4 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 78123988 (74.50 GiB 80.00 GB)
          Bitmap : 19074 bits (chunks), 0 dirty (0.0%)
turnip:~ #

This is with mdadm 2.6.4 on 2.6.25.18-0.2-default
I can try mdadm 3.0 if you like.

-- 
Jon
