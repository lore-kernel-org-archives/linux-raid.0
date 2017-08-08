From: Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH] Assemble: prevent segfault with faulty "best" devices
Date: Tue, 8 Aug 2017 19:48:07 +0200
Message-ID: <20170808174807.GA6611@Dell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes@trained-monkey.org>
Cc: Robert LeBlanc <robert@leblancnet.us>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was able to trigger this curious problem that seems to happen only on
one of our server:

# mdadm --assemble /dev/md/10.4.237.12-volume --name 10.4.237.12-volume
Segmentation fault

This md volume is a raid1 volume made of 2 device mapper (dm-multipath)
devices and the underlying LUNs are imported via iSCSI.

Applying the following patch (see below) seems to fix the problem:

# ./mdadm --assemble /dev/md/10.4.237.12-volume --name 10.4.237.12-volume
mdadm: /dev/md/10.4.237.12-volume has been started with 2 drives.

But I'm not sure if it's the right fix or if there're some other
problems that I'm missing.

More details about the md superblocks that might help to better
understand the nature of the problem:

# for i in 36001405a04ed0c104881{1,2}00000000000p2; do echo dev: ${i}; mdadm --examine /dev/mapper/${i}; done
dev: 36001405a04ed0c104881100000000000p2
/dev/mapper/36001405a04ed0c104881100000000000p2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5f3e8283:7f831b85:bc1958b9:6f2787a4
           Name : 10.4.237.12-volume
  Creation Time : Thu Jul 27 14:43:16 2017
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 1073729503 (511.99 GiB 549.75 GB)
     Array Size : 536864704 (511.99 GiB 549.75 GB)
  Used Dev Size : 1073729408 (511.99 GiB 549.75 GB)
    Data Offset : 8192 sectors
   Super Offset : 8 sectors
   Unused Space : before=8104 sectors, after=95 sectors
          State : clean
    Device UUID : 16dae7e3:42f3487f:fbeac43a:71cf1f63

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Aug  8 11:12:22 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 518c443e - correct
         Events : 167


   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
dev: 36001405a04ed0c104881200000000000p2
/dev/mapper/36001405a04ed0c104881200000000000p2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5f3e8283:7f831b85:bc1958b9:6f2787a4
           Name : 10.4.237.12-volume
  Creation Time : Thu Jul 27 14:43:16 2017
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 1073729503 (511.99 GiB 549.75 GB)
     Array Size : 536864704 (511.99 GiB 549.75 GB)
  Used Dev Size : 1073729408 (511.99 GiB 549.75 GB)
    Data Offset : 8192 sectors
   Super Offset : 8 sectors
   Unused Space : before=8104 sectors, after=95 sectors
          State : clean
    Device UUID : ef612bdd:e475fe02:5d3fc55e:53612f34

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Aug  8 11:12:22 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : c39534fd - correct
         Events : 167


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing, 'R' == replacing)

