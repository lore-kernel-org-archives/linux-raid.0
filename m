From: NeilBrown <neilb@suse.de>
Subject: Re: How do I set 'write-behind' on existing array?
Date: Tue, 21 Oct 2014 08:14:29 +1100
Message-ID: <20141021081429.509f2d72@notabene.brown>
References: <5445011B.8040008@hanswkraus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/qv=uI.5YYX7GRADurke5fAZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5445011B.8040008@hanswkraus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hans Kraus <hans@hanswkraus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/qv=uI.5YYX7GRADurke5fAZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Oct 2014 14:33:31 +0200 Hans Kraus <hans@hanswkraus.com> wrote:

> Hi,
>=20
> I want to expand an existing root array with an SSD. For that purpose I
> try to set firstly 'write-behind' on that array. Afterwards I will add
> the SSD, remove the HDs and re-add them with 'write-mostly'. On that
> array is the root filesystem, therefore stopping is no option. In
>  >/home/kraush/work/mdadm/mdadm< is the latest mdadm version from git.
> I tried:
> -----------------------------------------------------------------------
> root@elefant:/home/kraush/work/mdadm/mdadm# ./mdadm --manage=20
> --write-behind=3D4096 /dev/md4
> mdadm: :option --write-behind not valid in manage mode
> root@elefant:/home/kraush/work/mdadm/mdadm# ./mdadm --grow=20
> --write-behind=3D4096 /dev/md4
> mdadm: no changes to --grow
> -----------------------------------------------------------------------
> What is the correct syntax?
>=20

Not quite.

"write-behind" is a property of the bitmap.
To enable write-behind on an array you first need to remove the bitmap if
there is one
  mdadm /dev/md4 --grow --bitmap=3Dnone
then add a new bitmap with the required property
  mdadm /dev/md4 --grow --bitmap=3Dinternal --write-behind=3D4096

NeilBrown

--Sig_/qv=uI.5YYX7GRADurke5fAZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVEV7NTnsnt1WYoG5AQKZiA/9E+grqpyn8fPuKdWWJUU+4fseYwPS8V1d
aX8aeC0tQauy22VnERnjJaGa1kLLJJOkyNbsJgIUnYzOfqviptR77ZTp2GaIr2qr
SNEBmAzYb5qU4Uo6d2bb7262cN+kPefrdu+RZQOj8/JBBWwHx/bfK3H+0s1NYaKC
RjNAtEgz3FliGoWRvlfmfUh13hJ4UM2ktpupVNU8utlPo5/v++DWdUhV34NIKfMo
U/8Gg8C1r/PrhdoOT7eR2CwZPDDtidYGUAFRJUIgBE6NM4AJjiywlC26PsIyRyVK
tYatFU7+u9mwlhKYHHTmQIiZ+H9r2I5nk4zh7nc+hTbOkjIG/O7fGm5Ag6+AFoUt
IHny+zZ5JJ0wM7g8j7pAo1W6O5c1eCDMxDZSwdvzs2Qr/cSWBXjmfAKB0Nhgmuz6
LHVFlL9z9BTH3l7fZvkUeyHDeDe7Kx+5fEndzgX4cHc7jiettwD1xKKf0kD4xkuz
DNXWutKI+Dsi/4GllWXMWLd6wraHm1ghqUo+J7dGW1zlne9ByUbxw67KOjsnkoJX
udh15GIx1parCiVHYJbiaUIvgper8jA/F6sQHfVbyODL+m9geOt8f9HUeLGuREZT
DLkdJZWORctVgK3qi/vz88imrlMT7j/8zvSDe/dn/S1PeTne2h7LqZQTK1GC13Te
a4EfMxWcWpo=
=kj14
-----END PGP SIGNATURE-----

--Sig_/qv=uI.5YYX7GRADurke5fAZ--
