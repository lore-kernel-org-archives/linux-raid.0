From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid5: don't do chunk aligned read on degraded
 array.
Date: Thu, 19 Mar 2015 17:02:15 +1100
Message-ID: <20150319170215.7d6dfd60@notabene.brown>
References: <550A60FF.3050902@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/+iDSD/J5i/GJLrq71Fw/lEu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <550A60FF.3050902@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Mei <meijia@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/+iDSD/J5i/GJLrq71Fw/lEu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Mar 2015 23:39:11 -0600 Eric Mei <meijia@gmail.com> wrote:

> From: Eric Mei <eric.mei@seagate.com>
>=20
> When array is degraded, read data landed on failed drives will result in=
=20
> reading rest of data in a stripe. So a single sequential read would=20
> result in same data being read twice.
>=20
> This patch is to avoid chunk aligned read for degraded array. The=20
> downside is to involve stripe cache which means associated CPU overhead=20
> and extra memory copy.
>=20
> Signed-off-by: Eric Mei <eric.mei@seagate.com>
> ---
>   drivers/md/raid5.c |   15 ++++++++++++---
>   1 files changed, 12 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index cd2f96b..763c64a 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4180,8 +4180,12 @@ static int raid5_mergeable_bvec(struct mddev *mdde=
v,
>          unsigned int chunk_sectors =3D mddev->chunk_sectors;
>          unsigned int bio_sectors =3D bvm->bi_size >> 9;
>=20
> -       if ((bvm->bi_rw & 1) =3D=3D WRITE)
> -               return biovec->bv_len; /* always allow writes to be=20
> mergeable */
> +       /*
> +        * always allow writes to be mergeable, read as well if array
> +        * is degraded as we'll go through stripe cache anyway.
> +        */
> +       if ((bvm->bi_rw & 1) =3D=3D WRITE || mddev->degraded)
> +               return biovec->bv_len;
>=20
>          if (mddev->new_chunk_sectors < mddev->chunk_sectors)
>                  chunk_sectors =3D mddev->new_chunk_sectors;
> @@ -4656,7 +4660,12 @@ static void make_request(struct mddev *mddev,=20
> struct bio * bi)
>=20
>          md_write_start(mddev, bi);
>=20
> -       if (rw =3D=3D READ &&
> +       /*
> +        * If array is degraded, better not do chunk aligned read because
> +        * later we might have to read it again in order to reconstruct
> +        * data on failed drives.
> +        */
> +       if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
>               mddev->reshape_position =3D=3D MaxSector &&
>               chunk_aligned_read(mddev,bi))
>                  return;

Thanks for the patch.

However this sort of patch really needs to come with some concrete
performance numbers.  Preferably both sequential reads and random reads.

I agree that sequential reads are likely to be faster, but how much faster
are they?
I imagine that this might make random reads a little slower.   Does it?  By
how much?

Thanks,
NeilBrown

--Sig_/+iDSD/J5i/GJLrq71Fw/lEu
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVQpmaDnsnt1WYoG5AQKk5w//U4QEL75yRJKWdLoa9wBzsI5XoOKpSGeW
vFas29tlcPw+LoqzX8aauK/RLuNBlitlyEo8Rp2QeABCN6ClsIFEUmWulSZ9wAe1
uMYIw70v1MIwvL4oN8PRCsYScJ0j7uUbSKKHxIA2PMaOAfzzSIoru5TEuZVPNNn1
ZBVpIS2nUYEsQ4tlFShwPDBcIvY2T3AjOpuW5F1DimziFkyV/6mi/bJCUcKhxItD
pAUESMIKTeyEknvUZuJyWD9NzKcZgLww7Ts+3dezpKmj6gPUC3px9UAMJ4pUX+NO
OFD8bKL0P3XeSPWsNqafVigYUD9EAoaY+P4fBREtZXgl1g5rq44RxEZ3agXBQz+H
7/ejJcmwUEDXzL28IZ5E1S85bU3PoA85lpDJp3nsfPuxTh4pD16WC3w3ARBh4KBi
8sPvTZyoBDLDMnAS22AzXlaT4l67f18BXbJmackGfM1FYjnBjlfsOTEDBGrOiJp3
/4w3NV0ThLJZ+hy3Z1nuEqI7wZNvYSRTdDTXiJ/MabLboJ7XoVSL7BQqvh9sM/dc
pthCGXM1yoSgS53GG2jGsAVhjyDo5fmVT7hSB7fLaTFOjFdMe1UDrIOnJRDAIJYK
tWykvln2oFtaqMw3WVyg85QbeiselHXn5fGmIPZ9UmksMpR1DeOxCvqGz0hBPAAR
yiIeWFbIvco=
=U8Zl
-----END PGP SIGNATURE-----

--Sig_/+iDSD/J5i/GJLrq71Fw/lEu--
