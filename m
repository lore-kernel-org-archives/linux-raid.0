From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH] md: raid0: Make raid0_run() return a proper error code.
Date: Thu, 14 May 2009 13:42:11 +0200
Message-ID: <20090514114211.GG11504@skl-net.de>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org> <1242297833-13908-5-git-send-email-maan@systemlinux.org> <846d967866a89248644f819abeddfc62.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qf1oXS95uex85X0R"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <846d967866a89248644f819abeddfc62.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Qf1oXS95uex85X0R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21:21, NeilBrown wrote:
> >  	conf->strip_zone =3D NULL;
> >  	conf->devlist =3D NULL;
> > -	if (create_strip_zones (mddev))
> > +	ret =3D create_strip_zones(mddev);
> > +	if (ret < 0)
> >  		goto out_free_conf;
>=20
> Can we go one set further here and move the allocation of ->private
> into create_stripe_zones.  It seems funny allocating it here and
> never actually using it directly.

Yes, I thought about that but wanted the patches to be as small as
possible. I'll follow up with another patch that moves the allocation
to create_stripe_zones().

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--Qf1oXS95uex85X0R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKDAOTWto1QDEAkw8RAir9AKCFC4kfaNqyke6UqsMqK10LJEiO4QCeLtkO
+zkalMsS2KAd2aH5xDxi0KE=
=AeAK
-----END PGP SIGNATURE-----

--Qf1oXS95uex85X0R--
