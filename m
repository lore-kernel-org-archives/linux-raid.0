From: CAMTP guest <camtp.guest@uni-mb.si>
Subject: reconf RAID5 superblock corruption
Date: Wed, 16 Oct 2002 15:50:15 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15789.28311.501758.429777@proizd.camtp.uni-mb.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was testing raidreconf on RAID5, resizing from 3 to 4
IDE disk partitions. Reconfiguration completed successfully,
but resizing /dev/md0 with ext3 failed:

  # e2fsck -f /dev/md0 
  e2fsck 1.27 (8-Mar-2002)
  Superblock has a bad ext3 journal (inode 8).
  Clear<y>? yes

  *** ext3 journal has been deleted - filesystem is now ext2 only ***

  Superblock doesn't have has_journal flag, but has ext3 journal inode.
  Clear<y>? yes

  Corruption found in superblock.  (r_blocks_count = 125950).

I tried with different block sizes, with the same result:
  # e2fsck -b 8193 /dev/md0
  # e2fsck -b 32768 /dev/md0

The filesystem superblock contained:
# tune2fs -l /dev/md0
tune2fs 1.27 (8-Mar-2002)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          87be3ab7-f7b8-44bc-ab41-b6a4380c2bdc
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal filetype sparse_super
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              126208
Block count:              251936
Reserved block count:     125950
Free blocks:              126003
Free inodes:              101534
First block:              0
Block size:               4096
Fragment size:            4096
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         15776
Inode blocks per group:   493
Last mount time:          Wed Oct 16 14:39:10 2002
Last write time:          Wed Oct 16 14:39:43 2002
Mount count:              2
Maximum mount count:      26
Last checked:             Wed Oct 16 13:13:19 2002
Check interval:           15552000 (6 months)
Next check after:         Mon Apr 14 13:13:19 2003
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               128
Journal UUID:             <none>
Journal inode:            8
Journal device:           0x0000
First orphan inode:       0

I'm running 2.4.19 kernel, raidtools2 0.90.20010914, and
raidreconf from raidtools-0.95-raidreconf.

What am I doing wrong?

-Igor Mozetic
