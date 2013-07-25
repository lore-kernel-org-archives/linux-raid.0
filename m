From: NeilBrown <neilb@suse.de>
Subject: Re: Preparing for mdadm-3.3
Date: Thu, 25 Jul 2013 18:02:30 +1000
Message-ID: <20130725180230.79ac6360@notabene.brown>
References: <20130624171818.71a9688a@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NSz54k23gxKSLj2I8jXsctu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130624171818.71a9688a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/NSz54k23gxKSLj2I8jXsctu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Jun 2013 17:18:18 +1000 NeilBrown <neilb@suse.de> wrote:

>=20
> Hi all,
>  it has been way too long since an mdadm release.  So I'm hoping to pull =
one
>  together over the next few weeks.  It will be mdadm-3.3
>  My goal is to have it out by 25th July (i.e. one month).
>=20

That would be .. today.  I didn't quite make it.
I've just tagged mdadm-3.3-rc2 and pushed that out for anyone who wants to
test.

I still need to resolve whether I'm going to make --add safer (haven't real=
ly
thought more about it yet) and I need some self-tests for the bad-block log

I'd like to release by July 31st, but I suspect it will be some time in the
first half of August.

NeilBrown

--Sig_/NSz54k23gxKSLj2I8jXsctu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfDbljnsnt1WYoG5AQLb4BAAuGlxz658rN0226wPXvjk2/7/WP3YhAGu
wI9EupPvLYMWHShAtyQ70G8V0hV/cbzAmDxk0FSG7ba7Ob/P6Q4daJC3+iqQ2Ojj
/s/GDo4mluIJZnsCE9O1Ve6+4BZKSOjjCm0ULxDhp843O/t26ZqjoBuqnsCfZY4S
iu7Ny8Dqd4UWQoQuW79cVkwECXOxF4cxAJ88sxNDU0FGsoHpPFklDKnhlGr3jugH
X6DhGHzsfoVOKpr/FdJp+HNZoKJVI0KsypHQ4dTpVFufUzRq/hvnbRf/lXo0QRhr
0eG87FkYmNm8nUUyP999j6GRmsY4VnAKQMzks1KBqISBVOU6BA5UMpofFBELRIYI
LopguoTvCuJvsZ1aIjGPz1otYEksoxRviPvFhkTTnx07o878owaPQz7rxu0yQp5J
OF41fZxcNz6D7sys7jeR+yRV7EmxmwK+mC7qYoTv2tVSAGdoV0Wpd/fS1jf+yV9X
auGsF1fbMycMRrIk1qQh45L3jArxSbXj1v66g5P05nCP6OtiY7oOfd9yKjPhQTni
N6tACDdxdOevltwu7Pea4rlv74qslgTgyyipH88QI2uYy8dvkOJF/1Ys2GnMxk5O
DTa58cvC/m33RL2icz185+j3Twpw+oy93NnXCNnNB4mTi4lPox8vtlgBQOzkZ/Vg
LDtfsvjgsQk=
=THWX
-----END PGP SIGNATURE-----

--Sig_/NSz54k23gxKSLj2I8jXsctu--
