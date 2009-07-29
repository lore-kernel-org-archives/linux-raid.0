From: Paul Smith <paul@mad-scientist.us>
Subject: Want to remove a disk from raid10 during recovery
Date: Wed, 29 Jul 2009 11:40:14 -0400
Message-ID: <1248882014.7125.64.camel@psmith-ubeta.netezza.com>
Reply-To: paul@mad-scientist.us
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all.  We're working on an IBM Bladecenter with EXP3000 SAS JBOD disk
arrays.  We are using Linux 2.6.27.26 in an embedded OS (booting the
blades over PXE with a ramdisk).  We are working with various RAID10
arrays on these disks.

One thing we've discovered is that if we lose a disk and have entered
recovery, then we lose another disk in that same array, we can't remove
that one.  Obviously we know that the second failure is not the sole
surviving copy.  So for example if we have a raid10 set up as:

	(D1,D2), (D3,D4), (D5,D6), (D7,D8)

then we lose one disk in a pair (say D2) and enter recovery, then we
lose another disk in another pair (say D4), we can't remove that one.
This is a big problem for us in our environment, because we have
different partitions on the disks that are deployed across different
RAID configurations... it means that if a disk fails we can't recover
different array configurations at the same time, which is Not Good(tm).

Looking at the code in the kernel it doesn't seem like it's that
difficult to change this but I wanted to understand what potential
problems there would be with it, and why this restriction was added in
the first place.

Can anyone comment on this?


Thanks!

