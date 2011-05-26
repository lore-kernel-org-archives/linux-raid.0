From: =?ISO-8859-1?Q?Torbj=F8rn?= Skagestad <torbjorn@itpas.no>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 11:45:30 +0200
Message-ID: <1306403130.9437.109.camel@torbjorn>
References: <4DDDC301.7090608@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ujbDMj7IJh7KKPL7jo5U"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDDC301.7090608@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>, John Robinson <john.robinson@anonymous.org.uk>
List-Id: linux-raid.ids


--=-ujbDMj7IJh7KKPL7jo5U
Content-Type: multipart/mixed; boundary="=-ze2/GNr6sVeTvuH4ZFAv"


--=-ze2/GNr6sVeTvuH4ZFAv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Great tool, thanks for sharing.

I had to add some error handling to get it to work properly.
Currently it runs on Ubuntu 10.04, 10.10 and 11.04.

Added the check John Robinson asked for as well.

Attached patch for those interested.


--
Thanks
Torbj=C3=B8rn

On Wed, 2011-05-25 at 23:03 -0400, Phil Turmel wrote:
> Hi All,
>=20
> Last November, I shared a shell script that helped me keep track of the s=
pecific hot-swap drives I had in the various slots of my servers.  Although=
 encouraged by Roman and John, I declined to make a project out of it.
>=20
> I've since kicked it around some more, and thought a bit about supporting=
 more than just the SCSI subsystem.  The latest and greatest is still built=
 around some standard executables:  blkid, lspci, lsusb, sginfo, and smartc=
tl.  The original was similar to "lsscsi", but with controller details and =
device serial numbers.
>=20
> New features:
> 	Supports non-SCSI storage devices
> 	Describes layered block devices
> 		MD raid
> 		LVM
> 		generic device mapper
> 		loop (partial)
> 	Shows UUIDs
> 	Shows mountpoints
> 	Avoids repeating subtrees when enumerating raid devices
>=20
> I struggled with the last item, until I gave up on bash.  I needed to pas=
s data to subroutines by reference, and bash is sorely lacking in that area=
.  The new script is in python.  I'm releasing this one under the GPL versi=
on 2.
>=20
> Please give it a whirl.
>=20
> Phil

--=20
Torbj=C3=B8rn Skagestad
Id=C3=A9 Til Produkt AS
torborn@itpas.no

--=-ze2/GNr6sVeTvuH4ZFAv
Content-Disposition: attachment; filename="lsdrv.patch"
Content-Type: text/x-patch; name="lsdrv.patch"; charset="UTF-8"
Content-Transfer-Encoding: base64

