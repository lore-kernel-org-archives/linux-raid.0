From: NeilBrown <neilb@suse.de>
Subject: Re: Recovering an Array with inconsistent Superblocks
Date: Sun, 5 Jan 2014 20:56:12 +1100
Message-ID: <20140105205612.093276ef@notabene.brown>
References: <1388829881.16265.20.camel@vessel>
	<52C835C9.3050707@turmel.org>
	<1388873143.7641.20.camel@vessel>
	<52C8C433.5030403@turmel.org>
	<1388912870.3591.4.camel@vessel>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Lcu0mub.+XN6=5vFw6cNYt7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1388912870.3591.4.camel@vessel>
Sender: linux-raid-owner@vger.kernel.org
To: Fabian Knorr <knorrfab@fim.uni-passau.de>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Lcu0mub.+XN6=5vFw6cNYt7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 05 Jan 2014 10:07:50 +0100 Fabian Knorr <knorrfab@fim.uni-passau.de>
wrote:

> > Try this:
> >=20
> > mdadm --stop /dev/md0
> >=20
> > mdadm -Afv /dev/md0 /dev/sd[bcefghi]1
> >=20
> > It leaves out /dev/sda, which appears to have been the spare in the
> > original setup.
> >=20
> > If MD is happy after that, use fsck -n on your logical volumes to verify
> > your FS integrity, and/or see the extent of the damage (little or none,
> > I think).
>=20
> This had the same result as simply trying --assemble --scan, see
> "assemble.log". I tried using sda1 instead of sdb1 as well as the both
> seem to have ID 4 ("assemble2.log"), same thing again.
>=20
> Do you have any idea why mdadm seems to ignore --force and does not add
> the outdated disks? (Or am I misinterpreting --force?)

I haven't read the whole thread, but this sounds like the bug fixed by:

commit f81a2b56c4b437f66aaf5582a9c6b7f5ab2103c4
Author: NeilBrown <neilb@suse.de>
Date:   Tue Oct 22 09:55:04 2013 +1100

    Assembe: fix bug in force_array - it wasn't forcing properly.


try getting mdadm from git and building that
  git clone git://neil.brown.name/mdadm
  cd mdadm
  make

NeilBrown

>=20
> Thanks.
>=20
> Fabian


--Sig_/Lcu0mub.+XN6=5vFw6cNYt7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUsksQjnsnt1WYoG5AQJO1Q//ZoKZkvM6ASMq2rTtMVAvxx3BAXuam7rt
NNT79CDslWjbZJV/3eMzdGFvw5vu+hTndGPs+e7on1/GCukB1Y9v8OFWdS9A/qVS
jSu4FuMVgGRJwop5XqyMWpRvW7/b9GIb1UN2g2cGeWfdf7YQkRMwk6P1g1Eo/r0T
0SJ+wA3szVf3jS35w19CdDxbywk12i1wwpQpZ9/ITSaLXE/XaC261GooYOtTmLPv
0sO34k/C+gj8CjJnbpQE/WaFTEmm+i5fVjv7b0JJ3mWCNCq2qDn6qYcRWBrfq9aU
A81bfqK5H7iJRblgauczF1CkAJxw6zWBJN1Dt3J/AyK1blx2z3BOVNq4V8pgZStL
hKLbV6Nf08P+quYI3BLXTBWqfZU6O0wspD2/eU4J0gPLWy43t7Xk5AZN7Ptj76S1
tU4Uec3Q3wbHgs2mdoUFZbrPW2GWKJbZTiKWaKPeeTJknhKNY4ITaQqd4bQsWKFr
z9cvRRtFHfFF0O/vaXoGciMBkP1ohOLu7qd7Lr2cQIeYOFeIFP+3VZu0y33p682G
W9JIxz8E0+DWrJ99sY1El3jKbup6SjCeWDLGHsZUgeQl786QEiyeedobx9PXAvM/
BM4w8Sl+GNiZ075QV6gV113DDh6RRFg4+6CopjpjQqVTvHycxv9F2IYYR8lrP5IM
w+0uucW9dfo=
=G3Sm
-----END PGP SIGNATURE-----

--Sig_/Lcu0mub.+XN6=5vFw6cNYt7--
