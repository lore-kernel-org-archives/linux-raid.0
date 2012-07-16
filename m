From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 1/3 v4]raid1: make sequential read detection per disk
 based
Date: Mon, 16 Jul 2012 14:24:52 +1000
Message-ID: <20120716142452.081b43da@notabene.brown>
References: <20120705092031.GA27956@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5R8miYlPayAn99uUv6BdGcu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120705092031.GA27956@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/5R8miYlPayAn99uUv6BdGcu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Jul 2012 17:20:31 +0800 Shaohua Li <shli@kernel.org> wrote:

> Currently the sequential read detection is global wide. It's natural to m=
ake it
> per disk based, which can improve the detection for concurrent multiple
> sequential reads. And next patch will make SSD read balance not use dista=
nce
> based algorithm, where this change help detect truly sequential read for =
SSD.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid1.c |   29 ++++++-----------------------
>  drivers/md/raid1.h |   11 +++++------
>  2 files changed, 11 insertions(+), 29 deletions(-)
>=20
> Index: linux/drivers/md/raid1.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid1.c	2012-07-04 11:53:32.000000000 +0800
> +++ linux/drivers/md/raid1.c	2012-07-04 15:23:51.114885573 +0800
> @@ -483,7 +483,6 @@ static int read_balance(struct r1conf *c
>  	const sector_t this_sector =3D r1_bio->sector;
>  	int sectors;
>  	int best_good_sectors;
> -	int start_disk;
>  	int best_disk;
>  	int i;
>  	sector_t best_dist;
> @@ -503,20 +502,17 @@ static int read_balance(struct r1conf *c
>  	best_good_sectors =3D 0;
> =20
>  	if (conf->mddev->recovery_cp < MaxSector &&
> -	    (this_sector + sectors >=3D conf->next_resync)) {
> +	    (this_sector + sectors >=3D conf->next_resync))
>  		choose_first =3D 1;
> -		start_disk =3D 0;
> -	} else {
> +	else
>  		choose_first =3D 0;
> -		start_disk =3D conf->last_used;
> -	}
> =20
>  	for (i =3D 0 ; i < conf->raid_disks * 2 ; i++) {
>  		sector_t dist;
>  		sector_t first_bad;
>  		int bad_sectors;
> =20
> -		int disk =3D start_disk + i;
> +		int disk =3D i;
>  		if (disk >=3D conf->raid_disks * 2)
>  			disk -=3D conf->raid_disks * 2;

You forgot the change I asked for here to make it
      for (disk =3D 0; disk < ..... ; disk++)

but you've fixed up all the other bits nicely, so I made the above change a=
nd
have applied all three patches, thanks.

NeilBrown


--Sig_/5R8miYlPayAn99uUv6BdGcu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAOXlDnsnt1WYoG5AQLhpA/9FIf/xPkQcmwjMAfmsSUV6Ir63VKqlYN8
PE0ulczZIQvZr3SJbq/dZrSZwj88aiy3XEQdEIJOI/gX4M05fod8+M3dnvWAqp6i
32UT7EhlNWjyY4vux6G1yMv3R691421rTQAjCih1EwDgz5O7Gxm5sA8zdHK9c8TM
VDlMIH7K/R/8u6E2xu3J2QetevZTmz3RCOhTGuGEHuwNju8j57eEBFhcOzOv+3lU
tvYqpMpZe8M1UZ8o6+38xtSfzkCZYqyy/16qjgUgke7vcqloj0EcNgE3y8pIns+a
i9vKpVSDxIcIXA0Sj8uHMBiZIeLn4Wj1aNxNSS9fQREFx9l5ekDCn7jPSL+Kb8Jo
tmtrqcr1nBFTHNX651UQ5H2v81+5Dl6WV+2zpYARd/bNsQLJFs3wQwATV6TT6JrM
zVYfRm295Rn6KliZI7XopOiZW7hSNbUg01f7wmXNn4kZaFxSinbP/K6wiUrm89Os
7bv6hpbtiYsJ7auDdDZe0nok+RvFaRe1Ct7T+0AV5Oajzf69HVLUP8sarvZ4+LdT
MiVG5Xp8ktpyDOrsE/q34ue/4Ay93aUkdFXVeASe7SwXak4OMEZDiyYtzeAlWuf6
GgMMOodFEGJ3+ysvV2NCKkVvZmACIabTzmWuBTQzVhlcY9UzBWoWatqgeVFlDklo
GxF5U7MBgYo=
=e2VA
-----END PGP SIGNATURE-----

--Sig_/5R8miYlPayAn99uUv6BdGcu--
