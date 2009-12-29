From: "Andrea Dell'Amico" <adellam@sevenseas.org>
Subject: Re: Tools for Hardware Raid?
Date: Tue, 29 Dec 2009 19:42:35 +0100
Message-ID: <1262112155.2607.47.camel@localhost>
References: <1262014433.25079.212.camel@vibe>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-r6ZKy+ig+ECXfA2xavCZ"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1262014433.25079.212.camel@vibe>
Sender: linux-raid-owner@vger.kernel.org
To: Rick Bragg <lists@gmnet.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-r6ZKy+ig+ECXfA2xavCZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-12-28 at 10:33 -0500, Rick Bragg wrote:
> Hi,
>=20
> Since my latest disaster was caused be me not monitoring raid disks, I
> was wondering about tools for monitoring hardware based raid systems?
>=20
> I have a Dell 1900 with a perc5 raid controller
>=20
> # lspci
> 02:0e.0 RAID bus controller: Dell PowerEdge Expandable RAID controller 5
>=20
> It is set up as RAID 10
>=20
> I tried running smartctl on it, but that does not even work because the
> system sees the array as just one disk.
>=20
> I'm wondering how I can monitor the disks, etc...
>=20
> Any advice?

At http://linux.dell.com/ you can find firmware updates and the software
needed to monitor every piece of hardware of your server.

> Thanks
> Rick

ciao
andrea
--=20
Andrea Dell'Amico - <http://www.link.it/>


--=-r6ZKy+ig+ECXfA2xavCZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQCVAwUASzpNlnRv13Ch/b4ZAQIHDwP/TabWoCSHdwens0z8Lc/lzJfWzX+hr9dI
B3B8yG7ADXpKsCXaQgRz5e42BpiCx2vENhQYmtdjWFIueq+gXSwIk8xKYzcVN3x6
YuCKwYiMbFtJSPqd1gbBxcSCj39t7nfL2uS/lJQXBdMdeqdpjstZv+mCwhuYWyNU
TcXiyxu9Emo=
=+CWl
-----END PGP SIGNATURE-----

--=-r6ZKy+ig+ECXfA2xavCZ--

