From: John Yates <jyates65@gmail.com>
Subject: Advice recovering from interrupted grow on RAID5 array
Date: Mon, 14 Oct 2013 21:59:45 -0400
Message-ID: <CA+90J__=u_m9RW7c9KHGMRr+6ZOSVQUN6yXm61YM_yir-7LE7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Midway through a RAID5 grow operation from 5 to 6 USB connected
drives, system logs show that the kernel lost communication with some
of the drive ports which has left my array in a state that I have not
been able to reassemble. After reseating the cable connections and
rebooting, all of the drives appear to be functioning normally, so
hopefully the data is still intact. I need advice on recovery steps
for the array.

It appears that each drive failed in quick succession with /dev/sdc1
being the last standing and having the others marked as missing in its
superblock. The superblocks of the other drives show all drives as
available. (--examine output below)

>mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1
mdadm: too-old timestamp on backup-metadata on device-5
mdadm: If you think it is should be safe, try 'export MDADM_GROW_ALLOW_OLD=1'
mdadm: /dev/md127 assembled from 1 drives - not enough to start the array.

Since the Events count was just slightly different on /dev/sdc1, I
retried the assemble with the --force option. This appears to have
copied the Events count of /dev/sdc1 over to /dev/sdd1, /dev/sde1, and
/dev/sdf1, but still failed to assemble the array, though a verbose
assemble command is showing 4 drives now:

mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
/dev/sdf1 /dev/sdg1 --verbose
mdadm: looking for devices for /dev/md127
mdadm: /dev/sdb1 is identified as a member of /dev/md127, slot 4.
mdadm: /dev/sdc1 is identified as a member of /dev/md127, slot 3.
mdadm: /dev/sdd1 is identified as a member of /dev/md127, slot 2.
mdadm: /dev/sde1 is identified as a member of /dev/md127, slot 0.
mdadm: /dev/sdf1 is identified as a member of /dev/md127, slot 1.
mdadm: /dev/sdg1 is identified as a member of /dev/md127, slot 5.
mdadm: :/dev/md127 has an active reshape - checking if critical
section needs to be restored
mdadm: too-old timestamp on backup-metadata on device-5
mdadm: If you think it is should be safe, try 'export MDADM_GROW_ALLOW_OLD=1'
mdadm: added /dev/sdf1 to /dev/md127 as 1
mdadm: added /dev/sdd1 to /dev/md127 as 2
mdadm: added /dev/sdc1 to /dev/md127 as 3
mdadm: added /dev/sdb1 to /dev/md127 as 4 (possibly out of date)
mdadm: added /dev/sdg1 to /dev/md127 as 5 (possibly out of date)
mdadm: added /dev/sde1 to /dev/md127 as 0
mdadm: /dev/md127 assembled from 4 drives - not enough to start the array.


Is there a way to correct the superblock data to allow assembly again
and hopefully restart the grow process? Thanks for any help!

