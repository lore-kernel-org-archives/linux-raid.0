From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] mdadm: fix --detail for cases where device count >
 max_devices/2
Date: Tue, 4 Nov 2014 09:33:11 +1100
Message-ID: <20141104093311.2dabb44c@notabene.brown>
References: <CCCA52F1-B747-4762-8D07-12B543996470@reduxio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/_f8elr++kFVk6F4HSToNzDt"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CCCA52F1-B747-4762-8D07-12B543996470@reduxio.com>
Sender: linux-raid-owner@vger.kernel.org
To: Or Sagi <ors@reduxio.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/_f8elr++kFVk6F4HSToNzDt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 31 Oct 2014 11:10:33 +0200 Or Sagi <ors@reduxio.com> wrote:

> mdadm misreports (less devices then there are, and as a result decides th=
e array is degraded) in cases where there are > max_devices/2 devices.
>=20
> This seems to fix it.
>=20
> ---
> Detail.c |    4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/Detail.c b/Detail.c
> index c4fcad9..62e5867 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -72,7 +72,7 @@ int Detail(char *dev, struct context *c)
> 	int failed =3D 0;
> 	struct supertype *st;
> 	char *subarray =3D NULL;
> -	int max_disks =3D MD_SB_DISKS; /* just a default */
> +	int max_disks =3D MD_SB_DISKS * 2; /* just a default */
> 	struct mdinfo *info =3D NULL;
> 	struct mdinfo *sra;
> 	struct mdinfo *subdev;
> @@ -124,7 +124,7 @@ int Detail(char *dev, struct context *c)
> 	rv =3D 0;
>=20
> 	if (st)
> -		max_disks =3D st->max_devs;
> +		max_disks =3D st->max_devs * 2;
>=20
> 	if (subarray) {
> 		/* This is a subarray of some container.

Thanks  for the report, but this patch is too simplistic.
Setting "max_disks" to twice the maximum is clearly wrong.
Then it should be called twice_max_disks.

The problem is that the 'disks' array has two entries for each 'raid_disk',
the primary disk and a possible replacement.  So we need to check that all
references to the size of the array, or indices to it, are treated properly.

I think this patch should fix it.  Can you test please?

Thanks,
NeilBrown

diff --git a/Detail.c b/Detail.c
index c4fcad9620ba..dd72eded995d 100644
--- a/Detail.c
+++ b/Detail.c
@@ -295,8 +295,8 @@ int Detail(char *dev, struct context *c)
 		goto out;
 	}
=20
-	disks =3D xmalloc(max_disks * sizeof(mdu_disk_info_t));
-	for (d =3D 0; d < max_disks; d++) {
+	disks =3D xmalloc(max_disks * 2 * sizeof(mdu_disk_info_t));
+	for (d =3D 0; d < max_disks * 2; d++) {
 		disks[d].state =3D (1<<MD_DISK_REMOVED);
 		disks[d].major =3D disks[d].minor =3D 0;
 		disks[d].number =3D disks[d].raid_disk =3D d;
@@ -327,7 +327,7 @@ int Detail(char *dev, struct context *c)
 		else if (disk.raid_disk >=3D 0 && disk.raid_disk < array.raid_disks
 			 && disks[disk.raid_disk*2+1].state =3D=3D (1<<MD_DISK_REMOVED))
 			disks[disk.raid_disk*2+1] =3D disk;
-		else if (next < max_disks)
+		else if (next < max_disks*2)
 			disks[next++] =3D disk;
 	}
=20
@@ -602,7 +602,7 @@ This is pretty boring
 	}
 	free(info);
=20
-	for (d=3D 0; d < max_disks; d++) {
+	for (d=3D 0; d < max_disks * 2; d++) {
 		char *dv;
 		mdu_disk_info_t disk =3D disks[d];
=20

--Sig_/_f8elr++kFVk6F4HSToNzDt
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFgCpznsnt1WYoG5AQKrAg/+K93UoBHA+V3sg5mCwTRR3VJq8VlH77W0
TzQtRv72Qjr9AC3utHmAKiMzWjuB3pXPdw/7HhWZevdPjh3gEqwNHM/SLfafDs2b
WQOza5IOEdTEwKQf+tQnWe6VZL4RVQjbf12KMOTBQMrYAsz1oT3pi+IzdIRK7HI2
eu0Ra+JiLBWytuIJZLyefgL417sO2T+hQXHAJld6EK+IStsTWoXELwO1CWgGzK8g
kNo9yPMvKOphhvAF5O7j0FkXzyQBkWM04gkjI1id+pqz7MlMl7pAvIYTbtZJj1v8
qsn7VVRCZ0MtHyyeJdEJp+IK1WOajuNr6mKsSet6FI0zJ6Ef+xiMzEG0nQbemgRM
BiEYyOqGIwgjRQ8mfA6yzjfqOZZTHSwufaVAo6psX9+tIgKYXttNY85PuBM0HnrQ
bb4mRGy8g3LSJKOrV+Q1S73CNb7b89oSOVmX0DKVCuyPWgN1XLLAbGXzh8xmWzuH
KdnG964TQANcrTYU42ybhtv6m/o/bZal0Pd92/BvCIc0p93yQ07FNQH8t2i17Orm
uEilO6dcmnM6oHRaG9+Ntrvdh7ghb48zhP3v4BKSgPL6d4/IPshUdKMlMk+Xwlv1
H+w8Gc6xn5nMGVex6tbwN6LKnBzaFwkEiRLt8pcuz1PfKSftj1H1IukMeRTMCQTg
0rVkIA5DCYU=
=TThI
-----END PGP SIGNATURE-----

--Sig_/_f8elr++kFVk6F4HSToNzDt--
