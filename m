From: Paul Menzel <pm.debian@googlemail.com>
Subject: Re: [md PATCH 1/1] add display of hours remaining to finish resync
Date: Wed, 02 Nov 2011 00:35:10 +0100
Message-ID: <1320190510.27731.22.camel@mattotaupa>
References: <1320184427.6471.70.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-B/WnjF3iHT+yTVZOB3Ld"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320184427.6471.70.camel@oxygen.netxsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Adamski <k@adamski.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-B/WnjF3iHT+yTVZOB3Ld
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Krzysztof,


Am Dienstag, den 01.11.2011, 17:53 -0400 schrieb Krzysztof Adamski:
> This is my first patch, so please be gentle.

thank you for your patch. The line above does not belong to the commit
message. You can put that below the commit message after =C2=BB---=C2=AB or=
 on top
and separate the patch using =C2=BB--- 8< ----=C2=AB. (See `git help am` fo=
r more
information.

> This patch adds the display of the number of hours till the completion
> of resync of an array in the /proc/mdstat display.
>=20
> Example: [>....................]  resync =3D  3.3% (98633240/2928311808)
> finish=3D1026.1min (17h) speed=3D45957K/sec
>=20
> Signed-off-by: Krzysztof Adamski <k@adamski.org>
>=20
> # diff -Naru drivers/md/md.c-orig  drivers/md/md.c

It would be easier if you used `git commit` and for example

    git format-patch -1 -s

and then sent it using `git send-email` or your MUA (see below).

> --- drivers/md/md.c-orig        2011-10-25 01:11:12.000000000 -0400
> +++ drivers/md/md.c     2011-11-01 17:37:35.000000000 -0400
> @@ -6351,8 +6351,8 @@
>         rt *=3D dt;
>         rt >>=3D 5;
> =20
> -       seq_printf(seq, " finish=3D%lu.%lumin", (unsigned long)rt / 60,
> -                  ((unsigned long)rt % 60)/6);
> +       seq_printf(seq, " finish=3D%lu.%lumin (%luh)", (unsigned long)rt =
/
> 60,
> +                  ((unsigned long)rt % 60)/6, (unsigned long)rt / 60 /
> 60);

Unfortunately your mailer mangled the patch. You should choose pre
formatted, so automatic line breaks do not happen, which prevent the
application of the patch.

> =20
>         seq_printf(seq, " speed=3D%ldK/sec", db/2/dt);
>  }

Please resend this patch as v2.

    git format-patch --subject-prefix=3D"PATCH v2"

I am not sure if it should be a reply to the same thread or a new
message.

You can add the following line to the the commit message.

Reviewed-by: Paul Menzel <paulepanter@users.sourceforge.net>

(Different address on purpose.)


Thanks,

Paul

--=-B/WnjF3iHT+yTVZOB3Ld
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEUEABECAAYFAk6wgi4ACgkQPX1aK2wOHVgj6QCeKU0ruv0c93LZqBl5u3UVqwfH
3X4AliwiLbS42fK3JbF1ffrr2izahFQ=
=OE+2
-----END PGP SIGNATURE-----

--=-B/WnjF3iHT+yTVZOB3Ld--

