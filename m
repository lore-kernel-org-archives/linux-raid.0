From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH] md: raid0: Replace hash table lookup by looping over all strip_zones.
Date: Fri, 15 May 2009 15:18:05 +0200
Message-ID: <20090515131805.GM6403@skl-net.de>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org> <1242297833-13908-2-git-send-email-maan@systemlinux.org> <fe4d072c76f1ce1d6b2b75f83766b1f0.squirrel@neil.brown.name> <18956.3337.786085.284689@notabene.brown> <1242316280.11444.4.camel@raz> <bdf8aeadb1c3d24a5b43ba3264d53dc2.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hnsKUeImFCk/igEn"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bdf8aeadb1c3d24a5b43ba3264d53dc2.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: raz ben yehuda <raziebe@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--hnsKUeImFCk/igEn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 06:38, NeilBrown wrote:

> I was thinking further about this and realised that in the first zone,
> zone_start is always 0.  And we added a sentinal zone for which only
> the zone_start value is set.  This seems silly.

Yes, it is.

> Instead we can just store 'zone_end' in each zone (or possibly
> start_of_next_zone) and then we don't need the sentinal and don't waste
> the zone_start at the beginning.

That's what I did in the new version of the patch set. I'll send it out
shortly.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--hnsKUeImFCk/igEn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKDWuNWto1QDEAkw8RAs0dAJ4+13rrTEAJTNb2KsUeFdx+ROl+nQCdF5py
P42+N0wo5p/r//qCGSiemg0=
=DVgn
-----END PGP SIGNATURE-----

--hnsKUeImFCk/igEn--