--examine before --assemble --force
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 331103c1:c6a2afce:56b0404d:4786a453
           Name : localhost:archive
  Creation Time : Thu Nov 15 21:04:04 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 3905990738 (1862.52 GiB 1999.87 GB)
     Array Size : 9764974080 (9312.61 GiB 9999.33 GB)
  Used Dev Size : 3905989632 (1862.52 GiB 1999.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1106 sectors
          State : clean
    Device UUID : 2f5a0e84:f258e71d:9dd414e4:42dc45a0

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 5568890880 (5310.91 GiB 5702.54 GB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Oct 14 01:52:28 2013
       Checksum : ca0111bd - correct
         Events : 155279

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 331103c1:c6a2afce:56b0404d:4786a453
           Name : localhost:archive
  Creation Time : Thu Nov 15 21:04:04 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 3905990738 (1862.52 GiB 1999.87 GB)
     Array Size : 9764974080 (9312.61 GiB 9999.33 GB)
  Used Dev Size : 3905989632 (1862.52 GiB 1999.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1106 sectors
          State : clean
    Device UUID : c188fbad:7d9efd7e:a3fb4c45:833e30b9

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 5568890880 (5310.91 GiB 5702.54 GB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Oct 14 01:57:26 2013
       Checksum : cf1c1046 - correct
         Events : 155281

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : ...A.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 331103c1:c6a2afce:56b0404d:4786a453
           Name : localhost:archive
  Creation Time : Thu Nov 15 21:04:04 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 3905990738 (1862.52 GiB 1999.87 GB)
     Array Size : 9764974080 (9312.61 GiB 9999.33 GB)
  Used Dev Size : 3905989632 (1862.52 GiB 1999.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1106 sectors
          State : clean
    Device UUID : cda5e64c:a516c4fe:f79216b9:728ecd37

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 5568890880 (5310.91 GiB 5702.54 GB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Oct 14 01:52:28 2013
       Checksum : e03f8b96 - correct
         Events : 155279

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 331103c1:c6a2afce:56b0404d:4786a453
           Name : localhost:archive
  Creation Time : Thu Nov 15 21:04:04 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 3905990738 (1862.52 GiB 1999.87 GB)
     Array Size : 9764974080 (9312.61 GiB 9999.33 GB)
  Used Dev Size : 3905989632 (1862.52 GiB 1999.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1106 sectors
          State : clean
    Device UUID : 4a3c1fe5:08d55a2d:7e3796ad:2f4ece45

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 5568890880 (5310.91 GiB 5702.54 GB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Oct 14 01:52:28 2013
       Checksum : a98f44b7 - correct
         Events : 155279

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 331103c1:c6a2afce:56b0404d:4786a453
           Name : localhost:archive
  Creation Time : Thu Nov 15 21:04:04 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 3905990738 (1862.52 GiB 1999.87 GB)
     Array Size : 9764974080 (9312.61 GiB 9999.33 GB)
  Used Dev Size : 3905989632 (1862.52 GiB 1999.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1106 sectors
          State : clean
    Device UUID : 8bcd957a:0dd511c1:020851aa:b4f2963a

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 5568890880 (5310.91 GiB 5702.54 GB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Oct 14 01:52:28 2013
       Checksum : c4404b07 - correct
         Events : 155279

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 331103c1:c6a2afce:56b0404d:4786a453
           Name : localhost:archive
  Creation Time : Thu Nov 15 21:04:04 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 3905990738 (1862.52 GiB 1999.87 GB)
     Array Size : 9764974080 (9312.61 GiB 9999.33 GB)
  Used Dev Size : 3905989632 (1862.52 GiB 1999.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1106 sectors
          State : clean
    Device UUID : da285064:616afb61:d275b2bb:7dc91d94

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 5568890880 (5310.91 GiB 5702.54 GB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Oct 14 01:52:28 2013
       Checksum : b9cc8048 - correct
         Events : 155279

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)


--examine after --assemble --force (current state)

/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 331103c1:c6a2afce:56b0404d:4786a453
           Name : localhost:archive
  Creation Time : Thu Nov 15 21:04:04 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 3905990738 (1862.52 GiB 1999.87 GB)
     Array Size : 9764974080 (9312.61 GiB 9999.33 GB)
  Used Dev Size : 3905989632 (1862.52 GiB 1999.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1106 sectors
          State : clean
    Device UUID : 2f5a0e84:f258e71d:9dd414e4:42dc45a0

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 5568890880 (5310.91 GiB 5702.54 GB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Oct 14 01:52:28 2013
       Checksum : ca0111bd - correct
         Events : 155279

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 331103c1:c6a2afce:56b0404d:4786a453
           Name : localhost:archive
  Creation Time : Thu Nov 15 21:04:04 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 3905990738 (1862.52 GiB 1999.87 GB)
     Array Size : 9764974080 (9312.61 GiB 9999.33 GB)
  Used Dev Size : 3905989632 (1862.52 GiB 1999.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1106 sectors
          State : clean
    Device UUID : c188fbad:7d9efd7e:a3fb4c45:833e30b9

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 5568890880 (5310.91 GiB 5702.54 GB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Oct 14 01:57:26 2013
       Checksum : cf1c1046 - correct
         Events : 155281

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : ...A.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 331103c1:c6a2afce:56b0404d:4786a453
           Name : localhost:archive
  Creation Time : Thu Nov 15 21:04:04 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 3905990738 (1862.52 GiB 1999.87 GB)
     Array Size : 9764974080 (9312.61 GiB 9999.33 GB)
  Used Dev Size : 3905989632 (1862.52 GiB 1999.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1106 sectors
          State : clean
    Device UUID : cda5e64c:a516c4fe:f79216b9:728ecd37

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 5568890880 (5310.91 GiB 5702.54 GB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Oct 14 01:52:28 2013
       Checksum : e03f8b98 - correct
         Events : 155281

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 331103c1:c6a2afce:56b0404d:4786a453
           Name : localhost:archive
  Creation Time : Thu Nov 15 21:04:04 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 3905990738 (1862.52 GiB 1999.87 GB)
     Array Size : 9764974080 (9312.61 GiB 9999.33 GB)
  Used Dev Size : 3905989632 (1862.52 GiB 1999.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1106 sectors
          State : clean
    Device UUID : 4a3c1fe5:08d55a2d:7e3796ad:2f4ece45

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 5568890880 (5310.91 GiB 5702.54 GB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Oct 14 01:52:28 2013
       Checksum : a98f44b9 - correct
         Events : 155281

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 331103c1:c6a2afce:56b0404d:4786a453
           Name : localhost:archive
  Creation Time : Thu Nov 15 21:04:04 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 3905990738 (1862.52 GiB 1999.87 GB)
     Array Size : 9764974080 (9312.61 GiB 9999.33 GB)
  Used Dev Size : 3905989632 (1862.52 GiB 1999.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1106 sectors
          State : clean
    Device UUID : 8bcd957a:0dd511c1:020851aa:b4f2963a

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 5568890880 (5310.91 GiB 5702.54 GB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Oct 14 01:52:28 2013
       Checksum : c4404b09 - correct
         Events : 155281

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x5
     Array UUID : 331103c1:c6a2afce:56b0404d:4786a453
           Name : localhost:archive
  Creation Time : Thu Nov 15 21:04:04 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 3905990738 (1862.52 GiB 1999.87 GB)
     Array Size : 9764974080 (9312.61 GiB 9999.33 GB)
  Used Dev Size : 3905989632 (1862.52 GiB 1999.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1106 sectors
          State : clean
    Device UUID : da285064:616afb61:d275b2bb:7dc91d94

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 5568890880 (5310.91 GiB 5702.54 GB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Oct 14 01:52:28 2013
       Checksum : b9cc8048 - correct
         Events : 155279

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
