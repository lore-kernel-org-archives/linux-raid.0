From: Mike Hardy <mhardy@h3c.com>
Subject: raidreconf / growing raid 5 doesn't seem to work anymore
Date: Sun, 03 Apr 2005 19:52:56 -0700
Message-ID: <4250AC08.6020009@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello all -

This is more of a cautionary tale than anything, as I have not attempted
to determine the root cause or anything, but I have been able to add a
disk to a raid5 array using raidreconf in the past and my last attempt
looked like it worked but still scrambled the filesystem.

So, if you're thinking of relying on raidreconf (instead of a
backup/restore cycle) to grow your raid 5 array, I'd say its probably
time to finally invest in enough backup space. Or you could dig in and
test raidreconf until you know it will work.

I'll paste the commands and their output in below so you can see what
happened - raidreconf appeared to work just fine, but the file-system is
completely corrupted as far as I can tell. Maybe I just did something
wrong though. I used a "make no changes" mke2fs command to generate the
list of alternate superblock locations. They could be wrong, but the
first one being "corrupt" is enough by itself to be a fail mark for
raidreconf.

This isn't a huge deal in my opinion, as this actually is my backup
array, but it would have been cool if it had worked. I'm not going to be
able to do any testing on it past this point though as I'm going to
rsync the main array onto this thing ASAP...

-Mike


-------------------------------------------
<marvin>/root # raidreconf -o /etc/raidtab -n /etc/raidtab.new -m /dev/md2
Working with device /dev/md2
Parsing /etc/raidtab
Parsing /etc/raidtab.new
Size of old array: 2441960010 blocks,  Size of new array: 2930352012 blocks
Old raid-disk 0 has 953890 chunks, 244195904 blocks
Old raid-disk 1 has 953890 chunks, 244195904 blocks
Old raid-disk 2 has 953890 chunks, 244195904 blocks
Old raid-disk 3 has 953890 chunks, 244195904 blocks
Old raid-disk 4 has 953890 chunks, 244195904 blocks
New raid-disk 0 has 953890 chunks, 244195904 blocks
New raid-disk 1 has 953890 chunks, 244195904 blocks
New raid-disk 2 has 953890 chunks, 244195904 blocks
New raid-disk 3 has 953890 chunks, 244195904 blocks
New raid-disk 4 has 953890 chunks, 244195904 blocks
New raid-disk 5 has 953890 chunks, 244195904 blocks
Using 256 Kbyte blocks to move from 256 Kbyte chunks to 256 Kbyte chunks.
Detected 256024 KB of physical memory in system
A maximum of 292 outstanding requests is allowed
---------------------------------------------------
I will grow your old device /dev/md2 of 3815560 blocks
to a new device /dev/md2 of 4769450 blocks
using a block-size of 256 KB
Is this what you want? (yes/no): yes
Converting 3815560 block device to 4769450 block device
Allocated free block map for 5 disks
6 unique disks detected.
Working (\) [03815560/03815560]
[############################################]
Source drained, flushing sink.
Reconfiguration succeeded, will update superblocks...
Updating superblocks...
handling MD device /dev/md2
analyzing super-block
disk 0: /dev/hdc1, 244196001kB, raid superblock at 244195904kB
disk 1: /dev/hde1, 244196001kB, raid superblock at 244195904kB
disk 2: /dev/hdg1, 244196001kB, raid superblock at 244195904kB
disk 3: /dev/hdi1, 244196001kB, raid superblock at 244195904kB
disk 4: /dev/hdk1, 244196001kB, raid superblock at 244195904kB
disk 5: /dev/hdj1, 244196001kB, raid superblock at 244195904kB
Array is updated with kernel.
Disks re-inserted in array... Hold on while starting the array...
Maximum friend-freeing depth:         8
Total wishes hooked:            3815560
Maximum wishes hooked:              292
Total gifts hooked:             3815560
Maximum gifts hooked:               200
Congratulations, your array has been reconfigured,
and no errors seem to have occured.
<marvin>/root # cat /proc/mdstat
Personalities : [raid1] [raid5]
md1 : active raid1 hda1[0] hdb1[1]
      146944 blocks [2/2] [UU]

md3 : active raid1 hda2[0] hdb2[1]
      440384 blocks [2/2] [UU]

md2 : active raid5 hdj1[5] hdk1[4] hdi1[3] hdg1[2] hde1[1] hdc1[0]
      1220979200 blocks level 5, 256k chunk, algorithm 0 [6/6] [UUUUUU]
      [=>...................]  resync =  7.7% (19008512/244195840)
finish=434.5min speed=8635K/sec
md0 : active raid1 hda3[0] hdb3[1]
      119467264 blocks [2/2] [UU]

unused devices: <none>
<marvin>/root # mount /backup
mount: wrong fs type, bad option, bad superblock on /dev/md2,
       or too many mounted file systems
       (aren't you trying to mount an extended partition,
       instead of some logical partition inside?)
<marvin>/root # fsck.ext3 -C 0 -v /dev/md2
e2fsck 1.35 (28-Feb-2004)
fsck.ext3: Filesystem revision too high while trying to open /dev/md2
The filesystem revision is apparently too high for this version of e2fsck.
(Or the filesystem superblock is corrupt)


The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>

<marvin>/root # mke2fs -j -m 1 -n -v
Usage: mke2fs [-c|-t|-l filename] [-b block-size] [-f fragment-size]
        [-i bytes-per-inode] [-j] [-J journal-options] [-N number-of-inodes]
        [-m reserved-blocks-percentage] [-o creator-os] [-g
blocks-per-group]
        [-L volume-label] [-M last-mounted-directory] [-O feature[,...]]
        [-r fs-revision] [-R raid_opts] [-qvSV] device [blocks-count]
<marvin>/root # mke2fs -j -m 1 -n -v /dev/md2
mke2fs 1.35 (28-Feb-2004)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
152633344 inodes, 305244800 blocks
3052448 blocks (1.00%) reserved for the super user
First data block=0
9316 block groups
32768 blocks per group, 32768 fragments per group
16384 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632,
2654208,
        4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
        102400000, 214990848

<marvin>/root # fsck.ext3 -C 0 -v -b 32768 /dev/md2
e2fsck 1.35 (28-Feb-2004)
fsck.ext3: Bad magic number in super-block while trying to open /dev/md2

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>

<marvin>/root # fsck.ext3 -C 0 -v -b 163840 /dev/md2
e2fsck 1.35 (28-Feb-2004)
fsck.ext3: Bad magic number in super-block while trying to open /dev/md2

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>


