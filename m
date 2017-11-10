From: Jun-Kai Teoh <kai.teoh@gmail.com>
Subject: RAID5 up, but one drive removed, one says spare building, what now?
Date: Thu, 9 Nov 2017 19:09:24 -0800
Message-ID: <CAA4aoFaEwv=EPcotAbjzkgXWoOFwxo2XAoMzN1Zfb62k4Fngxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I managed to get my RAID drive back up, content looks like it's still
there, but it's not resyncing or reshaping and my parity drive was
removed (I did it when I tried to get it back up).

So what should I do now? I'm afraid of doing anything else at this point.

/dev/md126:
        Version : 1.2
  Creation Time : Thu Jun 30 07:57:36 2016
     Raid Level : raid5
     Array Size : 23441323008 (22355.39 GiB 24003.91 GB)
  Used Dev Size : 3906887168 (3725.90 GiB 4000.65 GB)
   Raid Devices : 8
  Total Devices : 7
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu Nov  9 18:57:18 2017
          State : clean, FAILED
 Active Devices : 6
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

  Delta Devices : 1, (7->8)

           Name : livingrm-server:2  (local to host livingrm-server)
           UUID : f7333d4f:8300969d:55148d64:93c8afc8
         Events : 650582

    Number   Major   Minor   RaidDevice State
       0       8      112        0      active sync   /dev/sdh
       1       8       48        1      active sync   /dev/sdd
       7       8       64        2      spare rebuilding   /dev/sde
       3       8       96        3      active sync   /dev/sdg
       4       8       32        4      active sync   /dev/sdc
       5       8       80        5      active sync   /dev/sdf
       6       8       16        6      active sync   /dev/sdb
      14       0        0       14      removed
