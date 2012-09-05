From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1 of 3] MD RAID10: Prep for DM RAID10 device replacement
 capability
Date: Wed, 5 Sep 2012 12:03:57 +1000
Message-ID: <20120905120357.7e7dd316@notabene.brown>
References: <1345832315.25206.16.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qhhh5YOnPYuW_CwtUq8cDis"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1345832315.25206.16.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/qhhh5YOnPYuW_CwtUq8cDis
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Aug 2012 13:18:35 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> MD RAID10:  Fix a couple potential kernel panics if RAID10 is used by dm-=
raid
>=20
> When device-mapper uses the RAID10 personality through dm-raid.c, there i=
s no
> 'gendisk' structure in mddev and some sysfs information is also not popul=
ated.
>=20
> This patch avoids touching those non-existent structures.
>=20
> Signed-off-by: Jonathan Brassow <jbrassow@rehdat.com>
>=20
> Index: linux-upstream/drivers/md/md.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/md.c
> +++ linux-upstream/drivers/md/md.c
> @@ -2056,8 +2056,14 @@ EXPORT_SYMBOL(md_integrity_register);
>  /* Disable data integrity if non-capable/non-matching disk is being adde=
d */
>  void md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev)
>  {
> -	struct blk_integrity *bi_rdev =3D bdev_get_integrity(rdev->bdev);
> -	struct blk_integrity *bi_mddev =3D blk_get_integrity(mddev->gendisk);
> +	struct blk_integrity *bi_rdev;
> +	struct blk_integrity *bi_mddev;
> +
> +	if (!mddev->gendisk)
> +		return;
> +
> +	bi_rdev =3D bdev_get_integrity(rdev->bdev);
> +	bi_mddev =3D blk_get_integrity(mddev->gendisk);
> =20
>  	if (!bi_mddev) /* nothing to do */
>  		return;
> Index: linux-upstream/drivers/md/raid10.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/raid10.c
> +++ linux-upstream/drivers/md/raid10.c
> @@ -1632,7 +1632,7 @@ static int raid10_spare_active(struct md
>  			   && !test_bit(Faulty, &tmp->rdev->flags)
>  			   && !test_and_set_bit(In_sync, &tmp->rdev->flags)) {
>  			count++;
> -			sysfs_notify_dirent(tmp->rdev->sysfs_state);
> +			sysfs_notify_dirent_safe(tmp->rdev->sysfs_state);
>  		}
>  	}
>  	spin_lock_irqsave(&conf->device_lock, flags);
>=20


This and the other too all look fine - applied.  Thanks.

While reviewing I noticed:

			if (value > rs->md.raid_disks) {
				rs->ti->error =3D "Invalid rebuild index given";
				return -EINVAL;
			}

(in the 'rebuild' handling).  That should be  'value >=3D rs->md.raid_disks'
shouldn't it?
If you agree, please send a patch.

Thanks,
NeilBrown

--Sig_/qhhh5YOnPYuW_CwtUq8cDis
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUEazDTnsnt1WYoG5AQLpYQ//YtxdtKZw0ILI4wcB1UM9Y39dnSc9xH4M
0xXSU73evJbPNlk43p3mhaHNcphbaPyshFDIlZalhvDNVl42rheRdG7mzpHoogIe
YK0mA/rZ9v/ad0LI592Ae99N6VHC8aFpCDBsLq/2cSdvZoxY2kJSHX9DtzA9g4Hn
5OPYcZ3T2klYFnxDZcCZtDnTB5/d8PTuPufqd0ePcqhiQU8cPetolCuTA7xKuYH+
N0Y+rMr/fI0LugppcYXeBi2Evb+wpVulf7/shr1E6A5W8Ekely13kSy/V1hmrQMZ
d7SX8URTNGUbJEQZakGD6Ox/j3pKPeUPBzuiSaM/GQhdnw39dl9NdJ3Mh0wHM2HI
J8/tnbPiCy6Qse8T9U1hLxDG7dLVS97OCmXFbdWPs4JtIDgyFPP31x8O/qTZIBxJ
FQ5TpT4eGMDIwRh1kmwSGRNVXgETlDVd9zVZy9i7ClQEO7EuH9mm/5A20dCIyBuW
OWddxKIuD7ix9bh7Pzg+rock4iCgkdWyNBTwToF+RbJrGyaf159M1u+nh+rclO3E
vGSAlW7anmgxAcWxu4lEnnYruSysWRlu9Dzzu5epnPkfLkuP0J8JygV/S3gR375k
TctSZ9ghaXMhTjqHBDqufK1EZrBaB7tu+avVSYb18zD8VZ/PFSfa6EeOHnU2KTqB
+h9UczA5HTc=
=OJW4
-----END PGP SIGNATURE-----

--Sig_/qhhh5YOnPYuW_CwtUq8cDis--
