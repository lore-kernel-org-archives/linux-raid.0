From: Roman Mamedov <rm@romanrm.ru>
Subject: Re:
Date: Mon, 26 Sep 2011 13:03:51 +0600
Message-ID: <20110926130351.63adc330@natsu>
References: <09f356fa46129bd08dd45752c0f736de.squirrel@www.maxstr.com>
	<20110926145248.6ffc5f02@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/B.kaW=U+UMXGE/_sGoLBNEa"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110926145248.6ffc5f02@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: kenn@kenn.us, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/B.kaW=U+UMXGE/_sGoLBNEa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Sep 2011 14:52:48 +1000
NeilBrown <neilb@suse.de> wrote:

> On Sun, 25 Sep 2011 21:23:31 -0700 "Kenn" <kenn@kenn.us> wrote:
>=20
> > I have a raid5 array that had a drive drop out, and resilvered the wrong
> > drive when I put it back in, corrupting and destroying the raid.  I
> > stopped the array at less than 1% resilvering and I'm in the process of
> > making a dd-copy of the drive to recover the files.
>=20
> I don't know what you mean by "resilvered".

At first I thought the initial poster just invented some peculiar funny wor=
d of his own, but it looks like it's from the ZFS circles:
https://encrypted.google.com/search?q=3Dresilver+zfs
@Kenn; you probably mean 'resync' or 'rebuild', but no one ever calls those=
 processes 'resilver' here, you'll get no google results and blank/unknowin=
g/funny looks from people when using that term in relation to mdadm.

--=20
With respect,
Roman

--Sig_/B.kaW=U+UMXGE/_sGoLBNEa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6AI9cACgkQTLKSvz+PZwhdhgCeMEDJMGiLYk5tldhV1RtwGCjH
xwQAmwS+YmGJzn20k04TpRd9ahSJxNoX
=HjY1
-----END PGP SIGNATURE-----

--Sig_/B.kaW=U+UMXGE/_sGoLBNEa--
