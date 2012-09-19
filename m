From: NeilBrown <neilb@suse.de>
Subject: Re: md: raid5 resync corrects read errors on data block - is this
 correct?
Date: Wed, 19 Sep 2012 15:59:17 +1000
Message-ID: <20120919155917.3d67f890@notabene.brown>
References: <CAGRgLy6Cqxyf2im+tG2JiaQFooLBBzT76hGpfTb47Cr_sFLr6g@mail.gmail.com>
	<20120912082909.33c8eec0@notabene.brown>
	<CAGRgLy6Syso2dfELFhpK9nCyEgvuD6k3F=MRJBnrVU=btKqKVw@mail.gmail.com>
	<20120913101924.13431e6e@notabene.brown>
	<CAGRgLy7VRTeegGXbxhzn4zrCt6agoQqLaOT5mM7=vSkq6XDN5A@mail.gmail.com>
	<CAGRgLy4bbfuK0zF8kkP2at+2kZz8CYrFy+EgTDFPMjPc+edUgg@mail.gmail.com>
	<CAGRgLy6wNUNWjOb8-5p2Wbag9R260AL++KU8xe-JTzgSoSqwpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DLs_JCceETklD5Xfk8oUz5a"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6wNUNWjOb8-5p2Wbag9R260AL++KU8xe-JTzgSoSqwpA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/DLs_JCceETklD5Xfk8oUz5a
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Sep 2012 14:15:16 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> below is a bit less-ugly version of the patch.
> Thanks,
> Alex.
>=20
> >From 05cf800d623bf558c99d542cf8bf083c85b7e5d5 Mon Sep 17 00:00:00 2001
> From: Alex Lyakas <alex@zadarastorage.com>
> Date: Thu, 13 Sep 2012 18:55:00 +0300
> Subject: [PATCH] When RAID5 is dirty, force reconstruct-write instead of
>  read-modify-write.
>=20
> Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
> Signed-off-by: Yair Hershko <yair@zadarastorage.com>
>=20
> diff --git a/ubuntu_kmodules/Ubuntu-3.2.0-25.40/drivers/md/raid5.c
> b/ubuntu_kmodules/Ubuntu-3.2.0-25.40/drivers/md/raid5.c
> index 5332202..0702785 100644
> --- a/ubuntu_kmodules/Ubuntu-3.2.0-25.40/drivers/md/raid5.c
> +++ b/ubuntu_kmodules/Ubuntu-3.2.0-25.40/drivers/md/raid5.c
> @@ -2555,12 +2555,36 @@ static void handle_stripe_dirtying(struct r5conf =
*conf,
>                                    int disks)
>  {
>         int rmw =3D 0, rcw =3D 0, i;
> -       if (conf->max_degraded =3D=3D 2) {
> -               /* RAID6 requires 'rcw' in current implementation
> -                * Calculate the real rcw later - for now fake it
> +       sector_t recovery_cp =3D conf->mddev->recovery_cp;
> +       unsigned long recovery =3D conf->mddev->recovery;
> +       int needed =3D test_bit(MD_RECOVERY_NEEDED, &recovery);
> +       int resyncing =3D test_bit(MD_RECOVERY_SYNC, &recovery) &&
> +                       !test_bit(MD_RECOVERY_REQUESTED, &recovery) &&
> +                       !test_bit(MD_RECOVERY_CHECK, &recovery);
> +       int transitional =3D test_bit(MD_RECOVERY_RUNNING, &recovery) &&
> +                          !test_bit(MD_RECOVERY_SYNC, &recovery) &&
> +                          !test_bit(MD_RECOVERY_RECOVER, &recovery) &&
> +                          !test_bit(MD_RECOVERY_DONE, &recovery) &&
> +                          !test_bit(MD_RECOVERY_RESHAPE, &recovery);

Thanks Alex,
 however I don't understand why you want to test all of these bits.
Isn't it enough just to check ->recovery_cp ??

> +
> +       /* RAID6 requires 'rcw' in current implementation.
> +        * Otherwise, attempt to check whether resync is now happening
> +        * or should start.
> +         * If yes, then the array is dirty (after unclean shutdown or
> +         * initial creation), so parity in some stripes might be inconsi=
stent.
> +         * In this case, we need to always do reconstruct-write, to ensu=
re
> +         * that in case of drive failure or read-error correction, we
> +         * generate correct data from the parity.
> +         */
> +       if (conf->max_degraded =3D=3D 2 ||
> +           (recovery_cp < MaxSector && sh->sector >=3D recovery_cp &&
> +            (needed || resyncing || transitional))) {
> +               /* Calculate the real rcw later - for now fake it
>                  * look like rcw is cheaper

Also, we should probably fix this comment.  s/fake/make/

Thanks,
NeilBrown



>                  */
>                 rcw =3D 1; rmw =3D 2;
> +               pr_debug("force RCW max_degraded=3D%u, recovery_cp=3D%lu
> sh->sector=3D%lu recovery=3D0x%lx\n",
> +                        conf->max_degraded, recovery_cp, sh->sector, rec=
overy);
>         } else for (i =3D disks; i--; ) {
>                 /* would I have to read this buffer for read_modify_write=
 */
>                 struct r5dev *dev =3D &sh->dev[i];


--Sig_/DLs_JCceETklD5Xfk8oUz5a
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFlfNTnsnt1WYoG5AQIZFA/+J19aj8tvDXGlOTgzryv37HBWRtSXx3Dx
gX9kB2OwXd/hm8hLa2pVsd9RuBuu4bg1YDGHOJ6MS/Lia6euZC+Pr1vZcFye/duu
NQigWlfk1PC5HZmEKiKhQUFA6hk5SiGiC9EI7pjfDMKO0yjOPwKt9/1+7TZtPALv
lf5OQUkSzmH06nXofPEQ6Op2M/e2mPw4Z849StBa2l1cY/MBemGVWUQoUPzQ2ZQd
4i+qW3Xretj0VHoKdhs3bjIEZBSf7RXCGvWJ28RjnYp6bsXXGkUmrusSiVeGOzOr
fUow6N4Dg4nHjmC3seYI01QT5XG5AY52H8GtbDx6HGB9snbEWbA1ha74GXTXqAjR
0n3iJVjAsRTFxOIkogWtOQhPYiUhlyernccjcDb++nvqlQIeOHGfJ9bfROHt531c
rmIs3ytQ9A8V4eVcGXTRd5IBpFOHHdggwWCaPlep2hFBkrGx7A103zpAVYq5wT4k
nX8Ld5YABqyzZ4oTPOQw0CTKBFI9CLiHy/41SsTmrrOLGJQjyhlAcHKPIgVIEWCE
7W7mvOYU9HeWfN6b6T789l1vFAUnOMwajEtW7ySeI9uCEetw3ykFovJqvGvq/L0H
NHroLz6EMFhT+lz5DAZetofPw1M2SNckYjyrFx3/rc50t8N4NohdOz3AYU77bj8X
wnMXaAv7LfQ=
=l/SX
-----END PGP SIGNATURE-----

--Sig_/DLs_JCceETklD5Xfk8oUz5a--
