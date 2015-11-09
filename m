From: Guillaume Paumier <guillaume.paumier@gmail.com>
Subject: Offline array, events count mismatch
Date: Sun, 08 Nov 2015 18:49:29 -0800
Message-ID: <1903758.3ih4aa4jR2@carbon.lepommierdujardin.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello folks,

I reached out to you a few months ago when a --grow went awry. In the end I 
managed to restore my array thanks to this mailing list and the invaluable 
help of IRC user frostschutz.

I'm now facing another issue and I'm hoping you can help me again.

Today I found out that my RAID6, 9-disk array was offline. When looking at the 
machine, two disks seemed to have disappeared; they didn't show in fdisk or 
anything. And a third one was marked as "faulty" in mdadm.

At first, I was puzzled because it seemed improbable that three disks had 
failed at the same time. I removed the array from fstab and rebooted. The two 
vanished disks re-appeared (in fdisk too), and when examining the partitions, 
I noticed the following events count:

/dev/sdb1:
         Events : 198477
/dev/sdc1:
         Events : 198477
/dev/sdd1:
         Events : 198477
/dev/sde1:
         Events : 54264
/dev/sdf1:
         Events : 54264
/dev/sdg1:
         Events : 198477
/dev/sdh1:
         Events : 198477
/dev/sdi1:
         Events : 198477
/dev/sdj1:
         Events : 198473

Looking at those event counts, my understanding is this:
* Two of the disks (sde, sdf) were dropped from the array for some reason.
* I didn't notice this immediately (an issue I'm addressing separately).
* A third disk (sdj) encountered a small issue today.
* The array went offline because it didn't have enough disks to function 
cleanly any more.

If I understand the documentation [1] correctly, since the event count for sdj 
is very close to the event count of sd[b,c,d,g,h,i], I should be able to re-
assemble the array with these 7 disks using --force, leaving sde and sdf 
aside. Once the array is assembled, I should be able to re-add sde and sdf, 
and they will be re-sync'd.

[1] 
https://raid.wiki.kernel.org/index.php/RAID_Recovery#Trying_to_assemble_using_--force

I prefer to be cautious and ask here before doing anything that could make 
things worse. It would be great if you could confirm that my understanding is 
correct, and tell me if this plan is sound.

I'm including some more detailed information below. Let me know if there's any 
other information that would be useful.

Many thanks,


===========================================================
Before the reboot: mdadm -D
-----------------------------------------------------------

# mdadm -D /dev/md0
/dev/md0:
        Version : 1.0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 3907016448 (3726.02 GiB 4000.78 GB)
   Raid Devices : 9
  Total Devices : 8
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sun Nov  8 06:36:50 2015
          State : clean, FAILED
 Active Devices : 6
Working Devices : 6
 Failed Devices : 2
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           UUID : eea59047:120a0365:353da182:6787e030
         Events : 198477

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       2       8       97        2      active sync   /dev/sdg1
       3       8      113        3      active sync   /dev/sdh1
       4       8      129        4      active sync   /dev/sdi1
      10       0        0       10      removed
      12       0        0       12      removed
      14       0        0       14      removed
       8       8       17        8      active sync   /dev/sdb1

       5       8      145        -      faulty   /dev/sdj1
       6       8       65        -      faulty   /dev/sde1


===========================================================
Before the reboot: mdadm --examine
-----------------------------------------------------------

# mdadm --examine /dev/sd[b-j]1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : eea59047:120a0365:353da182:6787e030
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033128 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 91b187fd:f416880a:f5e81e49:92615e07

Internal Bitmap : -16 sectors from superblock
    Update Time : Sun Nov  8 06:36:50 2015
  Bad Block Log : 512 entries available at offset -8 sectors
       Checksum : 30050dee - correct
         Events : 198477

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 8
   Array State : AAAAA...A ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : eea59047:120a0365:353da182:6787e030
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : e1b689b5:b4a2c5a7:56057b69:a9101af0

Internal Bitmap : -16 sectors from superblock
    Update Time : Sun Nov  8 06:36:50 2015
       Checksum : 8e546a7e - correct
         Events : 198477

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 0
   Array State : AAAAA...A ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : eea59047:120a0365:353da182:6787e030
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 1d8e74d3:9abd37f8:f2cf0ab8:02fdcfd6

Internal Bitmap : -16 sectors from superblock
    Update Time : Sun Nov  8 06:36:50 2015
       Checksum : 31f71397 - correct
         Events : 198477

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 1
   Array State : AAAAA...A ('A' == active, '.' == missing, 'R' == replacing)
mdadm: No md superblock detected on /dev/sde1.
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : eea59047:120a0365:353da182:6787e030
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : b24758e6:042412c5:9b5a3c06:f167aedf

