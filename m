From: ross@jose.lug.udel.edu (Ross Vandegrift)
Subject: Re: RAID design decisions
Date: Sat, 17 Dec 2005 13:06:24 -0500
Message-ID: <20051217180624.GA25052@jose.lug.udel.edu>
References: <17315.27096.325885.788363@smtp.charter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17315.27096.325885.788363@smtp.charter.net>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 16, 2005 at 08:28:56PM -0500, John Stoffel wrote:
> But I'm wondering if I'm being a) too complex here or b) inverted in
> how I want this setup so the LVM is under MD, or c) just fine overall.
> Should I be using LVM2 to build my RAID1 devices directly?  Should I
> be using MD instead to build my resizeable volumes to hold my
> filesystems?

Well, the main reason I use MD for all my personal RAID needs is
becuse I trust it more than any other RAID solution I have ever come
across.  Even in the event of a disaster, I know my data is there and
I know I have the ability to get it back.

I use LVM when I need to do volume management for the same reason.  I
know it, I trust it, I like it.

It sounds like you have a setup that works well and accomplishes your
goals.  Unless you're looking to tinker, I'd leave well enough alone!

> 1. setup MD bitmaps for speedier recoveries
> 2. mirror my /, swap and /boot partitions for reliability
> 	- requires mkinitrd to work well and easily for new kernels.

Unless you want to LVM your / too, you can get away without initrd by
using the kernel command-line to assemble your md devices.  If you've
never seen it, check Documentation/md.txt for syntax and details.

Debian's mkinitrd scripts do a pretty good job of building initrd's
for md, though I can't vouch for their LVM support.  My workstation
runs Slackware, and I'm far too lazy to build my own initrds ::-).

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
