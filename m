From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: recovery from multiple failures
Date: Sun, 08 Jan 2012 12:12:30 -0800
Message-ID: <eu9pt8xa4l.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I recently had an experience very similar to what's posted on the wiki:

https://raid.wiki.kernel.org/articles/r/a/i/RAID_Recovery_d376.html

From what I can piece together from the logs, my controller went a
little crazy, and dropped a whole bunch of drives in a span of about
10 minutes.  I attempted to look at the output of mdadm --examine, as
documented in the wiki, but the format appears to have changed, so I
am unclear where to go next.

I'm going to include the entire mdadm --examine output below, but as I
was looking at it, I was wondering if the analogous scenario to the wiki
situation is to look at the array slots:

$ grep Slot raid.status |cut -f1 -d '('
    Array Slot : 0 
    Array Slot : 0 
    Array Slot : 13 
    Array Slot : 4 
    Array Slot : 10 
    Array Slot : 6 
    Array Slot : 7 
    Array Slot : 9 
    Array Slot : 8 
    Array Slot : 11 
    Array Slot : 2 
    Array Slot : 4 
    Array Slot : 12 

There are two separate arrays on this box; the problematic one is
24363b01:90deb9b5:4b51e5df:68b8b6ea.  Will I be able to recover this
array with an appropriate mdadm --create --assume-clean command, and if
so, how would I go about determining the correct order in which to
specify the drives?  The big confusing part for me is, as a 9 device
RAID6, I'd expect to see device slots 0-8, but here I see slots 10
through 13, and I am unclear how to get the order exactly right.

My mdadm --examine (which I have also saved separately) is below.  If
you need any more information let me know.  Thanks!

--keith


