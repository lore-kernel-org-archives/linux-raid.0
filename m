From: NeilBrown <nfbrown@novell.com>
Subject: Re: [PATCH 1/2] allow md_flush_request to take NULL bio
Date: Thu, 11 Feb 2016 14:46:44 +1100
Message-ID: <87egcjx61n.fsf@notabene.neil.brown.name>
References: <1455151995-240805-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1455151995-240805-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dan.j.williams@intel.com, shli@fb.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 11 2016, Song Liu wrote:

> Signed-off-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/md.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e55e6cf..2997104 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -406,6 +406,8 @@ static void md_submit_flush_data(struct work_struct *=
ws)
>  	struct mddev *mddev =3D container_of(ws, struct mddev, flush_work);
>  	struct bio *bio =3D mddev->flush_bio;
>=20=20
> +	if (!bio)
> +		goto out;
>  	if (bio->bi_iter.bi_size =3D=3D 0)
>  		/* an empty barrier - all done */
>  		bio_endio(bio);
> @@ -415,6 +417,7 @@ static void md_submit_flush_data(struct work_struct *=
ws)
>  	}
>=20=20
>  	mddev->flush_bio =3D NULL;
> +out:
>  	wake_up(&mddev->sb_wait);
>  }
>=20=20

I don't think this is safe.
=2D>flush_bio is used for two different purposes.
One is to carry the bio so it can be passed to ->make_request after the
flush.
The other is to ensure exclusive access to mddev->flush_work.
The first thing md_flush_request() does is wait for ->flush_bio to be
NULL.  Then it knows that ->flush_work is no longer in use.
With your change you could get md_flush_request trying to INIT_WORK
=2D>flush_work while it is already queued.

Not good.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWvAQkAAoJEDnsnt1WYoG5EloP/2HjUroHGUPQP/rO12RA6lpE
BME1dX1XNVN6mBPcocTZpsv+tDxFf2MnVp5SI2wA9+C4zT+5OVtuYLt1+mDuIANU
YASXg7kcE9k21SvC1YWmueTnInCC5xSvAU24MeL+YNWMC4nHU/ybsfudb0KUXFqQ
6JDnZ+7mlQbhghV+K2y+7d23aCA0RArkV+Nd6sPnZgCBRwSoAB8MASoqVqKoxEBS
0x9ec4Cz/s3AumrjK40gC/CBOyfZ/+KDML6fhzxlWoLbb5djV2+HGlpsP+T2xtnL
wfOpAHhhs7X8xzl3VMNu/ykWnvmJU5CX0jBG+UAQijEkMpfMjW5DvCXQ30HbqNTq
HgPQwoXM+2mh3MaO81nEg1A/uLMS3Sy45+ejNVmSqtF1ss/NbR2ezx97z0OZosSL
TNTXIWnzIfDoFkEaPbaus1jNC6dxnkJqlPoZ/D/w0YCrKGlL8V9NsF68sR7t2X1x
XKSv3p1FdvnNYBPVQ32CX2A2Pmj+oyBU9/Za45YVk2xXLX9uLaApVe2uVfE1/t8E
6RG5K0VADJE0LVaQVo3oAK7aXOwJO+oLSlZDjtsH0to0YHMVEKWt6013WdjVvEFn
+pmtEP9uOBpJtuDCQ9kMleg87O7+LCwV4rqZ2iz1l+ZFlOPnPUUTXrSU+WpJmLBJ
hDH27dYrB0//PSt9mD3D
=ebPA
-----END PGP SIGNATURE-----
--=-=-=--
