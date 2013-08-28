From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 5/6] in_initrd: fix gcc compiler error
Date: Wed, 28 Aug 2013 15:08:22 +1000
Message-ID: <20130828150822.1f8580bf@notabene.brown>
References: <1376677320-12816-1-git-send-email-mwilck@arcor.de>
	<1376677320-12816-6-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gXP/7.S2fM0VL4dFDtJTJw="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1376677320-12816-6-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/gXP/7.S2fM0VL4dFDtJTJw=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Aug 2013 20:21:59 +0200 mwilck@arcor.de wrote:

> On some systems, this code caused a "comparison between signed
> and unsigned" error.
>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> ---
>  util.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/util.c b/util.c
> index 8096e29..491a107 100644
> --- a/util.c
> +++ b/util.c
> @@ -1949,6 +1949,6 @@ int in_initrd(void)
>  	/* This is based on similar function in systemd. */
>  	struct statfs s;
>  	return  statfs("/", &s) >=3D 0 &&
> -		(s.f_type =3D=3D TMPFS_MAGIC ||
> -		 s.f_type =3D=3D RAMFS_MAGIC);
> +		((unsigned long)s.f_type =3D=3D TMPFS_MAGIC ||
> +		 (unsigned long)s.f_type =3D=3D RAMFS_MAGIC);
>  }

That is rather horrible.  It seems that some architectures like this field =
to
be signed and other unsigned.
But aren't TMPFS_MAGIC and  RAMFS_MAGIC simple constants and so signed by
default?
What are that defined to on the system that produces the error?

Maybe we need to cast both LHS and RHS to "unsigned long"....

NeilBrown

--Sig_/gXP/7.S2fM0VL4dFDtJTJw=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUh2Fxjnsnt1WYoG5AQJFiBAAsWzW9eG/nnU8oQwTnP48R54rYrGy/qUt
FtCfkaTIXeb5roSxo95bLMoIvt9NE0le2S+LfGyUy1eA2Grbot9ZBtmc325rwEy+
RoZBQ/mRhgFy9mElbHMpH6JWPnXBYHK1wVveHhogc5rwVhQaPXJjOHbeGPY43sC+
olV1qwvMvA/FU/B+axsKmSyAq9k90z/kymgmKxblbaaKnCVOtWgP1sxaQ6hVfL87
g7de3pRhv4yYqBRG2H1erKk8ryIj9pKWYoG+at6srW3O36oWaqUea0soYxxOBh0B
mCZROvx9zhwBQUUjAcRW4BpeyvnS+X0NE4GztBXPQkWAoPnVQQLPud09eG1P+ExB
dsHdkZoV42T5SVOkjnLf1ICd+Ax1GAzS9G5Iy7K7y9oPamd93bPrtWMb1cniYInb
gQ1bZW2eJxO+rfcaUfzaleSy/uxtEE6KFxmRXnUllI3SPu7dZ4gwR9oKAAxqNpu8
NqpGmez4iZt3MDmnhWaeHa0DfhajIToh+qidMF5p+YpZsUJD36wijIUt4URAB06t
MUb5K4d6nJyN0n1p17xd/ODu8q0UWNr2f/rH8Ko8/LB2y1p5Oibh6mevb6kF7lzs
OnJ40OkA+yRe77LgBoCZEKTKLV5qUBPPFNKbhKdXXjLvoUckZTTGtLbO+C9Tl5n+
00d1Kti4vkg=
=WFey
-----END PGP SIGNATURE-----

--Sig_/gXP/7.S2fM0VL4dFDtJTJw=--
