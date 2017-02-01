From: Thomas Warntjen <thomas@warntjen.net>
Subject: Re: drives failed during reshape, array won't even force-assemble
Date: Wed, 1 Feb 2017 19:55:22 +0100
Message-ID: <ddc96793-cde0-33a7-b193-585efd74a202@warntjen.net>
References: <d08f3721-6a72-3fc3-58d6-29034a6962f1@warntjen.net>
 <73c909f6-5bf3-06c5-368f-2a641a3445b7@turmel.org>
 <d49d7786-1174-0e96-e857-f2b2b6144c1b@warntjen.net>
 <fb9787fd-4047-cc53-a926-f9715d7faee6@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fb9787fd-4047-cc53-a926-f9715d7faee6@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Holy cow, I poked it with a stick and I think I did it!

As I've wrote before after a reboot the array was there but didn't 
start, and I've noticed the same thing happend with the overlay files 
right after I created them:

# /cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4] [linear] [multipath] 
[raid0] [raid10]
md1 : inactive dm-0[8](S) dm-1[6](S) dm-7[4](S) dm-6[2](S) dm-5[0](S) 
dm-3[1](S) dm-4[5](S) dm-2[3](S)
       23429580800 blocks super 0.91

# mdadm --detail /dev/md1
/dev/md1:
         Version : 0.91
      Raid Level : raid0
   Total Devices : 8
Preferred Minor : 0
     Persistence : Superblock is persistent

           State : inactive

       New Level : raid6
      New Layout : left-symmetric
   New Chunksize : 64K

            UUID : 7a58ed4f:baf1934e:a2963c6e:a542ed71
          Events : 0.12370980

     Number   Major   Minor   RaidDevice

        -     252        0        -        /dev/dm-0
        -     252        1        -        /dev/dm-1
        -     252        2        -        /dev/dm-2
        -     252        3        -        /dev/dm-3
        -     252        4        -        /dev/dm-4
        -     252        5        -        /dev/dm-5
        -     252        6        -        /dev/dm-6
        -     252        7        -        /dev/dm-7

	
Now I tried

# mdadm --run /dev/md1
mdadm: failed to start array /dev/md1: Input/output error


and something interesting happend:

# mdadm --detail /dev/md1
/dev/md1:
         Version : 0.91
   Creation Time : Thu Sep  1 22:23:00 2011
      Raid Level : raid6
   Used Dev Size : 18446744073709551615
    Raid Devices : 7
   Total Devices : 6
Preferred Minor : 1
     Persistence : Superblock is persistent

     Update Time : Tue Jan 24 21:10:19 2017
           State : active, FAILED, Not Started
  Active Devices : 4
Working Devices : 6
  Failed Devices : 0
   Spare Devices : 2

          Layout : left-symmetric-6
      Chunk Size : 64K

      New Layout : left-symmetric

            UUID : 7a58ed4f:baf1934e:a2963c6e:a542ed71
          Events : 0.12370980

     Number   Major   Minor   RaidDevice State
        0     252        5        0      active sync   /dev/dm-5
        1     252        3        1      active sync   /dev/dm-3
        2     252        6        2      active sync   /dev/dm-6
        3     252        2        3      active sync   /dev/dm-2
        -       0        0        4      removed
        -       0        0        5      removed
        6     252        1        6      spare rebuilding   /dev/dm-1

        8     252        0        -      spare   /dev/dm-0
	
	
let's try to add the missing drives:

# mdadm --manage /dev/md1 --add /dev/mapper/sdc3
mdadm: re-added /dev/mapper/sdc3
	
# mdadm --manage /dev/md1 --add /dev/mapper/sdd3
mdadm: re-added /dev/mapper/sdd3
	
# mdadm --detail /dev/md1
detail /dev/md1
/dev/md1:
         Version : 0.91
   Creation Time : Thu Sep  1 22:23:00 2011
      Raid Level : raid6
   Used Dev Size : 18446744073709551615
    Raid Devices : 7
   Total Devices : 8
Preferred Minor : 1
     Persistence : Superblock is persistent

     Update Time : Tue Jan 24 21:10:19 2017
           State : active, degraded, Not Started
  Active Devices : 6
Working Devices : 8
  Failed Devices : 0
   Spare Devices : 2

          Layout : left-symmetric-6
      Chunk Size : 64K

      New Layout : left-symmetric

            UUID : 7a58ed4f:baf1934e:a2963c6e:a542ed71
          Events : 0.12370980

     Number   Major   Minor   RaidDevice State
        0     252        5        0      active sync   /dev/dm-5
        1     252        3        1      active sync   /dev/dm-3
        2     252        6        2      active sync   /dev/dm-6
        3     252        2        3      active sync   /dev/dm-2
        4     252        7        4      active sync   /dev/dm-7
        5     252        4        5      active sync   /dev/dm-4
        6     252        1        6      spare rebuilding   /dev/dm-1

        8     252        0        -      spare   /dev/dm-0
	