Internal Bitmap : -16 sectors from superblock
    Update Time : Sun Nov  8 06:36:50 2015
       Checksum : 68c5292e - correct
         Events : 198477

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 2
   Array State : AAAAA...A ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : eea59047:120a0365:353da182:6787e030
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 00e47d82:b49c3905:3ed961fe:40a5f259

Internal Bitmap : -16 sectors from superblock
    Update Time : Sun Nov  8 06:36:50 2015
       Checksum : b77bfa1e - correct
         Events : 198477

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 3
   Array State : AAAAA...A ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : eea59047:120a0365:353da182:6787e030
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : a7e34040:fa12382f:c2ef3d85:9c95b1d0

Internal Bitmap : -16 sectors from superblock
    Update Time : Sun Nov  8 06:36:50 2015
       Checksum : 9cd876ec - correct
         Events : 198477

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 4
   Array State : AAAAA...A ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : eea59047:120a0365:353da182:6787e030
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 9d89c55d:9f4a2181:6b87922f:0681d580

Internal Bitmap : -16 sectors from superblock
    Update Time : Sun Nov  8 06:36:38 2015
       Checksum : 66c5dfd2 - correct
         Events : 198473

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 5
   Array State : AAAAAA..A ('A' == active, '.' == missing, 'R' == replacing)


===========================================================
After the reboot: mdadm --examine
-----------------------------------------------------------

# mdadm --examine /dev/sd[b-j]1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : eea59047:120a0365:353da182:6787e030
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033128 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 91b187fd:f416880a:f5e81e49:92615e07

Internal Bitmap : -16 sectors from superblock
    Update Time : Sun Nov  8 06:36:50 2015
  Bad Block Log : 512 entries available at offset -8 sectors
       Checksum : 30050dee - correct
         Events : 198477

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 8
   Array State : AAAAA...A ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : eea59047:120a0365:353da182:6787e030
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : e1b689b5:b4a2c5a7:56057b69:a9101af0

Internal Bitmap : -16 sectors from superblock
    Update Time : Sun Nov  8 06:36:50 2015
       Checksum : 8e546a7e - correct
         Events : 198477

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 0
   Array State : AAAAA...A ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : eea59047:120a0365:353da182:6787e030
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 1d8e74d3:9abd37f8:f2cf0ab8:02fdcfd6

Internal Bitmap : -16 sectors from superblock
    Update Time : Sun Nov  8 06:36:50 2015
       Checksum : 31f71397 - correct
         Events : 198477

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 1
   Array State : AAAAA...A ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : eea59047:120a0365:353da182:6787e030
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : ddf17d3d:ea944bfb:6886cc91:3366f55f

Internal Bitmap : -16 sectors from superblock
    Update Time : Wed Oct  7 10:17:35 2015
       Checksum : 1dd30b1 - correct
         Events : 54264

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 7
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : eea59047:120a0365:353da182:6787e030
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 38675f59:ea412b1f:67d6ed9a:a33fc5dd

Internal Bitmap : -16 sectors from superblock
    Update Time : Wed Oct  7 10:17:35 2015
       Checksum : c88f7c7b - correct
         Events : 54264

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 6
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : eea59047:120a0365:353da182:6787e030
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : b24758e6:042412c5:9b5a3c06:f167aedf

Internal Bitmap : -16 sectors from superblock
    Update Time : Sun Nov  8 06:36:50 2015
       Checksum : 68c5292e - correct
         Events : 198477

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 2
   Array State : AAAAA...A ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : eea59047:120a0365:353da182:6787e030
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 00e47d82:b49c3905:3ed961fe:40a5f259

Internal Bitmap : -16 sectors from superblock
    Update Time : Sun Nov  8 06:36:50 2015
       Checksum : b77bfa1e - correct
         Events : 198477

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 3
   Array State : AAAAA...A ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : eea59047:120a0365:353da182:6787e030
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : a7e34040:fa12382f:c2ef3d85:9c95b1d0

Internal Bitmap : -16 sectors from superblock
    Update Time : Sun Nov  8 06:36:50 2015
       Checksum : 9cd876ec - correct
         Events : 198477

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 4
   Array State : AAAAA...A ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : eea59047:120a0365:353da182:6787e030
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 27349115136 (26082.15 GiB 28005.49 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 9d89c55d:9f4a2181:6b87922f:0681d580

Internal Bitmap : -16 sectors from superblock
    Update Time : Sun Nov  8 06:36:38 2015
       Checksum : 66c5dfd2 - correct
         Events : 198473

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 5
   Array State : AAAAAA..A ('A' == active, '.' == missing, 'R' == replacing)

===========================================================


-- 
Guillaume Paumier
