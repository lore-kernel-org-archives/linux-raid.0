From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: No resync
Date: Tue, 12 Jan 2010 08:37:54 +0000
Message-ID: <20100112083753.GA9891@cthulhu.home.robinhill.me.uk>
References: <C6.49.19471.1200C4B4@cdptpa-omtalb.mail.rr.com>
 <4B4C0162.5040807@sauce.co.nz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B4C0162.5040807@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Jan 12, 2010 at 05:58:10PM +1300, Richard Scobie wrote:

> Leslie Rhorer wrote:
>=20
> >> Is there a way to  force assemble a stopped array that has too many
> >> failed devices, while disabling the resync that would normally occur?
> >
> > 	Well, of course if the array has too few members to start (even
> > after the --force), then it won't start and thus won't recync, but assu=
ming
> > one has enough targets to assemble and run the array, I believe
> > --asume-clean will do what you want.  It's in the man page.
> >
>=20
> By using force as part of an assemble, all failed devices set to healty=
=20
> again and a resync is immediately started.
>=20
> According to the man page --asume-clean is not an available option for=20
> assemble.
>=20
> I have tried --read-only but that is not an otion either.
>=20
> I need to reassemble without resyncing so I can fsck first.
>=20
You probably need to start it with missing members then, so it's able to
run but not to resync.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAktMNOEACgkQShxCyD40xBKI2wCfYCyI1oZBoPwXlccSTP3OT9Nv
NBAAmwcfAQp+16WHPgsGFAi3IJxA1FV3
=omED
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
