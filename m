From: NeilBrown <neilb@suse.de>
Subject: Re: Filesystem corruption MD (imsm) Raid0 via 2 SSD's + discard
Date: Thu, 21 May 2015 09:08:45 +1000
Message-ID: <20150521090845.7e228e46@notabene.brown>
References: <alpine.LRH.2.11.1505201918570.4751@praktifix.dwd.de>
	<20150521013213.536deed0@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/NXouIzL0Bb/BhSakrhHAPX="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150521013213.536deed0@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/NXouIzL0Bb/BhSakrhHAPX=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 21 May 2015 01:32:13 +0500 Roman Mamedov <rm@romanrm.net> wrote:

> On Wed, 20 May 2015 20:12:31 +0000 (UTC)
> Holger Kiehl <Holger.Kiehl@dwd.de> wrote:
>=20
> > The kernel I was running when I discovered the
> > problem was 4.0.2 from kernel.org. However, after reinstalling from DVD
> > I updated to Fedora's lattest kernel, which was 3.19.? (I do not rememb=
er
> > the last numbers). So that kernel seems also effected, but I assume it
> > contains many 'fixes' from 4.0.x. As filesystem I use ext4, distribution
> > is Fedora 21 and hardware is: Xeon E3-1275, 16GB ECC Ram.
> >=20
> > My system seems to be now running stable for some days with kernel.org
> > kernel 4.0.3 and with discard DISABLED. But I am still unsure what could
> > be the real cause.
>=20
> It is a bug in the 4.0.2 kernel, fixed in 4.0.3.
>=20
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D785672
> https://bbs.archlinux.org/viewtopic.php?id=3D197400
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/linux-sta=
ble/+/d2dc317d564a46dfc683978a2e5a4f91434e9711
>=20
>=20

I suspect that is a different bug.
I think this one is
  https://bugzilla.kernel.org/show_bug.cgi?id=3D98501

NeilBrown

--Sig_/NXouIzL0Bb/BhSakrhHAPX=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVV0T/Tnsnt1WYoG5AQITVw//ZnyTDeL9oIeieZ6WgkWPyjBQAWSY4xN9
cXo83O1JWnOKTy9tpTrIx5DKtx2ElyxUpAqhH2ggZJbTYd1BrbQv2NzVtK28sGRw
K2M5lae+fX2z0Xga9j5me/91mp43f+9kD8V6CtSsTBji/XtaLWcNXM8rgvRsAFuG
Px/2BGw0XK5I161kDTQwoP/nLjPPkI9bdwu5FqpJ651n1tiIzrTmajnOyRV+oMrQ
E2JaT1lUcsPuGUwy1gwJyTDl67OV1kbAlUsH34oSpgX8/9xhWI8hxHjP+csz0FFg
a+QrFvU1dDq9qLD1ADuAzvZAs/HkTnefixTBXeAr+MwT94Pv56xbPkpa3fv0S6r3
1A3YC1mN0vM8BTtjhDL2PXE9lDioEKzaw7Nyhw88aNmLX04VwbxMMi+96HUM1HXq
A3SDA2VVUF5Bf526tOJ36AtHA53O3LzTiWfH4XQEMqp7ZhK3JuL5iaAmJLPCmYMd
n9zxkBVgbOJzFA3vtNzk30itmkK2WjPSMcBA1rQYa9lEsgGOuxZA4rZMsMdM8g44
rc7iwFXB1LgWq/wPB+vrTyEjfhTLy7s4N1j/lbdSE8d24gQfKSJviBPMNN1wmFNN
7N86tWr1C/e93gNp8HdXdjOrWEgI8RpAPzD2xLQVWExVMT12nQtqoZMdgAoahGCa
uEpOXHHLLGc=
=VwQ7
-----END PGP SIGNATURE-----

--Sig_/NXouIzL0Bb/BhSakrhHAPX=--
