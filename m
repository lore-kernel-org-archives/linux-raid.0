From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: raid10: remove VLAIS
Date: Fri, 06 Oct 2017 10:58:59 +1100
Message-ID: <87k209170c.fsf@notabene.neil.brown.name>
References: <20171005182847.3368-1-mka@chromium.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171005182847.3368-1-mka@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Michael Davidson <md@google.com>, Guenter Roeck <groeck@chromium.org>, Matthias Kaehlcke <mka@chromium.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 05 2017, Matthias Kaehlcke wrote:

> The raid10 driver can't be built with clang since it uses a variable
> length array in a structure (VLAIS):
>
> drivers/md/raid10.c:4583:17: error: fields must have a constant size:
>   'variable length array in structure' extension will never be supported
>
> Allocate the r10bio struct with kmalloc instead of using the VLAIS
> construct.
>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
>  drivers/md/raid10.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 374df5796649..9616163eaf8c 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4578,15 +4578,16 @@ static int handle_reshape_read_error(struct mddev=
 *mddev,
>  	/* Use sync reads to get the blocks from somewhere else */
>  	int sectors =3D r10_bio->sectors;
>  	struct r10conf *conf =3D mddev->private;
> -	struct {
> -		struct r10bio r10_bio;
> -		struct r10dev devs[conf->copies];
> -	} on_stack;
> -	struct r10bio *r10b =3D &on_stack.r10_bio;
> +	struct r10bio *r10b;
>  	int slot =3D 0;
>  	int idx =3D 0;
>  	struct page **pages;
>=20=20
> +	r10b =3D kmalloc(sizeof(*r10b) +
> +	       sizeof(struct r10dev) * conf->copies, GFP_KERNEL);

GFP_KERNEL isn't a good idea here.
This could wait for writeback, and if writeback tries to write to the
region of the array which is being reshaped, it might deadlock.

GFP_NOIO is safer.

given that conf->copies is almost always 2 it might be nicer to
have

	struct {
		struct r10bio r10_bio;
		struct r10dev devs[2];
	} on_stack;

        struct r10bio *r10b;

	if (conf->copies <=3D ARRAY_SIZE(on_stack.devs))
        	r10b =3D &on_stack.r10_bio;
        else
        	r10b =3D kmalloc(sizeof(*r10b) +
			       sizeof(struct r10dev) * conf->copies, GFP_NOIO);


Thanks,
NeilBrown


> +	if (!r10b)
> +		return -ENOMEM;
> +
>  	/* reshape IOs share pages from .devs[0].bio */
>  	pages =3D get_resync_pages(r10_bio->devs[0].bio)->pages;
>=20=20
> @@ -4635,11 +4636,13 @@ static int handle_reshape_read_error(struct mddev=
 *mddev,
>  			/* couldn't read this block, must give up */
>  			set_bit(MD_RECOVERY_INTR,
>  				&mddev->recovery);
> +			kfree(r10b);
>  			return -EIO;
>  		}
>  		sectors -=3D s;
>  		idx++;
>  	}
> +	kfree(r10b);
>  	return 0;
>  }
>=20=20
> --=20
> 2.14.2.920.gcf0c67979c-goog

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnWx0MACgkQOeye3VZi
gbnpUQ/+MZDAM47UJtmd2IYpUksyzWgzkhqx8cQCg5QssmsWBEluZL8aTFFYEw5p
5kRt+iKctRyp2Zygkfr8eP6kur2kSmDUiPBPNvejhNw9Why7PqLibmvfyaot15X0
mogDFC0Hp+XYlmLHxJarlHzbV+CkkrOdtf/SyNaTuMh2Q4V+g5tnUijv6ZOgIhb1
+AtCzypa7DZHycCUZY8Q3ZxnMjWPLQ00QPXj50M4jj0TmlM3iRPMJbyVpKGJLBDz
EPwEGuxER+OYXB3eNF4jLINT6zqm+72sTTJvRCCOrM7Xc/if37fYgyFRS/SqrJ0s
PHrViVashKpjL+CiGOy6rX2LvSvw6U3/H4dv9T40mcHagSpTBnMVT+ezgHgY72VN
6yUxnn+v1pvdynhk1egdMRZcWzofW6IaP0hTsqU4rcsneW7ywbE7x3kJSrcPGE22
Urya/ET80h0VbIIJnsvOwZl7Nt0Bx4r9nsiF/vnt+GhcA3PlzPgSOrwlTXX0+IXB
d5pIv0n9u4qNqHwPpn0atvpxKGdbA7qljFpgT+FzNMKNYAx52KOi7b9+VxMqjlM0
a23bQ4SmZ1p6aTkpAdinSAFxzD9oTSiapdhzDDlgvcbl25+E22tSQgUssF4Dn/3g
57TLxyUhw2/cnRZtWr1PnO2ZlROtpNgcOns9YmUkTNUNVzxt6PQ=
=BKjd
-----END PGP SIGNATURE-----
--=-=-=--
