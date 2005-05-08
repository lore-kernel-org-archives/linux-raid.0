From: Henrik Holst <henrik_holst@home.se>
Subject: RAID Reconfiguration Tool (raidreconf) Possible bug with spare disks
 in initial ("old") raidset?
Date: Mon, 09 May 2005 01:49:45 +0200
Message-ID: <427EA599.9040707@home.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

HELO linux-raid

I was doing some testing on 4 virtual loopback disks (/dev/loop/0-3) and 
I discovered an issue with spare disks.

I tried to setup a raid5 volume with 3 disks + 1 spare and convert that 
one to a 4 disk raid5 volume w/ 0 spares. (...just playing around with 
different initial setups and target setups). It didn't work. My 
partition (reiserfs) didn't detect properly after the resize.

The /dev/loop/0-3 devices are all created with "losetup" from 100Mb 
files created with "dd" command. The loopbacks where prepared with 
"cfdisk" with partition type "0xFD".

Here is some logs (btw; I'm using gentoo):

------------------------------------------------------------

# emerge -s raidtools
Searching...
[ Results for search key : raidtools ]
[ Applications found : 1 ]

*  sys-fs/raidtools
       Latest version available: 1.00.3-r4
       Latest version installed: 1.00.3-r4
       Size of downloaded files: 163 kB
       Homepage:    http://people.redhat.com/mingo/raidtools/
       Description: Linux RAID 0/1/4/5 utilities
       License:     GPL-2

# uname -r
2.4.26

# cat /etc/raidtab
raiddev /dev/md0
     raid-level              5
     chunk-size              64k
     nr-raid-disks           3
     nr-spare-disks          1
     persistent-superblock   1
     parity-algorithm        left-symmetric

     device                  /dev/loop/0
     raid-disk               0
     device                  /dev/loop/1
     raid-disk               1
     device                  /dev/loop/2
     raid-disk               2
     device                  /dev/loop/3
     spare-disk              0

# mkraid -R /dev/md0
DESTROYING the contents of /dev/md0 in 5 seconds, Ctrl-C if unsure!
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/loop/0, 102400kB, raid superblock at 102336kB
disk 1: /dev/loop/1, 102400kB, raid superblock at 102336kB
disk 2: /dev/loop/2, 102400kB, raid superblock at 102336kB
disk 3: /dev/loop/3, 102400kB, raid superblock at 102336kB

# cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 [dev 07:03][3] [dev 07:02][2] [dev 07:01][1] [dev 
07:00][0]
       204672 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>

# mkreiserfs /dev/md0
mkreiserfs 3.6.19 (2003 www.namesys.com)

A pair of credits:
Yury Umanets  (aka Umka)  developed  libreiser4,  userspace  plugins, 
and  all
userspace tools (reiser4progs) except of fsck.

The  Defense  Advanced  Research  Projects Agency (DARPA, www.darpa.mil) 
is the
primary sponsor of Reiser4.  DARPA  does  not  endorse  this project; it 
merely
sponsors it.


Guessing about desired format.. Kernel 2.4.26 is running.
Format 3.6 with standard journal
Count of blocks on the device: 51168
Number of blocks consumed by mkreiserfs formatting process: 8213
Blocksize: 4096
Hash function used to sort names: "r5"
Journal Size 8193 blocks (first block 18)
Journal Max transaction length 1024
inode generation number: 0
UUID: f855aa06-1e75-4af5-8f8b-c7a453055738
ATTENTION: YOU SHOULD REBOOT AFTER FDISK!
         ALL DATA WILL BE LOST ON '/dev/md0'!
Continue (y/n):y
Initializing journal - 0%....20%....40%....60%....80%....100%
Syncing..ok

Tell your friends to use a kernel based on 2.4.18 or later, and 
especially not a
kernel based on 2.4.9, when you use reiserFS. Have fun.

ReiserFS is successfully created on /dev/md0.

# mount /dev/md0 /raid