# for i in 36001405a04ed0c104881{1,2}00000000000p2; do echo dev: ${i}; hexdump -s 4096 -n 4189696 -C /dev/mapper/${i}; done
dev: 36001405a04ed0c104881100000000000p2
00001000  fc 4e 2b a9 01 00 00 00  01 00 00 00 00 00 00 00  |.N+.............|
00001010  5f 3e 82 83 7f 83 1b 85  bc 19 58 b9 6f 27 87 a4  |_>........X.o'..|
00001020  31 30 2e 34 2e 32 33 37  2e 31 32 2d 76 6f 6c 75  |10.4.237.12-volu|
00001030  6d 65 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |me..............|
00001040  64 50 7a 59 00 00 00 00  01 00 00 00 00 00 00 00  |dPzY............|
00001050  80 cf ff 3f 00 00 00 00  00 00 00 00 02 00 00 00  |...?............|
00001060  08 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00001070  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00001080  00 20 00 00 00 00 00 00  df cf ff 3f 00 00 00 00  |. .........?....|
00001090  08 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
000010a0  00 00 00 00 00 00 00 00  16 da e7 e3 42 f3 48 7f  |............B.H.|
000010b0  fb ea c4 3a 71 cf 1f 63  00 00 08 00 48 00 00 00  |...:q..c....H...|
000010c0  54 f0 89 59 00 00 00 00  a7 00 00 00 00 00 00 00  |T..Y............|
000010d0  ff ff ff ff ff ff ff ff  9c 43 8c 51 80 00 00 00  |.........C.Q....|
000010e0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00001100  00 00 01 00 fe ff fe ff  fe ff fe ff fe ff fe ff  |................|
00001110  fe ff fe ff fe ff fe ff  fe ff fe ff fe ff fe ff  |................|
*
00001200  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00002000  62 69 74 6d 04 00 00 00  5f 3e 82 83 7f 83 1b 85  |bitm...._>......|
00002010  bc 19 58 b9 6f 27 87 a4  a7 00 00 00 00 00 00 00  |..X.o'..........|
00002020  a7 00 00 00 00 00 00 00  80 cf ff 3f 00 00 00 00  |...........?....|
00002030  00 00 00 00 00 00 00 01  05 00 00 00 00 00 00 00  |................|
00002040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00003100  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
00004000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
003ffe00
dev: 36001405a04ed0c104881200000000000p2
00001000  fc 4e 2b a9 01 00 00 00  01 00 00 00 00 00 00 00  |.N+.............|
00001010  5f 3e 82 83 7f 83 1b 85  bc 19 58 b9 6f 27 87 a4  |_>........X.o'..|
00001020  31 30 2e 34 2e 32 33 37  2e 31 32 2d 76 6f 6c 75  |10.4.237.12-volu|
00001030  6d 65 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |me..............|
00001040  64 50 7a 59 00 00 00 00  01 00 00 00 00 00 00 00  |dPzY............|
00001050  80 cf ff 3f 00 00 00 00  00 00 00 00 02 00 00 00  |...?............|
00001060  08 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00001070  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00001080  00 20 00 00 00 00 00 00  df cf ff 3f 00 00 00 00  |. .........?....|
00001090  08 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
000010a0  01 00 00 00 00 00 00 00  ef 61 2b dd e4 75 fe 02  |.........a+..u..|
000010b0  5d 3f c5 5e 53 61 2f 34  00 00 08 00 48 00 00 00  |]?.^Sa/4....H...|
000010c0  54 f0 89 59 00 00 00 00  a7 00 00 00 00 00 00 00  |T..Y............|
000010d0  ff ff ff ff ff ff ff ff  5b 34 95 c3 80 00 00 00  |........[4......|
000010e0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00001100  00 00 01 00 fe ff fe ff  fe ff fe ff fe ff fe ff  |................|
00001110  fe ff fe ff fe ff fe ff  fe ff fe ff fe ff fe ff  |................|
*
00001200  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00002000  62 69 74 6d 04 00 00 00  5f 3e 82 83 7f 83 1b 85  |bitm...._>......|
00002010  bc 19 58 b9 6f 27 87 a4  a7 00 00 00 00 00 00 00  |..X.o'..........|
00002020  a7 00 00 00 00 00 00 00  80 cf ff 3f 00 00 00 00  |...........?....|
00002030  00 00 00 00 00 00 00 01  05 00 00 00 00 00 00 00  |................|
00002040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00003100  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
00004000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
003ffe00

---
Assemble: prevent segfault with faulty "best" devices

In Assemble(), after context reload, best[i] can be -1 in some cases,
and before checking if this value is negative we use it to access
devices[j].i.disk.raid_disk, potentially causing a segfault.

Check if best[i] is negative before using it to prevent this potential
segfault.

Signed-off-by: Andrea Righi <andrea@betterlinux.com>
Signed-off-by: Robert LeBlanc <robert@leblancnet.us>
---
 Assemble.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 3da0903..fc681eb 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1669,6 +1669,8 @@ try_again:
 		int j = best[i];
 		unsigned int desired_state;
 
+		if (j < 0)
+			continue;
 		if (devices[j].i.disk.raid_disk == MD_DISK_ROLE_JOURNAL)
 			desired_state = (1<<MD_DISK_JOURNAL);
 		else if (i >= content->array.raid_disks * 2)
@@ -1678,8 +1680,6 @@ try_again:
 		else
 			desired_state = (1<<MD_DISK_ACTIVE) | (1<<MD_DISK_SYNC);
 
-		if (j<0)
-			continue;
 		if (!devices[j].uptodate)
 			continue;
 
