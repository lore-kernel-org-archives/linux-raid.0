From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 0/6] md: More sector_t conversions -- intro
Date: Wed, 27 May 2009 10:02:58 +0200
Message-ID: <20090527080258.GV11504@skl-net.de>
References: <1243243657-21855-1-git-send-email-maan@systemlinux.org> <18971.11911.795582.413933@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2tWkrNKppd65XSnD"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18971.11911.795582.413933@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--2tWkrNKppd65XSnD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09:49, Neil Brown wrote:

> > Patch #1 converts mddev->chunk_size which was previously stored
> > in bytes.  Patch #2 fixes what I believe is a bug in super_1_sync()
> > and might be a candiate for -stable. Patches #3 and #4 are further
> > straight-forward conversions that deal with mddev->new_chunk,
> > conf->chunk_size and conf->prev_chunk. Patches #5 and #6 are pure
> > cleanups.
>=20
> Thanks.
> With the exception of #2, and with the other changes I mentioned,
> there are all i my for-next now.

Thanks. BTW: I have a couple of other patches ready that push down
code from md.c to the personalities as you suggested. These need to
be rebased to current for-next though. I'll send them later this week
or at the beginning of next week.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--2tWkrNKppd65XSnD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKHPOyWto1QDEAkw8RApWvAKCPokJEIqRMr/QJQ3SQvkhZctFymwCfWiXi
HvrtS5B/s4j6H0iOP7v+xhI=
=swJ/
-----END PGP SIGNATURE-----

--2tWkrNKppd65XSnD--
