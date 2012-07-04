From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 2/3 v3] raid1: read balance chooses idlest disk for SSD
Date: Wed, 4 Jul 2012 15:45:31 +1000
Message-ID: <20120704154531.3eca9cb5@notabene.brown>
References: <20120702010840.197370335@kernel.org>
	<20120702011031.890864816@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KvZlFhkfQcC+.5TF32GjKN_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120702011031.890864816@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

--Sig_/KvZlFhkfQcC+.5TF32GjKN_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 02 Jul 2012 09:08:42 +0800 Shaohua Li <shli@kernel.org> wrote:

> SSD hasn't spindle, distance between requests means nothing. And the orig=
inal
> distance based algorithm sometimes can cause severe performance issue for=
 SSD
> raid.
>=20
> Considering two thread groups, one accesses file A, the other access file=
 B.
> The first group will access one disk and the second will access the other=
 disk,
> because requests are near from one group and far between groups. In this =
case,
> read balance might keep one disk very busy but the other relative idle.  =
For
> SSD, we should try best to distribute requests to as more disks as possib=
le.
> There isn't spindle move penality anyway.
>=20
> With below patch, I can see more than 50% throughput improvement sometimes
> depending on workloads.
>=20
> The only exception is small requests can be merged to a big request which
> typically can drive higher throughput for SSD too. Such small requests are
> sequential reads. Unlike hard disk, sequential read which can't be merged=
 (for
> example direct IO, or read without readahead) can be ignored for SSD. Aga=
in
> there is no spindle move penality. readahead dispatches small requests an=
d such
> requests can be merged.
>=20
> Last patch can help detect sequential read well, at least if concurrent r=
ead
> number isn't greater than raid disk number. In that case, distance based
> algorithm doesn't work well too.
>=20
> V2: For hard disk and SSD mixed raid, doesn't use distance based algorith=
m for
> random IO too. This makes the algorithm generic for raid with SSD.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid1.c |   23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
>=20
> Index: linux/drivers/md/raid1.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid1.c	2012-06-28 16:56:20.846401902 +0800
> +++ linux/drivers/md/raid1.c	2012-06-29 14:13:23.856781798 +0800
> @@ -486,6 +486,7 @@ static int read_balance(struct r1conf *c
>  	int best_disk;
>  	int i;
>  	sector_t best_dist;
> +	unsigned int min_pending;
>  	struct md_rdev *rdev;
>  	int choose_first;
> =20
> @@ -499,6 +500,7 @@ static int read_balance(struct r1conf *c
>  	sectors =3D r1_bio->sectors;
>  	best_disk =3D -1;
>  	best_dist =3D MaxSector;
> +	min_pending =3D -1;
>  	best_good_sectors =3D 0;
> =20
>  	if (conf->mddev->recovery_cp < MaxSector &&


That's not good form - declaring a variable "unsigned int" then assigning
"-1" to it.
Maybe initialise it to "UINT_MAX".

> -		if (dist < best_dist) {
> +
> +		/*
> +		 * If all disks are rotational, choose the closest disk. If any
> +		 * disk is non-rotational, choose the disk with less pending
> +		 * request even the disk is rotational, which might/might not
> +		 * be optimal for raids with mixed ratation/non-rotational
> +		 * disks depending on workload.
> +		 */
> +		if (nonrot || min_pending !=3D -1) {
> +			if (min_pending > pending) {
> +				min_pending =3D pending;
> +				best_disk =3D disk;
> +			}
> +		} else if (dist < best_dist) {
>  			best_dist =3D dist;
>  			best_disk =3D disk;
>  		}

It don't think it is clear that the code matches the comment in all cases.
e.g. if you have 3 disks and the first 2 were rotational, then you wouldn't
examine the 'pending' count of the 2nd disk at all.
Also you never examine the distance for the first disk.

Maybe if you have a 'best_pending_disk' and a 'best_dist_disk' and after
the loop, use best_pending_disk if any were non-rotation, and best_disk_disk
if all were rotating.

Thanks,
NeilBrown



--Sig_/KvZlFhkfQcC+.5TF32GjKN_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/PYeznsnt1WYoG5AQLrhRAAq4o4Cu+UiINfEXe4TpN3+QXPXDim19US
0dq8dqmsJQpGc3rSDv7aNGPy0G4LUsMfyODqNcG+A4/c4UBeftialvxSm3xqlp9B
tFfVG97v668749x+srPXwdwHNLvWJCto9ov5nOskZlQR20USDeseVsRQzgAiZ0j2
fHZ2gA/SO69qUeNlcXUCzXSQ6ahpvlJQWCLjPPX6HZiDqk1v5+6KYZYR77wRyNFw
jDA80ki4naTDkCHZi28fh6RClZbFXorgV/C4CMk65onnCI+JeouQj1Zp0VPIfyTv
YgpE92V5+XpX/++fhLOfbkdWalw+JE+rJ0oBSC2SYUqMoMPAO1BV3R9ebpLmZ7Iw
0C1sD5qbrouN/A3tQHE3c+xfiBPFVrzC/daIzx6/ja83uOF0LfsH/l2xls1gZz/4
6s2sFLEZ9osospxOyUNZeMEPr48wCUSQaAT4Hg8WAWGb50z8BCR+KPyDwI8Nvj1Y
WA0rHxbzD3SlOLpC5yqyuc7HAEPVC6VFJ1sy7k7HEVvMPQKa5TdEfN37L9FeEpad
4ccJXqZhxrfoYI7MhF9fYjEFisKcZdjQQwPYQSeYwwAHC3oewUgqRjTDhLMtjs0Z
n7JoXsgfRakY+QfFZV3KIRgXNmAKyHmkLRXmbSvNT1foYT1ZN9B7PYIJ3QXtcD2X
oMFaRONmaG4=
=tXvr
-----END PGP SIGNATURE-----

--Sig_/KvZlFhkfQcC+.5TF32GjKN_--
