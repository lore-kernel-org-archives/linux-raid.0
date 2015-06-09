From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Migrating a RAID 5 from 4x2TB to 3x6TB ?
Date: Wed, 10 Jun 2015 00:15:44 +0500
Message-ID: <20150610001544.484da3a6@natsu>
References: <167089395.613.1433791723592.JavaMail.zimbra@wieser.fr>
	<55767860.5000803@gmail.com>
	<1222347192.1017.1433875572719.JavaMail.zimbra@wieser.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DvL_wv+.oAKwNfO_u.vYTCd"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1222347192.1017.1433875572719.JavaMail.zimbra@wieser.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Pierre Wieser <pwieser@trychlos.org>
Cc: Can Jeuleers <can.jeuleers@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/DvL_wv+.oAKwNfO_u.vYTCd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 9 Jun 2015 20:46:12 +0200 (CEST)
Pierre Wieser <pwieser@trychlos.org> wrote:

> Does linux-raid have any recommandation(s) when managing more than 10TB o=
f data ?
>=20
> I may imagine:
> - several smaller RAID 5 devices
> - would RAID10 be a valuable solution in your opinion ?

The solution is called RAID6.

And don't go for overly large drives, e.g. 6x2TB is better than 4x3TB.

1) smaller drives might use more proven technology, require less precision,=
 so
might be more reliable (at least according to hearsay and urban legends);

2) you need a considerable array member count anyway, to justify "losing" t=
wo
drives for parity in RAID6.

"But my enclosure only fits 4 drives". "But I don't have enough SATA ports".

Get a bigger enclosure. Get a second/third SATA controller. :)

--=20
With respect,
Roman

--Sig_/DvL_wv+.oAKwNfO_u.vYTCd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlV3O2AACgkQTLKSvz+PZwjWuQCfQiXjw9zhEHmQDMfzfYnY97mm
Tm0An3RloreqymwwRTUp0WWiP+exlCBm
=HwYM
-----END PGP SIGNATURE-----

--Sig_/DvL_wv+.oAKwNfO_u.vYTCd--
