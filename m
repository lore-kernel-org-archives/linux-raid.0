From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
Date: Mon, 14 Jun 2010 17:53:27 +0600
Message-ID: <20100614175327.57f05bb1@natsu>
References: <4C1128C2.4020105@meetinghouse.net>
	<001501cb091f$07ac4e40$1704eac0$@woodlea.com>
	<20100611145019.6f1a5e7d@notabene.brown>
	<201006131628.35037.bernd.schubert@fastmail.fm>
	<20100614090520.2ae5a961@notabene.brown>
	<20100614151425.11f91562@natsu>
	<20100614194742.4a383a3f@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/s4oJ5R+_7SakiPr2KRr/8wD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100614194742.4a383a3f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/s4oJ5R+_7SakiPr2KRr/8wD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 14 Jun 2010 19:47:42 +1000
Neil Brown <neilb@suse.de> wrote:

> When you create an array an specify that a bitmap be added at the same ti=
me,
> there is more flexibility for size and location of the bitmap.  It can ea=
sily
> be more that 3K in that case.
>=20
> So presumably this array was created with a bitmap, rather than created
> without a bitmap and had a bitmap added later with --grow.  Correct?

Yes, as far as I remember. However, it seems a bit unfortunate to have any
significant difference between adding the bitmap right when creating the
array, and adding it later. For that reason, I'd suggest reserving more spa=
ce
in the metadata than 3K, even if the bitmap isn't requested - and even if it
won't be added later, then that space could prove useful for something else
that might require it later. Maybe 64, 128 or 256K - still miniscule compar=
ed
to the array size, and could provide some nice flexibility for the future.

--=20
With respect,
Roman

--Sig_/s4oJ5R+_7SakiPr2KRr/8wD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwWGDcACgkQTLKSvz+PZwjfVQCeKW+CXHM3ukhAxcI0jFM13nOC
7LAAnRxgLOcIkqmX4ro3cJUM01/64nDF
=SrkB
-----END PGP SIGNATURE-----

--Sig_/s4oJ5R+_7SakiPr2KRr/8wD--
