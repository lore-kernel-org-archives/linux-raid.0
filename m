From: Steven Ihde <sihde@cs.stanford.edu>
Subject: 2.6.0: ext3 journal aborted with ext3/lvm/raid5
Date: Wed, 7 Jan 2004 12:53:26 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040107205326.GA14511@hamachi.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I get "Aborting journal on device dm-x" and associated errors about
every week or two.  This is on a 2.6.0 kernel, ext3 filesystem running
on lvm over md raid5.  This has been happening since at least some
point in the 2.6.0-test series.

The "Aborting journal" is always preceded by some type of
"ext3_readdir: bad entry" error.  At the end of this mail I have
listed a selection of entries from my syslog showing the relevant
occurences.  This normally happens around 6:25am when the locate
database is being updated, though it has occasionally happened at
other times when the partition was being accessed.

The filesystem in question is my /usr partition.  When I take the
system down to run fsck, it has always been able to recover (sometimes
with modifications, sometimes without).  I have rebuilt the filesystem
at least twice (by running mke2fs to create a fresh fs and copying in
everything from an archive) and the problem has persisted.  I have
also tried running my /usr partition on a plain disk partition (no lvm
or raid5), and that went two weeks with no errors.  I have several
other partitions on the same raid5 array and I only get problem with
one of them.

So, it seems the problem could be:

1. a hardware problem in a certain area of one of my disks (but there
   has never been a hardware error in the logs)
2. a problem with lvm
3. a problem with raid5
4. a problem with ext3

Any suggestions as to whether raid5 might be the source of the
problem, or how to rule it out?  I can provide more information or try
out patches if necessary.

Thanks for any suggestions,

Steve



More info about my system:

Debian unstable, 2.6.0 kernel
Abit IS-7 (with Intel i865PE chipset) motherboard
Two 80G PATA Seagate drives hooked to separate channels on the
on-board IDE controller
One 120G SATA Seagate drive hooked to the onboard SATA controller

One three-disk raid0 array one the first 1G of each disk
One three-disk raid5 array on the remaining 79G of each disk
  (all the errors have been on the /usr partition, which is on the
  raid5 array)

Here are some syslog entries (dm-1 and dm-2 are referring to the same
logical volume; I changed my configuration slightly at some point
which caused the numbering to change):

Nov 26 06:25:31 hamachi kernel: EXT3-fs error (device dm-1): ext3_readdir: bad entry in directory #268586: rec_len %% 4 != 0 - offset=0, inode=298189867, rec_len=63517, name_len=32
Nov 26 06:25:31 hamachi kernel: Aborting journal on device dm-1.
Nov 26 06:25:32 hamachi kernel: ext3_abort called.
Nov 26 06:25:32 hamachi kernel: EXT3-fs abort (device dm-1): ext3_journal_start: Detected aborted journal
Nov 26 06:25:32 hamachi kernel: Remounting filesystem read-only

Dec  5 06:25:53 hamachi kernel: EXT3-fs error (device dm-1): ext3_readdir: bad entry in directory #72235: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
Dec  5 06:25:53 hamachi kernel: Aborting journal on device dm-1.
Dec  5 06:25:54 hamachi kernel: ext3_abort called.
Dec  5 06:25:54 hamachi kernel: EXT3-fs abort (device dm-1): ext3_journal_start: Detected aborted journal
Dec  5 06:25:54 hamachi kernel: Remounting filesystem read-only

Dec 14 20:00:12 hamachi kernel: EXT3-fs error (device dm-1): ext3_readdir: bad entry in directory #229414: directory entry across blocks - offset=0, inode=0, rec_len=61476, name_len=157
Dec 14 20:00:12 hamachi kernel: Aborting journal on device dm-1.
Dec 14 20:00:12 hamachi kernel: ext3_abort called.
Dec 14 20:00:12 hamachi kernel: EXT3-fs abort (device dm-1): ext3_journal_start: Detected aborted journal
Dec 14 20:00:12 hamachi kernel: Remounting filesystem read-only
Dec 14 20:00:14 hamachi kernel: EXT3-fs error (device dm-1): ext3_readdir: bad entry in directory #229414: directory entry across blocks - offset=0, inode=0, rec_len=61476, name_len=157


Jan  2 22:54:12 hamachi kernel: EXT3-fs error (device dm-2): ext3_readdir: bad entry in directory #182492: inode out of bounds - offset=0, inode=50462976, rec_len=1284, name_len=6
Jan  2 22:54:12 hamachi kernel: Aborting journal on device dm-2.
Jan  2 22:54:12 hamachi kernel: ext3_abort called.
Jan  2 22:54:12 hamachi kernel: EXT3-fs abort (device dm-2): ext3_journal_start: Detected aborted journal
Jan  2 22:54:12 hamachi kernel: Remounting filesystem read-only
Jan  2 22:54:13 hamachi kernel: EXT3-fs error (device dm-2): ext3_readdir: bad entry in directory #184711: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
Jan  2 22:54:13 hamachi kernel: EXT3-fs error (device dm-2): ext3_readdir: bad entry in directory #197622: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
Jan  2 22:54:13 hamachi kernel: EXT3-fs error (device dm-2): ext3_readdir: bad entry in directory #295097: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
Jan  2 22:54:13 hamachi kernel: EXT3-fs error (device dm-2): ext3_readdir: bad entry in directory #196845: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
Jan  2 22:54:13 hamachi kernel: EXT3-fs error (device dm-2): ext3_readdir: bad entry in directory #197149: inode out of bounds - offset=0, inode=50462976, rec_len=1284, name_len=6
Jan  2 22:54:14 hamachi kernel: EXT3-fs error (device dm-2): ext3_readdir: bad entry in directory #184553: inode out of bounds - offset=0, inode=50462976, rec_len=1284, name_len=6
Jan  2 22:54:14 hamachi kernel: EXT3-fs error (device dm-2): ext3_readdir: bad entry in directory #197435: inode out of bounds - offset=0, inode=50462976, rec_len=1284, name_len=6
Jan  2 22:54:24 hamachi kernel: EXT3-fs error (device dm-2): ext3_readdir: bad entry in directory #249397: directory entry across blocks - offset=0, inode=1886220131, rec_len=25964, name_len=116
Jan  2 22:54:26 hamachi last message repeated 11 times

Jan  7 06:25:19 hamachi kernel: EXT3-fs error (device dm-2): ext3_readdir: bad entry in directory #280327: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
Jan  7 06:25:19 hamachi kernel: Aborting journal on device dm-2.
Jan  7 06:25:19 hamachi kernel: ext3_abort called.
Jan  7 06:25:19 hamachi kernel: EXT3-fs abort (device dm-2): ext3_journal_start: Detected aborted journal
Jan  7 06:25:19 hamachi kernel: Remounting filesystem read-only

