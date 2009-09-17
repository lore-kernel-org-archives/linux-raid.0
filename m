From: Andre Noll <maan@systemlinux.org>
Subject: Re: RAID1 assembled broken array
Date: Thu, 17 Sep 2009 10:25:28 +0200
Message-ID: <20090917082528.GO5174@skl-net.de>
References: <h8ophd$n8p$6@ger.gmane.org> <9F2F4760-DF0C-4416-89AC-C689177AD4ED@redhat.com> <65549e07fd6559855af68b60783213c3.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+mr2ctTDD1GjnQwB"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <65549e07fd6559855af68b60783213c3.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, Matthias Urlichs <matthias@urlichs.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--+mr2ctTDD1GjnQwB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07:01, NeilBrown wrote:
> > Wrong lesson.  The correct lesson to gather from this is to prefer
> > version 1.1 or 1.2 superblocks wherever possible.  Superblocks at the
> > beginning of the device disappear when there is no partition table,
> > superblocks at the end can be confused for superblocks belonging to
> > the whole device when there is no partition table.
>=20
> 1.0 also protects from this problem.  The 1.x metadata stores the
> offset of the superblock from the start of the device.  That will appear
> to be wrong if you find a partition-superblock when reading from a
> whole-device, so mdadm will reject the device as not having a valid
> superblock.

BTW: Why are new arrays still created with 0.90 metadata format by
default?

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--+mr2ctTDD1GjnQwB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKsfJ4Wto1QDEAkw8RApFAAJ4ouXQ+8y/yGWecx3Nvuv98gyZfowCfRun2
DvVYlFGV7bnzsHp11trhGWY=
=S0SD
-----END PGP SIGNATURE-----

--+mr2ctTDD1GjnQwB--
