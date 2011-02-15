From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Samsung HD204UI (2TB F4EG) disk vs smart
Date: Wed, 16 Feb 2011 03:00:52 +0500
Message-ID: <20110216030052.5d9878cf@natsu>
References: <4D5AF2EB.3060809@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/e9ko9Zv98mRrKm1_Lg4lss5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5AF2EB.3060809@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/e9ko9Zv98mRrKm1_Lg4lss5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Feb 2011 08:40:59 +1100
Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:

> In the end the problem turned out to be the disks. It seems that these
> popular (cheap) disks have a firmware bug that causes bad writes if a
> specific smart command is issued at the right (wrong) time.
>=20
> There is a fw fix but I found it not widely advertised. It can be found
> here
>      http://www.samsung.com/global/business/hdd/faqView.do?b2b_bbs_msg_id=
=3D386
> Unfortunately it does *not* change the fw revision so you will not know
> if your disk has the patch applied or not. I just applied it and so far
> so good. My fw rev was (and still is) 1AQ10001.

You are right. Here is the most comprehensive documentation on this issue:
http://sourceforge.net/apps/trac/smartmontools/wiki/SamsungF4EGBadBlocks

--=20
With respect,
Roman

--Sig_/e9ko9Zv98mRrKm1_Lg4lss5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1a95QACgkQTLKSvz+PZwgxqACghGSJqJn2B+wTpvD3JpavkGFs
bDIAoI+JxuWdiWBR5YH5ou6osQWWTLmI
=HJdA
-----END PGP SIGNATURE-----

--Sig_/e9ko9Zv98mRrKm1_Lg4lss5--
