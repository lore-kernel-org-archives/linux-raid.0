From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Problem with raid1 read error patch
Date: Tue, 21 Sep 2004 18:07:58 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1095782878.8380.60.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.58.0409201700460.12286@tux.rsn.bth.se>
	 <414EF709.7040505@steeleye.com>  <1095696866.8380.23.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZcXCM0qkQmoTGZ9IuXL9"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1095696866.8380.23.camel@tux.rsn.bth.se>
To: Paul Clements <paul.clements@steeleye.com>
Cc: neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-ZcXCM0qkQmoTGZ9IuXL9
Content-Type: multipart/mixed; boundary="=-j3JKV33gTF3IcSk8YxZ8"


--=-j3JKV33gTF3IcSk8YxZ8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2004-09-20 at 18:14, Martin Josefsson wrote:

Hi Paul

> > I've been debugging the same problem just recently. In addition to this=
=20
> > patch from Neil, you'll also need a patch that I posted here last week,=
=20
> > which does a bio_put() and a bio_clone() to get rid of the old bio that=
=20
> > the read error occurred on, and create a new (clean) bio to retry the=20
> > read against:
> >=20
> > http://marc.theaimsgroup.com/?l=3Dlinux-raid&m=3D109527014728404&w=3D2
>=20
> Thanks, will try it out tomorrow when I'm back in front of the machine.
> Didn't expect an answer so soon :)

I tested the patch today, worked like a charm. Thank you.

There's been some small changes in 2.6.9-rc2-bk6 which is the kernel
I've been testing with. I applied your fix by hand and diffed, the
resulting patch is attached to make life easy for others with the same
problem.

Thanks again.

--=20
/Martin

--=-j3JKV33gTF3IcSk8YxZ8
Content-Disposition: attachment; filename=raid1-errorfix.patch-2.6.9-rc2-bk6
Content-Type: text/plain; name=raid1-errorfix.patch-2.6.9-rc2-bk6; charset=iso-8859-1
Content-Transfer-Encoding: base64

LS0tIGxpbnV4LTIuNi45LXJjMi1iazYvZHJpdmVycy9tZC9yYWlkMS5jLm5vZml4CTIwMDQtMDkt
MjEgMDk6MjU6NDguMDAwMDAwMDAwICswMjAwDQorKysgbGludXgtMi42LjktcmMyLWJrNi9kcml2
ZXJzL21kL3JhaWQxLmMJMjAwNC0wOS0yMSAwOToyNzo1Ni4wMDAwMDAwMDAgKzAyMDANCkBAIC05
NDEsNiArOTQxLDkgQEANCiAJCQl9IGVsc2Ugew0KIAkJCQlyMV9iaW8tPmJpb3NbcjFfYmlvLT5y
ZWFkX2Rpc2tdID0gTlVMTDsNCiAJCQkJcjFfYmlvLT5yZWFkX2Rpc2sgPSBkaXNrOw0KKwkJCQkv
KiBkaXNjYXJkIHRoZSBmYWlsZWQgYmlvIGFuZCBjbG9uZSBhIG5ldyBvbmUgKi8NCisJCQkJYmlv
X3B1dChiaW8pOw0KKwkJCQliaW8gPSBiaW9fY2xvbmUocjFfYmlvLT5tYXN0ZXJfYmlvLCBHRlBf
Tk9JTyk7DQogCQkJCXIxX2Jpby0+Ymlvc1tyMV9iaW8tPnJlYWRfZGlza10gPSBiaW87DQogCQkJ
CXJkZXYgPSBjb25mLT5taXJyb3JzW2Rpc2tdLnJkZXY7DQogCQkJCWlmIChwcmludGtfcmF0ZWxp
bWl0KCkpDQpAQCAtOTQ4LDkgKzk1MSwxMSBAQA0KIAkJCQkJICAgICAgICIgYW5vdGhlciBtaXJy
b3JcbiIsDQogCQkJCQkgICAgICAgYmRldm5hbWUocmRldi0+YmRldixiKSwNCiAJCQkJCSAgICAg
ICAodW5zaWduZWQgbG9uZyBsb25nKXIxX2Jpby0+c2VjdG9yKTsNCi0JCQkJYmlvLT5iaV9iZGV2
ID0gcmRldi0+YmRldjsNCiAJCQkJYmlvLT5iaV9zZWN0b3IgPSByMV9iaW8tPnNlY3RvciArIHJk
ZXYtPmRhdGFfb2Zmc2V0Ow0KKwkJCQliaW8tPmJpX2JkZXYgPSByZGV2LT5iZGV2Ow0KKwkJCQli
aW8tPmJpX2VuZF9pbyA9IHJhaWQxX2VuZF9yZWFkX3JlcXVlc3Q7DQogCQkJCWJpby0+Ymlfcncg
PSBSRUFEOw0KKwkJCQliaW8tPmJpX3ByaXZhdGUgPSByMV9iaW87DQogCQkJCXVucGx1ZyA9IDE7
DQogCQkJCWdlbmVyaWNfbWFrZV9yZXF1ZXN0KGJpbyk7DQogCQkJfQ0K

--=-j3JKV33gTF3IcSk8YxZ8--

--=-ZcXCM0qkQmoTGZ9IuXL9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBUFHdWm2vlfa207ERApk7AJ4kerwpMNVP+NGaMCwUWaXVSGPFqgCgt+43
jK4RWJNTEgNasFddFHdo8Dk=
=dx2h
-----END PGP SIGNATURE-----

--=-ZcXCM0qkQmoTGZ9IuXL9--
