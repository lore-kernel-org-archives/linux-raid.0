From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Filesystem corruption MD (imsm) Raid0 via 2 SSD's + discard
Date: Thu, 21 May 2015 01:32:13 +0500
Message-ID: <20150521013213.536deed0@natsu>
References: <alpine.LRH.2.11.1505201918570.4751@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+Bobs340mqqo07L=T7fyIyu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1505201918570.4751@praktifix.dwd.de>
Sender: linux-raid-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/+Bobs340mqqo07L=T7fyIyu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 May 2015 20:12:31 +0000 (UTC)
Holger Kiehl <Holger.Kiehl@dwd.de> wrote:

> The kernel I was running when I discovered the
> problem was 4.0.2 from kernel.org. However, after reinstalling from DVD
> I updated to Fedora's lattest kernel, which was 3.19.? (I do not remember
> the last numbers). So that kernel seems also effected, but I assume it
> contains many 'fixes' from 4.0.x. As filesystem I use ext4, distribution
> is Fedora 21 and hardware is: Xeon E3-1275, 16GB ECC Ram.
>=20
> My system seems to be now running stable for some days with kernel.org
> kernel 4.0.3 and with discard DISABLED. But I am still unsure what could
> be the real cause.

It is a bug in the 4.0.2 kernel, fixed in 4.0.3.

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D785672
https://bbs.archlinux.org/viewtopic.php?id=3D197400
https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/linux-stabl=
e/+/d2dc317d564a46dfc683978a2e5a4f91434e9711


--=20
With respect,
Roman

--Sig_/+Bobs340mqqo07L=T7fyIyu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlVc700ACgkQTLKSvz+PZwjEWQCdF2ly+iY8tEPIrdZpj1suSEEC
OJYAn1xtxPWBqxYdM8/iqNMMtD4CQPL6
=Fjcw
-----END PGP SIGNATURE-----

--Sig_/+Bobs340mqqo07L=T7fyIyu--
