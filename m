From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v4] super1: fix sb->max_dev when adding a new disk in linear array
Date: Mon, 22 May 2017 21:07:33 +1000
Message-ID: <87d1b1jgju.fsf@notabene.neil.brown.name>
References: <20170522061612.29410-1-lzhong@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170522061612.29410-1-lzhong@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lidong Zhong <lzhong@suse.com>, linux-raid@vger.kernel.org
Cc: colyli@suse.com, Jes.Sorensen@gmail.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, May 22 2017, Lidong Zhong wrote:

> The value of sb->max_dev will always be increased by 1 when adding
> a new disk in linear array. It causes an inconsistence between each
> disk in the array and the "Array State" value of "mdadm --examine DISK"
> is wrong. For example, when adding the first new disk into linear array
> it will be:
>
> Array State : RAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
> ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D replacing)
>
> Adding the second disk into linear array it will be
>
> Array State : .AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
> ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D replacing)
>
> Signed-off-by: Lidong Zhong <lzhong@suse.com>
> ---
>  super1.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/super1.c b/super1.c
> index 2fcb814..03cea72 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1267,8 +1267,10 @@ static int update_super1(struct supertype *st, str=
uct mdinfo *info,
>  				break;
>  		sb->dev_number =3D __cpu_to_le32(i);
>  		info->disk.number =3D i;
> -		if (max >=3D __le32_to_cpu(sb->max_dev))
> +		if (i >=3D max) {
> +			sb->dev_roles[max] =3D __cpu_to_le16(MD_DISK_ROLE_SPARE);

Why do you assign to dev_roles[max]?
max must equal i here, and a few lines later:
		sb->dev_roles[i] =3D __cpu_to_le16(info->disk.raid_disk);

your assignment is over-written.  So it is pointless.
If i was greater than max (which should be impossible), you assignment
here would corrupt the dev_roles table.

Please drop this assignment.

>  			sb->max_dev =3D __cpu_to_le32(max+1);
> +		}
>=20=20
>  		random_uuid(sb->device_uuid);
>=20=20
> @@ -1293,9 +1295,14 @@ static int update_super1(struct supertype *st, str=
uct mdinfo *info,
>  			}
>  		}
>  	} else if (strcmp(update, "linear-grow-update") =3D=3D 0) {
> +		unsigned int max =3D __le32_to_cpu(sb->max_dev);
>  		sb->raid_disks =3D __cpu_to_le32(info->array.raid_disks);
>  		sb->dev_roles[info->disk.number] =3D
>  			__cpu_to_le16(info->disk.raid_disk);
> +		if (info->array.raid_disks >=3D max) {

if raid_disks =3D=3D max there is no need to change anything.
It is only when raid_disks > max that you need to increase max.

> +			sb->dev_roles[max] =3D __cpu_to_le16(MD_DISK_ROLE_SPARE);

When you increase max, you do need to assign MD_DISK_ROLE_SPARE to the
new element, but you need to do that *before* disk.raid_disk is
assigned, in case info->disk.number =3D=3D max (as it could be for the
recently added device).

NeilBrown


> +			sb->max_dev =3D __cpu_to_le32(max+1);
> +		}
>  	} else if (strcmp(update, "resync") =3D=3D 0) {
>  		/* make sure resync happens */
>  		sb->resync_offset =3D 0ULL;
> --=20
> 2.12.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkixnUACgkQOeye3VZi
gbmyKQ//WaLYoavvHKZvA0CRASMYyXoW2pmVIlR61TgJB9rtdZ3kyjrgtEDSlL0R
wgAwm/vpE6pVRNNLjj9+CA8tFV2KlEJPAb6H9v54RC8pkpyIDbCqcU1Xgs7PuiEL
ceXlEDLO/OER0M2bUIg413PS0e48vBLQly6MRp4sUizhUFvUaVejtuUXRKMkIoKL
hT9/5Aqukek3oifTjl6GynVJ+ffouQ1ylx4J6cRVtlg3Vj+WGGQZVE1SQXXz56l4
vsngRCqdQyq1hYSuU7jK0Od5u0n5YIQ6hnY1HGpKwaFfCnNrQ8qkn3n7PmPAYPto
Yrh4d5RvajqvM0gqDoJcUyc2T/i75rvSKyfAgcb8jL9cvFO6HU2UqrEOB2WfnE3N
kgCC55VKF6qYUcDCNpgziDbdfxHzEBFBm3h99WVyn8wd3YLhI0DgTST4+sjq0Q+y
uihFNXP4c2LFWyIoB2t0F2BzEzdcu6N0IgticIedmiz5DuQsZsf2C+PsQ5x1A46t
BAFgsnUEOGX8gwdLvUwk9/iUpweTmqVxbxODL2aHIzy86TV4C4d2v6hpcD1rNunj
CCpPfH4JUuhj31dnKbwIB+LYbxALUKF/98VSJ4PNV2smk6v3oTUbTShV69PZyBYH
+Hx1Donr6a5EXhdSv1v3taOJtRayjRYdAyCSp3YZUTAk4lI8tKs=
=o078
-----END PGP SIGNATURE-----
--=-=-=--
