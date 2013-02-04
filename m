From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: What layout with 6x2TB, Intel Atom?
Date: Tue, 5 Feb 2013 03:12:32 +0600
Message-ID: <20130205031232.61813f6c@natsu>
References: <CADNH=7EUc7z-E=uo74-QqaKEUcrZiAYKaZqtSfFVbLKpfvt7og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Rj/AUCqPhQ=/QXorMHt9Ty2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7EUc7z-E=uo74-QqaKEUcrZiAYKaZqtSfFVbLKpfvt7og@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?UTF-8?B?QnVyw6lu?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Rj/AUCqPhQ=/QXorMHt9Ty2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 4 Feb 2013 20:27:42 +0000
Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:

> I read that the far layout gives faster read performance compared to
> standard RAID1 in a 2 HDD array, so that's why I used it. I then
> created yet another RAID10 f2 layout of the 3x 2 disk RAID10 volumes,
> giving me /dev/md124. Filesystem doesn't matter, I need something
> that's stable with good performance over the RAID set.
> I just realized that out of 12 TB raw space I now only have 3TB
> available, heh. So I suppose I'm going for a different layout.
>=20
> Any opinions?

Hello,

Why won't you even consider RAID6? To me it seems like the perfect choice,
given the details you described (mostly reads, large files, few clients).
And the disk count is perfect, not too few and not too many, so to say :D

--=20
With respect,
Roman

--Sig_/Rj/AUCqPhQ=/QXorMHt9Ty2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlEQJEAACgkQTLKSvz+PZwjzdwCeILe+ZKUf2faQ3Rt50UpGyIWF
xwUAoIGqsDbZrmMJfiCGPIop84F7dNNJ
=vRCz
-----END PGP SIGNATURE-----

--Sig_/Rj/AUCqPhQ=/QXorMHt9Ty2--
