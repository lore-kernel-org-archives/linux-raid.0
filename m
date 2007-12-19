From: "Jon Nelson" <jnelson@jamponi.net>
Subject: Re: Linux RAID Partition Offset 63 cylinders / 30% performance hit?
Date: Wed, 19 Dec 2007 16:12:40 -0600
Message-ID: <cccedfc60712191412j27256304p185d6d06e27d9ebe@mail.gmail.com>
References: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan>
	 <476990B4.5050803@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <476990B4.5050803@ziu.info>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/19/07, Michal Soltys <soltys@ziu.info> wrote:
> Justin Piszcz wrote:
> >
> > Or is there a better way to do this, does parted handle this situation
> > better?
> >
> > What is the best (and correct) way to calculate stripe-alignment on the
> > RAID5 device itself?
> >
> >
> > Does this also apply to Linux/SW RAID5?  Or are there any caveats that
> > are not taken into account since it is based in SW vs. HW?
> >
> > ---
>
> In case of SW or HW raid, when you place raid aware filesystem directly on
> it, I don't see any potential poblems
>
> Also, if md's superblock version/placement actually mattered, it'd be pretty
> strange. The space available for actual use - be it partitions or filesystem
> directly - should be always nicely aligned. I don't know that for sure though.
>
> If you use SW partitionable raid, or HW raid with partitions, then you would
> have to align it on a chunk boundary manually. Any selfrespecting os
> shouldn't complain a partition doesn't start on cylinder boundary these
> days. LVM can complicate life a bit too - if you want it's volumes to be
> chunk-aligned.

That, for me, is the next question - how can one educate LVM about the
underlying block device such that logical volumes carved out of that
space align properly - many of us have experienced 30% (or so)
performance losses for the convenience of LVM (and mighty convenient
it is).


-- 
Jon
