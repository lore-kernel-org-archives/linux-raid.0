From: Marc MERLIN <marc@merlins.org>
Subject: 9 second recovery when re-adding a drive that got kicked out?
Date: Sun, 4 Jun 2017 15:38:17 -0700
Message-ID: <20170604223817.ntxlvafgfa2umww2@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Howdy,

Can you confirm that I understand how the write intent bitmap works, and
that it doesn't cover the entire array, but only a part of it, and once
you overflow it, syncing reverts to syncing the entire array?

I had a raid5 array with 5 6TB drives.

/dev/sdl1 got kicked out due to a bus disk error of some kind.
The drive is fine, it was a cabling issue, so I fixed the cabling,
re-added it, and did

gargamel:~# mdadm -a /dev/md6 /dev/sdl1

Then I saw this:
[ 1001.728134] md: recovery of RAID array md6
[ 1010.975255] md: md6: recovery done.

Before the re-add:
md6 : active raid5 sdk1[5] sdb1[3] sdm1[2] sdj1[1]
      23441555456 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/4] [_UUUU]
      bitmap: 3/44 pages [12KB], 65536KB chunk

After the re-add (syncing now just to be safe):
md6 : active raid5 sdl1[0] sdj1[1] sdk1[5] sdf1[3] sdm1[2]
      23441555456 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
      [>....................]  check =  0.8% (49258960/5860388864) finish=569.3min speed=170093K/sec
      bitmap: 0/44 pages [0KB], 65536KB chunk

https://raid.wiki.kernel.org/index.php/Mdstat
Explains a bit, I don't think it says how big a page is, but it seems to
be 4KB.

So let's say I have 64MB chuncks, each take 16 bits.
The whole array is 22,892,144MiB
That's 357,689 chunks, or about 700KB (16 bits per chunk) to keep all the
state, but there is 44 pages of 4KB, or 176KB of write intent
state.

The first bitmap line shows 3 pages totallying 12KB, so each page
contains 4KB, or 2048 chunks per page.
Did the above say that I had 6144 chunks that needed to be synced?

If so it would be 6144 * 65536KB = 393,216 MB to write
They were written in 9 seconds, so the sync happened at 43MB/s, which is
believeable.

The part I'm not too clear about is 44 pages of intent isn't enough to
cover all my data.
Is the idea that once I overflow that write intent bitmap, then it
reverts to resyncing the entire array?

I looked at https://raid.wiki.kernel.org/index.php/Write-intent_bitmap
but didn't see anything about that specific bit.


Array details if that helps:
gargamel:~# mdadm --examine /dev/sdl1
/dev/sdl1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 66bccdfb:afbf9683:fcf1f12e:f2af2dcb
           Name : gargamel.svh.merlins.org:6  (local to host gargamel.svh.merlins.org)
  Creation Time : Thu Jan 28 14:38:40 2016
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 11720777728 (5588.90 GiB 6001.04 GB)
     Array Size : 23441555456 (22355.61 GiB 24004.15 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : ca4598ba:de585baa:b9935222:e06ac97d

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Jun  4 15:08:45 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : d645f600 - correct
         Events : 84917

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
