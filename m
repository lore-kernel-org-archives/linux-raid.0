From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH --resend 1/2] md: disable WRITE SAME if it fails for linear/raid0
Date: Tue, 14 Feb 2017 10:42:32 +1100
Message-ID: <8737fh4pzr.fsf@notabene.neil.brown.name>
References: <cover.1487015420.git.shli@fb.com> <c98a106b47626695f3b6976b616230da4b638df8.1487015420.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c98a106b47626695f3b6976b616230da4b638df8.1487015420.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 13 2017, Shaohua Li wrote:

> This makes md do the same thing as dm for write same IO failure. Please
> see 7eee4ae(dm: disable WRITE SAME if it fails) for details why we need
> this.
>
> Also reported here: https://bugzilla.kernel.org/show_bug.cgi?id=3D118581
>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/linear.c |  6 +++++-
>  drivers/md/md.c     | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/md/md.h     |  2 ++
>  drivers/md/raid0.c  |  6 +++++-
>  4 files changed, 57 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index 26a73b2..bebc834 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -291,7 +291,11 @@ static void linear_make_request(struct mddev *mddev,=
 struct bio *bio)
>  				trace_block_bio_remap(bdev_get_queue(split->bi_bdev),
>  						      split, disk_devt(mddev->gendisk),
>  						      bio_sector);
> -			generic_make_request(split);
> +			if (bio_op(split) =3D=3D REQ_OP_WRITE_SAME)
> +				generic_make_request(md_writesame_setup(mddev,
> +								split));
> +			else
> +				generic_make_request(split);
>  		}
>  	} while (split !=3D bio);
>  	return;
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 13020e5..7354f0b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -312,6 +312,51 @@ static blk_qc_t md_make_request(struct request_queue=
 *q, struct bio *bio)
>  	return BLK_QC_T_NONE;
>  }
>=20=20
> +struct md_writesame_data {
> +	struct bio *orig_bio;
> +	struct mddev *mddev;
> +	struct bio cloned_bio;
> +};
> +
> +static void md_writesame_endio(struct bio *bio)
> +{
> +	struct md_writesame_data *data =3D bio->bi_private;
> +
> +	if (bio->bi_error =3D=3D -EREMOTEIO &&
> +	    !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors)
> +		data->mddev->queue->limits.max_write_same_sectors =3D 0;

What would be *really* nice is if a block device could send a
reconfigure message to its 'holder' (bd_holder).  This could include
device size changes and, for this, changes to max_write_same_sectors.
There are probably other changes that can usefully be propagated.

But for this patch, wouldn't it be easier, and maybe more efficient, to
do

  if (bio_op(split) =3D=3D REQ_OP_WRITE_SAME &&
      !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors)
           mddev->queue->limits.max_write_same_sectors =3D 0;
  generic_make_request(split);

???
If there is some reason that can't work, then the patch as it stands
look OK to me.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAliiRGgACgkQOeye3VZi
gbmMcg/+PEMjUMepK88Mhau3iFOx/5hBHwfIl+H6P5tvxo+Cj0X7eQ9782MD2pH/
Xn40Zxr0Ki86AXxP9X6Y2dNKLJ2i7J5qkApAXlPvJSNlKPdUgRMjppzUNfAxl5fH
VsvcmrdgKto3xf4jEcTkOLukn0r4H5GBQmthTuhc9lxXr8asVw948OTV/CwqmkMZ
94GvTBGNUO0+sArGsF3ICPJ2DVO4J1RUg2SMSxeubbpuOVfKEEiwv+DOcTvWghDk
JPfYCbG+eZGG2l6PdH+pm/uhaGQDPhEMj6jv+PY93NsdjaFtCKyLPLEd/oBettK3
cOq6jPG6h3r2nhZIKGHq9TX9jp6EQvcQrN6TMUN4sqgn1qFI84ihfwRc/6fQFuc7
O4KScQaE4h0I2BGLyH+hHDL6zlDyIssCsE8/GxX/2ZKwBp7mfBfGRN4wUgZQiu5v
AHDJ87dmeraQ+gLUieZsRsjAgHtQ9n90ad1xEQIiR6Y1dq1n/WGPyYnPb1MiMCJj
a5ew4D4EH6SF0ey0tQ+IUDps4Bb8GQ2BdDXQpPUhiJcsoJyuQy9/IdDEQAhPw+I2
yQOLSp8fEyMElQD7ixKl31IKgKU9GUkW0KT+gH/hSnJXAnOFLNyo052V7GMn9C8p
1NhQkbYyxMQszsMahjdzrXiPPjy1HkVHUek+FFf8YQbbQzbxs4I=
=Lt0x
-----END PGP SIGNATURE-----
--=-=-=--
