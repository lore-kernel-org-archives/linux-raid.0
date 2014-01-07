From: NeilBrown <neilb@suse.de>
Subject: Re: More 'D' state processes [was: Re: Weird problem: mdadm blocks]
Date: Tue, 7 Jan 2014 11:23:05 +1100
Message-ID: <20140107112305.0e8ff837@notabene.brown>
References: <52B6AA66.5050502@hanswkraus.com>
	<20131222221914.78630829@notabene.brown>
	<52B70F38.5040807@hanswkraus.com>
	<52B716BF.70000@hanswkraus.com>
	<20140106090054.594f6853@notabene.brown>
	<2b3bc4b9893fa3dee2944c249722d863@hanswkraus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uczUH3JzxYh8HBWm3r+Zp6q"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2b3bc4b9893fa3dee2944c249722d863@hanswkraus.com>
Sender: linux-raid-owner@vger.kernel.org
To: hans@hanswkraus.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/uczUH3JzxYh8HBWm3r+Zp6q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 06 Jan 2014 17:00:35 +0100 hans@hanswkraus.com wrote:

> =20
>=20
> Hi Neil,=20
>=20
> the output of 'uname -r' is: 3.2.0-4-amd64. A standard Debian Wheezy.
>=20
> I rebooted the system in the meantime. The re-sync started anew but
> finished otherwise without flaws.=20

I guess there must be some other bug then. I still expect that it is related
to md_flush_request().  Probably related to the fact that you have an md
device on top of other md devices....

I had a quick look and cannot find the cause of the problem.  Maybe it will
have to wait until someone else hit it :-(

Thanks for the report,
NeilBrown


>=20
> Regards, Hans=20
>=20
> Am 05.01.2014 23:00, schrieb NeilBrown:=20
>=20
> > On Sun, 22 Dec 2013 17:43:43 +0100 Hans Kraus <hans@hanswkraus.com> wro=
te:
> >=20
> >> Hi Neil,
> >=20
> > Hi Hans,
> > sorry for the delay - Christmas/New Year vacation...
> > [40800.777037] xfsaild/dm-0 D ffff88003754c300 0 20798 2 0x00000000 [40=
800.777042] ffff88003754c300 0000000000000046 0000000000000000 ffff88005d7c=
51a0 [40800.777047] 0000000000013780 ffff88001b01ffd8 ffff88001b01ffd8 ffff=
88003754c300 [40800.777052] ffff880071fede00 ffffffff81070fc1 0000000000000=
046 ffff88003734a400 [40800.777057] Call Trace: [40800.777061] [<ffffffff81=
070fc1>] ? arch_local_irq_save+0x11/0x17 [40800.777071] [<ffffffffa0170466>=
] ? md_flush_request+0x96/0x111 [md_mod] [40800.777076] [<ffffffff8103f6c4>=
] ? try_to_wake_up+0x197/0x197 [40800.777082] [<ffffffffa0f11711>] ? make_r=
equest+0x25/0x37a [raid456] [40800.777091] [<ffffffffa0185873>] ?
>=20
> This looks like the most likely root of the problem - something wrong in
> md_flush_request.
>=20
> There was a bug here fixed in 2.6.37
>=20
> commit a035fc3e2531703b539f23bec4ca7943cfc69349
> Author: NeilBrown <neilb@suse.de>
> Date: Thu Dec 9 16:17:51 2010 +1100
>=20
>  md: fix possible deadlock in handling flush requests.
>=20
> You didn't say which kernel you were running. Could it be earlier than
> 2.6.37???
>=20
> NeilBrown
>=20
> =20

--Sig_/uczUH3JzxYh8HBWm3r+Zp6q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUstI6Tnsnt1WYoG5AQIsBRAAuIqgeMIR94ACZPX7FIkW5G2qBcN68aWR
edNm9La7N4SRbUiTdXcaZrV7bZWx63cOEjKfbbQtxJz2KL2QodXrtdK8I6kd2jrj
NxmLF1oUfOQX4JxE3VBWpv44oYNBdVcIhuDVNadHmLOYqC9h8BGm9kzsSnPQQ/kn
Fi91P0yrsQUtPFt6ClBxv20z/1jxkC5Cp+viz2mhQCXXUWmOIzYXrTIYtUvpywzA
AFPvy6cauPv+vGqElPGuLo/ivyoRxmIuyljh0Yl85jG2FWy3vV5E+Zw0A+fyrorR
jxgwT+EZ4rADS5uxlNGnOcbLv09XTQAg8th/FbU5ub11FfrDUidy9E+Cgb9E7zCs
bsqwjyUzfQvfmL2lZKlR9JInBZ+7Bfpj46k2QQyHB4seBr+UE1Z28oxGpCXpBwHd
mJDOw9qSb/Ky882qp8Ix1hCwa5uL5BmdZfzFPgiCo7kdqcN6+81NVPzAzYw9TLJI
WUfeGsJBMy6S//kT5E57qbrXRhaCP7l2epEuKUPPc9GN+N9vehxB+XDv4lDiOpq3
pl2Fockp+gVRrTzlqISFrN6AY86GglUp8ODMghys38bB98bTSob+x1zwrG32K3FX
42eXMtu5ATcqMWyprE4gT2VqaAVIlM3OOVEVXiBea+qwiU2xH4ds94JXx/QJpF8P
N6gFU4fqGCY=
=BVlW
-----END PGP SIGNATURE-----

--Sig_/uczUH3JzxYh8HBWm3r+Zp6q--
