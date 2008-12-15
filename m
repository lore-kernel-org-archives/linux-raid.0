From: Dave Chinner <david@fromorbit.com>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Date: Tue, 16 Dec 2008 09:38:57 +1100
Message-ID: <20081215223857.GF32301@disturbed>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan> <1229225480.16555.152.camel@localhost> <18757.4606.966139.10342@tree.ty.sabi.co.uk> <200812141912.59649.Martin@lichtvoll.de> <18757.33373.744917.457587@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18757.33373.744917.457587@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux XFS <xfs@oss.sgi.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Dec 14, 2008 at 10:02:05PM +0000, Peter Grandi wrote:
> [ ... ]
>=20
> > But - as far as I understood - the filesystem doesn't have to
> > wait for barriers to complete, but could continue issuing IO
> > requests happily. A barrier only means, any request prior to
> > that have to land before and any after it after it.
>=20
> > It doesn't mean that the barrier has to land immediately and
> > the filesystem has to wait for this. At least that always was
> > the whole point of barriers for me. If thats not the case I
> > misunderstood the purpose of barriers to the maximum extent
> > possible.
>=20
> Unfortunately that seems the case.
>=20
> The purpose of barriers is to guarantee that relevant data is
> known to be on persistent storage (kind of hardware 'fsync').
>=20
> In effect write barrier means "tell me when relevant data is on
> persistent storage", or less precisely "flush/sync writes now
> and tell me when it is done". Properties as to ordering are just
> a side effect.

No, that is incorrect.

Barriers provide strong ordering semantics.  I/Os issued before the
barrier must be completed before the barrier I/O, and I/Os issued
after the barrier write must not be started before the barrier write
completes. The elevators are not allowed to re-=D0=BErder I/Os around
barriers.

This is all documented in Documentation/block/barrier.txt. Please
read it because most of what you are saying appears to be based on
incorrect assumptions about what barriers do.

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
