From: NeilBrown <neilb@suse.de>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Mon, 26 Sep 2011 19:31:30 +1000
Message-ID: <20110926193130.6377f5b9@notabene.brown>
References: <4E7EDE58.3000804@yazzy.org>
	<20110926074002.6399de56@notabene.brown>
	<4E7FA3E8.5010603@yazzy.org>
	<20110926081853.2819622b@notabene.brown>
	<4E804062.3020700@yazzy.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6=eZrKma46s54rho23Ag+H9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E804062.3020700@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/6=eZrKma46s54rho23Ag+H9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Sep 2011 11:05:38 +0200 "Marcin M. Jessa" <lists@yazzy.org> wrot=
e:

> On 9/26/11 12:18 AM, NeilBrown wrote:
>=20
> > Do you remember what filesystem you had on 'storage'?  Was it ext3 or e=
xt4 or
> > xfs or something else?
>=20
> You're giving me some hope here and then silence :)
> Why did you ask about the file system? Should I run fsck on the LV ?
>=20
>=20
>=20

You already did run fsck on the LV.  It basically said that it didn't
recognise the filesystem at all.
I asked in case maybe it was XFS in which case a different tool would be
required.
But you said it was EXT4, so the fsck.ext2 which you used should have worked
if anything would.

It is certainly odd that the LVM info is all consistent, but the filesystem
info has disappear.  It could be that you have the chunksize or device order
wrong and so it is looking for the filesystem info at the wrong place.

Nothing else I can suggest - sorry.

NeilBrown

--Sig_/6=eZrKma46s54rho23Ag+H9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOgEZyG5fc6gV+Wb0RAs59AKC06etbySkFAJBKoIJ0jcB+vVq9fQCfXkbB
qTlUihw3J/zbMkjBDlFsq8Y=
=cP6x
-----END PGP SIGNATURE-----

--Sig_/6=eZrKma46s54rho23Ag+H9--
