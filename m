From: NeilBrown <neilb@suse.de>
Subject: Re: Guess the size of a RAID{5,6} device
Date: Sat, 12 Apr 2014 09:50:49 +1000
Message-ID: <20140412095049.6cce32a6@notabene.brown>
References: <5347A58B.2060308@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//P2NWBXq/mS_9uKwh+EJgs_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5347A58B.2060308@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_//P2NWBXq/mS_9uKwh+EJgs_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Apr 2014 10:19:23 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> Hello,
>=20
> I'd like to know if it's possible to get the size of a RAID{5,6} which
> is not created yet but the size of the partitions which will make up the
> array are.

How precise does the "guess" need to be?

If you subtract about 128Meg from the size of the partitions, round down the
a multiple of the chunk size then multiply by the number of data disks, you
should come quite close.

If you want an exact number, then you really need to create the array.

NeilBrown


>=20
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_//P2NWBXq/mS_9uKwh+EJgs_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU0h/2Tnsnt1WYoG5AQJ+6BAAr3J99V4ZonyfvP7C5GyU5dxrcw2Gwqc8
sgxOMYfCroS5Uw2hMYOuADnMENzwrTF3CpqhPsABVgHTprtH39LbWkSE+hS3+soc
UC64Z5Ug527nBT5B4BQSiPJ4IWTWdPcZp+lk8LMcHeQZADBZ9Ig0dPKFkA6ewhy8
V6Tb2MiJRstL3rk8sNQB9Z4WC/iiTgH4qlAN5b3FlwCj72plK+Tf/E8zLAGM+h98
Z1Qs7QJJePqiuFa9yZAIInlR2QUnam0zw2NBdZS5L8EzBJNGGsqo2nphn2b08xOy
ScZDa3alQaR3JvL2NhbVV2DOt2GlvGHcJNfwMC7So1dxwck2/ey5DaqITWTnlxtm
mWuMPCnMqRqm0SjGhNOZjwG9cxtIiDnqdu9IsE8JYxU17NXwXiDJlehyBXwy+/kL
LUJUv0nusnuq6ClBrx9G68pIZ63Z5ARPjEP1y4/1wLcZRBF0ED7mJsk5WviXxBwO
AOs4GkzqkzItdr0BMQwLBxICEtSMkcdql2veqjkPA+p/hka6jyyOy7bE9D1cISSP
Kz4s3bu+R1dXCMKnLaE65yBvEpjUQINFB8xfjsLPvdOwy+emLcOzZ2+3EKLd5ph8
0+BUfHJXeRe+Mv6iuUyOVBFi4N0aSm4uDmpr14dNzpfRNBvoY5j28bmaj8gYpUg9
v29pT1B21rg=
=DNIS
-----END PGP SIGNATURE-----

--Sig_//P2NWBXq/mS_9uKwh+EJgs_--
