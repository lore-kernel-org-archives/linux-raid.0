From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Best size partition for a mdadm array
Date: Mon, 27 May 2013 15:34:26 +0600
Message-ID: <20130527153426.108c8b4a@natsu>
References: <CAOsORH9X6L+EZY5DEDfwbWkHPgL6Oz9yGC1JWf0nejLckVJg=w@mail.gmail.com>
	<51A2D4A5.6000907@smartguide.com.au>
	<CAOsORH-atqXVkkn+YWH+Q0pO0ZCKvRL3EWUpxa6h-GfsxsjdcQ@mail.gmail.com>
	<8b038c62bf256249769a7dc0bf565db4.squirrel@webmail.websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Vvi//zRhSo4TpEc7WPx4MKT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8b038c62bf256249769a7dc0bf565db4.squirrel@webmail.websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Andrea Bolandrina <andrea.bola@yahoo.it>, Tudor Holton <tudor@smartguide.com.au>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Vvi//zRhSo4TpEc7WPx4MKT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 27 May 2013 19:11:32 +1000
"Adam Goryachev" <mailinglists@websitemanagers.com.au> wrote:

> On Mon, May 27, 2013 18:38, Andrea Bolandrina wrote:
> > Hi Tudor.
> >
> > All disks I have report the same size, even though they are different
> > brand/model
>=20
> Discussion on this list in the past would suggest the manufacturers have
> agreed to make equal sized drives in future, so this shouldn't really be
> an issue for 2TB drives or larger.

There are also some overly smart BIOSes, which in certain motherboard models
and versions are configured to automatically store a backup of the BIOS on =
the
primary HDD. What they do is cut off a small area from the HDD's "tail" by
establishing an HPA there, and put the BIOS copy on that area, possibly
overwriting whatever was there previously.

http://forums.overclockers.com.au/showthread.php?t=3D885212
http://matt.simerson.net/news/2009/07/22/hpa-host-protected-area
http://www.gigabyte.com/webpage/8/article_04_bios_explained.htm

The forum discussion linked cites the actual number to be 2113 sectors whic=
h is
about 1 MB.

Personally I always leave about 8 MB in the end of all disks just in case.


--=20
With respect,
Roman

--Sig_/Vvi//zRhSo4TpEc7WPx4MKT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlGjKKIACgkQTLKSvz+PZwhkbACdHtwf8I4T/v6QoyBj8gCsBr5J
OgwAmgLkeWum97NXNF746/b5u7VrtXOu
=UxQk
-----END PGP SIGNATURE-----

--Sig_/Vvi//zRhSo4TpEc7WPx4MKT--
