From: NeilBrown <neilb@suse.de>
Subject: Re: Help recovering an interrupted raid0 reshape
Date: Tue, 7 Apr 2015 11:50:33 +1000
Message-ID: <20150407115033.1d63b65c@notabene.brown>
References: <CAC_83AFDEijn-7gNmnWNNabzcuPRMabNwr8xfRFt0xacsvZfog@mail.gmail.com>
	<20150407094608.4a9dd142@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Q=Jn+AUQrt70hlttOjU/UuV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150407094608.4a9dd142@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: "Jonathan Harker (Jesusaurus)" <jesusaurus@gentlydownthe.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Q=Jn+AUQrt70hlttOjU/UuV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Apr 2015 09:46:08 +1000 NeilBrown <neilb@suse.de> wrote:

> On Fri, 3 Apr 2015 19:22:15 -0700 "Jonathan Harker (Jesusaurus)"
> <jesusaurus@gentlydownthe.net> wrote:
>=20
> >=20
> > Third, is it possible to resume the reshape? If not, can it be reverted?
> >=20
>=20
> I'll have to get back to you on that.  Hopefully you can be patient a lit=
tle
> longer.
>=20
> NeilBrown
>=20
>=20

Hi again Jonathan,
 please report what version of mdadm and of Linux that you are running.

Also is there any chance that you tried=20
   mdadm --assemble .... --update=3Drevert-reshape
??
And if you did, why didn't you say so :-)

NeilBrown

--Sig_/Q=Jn+AUQrt70hlttOjU/UuV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSM37znsnt1WYoG5AQIDgw/9EcuN8P9b/hUnwzz16bwAVQvDzgSCN16d
BTKvckYst2YiVQU+GR6BywpL3pvT/89wwaBkfcvgQgnx9li+QcE/k6joa6fzFx1J
C23ULt/GQrliIxQSLikdwkoA3eXdvMGOv/BHlZmuXpA+erFTzRD8kJqCrJXto1AM
9U7TE2HMblOTeLu2L2xjPKvfoq1rvQO8storFA14ZiTtkC/KU4z48+rELKPxloAm
Hfopu1ml+NG3IA3m/CoNbenFQ9JEgUZLnMXRav6mrT8XVQQEqyz6nsGrzX+S3Q6f
Vr5Pkq9H5E+PIq5zd0JJYs+Fz833w63ly5wMox4LzSHldJLaFta0DV7moNWd7r+7
sYpXym+SS2yArYzMqseI2V3c3wyGf5TKLtsd9OBRmPoOG5uMcofEtJwdRWeUdR6o
heynYPIVe05AUqflhhZ/fUCYeS+bUqlg2AooDIVf74xu4mlrKlUcJ0a7gc7d15YD
YSyBOaxcRpGrMTmXSPci+VACOrNLVzPGzl19lfi6ReXArUYzpdbvOWtten+r2paC
KJS1Siexe23T5Tlsl1XQBrwVpXFwQLK/LB8dzd3QjqbYmJTm8SHLBlWreFC8Adnm
ko+gAvnFJFzPivD/cogXyuHHkmcn+HwbhxTwDWbKJQG5wW73N9kjKQDhrO+agsEg
baBvVF+pSec=
=J9T8
-----END PGP SIGNATURE-----

--Sig_/Q=Jn+AUQrt70hlttOjU/UuV--
