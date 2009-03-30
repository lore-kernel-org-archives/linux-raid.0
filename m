From: Andre Noll <maan@systemlinux.org>
Subject: Re: [md PATCH 4/6] md/raid5: change reshape-progress measurement to cope with reshaping backwards.
Date: Mon, 30 Mar 2009 11:09:38 +0200
Message-ID: <20090330090938.GT17185@skl-net.de>
References: <20090324084629.15383.10271.stgit@notabene.brown> <20090324085332.15383.94300.stgit@notabene.brown> <20090327161936.GQ17185@skl-net.de> <38a7f1dc05f8b3cedebd2e30a0288929.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dU989noCA+aq9KP4"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <38a7f1dc05f8b3cedebd2e30a0288929.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--dU989noCA+aq9KP4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 06:54, NeilBrown wrote:
> > Is it only me who finds such code hard to comprehend?  Given that
> > the patch adds checks of the form
> >
> > 	(delta < 0 && s < r) || (delta >=3D 0 && s >=3D r)
>=20
> They are really of the form
>        delta < 0 ? s < r : s >=3D r

Yeah right. This underlines that it is easy to get wrong :)

>  static inline inorder(mddev_t *mddev, sector_t a, sector_t b)
>  {
>       if (mddev->delta_disks < 0)
>                 return b > a;
>       else
>                 return a <=3D b;
>  }
>=20
> However sometimes it is '<' vs '>=3D' and sometimes  '<' vs '>',
> so I'm not sure it would apply universally.....

Return -1, 0, or 1, i.e. something like this:

static inline int inorder(int delta, sector_t a, sector_t b)
{
	int x;

	if (a < b)
		x =3D 1;
	else if (a > b)
		x =3D -1;
	else x =3D 0;
	if (delta < 0)
		x =3D -x;
	return x;
}

Of course, the callers would need to be adapted slightly.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--dU989noCA+aq9KP4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJ0IxSWto1QDEAkw8RAk8rAJ9VBGQACtcVtv6f/QnANkJfjSBg6gCeJZ7N
OVKGkWx/djLCkx+rrIjSREk=
=2ZTK
-----END PGP SIGNATURE-----

--dU989noCA+aq9KP4--
