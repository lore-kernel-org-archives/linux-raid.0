From: Hans Kraus <hans@hanswkraus.com>
Subject: mdadm creates corrupt superblock
Date: Tue, 28 Oct 2014 19:06:20 +0100
Message-ID: <544FDB1C.5030306@hanswkraus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I debugged my problem a bit more: it seems that mdadm creates a defect
superblock. That's repeatedly happening, but only for one drive. I
copied zeros to that drive (via ddrescue /dev/zero ...) and the drive
looks OK. The info I got:
=================================================================================================================================================================================================
root@nashorn:/home/kraush/work/smartctrl# mdadm --zero-superblock /dev/sde1
mdadm: Unrecognised md component device - /dev/sde1
root@nashorn:/home/kraush/work/smartctrl# mdadm --add /dev/md126 /dev/sde1
mdadm: add new device failed for /dev/sde1 as 4: Invalid argument
root@nashorn:/home/kraush/work/smartctrl# mdadm -E /dev/sde1
/dev/sde1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : e7caa5d1:b33fd2a5:7782fb0c:9d8d9d5b
            Name : nashorn:126  (local to host nashorn)
   Creation Time : Mon Oct 27 15:58:38 2014
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 1953260976 (931.39 GiB 1000.07 GB)
      Array Size : 0
   Used Dev Size : 0
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=1953260976 sectors
           State : clean
     Device UUID : 4d1420c6:79978477:e86412b1:24beebfc

Internal Bitmap : 8 sectors from superblock
     Update Time : Tue Oct 28 11:53:49 2014
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 6f02d040 - expected 891eedff
          Events : 0


    Device Role : spare
    Array State : RR ('A' == active, '.' == missing, 'R' == replacing)
root@nashorn:/home/kraush/work/smartctrl#
-----------------------------------------------------------------------------------------------------------
root@nashorn:/home/kraush/work/smartctrl# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md127 : active (auto-read-only) raid6 sda1[0] sdk1[6](S) sdl2[7](S) 
sdh1[5] sdg1[4] sdf1[3] sdc1[2] sdb1[1]
       1953017856 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[6/6] [UUUUUU]
       bitmap: 0/4 pages [0KB], 65536KB chunk

md10 : active (auto-read-only) raid1 sdi2[0] sdl3[1]
       87833408 blocks super 1.2 [2/2] [UU]
       bitmap: 0/1 pages [0KB], 65536KB chunk

md126 : active raid1 sdd1[3] sdj1[2]
       488254464 blocks super 1.2 [2/2] [UU]
       bitmap: 0/4 pages [0KB], 65536KB chunk

md0 : active raid1 sdl1[4] sdd2[3] sdi1[5]
       156157824 blocks super 1.2 [3/1] [U__]
       [===================>.]  recovery = 95.6% (149290048/156157824) 
finish=8.4min speed=13496K/sec
       bitmap: 1/2 pages [4KB], 65536KB chunk

unused devices: <none>
root@nashorn:/home/kraush/work/smartctrl#
-----------------------------------------------------------------------------------------------------------
dmesg:
[33299.387382] md: invalid superblock checksum on sde1
[33299.387385] md: sde1 does not have a valid v1.2 superblock, not 
importing!
[33299.387408] md: md_import_device returned -22
root@nashorn:/home/kraush/work/smartctrl#
-----------------------------------------------------------------------------------------------------------
root@nashorn:/home/kraush/work/mdadm# mdadm --version
mdadm - v3.3-161-gfed12d4 - 21st August 2014
=================================================================================================================================================================================================

Kind regards, Hans
