From: Gordon Henderson <gordon@drogon.net>
Subject: RAID-6 ...
Date: Wed, 12 Jan 2005 11:41:13 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0501121020490.21510@lion.drogon.net>
References: <200501101713.j0AHDx922062@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501101713.j0AHDx922062@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Until now I haven't really paid too much attention to the RAID-6 stuff,
but I have an application which needs to be as resilient to disk failures
as possible.

So other than what's at:

  ftp://ftp.kernel.org/pub/linux/kernel/people/hpa/

and the archives of this list (which I'm re-reading now), can anyone give
me a quick heads-up about it?

Specifically I'm still buried in the dark days of 2.4.27/28 - are there
recent patches against 2.4?

If RAID-6 isn't viable for me right now, what I'm planning is as follows:

Put 8 x 250GB SATA drives in the system, and arrange them in 4 pairs of
RAID-1 units.

Assemble the 4 RAID-1 units into a RAID-5.

Big waste of disk space, but thats not really important for this
application, and disk is cheap, (relatively) So I'll end up with just over
700GB of usable storage, with the potential of surviving a minimum of any
3 disks disks failing, and possibly 4 or 5, depending on just where they
fail (although disks would be replaced way before it got to that stage!)

Certainly any 2 can fail, and if it were 2 in the same RAID-1 unit, (which
would cause the RAID-5 to become degraded) and I were desperate, I could
move a disk and deliberately fail another RAID-1 to recover the RAID-5 ...

In the absence of RAID-6, would anyone do it differently?

Note: I'm relatively new to mdadm, but can see it's the way of the future,
(especially after I had to use it in-anger recently to recover from a
2-disk failure in an old 8-disk RAID-5 array), and I'm looking at the
spare-groups part of it all and wondering if that might be an alternative,
but I'd like to avoid the possibility of the array failing
catastrophically during a re-build if at all possible.

Cheers,

Gordon
