From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] raid5: Avoid doing more read on dev of a stripe at the
 same time
Date: Wed, 26 Sep 2012 12:43:48 +1000
Message-ID: <20120926124348.3190990c@notabene.brown>
References: <2012091510203206229010@gmail.com>
	<20120920125144.0ed69ec3@notabene.brown>
	<201209201104415460652@gmail.com>
	<20120920132422.0f7841f1@notabene.brown>
	<201209211024418590971@gmail.com>
	<20120925172912.65db0e03@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ps1bwIoETtzk0LzLrJT/oqa"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120925172912.65db0e03@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jianpeng Ma <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/ps1bwIoETtzk0LzLrJT/oqa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Sep 2012 17:29:12 +1000 NeilBrown <neilb@suse.de> wrote:

> On Fri, 21 Sep 2012 10:24:45 +0800 "Jianpeng Ma" <majianpeng@gmail.com> w=
rote:

> > Hi,
> >  i wrote a shell-script can reproduct this bug.
> > Note: mdadm -V
> > mdadm - v3.3-pre - Unreleased
> >=20
...

> Thanks a lot!
> I'll try this out and see what I find.

I've been running this script (with the mentioned version of mdadm) and
nothing has gone wrong.
The 'dd' keeps reporting read errors of course, as does the kernel, but not
crash or freeze or anything.

What exactly happens when you run it?  Do you get a kernel stack trace at a=
ll?
Can you post logs showing where it goes wrong?

Thanks,
NeilBrown


--Sig_/ps1bwIoETtzk0LzLrJT/oqa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGJr5Dnsnt1WYoG5AQK4TRAAqZ3x8Re+Y2+hkobZIRWx5vZ/Q5Q3h9sU
EwtDM4NebikaWN+h/YRl3hXxYIvGZ9TqUCHTL6LSR1FLozzF1y+TkkxwA77EtypZ
8NA+FoUNl8aArUSE6KXSEnrFXw58w1EYolno4Q3gUNwN/2de5bTejnJT/BfXOG1X
FinvfHeCUGyYtqiuZmuEqTPydXACjKH8eREEnO4IuQz3ZKvUM8zoyoV7pS0YajsQ
9uUN+V/Svk/CaS6lc5eARiRvhy0YLH4Pt3gOVWJ+8O5EMLzNvSUk7kos1bIsm4FF
J5P4tvPOqQVbozn8wdtUEDAl2wWtJAnLqA24LmzngQD1seMVpK7JliEN1Qb2k6XK
pThtX2VoPmziZbrFBGZKysmS7j3fqPCox/nHvf/LMJc+SWkVd7lFYiBPV5FKbj/u
QfcE8OJ8aOyRkNEKyugmepPlD5JRTiCqubKtuoPTAfyA8dNb5cnsicGdT3eUwc3Y
zgO+uQrLJtsBs20TpFHtUNhtpJkR7LWvfdHMPmekH9vUbnZLA9eJSADKiUJUj3bg
Bo4aNEKNn8QTHAY4pBWIsRfGZVwJQW5msYfjJ28ONuuzMzpgAp+GNu+TwD8RAMQy
20nl8Y6X7ypEDn3jFPrqzC9LkRm6lueGKAC7egu/Y2orWWjLLDExw3uakPI1QBd9
KNygPFT+eQo=
=mKkm
-----END PGP SIGNATURE-----

--Sig_/ps1bwIoETtzk0LzLrJT/oqa--
