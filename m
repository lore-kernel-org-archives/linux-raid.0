From: William Morgan <therealbrewer@gmail.com>
Subject: Re: Two raid5 arrays are inactive and have changed UUIDs
Date: Wed, 15 Jan 2020 16:12:02 -0600
Message-ID: <CALc6PW5Y-SvUZ5HOWZLk2YcggepUwK0N===G=42uMR88pDfAVA@mail.gmail.com>
References: <CALc6PW4OKR2KVFgzoEbRJ0TRwvqi5EZAdC__HOx+vJKMT0TXYQ@mail.gmail.com>
 <959ca414-0c97-2e8d-7715-a7cb75790fcd@youngman.org.uk> <CALc6PW7276uYYWpL7j2xsFJRy3ayZeeSJ9kNCGHvB6Ndb6m1-Q@mail.gmail.com>
 <5E17D999.5010309@youngman.org.uk> <CALc6PW5DrTkVR7rLngDcJ5i8kTpqfT1-K+ki-WjnXAYP5TXXZg@mail.gmail.com>
 <CALc6PW7hwT9VDNyA8wfMzjMoUFmrFV5z=Ve+qvR-P7CPstegvw@mail.gmail.com> <5E1DDCFC.1080105@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E1DDCFC.1080105@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Did you do an "mdadm --stop /dev/md1"? You should
> always do that between every attempt.
>
Yes, that was exactly the problem - I forgot to stop it. After that,
the array assembled perfectly, and fsck showed no problems with the
array. I was able to salvage all the data. Wouldn't have been able to
do it without your help!

Now on to the array of larger disks:

md0 consists of 4x 8TB drives:

role drive events state
 0    sdb   10080  A.AA (bad blocks reported on this drive)
 1    sdc   10070  AAAA
 2    sdd   10070  AAAA
 3    sde   10080  A.AA (bad blocks reported on this drive)

I used the same approach, ddrescue-ing sd[b-e] to sd[f-i]. No errors
during the copy. Then I stopped md0 and force-assembled the array from
the copies. That seems to have gone well.:

bill@bill-desk:~$ sudo mdadm --assemble --force /dev/md0 /dev/sd[f-i]1
mdadm: forcing event count in /dev/sdg1(1) from 10070 upto 10080
mdadm: forcing event count in /dev/sdh1(2) from 10070 upto 10080
mdadm: clearing FAULTY flag for device 1 in /dev/md0 for /dev/sdg1
mdadm: Marking array /dev/md0 as 'clean'
mdadm: /dev/md0 has been started with 4 drives.

checked the status of md0:

bill@bill-desk:~$ sudo mdadm -D /dev/md0
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

       Update Time : Sat Jan  4 16:58:47 2020
             State : clean
    Active Devices : 4
   Working Devices : 4
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 64K

Consistency Policy : bitmap

              Name : bill-desk:0  (local to host bill-desk)
              UUID : 06ad8de5:3a7a15ad:88116f44:fcdee150
            Events : 10080

    Number   Major   Minor   RaidDevice State
       0       8       81        0      active sync   /dev/sdf1
       1       8       97        1      active sync   /dev/sdg1
       2       8      113        2      active sync   /dev/sdh1
       4       8      129        3      active sync   /dev/sdi1

Then checked with fsck:

bill@bill-desk:~$ sudo fsck /dev/md0
fsck from util-linux 2.34
e2fsck 1.45.3 (14-Jul-2019)
/dev/md0: recovering journal
/dev/md0: clean, 11274/366276608 files, 5285497435/5860419840 blocks

Everything seems ok. Then I examined each disk:

ill@bill-desk:~$ sudo mdadm --examine /dev/sd[f-i]
/dev/sdf:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdg:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdh:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdi:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
bill@bill-desk:~$ sudo mdadm --examine /dev/sd[f-i]1
/dev/sdf1:
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
    Update Time : Wed Jan 15 15:35:37 2020
  Bad Block Log : 512 entries available at offset 40 sectors - bad
blocks present.
       Checksum : f1599c42 - correct
         Events : 10080

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg1:
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
    Update Time : Wed Jan 15 15:35:37 2020
  Bad Block Log : 512 entries available at offset 40 sectors
       Checksum : 7a1de7a - correct
         Events : 10080

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdh1:
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
    Update Time : Wed Jan 15 15:35:37 2020
  Bad Block Log : 512 entries available at offset 40 sectors
       Checksum : beeffd56 - correct
         Events : 10080

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
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
    Device UUID : 8c628aed:802a5dc8:9d8a8910:9794ec02

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jan 15 15:35:37 2020
  Bad Block Log : 512 entries available at offset 40 sectors - bad
blocks present.
       Checksum : 7b4adb4a - correct
         Events : 10080

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 3
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

All 4 drives have the same event count and all four show the same
state of AAAA, but the first and last drive still show bad blocks
present. Is that because ddrescue copied literally everything from the
original drives, including the list of bad blocks? How should I go
about clearing those bad blocks? Is there something more I should do
to verify the integrity of the data?

Thanks so much for your help!
Bill
