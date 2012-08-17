From: NeilBrown <neilb@suse.de>
Subject: Re: md: raid 10 supports TRIM
Date: Fri, 17 Aug 2012 19:28:44 +1000
Message-ID: <20120817192844.237a9026@notabene.brown>
References: <20120816110237.GA4709@elgon.mountain>
	<502DAEB3.6080302@fusionio.com>
	<20120817040015.GA8644@kernel.org>
	<502E03C4.5000607@computer.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/W4e=3FETNgnzp+8Akh1i7IF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <502E03C4.5000607@computer.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, dan.carpenter@oracle.com
List-Id: linux-raid.ids

--Sig_/W4e=3FETNgnzp+8Akh1i7IF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Aug 2012 10:41:40 +0200 Jan Ceuleers <jan.ceuleers@computer.org>
wrote:

> On 08/17/2012 06:00 AM, Shaohua Li wrote:
> > Thanks! Neil, this is the updated patch. If you prefer a fix against or=
iginal
> > patch, please let me know.=20
>=20
> I rather suspect that Neil has already applied the original version of
> your patch, that Dan then ran his static checker on Neil's tree (or
> perhaps on linux-next?) and found this problem.
>=20
> If so, Neil will need an incremental fix from you, rather than a fix
> that's incorporated into the patch that introduced the problem.
>=20
> HTH, Jan

If I had sent it upstream to Linus, then you would be right.
But I haven't yet, it is just sitting in -next, and I regularly rebase my
-next tree so I'll have no trouble replacing the offending one with the fix=
ed
up.

Thanks,
NeilBrown

--Sig_/W4e=3FETNgnzp+8Akh1i7IF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUC4OzDnsnt1WYoG5AQKbwg/9HEwu6KIPN9zmi5DxH+KEhQN6jS5RV+vP
G3IMVIS62Z1aF7mFVEDZV6AT7Klmgh/jCtlXB4trKe5kIOz0QU0uYaurcUJUeEO2
1sK693SZEUA47oG3NsF3DbWRNZ0Kex1dr4oU0vbr+zAOLZ6576UGVZGo2oKT+HFc
b2QEYc+wmwA3QBDRLVXJ4k2lR/q/X1w317K9KphgFovTdOzkLm2GZBy3PXHpbXLL
Rvcd1QLmnEjgLhV8V2IqjaJmIcmqBWuuGIvosx++5fYhpyxrHOh/6HekTjFRCBjh
n85Woz4dAuuzsxJDFR4QrVb16zZCRODn3uqY1OYM+GSQ/vlfz6S99lYvWSe5CIKi
yRtF4Lalk4f0vNuqNjPb75NAO9TVOCljjXOkloUS6MQ5hqsl8UpSrKzxowYBlcBA
omvU6BcJcnyVXyiUNVof4nqwhQoPoSk/lNnasT/pXGKdNxo3hjt7Zop9i7HJwbH2
BDBTJGyxcrGWiOdIvGvLyi/3M4A3OArWITe8bOGOypunbzrSFqoalwrz9t11g+4X
UCpF9LZQMp4N5yoDPPdOlpkQDkaigTaIAJwPOVQ/fRUZbud0XFXxvJR6RZbb1qw7
6jZhd9xhzv5qhRmPJX5wkc6ysOMR5Y/JhoDVBTWadKbtgG9gXk16Y0CytmuX0kRZ
BR+YJqV29mA=
=6rmx
-----END PGP SIGNATURE-----

--Sig_/W4e=3FETNgnzp+8Akh1i7IF--
