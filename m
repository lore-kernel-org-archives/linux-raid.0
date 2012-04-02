From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid1:Using 1 instead of update.
Date: Mon, 2 Apr 2012 12:01:38 +1000
Message-ID: <20120402120138.1475c54a@notabene.brown>
References: <201204011036292188169@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/LIC82=vSphNwQXXZM6Z797J"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201204011036292188169@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/LIC82=vSphNwQXXZM6Z797J
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 1 Apr 2012 10:36:32 +0800 "majianpeng" <majianpeng@gmail.com> wrote:

> >From 6991dc532e4d655fb509ba1dbe7a9869b0cd33d9 Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Sun, 1 Apr 2012 10:31:52 +0800
> Subject: [PATCH] md/raid1:Using 1 instead of update.=20
> If update =3D=3D 0 and then  set R1BIO_WriteError,so did not exec md_do_s=
ync().
>=20
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid1.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 4a40a20..def1ed1 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1554,7 +1554,7 @@ static void end_sync_write(struct bio *bio, int err=
or)
>  			reschedule_retry(r1_bio);
>  		else {
>  			put_buf(r1_bio);
> -			md_done_sync(mddev, s, uptodate);
> +			md_done_sync(mddev, s, 1);
>  		}
>  	}
>  }

Again, I think this hurts readability - it is less obvious that it is corre=
ct.

So I'll leave it as it is.

Thanks,
NeilBrown


--Sig_/LIC82=vSphNwQXXZM6Z797J
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3kIgjnsnt1WYoG5AQIfNA//dnowzDf+ziVNl6J/59+n0D90fwhtydWs
WhE4XUb0wvgYfeU1Es6ZxPqFijHgS33ftgBmUbEpgWIbA3wMU8XhfncDTgkO7XTo
2+/c5BgKse50WE2swGLFrNQvYMbBDoclTJLxilhR8O4nGpXwpkHGPd8mutXNAweE
OUY8HQjuMymk8Q3YdD4+K9nG0rOAIvL3PKYfDMpYOWF4soePB1A64EPKFKWCQAVe
WrIl0c6kahxdsXZodLlf+qGKWmuu+1LUd2PJ4JPhlmDKdpi+k/eGy1a7FAOFZXBA
DWjTPZGeaeOsJMtg6AqqKxQy3/y7dSxhFgYb8IButGHG0UIAWmHLQft0uYcy0XLy
5w1iCqHnnJs7zEV1Hr2MI0voIJ3+1mb7MhtzrVuy/DPBnkOOV4sCnSowBtRpYA90
entyvvkgaX0UXRJMJ/wiPDx+cXaXcDA753fIAwQ99U01Aw6IlXJ0a3Bm7Bzcy2fW
XOvSAs+Ch0g9JRt/Svj8xFL1F25YS1rqDTg/mNGG5rjTlpytk5EtXZiRA5jGAHaX
t7wjvgUzfjZzhN3IucNAhGvNP/dSfV9FUBsaUEN9rcq8T5CEVUhsxgpuXikZuIBK
b8bu400BLIA+45NcEpSZkgSnDu9Uq8GKUPnEV7dKoWgjA6sWccJ53FGiufGlF7Py
93TTQVxZOPk=
=0I8+
-----END PGP SIGNATURE-----

--Sig_/LIC82=vSphNwQXXZM6Z797J--