Not bad at all! But it still won't start, even with --run.  Maybe if I 
wait long enough for the rebuild to finish? But I still don't see it in 
/proc/mdstat and I don't want to wait for several days to see if it 
really rebuilds in the background.

So I poke it with a stick...

# echo "clean" > /sys/block/md1/md/array_state
-bash: echo: write error: Invalid argument	

nope

# echo "active" > /sys/block/md1/md/array_state
-bash: echo: write error: Invalid argument	

nope

# echo "readonly" > /sys/block/md1/md/array_state

wait, no error?

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4] [linear] [multipath] 
[raid0] [raid10]
md1 : active (read-only) raid6 dm-0[5] dm-2[4] dm-7[6] dm-6[3] dm-4[0] 
dm-1[2] dm-5[1] dm-3[8](S)
       14643488000 blocks super 0.91 level 6, 64k chunk, algorithm 18 
[7/6] [UUUUUU_]
       resync=PENDING
       bitmap: 175/175 pages [700KB], 8192KB chunk

# mdadm --detail /dev/md1
/dev/md1:
         Version : 0.91
   Creation Time : Thu Sep  1 22:23:00 2011
      Raid Level : raid6
      Array Size : 14643488000 (13965.12 GiB 14994.93 GB)
   Used Dev Size : 18446744073709551615
    Raid Devices : 7
   Total Devices : 8
Preferred Minor : 1
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Tue Jan 24 21:10:19 2017
           State : clean, degraded, resyncing (PENDING)
  Active Devices : 6
Working Devices : 8
  Failed Devices : 0
   Spare Devices : 2

          Layout : left-symmetric-6
      Chunk Size : 64K

      New Layout : left-symmetric

            UUID : 7a58ed4f:baf1934e:a2963c6e:a542ed71
          Events : 0.12370980

     Number   Major   Minor   RaidDevice State
        0     252        4        0      active sync   /dev/dm-4
        1     252        5        1      active sync   /dev/dm-5
        2     252        1        2      active sync   /dev/dm-1
        3     252        6        3      active sync   /dev/dm-6
        4     252        2        4      active sync   /dev/dm-2
        5     252        0        5      active sync   /dev/dm-0
        6     252        7        6      spare rebuilding   /dev/dm-7

        8     252        3        -      spare   /dev/dm-3


still no error
	
# echo "clean" > /sys/block/md1/md/array_state

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4] [linear] [multipath] 
[raid0] [raid10]
md1 : active raid6 raid6 dm-0[5] dm-2[4] dm-7[6] dm-6[3] dm-4[0] dm-1[2] 
dm-5[1] dm-3[8](S)
       14643488000 blocks super 0.91 level 6, 64k chunk, algorithm 18 
[7/6] [UUUUUU_]
       [==============>......]  reshape = 74.6% (2185464448/2928697600) 
finish=7719.3min speed=1603K/sec
       bitmap: 175/175 pages [700KB], 8192KB chunk
       14643488000 blocks super 0.91 level 6, 64k chunk, algorithm 18 
[7/6] [UUUUUU_]
       resync=PENDING
       bitmap: 175/175 pages [700KB], 8192KB chunk

# mdadm --detail /dev/md1
/dev/md1:
         Version : 0.91
   Creation Time : Thu Sep  1 22:23:00 2011
      Raid Level : raid6
      Array Size : 14643488000 (13965.12 GiB 14994.93 GB)
   Used Dev Size : 18446744073709551615
    Raid Devices : 7
   Total Devices : 8
Preferred Minor : 1
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Tue Jan 31 20:09:30 2017
           State : clean, degraded, reshaping
  Active Devices : 6
Working Devices : 8
  Failed Devices : 0
   Spare Devices : 2

          Layout : left-symmetric-6
      Chunk Size : 64K

  Reshape Status : 74% complete
      New Layout : left-symmetric

            UUID : 7a58ed4f:baf1934e:a2963c6e:a542ed71
          Events : 0.12370982

     Number   Major   Minor   RaidDevice State
        0     252        4        0      active sync   /dev/dm-4
        1     252        5        1      active sync   /dev/dm-5
        2     252        1        2      active sync   /dev/dm-1
        3     252        6        3      active sync   /dev/dm-6
        4     252        2        4      active sync   /dev/dm-2
        5     252        0        5      active sync   /dev/dm-0
        6     252        7        6      spare rebuilding   /dev/dm-7

        8     252        3        -      spare   /dev/dm-3

	
Looks good! fsck shows no errors, nothing in lost+found, so I've stopped 
the reshape (so the overlays won't fill the disk), mounted it readonly 
and backed up the more important data. That finished today, so I 
rebooted and did it for real. Reshape is finished, resync at 24% (6 
hours to go), fsck still looks good. w00t!

	
