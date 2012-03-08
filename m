From: NeilBrown <neilb@suse.de>
Subject: Re: fakeraid question
Date: Thu, 8 Mar 2012 19:39:53 +1100
Message-ID: <20120308193953.5a679b34@notabene.brown>
References: <4F586D5A.5010707@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/naM=iuy3aZGaYmYNXj21/MH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F586D5A.5010707@googlemail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tobias Powalowski <tobias.powalowski@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/naM=iuy3aZGaYmYNXj21/MH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 08 Mar 2012 09:27:06 +0100 Tobias Powalowski
<tobias.powalowski@googlemail.com> wrote:

> Hi,
> I read on our bugtracker that fedora deprecated the dmraid package in
> favour of mdadm for fakeraid devices.
> Is this correct does mdadm now support all fakeraid devices?

No.  Only Intel Matrix Storage Manager (IMSM) aka 'isw', and some support f=
or
DDF.

mdadm does not support other RAID metadata formats - you still need to use
dmraid for those.

NeilBrown

> Thanks for your help, i'll change the archlinux package and installer the=
n.
>=20
> greetings
> tpowa
>=20


--Sig_/naM=iuy3aZGaYmYNXj21/MH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT1hwWTnsnt1WYoG5AQLhPw//XpA+kiuDC0Z/EdeNNpFdFTc0bA4KP2ek
eOXHIOLkrh5+1+4bevfh0BVRBYy2QX/Xofqb1bjg5g/XUM3gmjWmU8MdVh8CkLyd
UwYmDW2Ir6E1Pn1Hojhq52w2aCOD9/qAhTmswSPyRkEX19FsE5AZjvMEmYG2Spes
ZYGCq+6ODnPHonFZX7CKZqsNdWtt2dsgO+6OYcXwP4rvuu0bhdohGr6ffsiDZ1/k
ssL4AXRRWxSz/IC/uaag64lQNZMJKCpLLIUuhogZd6LMrxsB9COe4dljVQWty+t5
MqQu/Wj+pzkxPxoOXn+OYiPBIFT/nUar8xRtmTdp5jy+Wna6YJYPCkKgns99yHBC
RSR69SA3el34ORTOiE2Z7w82H2qyHMSJJRB5IKQ/ZTy60RRTFrQeF2y6rD3LnlPP
0w2aDDO08GYWrjeAbzvOOSBHlITOqX6/8dTKCZrU6IsSHdUwcaab3vuDNbbOPEdg
s3HGpIXXo88S7TxxmL/UsHqlnX2k/oT8+nF8TacXLYuaFFW4Uh0n0dFsjOrHdhHv
3mhlgg9bOlDBVm4BmaNC1SUqFXrhSzayakzjmpzvTnF6nLrvrg7x+nZVcgvdpWpF
BBf173RgkVDEtaHp6F1joh6J79xFohyW1J++L/qczR9J+fezEeVpzPktq77g7jOi
6jJCDWgZYho=
=MncS
-----END PGP SIGNATURE-----

--Sig_/naM=iuy3aZGaYmYNXj21/MH--
