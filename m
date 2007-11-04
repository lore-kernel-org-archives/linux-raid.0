From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 2.6.23.1: mdadm/raid5 hung/d-state
Date: Sun, 4 Nov 2007 07:03:30 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

# ps auxww | grep D
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root       273  0.0  0.0      0     0 ?        D    Oct21  14:40 [pdflush]
root       274  0.0  0.0      0     0 ?        D    Oct21  13:00 [pdflush]

After several days/weeks, this is the second time this has happened, while 
doing regular file I/O (decompressing a file), everything on the device 
went into D-state.

# mdadm -D /dev/md3
/dev/md3:
         Version : 00.90.03
   Creation Time : Wed Aug 22 10:38:53 2007
      Raid Level : raid5
      Array Size : 1318680576 (1257.59 GiB 1350.33 GB)
   Used Dev Size : 146520064 (139.73 GiB 150.04 GB)
    Raid Devices : 10
   Total Devices : 10
Preferred Minor : 3
     Persistence : Superblock is persistent

     Update Time : Sun Nov  4 06:38:29 2007
           State : active
  Active Devices : 10
Working Devices : 10
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 1024K

            UUID : e37a12d1:1b0b989a:083fb634:68e9eb49
          Events : 0.4309

     Number   Major   Minor   RaidDevice State
        0       8       33        0      active sync   /dev/sdc1
        1       8       49        1      active sync   /dev/sdd1
        2       8       65        2      active sync   /dev/sde1
        3       8       81        3      active sync   /dev/sdf1
        4       8       97        4      active sync   /dev/sdg1
        5       8      113        5      active sync   /dev/sdh1
        6       8      129        6      active sync   /dev/sdi1
        7       8      145        7      active sync   /dev/sdj1
        8       8      161        8      active sync   /dev/sdk1
        9       8      177        9      active sync   /dev/sdl1

If I wanted to find out what is causing this, what type of debugging would 
I have to enable to track it down?  Any attempt to read/write files on the 
devices fails (also going into d-state).  Is there any useful information 
I can get currently before rebooting the machine?

# pwd
/sys/block/md3/md
# ls
array_state      dev-sdj1/         rd2@              stripe_cache_active
bitmap_set_bits  dev-sdk1/         rd3@              stripe_cache_size
chunk_size       dev-sdl1/         rd4@              suspend_hi
component_size   layout            rd5@              suspend_lo
dev-sdc1/        level             rd6@              sync_action
dev-sdd1/        metadata_version  rd7@              sync_completed
dev-sde1/        mismatch_cnt      rd8@              sync_speed
dev-sdf1/        new_dev           rd9@              sync_speed_max
dev-sdg1/        raid_disks        reshape_position  sync_speed_min
dev-sdh1/        rd0@              resync_start
dev-sdi1/        rd1@              safe_mode_delay
# cat array_state
active-idle
# cat mismatch_cnt
0
# cat stripe_cache_active
1
# cat stripe_cache_size
16384
# cat sync_action
idle
# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md1 : active raid1 sdb2[1] sda2[0]
       136448 blocks [2/2] [UU]

md2 : active raid1 sdb3[1] sda3[0]
       129596288 blocks [2/2] [UU]

md3 : active raid5 sdl1[9] sdk1[8] sdj1[7] sdi1[6] sdh1[5] sdg1[4] sdf1[3] 
sde1[2] sdd1[1] sdc1[0]
       1318680576 blocks level 5, 1024k chunk, algorithm 2 [10/10] 
[UUUUUUUUUU]

md0 : active raid1 sdb1[1] sda1[0]
       16787776 blocks [2/2] [UU]

unused devices: <none>
#

Justin.
