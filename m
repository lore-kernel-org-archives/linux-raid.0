From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: fix md io stats accounting broken
Date: Wed, 8 Apr 2015 13:11:55 +1000
Message-ID: <20150408131155.7e3aa2d3@notabene.brown>
References: <1428021887-18128-1-git-send-email-guz.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/IxnlsHGz5MRbWm=8u5rW_kQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1428021887-18128-1-git-send-email-guz.fnst@cn.fujitsu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: sim@hostway.ca, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/IxnlsHGz5MRbWm=8u5rW_kQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 3 Apr 2015 08:44:47 +0800 Gu Zheng <guz.fnst@cn.fujitsu.com> wrote:

> Simon reported the md io stats accounting issue:
> "
> I'm seeing "iostat -x -k 1" print this after a RAID1 rebuild on 4.0-rc5.
> It's not abnormal other than it's 3-disk, with one being SSD (sdc) and
> the other two being write-mostly:
>=20
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-s=
z avgqu-sz   await r_await w_await  svctm  %util
> sda               0.00     0.00    0.00    0.00     0.00     0.00     0.0=
0     0.00    0.00    0.00    0.00   0.00   0.00
> sdb               0.00     0.00    0.00    0.00     0.00     0.00     0.0=
0     0.00    0.00    0.00    0.00   0.00   0.00
> sdc               0.00     0.00    0.00    0.00     0.00     0.00     0.0=
0     0.00    0.00    0.00    0.00   0.00   0.00
> md0               0.00     0.00    0.00    0.00     0.00     0.00     0.0=
0   345.00    0.00    0.00    0.00   0.00 100.00
> md2               0.00     0.00    0.00    0.00     0.00     0.00     0.0=
0 58779.00    0.00    0.00    0.00   0.00 100.00
> md1               0.00     0.00    0.00    0.00     0.00     0.00     0.0=
0    12.00    0.00    0.00    0.00   0.00 100.00
> "
> The cause is commit "18c0b223cf9901727ef3b02da6711ac930b4e5d4" uses the
> generic_start_io_acct to account the disk stats rather than the open code,
> but it also introduced the increase to .in_flight[rw] which is needless to
> md. So we re-use the open code here to fix it.
>=20
> Reported-by: Simon Kirby <sim@hostway.ca>
> Cc: <stable@vger.kernel.org> 3.19
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  drivers/md/md.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 717daad..e617878 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -249,6 +249,7 @@ static void md_make_request(struct request_queue *q, =
struct bio *bio)
>  	const int rw =3D bio_data_dir(bio);
>  	struct mddev *mddev =3D q->queuedata;
>  	unsigned int sectors;
> +	int cpu;
> =20
>  	if (mddev =3D=3D NULL || mddev->pers =3D=3D NULL
>  	    || !mddev->ready) {
> @@ -284,7 +285,10 @@ static void md_make_request(struct request_queue *q,=
 struct bio *bio)
>  	sectors =3D bio_sectors(bio);
>  	mddev->pers->make_request(mddev, bio);
> =20
> -	generic_start_io_acct(rw, sectors, &mddev->gendisk->part0);
> +	cpu =3D part_stat_lock();
> +	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
> +	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw], sectors);
> +	part_stat_unlock();
> =20
>  	if (atomic_dec_and_test(&mddev->active_io) && mddev->suspended)
>  		wake_up(&mddev->sb_wait);


Applied, thanks.
Will push to Linus in a day or 2.

NeilBrown

--Sig_/IxnlsHGz5MRbWm=8u5rW_kQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSSceznsnt1WYoG5AQIyYBAAkb13zFNumwcpIKdKxMRb5rGZyP1OXYyo
rJvI/jTWlsOuoH3gNMM4ZtW/ABpIrmyqk1Tf3476rVIcMAUz0rqs6o88fYhCWw/i
UrNc7543rD25ed4rZaQjNLrONvX/tiNmq9ZpIoqhxtYXGuu+BIUnO8NCm4HqcmEa
dGlHPsHkQU97OkUAclwW9VHUNcC5UpddEMtdnieGEwR/42RBmhFp5P47eA4Ej2t8
wz2D/NmlToKvjm8cwJe/DwuK3twdgSq6UqXPvGqVGYTYHAiw1JEG6d3Kgd6wCBrm
iqKlmEdYEiLAKSt8XVfUxq3NydE7Rd31XtdLwfpe5AYnBegHjQnVtTfT8u+ENLm3
fv/McFWJDWtx4ZgdrSo3BfHN4JSpxpBWIG0P/Ag+aM5Bb0UGIWEIpIu8Ajcglvbv
1mY6rA3MOTFsO6J4v5GLBl0Ah1UU7rmjBkbFwqzbK5cU2ntjbm+hIxVyC3GkV43C
fcc8EhFgD7JlxuGxSaEHDC68EnXbYb4zYcmRrmFPKQEkG4zuVumPHtIcZTrYQ5Jh
sX0w1PT/+l9NxcoKp3drO9yjhUX0sZ4/xbr0quSpigqKLddDFpLZaRShVrZliGgs
zG/CUJPnZ+TKgt348CDcgX/JYqXFeELDyRaiULY6DG0qj5Zg9TiPMEKLqkryigCr
mBOU6GC4Trs=
=WrvG
-----END PGP SIGNATURE-----

--Sig_/IxnlsHGz5MRbWm=8u5rW_kQ--
