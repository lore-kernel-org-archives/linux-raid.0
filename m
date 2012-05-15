From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: Failed, but "md: cannot remove active disk..."
Date: Tue, 15 May 2012 09:56:01 +0200
Message-ID: <1337068561.27149.2.camel@localhost>
References: <1336933308.2831.4.camel@localhost>
	 <20120514202220.5a164eb0@notabene.brown>
	 <1336992780.6722.18.camel@localhost>
	 <20120514213623.3bc1bfa5@notabene.brown>
	 <1336995865.6722.22.camel@localhost>
	 <20120515133856.6e04d77b@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-pBR7kqRVxtYtfyM8uORU"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120515133856.6e04d77b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-pBR7kqRVxtYtfyM8uORU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2012-05-15, wto o godzinie 13:38 +1000, NeilBrown pisze:
On Mon, 14 May 2012 13:44:25 +0200 Micha=C5=82 Sawicz <michal@sawicz.net>
wrote:
>=20
> > Dnia 2012-05-14, pon o godzinie 21:36 +1000, NeilBrown pisze:
> > > Is the array still functioning?
> > > Are there any interesting messages appearing in the kernel logs?
> >=20
> > Yes and no, the array is fine, working, nothing interesting in any
logs
> > I can see.
> >=20
> > > What does
> > >   grep . /sys/block/md126/md/dev*/*
> > > show?
> >
> //snip//
>=20
>=20
> Thanks. No hints there - all normal.
>=20
--8<--

I ended up rebooting the machine and managed to get everything going
again. Thanks for the help.

--=20
Micha=C5=82 Sawicz <michal@sawicz.net>

--=-pBR7kqRVxtYtfyM8uORU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPsgwRAAoJEGnv7NPGHSZF9RwQAM0OH/aY22RGDo6pMDC3Jsac
S9K78CKkjDhfJT5XKvS9p2IqtP8ugZGntpjg9EGwl8BcnK6JJDDM0h1KUyAf4/9V
LKQ+dcwW9KSmaRd91HVQrEIO2ExJ4mfdXKzuY+jckfYurypZVySm0pcrIWfigwdl
gtWHvueQdmPVJb3iaJCSB70KLF+KYIPHmfT2IjVGvkeFydI9TD6PkqIVxfmpNanC
F5/4TIIfctJDrBsQtsYH27fAXt64p5NdsgUo6/4ProUxTxGCR4ayu6dok7dxhbW5
jz+aSDLrK0NTyadi+ZWZD5YAkGz/VYaXvx5gvWgbcTD+cn/I1pZHbxfrmpvhRXYa
ip/qeJ3FsuXt9da33c7kDfbOpJyVzOkUyO1MjfpnhLG6MVZAf48ay0X4tekfLdqv
eHJqYQpdIDmZJy4WhyQz30qmhbcVCvWOJ19skUqRqiQ9lbxoTz7tFgr8dmqjSn0r
lI95CqM6J+UyotqcUB/ekNW6aS9WYjNcAzvWHCF0IHSYYSxWA+ImW8X+JKZ0XEmZ
ifUL/impfWFf8L2TPPqS0pNgzkpPYsMwo1sD+X0lhjNS4Cv8a/+v7WmLFFFbNtxI
J2ssetGbpzp3LAYBsfjmT6Lj7EVrd9/wQWh3pYA8wh+yOGgZepOTCXX749REWRSj
sj5k75rBXrwfLRd+XmkM
=8Rvw
-----END PGP SIGNATURE-----

--=-pBR7kqRVxtYtfyM8uORU--

