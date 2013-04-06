From: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: Help, array corrupted after clean shutdown.
Date: Sat, 06 Apr 2013 20:34:12 +0200
Message-ID: <51606AA4.4050809@schinagl.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

the following message was initially sent to linux-raid, but there they 
said it was very most likly an ext4 corruption. I left it in tact as it 
explains what happened to as much detail as I could provide. I marked 
the start of that message with =======

Some additional information, I have put the ext4 filesystem on top of a 
md raid5 array of 4 disks and tune2fs reports the following:

riley tmp # tune2fs -l /dev/md101
tune2fs 1.42 (29-Nov-2011)
Filesystem volume name:   data01
Last mounted on:          /tank/01
Filesystem UUID:          9c812d61-96ce-4b71-9763-b77e8b9618d1
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index 
filetype extent flex_bg sparse_super large_file huge_file uninit_bg 
dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         not clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              274718720
Block count:              1098853440
Reserved block count:     0
Free blocks:              228693396
Free inodes:              274387775
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      762
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
RAID stride:              64
RAID stripe width:        192
Flex block group size:    16
Filesystem created:       Wed Apr 28 16:42:58 2010
Last mount time:          Tue May  4 17:14:48 2010
Last write time:          Sat Apr  6 11:45:57 2013
Mount count:              10
Maximum mount count:      32
Last checked:             Wed Apr 28 16:42:58 2010
Check interval:           15552000 (6 months)
Next check after:         Mon Oct 25 16:42:58 2010
Lifetime writes:          3591 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       17
Default directory hash:   half_md4
Directory Hash Seed:      f1248a94-5a6a-4e4a-af8a-68b019d13ef6
Journal backup:           inode blocks

The strange thing is, 'last checked' and is set to somewhere in 2010. 
While an automatic check never has run, I always check with fsck -f 
/dev/md101 -C - before each mount and before/after each reboot 
religiously. The last write time is most likly when I tried to run fsck 
and it came with tons of errors, well only 1 error repeating after each 
descriptor:

riley tmp # fsck -n /dev/md101 -C -
fsck from util-linux 2.21.2
e2fsck 1.42 (29-Nov-2011)
One or more block group descriptor checksums are invalid.  Fix? no

Group descriptor 0 checksum is invalid.  IGNORED.
Group descriptor 1 checksum is invalid.  IGNORED.
Group descriptor 2 checksum is invalid.  IGNORED.

It hasn't automatically tried the backup blocks yet, but I am very very 
hesitant to let it get fixed, in case I loose everything.

I can mount it in 'ro' only mode, but have no clue on the validity  of 
the data. (I tried mounting normally earlier today, but got errors about 
not being an ext4 fs).

Looking at dmesg after the successful mount I get:
[38006.011956] EXT4-fs (md101): ext4_check_descriptors: Checksum for 
group 33532 failed (23179!=34446)
[38006.011958] EXT4-fs (md101): ext4_check_descriptors: Checksum for 
group 33533 failed (64080!=9813)
[38006.011960] EXT4-fs (md101): ext4_check_descriptors: Checksum for 
group 33534 failed (44694!=46442)
[38006.026547] EXT4-fs (md101): write access unavailable, skipping 
orphan cleanup
[38006.026548] EXT4-fs (md101): recovery complete
[38006.026551] EXT4-fs (md101): mounted filesystem with writeback data 
mode. Opts: commit=120,data=writeback

