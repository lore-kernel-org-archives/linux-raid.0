From: jedd <jedd@progsoc.org>
Subject: RAID-5 borked .. but how borked?
Date: Sun, 19 Feb 2006 10:46:54 +1100
Message-ID: <200602191046.54783.jedd@progsoc.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 Howdi,

 I'm running a RAID5 system across 300GB IDE drives, on an amd32 box.
 I recently attempted to raidreconf that from 4 drives to 5 drives.
 There were no telltale signs of trouble with any of the drives -- all
 of them identical models of Seagates.  About 90% of the way through
 the process, I got a read error on one of the drives, and then
 raidreconf core-dumped.

 Yes -- I know I should have backed up the data prior, but a long
 history of having no problems with these model drives, the fact
 that at home I just don't have space for 850GB of data, and an
 eternal though occasionally misplaced hubris, meant that I did not.

 I've attached a log of the proceedings at the end of this mail, but
 what I'd like to know is:

 o  Just how stuffed a position am I now in?
 o  What would someone that really knows what they're doing, do now?
 o   There's no state information saved periodically by raidreconf,
      is there?  I mean, if I run it again it'll completely bork the
      data on those drives, and still fail at the same block #, right?
 o  Is it feasible to (either through undocumented feature, or by
      modding raidreconf.c slightly) get it to kick off the disk-add
      process again *at the point right after where it failed*.  I do
      know the block number where it failed, after all.
 o  Corollary - how much effort is involved in that (for someone with
      a minimal knowledge of C and no familiarity with raidtools2).
 o  Would I need to replace the faulty (read error on drive 1) disk
      first, doing some dd(rescue) dump of the data across first?
      I suppose that's something I'd need to do anyway.
 o  If I somehow manage to do this (replace drive, get raidreconf
      to start off where it stopped before and run to completion) just
      what kinds of problems should I expect with the data?  Will the
      RAID striping be forever broken and then show little weirdities
      from time to time, will my file system (reiser) have hiccups and
      ultimately wet itself,  or will it simply be that a few of the
      files on there (mostly 600mb lumps of binary data) just have
      holes in them that I'll get to discover over the next few years?
 o   Is the core file of any use to anyone (incl me)?
 o   I know this is a relatively unsupported piece of software, but
       should it really fall over quite this inelegantly?

 thanks for any insights,
 Jedd.


amy:~# raidstart /dev/md0
amy:~# mount /pub
amy:~# df
Filesystem    Type   1M-blocks      Used Available Use% Mounted on
<snip>
/dev/md0  reiserfs      858478    855732      2747 100% /pub

amy:~# umount /pub

amy:~# cat /proc/mdstat
Personalities : [raid5]
md0 : active raid5 hdh[3] hdg[2] hdf[1] hde[0]
      879108096 blocks level 5, 128k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>

amy:~# raidstop /dev/md0


%%% Kicked off ~ 4pm Friday, looks like it'll take about 14 hours
%%% to complete at the current rate

amy:~# cd /etc

amy:/etc# cat raidtab.4disks
raiddev /dev/md0
        raid-level              5
        nr-raid-disks           4
        nr-spare-disks          0
        chunk-size                              128
        persistent-superblock   1
        parity-algorithm        left-symmetric
        device                  /dev/hde
        raid-disk               0
        device                  /dev/hdf
        raid-disk               1
        device                  /dev/hdg
        raid-disk               2
        device                  /dev/hdh
        raid-disk               3

amy:/etc# cat raidtab.5disks
raiddev /dev/md0
        raid-level              5
        nr-raid-disks           5
        nr-spare-disks          0
        chunk-size                              128
        persistent-superblock   1
        parity-algorithm        left-symmetric
        device                  /dev/hde
        raid-disk               0
        device                  /dev/hdf
        raid-disk               1
        device                  /dev/hdg
        raid-disk               2
        device                  /dev/hdh
        raid-disk               3
        device                  /dev/hdd
        raid-disk               4


amy:/etc# raidreconf -o /etc/raidtab.4disks -n /etc/raidtab.5disks -m /dev/md0
Working with device /dev/md0
Parsing /etc/raidtab.4disks
Parsing /etc/raidtab.5disks
Size of old array: 2344289472 blocks,  Size of new array: 2930361840 blocks
Old raid-disk 0 has 2289344 chunks, 293036096 blocks
Old raid-disk 1 has 2289344 chunks, 293036096 blocks
Old raid-disk 2 has 2289344 chunks, 293036096 blocks
Old raid-disk 3 has 2289344 chunks, 293036096 blocks
New raid-disk 0 has 2289344 chunks, 293036096 blocks
New raid-disk 1 has 2289344 chunks, 293036096 blocks
New raid-disk 2 has 2289344 chunks, 293036096 blocks
New raid-disk 3 has 2289344 chunks, 293036096 blocks
New raid-disk 4 has 2289344 chunks, 293036096 blocks
Using 128 Kbyte blocks to move from 128 Kbyte chunks to 128 Kbyte chunks.
Detected 904760 KB of physical memory in system
A maximum of 1838 outstanding requests is allowed
---------------------------------------------------
I will grow your old device /dev/md0 of 6868032 blocks
to a new device /dev/md0 of 9157376 blocks
using a block-size of 128 KB
Is this what you want? (yes/no): yes
Converting 6868032 block device to 9157376 block device
Allocated free block map for 4 disks
5 unique disks detected.
Working (|) [06155471/06868032] [#######################################     ]
Secondary request: Read error on disk 1 in souce (disk_id=1). Bad blocks on disk ?.
Aborted (core dumped)

amy:/etc# ls -lh core
-rw-------  1 root root 280M Feb 18 07:55 core

amy:/etc# grep {interestingbits} /var/log/mesages
Feb 18 07:54:23 amy kernel: hdf: dma_timer_expiry: dma status == 0x61
Feb 18 07:54:38 amy kernel: hdf: DMA timeout error
Feb 18 07:54:38 amy kernel: hdf: dma timeout error: status=0x58 { DriveReady SeekComplete DataRequest }
Feb 18 07:54:38 amy kernel: 
Feb 18 07:54:38 amy kernel: ide: failed opcode was: unknown
Feb 18 07:54:38 amy kernel: hdf: status timeout: status=0xd0 { Busy }
Feb 18 07:54:38 amy kernel: 
Feb 18 07:54:38 amy kernel: ide: failed opcode was: unknown
Feb 18 07:54:38 amy kernel: hde: DMA disabled
Feb 18 07:55:08 amy kernel: ide2: reset timed-out, status=0x90
Feb 18 07:55:08 amy kernel: hdf: status timeout: status=0xd0 { Busy }
Feb 18 07:55:08 amy kernel: 
Feb 18 07:55:08 amy kernel: ide: failed opcode was: unknown
Feb 18 07:55:38 amy kernel: 012496
Feb 18 07:55:38 amy kernel: end_request: I/O error, dev hdf, sector 394012504
Feb 18 07:55:38 amy kernel: end_request: I/O error, dev hdf, sector 394012512
Feb 18 07:55:38 amy kernel: end_request: I/O error, dev hdf, sector 394012520
<  ~300 lines snipped  >
Feb 18 07:55:38 amy kernel: end_request: I/O error, dev hdf, sector 525359088
Feb 18 07:55:38 amy kernel: end_request: I/O error, dev hdf, sector 525359096
Feb 18 07:55:38 amy kernel: end_request: I/O error, dev hdf, sector 525358848


