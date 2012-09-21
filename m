From: NeilBrown <neilb@suse.de>
Subject: Re: hung in raise_barrier() in raid1.c  -- any ideas?
Date: Fri, 21 Sep 2012 12:16:58 +1000
Message-ID: <20120921121658.4fc4e5aa@notabene.brown>
References: <505B49E2.8070109@genband.com>
	<505B5876.4040405@genband.com>
	<20120921072751.38319b46@notabene.brown>
	<505BA133.3000005@genband.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CPtnty3YJdB2E.=wZ.CjZYw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <505BA133.3000005@genband.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Friesen <chris.friesen@genband.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/CPtnty3YJdB2E.=wZ.CjZYw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Sep 2012 17:05:23 -0600 Chris Friesen <chris.friesen@genband.com>
wrote:

> On 09/20/2012 03:27 PM, NeilBrown wrote:
> > On Thu, 20 Sep 2012 11:55:02 -0600 Chris Friesen<chris.friesen@genband.=
com>
> > wrote:
> >
> >> On 09/20/2012 10:52 AM, Chris Friesen wrote:
> >>>
> >>> Hi,
> >>>
> >>> I've got a fairly beefy (32 cpus, 64GB ram, isci-based SAS disks,
> >>> etc.) embedded system running 2.6.27.
> >>>
> >>> We're seeing issues where disk operations suddenly seem to stall.  In
> >>> the most recent case we had the hung-task watchdog indicate that
> >>> md1_resync was stuck for more than 120sec in raise_barrier().
> >>>
> >>> There are a bunch of "normal" tasks also stuck in wait_barrier(), so
> >>> based on that I assume we're stuck in the second call to
> >>> wait_event_lock_irq().
> >>>
> >>> Has anyone seen anything like this?  Could commit 73d5c38 be related?
> >>> What about 1d9d524?
> >>
> >> Could d6b42dc be related?
> >
> > That last one seems more likely.  Does the scenario fit your config.
> > i.e. is your RAID1 being used under LVM?
> >
> > If it does, then I would say it is very likely this issue.
>=20
>=20
> Yes, we're using it under LVM.  I've added some instrumentation to tell=20
> if we're hitting that case.  The current->bio_list handling is a bit=20
> different in 2.6.27 but I think I figured out the equivalent to the patch.
>=20
> Interesting that it took this long to fix that issue.
>=20
>=20
> >> Also, what's the meaning of RESYNC_DEPTH?
> >
> > The maximum number of resync requests that can be concurrently active.
>=20
> And each request would resync a single block?

Each request will resync up to RESYNC_BLOCK_SIZE bytes - i.e. up to 64K.

NeilBrown

--Sig_/CPtnty3YJdB2E.=wZ.CjZYw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFvOGjnsnt1WYoG5AQLicw//dcDZiL2KkYhOSp55RHctRip/nfv3QmQl
jCcdmConkrXZ4f3QiBADCz8KYf6eWispUivZ7PG8rLnXZpfmSoAFq2Nb7s4PonhR
8eknNxJ9qR991JH5ususn0PY2PQqetbkt2foo2ar0BoCGcu/qd1arzweuCtS8Be2
y9yGz2NKZVKRruV1TDI71P9yns5q3ONydY7nhLGu9R1/GVTWE9Cd/zfY72utADMc
kTRvo+HDYsJMmOobP4Ei0033ZNqGFh5C4ffYdW9WmYm751zLMLl7Fbl14B+nAeyZ
g1BUdZwP1ozkGL8GaxWpX6cmWvk4mBSi0T+KdKlRkkyl9n95/tbq5Mx5hMB3CTDQ
PnknJ0rOKImUbkn+RKSb8RQiMtMVb8evODv2ik/xfg8U6ur4J6n673Ks4FiwFeTK
iY1QM76sT5FGrSx8NemYn0OJlR5iJm/b72BwyQZ8L74fjOgRYQhPO7fM2UlB86k4
ZMQud+MxLgfh8kQmNwUX+NKG+xkGjbzv68tEV5Qcc7mijJsWkoXUwgKFvZirLsKc
KwhW8keKXwBpjqNkYD7XvjUM3xJ0xdlngmzJtNLadK7uG2MOV1YWPgnH8AmKQHmp
Kiwda9U86+l6zPumPIV/gQE2jqnDlTQuOWCDJR968nfiepGaPkrNI5aDvyYBlJXm
4WVYj/43fag=
=bC4G
-----END PGP SIGNATURE-----

--Sig_/CPtnty3YJdB2E.=wZ.CjZYw--
