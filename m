From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: Failed, but "md: cannot remove active disk..."
Date: Mon, 14 May 2012 12:53:00 +0200
Message-ID: <1336992780.6722.18.camel@localhost>
References: <1336933308.2831.4.camel@localhost>
	 <20120514202220.5a164eb0@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-fHwM5YZRPmz2kdlVeOXL"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120514202220.5a164eb0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-fHwM5YZRPmz2kdlVeOXL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2012-05-14, pon o godzinie 20:22 +1000, NeilBrown pisze:
> On Sun, 13 May 2012 20:21:48 +0200 Micha=C5=82 Sawicz <michal@sawicz.net>=
 wrote:
>=20
> > Hey,
> >=20
> > I've a weird issue with a RAID6 setup, /proc/mdstat says:
> >=20
> > > md126 : active raid6 sda1[3] sdh1[6] sdg1[0](F) sdf1[5] sdi1[1] sdc[8=
] sdb[7]
> > >       9767559680 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7=
/6] [_UUUUUU]
> >=20
> > So sdg1 is (F)ailed, yet `mdadm --remove` yields:
> >=20
> > > md: cannot remove active disk sdg1 from md126 ...
>=20
> There is a period of time between when a device fails and when the raid45=
6
> module finally lets go of it so it can be removed.  You seem to be in thi=
s
> period of time.
> Normally it is very short.  It needs to wait for any requests that have
> already been sent to the device to complete (probably with failure) and
> very shortly after that it should be released.  So this is normally much =
less
> than one second but could be several seconds is some excessive retry is
> happening.
>=20
> But I'm guessing you have waited more than a few seconds.

Yup :)

> I vaguely recall a bug in the not too distant past whereby RAID456 wouldn=
't
> let go of a device quite as soon as it should.  Unfortunately I don't
> remember the details.  You might be able to trigger it to release the dri=
ve
> by adding a spare - if you have one - or maybe by just
>   echo sync > /sys/block/md126/md/sync_action
> it won't actually do a sync, but it might check things enough to make
> progress.

# echo sync > /sys/block/md126/md/sync_action
-bash: echo: write error: Device or resource busy

eh?

> What kernel are you using?

# uname -a
Linux media 2.6.38-gentoo-r6 #2 SMP Tue Sep 13 19:13:42 CEST 2011 x86_64
AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ AuthenticAMD GNU/Linux

Thanks,
--=20
Micha=C5=82 Sawicz <michal@sawicz.net>

--=-fHwM5YZRPmz2kdlVeOXL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPsOQMAAoJEGnv7NPGHSZFCBQQAMLX1oB6ryU6iKzSTtPHsyYu
D/ZN4FMkWVBi7EGAJmc2rbppDFKpoeU34EhuNxQZ8NTK99VpHt4tNQtsWeR7C20D
GhWW7ID0Ho1MXPxU5D5EYyUB8+qS55JHnH53gfJMe0cS+lSJ3X2HsI1My85EJOB7
8kw9ZoelYEMHx+gqKaeTDMWbcKPXBrvX98+dvjpu++NcMjQoi1Y9blyaDptA9V2l
dcEVbwqmOtz4nhBHSj+sqqrwjEedy8CIpW5LBMVw3asqMWK+AOB6ILmoPC1agvqG
boh2YJLCC8DHfPx3w5tItkTUEWPhfo3wU3VNn+aUb5VC4o4W52LTNIemIxzgS2Vp
Mj4EhO1i80An9ovrBWYn6H6aGdg5pcQIvr4ItvrIqlPyLOrfHglFL8K1LlO39Uss
W0oSpCgEH+q9/UZKufr04MGWPZYSN10xWlUUVwHnOLaK20B2Hio0hlFweyaJiSoC
wDyzf/B/nULIKFfvsGZ69HGdyqh9L5VzwKYQnV2jFi5CGZCB2e8n9hm25AX08BzC
9aNgQuRgIySprfELVxllT4tp2iLeCGdOQGCMHkMHr0LkhFHfxN+6XDCyQ72lM4Cc
I6312yrEbrMfXaBB2LRYJgomr3o77Vf/hIhyb7lUJy3t93IPM05RlcO82YME5bq1
RvMlDWMKGbLiASRXOrsx
=TzJG
-----END PGP SIGNATURE-----

--=-fHwM5YZRPmz2kdlVeOXL--

