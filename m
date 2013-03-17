From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD: Quickly return errors if too many devices have
 failed.
Date: Mon, 18 Mar 2013 10:49:05 +1100
Message-ID: <20130318104905.4a70bc00@notabene.brown>
References: <1363195764.24906.14.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/p1NoYEaq+e+VXtSGC1HMprw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1363195764.24906.14.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/p1NoYEaq+e+VXtSGC1HMprw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Mar 2013 12:29:24 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> Neil,
>=20
> I've noticed that when too many devices fail in a RAID arrary that
> addtional I/O will hang, yielding an endless supply of:
> Mar 12 11:52:53 bp-01 kernel: Buffer I/O error on device md1, logical blo=
ck 3
> Mar 12 11:52:53 bp-01 kernel: lost page write due to I/O error on md1
> Mar 12 11:52:53 bp-01 kernel: sector=3D800 i=3D3           (null)        =
   (null) =20
>          (null)           (null) 1

This is the third report in as many weeks that mentions that WARN_ON.
The first two where quite different causes.
I think this one is the same as the first one, which means it would be fixed
by =20
      md/raid5: schedule_construction should abort if nothing to do.

which is commit 29d90fa2adbdd9f in linux-next.

> Mar 12 11:52:53 bp-01 kernel: ------------[ cut here ]------------
> Mar 12 11:52:53 bp-01 kernel: WARNING: at drivers/md/raid5.c:354 init_str=
ipe+0x2d4/0x370 [raid456]()

>=20
> Are other people seeing this, or is this an artifact of the way I am kill=
ing
> devices ('echo offline > /sys/block/$dev/device/state')?

That is a perfectly good way to kill a device.

>=20
> I would prefer to get immediate errors if nothing can be done to satisfy =
the
> request and I've been thinking of something like the attached patch.  The
> patch below is incomplete.  It does not take into account any reshaping t=
hat
> is going on, nor does it try to figure out if a mirror set in RAID10 has =
died;
> but I hope it gets the basic idea across.
>=20
> Is this a good way to handle this situation, or am I missing something?

I think we do get immediate errors (once all bugs are fixed).
Your patch does extra work for every request which is only of value if the
array has failed - and it really doesn't make sense to optimise for a failed
array.
The current approach is to just try to satisfy a request and once we find
that we need to do something that is impossible - return an error at that
point.  I think that is best.

Can you try the commit I identified and see if it makes the problem go away?

Thanks,
NeilBrown


--Sig_/p1NoYEaq+e+VXtSGC1HMprw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUUZWcTnsnt1WYoG5AQI5tQ/9FEoCyAhqcc7BkWRDQWjygoCLvC5cm8Wi
nskwuon0KmTsVPnIX+VBNuz9v3bqB9QU/iCxTVS2hailu4a7E0i2fQMhJr2/0K+W
JWfJhxr0yYQckkDJLoPwz7hnYgFi8ahOKdub/MqAyS1+5DjKzWgEAED/qlZmQEZN
d57nK5zGuhmQPh79iyKVDN+4YWRmNSEW/I5mCtrU1xiOEwrKyDuPmgRGy/qWOoeH
WTs+ekzPX5jmFjZGJcTlfH3ODuMOQC0CghFNDCNAV/c6hgONnc2PXneTeu3QLTe2
75qw0CGGy/tAkV4zT7kSqv8KJLOcZvLMNdOuXbv/ZedCiYUTpeg0Tb4mhxNua41s
uXvgaRnNwgoJZn/JmlK7DjDI+Naqj5mbqvp4JLvtge5fhqQ4x3mJRN65yK6UkhG6
3pklRLuQK9nBNify3z9cnF+q1/L9+wrpUb/DXzrlOdpzMY+rndjEJTfBbhrBozkh
oatDwZFn0ac9YYypivDz4+Ufcp8alY0Tkw6+QmqgUPfFsjT0VrNbtcy4neDFH56W
eS5PSV1JPoXof8e2m3qQE9vGdWl0c9Twi7WZunPLWSOEGHW3Dmc4Icq6HeQ2wu96
txt508ZkjIivG60v+29E6gqL7zeRQfwGpfRD7w9MXccB7egAWIW1+r+oc/4WGk3W
Q+/c3K2FSpY=
=7qgi
-----END PGP SIGNATURE-----

--Sig_/p1NoYEaq+e+VXtSGC1HMprw--
