From: Roman Mamedov <rm@romanrm.net>
Subject: Re: performance issue (was: Re: kernel: BUG: soft lockup - CPU#1
 stuck for 60s!)
Date: Sat, 24 Oct 2015 21:31:39 +0500
Message-ID: <20151024213139.5b20dec6@natsu>
References: <1092031595.20151015153830@oudeis.org>
	<87si5bvcj4.fsf@notabene.neil.brown.name>
	<43246687.20151024181541@oudeis.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5dKzbPX4OLgAlXz1xG33uO."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43246687.20151024181541@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer =?UTF-8?B?RsO8Z2Vuc3RlaW4=?= <rfu@oudeis.org>
Cc: Neil Brown <nfbrown@novell.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/5dKzbPX4OLgAlXz1xG33uO.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 24 Oct 2015 18:15:41 +0200
Rainer F=C3=BCgenstein <rfu@oudeis.org> wrote:

> hi,
>=20
> > I strongly recommend adding a write-intend bitmap
> >   mdadm --grow /dev/md0 --bitmap=3Dinternal
>=20
> I  did  as suggested, but now it feels like performance has dropped to
> about 1/4th of what it used to be before. since this system is already
> pretty slow by design, this is quite frustrating.

Use a higher bitmap-chunk size, such as 256M or more.

--=20
With respect,
Roman

--Sig_/5dKzbPX4OLgAlXz1xG33uO.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlYrsmsACgkQTLKSvz+PZwgX3wCeIE+XRcfw4iZph2BSplb4ye4R
zcAAnAhFRC0VJSYM/Do4KgYqh1NTf+Wy
=BTZE
-----END PGP SIGNATURE-----

--Sig_/5dKzbPX4OLgAlXz1xG33uO.--
