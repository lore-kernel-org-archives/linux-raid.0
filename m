From: NeilBrown <neilb@suse.de>
Subject: Re: 2 disk raid 5 failure
Date: Mon, 6 Oct 2014 10:50:36 +1100
Message-ID: <20141006105036.15e2cfd1@notabene.brown>
References: <CANuKpt=QJsham0TQWR1Cu1EC8GLyc0aSdU4p3DOznBRrEea11A@mail.gmail.com>
	<20141005194105.4377c295@notabene.brown>
	<CANuKptm=Y3L-xUfGfB5GO3yV63buHeWsfxMYKjUVPP8paGhs0A@mail.gmail.com>
	<CANuKptnEodSbv5ywzMtBq4TZXeOmdd7g0Awo1SXB=xm9kD=EQg@mail.gmail.com>
	<20141005205242.31d630da@notabene.brown>
	<CANuKpt=ujnZh1R+g8O6QxGW4=CLOJAePB-+tFaTKz+XaNVvOYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//+/+/5eQJb3bp4F2/V5Wb+u"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANuKpt=ujnZh1R+g8O6QxGW4=CLOJAePB-+tFaTKz+XaNVvOYw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jean-Paul Sergent <jpsergent@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_//+/+/5eQJb3bp4F2/V5Wb+u
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 5 Oct 2014 02:55:25 -0700 Jean-Paul Sergent <jpsergent@gmail.com>
wrote:

> Great, so its mostly media, movies and stuff. So no real tragedy if I
> loose it. but I'll go ahead and do both then copy the few essential
> files I think I have off of it.
>=20
> Do you know why version 3.3 had those problems and 3.3.2 works?

Because I introduced a bug when I added support for --replace, and my test
suite didn't find it.  Someone else did and reported it, so I fixed it.
Just the normal stuff :-)

NeilBrown

--Sig_//+/+/5eQJb3bp4F2/V5Wb+u
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVDHZTDnsnt1WYoG5AQKCQw//f4uscBdJUuRLJkp+K0Ih0vIxy2TmiN+K
jnbQhPHhNaAhZG5XqpLv60HgecHaBraWCzjispfXm/MAY0ntzQtLAvzwKzasiL92
5qTD4OI8I6StfE1MYz7V5KNoR25VLhQT7o1svTXJVzWPLI8oAZQtd8iNdnwDrd6d
d3XmegDJ9Z1thT1qzvJ6B0jXBx3SClflJlebgVHA8Gk+Y0slMRr8iJoMj8ir6Mn2
SvMPpDiiq4Wab7et3r0brOsnl0uzY7Wc3ju7q+SkC+EQTUdEskk4xIcsRVOo4Mi0
p3mRS8kTX5W0FHNHR6GVy8iOebnRvMd71eYD3ge3WLHjVfeSWJL03ok0J05+uqhS
cZbmJO9MR0SO0/A1oGJIZh/yjqlZjcI6WGMhVYJ3DlRRZdz6/gCl12O92DoMSOmH
IE9ti1GtozQ3V8Xo5OX3yEGzv1LHZP86mGQevJUZu6SJ8Wlgc/VVSlssoO5F3rUI
YVi2xJOrluWEhhXQVxhJWHXSaYFcQyi9CY9i+Ys5xy04L08sjlraUsm8zxWdbAAc
WpgiMwr2dhoHLfSBJ7VdUY4pj01PSePCLHrp1uQLfLVkVQFGDHcDlSOSyOJbEKSk
r5iu4mtv1Be66lI4YlmGdePq1DXwzjWZlLH01XLOF714GJ8nF3xyR+GmIn/Gppsr
9G0nW5If/Y8=
=OIQ9
-----END PGP SIGNATURE-----

--Sig_//+/+/5eQJb3bp4F2/V5Wb+u--
