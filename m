From: Roman Mamedov <rm@romanrm.net>
Subject: Re: raid1 recoverable after system crash?
Date: Thu, 7 Apr 2016 21:59:27 +0500
Message-ID: <20160407215927.2fc82680@natsu>
References: <1460033086.27740.145.camel@interlinx.bc.ca>
 <20160407180004.53615913@natsu>
 <1460045497.27740.157.camel@interlinx.bc.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Ca.L8d6ZqNRI6fb_w=.UIWf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1460045497.27740.157.camel@interlinx.bc.ca>
Sender: linux-raid-owner@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Ca.L8d6ZqNRI6fb_w=.UIWf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 07 Apr 2016 12:11:37 -0400
"Brian J. Murrell" <brian@interlinx.bc.ca> wrote:

> 2016 Apr=C2=A0=C2=A07 12:01:00 linux [16583.606363] md/raid1:md0: Disk fa=
ilure on md1, disabling device.
> 2016 Apr=C2=A0=C2=A07 12:01:00 linux [16583.606366] md/raid1:md0: Operati=
on continuing on 1 devices.
> 2016 Apr=C2=A0=C2=A07 12:01:00 linux FailSpare event detected on md devic=
e /dev/md0, component device /dev/md1
> 2016 Apr=C2=A0=C2=A07 12:01:01 linux [16583.907982] BUG: unable to handle=
 kernel paging request at 0000000099b899b8
> 2016 Apr=C2=A0=C2=A07 12:01:01 linux [16583.908009] IP: [<ffffffffa001922=
7>] call_bio_endio+0x37/0xb0 [raid1]
> 2016 Apr=C2=A0=C2=A07 12:01:01 linux [16583.908009] Oops: 0000 [#1] SMP
> 2016 Apr=C2=A0=C2=A07 12:01:01 linux [16583.908009] Stack:
> 2016 Apr=C2=A0=C2=A07 12:01:01 linux [16583.908009] Call Trace:
> 2016 Apr=C2=A0=C2=A07 12:01:01 linux [16583.908009] Code: 4c 89 65 e0 4c =
89 6d e8 4c 89 75 f0 4c 89 7d f8 66 66 66 66 90 4c 8b 67 28 48 8b 47 20 41 =
bf 01 00 00 00 48 89 fb 41 8b 54 24 2c <4c> 8b 28 85 d2 75 42 48 8b 43 18 a=
8 01 75 07 3e 41 80 64 24 18
> 2016 Apr=C2=A0=C2=A07 12:01:01 linux [16583.908009] RIP=C2=A0=C2=A0[<ffff=
ffffa0019227>] call_bio_endio+0x37/0xb0 [raid1]
> 2016 Apr=C2=A0=C2=A07 12:01:01 linux [16583.908009] CR2: 0000000099b899b8
>=20
> And it seems to be stuck there now.
>=20
> dmesg contents at http://www.interlinx.bc.ca/~brian/raid-dmesg.txt

Don't know what's up with this bug, maybe someone else does.

How are the drives connected, plain SATA, not something unusual such as USB?

As something to try, upgrade to a newer kernel if you can: the 3.2 series is
very old, maybe the bug has been fixed in newer ones.=20

--=20
With respect,
Roman

--Sig_/Ca.L8d6ZqNRI6fb_w=.UIWf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlcGkfIACgkQTLKSvz+PZwgH5gCdGZ9haMYJ7KvjT7+avZB0FylB
F84An21a+M5pOG1aHBDZQH/yM3exSoQ5
=ng2E
-----END PGP SIGNATURE-----

--Sig_/Ca.L8d6ZqNRI6fb_w=.UIWf--
