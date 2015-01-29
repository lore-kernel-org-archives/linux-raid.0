From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] IMSM: Clear migration record on disks more often
Date: Thu, 29 Jan 2015 14:13:14 +1100
Message-ID: <20150129141314.3ffca025@notabene.brown>
References: <20150120125225.3110.88243.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Kd5hPyIgBqdGNLhVxnv19/Y"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150120125225.3110.88243.stgit@gklab-154-222.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

--Sig_/Kd5hPyIgBqdGNLhVxnv19/Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Jan 2015 13:52:25 +0100 Pawel Baldysiak
<pawel.baldysiak@intel.com> wrote:

> Migration record is not always cleared after successful migration. This c=
an
> block another reshape from being started. Migration will not be continued=
 via
> systemd service due to error in verifying reshape position. This patch ad=
ded
> clearing migration record when disk is added to container, and after succ=
essful
> migration.
>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  super-intel.c |   25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 4c53019..2406991 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5055,6 +5055,14 @@ static int add_to_super_imsm(struct supertype *st,=
 mdu_disk_info_t *dk,
>  	}
> =20
>  	get_dev_size(fd, NULL, &size);
> +	/* clear migr_rec when adding disk to container */
> +	memset(super->migr_rec_buf, 0, MIGR_REC_BUF_SIZE);
> +	if (lseek64(fd, size - 512, SEEK_SET) >=3D 0) {
> +		if (write(fd, super->migr_rec_buf,
> +			MIGR_REC_BUF_SIZE) !=3D MIGR_REC_BUF_SIZE)
> +			perror("Write migr_rec failed");
> +	}
> +
>  	size /=3D 512;
>  	serialcpy(dd->disk.serial, dd->serial);
>  	set_total_blocks(&dd->disk, size);
> @@ -10648,6 +10656,23 @@ static int imsm_manage_reshape(
> =20
>  	}
> =20
> +	/* clear migr_rec on disks after successful migration */
> +	struct dl *d;
> +
> +	memset(super->migr_rec_buf, 0, MIGR_REC_BUF_SIZE);
> +	for (d =3D super->disks; d; d =3D d->next) {
> +		if (d->index < 0 || is_failed(&d->disk))
> +			continue;
> +		unsigned long long dsize;
> +
> +		get_dev_size(d->fd, NULL, &dsize);
> +		if (lseek64(d->fd, dsize - 512, SEEK_SET) >=3D 0) {
> +			if (write(d->fd, super->migr_rec_buf,
> +				MIGR_REC_BUF_SIZE) !=3D MIGR_REC_BUF_SIZE)
> +				perror("Write migr_rec failed");
> +		}
> +	}
> +
>  	/* return '1' if done */
>  	ret_val =3D 1;
>  abort:


Thanks.
I replaced both "size - 512" with "size - MIGR_REC_POSITION" and applied
the patch.

NeilBrown

--Sig_/Kd5hPyIgBqdGNLhVxnv19/Y
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVMmlSjnsnt1WYoG5AQKy2w/+L13jIieb43iZ9+sNYub2BN1Cv1JJxYjZ
K+p3tqX7q1s6JzUJmbdwTuDrwrZ/NA6znV0iPelOIyYqFe+OcLkZMQlDhMckIAGy
emSK4rfjU7RhUH9HEI0+yySVV9Nhk2fxvjpf8SOw/HiCs3xWRVvMHeuswCutNvUj
Prixj9XMB0Dt5uD3mZF2KbzbSfMcXh6nNslFcOU8VX91MFFanx27S1hwrhKGgSoJ
g62BnKjyjSr3AyQZtXO2ede7LcWITDqoFaj5WwSz6LP+Ncxf4B59TBW6lZWKicuw
VWSHvofKbz/D0Gkinj5TmTHtMVa4CVPtmpfKgffmWt9PJnYH6+cp/kWwDUwaAVrI
M8JKYuFAdWsBXJUjPyfPGoO1ZLQ0D+jDvxgod8f2IJaFG7/mbXooJJh3/8RkRoST
aAYhOviENtTq7W0G+xIMGWEPfJUmCu8LxaRi3c3KmKfKeqYSZ9C/VqpdrpWgMJNz
EfI9tK1/OQ+qnA4xFyOSkdFm65ky7HYipp/jOHLcSWhJmet0YzvXHwIdg+6lg8gi
iDf+JpeQwuzMdK0onoB24X7/0sko8SAc8e5MezcdFvDHTkwSD1KxcCehzpLiohU0
2Rb9taNQkf9+Z4GjlKxHHkl5p8cbXEKxpwHogV/yvFa1aEUW52jo7V0Rwa8VpWkg
Wi1a1w5EMYI=
=sF7f
-----END PGP SIGNATURE-----

--Sig_/Kd5hPyIgBqdGNLhVxnv19/Y--
