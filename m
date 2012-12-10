From: bobzer <bobzer@gmail.com>
Subject: problem with raid after reboot
Date: Sun, 9 Dec 2012 23:13:16 -0500
Message-ID: <CADzS=aqXh08P+ujEoJPMBxPiZ-PeEdk3x3iRW1ymAvhtpZcDmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi had to reboot my raid 5 server. but now it doesnt't want to
reassemble correctly

i have a raid 5 of 3 disk and a lvm on top of that. i know my data are
there but i'm afraid of enter the dead command :-)

so here is the information about my raid, if someone could help or
explain me something or just give a clue to follow.
i remember that, this already happend to me ... exactly the same but i
don't remember how i did (promes that this time right everything down)
because it's already happend i'm afraid there is a bigger problem in my raid...

help me please :-)

cat /etc/mdstat :
Personalities :
md0 : inactive sdd1[2](S) sdc1[1](S) sdb1[3](S)
      5860532931 blocks super 1.2

unused devices: <none>

------------------------------------------------

/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : bf3c605b:9699aa55:d45119a2:7ba58d56
           Name : debian:0  (local to host debian)
  Creation Time : Sun Mar  4 22:49:14 2012
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 3907021954 (1863.01 GiB 2000.40 GB)
     Array Size : 7814043136 (3726.03 GiB 4000.79 GB)
  Used Dev Size : 3907021568 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 5e71f69a:a78b0cd7:bbbb7ecb:cf81f9f6

    Update Time : Sat Dec  1 20:46:35 2012
  Bad Block Log : 512 entries available at offset 2032 sectors
       Checksum : 920f006c - correct
         Events : 372

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 0
   Array State : A.. ('A' == active, '.' == missing)

----------------------------------------------

/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : bf3c605b:9699aa55:d45119a2:7ba58d56
           Name : debian:0  (local to host debian)
  Creation Time : Sun Mar  4 22:49:14 2012
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 3907021954 (1863.01 GiB 2000.40 GB)
     Array Size : 7814043136 (3726.03 GiB 4000.79 GB)
  Used Dev Size : 3907021568 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 406c4cb5:c188e4a9:7ed8be9f:14a49b16

    Update Time : Sat Dec  1 06:58:57 2012
  Bad Block Log : 512 entries available at offset 2032 sectors
       Checksum : 73207571 - correct
         Events : 367

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 1
   Array State : AAA ('A' == active, '.' == missing)

----------------------------------------------

/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : bf3c605b:9699aa55:d45119a2:7ba58d56
           Name : debian:0  (local to host debian)
  Creation Time : Sun Mar  4 22:49:14 2012
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 3907021954 (1863.01 GiB 2000.40 GB)
     Array Size : 7814043136 (3726.03 GiB 4000.79 GB)
  Used Dev Size : 3907021568 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : f9059dfb:74af1ab7:bc1465b1:e2ff30ba

    Update Time : Sat Dec  1 06:58:57 2012
  Bad Block Log : 512 entries available at offset 2032 sectors
       Checksum : 7be2cdeb - correct
         Events : 367

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 2
   Array State : AAA ('A' == active, '.' == missing)


hope you can help me thanks

Mathieu
