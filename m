From: Andre Noll <maan@systemlinux.org>
Subject: Re: [md PATCH 04/22] md: support barrier requests on all personalities.
Date: Fri, 11 Dec 2009 12:46:59 +0100
Message-ID: <20091211114659.GC21495@skl-net.de>
References: <20091204064559.10264.37619.stgit@notabene.brown> <20091204064802.10264.60521.stgit@notabene.brown> <20091208135442.GR5174@skl-net.de> <20091210172522.26ff48b5@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wl4gXchqb9PBRcq/"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091210172522.26ff48b5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--wl4gXchqb9PBRcq/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17:25, Neil Brown wrote:
tely Tue, 8 Dec 2009 14:54:42 +0100
> Andre Noll <maan@systemlinux.org> wrote:
>=20
> Thanks again.
> I have made most of the changes you suggest.

Thanks. Feel free to add

Reviewed-by: Andre Noll <maan@systemlinux.org>

> > Calling atomic_inc() twice isn't an atomic operation any more. If
> > this doesn't matter (because all modifications of rdev->nr_pending
> > are supposed to happen within RCU read-side critical sections) then
> > why is rdev->nr_pending an atomic_t at all?
>=20
> Calling atomic_inc() twice is still two atomic operations, and that is wh=
at I
> need.
> The important thing is that the read-modify-write cycle of atomic_inc isn=
't
> interrupted, so if two thread both do atomic_inc at the same time the res=
ult
> really is adding 2, not just adding one.

A conceivable problem is that someone else might remove the
whole thing between the two atomic_inc() calls because it calls
atomic_dec_and_test() and finds it is zero. But this can't possibly
happen here, can it?

> Multiple RCU read-side blocks can run at the same time on different
> processors - so we definitely need to protection of 'atomic_'.

Yes, definitely.

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--wl4gXchqb9PBRcq/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLIjEzWto1QDEAkw8RAmk4AKCXPOSsc1vq0D3oaRRnMKfJiuKQswCfdTB3
fZ2adsZ0gDOIUmsF5YtWhrk=
=bqeT
-----END PGP SIGNATURE-----

--wl4gXchqb9PBRcq/--
