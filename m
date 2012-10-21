From: NeilBrown <neilb@suse.de>
Subject: Re: Planning a bug-fix release for mdadm: mdadm 3.2.6
Date: Mon, 22 Oct 2012 09:01:21 +1100
Message-ID: <20121022090121.68e958e5@notabene.brown>
References: <20121018154807.461ddd29@notabene.brown>
	<5082C322.6020506@msgid.tls.msk.ru>
	<5082C6CE.9050809@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ktKYcDuD9pv.7XW_ofHvR4_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5082C6CE.9050809@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Sergey B Kirpichev <skirpichev@gmail.com>, linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/ktKYcDuD9pv.7XW_ofHvR4_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 20 Oct 2012 19:44:14 +0400 Michael Tokarev <mjt@tls.msk.ru> wrote:

> On 20.10.2012 19:28, Michael Tokarev wrote:
> > On 18.10.2012 08:48, NeilBrown wrote:
> >>  The "mdadm-3.2.x" branch of my git tree (git://neil.brown.name/mdadm)
> >>  contains what I have so far.  If anyone knows of bugs in current mdad=
m that
> >>  really should be fixed for the next release and aren't in that tree, =
please
> >>  let me know (or even send me a patch).
> >=20
> > There's apparently a small (but annoying when you hit it) bug mentioned=
 in
> > http://bugs.debian.org/686703 -- when specifying --uuid, --homehost is =
NOT
> > ignored as it should be.  I'm looking at it right now, so for now it is=
 JFYI.
>=20
> I just sent a trivial one-liner patch for this issue.  It is applicable f=
or
> older releases too.
>=20
> And here's another trivial bugfix, now for spelling mistakes in various
> places, authred by Sergey Kirpichev (Cc'ed) and carried in debian mdadm
> package.  Please consider applying.
>=20
> /mjt

I've applied these - thanks!

NeilBrown

--Sig_/ktKYcDuD9pv.7XW_ofHvR4_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUIRwsTnsnt1WYoG5AQLAQhAAmf6g6k+ZA2dsGz+/DpijQ+CvmbDxOtQd
WPuDvTWRVOxX3/FlGqMZfl9FpoWoRUN3uadJmkShMzfoBUktygCA02jOVpTrU887
nOaVxtd7mOXyT7uduSi9yoWcnmsgjSYf4g1PxYV9RYPTnO0RN6iSExaQHm3JfwRj
NRWxLrnv2vn5fglr8Nmvp8bgrd4C/2EhqPLCgdFmiQl8dpHH8Wzl0SxbPNxiavCR
Z4ZCARuJOxtn9a1xMCgmjhhocn+rFkA/Gpe8GhF1oKDUwGF6QZgcjNNUxPAtgDZA
n4P54j0Ze6a9leTsV+Mx4jL9CpzTrmYGBWf8mquPMFB9Mfq4VKuZzX077cRZuzZm
SwfKLE/uoQ+oEgZB7BUsvN3V9FMJNq0t3rVVANzrDufIasdHlbf4uxtSMfh3P8wO
eOyrNYpvQdfRUJnmRyadOUvexFqwltGWuQ07mTb93KRdCfLieHhr1aTVaABU3cdA
yTeoRCEFE00Hts40IiJWjKTiSLmNBNa5GddwQ/Oo5xc092HWi3Z/goiiDZxsRbhe
Spyu7D0nVKKvyKT88cd5LLO2KJNGQk9o1s0NvDHXqcD2cMWknc3kpWDuL8pPM/Ci
RbRSQ25/3FJCYrz4NDEiovep1/NmrdETcxanredGwdJCJ3P4dqGmZQLByBcG7DuK
QiqV+BFFFv4=
=F4I7
-----END PGP SIGNATURE-----

--Sig_/ktKYcDuD9pv.7XW_ofHvR4_--
