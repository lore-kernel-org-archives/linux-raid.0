From: Andre Noll <maan@systemlinux.org>
Subject: Re: [md PATCH 14/22] md: support updating bitmap parameters via sysfs.
Date: Fri, 11 Dec 2009 12:46:54 +0100
Message-ID: <20091211114654.GB21495@skl-net.de>
References: <20091204064559.10264.37619.stgit@notabene.brown> <20091204064802.10264.47719.stgit@notabene.brown> <20091208102943.GZ21495@skl-net.de> <20091210171459.6aee086f@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ATYltwmfWCpDp8Ax"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091210171459.6aee086f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--ATYltwmfWCpDp8Ax
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17:14, Neil Brown wrote:
> On Tue, 8 Dec 2009 11:29:43 +0100
> Andre Noll <maan@systemlinux.org> wrote:
>=20
> Thanks for the very thorough review.
>=20
> I think I have address all your issues - see below.

Jup, looks fine to me now.

>=20
> > > +		/* No bitmap, OK to set a location */
> > > +		long long offset;
> > > +		if (strncmp(buf, "none", 4) =3D=3D 0)
> > > +			/* nothing to be done */;
> > > +		else if (strncmp(buf, "file:", 5) =3D=3D 0) {
> > > +			/* Not supported yet */
> > > +			return -EINVAL;
> > > +		} else {
> > > +			int rv;
> > > +			if (buf[0] =3D=3D '+')
> > > +				rv =3D strict_strtoll(buf+1, 10, &offset);
> > > +			else
> > > +				rv =3D strict_strtoll(buf, 10, &offset);
> > > +			if (rv)
> > > +				return rv;
> > > +			mddev->bitmap_info.offset =3D offset;
> >=20
> > Introducing a sanity check here would probably save some sysadmin's
> > feet.
>=20
> What sort of sanity check did you have in mind.  When we come to
> write out bitmap data a sanity check is performed and if there is
> any overlap the bitmap is disabled.

I thought of a simple check for overlaps, not being aware of the fact
that such a check is already done in write_sb_page() of bitmap.c. Doing
the check there is obviously good as well. The only difference is
that for invalid offset values the bitmap is accepted (i.e. setting
the bitmap with mdadm succeeds) but then kicked immediately.


> > Also, if the timeout is being set while the array is stopped, the
> > command succeeds but has no effect (as mddev->thread is NULL). Maybe
> > it's better to return an error in this case.
>=20
> No - bitmap_info.daemon_sleep is always set.  This is the important part =
of
> the function.  This "if (mddev->thread) {" branch is just to ensure it ta=
kes
> effect instantly instead of soon.

Ah, I see. Thanks for the explanation.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--ATYltwmfWCpDp8Ax
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLIjEuWto1QDEAkw8RAkzNAKCcBUtHeAuTCUghFhtr1kzbN/b65gCfTggj
YjsC4ne2xtKu6st9XZu6OrI=
=WlO6
-----END PGP SIGNATURE-----

--ATYltwmfWCpDp8Ax--
