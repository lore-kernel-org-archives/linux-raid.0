From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Which physical device failed?
Date: Wed, 27 May 2015 23:02:23 +0500
Message-ID: <20150527230223.4ef48749@natsu>
References: <5565B2BB.5090701@gmail.com>
	<5565B41B.8040104@aei.mpg.de>
	<20150527172701.1090e525@natsu>
	<55660373.3030700@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aqJxNBmYwh4g0Y6hg3evPGC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55660373.3030700@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>, Michael Munger <michael.munger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/aqJxNBmYwh4g0Y6hg3evPGC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 May 2015 18:48:35 +0100
Wols Lists <antlists@youngman.org.uk> wrote:

> Just for info, I've done an ls -al on my by-id directory, and I have
> no clue whatsoever as to what the serial number is. All my drives
> appear twice (Seagate Barracudas), there is no manufacturer name that
> I can see, and while the model number appears in one of the records,
> there is nothing obvious to indicate whether what follows is the
> serial number or whether the serial number is part of the other
> directory entry.
>=20
> Not helped, of course, by the fact I have no clue what the serial
> number looks like ... :-)
>=20
> ata-ST3000DM001-1CH166_W1F4JWRP -> ../../sdb
> ata-ST3000DM001-1CH166_W1F50K0F -> ../../sda

=46rom a picture of this model's top side
http://www.nix.ru/autocatalog/hdd_seagate/126689_2245_draft_large.jpg
the serial number on this model is 8 alphanumeric characters, so in your ca=
se
W1F4JWRP and W1F50K0F are the serial numbers.

--=20
With respect,
Roman

--Sig_/aqJxNBmYwh4g0Y6hg3evPGC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlVmBq8ACgkQTLKSvz+PZwgPEQCfenb2y872wgmLyyZZujJkfgmZ
I4AAn3/6FzUke3bSh0j+kOCx+Y2F2J0I
=ey7Z
-----END PGP SIGNATURE-----

--Sig_/aqJxNBmYwh4g0Y6hg3evPGC--
