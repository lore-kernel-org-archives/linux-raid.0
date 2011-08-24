From: Robin Hill <robin.hill47@ntlworld.com>
Subject: Re: Raid 5 to Raid 1 (half of the data not required)
Date: Wed, 24 Aug 2011 08:34:54 +0100
Message-ID: <20110824073454.GA1925@cthulhu.home.robinhill.me.uk>
References: <BAY148-W51F7F3A42E515F76BB76EFEF2E0@phx.gbl>
 <20110824104649.1c5696c3@notabene.brown>
 <BAY148-W29A568212EC52E4C4BC52EF110@phx.gbl>
 <20110824123938.6743e87c@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110824123938.6743e87c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Viau <viaum@sheridanc.on.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Aug 24, 2011 at 12:39:38 +1000, NeilBrown wrote:

> On Tue, 23 Aug 2011 22:18:12 -0400 Mike Viau <viaum@sheridanc.on.ca> wrot=
e:
>=20
> >=20
> > I am not sure how crack-pot of a solution this would be, but could I:=
=20
> >=20
> > 1/ mdadm -r /dev/md0 /dev/sde1
> > Remove /dev/sde1 from the raid 5 array
>=20
> Here you have lost your redundancy .... your choice I guess.
>=20
> >=20
> > 2/ dd if=3D/dev/zero of=3D/dev/sde1 bs=3D512 count=3D1
> > This clears the msdos mbr and clears the partitions
> >=20
> > 3/ parted, fdisk or cfdisk to create a new 1TB (or less is possible as =
well) ext4 partition on /dev/sde
> >=20
> > 4/ mkfs.ext4 /dev/sde1
> >=20
> > 5/ cp -R {mounted location of degraded /dev/md0 partition} {mounted loc=
ation of /dev/sde1 partition}
> > Aka backup
> >=20

If you're wanting to backup, "cp -a" would be better than "cp -R",
otherwise you lose attributes & symlinks.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5UqZ0ACgkQShxCyD40xBIzrQCdGWxgKe6wrDryoij1qHzqxHwK
ZjgAnAqmmivAsMgT2dflyyDtzSOXydBL
=ef6g
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
