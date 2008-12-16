From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Date: Tue, 16 Dec 2008 10:39:07 +0100
Message-ID: <200812161039.07700.Martin@lichtvoll.de>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan> <18757.33373.744917.457587@tree.ty.sabi.co.uk> <20081215223857.GF32301@disturbed> (sfid-20081216_091051_242821_0787460D)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081215223857.GF32301@disturbed>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-xfs@oss.sgi.com
Cc: Dave Chinner <david@fromorbit.com>, Peter Grandi <pg_xf2@xf2.for.sabi.co.uk>, Linux RAID <linux-raid@vger.kernel.org>, Linux XFS <xfs@oss.sgi.com>
List-Id: linux-raid.ids

Am Montag 15 Dezember 2008 schrieb Dave Chinner:
> On Sun, Dec 14, 2008 at 10:02:05PM +0000, Peter Grandi wrote:
> > [ ... ]
> >
> > > But - as far as I understood - the filesystem doesn't have to
> > > wait for barriers to complete, but could continue issuing IO
> > > requests happily. A barrier only means, any request prior to
> > > that have to land before and any after it after it.
> > >
> > > It doesn't mean that the barrier has to land immediately and
> > > the filesystem has to wait for this. At least that always was
> > > the whole point of barriers for me. If thats not the case I
> > > misunderstood the purpose of barriers to the maximum extent
> > > possible.
> >
> > Unfortunately that seems the case.
> >
> > The purpose of barriers is to guarantee that relevant data is
> > known to be on persistent storage (kind of hardware 'fsync').
> >
> > In effect write barrier means "tell me when relevant data is on
> > persistent storage", or less precisely "flush/sync writes now
> > and tell me when it is done". Properties as to ordering are just
> > a side effect.
>
> No, that is incorrect.
>
> Barriers provide strong ordering semantics.  I/Os issued before the
> barrier must be completed before the barrier I/O, and I/Os issued
> after the barrier write must not be started before the barrier write
> completes. The elevators are not allowed to re-=D0=BErder I/Os around
> barriers.
>
> This is all documented in Documentation/block/barrier.txt. Please
> read it because most of what you are saying appears to be based on
> incorrect assumptions about what barriers do.

Hmmm, so I am not completely off track it seems ;-).

What I still do not understand then is: How can write barriers + write=20
cache be slower than no write barriers + no cache? I still would expect=
=20
write barriers + write cache be in between no barriers + write cache an=
d=20
no barriers + no cache performance wise. And would see anything else as=
 a=20
regression basically.

This doesn't go into my brain yet and I thought I understood=20
Documentation/block/barrier.txt well enough before writing my article.

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
