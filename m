From: Theo Cabrerizo Diem <diem@carpediem.sh>
Subject: help recovering a software raid5 device
Date: Sun, 27 Jan 2013 15:52:43 +0200
Message-ID: <CAAXKdzzERB_zzcdPPzuwdL+afFO334X3bck1EvrRV5rFvEEg6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I had (hopefully still have ;) ) a raid5 setup using 4x 2Tb HDDs.
Recently when I was on vacations one disk failed and before I could
come back (15 days after) a second one failed also.

Of course I had no backups ;) and to make it worse the raid device had
luks running on top of it, but that would come later. Just as
clarfication I did encrypt the md device, and not built a md on top of
luks devices.

I did read the wiki, and took a copy of mdadm --examine /dev/sd[ghij]1
before doing anything. I've tried to run :

mdadm --create --assume-clean --level=5 --chunk 64 --raid-devices=4
/dev/md/stuff1 /dev/sdh1 /dev/sdg1 /dev/sdj1 /dev/sdi1

Including the "supposed" correct order taken from examine command and
all possible permutations of the disk orders with no luck.

From there I have three questions :
- From the output of --examine I have "Chunk Size: 64K". I suppose I
should add "--chunk 64" on the mdadm --create line right?
- Should I attempt "mdadm --create" command with just the last 3 good
disks and a "missing" one or should I attempt with all four ?
- Any further suggestions to try to recover it ?

Following my output of mdadm --examine after a reboot (don't know why
the distro detected and assembled the raid with only two devices in a
inactive state)

Thanks in advance,


=== mdadm --examine ===
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 9e0221c0:4c86d48e:17f44c71:374ab4fc
           Name : turquoise:stuff1  (local to host turquoise)
  Creation Time : Thu Apr  7 21:53:47 2011
     Raid Level : raid5
   Raid Devices : 4
 Avail Dev Size : 3907024897 (1863.01 GiB 2000.40 GB)
     Array Size : 5860536768 (5589.04 GiB 6001.19 GB)
  Used Dev Size : 3907024512 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : b126fff4:3072b6ad:70f6d710:9211b38a
    Update Time : Sun Jan  6 13:47:04 2013
       Checksum : 9ea2be38 - correct
         Events : 196828
         Layout : left-symmetric
     Chunk Size : 64K
   Device Role : Active device 1
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 9e0221c0:4c86d48e:17f44c71:374ab4fc
           Name : turquoise:stuff1  (local to host turquoise)
  Creation Time : Thu Apr  7 21:53:47 2011
     Raid Level : raid5
   Raid Devices : 4
 Avail Dev Size : 3907024897 (1863.01 GiB 2000.40 GB)
     Array Size : 5860536768 (5589.04 GiB 6001.19 GB)
  Used Dev Size : 3907024512 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 7429aae9:e6b533db:b8691ef5:82776fe3
    Update Time : Sun Jan 20 06:26:40 2013
       Checksum : fde2d905 - correct
         Events : 323123
         Layout : left-symmetric
     Chunk Size : 64K
   Device Role : Active device 0
   Array State : A.AA ('A' == active, '.' == missing)
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 9e0221c0:4c86d48e:17f44c71:374ab4fc
           Name : turquoise:stuff1  (local to host turquoise)
  Creation Time : Thu Apr  7 21:53:47 2011
     Raid Level : raid5
   Raid Devices : 4
 Avail Dev Size : 3907024897 (1863.01 GiB 2000.40 GB)
     Array Size : 5860536768 (5589.04 GiB 6001.19 GB)
  Used Dev Size : 3907024512 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 0cd288e4:91fe05b3:2635c653:47d1b20c
    Update Time : Sun Jan 27 10:10:06 2013
       Checksum : 58865ead - correct
         Events : 323208
         Layout : left-symmetric
     Chunk Size : 64K
   Device Role : Active device 3
   Array State : ..AA ('A' == active, '.' == missing)
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 9e0221c0:4c86d48e:17f44c71:374ab4fc
           Name : turquoise:stuff1  (local to host turquoise)
  Creation Time : Thu Apr  7 21:53:47 2011
     Raid Level : raid5
   Raid Devices : 4
 Avail Dev Size : 3907024897 (1863.01 GiB 2000.40 GB)
     Array Size : 5860536768 (5589.04 GiB 6001.19 GB)
  Used Dev Size : 3907024512 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 69c3570d:57b1ef84:7eb3bac5:ba27f173
    Update Time : Sun Jan 27 10:10:06 2013
       Checksum : 2c71d799 - correct
         Events : 323208
         Layout : left-symmetric
     Chunk Size : 64K
   Device Role : Active device 2
   Array State : ..AA ('A' == active, '.' == missing)
=== end ===
