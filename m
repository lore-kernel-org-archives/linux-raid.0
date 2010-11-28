From: hansbkk@gmail.com
Subject: Re: RAID10 striping vs LVM striping over RAID1 (noob)
Date: Sun, 28 Nov 2010 20:49:22 +0700
Message-ID: <AANLkTimiR9xeDhCnMSSO49Gxvbdi5j+m=vuNr-WRqfMc@mail.gmail.com>
References: <AANLkTinW4sxsii=g-4hG_qSMjvyLk92XQPb5HHtGFT94@mail.gmail.com>
	<alpine.DEB.1.10.1011281140580.1154@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1011281140580.1154@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

On Sun, Nov 28, 2010 at 5:43 PM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> What about data reliability? I'd recommend doing two RAID6:es out of the
> drives you have and using them as PVs, one VG, and don't stripe them at all.
>
> <http://www.zdnet.com/blog/storage/why-raid-5-stops-working-in-2009/162>
> applies to large drives even in RAID1.
>
> --
> Mikael Abrahamsson

Mikael,

I personally use "data availability" (my top priority listed) as
inclusive of what you most likely mean by data reliability.

I hadn't considered RAID6, as my understanding has been that it's
usually implemented by specialized "enterprise-level" hardware, as
opposed to my "consumer level" stuff, and much larger sets of disks
than what I'm working with.

Although performance isn't such a big issue for me, my (several
generations old now) CPU will already be handling all the disk I/O
discussed - plus the filer's going to be serving out a
yet-to-be-determined number of iSCSI LUNs, so I'm willing to trade off
space penalty for the performance and (even more important) the
simplicity of RAID1 or RAID10.

Regarding the possibility (IMO slim) of the primary drive failing
during a straight-mirror rebuild, the first (smaller) RAID set is
being regularly backed up to the larger one, and I'm even trying to
build off-site disk rotation into my planning (we can't afford tapes).

Next step up will be "full-server" mirroring via drdb/heartbeat to an
offsite location, but we're not quite there yet.

So I appreciate your "even better" suggestion, but do you have
anything to say about the relative merits of the two alternatives I
put forward?

Thanks,

Hans
