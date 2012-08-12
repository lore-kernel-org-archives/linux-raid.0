From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] mdassemble: split dietlibc logic into dedicated
 target
Date: Mon, 13 Aug 2012 08:13:22 +1000
Message-ID: <20120813081322.260c158d@notabene.brown>
References: <1344799457-2478-1-git-send-email-vapier@gentoo.org>
	<1344799457-2478-2-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zqQbFFbPiAj1EzmMQQ89=_g"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1344799457-2478-2-git-send-email-vapier@gentoo.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/zqQbFFbPiAj1EzmMQQ89=_g
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 12 Aug 2012 15:24:16 -0400 Mike Frysinger <vapier@gentoo.org> wrote:

> This lets people run `make mdassemble` and get a sane build by default.
>=20
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  .gitignore |    1 +
>  Makefile   |    3 +++
>  2 files changed, 4 insertions(+)
>=20
> diff --git a/.gitignore b/.gitignore
> index 7200741..fcbe069 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -4,6 +4,7 @@
>  /mdadm
>  /mdadm.8
>  /mdadm.udeb
> +/mdassemble
>  /mdmon
>  /swap_super
>  /test_stripe
> diff --git a/Makefile b/Makefile
> index 704b374..72f609e 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -180,6 +180,9 @@ raid6check : raid6check.o mdadm.h $(CHECK_OBJS)
>  	$(CC) $(CXFLAGS) $(LDFLAGS) -o raid6check raid6check.o $(CHECK_OBJS)
> =20
>  mdassemble : $(ASSEMBLE_SRCS) $(INCL)
> +	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(ASSEMBLE_FLAGS) -o mdassemble =
$(ASSEMBLE_SRCS)  $(STATICSRC)
> +
> +mdassemble.diet : $(ASSEMBLE_SRCS) $(INCL)
>  	rm -f $(OBJS)
>  	$(DIET_GCC) $(ASSEMBLE_FLAGS) -o mdassemble $(ASSEMBLE_SRCS)  $(STATICS=
RC)
> =20


Applied, thanks.
NeilBrown

--Sig_/zqQbFFbPiAj1EzmMQQ89=_g
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCgqgjnsnt1WYoG5AQKqSA/9EYfULmGjYh6DkV/0iTzybbDWZakCTAfV
EzGM8apimeqTlCR9j5fSZiWcHdnvuBn2EZSG3XI3cQYewjovWYwwheO3qrIoevX8
o/LBMB1PgVA16m3sk8d6tjZRJlx5JiRAqhcEuZyC5nnZ4EkJP/+Q928PZm69EnS2
NPq64SeFDx8JXaqL642LhD8daZxWenXe0yfhVfqCyKW2qevMGqivNPNIG/aiBmsf
zbDs/M5pkix6SO8q3FxU+8QcA69YZEbc565fLRLosBsUirNO3RzPtr58HR3vEqjE
vPxjOgvLxHr/+U78MsOT1ZZUWb28WC6aXgD58/xfgmbDWI26Kc5Cf7iLGBKUZi8R
tAMh9NTqjzsYAWgfAMHOXS+v6ro3uU9Vkd6tZkFVNHB1AvKNj8S3KowZ6grUkpK8
GsZWh7uRFolqdQbFTYuWoBtNMCN1xheyWOBzg/WQyZwVF3v+XhVK6LTLbDjFJhRY
zk3yCfOhtCJXJ+yfwkutlUTabV4+tLKT01NQNBGwC11Smn/DiRztUNCcnwfH4AvD
65vOdadRsdUpJ5plDx/28+Zrl7NJhmuI5I2Qrwi55TwY7KXhKjiJWlWTcqx1nVqn
UnEokjU0mg/IC05rm9tPwwb5jjcc+tLWIWtO1AWmzongBzh3TYTO0XKLGNJSprDC
afTqMCaT2+E=
=5Kqj
-----END PGP SIGNATURE-----

--Sig_/zqQbFFbPiAj1EzmMQQ89=_g--
