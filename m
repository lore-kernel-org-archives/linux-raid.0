From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH] md: raid0: Replace hash table lookup by looping over all strip_zones.
Date: Fri, 15 May 2009 19:30:40 +0200
Message-ID: <20090515173040.GN6403@skl-net.de>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org> <1242297833-13908-2-git-send-email-maan@systemlinux.org> <fe4d072c76f1ce1d6b2b75f83766b1f0.squirrel@neil.brown.name> <18956.3337.786085.284689@notabene.brown> <1242316280.11444.4.camel@raz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zl+NncWK+U5aSfTo"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1242316280.11444.4.camel@raz>
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Zl+NncWK+U5aSfTo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18:51, raz ben yehuda wrote:

> > and as we aren't using ->sectors in this loop any more, I think it
> > can be discarded completely, just making struct strip_zone 20% smaller
> > and improving cache performance.
> >=20
> > What do you think?
> hamm.. please do not do it now. I think i need it for the reshape
> because I have to traverse each zone up to its end.=20

Well, you can always get the zone size of zone #i by

	z[i].zone_end - z[i - 1].zone_end

(with z[-1].zone_end :=3D 0). Since reshape is a slow operation anyway,
the additional subtraction won't hurt, and we'd have the smaller
cache footprint during normal operation. So I'd be inclined to kill
->sectors as well.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--Zl+NncWK+U5aSfTo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKDabAWto1QDEAkw8RAoEmAKCqYyRinCYIuXWi4fhJSLKfj//2XgCfYTfp
z0lX/gg5fAfGb8IM0XKOAl4=
=ShCN
-----END PGP SIGNATURE-----

--Zl+NncWK+U5aSfTo--
