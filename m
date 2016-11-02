From: Robert LeBlanc <robert@leblancnet.us>
Subject: Issue with growing RAID10
Date: Wed, 2 Nov 2016 11:59:25 -0600
Message-ID: <CAANLjFrK25fUjMpif6m7y3PZ0phNa_zVLFWUVs2Yj1PtbkA_Qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We would like to add read performance to our RAID10 volume by adding
another drive (we don't care about space), so I did the following test
with poor results.

# mdadm --create /dev/md13 --level 10 --run --assume-clean -p n2
--raid-devices 2 /dev/loop{2..3}
mdadm: /dev/loop2 appears to be part of a raid array:
      level=raid10 devices=3 ctime=Wed Nov  2 11:25:22 2016
mdadm: /dev/loop3 appears to be part of a raid array:
      level=raid10 devices=3 ctime=Wed Nov  2 11:25:22 2016
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md13 started.

# mdadm --detail /dev/md13
/dev/md13:
       Version : 1.2
 Creation Time : Wed Nov  2 11:47:48 2016
    Raid Level : raid10
    Array Size : 10477568 (9.99 GiB 10.73 GB)
 Used Dev Size : 10477568 (9.99 GiB 10.73 GB)
  Raid Devices : 2
 Total Devices : 2
   Persistence : Superblock is persistent

   Update Time : Wed Nov  2 11:47:48 2016
         State : clean
Active Devices : 2
Working Devices : 2
Failed Devices : 0
 Spare Devices : 0

        Layout : near=2
    Chunk Size : 512K

          Name : rleblanc-pc:13  (local to host rleblanc-pc)
          UUID : 1eb66d7c:21308453:1e731c8b:1c43dd55
        Events : 0

   Number   Major   Minor   RaidDevice State
      0       7        2        0      active sync set-A   /dev/loop2
      1       7        3        1      active sync set-B   /dev/loop3

# mdadm /dev/md13 -a /dev/loop4
mdadm: added /dev/loop4

# mdadm --detail /dev/md13
/dev/md13:
       Version : 1.2
 Creation Time : Wed Nov  2 11:47:48 2016
    Raid Level : raid10
    Array Size : 10477568 (9.99 GiB 10.73 GB)
 Used Dev Size : 10477568 (9.99 GiB 10.73 GB)
  Raid Devices : 2
 Total Devices : 3
   Persistence : Superblock is persistent

   Update Time : Wed Nov  2 11:48:13 2016
         State : clean
Active Devices : 2
Working Devices : 3
Failed Devices : 0
 Spare Devices : 1

        Layout : near=2
    Chunk Size : 512K

          Name : rleblanc-pc:13  (local to host rleblanc-pc)
          UUID : 1eb66d7c:21308453:1e731c8b:1c43dd55
        Events : 1

   Number   Major   Minor   RaidDevice State
      0       7        2        0      active sync set-A   /dev/loop2
      1       7        3        1      active sync set-B   /dev/loop3

      2       7        4        -      spare   /dev/loop4

# mdadm --grow /dev/md13 -p n3 --raid-devices 3
mdadm: Cannot change number of copies when reshaping RAID10

I also tried to add the device, grow raid-devices, let it reshape,
then try to change the number of copies and it didn't like that
either. It would be nice to supply -p nX and --raid-devices X at the
same time to prevent the reshape and only copy the data over to the
new drive (or drop a drive out completely). I could see changing -p
separately or at a different rate of drives added/removed could be
difficult, but for lockstep changes, it seems that it would be rather
easy.

Any ideas?

Thanks,

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
