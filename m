From: David Dougall <davidd@et.byu.edu>
Subject: confusion or possible bug
Date: Wed, 12 Jan 2005 13:15:44 -0700 (MST)
Message-ID: <Pine.LNX.4.58.0501121304560.19586@lewis.et.byu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have several nfs servers that have had problems recently that I believe
are related to software raid.  Perhaps it is a known bug, perhaps I am
doing things wrong...
Anyway, It is a layered approach as follows
xfs filesystem ontop of LVM2 ontop of software raid1 ontop of fiber
channel disks.
This is a debian distro.  Kernel is standard 2.4.26 with patches for xfs
quotas and device-mapper(for LVM2).  mdadm is version 1.7.0.  Fiber
channel is emulex LP9802 driver version 4.30l.

Anyway, a few days ago, one of our disk arrays had issues and returned I/O
errors to the servers.  My understanding is that software raid should mask
this from the higher layers(LVM and xfs).  This was not the case.  xfs
threw all kinds of errors and eventually needed a xfs_repair to mount back
up.  After things were fixed and I started the rebuild of this md, xfs
began throwing I/O errors again.
From my understanding of how software raid works, if a write request to a
disk fails, the kernel marks that disk as bad and continues on the good
one.  Looking through the kernel, read requests are round-robinned? among
the disks, but if a read fails, it will retry it on the other disk(s).  Is
this a correct understanding?

If so, then what may be causing xfs to see the hardware issues?  Please
advise on what I am missing here.
Thanks
--David Dougall

