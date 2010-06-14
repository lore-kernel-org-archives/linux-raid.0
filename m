From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
Date: Mon, 14 Jun 2010 15:14:25 +0600
Message-ID: <20100614151425.11f91562@natsu>
References: <4C1128C2.4020105@meetinghouse.net>
	<001501cb091f$07ac4e40$1704eac0$@woodlea.com>
	<20100611145019.6f1a5e7d@notabene.brown>
	<201006131628.35037.bernd.schubert@fastmail.fm>
	<20100614090520.2ae5a961@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/J/Dp9Vw4KHJ4DF/hq6Ea09p"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100614090520.2ae5a961@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/J/Dp9Vw4KHJ4DF/hq6Ea09p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 14 Jun 2010 09:05:20 +1000
Neil Brown <neilb@suse.de> wrote:

> > While I have done this myself a couple of times, I still do not underst=
and=20
> > where it takes the disk space for the bitmap journal from? Is this space
> > mdadm reserved for this purpose?
>=20
> Sort-of.
> It uses space that the alignment requirements of the metadata assure us is
> otherwise unused.
> For v0.90, that is limited to 60K.  For 1.x it is 3K.

I have now:

md0 : active raid5 sdf3[3] sde3[1] sda3[0]
      3887004672 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UU=
U]
      bitmap: 1/8 pages [4KB], 131072KB chunk

Metadata is 1.2, and the internal bitmap is 8 pages, which is 32K, not 3K.
Did I misunderstand something, or perhaps 3K was a typo?

--=20
With respect,
Roman

--Sig_/J/Dp9Vw4KHJ4DF/hq6Ea09p
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwV8vEACgkQTLKSvz+PZwhqyACfRXKK1AYUNOYr/P12eonsiGvZ
oDoAn2HOfK/z8xoQ9ALzLUujZ0LGr8CK
=CVEF
-----END PGP SIGNATURE-----

--Sig_/J/Dp9Vw4KHJ4DF/hq6Ea09p--
