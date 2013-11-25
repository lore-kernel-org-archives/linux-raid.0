From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid5: Use conf->device_lock protect changing of
 multi-thread resources.
Date: Mon, 25 Nov 2013 11:16:48 +1100
Message-ID: <20131125111648.7bdedb61@notabene.brown>
References: <1385136649.1586.27.camel@bwh-desktop.uk.level5networks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6DajYHgxLOQVYNZyAAX2x=a"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1385136649.1586.27.camel@bwh-desktop.uk.level5networks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: majianpeng <majianpeng@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/6DajYHgxLOQVYNZyAAX2x=a
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 22 Nov 2013 16:10:49 +0000 Ben Hutchings <bhutchings@solarflare.com>
wrote:

> Coverity reported a new defect after this change (commit 60aaf9338545) -
> passing a singleton pointer as the worker_groups parameter to
> alloc_thread_groups() which expects an array pointer.  But actually it
> looks like it should still be a singleton pointer and
> alloc_thread_groups() is broken:
>=20
> -       conf->worker_groups =3D kzalloc(sizeof(struct r5worker_group) *
> -                               conf->group_cnt, GFP_NOIO);
> -       if (!conf->worker_groups || !workers) {
> +       workers =3D kzalloc(size * *group_cnt, GFP_NOIO);
> +       *worker_groups =3D kzalloc(sizeof(struct r5worker_group) *
> +                               *group_cnt, GFP_NOIO);
> +       if (!*worker_groups || !workers) {
>                 kfree(workers);
> -               kfree(conf->worker_groups);
> -               conf->worker_groups =3D NULL;
> +               kfree(*worker_groups);
>                 return -ENOMEM;
>         }
> =20
> -       for (i =3D 0; i < conf->group_cnt; i++) {
> +       for (i =3D 0; i < *group_cnt; i++) {
>                 struct r5worker_group *group;
> =20
> -               group =3D &conf->worker_groups[i];
> +               group =3D worker_groups[i];
>=20
> This assignment should, I think, be:
>=20
> 		group =3D &(*worker_groups)[i];
>=20
> or equivalently:
>=20
> 		group =3D *worker_groups + i;
>=20
> Ben.
>=20


Thanks Ben!  I completely agree with the analysis.

Following patch queue for submission later in the week.

NeilBrown


From: NeilBrown <neilb@suse.de>
Date: Mon, 25 Nov 2013 11:12:43 +1100
Subject: [PATCH] md/raid5: fix new memory-reference bug in alloc_thread_gro=
ups.

In alloc_thread_groups, worker_groups is a pointer to an array,
not an array of pointers.
So
   worker_groups[i]
is wrong.  It should be
   &(*worker_groups)[i]

Found-by: coverity
Fixes: 60aaf9338545
Reported-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: majianpeng <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 47da0af6322b..676d8b7c5117 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5471,7 +5471,7 @@ static int alloc_thread_groups(struct r5conf *conf, i=
nt cnt,
 	for (i =3D 0; i < *group_cnt; i++) {
 		struct r5worker_group *group;
=20
-		group =3D worker_groups[i];
+		group =3D &(*worker_groups)[i];
 		INIT_LIST_HEAD(&group->handle_list);
 		group->conf =3D conf;
 		group->workers =3D workers + i * cnt;

--Sig_/6DajYHgxLOQVYNZyAAX2x=a
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUpKW8Dnsnt1WYoG5AQJ1fxAAtriNkKv9CfSoA/vHi8ET+DC7JSFaaEn1
mIbRRpmJUIJcSrEACASfgdqF1zWQuk+Euklo8p+ksaXDu6rPNPQMm52KoC5dkvDd
s/jGW8SqU+VC/Q5Lb4ev5fdI9QSI2iN9U4k/ErgmPip3OmPdrSk3e8sGCGquwqMh
ToXELGHYx94MadVqoIIgJD9s/QowqS6YP1E4dnyrqZe2OuLNBY3A5o7ZbBKzC5ZV
P89JtKTH2eg+FQ0wNwoE0ElVuebIfHxDAt+P8f/xPJZnPwv5Uq/eUsWYeY6Yx2zT
At5B8h9Uegk3tzdy0yd6UljWj/15Nql31VJITcmyRW6lMifMaaEwEJjczKAZmKd/
qYa+dEWCBrtn75nG9o7bP4Rv1MUpCFi1zkL53ML+dXpS1nXshjxWcsm+4A/krAcZ
FumTV4nBwitTlwlHAPlzvGAU8xFnbzyNzrCJFzgrqySxRJNZPys+itT3MSIQSWeh
ElAwxnqGzwEspsQVzSvgKDuxp6bWJxMFYmgZfpflPIs+KiZCjcFVOr1TBuvXaXsZ
nUc0KRe9UoORal+ioaXGRQb4KTkT3DHQiHEfTB5Q6I/HqveYqOBsGHyzjIRoONkm
LXLaOOLCjAujCcj+ck6ppHoBTY8JGIUsCB+oAfU5DmE03+wfaycmzOQPPmKz9vpM
elb3jJGyq/8=
=C1qC
-----END PGP SIGNATURE-----

--Sig_/6DajYHgxLOQVYNZyAAX2x=a--
