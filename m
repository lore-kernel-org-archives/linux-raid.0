From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Mixed controllers on JBOD Raid 6?
Date: Thu, 2 Jul 2015 00:14:40 +0500
Message-ID: <20150702001440.2d391587@natsu>
References: <CAOS+5GFJQ10z-VV=06ncxh+wb=ycq9HrHJfJD++y8z8qGnoOrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/H8_VvVJ2Xs.Nx+Te=RRWlao"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GFJQ10z-VV=06ncxh+wb=ycq9HrHJfJD++y8z8qGnoOrw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/H8_VvVJ2Xs.Nx+Te=RRWlao
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Jul 2015 19:27:11 +0100
Another Sillyname <anothersname@googlemail.com> wrote:

> I'm looking at an Asus Maximus Vii Gene motherboard which has 8 SATA
> controller connectors.....6 Intel and 2 other (can't remember at the
> moment).
>=20
> Are there any projected issues or concerns about making a 8 Drive
> RAID6 array where I'm using mixed controllers?

Mixing controllers in general -- no issue whatsoever, that's the beauty of =
the
(Linux) software RAID.

In cases like yours, there could be a minor performance hit if the addition=
al
2-port controller gets fed only a single-lane of PCI-E 1.0. If so, this will
cap the total throughput of both ports combined to less than 250 MB/sec.

However on the motherboard that you specified that controller is ASMedia
ASM1061 which supports PCI-E 1x 2.0. And if the chipset really provides a 2=
.0
port to it (not an expert in Intel chipsets, check the datasheets), then the
cap would be 500 MB/sec, which should be more than enough for two regular
spinning hard drives.

In any case, typically with RAID6 setups like these getting the highest
possible sequential read/write performance isn't on top of the priorities
list, so the above may not even be a concern for you.

--=20
With respect,
Roman

--Sig_/H8_VvVJ2Xs.Nx+Te=RRWlao
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlWUPCAACgkQTLKSvz+PZwgsuwCeKFVp8JB2xyc5hUDKfKCpB4fW
KFYAn3AAZfU6s8tDF+VoopKvaoAG15bU
=x1R+
-----END PGP SIGNATURE-----

--Sig_/H8_VvVJ2Xs.Nx+Te=RRWlao--
