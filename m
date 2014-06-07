From: Roman Mamedov <rm@romanrm.net>
Subject: Re: writing zeros to bad sector results in persistent read error
Date: Sat, 7 Jun 2014 07:51:40 +0600
Message-ID: <20140607075140.277c0880@natsu>
References: <B7EA34DA-1064-45B1-B0C0-B7C423C7EB47@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=M2=/5bqlxSPgnhVdlVJRjO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B7EA34DA-1064-45B1-B0C0-B7C423C7EB47@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/=M2=/5bqlxSPgnhVdlVJRjO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Jun 2014 18:11:03 -0600
Chris Murphy <lists@colorremedies.com> wrote:

> # dd if=3D/dev/zero of=3D/dev/sda seek=3D430196560 count=3D2048
> dd: writing to =E2=80=98/dev/sda=E2=80=99: Input/output error
> 1025+0 records in
> 1024+0 records out
>=20
> It stops right at LBA 430197584, again with a read error. So even though =
the drive SMART health assessment is "pass" and there are no other SMART va=
lues below threshold indicating "works as designed" this drive has effectiv=
ely failed because any write operation to this LBA results in unrecoverable=
 failure.

Hello,

Try again with "oflag=3Ddirect";

If that doesn't help, remember this is a 4K-sector drive, maybe you should
retry with bs=3D4096 (recalculating the offset so it still writes to the pr=
oper
place).

--=20
With respect,
Roman

--Sig_/=M2=/5bqlxSPgnhVdlVJRjO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlOScCwACgkQTLKSvz+PZwhFqACfUqlj0cCHRtxoIvi4+fSVU+Kj
Qg4An32xzjJBZjEygqwTQJyjyhTl3JAf
=CN6W
-----END PGP SIGNATURE-----

--Sig_/=M2=/5bqlxSPgnhVdlVJRjO--
