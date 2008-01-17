From: "Norman Elton" <normelton@gmail.com>
Subject: Raid over 48 disks ... for real now
Date: Thu, 17 Jan 2008 11:19:35 -0500
Message-ID: <6b3a7f010801170819o59533c39qf4dada60a6f8701@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I posed the question a few weeks ago about how to best accommodate
software RAID over an array of 48 disks (a Sun X4500 server, a.k.a.
Thumper). I appreciate all the suggestions.

Well, the hardware is here. It is indeed six Marvell 88SX6081 SATA
controllers, each with eight 1TB drives, for a total raw storage of
48TB. I must admit, it's quite impressive. And loud. More information
about the hardware is available online...

http://www.sun.com/servers/x64/x4500/arch-wp.pdf

It came loaded with Solaris, configured with ZFS. Things seemed to
work fine. I did not do any benchmarks, but I can revert to that
configuration if necessary.

Now I've loaded RHEL onto the box. For a first-shot, I've created one
RAID-5 array (+ 1 spare) on each of the controllers, then used LVM to
create a VolGroup across the arrays.

So now I'm trying to figure out what to do with this space. So far,
I've tested mke2fs on a 1TB and a 5TB LogVol.

I wish RHEL would support XFS/ZFS, but for now, I'm stuck with ext3.
Am I better off sticking with relatively small partitions (2-5 TB), or
should I crank up the block size and go for one big partition?

Thoughts?

Norman Elton
