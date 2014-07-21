From: NeilBrown <neilb@suse.de>
Subject: Re: Drive replace question
Date: Mon, 21 Jul 2014 17:35:46 +1000
Message-ID: <20140721173546.40e8338c@notabene.brown>
References: <20140711171338.GA7295@animx.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/CFm1RC2e=TyavxbhAYVLtlK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140711171338.GA7295@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/CFm1RC2e=TyavxbhAYVLtlK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Jul 2014 13:13:38 -0400 Wakko Warner <wakko@animx.eu.org> wrote:

> When a drive is being replaced and has lots of errors, does it get kicked
> before the resync is completed?

If it doesn't have a bad block log, then "yes".
If it does, then "no, as long as  it doesn't have too many error".

>=20
> I'm performing this action now on a system with kernel 3.14.6.  I don't
> believe the mdadm version makes a difference but it's debian version 3.3-2

The version of mdadm that created the array does make a difference.  Not all
versions create a bad block log.  3.3 and later will create a bad block log.

NeilBrown


>=20
> Here's the mdstat for that array:
> md1 : active raid1 sde[3](R) sdj[2] sdk[1]
>       1465138448 blocks super 1.0 [2/2] [UU]
>       [>....................]  recovery =3D  0.0% (419648/1465138448) fin=
ish=3D174.5min speed=3D139882K/sec
>       bitmap: 3/11 pages [12KB], 65536KB chunk
>=20
> sdj is being replaced by sde.  Currently, md1 is not in use.
>=20


--Sig_/CFm1RC2e=TyavxbhAYVLtlK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU8zC0jnsnt1WYoG5AQIhXxAAkZcH5LDhvg3vWrGsturaQV0a8ETGNl9S
QalCpw09Z5QVbQCoPBx8+ZgvRw4Ub+y+MRhPIGveCo8Q/7fMghb3QauaUlRB/Y79
otGS0CvtorHZwkbmUmwKYaqPAPyTcME/u1SuuhvMgJKelt4wVa7YSsPT5Dc2eQud
pxWauSHbff/w1VYS4bYcAjVQKxLXqoUnHXftESYuONcBjIBJf0gkT7YgH7AzVXx7
MyFYddj4gh/f+hvyJapHo/EuLs56ycwoyT4iiY2/P1i6HITPpQjE6hJqnhIi7rl4
His3f30sOGcIihv6U5ToVGSBOknG+XlQHLqc0fBR/4lgOv9XSDA9TD++eOhrmQ1Y
d1vc1mhxsk5f8VBlDSFgak5X9KoUZ8RDdsP6FyNnXwGbuY3bC6/QUf4yU7Q2ri6C
R3CFHqTWbRf2+bpO1gLFOADY94rUAOtvzxvMKFRXXyJN9GqdCpkfoBJ2W6vwWFR4
E+/+4HbROKvCwK7S1AxzuiyeDnY8mdWjLmrEhZwy1hd7zwIqulXje4Q6QQwycWih
jIU0jBB9FokQkdN6r19ponH4R/kPxr43HW/t3jO9FdeVSYmzbfqCeo59LhbvmQ+K
7saCAN9Y0GslcAAXThwMaAs8cWRXu4t0yYIpT02I6xAlXLRIR0xlcA4bR3+xCNAs
byp84y9lFIc=
=lYYz
-----END PGP SIGNATURE-----

--Sig_/CFm1RC2e=TyavxbhAYVLtlK--