# ls /stuff
sunset_strippers-falling_stars-repack-svcd-2005-mva.mpg
sunset_strippers-falling_stars-repack-svcd-2005-mva.sfv

# cp /stuff/* /raid

# cd /raid && cksfv -f *.sfv
--( Verifying: sunset_strippers-falling_stars-repack-svcd-2005-mva.sfv 
)--------
sunset_strippers-falling_stars-repack-svcd-2005-mva.mpg OK
--------------------------------------------------------------------------------
Everything OK

 >> sfv files are like md5 files. I was planning on using them to verify 
that the raidreconf tool didn't break the files inside the filesystem 
after the resize.

 >> Now I umount /raid and try and resize

# cp /etc/raidtab /etc/raidtab.old

# cat /etc/raidtab.new
raiddev /dev/md0
     raid-level              5
     chunk-size              64k
     nr-raid-disks           4
     nr-spare-disks          0
     persistent-superblock   1
     parity-algorithm        left-symmetric

     device                  /dev/loop/0
     raid-disk               0
     device                  /dev/loop/1
     raid-disk               1
     device                  /dev/loop/2
     raid-disk               2
     device                  /dev/loop/3
     raid-disk               3

# raidstop /dev/md0

# raidreconf -o /etc/raidtab.old -n /etc/raidtab.new -m /dev/md0
Working with device /dev/md0
Parsing /etc/raidtab.old
Parsing /etc/raidtab.new
Size of old array: 819200 blocks,  Size of new array: 819200 blocks
Old raid-disk 0 has 1599 chunks, 102336 blocks
Old raid-disk 1 has 1599 chunks, 102336 blocks
Old raid-disk 2 has 1599 chunks, 102336 blocks
Old raid-disk 3 has 1599 chunks, 102336 blocks
New raid-disk 0 has 1599 chunks, 102336 blocks
New raid-disk 1 has 1599 chunks, 102336 blocks
New raid-disk 2 has 1599 chunks, 102336 blocks
New raid-disk 3 has 1599 chunks, 102336 blocks
Using 64 Kbyte blocks to move from 64 Kbyte chunks to 64 Kbyte chunks.
Detected 515816 KB of physical memory in system
A maximum of 1719 outstanding requests is allowed
---------------------------------------------------
I will convert your old device /dev/md0 of 4797 blocks
to a new device /dev/md0 of same size
using a block-size of 64 KB
Is this what you want? (yes/no): yes
Converting 4797 block device to 4797 block device
Allocated free block map for 4 disks
4 unique disks detected.
Working (|) [00004797/00004797] 
[############################################]
Source drained, flushing sink.
Reconfiguration succeeded, will update superblocks...
Updating superblocks...
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/loop/0, 102400kB, raid superblock at 102336kB
disk 1: /dev/loop/1, 102400kB, raid superblock at 102336kB
disk 2: /dev/loop/2, 102400kB, raid superblock at 102336kB
disk 3: /dev/loop/3, 102400kB, raid superblock at 102336kB
Array is updated with kernel.
Disks re-inserted in array... Hold on while starting the array...
Maximum friend-freeing depth:         1
Total wishes hooked:               4797
Maximum wishes hooked:             1719
Total gifts hooked:                4797
Maximum gifts hooked:              1253
Congratulations, your array has been reconfigured,
and no errors seem to have occured.

# cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 [dev 07:03][3] [dev 07:02][2] [dev 07:01][1] [dev 
07:00][0]
       307008 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>

# resize_reiserfs /dev/md0
resize_reiserfs 3.6.19 (2003 www.namesys.com)


reiserfs_open_journal: journal parameters from the superblock does not 
match
to the journal headers ones. It looks like that you created your fs with old
reiserfsprogs. Journal header is fixed.

cannot open ondisk bitmap

# mount /dev/md0 /raid

# df -h
...
/dev/md0              200M   33M  168M  17% /raid

 >> Didn't work 100% :-(
------------------------------------------------------------

Is this an issue with raidreconf, with reiserfs or with me? :-)

--
Yours sincerly,
Henrik Holst <henrik_holst@home.se>
