From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/6] raid6check fixes
Date: Wed, 19 Jun 2013 10:08:03 +1000
Message-ID: <20130619100803.03fde6d5@notabene.brown>
References: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BBx.kU9FfxbfEjBzr04xT/h"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: piergiorgio.sartor@nexgo.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/BBx.kU9FfxbfEjBzr04xT/h
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Jun 2013 11:09:10 +0200 Bernd Schubert
<bernd.schubert@itwm.fraunhofer.de> wrote:

> Here are a few raid6check fixes. This series also includes a patch for
> Makefile to allow to build with optimizations. I only fixed raid6check
> to build with -O3, but I don't have time left today to fix mdadm=20
> (e.g. Grow.c:2237:41: error: =E2=80=98info2.data_offset=E2=80=99 may be u=
sed uninitialized in this function [-Werror=3Duninitialized])
>=20

Thanks for mentioning that.  I've fix that problem.

NeilBrown


> I wanted to send the memleak-fixes much earlier, but then
> I had been too busy. This patch is lightly tested, patches
> from today are only build-tested.


--Sig_/BBx.kU9FfxbfEjBzr04xT/h
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUcD2Yznsnt1WYoG5AQLb2w//Qag5lE/R62sxclz6SAMT68WArPJNITGf
cUEVILHwcPKRF300+XEJsRJZ6IpclUxz4sBw2FUKChK5SVPyAZbvkf8+z7asKJ6n
ersGuESHRmjvya+QNUFP1zgJZYEhZT6t5ekfV26U44sqkT/rupH/NrdxkMuAW3nn
HRs2XrVXb3Ilu8lITxFOlCDVPEaGR7GFhVcaCo1wOssMbhLTMfc5Ry8afxWub+EG
crcAsJ50Hzs1DtlZE0DRHYseHNtKc8VvDdWYnIzP1zqb5oEYFv2dYIbnC7ironyT
CdjVFs/gKwXUUHeyJ3tLBFkyJ9OE58qF0x2+r6lrJBaswlW8H6HT6UCXxZ9Ayg1v
QbIeGrHD40tnYXG3FZpfvnL3M0uNfl6VqncH4kfaxUNE1OZKT2owWM8jQzWpCYxp
cF7AjmQNlo25LBKkWNH2I3SJpXdxFGfQddgjX0upP70KnE3W25xs9El409LShtQ6
KqfVYn/N+DwH/eQzVz/ZIniV2FapURLwUWjfkq54vfVjUdUI6BlyHlKlAhxIx4og
PRlBN1Zk03B1zRZc/oRCyXyIw0uetgzfFNMwubtHN4clHjtKplGLq5e4wHpqJYDK
WEQypLwpsF2WXUd5J59BrWjJ2cPKQuCrfTJzp4oXCx+3gQYDEB90+CMrQSEuV1vi
Gt5Y33doz/I=
=xNOM
-----END PGP SIGNATURE-----

--Sig_/BBx.kU9FfxbfEjBzr04xT/h--
