From: NeilBrown <neilb@suse.de>
Subject: Re: some general questions on RAID
Date: Mon, 8 Jul 2013 14:53:16 +1000
Message-ID: <20130708145316.4486d0dc@notabene.brown>
References: <1372962602.8716.56.camel@heisenberg.scientia.net>
	<51D5F22C.70007@turmel.org>
	<51D9A7CF.6000700@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hsFSdkRgVA5ip1+T2kxYfjm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51D9A7CF.6000700@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, Christoph Anton Mitterer <calestyo@scientia.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/hsFSdkRgVA5ip1+T2kxYfjm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 07 Jul 2013 19:39:27 +0200 Milan Broz <gmazyland@gmail.com> wrote:


> So if you have multiple IOs submitted in parallel from *different* CPUs,
> they are processed in parallel.
>=20
> If you have MD over dmcrypt, this can cause problem that MD sumbits all I=
Os
> with the same cpu context and dmcrypt cannot run it in parallel.

For RAID1 and RAID10 this isn't true any more.

Commit f54a9d0e59c4bea3db733921ca9147612a6f292c
in 3.6 changed this for RAID1 and a similar commit did for RAID10.
RAID4/5/6 still submit from a single thread as you say.

NeilBrown


--Sig_/hsFSdkRgVA5ip1+T2kxYfjm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUdpFvDnsnt1WYoG5AQJn9RAArL1Oi1qgoFJOlx4lpktsD77VW5JWQh8T
5/H7u0cxcyl8Khcpcacor1xpjaaFoDB+ngpD28g1zx5AJpGEoD99/+WW8LyQUJzr
3apnxxJsrbZkoj26tueZ/mw1iMc0GupJqu+GIWvHSMkbwDxDa/j6kT45eRDNg0Cr
9WlpEj8QfIvrTiWztE5A+4aXCOSWq3qbW263bOfH11rHqiWrI+8HdHZZ+W8PLt8I
AFSkbwTJQkzHir2SerMifXTiTxOjDWnpwhAIauubDGMEjCxZZbtS7V3WEubgt+Z+
a2s7o6eyBhapp8zpvUPGM71viQZws+5j7Uce6bbVrW7dZjU2P73NPrGlJ2iuvJlb
c2AYQOIKNEtBVc3WE68pyf4S6T4NXk92TncvFLp5xMC51IPsqKxp9lVvFmvxKA52
ItdFYUhBb7WejDm9a9eC14CaCHvh2Clsx14RQ9txhJSlqWbTCJZUlbFG3veMikgG
rsD/hd8L/oddCUHJMHQAYPWIw0VLKhoCm+tb0u1ipjCs6i1CrXYRHl3ywIiBM2qk
d24pm/lMCQ2WJpscU145GhJmFhAY92NcGs+KyerpxeMjpQpP/ANVWTH29oP1DOIv
zwUqivvUHWNBG85CE2c9nl3p+dE0sicTGt7Uj5r6b9x3gpxpwlPq5IOkXh+4OYOJ
i4GUakdTpL4=
=U2Fh
-----END PGP SIGNATURE-----

--Sig_/hsFSdkRgVA5ip1+T2kxYfjm--
