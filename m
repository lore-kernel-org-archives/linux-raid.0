From: NeilBrown <neilb@suse.de>
Subject: Re: [md:for-linus 7/8] drivers/md/md.c:5297:6: sparse: symbol
 '__md_stop' was not declared. Should it be static?
Date: Tue, 20 Nov 2012 19:46:14 +1100
Message-ID: <20121120194614.3bb75ef0@notabene.brown>
References: <50ab3e71.l5WJWEVMFL2rb1jK%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KQL/R/6YXwHmfD3+35w9ViF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50ab3e71.l5WJWEVMFL2rb1jK%fengguang.wu@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/KQL/R/6YXwHmfD3+35w9ViF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Nov 2012 16:25:21 +0800 kbuild test robot <fengguang.wu@intel.co=
m>
wrote:

> tree:   git://neil.brown.name/md for-linus
> head:   879d63a5d4cc36ff804a9cf0de2c092dd538fa45
> commit: fceef26b94e8507f33e28741f755c010de052042 [7/8] md: make sure ever=
ything is freed when dm-raid stops an array.
>=20
>=20
> sparse warnings:
>=20
> drivers/md/md.c:1553:34: sparse: cast to restricted __le64
> drivers/md/md.c:1823:40: sparse: incorrect type in assignment (different =
base types)
> drivers/md/md.c:1823:40:    expected unsigned long long [unsigned] [long]=
 [long long] [usertype] <noident>
> drivers/md/md.c:1823:40:    got restricted __le64 [usertype] <noident>
> drivers/md/md.c:1898:26: sparse: incorrect type in assignment (different =
base types)
> drivers/md/md.c:1898:26:    expected restricted __le64 [usertype] super_o=
ffset
> drivers/md/md.c:1898:26:    got unsigned long long [unsigned] [usertype] =
sb_start
> + drivers/md/md.c:5297:6: sparse: symbol '__md_stop' was not declared. Sh=
ould it be static?
>=20
> Please consider folding the attached diff :-)

Wow!  What wonderful service.

Attached diff has been folded in.

Thanks,
NeilBrown

--Sig_/KQL/R/6YXwHmfD3+35w9ViF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKtDVznsnt1WYoG5AQLH9g//SRqTMcvYXenPZ7WQxnrjAF2X4e0ZuRDV
FYopjXfu/n+hs4eGZGgNXIGtl1ilkyLj3Vqhk6searh/9Si6zD/psnb1C5yJYlHL
u8LXcTXBa9YhY3OU0RG/c5ZSssD5JcOq8Vf11RPhRG76DuYJrPp0qRCJV4M3XXQm
IUu/Oo6vaw/0LxTpCxV5UTCmhxIf/B51mxlS3qVl1XWolLy9eh0vXox0cfBZU8iz
Kjt+cJftIcyhXmyrMiPXsmNJB7W69ITNyddmUSwKieYwR7OF4KXw1vSpBa0Kw93Z
6AO/LXpV7g2Q1dpxgat51luszRwAzbeH4qvw6ZVBhYK74Cn8DZ2bim4/3p6PXFC7
WLpy0m0Nenge33hVY9vYVS7iE7kxFwFuqdnUGmr9BtLaoh3pXtdPrhx2tvxVlZbF
OoH2fepmnDGwZJhGspCW5BH/VV8edYCtaTzH0UsVBbWrSbHb5bFhle+9qr/2y/DK
sBPAxWxMt6NWDXVkMM9vpb85EofFPaLddQlvyz+8FTFzoA4W0HN0AiU7Zwi7UbvF
YLADpZn//pXC6TKjKla970dTs45Oz4aq59anYOiJSrNFYo7sG9kDL4HElcW3d8Tk
70WUinwY6IQVBrrqSCcdC/Ex0if1Ft0U+jx39GxKPDIfTK6Rh8OGOT0/b+frAmMS
pY/yLf0/Cjc=
=e7dd
-----END PGP SIGNATURE-----

--Sig_/KQL/R/6YXwHmfD3+35w9ViF--
