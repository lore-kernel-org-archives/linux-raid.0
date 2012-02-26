From: NeilBrown <neilb@suse.de>
Subject: Re: md: Use existed macro instead of number
Date: Mon, 27 Feb 2012 09:57:55 +1100
Message-ID: <20120227095755.033c450a@notabene.brown>
References: <201202241500185468624@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mlyZ3TK.WB5HPg=_XhtCoT4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201202241500185468624@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: kedacomkernel <kedacomkernel@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/mlyZ3TK.WB5HPg=_XhtCoT4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Feb 2012 15:00:21 +0800 "kedacomkernel" <kedacomkernel@gmail.com>
wrote:

> >From d5905ed3c5355a13e954057856733f8ad64a86ac Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Fri, 24 Feb 2012 22:49:45 +0800
> Subject: [PATCH] md: Use existed macro instead of number
>=20
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  include/linux/raid/md_p.h |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/raid/md_p.h b/include/linux/raid/md_p.h
> index 6f6df86..7c3577c 100644
> --- a/include/linux/raid/md_p.h
> +++ b/include/linux/raid/md_p.h
> @@ -281,6 +281,8 @@ struct mdp_superblock_1 {
>  					    * active device with same 'role'.
>  					    * 'recovery_offset' is also set.
>  					    */
> -#define	MD_FEATURE_ALL			(1|2|4|8|16)
> -
> +#define	MD_FEATURE_ALL			(MD_FEATURE_BITMAP_OFFSET | MD_FEATURE_RECOVERY=
_OFFSET | \
> +					MD_FEATURE_RESHAPE_ACTIVE | MD_FEATURE_BAD_BLOCKS | \
> +					MD_FEATURE_REPLACEMENT)
> +
>  #endif=20

Applied, thanks.
Though I reformatted it a bit.

NeilBrown

commit 473a5bfef64c6c328bc110f28ba6c32fe4d4508a
Author: majianpeng <majianpeng@gmail.com>
Date:   Mon Feb 27 09:56:59 2012 +1100

    md: Use existed macros instead of numbers
   =20
    Signed-off-by: majianpeng <majianpeng@gmail.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/include/linux/raid/md_p.h b/include/linux/raid/md_p.h
index 6f6df86..8c0a3ad 100644
--- a/include/linux/raid/md_p.h
+++ b/include/linux/raid/md_p.h
@@ -281,6 +281,10 @@ struct mdp_superblock_1 {
 					    * active device with same 'role'.
 					    * 'recovery_offset' is also set.
 					    */
-#define	MD_FEATURE_ALL			(1|2|4|8|16)
+#define	MD_FEATURE_ALL			(MD_FEATURE_BITMAP_OFFSET	\
+					|MD_FEATURE_RECOVERY_OFFSET	\
+					|MD_FEATURE_RESHAPE_ACTIVE	\
+					|MD_FEATURE_BAD_BLOCKS		\
+					|MD_FEATURE_REPLACEMENT)
=20
 #endif=20

--Sig_/mlyZ3TK.WB5HPg=_XhtCoT4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0q48znsnt1WYoG5AQKUNg//UEQKizs9WxOStuzKC3/Tq5bhXM3kELxS
XZ2UXYus43Dz9YoIHQT6f3FAoZ4KzaSG4JJhpWFpNQ/5th3uO3hYAXiTc1CwEdE+
qy3HiLfxWVfz8H1cP6sOSF7eRUpDAR4HYhETgUGgc1z5ysyVkn/4QngX3dfpfSD2
D39X4iSdKr8gpOfV9JaBA0Zc8hm6AxiHDDh51OAAhBtO0y7xHBsjTnOrCl1utbeu
IAUCuXPxhN7FZissejeKS0g2Py6YIng2FM/CaSQVBtZcSuVPK+rCtxed6294sL2W
DxCkcRa5O9aHSQzymtK+dQqRy8Zq9rtlEpNKRCdIjKQ3OIWnyJg4P7pBVWJ5Gj8j
e0k4YP1b4hkd6NnCKLV0xrmvR/AhdlQvPp4BMKrpSDQ18fI8znpPo73LszfnGoGD
lrLdVeN+BEcI0E0lB9P/iYQPPdQEq5x0RSBXCvfx5kuEKYGUseYy0r2YMC+oCAv3
ac+VfkWkSR79zS/iFNhi/mCFzn+MtGOgYX5OybG0HorUMlEaaBu6Vtsf5aefoWps
YobQBZfQwg6OjhNqgnm80EVcSpNSyHYPiD+8nMkRBvkCr4a4J1KkitszdUGWZE1q
sjx+ICQNUkh/4Vvc6Cd16XUHy89U6vJLTowYsDSmXRpm4xZggbkGWZiJIqrILx+Q
PW7GcC8vyGA=
=1Vs9
-----END PGP SIGNATURE-----

--Sig_/mlyZ3TK.WB5HPg=_XhtCoT4--
