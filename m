From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: RAID5 in sync does not populate slots sequentially, shows array as
 (somewhat) faulty
Date: Mon, 03 Mar 2008 11:42:54 +0100
Message-ID: <47CBD62E.7040608@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Noticing the problems Tor Vestb=C3=B8 is having, I remembered that I ha=
ve an array=20
in a similar state, which I never figured out. The array has been worki=
ng=20
flawlessly for 3 months, the monthly 'check' runs come back with everyt=
hing=20
being clean. However this is how the array looks through mdadm's eyes:

root@Thesaurus:~# mdadm -D /dev/md5
/dev/md5:
         Version : 01.01.03
   Creation Time : Tue Jan 22 03:52:42 2008
      Raid Level : raid5
      Array Size : 865081344 (825.01 GiB 885.84 GB)
   Used Dev Size : 576720896 (275.00 GiB 295.28 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 5
     Persistence : Superblock is persistent

     Update Time : Mon Mar  3 11:34:36 2008
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 2048K

            Name : Thesaurus:Crypta  (local to host Thesaurus)
            UUID : 1decb2d1:ebf16128:a240938a:669b0999
          Events : 9090

     Number   Major   Minor   RaidDevice State
        4       8        3        0      active sync   /dev/sda3	<-- wh=
y at=20
#4, not #0?
        1       8       19        1      active sync   /dev/sdb3
        2       8       35        2      active sync   /dev/sdc3
        3       8       51        3      active sync   /dev/sdd3
root@Thesaurus:~#

root@Thesaurus:~# mdadm -E /dev/sda3
/dev/sda3:
           Magic : a92b4efc
         Version : 1.1
     Feature Map : 0x0
      Array UUID : 1decb2d1:ebf16128:a240938a:669b0999
            Name : Thesaurus:Crypta  (local to host Thesaurus)
   Creation Time : Tue Jan 22 03:52:42 2008
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 576733236 (275.01 GiB 295.29 GB)
      Array Size : 1730162688 (825.01 GiB 885.84 GB)
   Used Dev Size : 576720896 (275.00 GiB 295.28 GB)
     Data Offset : 264 sectors		<-- not sure why this is different from=
 the rest
    Super Offset : 0 sectors
           State : active
     Device UUID : 72d9ceb4:89a20f49:50d51384:9b164f72

     Update Time : Mon Mar  3 11:34:26 2008
        Checksum : 4bd3ae95 - correct
          Events : 9090

          Layout : left-symmetric
      Chunk Size : 2048K

     Array Slot : 4 (failed, 1, 2, 3, 0)
    Array State : Uuuu 1 failed			<-- why is that?
root@Thesaurus:~#

root@Thesaurus:~# mdadm -E /dev/sdb3
/dev/sdb3:
           Magic : a92b4efc
         Version : 1.1
     Feature Map : 0x0
      Array UUID : 1decb2d1:ebf16128:a240938a:669b0999
            Name : Thesaurus:Crypta  (local to host Thesaurus)
   Creation Time : Tue Jan 22 03:52:42 2008
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 576733364 (275.01 GiB 295.29 GB)
      Array Size : 1730162688 (825.01 GiB 885.84 GB)
   Used Dev Size : 576720896 (275.00 GiB 295.28 GB)
     Data Offset : 136 sectors
    Super Offset : 0 sectors
           State : active
     Device UUID : 0ba427b2:6cc26a34:cc9838d9:1dc77772

     Update Time : Mon Mar  3 11:39:01 2008
        Checksum : 89d50e1f - correct
          Events : 9090

          Layout : left-symmetric
      Chunk Size : 2048K

     Array Slot : 1 (failed, 1, 2, 3, 0)
    Array State : uUuu 1 failed			<-- and that?
root@Thesaurus:~#

root@Thesaurus:~# mdadm -E /dev/sdc3
/dev/sdc3:
           Magic : a92b4efc
         Version : 1.1
     Feature Map : 0x0
      Array UUID : 1decb2d1:ebf16128:a240938a:669b0999
            Name : Thesaurus:Crypta  (local to host Thesaurus)
   Creation Time : Tue Jan 22 03:52:42 2008
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 576733364 (275.01 GiB 295.29 GB)
      Array Size : 1730162688 (825.01 GiB 885.84 GB)
   Used Dev Size : 576720896 (275.00 GiB 295.28 GB)
     Data Offset : 136 sectors
    Super Offset : 0 sectors
           State : active
     Device UUID : ada93838:5e3fef07:fd478ba7:8fcf75e6

     Update Time : Mon Mar  3 11:39:44 2008
        Checksum : 25bb4882 - correct
          Events : 9090

          Layout : left-symmetric
      Chunk Size : 2048K

     Array Slot : 2 (failed, 1, 2, 3, 0)
    Array State : uuUu 1 failed			<-- same here
root@Thesaurus:~#

root@Thesaurus:~# mdadm -E /dev/sdd3
/dev/sdd3:
           Magic : a92b4efc
         Version : 1.1
     Feature Map : 0x0
      Array UUID : 1decb2d1:ebf16128:a240938a:669b0999
            Name : Thesaurus:Crypta  (local to host Thesaurus)
   Creation Time : Tue Jan 22 03:52:42 2008
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 576733364 (275.01 GiB 295.29 GB)
      Array Size : 1730162688 (825.01 GiB 885.84 GB)
   Used Dev Size : 576720896 (275.00 GiB 295.28 GB)
     Data Offset : 136 sectors
    Super Offset : 0 sectors
           State : active
     Device UUID : be5f202f:c9097996:98d66036:9b6453ee

     Update Time : Mon Mar  3 11:40:11 2008
        Checksum : 41dfecc1 - correct
          Events : 9090

          Layout : left-symmetric
      Chunk Size : 2048K

     Array Slot : 3 (failed, 1, 2, 3, 0)
    Array State : uuuU 1 failed
root@Thesaurus:~# 				<-- and here



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
