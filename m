From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm on an MvixBox running OpenWRT
Date: Mon, 23 Apr 2012 07:28:45 +1000
Message-ID: <20120423072845.03d854f1@notabene.brown>
References: <SNT108-DS14C5F6BAE0EFE3A61BEB4BF0200@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DXKHboRcjNWvb.8vjyVkwdY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <SNT108-DS14C5F6BAE0EFE3A61BEB4BF0200@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: "Hotmail (John Fleuren)" <john_fleuren@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/DXKHboRcjNWvb.8vjyVkwdY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Apr 2012 22:35:12 +1000 "Hotmail (John Fleuren)"
<john_fleuren@hotmail.com> wrote:

> Hi Everyone, (Neil Brown if he is looking), =20
>=20
> Thanks to the OpenGemini project I have OpenWRT running on an MvixBOX (a =
small 2 bay and rather cheap NAS box).
> Just recently someone on the NAS2000 forum asked about configuring a RAID=
 1 on the MvixBOX running this OpenWRT firmware.
> He was looking for the mdamn module, but it had not been compiled and the=
refore not included as an IPK.
>=20
> The mdamn source code has some patches for Linux Kernels but not noticed =
anything for v3.04 (as is used by this version of OpenWRT).
>=20
> So my question is simple: will mdamd still work with linux kernel 3.04?=20
>=20
> I was able to cross compile the mdamn source for the storlink soc for thi=
s person and hoped he would provide some feedback on setting up the RAID 1.
> Never heard from him again but now I am intrigued if it is possible.
> I've never configured a RAID 1 system myself, but want to try if mdadm do=
es indeed work with the later Linux Kernel.=20

Sure - any mdadm should work with any kernel.  Just try it...

NeilBrown

--Sig_/DXKHboRcjNWvb.8vjyVkwdY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5R4DTnsnt1WYoG5AQIIrA/9Ep00gDKxndvGhIkf4WqyTKdjx69pubGu
yxkC7Wmbox72dDYqNqJvSwA9eOv/IF35laAfPYY6pm2po5nMwggzV58fG25eC5G4
lqFdQtiu6Fkh9rieiTj//0OsYRXEiVTyU9nnCV9nGB7Ah/yVG+Ri8drGHtM8Nqby
fTSBnvsB7gFodjLakF/am+PI9iM11RBPWbj7C/CLPUXZlbEBMptddcAFHXojf2Hw
U5/b/hpOqgNWSjflN7akCBRM46YRZs99YfJxbWD+oUdaf5Jf4OjFKL2659u56Nwv
wWOwuM6EViCjEh3mFe8hv+jXd7brkImrP+KVhcT/GxnJeVEtctcCN+Sz5IUa9WOy
mUlufi3Qyh/EXk2lc5pnP8iJxZeceWom3ApMR+RvzkJnPOpW/YH4Isj9tWWpyTuW
+35oIYDk6zCu1tAqQ2jRG3XmA2alZZCH0+YeKKjwMoEJyeyDgfDulLhmdaT5pbK4
2bVgEpfj0DOAsfxcTp8CLO3d6dWp8zQVMMQV2RWnmqmynjF8GH1/ANc5zUhjQow8
hxmpih5l2IuaXpHkHgCuiDfqmVZveCo2pE4t74ET+vAduBrOlvcORXswZQmpcEi9
t0aDgNa0X11CGhos3aZMlER+Y5ANZKc+TywtnRMy61g3jfV1dsSmxs9XmQqo2KXs
Xw2W3J2Bf/g=
=D9Ls
-----END PGP SIGNATURE-----

--Sig_/DXKHboRcjNWvb.8vjyVkwdY--
