From: NeilBrown <neilb@suse.de>
Subject: Re: invalid bitmap file superblock: bad magic
Date: Fri, 9 Mar 2012 08:04:33 +1100
Message-ID: <20120309080433.64963aac@notabene.brown>
References: <201203081711.17836.a.miskiewicz@gmail.com>
	<20120309070041.558a4ca6@notabene.brown>
	<201203082124.21661.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kL4R3FBlstFu_OeErr5/+qz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203082124.21661.a.miskiewicz@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arkadiusz =?UTF-8?B?TWnFm2tpZXdpY3o=?= <a.miskiewicz@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kL4R3FBlstFu_OeErr5/+qz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Mar 2012 21:24:21 +0100 Arkadiusz Mi=C5=9Bkiewicz
<a.miskiewicz@gmail.com> wrote:

> On Thursday 08 of March 2012, NeilBrown wrote:
> > On Thu, 8 Mar 2012 17:11:17 +0100 Arkadiusz Mi=C5=9Bkiewicz
> >=20
> > <a.miskiewicz@gmail.com> wrote:
> > > Hello.
> > >=20
> > > I'm trying to create internal bitmap on freshly created
> > > raid1 array on 3.2.6 kernel.
> > >=20
> > > What's going on and how to fix this problem?
> >=20
> > There is a bug in the latest mdadm which causes this.
> > It is fixed in git,=20
>=20
> Which commit is that?
>=20

This commit fixes it.

http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3D6ef89052d85b8137b8a=
7100f761d896ae6f61001

NeilBrown

--Sig_/kL4R3FBlstFu_OeErr5/+qz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT1ke4Tnsnt1WYoG5AQKniRAApaTVmFJKythoH9la3Ffnb8y8Nf+d+YeU
BTthbl8EDeVuA7IYONU7OcwzI3U5JSBACrUEgN+RIsGAGe9k9XLv1OmJHvG6CXDY
6c1H4ouRh+AyMfSilJ5j7hnUYiWX758/QPn8MwE+fMBpeY+tOKWTKsmhCnuNvu24
HnAckMIjGWgDURgxJVzei+arc3XtqSUqfKl+U/zHEaGb/lu9K1cl6MBBPCuOMpAG
kEy2FwfWdKS+cfYhhqAqashNhbsh8nfy6ZDqNOUBjhMZxCTYfBiU/avJr0ZaP/xP
eLt7Rm6Q7z2mm9kjKDQ3HlJE8lrLHkpupk+TNhxJW0SL5K0hzAsFxv21RF5jvL8v
NRXT5bi4mOVvkZasIef0+1arw/wz/LOaRbfnJyuw9Eu7yNhueZglDNMp06G69r7f
f1y1+xLj4dCIUgBq/NIe6xPXkAOFfZV5U/9+mP/EYRcY80KxsQ/Gi0+46P+XSk/L
Zs0btIV18qe83zr8hvUtGgiwbW2AV5AZhY6DMJSfSnug6sR/xfwnXo+3c/DbyYRR
JiPS7wObn3AmH0cTiEEOKSbQHyh1Yrvrfs3ZgzSFycNmqzfXNhPcwp1yvIXO3apR
GSrug0w6JHCVJDk2ox8k8talzbOorBPYKLAfdn0lqB3iqBL5bvAnKact+s1w/BKq
IIwS+dHVp9o=
=qNvV
-----END PGP SIGNATURE-----

--Sig_/kL4R3FBlstFu_OeErr5/+qz--
