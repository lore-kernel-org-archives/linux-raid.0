From: Nick Maynard <nick.maynard@alumni.doc.ic.ac.uk>
Subject: RAID1 sync() slowness
Date: Tue, 10 Aug 2004 13:46:22 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1092141982.4118c39ee37e5@www.tastycake.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello - hoping someone can give some insight into a RAID1 performance problem
that's been affecting us for a while now...

Our current setup:

$ cat /proc/mdstat
Personalities : [raid1] [multipath]
read_ahead 1024 sectors
md4 : active raid1 hdg6[1] hde6[0]
      102494592 blocks [2/2] [UU]

md3 : active raid1 hdg5[1] hde5[0]
      2104384 blocks [2/2] [UU]

md2 : active raid1 hdg3[1] hde3[0]
      2104448 blocks [2/2] [UU]

md0 : active raid1 hdg1[1] hde1[0]
      24000 blocks [2/2] [UU]

md1 : active raid1 hdg2[1] hde2[0]
      10490368 blocks [2/2] [UU]

unused devices: <none>

/dev/md2 is swap space, the other arrays are ext2/3 filesystems.

We're finding calls to sync() take a much longer time than we would expect.
In particular, sometimes it can take over a second (in extreme cases, several)
to run "sync".  As our mail server runs sync() often, we're getting some fairly
noticeable performance degradation, mostly showing itself in terminal delays,
but sometimes in database accesses etc.

We originally thought it might be something to do with atime inode records, and
tried remounting our filesystems with noatime, but to no avail.

The hardware's all fairly recent - two 120GB drives on their own channels, DMA,
2.4Ghz P4, 1GB RAM - so we shouldn't be having trouble of this sort.

The system is currently running 2.4.26.

Does anyone have any ideas on how to fix our problems?

Thanks,

--

Nick Maynard
nick.maynard@alumni.doc.ic.ac.uk
