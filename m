From: Paul Menzel <paulepanter@users.sourceforge.net>
Subject: Re: [PATCH] raid5:Only move IO_THRESHOLD stripes from delay_list to
 hold_list in raid5_activate_delayed().
Date: Fri, 06 Jul 2012 14:56:43 +0200
Message-ID: <1341579403.5595.5.camel@mattotaupa>
References: <201207062038188750110@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-njj++0Q9eQOlbCFZRnXN"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201207062038188750110@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-njj++0Q9eQOlbCFZRnXN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Ma Jian,


thanks for the patch.


Am Freitag, den 06.07.2012, 20:38 +0800 schrieb majianpeng:
> To imporve write performance and as posssible as to achieve full-write,

s,imporve,improve,
s,posssible,possible,

The second part of the sentence is not clear to me.

Maybe: =E2=80=A6 and to achieve full-write if possible.

> it only fetch IO_THRESHOLD stripes from delay_list to hold_list.

Can you proof the speed up with some benchmarks? That would be awesome.

> Signed-off-by: majianpeng <majianpeng@gmail.com>

Last not least, could you write your first and last names separated by a
space? (I do not know if I separated them correctly.)

Ma Jian Peng (=E9=A9=AC=E5=BB=BA=E6=9C=8B) <majianpeng@gmail.com>

    $ git config user.name "Ma Jian Peng (=E9=A9=AC=E5=BB=BA=E6=9C=8B)"

Maybe even pass `--global` to it.

> ---
>  drivers/md/raid5.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 04348d7..45308c5 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3662,6 +3662,7 @@ finish:
> =20
>  static void raid5_activate_delayed(struct r5conf *conf)
>  {
> +	int count =3D 0;
>  	if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD) {
>  		while (!list_empty(&conf->delayed_list)) {
>  			struct list_head *l =3D conf->delayed_list.next;
> @@ -3672,6 +3673,8 @@ static void raid5_activate_delayed(struct r5conf *c=
onf)
>  			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>  				atomic_inc(&conf->preread_active_stripes);
>  			list_add_tail(&sh->lru, &conf->hold_list);
> +			if (count++ >=3D IO_THRESHOLD)
> +				break;
>  		}
>  	}
>  }


Thanks,

Paul

--=-njj++0Q9eQOlbCFZRnXN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAk/24IwACgkQPX1aK2wOHViP+gCghucQM7Eu/oBiYW/10GhodCJR
eHYAniqNIwi6WOflj7G9pUdlySbFqZ9s
=NyKi
-----END PGP SIGNATURE-----

--=-njj++0Q9eQOlbCFZRnXN--

