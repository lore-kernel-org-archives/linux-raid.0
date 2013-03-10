From: Paul Menzel <pm.debian@googlemail.com>
Subject: Re: [PATCH] mdadm.8.in: Fix typo: previous -> previously
Date: Sun, 10 Mar 2013 10:31:19 +0100
Message-ID: <1362907879.11500.13.camel@mattotaupa>
References: <1362839664-361-1-git-send-email-themineo@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-93u/KwfGg5MdMHIgTgYw"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1362839664-361-1-git-send-email-themineo@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wieland Hoffmann <themineo@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-93u/KwfGg5MdMHIgTgYw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Samstag, den 09.03.2013, 15:34 +0100 schrieb Wieland Hoffmann:
> Signed-off-by: Wieland Hoffmann <themineo@gmail.com>
> ---
>  mdadm.8.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 1c06533..f7aa6aa 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -1224,7 +1224,7 @@ with redundancy.  They don't apply to RAID0 or Line=
ar.
> =20
>  .TP
>  .BR \-\-re\-add
> -re\-add a device that was previous removed from an array.
> +re\-add a device that was previously removed from an array.
>  If the metadata on the device reports that it is a member of the
>  array, and the slot that it used is still vacant, then the device will
>  be added back to the array in the same position.  This will normally

Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>


Thanks,

Paul

--=-93u/KwfGg5MdMHIgTgYw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlE8UucACgkQPX1aK2wOHVjl+QCfRAPZZgXBgMEf965r++noUmc2
Hn4AnA7HFI9s3uaQkP7jTBcH6LzTVVnp
=PSrU
-----END PGP SIGNATURE-----

--=-93u/KwfGg5MdMHIgTgYw--

