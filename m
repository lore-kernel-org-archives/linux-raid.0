From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 1/3 v3] raid1: make sequential read detection per disk
 based
Date: Wed, 4 Jul 2012 15:38:45 +1000
Message-ID: <20120704153845.509b5814@notabene.brown>
References: <20120702010840.197370335@kernel.org>
	<20120702011025.079670656@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/P9IJTpY8CWlXP+RPn7ubu6y"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120702011025.079670656@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

--Sig_/P9IJTpY8CWlXP+RPn7ubu6y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 02 Jul 2012 09:08:41 +0800 Shaohua Li <shli@kernel.org> wrote:

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
> --- linux.orig/drivers/md/raid1.c	2012-06-28 10:44:47.550666575 +0800
> +++ linux/drivers/md/raid1.c	2012-06-28 12:01:03.513137377 +0800
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
>  		if (disk >=3D conf->raid_disks)
>  			disk -=3D conf->raid_disks;

One last little change please.  Could you make that loop:


     for (disk =3D 0; disk < conf->raid_disks * 2; disk++)

and remote the 'if' statement that wraps 'disk' back to zero
when it gets too big (which is buggy and has been fixed in my for-next).

With that change I'll take the patch.

Thanks,
NeilBrown


--Sig_/P9IJTpY8CWlXP+RPn7ubu6y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/PW5Tnsnt1WYoG5AQImcxAAkD4M9EYlEWRnpT6guXlBtktJjcskNpjk
vYSLnsQpOKLebX1XmhioQhAbvwY9bl2qak8aXnaR5kZDx4H9FnsOTtlo0NWb24u3
QvriCJj113OUUHLM2Tx0XNyjEXvyX/VAk1G1ECKoed06HQbc8KG+06tBKxdmZXJu
U2g3ljCHBZ80bjXbKkNDa8vWa0hO4pYUummqFrsPy3VqbLEgPZxexLJtTWUQ7pr4
yq2irGCIsBck8idsmiGiU/E83S1xXXPkTqT4wdanBRsUpDa0yMJBh7PdvshpY7uU
DfuXYKt9BvMiMa5bHNZGCxVdq6LIya9lUA3GEHVQp6CFSDrcObyixG8dYyABWudr
OEgQGn8IshcAbtGuyClR5RvaOUJUPkXr7zmzafbAiqQt70vHf1mMvksoCpGyOea2
Pu2gHoXmOaaK5hnHPx6UKqo5KKTd3Pva4+ul7cH9GuAi4tgqBOha0hSwkbSAFZtG
IOmHuy8BYljDrcO+SVIIyQhnTaAyuZ20RUwKoedrLlhmvddhRi0K4Bb6KwhyK0u2
Jf/NIGshH3wB/f4PInINfOCKF2fHUGXhGEvsGQdDQHKIUkTDBrcYfsgRYHiVQl4w
qw4qX3r7FJ0STKddNgUg4tktk7lUcdkvzdfJTUkW2HHJbJq+UbNuAFoywla9BgzM
giPEQzHSr+o=
=lKcN
-----END PGP SIGNATURE-----

--Sig_/P9IJTpY8CWlXP+RPn7ubu6y--
