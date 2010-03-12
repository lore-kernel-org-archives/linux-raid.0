From: Kapetanakis Giannis <bilias@edu.physics.uoc.gr>
Subject: large filesystem corruptions
Date: Fri, 12 Mar 2010 22:01:05 +0200
Message-ID: <4B9A9D81.3000009@edu.physics.uoc.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

The last few days I'm trying to setup a large filesystem
14TB and is always getting corrupted...

This is my latest non-working setup. Sorry for long message
but I want to make clear my  actual setup

2.6.18-164.11.1.el5PAE (x86)
4GB RAM

CONFIG_EFI_VARS=y
CONFIG_EFI=y

/dev/sdb - 6 x 1.5TB SATA drives in hardware RAID 5 (256 chunk size)
/dev/sdc - 6 x 1.5TB SATA drives in hardware RAID 5 (256 chunk size)

-- Both hardware raids are GPT labeled

Model: Adaptec ARRAY01 (scsi)
Disk /dev/sdb: 7489GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name     Flags
  1      17.4kB  7489GB  7489GB               ARRAY01

Model: Adaptec ARRAY02 (scsi)
Disk /dev/sdc: 7489GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name     Flags
  1      17.4kB  7489GB  7489GB               ARRAY02

-- /dev/md_d0 software raid0 on /dev/sdb1 and /dev/sdc1
-- (doing on /dev/sdb and /dev/sdc also corrupted)
-- this raid0 is also GPT labeled (256 chunk size)

mdadm --create /dev/md_d0 -a p1 -c 256 -l 0 -n 2 /dev/sdb1 /dev/sdc1

   md_d0 : active raid0 sdb1[0] sdc1[1]
       14627614208 blocks 256k chunks

Model: Unknown (unknown)
Disk /dev/md_d0: 15.0TB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name     Flags
  1      17.4kB  15.0TB  15.0TB               primary


-- LVM2 on top of /dev/md_d0p1

  --- Physical volume ---
   PV Name               /dev/md_d0p1
   VG Name               vgshare
   PV Size               13.62 TB / not usable 3.47 MB
   PE Size (KByte)       4096

   --- Volume group ---
   VG Name               vgshare
   System ID
   Format                lvm2
   VG Size               13.62 TB
   PE Size               4.00 MB

   --- Logical volume ---
   LV Name                /dev/vgshare/share
   VG Name                vgshare
   LV UUID                Aoj27F-kf4U-i6XE-eNWg-hMLX-MS1h-s3oArp
   LV Write Access        read/write
   LV Status              available
   # open                 0
   LV Size                7.00 TB
   Current LE             1835008
   Segments               1
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     2048
   Block device           253:4

-- /dev/vgshare/share is ext4 formated with
mkfs.ext4 -b 4096 -E stride=64,stripe-width=128 /dev/md_d0p1

All well so far. And I start write data...

Then I create a new 2TB test lv
and format it.

/share_7TB is lost, /test_2TB is there....

Mar 12 21:13:28 server kernel: EXT4-fs error (device dm-4): 
ext4_mb_generate_buddy: EXT4-fs: group 0: 32768 blocks in bitmap, 3248 in gd
Mar 12 21:13:30 server kernel: EXT4-fs error (device dm-4): 
ext4_mb_generate_buddy: EXT4-fs: group 1648: 24544 blocks in bitmap, 153 
in gd
Mar 12 21:13:31 server kernel: attempt to access beyond end of device
Mar 12 21:13:31 server kernel: dm-4: rw=2, want=15493450520, 
limit=15032385536
Mar 12 21:13:31 server kernel: attempt to access beyond end of device
--snip
Mar 12 21:17:49 server kernel: EXT4-fs error (device dm-4): 
ext4_mb_release_inode_pa: free 1802, pa_free 1458
Mar 12 21:17:49 server kernel: EXT4-fs: mballoc: 93430033 blocks 705745 
reqs (482734 success)
Mar 12 21:17:49 server kernel: EXT4-fs: mballoc: 327298 extents scanned, 
241152 goal hits, 219206 2^N hits, 0 breaks, 0 lost
Mar 12 21:17:49 server kernel: EXT4-fs: mballoc: 9561 generated and it 
took 2012010656
Mar 12 21:17:49 server kernel: EXT4-fs: mballoc: 85047925 preallocated, 
30759591 discarded
Mar 12 21:18:09 server kernel: EXT4-fs: ext4_check_descriptors: Inode 
table for group 0 not in group (block 1936681314)!
Mar 12 21:18:09 server kernel: EXT4-fs: group descriptors corrupted!

GFS instead of ext4 also corrupted.

ext4 on top of /dev/md0 (non partitioned) on top of /dev/sdb /dev/sdc 
(without GPT) also corrupted.

I want to use software raid0 on top of the two hardware radi5
for better performance.

I understood that labeling GPT would solve this problem.
Is it x86 problem? Something fishy with my setup probably
but can't figure it out.

thanks and sorry for long message,
but I can't find a way to get this mirror server up
on it's feet again after this upgrade....

regards,

Giannis






