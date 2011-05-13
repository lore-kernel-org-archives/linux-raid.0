From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: mdadm does not create partition devices whatsoever,
 "partitionable" functionality broken
Date: Sat, 14 May 2011 01:32:21 +0600
Message-ID: <20110514013221.552dc8ef@natsu>
References: <4DCD4A83.8060202@pulseforce.com>
	<4DCD6119.3080705@turmel.org>
	<4DCD67EF.1070602@pulseforce.com>
	<4DCD6B27.70402@pulseforce.com>
	<20110513234055.4307c536@natsu>
	<4DCD72AF.1070809@pulseforce.com>
	<4DCD75FE.8010703@turmel.org>
	<4DCD7E78.6050000@pulseforce.com>
	<4DCD84E1.3040704@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GnPeh53ewwrAIeme=xwjy9V"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DCD84E1.3040704@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Christopher White <linux@pulseforce.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/GnPeh53ewwrAIeme=xwjy9V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 May 2011 15:22:09 -0400
Phil Turmel <philip@turmel.org> wrote:

> I always use LVM.  While the lack of attention to MD partitions might
> justify that, the real reason is the sheer convenience of creating,
> manipulating, and deleting logical volumes on the fly.  While you may not
> need it *now*, when you discover that you *do* need it, you won't be able=
 to
> use it.  Online resizing of any of your LVs is the killer feature.

Can it defragment non-contiguous LVs yet?

--=20
With respect,
Roman

--Sig_/GnPeh53ewwrAIeme=xwjy9V
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3Nh0UACgkQTLKSvz+PZwjgCQCeJM5WNSud6L20pYLOtDvkDrnz
Bt4An1PrKA44LRm9kjpReGOh1ukA443r
=Kdj5
-----END PGP SIGNATURE-----

--Sig_/GnPeh53ewwrAIeme=xwjy9V--