(I can't scroll up to group 0, 1, 2 to mach the above bit, and I 
ctrl-c'ed fsck -n around there).

Should I be worried? I do not think I changed my kernel in the last two 
weeks (def. not a new version) but it is possible I recompiled and 
installed it without reboot, to enable certain features.

I will try meanwhile to copy 4 TB of data elsewhere (lets pray I have 
enough space) and if so re-create my ext4 FS?

Thanks, and sorry about the confusing with the new/original message bit. 
Corrupted FS (that of course are not properly backed up) have had me on 
edge all day :(

Oliver

=======
original message:

I've had a powerfailure today, to which my UPS responded nicely and made 
my server shutdown normally. One would expect everything is well, right? 
The array, as far as I know, was operating without problems before the 
shutdown, all 4 devices where normally online. mdadm sends me an e-mail 
if something is wrong, so does smartctl.

First thing I noticed that I had 2 (S) drives for /dev/md101. I thus 
started examining things. First I thought that it was some mdadm 
weirdness, where it failed to assemble the drive with all components.
mdadm -A /dev/md101 /dev/sd[cdef]1 failed and gave the same result. 
Something was really wrong.

I checked and compared the output of mdadm --examine on all drives (like 
-Evvvs below) and found that /dev/sdc1's events count was wrong.
/dev/sdf1 and /dev/sdd1 matched (and later sde1 too, but more on that in 
a sec). So sdc1 may have been dropped from the array without me knowing 
it, unlikely put possible. The odd thing is the huge difference in event 
counts, but all four are marked as ACTIVE.

So then onto sde1; why was it failing on that. The gpt table was 
completly gone. 00000. Gone. I used hexdump to examine the drive 
further, and at 0x00041000 there was the mdraid table, as one would 
expect. Good, so it looks like only the gpt has been wiped for some 
misterious reason. Re-creating the gpt quickly revealed mdadm's 
information was still correct (as can be seen below).

So ignore sdc1 and assemble the drive as is should be fine? Right? No.
mdadm -A /dev/md101 /dev/sd[def]1 worked without error.

I always do a fsck before and after a reboot (unless of course I can't 
do the shutdown fsck) and verify /proc/mdadm after a boot. So before 
mounting, as always, I tried to run fsck /dev/md101 -C -; but that came 
up with tons of errors. I didn't fix anything and aborted.

And here we are now. I can't just copy the entire disk (1.5TB per disk) 
and 'experiment', I don't have 4 spare disks. The first thing I would 
want to try is is mdadm -A /dev/sd[cdf]1 --force (leave out the possibly 
corrupted sde1) and see what that does.


All that said when I did the assemble with the 'guessed' 3 correct 
drives. Did of course increase the events count. sdc1 of course didn't 
partake in this. Assuming that it is in sync with the rest, what is the 
worst that can happen? And does the --read-only flag protect against it?


Linux riley 3.7.4-gentoo #2 SMP Tue Feb 5 16:20:59 CET 2013 x86_64 AMD 
Phenom(tm) II X4 905e Processor AuthenticAMD GNU/Linux

riley tmp # mdadm --version
mdadm - v3.1.4 - 31st August 2010


riley tmp # mdadm -Evvvvs
/dev/sdf1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 2becc012:2d317133:2447784c:1aab300d
            Name : riley:data01  (local to host riley)
   Creation Time : Tue Apr 27 18:03:37 2010
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 2930276351 (1397.26 GiB 1500.30 GB)
      Array Size : 8790827520 (4191.79 GiB 4500.90 GB)
   Used Dev Size : 2930275840 (1397.26 GiB 1500.30 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 97877935:04c16c5f:0746cb98:63bffb4c

     Update Time : Sat Apr  6 11:46:03 2013
        Checksum : b585717a - correct
          Events : 512993

          Layout : left-symmetric
      Chunk Size : 256K

    Device Role : Active device 1
    Array State : AA.A ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sdf.
/dev/sde1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 2becc012:2d317133:2447784c:1aab300d
            Name : riley:data01  (local to host riley)
   Creation Time : Tue Apr 27 18:03:37 2010
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 2930275847 (1397.26 GiB 1500.30 GB)
      Array Size : 8790827520 (4191.79 GiB 4500.90 GB)
   Used Dev Size : 2930275840 (1397.26 GiB 1500.30 GB)
     Data Offset : 776 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 3f48d5a8:e3ee47a1:23c8b895:addd3dd0

     Update Time : Sat Apr  6 11:46:03 2013
        Checksum : eaec006b - correct
          Events : 512993

          Layout : left-symmetric
      Chunk Size : 256K

    Device Role : Active device 3
    Array State : AA.A ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sde.
/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 2becc012:2d317133:2447784c:1aab300d
            Name : riley:data01  (local to host riley)
   Creation Time : Tue Apr 27 18:03:37 2010
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 2930276351 (1397.26 GiB 1500.30 GB)
      Array Size : 8790827520 (4191.79 GiB 4500.90 GB)
   Used Dev Size : 2930275840 (1397.26 GiB 1500.30 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 236f6c48:2a1bcf6b:a7d7d861:53950637

     Update Time : Sat Apr  6 11:46:03 2013
        Checksum : 87f31abb - correct
          Events : 512993

          Layout : left-symmetric
      Chunk Size : 256K

    Device Role : Active device 0
    Array State : AA.A ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sdd.
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 2becc012:2d317133:2447784c:1aab300d
            Name : riley:data01  (local to host riley)
   Creation Time : Tue Apr 27 18:03:37 2010
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 2930276351 (1397.26 GiB 1500.30 GB)
      Array Size : 8790827520 (4191.79 GiB 4500.90 GB)
   Used Dev Size : 2930275840 (1397.26 GiB 1500.30 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 3ce8e262:ad864aee:9055af9b:6cbfd47f

     Update Time : Sat Mar 16 20:20:47 2013
        Checksum : a7686a57 - correct
          Events : 180132

          Layout : left-symmetric
      Chunk Size : 256K

    Device Role : Active device 2
    Array State : AAAA ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sdc.


Before I assembled the array for the first time (mdadm -A /dev/md101 
/dev/sdd1 /dev/sde1 /dev/sdf1), this is how it looked like:
So identical to the above, wtih the exception of the number of events.

riley tmp # mdadm --examine /dev/sde1
/dev/sde1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 2becc012:2d317133:2447784c:1aab300d
            Name : riley:data01  (local to host riley)
   Creation Time : Tue Apr 27 18:03:37 2010
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 2930275847 (1397.26 GiB 1500.30 GB)
      Array Size : 8790827520 (4191.79 GiB 4500.90 GB)
   Used Dev Size : 2930275840 (1397.26 GiB 1500.30 GB)
     Data Offset : 776 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 3f48d5a8:e3ee47a1:23c8b895:addd3dd0

     Update Time : Sat Apr  6 09:44:30 2013
        Checksum : eaebe3ea - correct
          Events : 512989

          Layout : left-symmetric
      Chunk Size : 256K

    Device Role : Active device 3
    Array State : AA.A ('A' == active, '.' == missing)

