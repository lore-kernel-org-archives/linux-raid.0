From: NeilBrown <neilb@suse.de>
Subject: Re: ioctl message
Date: Sat, 19 May 2012 08:05:16 +1000
Message-ID: <20120519080516.3f8f4e19@notabene.brown>
References: <4FB69FE7.2010807@rogers.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_r8bXAwNW=fwOOaNg2W7w/b"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FB69FE7.2010807@rogers.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wiliam Colls <william.colls@rogers.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/_r8bXAwNW=fwOOaNg2W7w/b
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 May 2012 15:15:51 -0400 Wiliam Colls <william.colls@rogers.com>
wrote:

>=20
> In our system log, we recently saw the following message:
>=20
> May 17 14:20:54 gabriel kernel: [423762.117502] mdadm: sending ioctl=20
> 1261 to a partition!
>=20
> repeated 10 times, all with the same time stamp. Has not re-occured=20
> since, and I don't recall seeing anything like it before.
>=20
> What is mdadm trying to tell me,=20

That someone should remove that silly message from the kernel.

> and what do I need to do about it?

Nothing.

NeilBrown

>=20
> Thanks for your time.
>=20


--Sig_/_r8bXAwNW=fwOOaNg2W7w/b
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7bHnDnsnt1WYoG5AQKPFA/7BaGeaXijcvy8lZC6SYoqfZ9n47QcG02C
RfPC1Bidb1bi+HHzoE7miERLXiTsTLQ36DHUDrK/c3ZkPDSBGkJp2zBxWg89ISRg
0ET6LWgHBb6P+O9w8YZ+K4gAqxIitKnvVBCUtToqJUgTiBLjGnWqt5kzePJ30z6o
Nj6eI2rTO9be27dvdwZF4IQ9sRj31D9+RAm8MeKBhod+KdkmzlY/Ybo36T772O4B
DLB3ZyHgmmoZs255VUO24XE1uwKxGHKgPLaeOD4vCH4zR3fGdsAVTa4nzUxCv3I9
ZUV/8IbUx0vfqKBcicw0cSEnamhSTWEH0L7k+nZYdHiXBerkwED+yQVX9nkHpR6n
L2bDquhTn0wJa2Vx7Ww0nHgHIhiOnwKpFuPNZyyw6lmcFg7RMWm6SOogwpsU6e02
1tX3owIpO0QDdVCRTiluaQe+GANL9yq1faSCvMYV0FMRN9Z8z3/DpIqTBFH2aok+
3Bww+YPwMFew3vl3YpL6J8a3SZEFcRdliejUmkPldcmfPw3gkE5Zwkhz//9dojlp
ceUBhkrjHxkfsV/uhoTS5y0GALEeniixcvtTvKrP4fLW7CKVs8t8CD9WzXzPQbxg
XRkSGAZWwdP8qS1s6u8BCX5Yh43KBCQcEfJxtXfCBgh27ayhrva4IL3LzKAC9dc1
aN+2LT/0DHs=
=OYDi
-----END PGP SIGNATURE-----

--Sig_/_r8bXAwNW=fwOOaNg2W7w/b--
