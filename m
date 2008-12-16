From: Dave Chinner <david@fromorbit.com>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Date: Wed, 17 Dec 2008 10:14:11 +1100
Message-ID: <20081216231411.GG32301@disturbed>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan> <18757.33373.744917.457587@tree.ty.sabi.co.uk> <20081215223857.GF32301@disturbed> <200812161039.07700.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200812161039.07700.Martin@lichtvoll.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com, Peter Grandi <pg_xf2@xf2.for.sabi.co.uk>, Linux RAID <linux-raid@vger.kernel.org>Linux XFS <xfs@oss.sgi.com>
List-Id: linux-raid.ids

On Tue, Dec 16, 2008 at 10:39:07AM +0100, Martin Steigerwald wrote:
> Am Montag 15 Dezember 2008 schrieb Dave Chinner:
> > On Sun, Dec 14, 2008 at 10:02:05PM +0000, Peter Grandi wrote:
> > > The purpose of barriers is to guarantee that relevant data is
> > > known to be on persistent storage (kind of hardware 'fsync').
> > >
> > > In effect write barrier means "tell me when relevant data is on
> > > persistent storage", or less precisely "flush/sync writes now
> > > and tell me when it is done". Properties as to ordering are just
> > > a side effect.
> >
> > No, that is incorrect.
> >
> > Barriers provide strong ordering semantics.  I/Os issued before the
> > barrier must be completed before the barrier I/O, and I/Os issued
> > after the barrier write must not be started before the barrier writ=
e
> > completes. The elevators are not allowed to re-=D0=BErder I/Os arou=
nd
> > barriers.
> >
> > This is all documented in Documentation/block/barrier.txt. Please
> > read it because most of what you are saying appears to be based on
> > incorrect assumptions about what barriers do.
>=20
> Hmmm, so I am not completely off track it seems ;-).
>=20
> What I still do not understand then is: How can write barriers + writ=
e=20
> cache be slower than no write barriers + no cache?

Because frequent write barriers cause ordering constraints on I/O.
=46or example, in XFS log I/Os are sequential. With barriers enabled
they cannot be merged by the elevator, whereas without barriers
they can be merged and issued as a single I/O.

=46urther, if you have no barrier I/os queued in the elevator, sorting
and merging occurs across the entire queue of I/Os, not just the
I/Os that have been issued after the last barrier I/O.

Effectively the ordering constraints of barriers introduce more
seeks by reducing the efficiency of the elevator due to constraining
sorting and merging ranges.

In many cases, the ordering constraints impose a higher seek penalty
than the write cache can mitigate - the whole purpose of the barrier
IOs is to force the cache to be flushed - so write caching does not
improve performance when frequent barriers are issued. In this case,
barriers are the problem and hence turning of the cache and barriers
will result in higher performance.



> I still would expect=20
> write barriers + write cache be in between no barriers + write cache =
and=20
> no barriers + no cache performance wise.

Depends entirely on the disk and the workload. Some disks are faster
with wcache and barriers (e.g. laptop drives), some are faster with
no wcache and no barriers (e.g. server drives)....

> And would see anything else as a=20
> regression basically.

No, just your usual "pick the right hardware" problem.

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