/dev/sdb1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 24363b01:90deb9b5:4b51e5df:68b8b6ea
           Name : 0
  Creation Time : Thu Sep 29 21:26:35 2011
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 3906227893 (1862.63 GiB 1999.99 GB)
     Array Size : 27343594880 (13038.44 GiB 13999.92 GB)
  Used Dev Size : 3906227840 (1862.63 GiB 1999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : active
    Device UUID : 7abdc565:f4f29c91:c92d41be:c4fe1fa9

    Update Time : Sat Jan  7 22:50:29 2012
       Checksum : 55d050cb - correct
         Events : 106059

     Chunk Size : 64K

    Array Slot : 0 (0, failed, failed, failed, 4, failed, 3, 7, 8, 5, 6, 2, empty, 1, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, fa
 iled, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, 
 failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed
 , failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed)
   Array State : Uuuuuuuuu 374 failed
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x4
     Array UUID : d835beeb:ae980218:ea6a9702:b21d7b29
           Name : 1
  Creation Time : Wed Dec  7 15:22:06 2011
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 390624831 (186.26 GiB 200.00 GB)
     Array Size : 1171808256 (558.76 GiB 599.97 GB)
  Used Dev Size : 390602752 (186.25 GiB 199.99 GB)
    Data Offset : 136 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : c3bb6c0a:4c470d1d:d8f113fc:3a8dfead

  Reshape pos'n : 7691712 (7.34 GiB 7.88 GB)
  Delta Devices : 1 (4->5)

    Update Time : Mon Dec 12 13:14:25 2011
       Checksum : 7713b627 - correct
         Events : 384

     Chunk Size : 64K

    Array Slot : 0 (0, 1, 2, 3, 4, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, faile
 d, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, fai
 led, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, f
 ailed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed)
   Array State : Uuuuu 379 failed
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 24363b01:90deb9b5:4b51e5df:68b8b6ea
           Name : 0
  Creation Time : Thu Sep 29 21:26:35 2011
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 3906227893 (1862.63 GiB 1999.99 GB)
     Array Size : 27343594880 (13038.44 GiB 13999.92 GB)
  Used Dev Size : 3906227840 (1862.63 GiB 1999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : c1a0df18:c7114a25:28129700:62db72ae

    Update Time : Sun Jan  8 09:36:19 2012
       Checksum : e43bab70 - correct
         Events : 106120

     Chunk Size : 64K

    Array Slot : 13 (failed, failed, failed, failed, 4, failed, failed, failed, failed, 5, failed, 2, empty, 1, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, 
 failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed
 , failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, fail
 ed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed)
   Array State : _Uu_uu___ 379 failed
/dev/sde1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 24363b01:90deb9b5:4b51e5df:68b8b6ea
           Name : 0
  Creation Time : Thu Sep 29 21:26:35 2011
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 3906227893 (1862.63 GiB 1999.99 GB)
     Array Size : 27343594880 (13038.44 GiB 13999.92 GB)
  Used Dev Size : 3906227840 (1862.63 GiB 1999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 07136a9d:e5206ada:4a54d22b:b90e6858

    Update Time : Sun Jan  8 09:36:19 2012
       Checksum : f316a245 - correct
         Events : 106120

     Chunk Size : 64K

    Array Slot : 4 (failed, failed, failed, failed, 4, failed, failed, failed, failed, 5, failed, 2, empty, 1, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, f
 ailed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed,
  failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, faile
 d, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed)
   Array State : _uu_Uu___ 379 failed
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 24363b01:90deb9b5:4b51e5df:68b8b6ea
           Name : 0
  Creation Time : Thu Sep 29 21:26:35 2011
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 3906227893 (1862.63 GiB 1999.99 GB)
     Array Size : 27343594880 (13038.44 GiB 13999.92 GB)
  Used Dev Size : 3906227840 (1862.63 GiB 1999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : active
    Device UUID : 6079c394:2acfaf27:2dc87760:a2cb1800

    Update Time : Sat Jan  7 22:50:29 2012
       Checksum : 14105032 - correct
         Events : 106059

     Chunk Size : 64K

    Array Slot : 10 (0, failed, failed, failed, 4, failed, 3, 7, 8, 5, 6, 2, empty, 1, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, f
 ailed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed,
  failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, faile
 d, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed)
   Array State : uuuuuuUuu 374 failed
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x2
     Array UUID : 24363b01:90deb9b5:4b51e5df:68b8b6ea
           Name : 0
  Creation Time : Thu Sep 29 21:26:35 2011
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 3906227893 (1862.63 GiB 1999.99 GB)
     Array Size : 27343594880 (13038.44 GiB 13999.92 GB)
  Used Dev Size : 3906227840 (1862.63 GiB 1999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
Recovery Offset : 0 sectors
          State : active
    Device UUID : e3b05100:736369e4:d7cc777f:029d08d6

    Update Time : Sat Jan  7 22:50:29 2012
       Checksum : 3147f687 - correct
         Events : 106059

     Chunk Size : 64K

    Array Slot : 6 (0, failed, failed, failed, 4, failed, 3, 7, 8, 5, 6, 2, empty, 1, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, fa
 iled, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, 
 failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed
 , failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed)
   Array State : uuuUuuuuu 374 failed
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 24363b01:90deb9b5:4b51e5df:68b8b6ea
           Name : 0
  Creation Time : Thu Sep 29 21:26:35 2011
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 3906227893 (1862.63 GiB 1999.99 GB)
     Array Size : 27343594880 (13038.44 GiB 13999.92 GB)
  Used Dev Size : 3906227840 (1862.63 GiB 1999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : active
    Device UUID : b5ec03cc:c659fcd8:1cbffa7c:7d99c2c2

    Update Time : Sat Jan  7 22:50:29 2012
       Checksum : dbca12f3 - correct
         Events : 106059

     Chunk Size : 64K

    Array Slot : 7 (0, failed, failed, failed, 4, failed, 3, 7, 8, 5, 6, 2, empty, 1, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, fa
 iled, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, 
 failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed
 , failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed)
   Array State : uuuuuuuUu 374 failed
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 24363b01:90deb9b5:4b51e5df:68b8b6ea
           Name : 0
  Creation Time : Thu Sep 29 21:26:35 2011
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 3906227893 (1862.63 GiB 1999.99 GB)
     Array Size : 27343594880 (13038.44 GiB 13999.92 GB)
  Used Dev Size : 3906227840 (1862.63 GiB 1999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 6726eb21:46024127:bb8ef26a:181eefc7

    Update Time : Sun Jan  8 09:36:19 2012
       Checksum : 7315e1db - correct
         Events : 106120

     Chunk Size : 64K

    Array Slot : 9 (failed, failed, failed, failed, 4, failed, failed, failed, failed, 5, failed, 2, empty, 1, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, f
 ailed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed,
  failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, faile
 d, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed)
   Array State : _uu_uU___ 379 failed
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 24363b01:90deb9b5:4b51e5df:68b8b6ea
           Name : 0
  Creation Time : Thu Sep 29 21:26:35 2011
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 3906227893 (1862.63 GiB 1999.99 GB)
     Array Size : 27343594880 (13038.44 GiB 13999.92 GB)
  Used Dev Size : 3906227840 (1862.63 GiB 1999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : active
    Device UUID : 1595f70a:1c1d5455:ca81c332:ae654260

    Update Time : Sat Jan  7 22:50:29 2012
       Checksum : ea5e0d7f - correct
         Events : 106059

     Chunk Size : 64K

    Array Slot : 8 (0, failed, failed, failed, 4, failed, 3, 7, 8, 5, 6, 2, empty, 1, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, fa
 iled, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, 
 failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed
 , failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed)
   Array State : uuuuuuuuU 374 failed
/dev/sdk1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 24363b01:90deb9b5:4b51e5df:68b8b6ea
           Name : 0
  Creation Time : Thu Sep 29 21:26:35 2011
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 3906227893 (1862.63 GiB 1999.99 GB)
     Array Size : 27343594880 (13038.44 GiB 13999.92 GB)
  Used Dev Size : 3906227840 (1862.63 GiB 1999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 483df5eb:76a6af2a:55eafe1a:1b084b16

    Update Time : Sun Jan  8 09:36:19 2012
       Checksum : 3ef6e18b - correct
         Events : 106120

     Chunk Size : 64K

    Array Slot : 11 (failed, failed, failed, failed, 4, failed, failed, failed, failed, 5, failed, 2, empty, 1, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, 
 failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed
 , failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, fail
 ed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed)
   Array State : _uU_uu___ 379 failed
/dev/sdl1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x4
     Array UUID : d835beeb:ae980218:ea6a9702:b21d7b29
           Name : 1
  Creation Time : Wed Dec  7 15:22:06 2011
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 390624831 (186.26 GiB 200.00 GB)
     Array Size : 1171808256 (558.76 GiB 599.97 GB)
  Used Dev Size : 390602752 (186.25 GiB 199.99 GB)
    Data Offset : 136 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 67b71288:2113a126:6ddc3a2a:6c317bde

  Reshape pos'n : 7691712 (7.34 GiB 7.88 GB)
  Delta Devices : 1 (4->5)

    Update Time : Mon Dec 12 13:14:25 2011
       Checksum : 5cef3831 - correct
         Events : 384

     Chunk Size : 64K

    Array Slot : 2 (0, 1, 2, 3, 4, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, faile
 d, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, fai
 led, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, f
 ailed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed)
   Array State : uuUuu 379 failed
/dev/sdm1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x4
     Array UUID : d835beeb:ae980218:ea6a9702:b21d7b29
           Name : 1
  Creation Time : Wed Dec  7 15:22:06 2011
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 390624831 (186.26 GiB 200.00 GB)
     Array Size : 1171808256 (558.76 GiB 599.97 GB)
  Used Dev Size : 390602752 (186.25 GiB 199.99 GB)
    Data Offset : 136 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : fc8330af:564224ff:dfff62e8:476b9635

  Reshape pos'n : 7691712 (7.34 GiB 7.88 GB)
  Delta Devices : 1 (4->5)

    Update Time : Mon Dec 12 13:14:25 2011
       Checksum : 71d39a8b - correct
         Events : 384

     Chunk Size : 64K

    Array Slot : 4 (0, 1, 2, 3, 4, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, faile
 d, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, fai
 led, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, f
 ailed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed)
   Array State : uuuuU 379 failed
/dev/sdn1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 24363b01:90deb9b5:4b51e5df:68b8b6ea
           Name : 0
  Creation Time : Thu Sep 29 21:26:35 2011
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 3906227893 (1862.63 GiB 1999.99 GB)
     Array Size : 27343594880 (13038.44 GiB 13999.92 GB)
  Used Dev Size : 3906227840 (1862.63 GiB 1999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 851b031b:faa4ee37:89c05950:b4746150

    Update Time : Sun Jan  8 09:36:19 2012
       Checksum : eab50119 - correct
         Events : 106120

     Chunk Size : 64K

    Array Slot : 12 (failed, failed, failed, failed, 4, failed, failed, failed, failed, 5, failed, 2, empty, 1, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, 
 failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed
 , failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, fail
 ed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed, failed)
   Array State : _uu_uu___ 379 failed


-- 
kkeller@wombat.san-francisco.ca.us


