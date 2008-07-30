From: Richard Michael <rmichael-raid@edgeofthenet.org>
Subject: Re: Docs and operation of RAID10, size limitations on 0.90
Date: Wed, 30 Jul 2008 18:47:35 -0400
Message-ID: <20080730224735.GA13138@nexus.edgeofthenet.org>
References: <20080728143553.GE30681@nexus.edgeofthenet.org> <4890943E.5060608@tmr.com> <20080730182907.GB10710@rap.rap.dk> <20080730214933.GC12623@nexus.edgeofthenet.org> <cccedfc60807301456o19bc788flaa67cf88a83f290a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cccedfc60807301456o19bc788flaa67cf88a83f290a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 30, 2008 at 04:56:38PM -0500, Jon Nelson wrote:
> On Wed, Jul 30, 2008 at 4:49 PM, Richard Michael
> <rmichael-raid@edgeofthenet.org> wrote:
> > Re-reading what I wrote, it's a mess of typos. :)  But, yes, I want to
> > remove half the disks on a regular basis, as off-site storage, and return
> > them to the array for periodic resync.
> 
> Basically what you want is a raid 51.
> 2x RAID5 (4 disks each) mirrored to form a RAID1.

Exactly.  Have you built such a config and managed to get the system
booting from the nested RAID1 (perhaps even with LVM inside)?  This is
where I am having difficulty.  Else, I'll just create an 8-way RAID1 of
100MB or so for /boot (as usual, as I mentioned elsewhere).

> Look also into using drbd.

Will do; thanks.

Richard