LS0tIGxzZHJ2CTIwMTEtMDUtMjYgMTE6MDY6NDQuMDAwMDAwMDAwICswMjAwDQorKysgbHNkcnYu
cHkJMjAxMS0wNS0yNiAxMTozNDo1MC4wMDAwMDAwMDAgKzAyMDANCkBAIC00Nyw3ICs0NywxMiBA
QA0KIGRlZiBydW54KCphcmdzLCAqKmt3YXJncyk6DQogCWt3YXJnc1snc3Rkb3V0J10gPSBQSVBF
DQogCWt3YXJnc1snc3RkZXJyJ10gPSBQSVBFDQotCXN1YiA9IFBvcGVuKCphcmdzLCAqKmt3YXJn
cykNCisJdHJ5Og0KKwkJc3ViID0gUG9wZW4oKmFyZ3MsICoqa3dhcmdzKQ0KKwlleGNlcHQgT1NF
cnJvciBhcyBlOg0KKwkJcHJpbnQgIlVuYWJsZSB0byBleGVjdXRlICIgKyBzdHIoYXJnc1swXVsw
XSkNCisJCXByaW50IGUNCisJCWV4aXQoKQ0KIAlvdXQsIGVyciA9IHN1Yi5jb21tdW5pY2F0ZSgp
DQogCXJldHVybiBvdXQNCiANCkBAIC0xNjYsOSArMTcxLDEyIEBADQogCWRldnBhdGggPSBvcy5w
YXRoLnJlYWxwYXRoKGRldnBhdGhsaW5rKQ0KIAlpZiBkZXZwYXRoIGluIHBoeWRldnM6DQogCQly
ZXR1cm4gcGh5ZGV2c1tkZXZwYXRoXQ0KLQlwaHkgPSBTdHJ1Y3QoZHBhdGg9ZGV2cGF0aCwgbm9k
ZT1ub2Rlc3RyLA0KLQkJdmVuZG9yPWlvLkZpbGVJTyhkZXZwYXRoKycvdmVuZG9yJykucmVhZCgp
LnNwbGl0KCJcbiIsMSlbMF0uc3RyaXAoKSwNCi0JCW1vZGVsPWlvLkZpbGVJTyhkZXZwYXRoKycv
bW9kZWwnKS5yZWFkKCkuc3BsaXQoIlxuIiwxKVswXS5zdHJpcCgpKQ0KKwl0cnk6DQorCQlwaHkg
PSBTdHJ1Y3QoZHBhdGg9ZGV2cGF0aCwgbm9kZT1ub2Rlc3RyLA0KKwkJCXZlbmRvcj1pby5GaWxl
SU8oZGV2cGF0aCsnL3ZlbmRvcicpLnJlYWQoKS5zcGxpdCgiXG4iLDEpWzBdLnN0cmlwKCksDQor
CQkJbW9kZWw9aW8uRmlsZUlPKGRldnBhdGgrJy9tb2RlbCcpLnJlYWQoKS5zcGxpdCgiXG4iLDEp
WzBdLnN0cmlwKCkpDQorCWV4Y2VwdCBJT0Vycm9yOg0KKwkJcmV0dXJuIE5vbmUNCiAJaWYgb3Mu
cGF0aC5leGlzdHMoZGV2cGF0aCsnL3VuaXF1ZV9pZCcpOg0KIAkJcGh5LnNlcmlhbCA9IGlvLkZp
bGVJTyhkZXZwYXRoKycvdW5pcXVlX2lkJykucmVhZCgpLnNwbGl0KCJcbiIsMSlbMF0uc3RyaXAo
KQ0KIAlpZiBub3QgcGh5LnNlcmlhbDoNCkBAIC0xODksNiArMTk3LDggQEANCiBibG9ja2J5bmFt
ZT1kaWN0KCkNCiBibG9ja2J5bm9kZT1kaWN0KCkNCiBzeXNjbGFzc2Jsb2NrPSIvc3lzL2NsYXNz
L2Jsb2NrLyINCitpZihub3Qgb3MucGF0aC5leGlzdHMoc3lzY2xhc3NibG9jaykpOg0KKwlzeXNj
bGFzc2Jsb2NrID0gIi9zeXMvYmxvY2svIg0KIGZvciB4IGluIG9zLmxpc3RkaXIoc3lzY2xhc3Ni
bG9jayk6DQogCW5vZGVzdHI9aW8uRmlsZUlPKHN5c2NsYXNzYmxvY2sreCsnL2RldicpLnJlYWQo
KS5zcGxpdCgiXG4iKVswXQ0KIAlzaXplc3RyPXNlY3Qyc2l6ZShpby5GaWxlSU8oc3lzY2xhc3Ni
bG9jayt4Kycvc2l6ZScpLnJlYWQoKS5zcGxpdCgiXG4iKVswXSkNCkBAIC0yNTAsNyArMjYwLDEw
IEBADQogCQlkZXZzdGF0ID0gb3Muc3RhdChtZGV2KQ0KIAkJbm9kZXN0cj0iJWQ6JWQiICUgKG9z
Lm1ham9yKGRldnN0YXQuc3RfcmRldiksIG9zLm1pbm9yKGRldnN0YXQuc3RfcmRldikpDQogCQlp
ZiBub2Rlc3RyIGluIGJsb2NrYnlub2RlOg0KLQkJCW1udHN0YXQgPSBvcy5zdGF0dmZzKG1udCkN
CisJCQl0cnk6DQorCQkJCW1udHN0YXQgPSBvcy5zdGF0dmZzKG1udCkNCisJCQlleGNlcHQgT1NF
cnJvcjoNCisJCQkJbW50c3RhdCA9IE5vbmUNCiAJCQlkZXYgPSBibG9ja2J5bm9kZVtub2Rlc3Ry
XQ0KIAkJCWRldi5tb3VudGRldiA9IG1kZXYNCiAJCQlkZXYubW91bnRwb2ludCA9IG1udA0K


--=-ze2/GNr6sVeTvuH4ZFAv--

--=-ujbDMj7IJh7KKPL7jo5U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk3eITQACgkQ4RjLWGFqSIaERQCfeUGDfezAnAWemhYSSFOgdU4D
5iIAnjoUHs21wRknXpG6ySN1Bfn2rvlT
=K19z
-----END PGP SIGNATURE-----

--=-ujbDMj7IJh7KKPL7jo5U--

