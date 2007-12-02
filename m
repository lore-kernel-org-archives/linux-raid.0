From: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Subject: Spontaneous rebuild
Date: Sun, 02 Dec 2007 05:12:31 +0100
Message-ID: <475230AF.3010100@student.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Oliver Martin <oliver.martin@student.tuwien.ac.at>
List-Id: linux-raid.ids

[Please CC me on replies as I'm not subscribed]

Hello!

I've been experimenting with software RAID a bit lately, using two
external 500GB drives. One is connected via USB, one via Firewire. It is
set up as a RAID5 with LVM on top so that I can easily add more drives
when I run out of space.
About a day after the initial setup, things went belly up. First, EXT3
reported strange errors:
EXT3-fs error (device dm-0): ext3_new_block: Allocating block in system
zone - blocks from 106561536, length 1
EXT3-fs error (device dm-0): ext3_new_block: Allocating block in system
zone - blocks from 106561537, length 1
...

There were literally hundreds of these, and they came back immediately
when I reformatted the array. So I tried ReiserFS, which worked fine for
about a day. Then I got errors like these:
ReiserFS: warning: is_tree_node: node level 0 does not match to the
expected one 2
ReiserFS: dm-0: warning: vs-5150: search_by_key: invalid format found in
block 69839092. Fsck?
ReiserFS: dm-0: warning: vs-13070: reiserfs_read_locked_inode: i/o
failure occurred trying to find stat data of [6 10 0x0 SD]

Again, hundreds. So I ran badblocks on the LVM volume, and it reported
some bad blocks near the end. Running badblocks on the md array worked,
so I recreated the LVM stuff and attributed the failures to undervolting
experiments I had been doing (this is my old laptop running as a server).

Anyway, the problems are back: To test my theory that everything is
alright with the CPU running within its specs, I removed one of the
drives while copying some large files yesterday. Initially, everything
seemed to work out nicely, and by the morning, the rebuild had finished.
Again, I unmounted the filesystem and ran badblocks -svn on the LVM. It
ran without gripes for some hours, but just now I saw md had started to
rebuild the array again out of the blue:

Dec  1 20:04:49 quassel kernel: usb 4-5.2: reset high speed USB device
using ehci_hcd and address 4
Dec  2 01:06:02 quassel kernel: md: data-check of RAID array md0
Dec  2 01:06:02 quassel kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Dec  2 01:06:02 quassel kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for data-check.
Dec  2 01:06:02 quassel kernel: md: using 128k window, over a total of
488383936 blocks.
Dec  2 03:57:24 quassel kernel: usb 4-5.2: reset high speed USB device
using ehci_hcd and address 4

I'm not sure the USB resets are related to the problem - device 4-5.2 is
part of the array, but I get these sometimes at random intervals and
they don't seem to hurt normally. Besides, the first one was long before
the rebuild started, and the second one long afterwards.

Any ideas why md is rebuilding the array? And could this be related to
the bad blocks problem I had first? badblocks is still running, I'll
post an update when it is finished.
In the meantime, mdadm --detail /dev/md0 and mdadm --examine
/dev/sd[bc]1 don't give me any clues as to what went wrong, both disks
are marked as "active sync", and the whole array is "active, recovering".

Before I forget, I'm running 2.6.23.1 with this config:
http://stud4.tuwien.ac.at/~e0626486/config-2.6.23.1-hrt3-fw

Thanks,
Oliver
