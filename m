From: NeilBrown <neilb@suse.de>
Subject: Re: about:conf->recovery_disabled and  mddev->recovery_disabled
Date: Mon, 9 Apr 2012 10:03:29 +1000
Message-ID: <20120409100329.5eff419d@notabene.brown>
References: <201204071713172658588@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qCRj=JB86E8hx=ghCHV1oFx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201204071713172658588@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/qCRj=JB86E8hx=ghCHV1oFx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 7 Apr 2012 17:13:22 +0800 "majianpeng" <majianpeng@gmail.com> wrote:

> Hi all:
> 	I confused the recovery_disabled.
> 	what's the mean when conf->recovery_disabled =3D mddev->recovery_disable=
d?
> 	If equal,so not to add disk and not to recovery?

Yes, exactly.

in an attempt to recover a device fails we don't want to immediately retry =
as
that would cause a loop.
So whenever a recovery fails, we set conf->recovery_disabled to match
mddev->recovery_disable.  And whenever something changes which might make
recovery possible, we increment mddev->recovery_disabled, so that it tries
again.

With raid10, the 'recovery_disabled' is per-disk, not per-array.

NeilBrown

--Sig_/qCRj=JB86E8hx=ghCHV1oFx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4InUTnsnt1WYoG5AQLkcA/+PW5aLuOPzZ5XwH2nKdZqKrm9LpUD5JEm
A30dzZBqEQYTEwBvuNW6dcxnNSv1KAM8ik1WaXjco51MiL88bBltLD0657g/5EAJ
mp4EvDPskzM2+xZ1i8uvj0V6NKRO1ADN99w+4RdDtGN6NewCvbyGPnwSLn1W8c20
5OsYhT3AUgwlcB10yH4w8Vm4ulZ2q2EPEtLqTLrECz2WkxZqTm8i1ICCmlYBCPci
sNjN8eP+/sH/3wWAZvgjagLDo+S/DeE9AHCbGO2VocjBdD/HdIE6iGO2pAwc4fmp
KcM75y81cxeHshNuAT0B2sdWPcPjHEFT9Prw640GZyNo5fYW3XWNcvXOpxAVfewY
2XjYWdinUZFXXj6BzHYf+rfgjjXuvwjX6e2VP6SjOVo9pGx8ObInSolV9qyqa6JK
3JR2QLz1/VmkXCRJg4a7tq7kPkmXE2h9cYYlsgpE0fMTMCAzGn0L0zEcFIt/e+zG
Xps2rnXNak57ydnQkJKKzX6HxQH2deVVzrzzLH3Llxaeyohl1j2NCqOrc+voKXJX
ctFnnxLQjK9OdpfCX8Jj7ICBYTPA+crzPFWs/0/NTX2El5smIquEGV+X16ZVF5/J
3ALY0tGzLRNmQlPYI8+qdmlqyytm2zcqPu1L5mkCVilFS220kDbNNq4hH/mk3gw0
CbpHx7YOuzY=
=k1RR
-----END PGP SIGNATURE-----

--Sig_/qCRj=JB86E8hx=ghCHV1oFx--
