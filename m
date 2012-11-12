From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/3] Align FAILED to test name to be parsable
Date: Mon, 12 Nov 2012 16:48:56 +1100
Message-ID: <20121112164856.3a4da5ab@notabene.brown>
References: <20121023092356.1834e0a1@notabene.brown>
	<975144635.322922429.1350981075121.JavaMail.root@zimbra33-e6.priv.proxad.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1SrS4fZDcUZxgtXKoLlnlf0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <975144635.322922429.1350981075121.JavaMail.root@zimbra33-e6.priv.proxad.net>
Sender: linux-raid-owner@vger.kernel.org
To: g.esp@free.fr
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/1SrS4fZDcUZxgtXKoLlnlf0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Oct 2012 10:31:15 +0200 (CEST) g.esp@free.fr wrote:

>=20
>=20
> ----- Mail original -----
> > De: "NeilBrown" <neilb@suse.de>
> > =C3=80: "g esp" <g.esp@free.fr>
> > Cc: linux-raid@vger.kernel.org
> > Envoy=C3=A9: Mardi 23 Octobre 2012 00:23:56
> > Objet: Re: [PATCH 1/3] Align FAILED to test name to be parsable
> >=20
> > On Mon, 22 Oct 2012 10:31:23 +0200 (CEST) g.esp@free.fr wrote:
> >=20
> ...
> > I've change the patch description and removed the change to the failed
> > message, because I don't want the log to appear in-line:
> >=20
> When using an automated build system (like I do in the linux from sources=
 way), usually the last action is to remove the package source that was jus=
t build. So that would remove any log needed to check the reasons of the fa=
ilures.
>=20
> coreutils, after the test suite end, add all logs for failed and skipped =
tests.
> I think this is a good compromise.
>=20
> Did you want that sort of behavior?

I wouldn't object to it as an option.  --errors-in-line or something.

NeilBrown

--Sig_/1SrS4fZDcUZxgtXKoLlnlf0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKCNyDnsnt1WYoG5AQLoohAAmNU/wswrUykOUB9YbmOBmLNAVKbNAxro
SCeqHgAQTNBsF1FDUxgh8USsQ40c0jfpO1JGfeTXQ7zbvMqcR6ZWbGbDSRdWi10P
U4BSD/XeGe3NgXzeZ8vY3XLJeYT1AJ/2SOXW/f2aWAbnF6ueKKUY3WYMA20xqIus
Sl1pOkcFdf1dsXumlZYR+tqOS+cGLnK6JyuXh13YmwtxTG3vFHylXsolv+LsMgLG
QxVLkc5T0UgRfxBCWGxBonXaLx6cCNRsh1dGJbMI/Lt/aVYyq3CL3QnfXJ5kUPjV
w+4srv5jE73fTg8AAWRNPqFGB4gjY1f6Qj3iblgfUcTFP4sdd4zYH5oDile03Gyg
SzqwUU+mPs5KFG6aDU0drBUvVXhK0BeUIyCAD/UGtcFWfwIvMZfwJK0U/LVpeAH/
m2srEap/katJNATnbXsSdm3AA+W1Hj/8BbMgUyihhgDoO++bn+hpexDOLi53i9gu
ePZ4kRkjiKC2zUthwhk17SroWiDvFINcdFPDrzQ64KPWq8QwMByS19BQ9wBmiPTS
EdlZuwkj+1DyJ0wmst71v328/6yPYEoUKk8/ZVXk4Xrxwu3BSsy3zYxh7mO/NnMt
XHd8RFedNEK2DiUZbVkvJPsJN70E48MT7xpEkOXeknv8UKkOFqqIOoe56h8yrWsd
nrokgvqyUfI=
=2Pp5
-----END PGP SIGNATURE-----

--Sig_/1SrS4fZDcUZxgtXKoLlnlf0--
