From: <pg_mh@mh.to.sabi.co.UK>
Subject: Re: raid 10 su, sw settings
Date: Mon, 31 Dec 2007 18:53:25 +0000
Message-ID: <18297.15013.962286.468356@base.ty.sabi.co.UK>
References: <1199059239.13944.65.camel@up>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
In-Reply-To: <1199059239.13944.65.camel@up>r
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Sun, 30 Dec 2007 19:00:39 -0500, Brad Langhorst
>>> <brad@langhorst.com> said:

[ ... VMware virtual disks over RAID ... ]

brad>  - 4 disk raid 10
brad>  - 64k stripe size

Stripe size or chunk size? Try reducing the chunk size if that
is the chunk size, and applications in the VM do short reads or
writes with intervals. But things seem not to require a lot of
tweaking:

[ ... ]

brad> Typical blocks/sec from iostat during large file movements
brad> is about 100M/s read and 80M/s write.

That's fine, you are getting more or less the combined speed of
2 drives, which is what standard RAID10 over 4 drives should
give you.

brad>  - is the partition aligned correctly? i fear not... [
brad>    ... ]
brad>  - What should the sunit and swidth settings be during
brad>    mount? [ ... ]

These really matter for parity RAID that do read-modify-write of
unaligned sector clusters. But it is rather less essential to
say the least for non-parity RAID, as it only affects speed with
respect to chunk size if operations are of the order of size as
the chunk size or smaller.

If the applications in your VM do mostly reads, try to switch to
RAID0 f2 software RAID, unless they often do concurrent reads,
in which case that's a bad idea.
