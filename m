From: William Morgan <therealbrewer@gmail.com>
Subject: Re: Grow array and convert from raid 5 to 6
Date: Mon, 2 Mar 2020 17:57:03 -0600
Message-ID: <CALc6PW5RuDMk3YAc24FcAeXR1=rPd2tuSrTcWw3a8Vk6Otfd9w@mail.gmail.com>
References: <CALc6PW7C30Z6bccQLXLPf8zYuM=aBVZ_hLgW3i5gqZFVsLRpfA@mail.gmail.com>
 <fa393999-3f56-0bcf-b097-462a209f1eae@youngman.org.uk> <20200302004806.54852908@natsu>
 <cf69979e-8df7-31f4-a2f0-a6187aef6f6d@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cf69979e-8df7-31f4-a2f0-a6187aef6f6d@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: antlists <antlists@youngman.org.uk>
Cc: Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, while I was contemplating my options, a power outage caused my
array to fail to a degraded state. One of the drives is now marked as
a spare and i can't figure out how to get it back into the array. Does
it have to be completely rebuilt?

bill@bill-desk:~$ sudo mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Sat Sep 22 19:10:10 2018
        Raid Level : raid5
        Array Size : 23441679360 (22355.73 GiB 24004.28 GB)
     Used Dev Size : 7813893120 (7451.91 GiB 8001.43 GB)
      Raid Devices : 4
     Total Devices : 4
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Mon Mar  2 17:41:32 2020
             State : clean, degraded
    Active Devices : 3
   Working Devices : 4
    Failed Devices : 0
     Spare Devices : 1

            Layout : left-symmetric
        Chunk Size : 64K

Consistency Policy : bitmap

              Name : bill-desk:0  (local to host bill-desk)
              UUID : 06ad8de5:3a7a15ad:88116f44:fcdee150
            Events : 10407

    Number   Major   Minor   RaidDevice State
       0       8      129        0      active sync   /dev/sdi1
       1       8      145        1      active sync   /dev/sdj1
       2       8      161        2      active sync   /dev/sdk1
       -       0        0        3      removed

       4       8      177        -      spare   /dev/sdl1
bill@bill-desk:~$ sudo mdadm --examine /dev/sdi1
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 06ad8de5:3a7a15ad:88116f44:fcdee150
           Name : bill-desk:0  (local to host bill-desk)
  Creation Time : Sat Sep 22 19:10:10 2018
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 15627786240 (7451.91 GiB 8001.43 GB)
     Array Size : 23441679360 (22355.73 GiB 24004.28 GB)
    Data Offset : 264192 sectors
   Super Offset : 8 sectors
   Unused Space : before=264112 sectors, after=0 sectors
          State : clean
    Device UUID : ab1323e0:9c0426cf:3e168733:b73e9c5c

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Mar  2 17:41:16 2020
  Bad Block Log : 512 entries available at offset 40 sectors - bad
blocks present.
       Checksum : f197b17c - correct
         Events : 10407

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
bill@bill-desk:~$ sudo mdadm --examine /dev/sdj1
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 06ad8de5:3a7a15ad:88116f44:fcdee150
           Name : bill-desk:0  (local to host bill-desk)
  Creation Time : Sat Sep 22 19:10:10 2018
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 15627786240 (7451.91 GiB 8001.43 GB)
     Array Size : 23441679360 (22355.73 GiB 24004.28 GB)
    Data Offset : 264192 sectors
   Super Offset : 8 sectors
   Unused Space : before=264112 sectors, after=0 sectors
          State : clean
    Device UUID : c875f246:ce25d947:a413e198:4100082e

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Mar  2 17:41:32 2020
  Bad Block Log : 512 entries available at offset 40 sectors
       Checksum : 7e0f516 - correct
         Events : 10749

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)
bill@bill-desk:~$ sudo mdadm --examine /dev/sdk1
/dev/sdk1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 06ad8de5:3a7a15ad:88116f44:fcdee150
           Name : bill-desk:0  (local to host bill-desk)
  Creation Time : Sat Sep 22 19:10:10 2018
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 15627786240 (7451.91 GiB 8001.43 GB)
     Array Size : 23441679360 (22355.73 GiB 24004.28 GB)
    Data Offset : 264192 sectors
   Super Offset : 8 sectors
   Unused Space : before=264112 sectors, after=0 sectors
          State : clean
    Device UUID : fd0634e6:6943f723:0e30260e:e253b1f4

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Mar  2 17:41:32 2020
  Bad Block Log : 512 entries available at offset 40 sectors
       Checksum : bf2f13f2 - correct
         Events : 10749

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)
bill@bill-desk:~$ sudo mdadm --examine /dev/sdl1
/dev/sdl1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 06ad8de5:3a7a15ad:88116f44:fcdee150
           Name : bill-desk:0  (local to host bill-desk)
  Creation Time : Sat Sep 22 19:10:10 2018
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 15627786240 (7451.91 GiB 8001.43 GB)
     Array Size : 23441679360 (22355.73 GiB 24004.28 GB)
    Data Offset : 264192 sectors
   Super Offset : 8 sectors
   Unused Space : before=264112 sectors, after=0 sectors
          State : clean
    Device UUID : 8c628aed:802a5dc8:9d8a8910:9794ec02

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Mar  2 17:41:32 2020
  Bad Block Log : 512 entries available at offset 40 sectors - bad
blocks present.
       Checksum : 7b89f1e6 - correct
         Events : 10749

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : spare
   Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)
