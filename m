From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 1/1] raid5: avoid release list until last reference of
 the stripe
Date: Wed, 28 May 2014 12:01:13 +1000
Message-ID: <20140528120113.7545de1a@notabene.brown>
References: <CC9129A7-569A-4065-A14B-C03A9E6DD091@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wSX4Exq4841ox9rDL85U.yx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CC9129A7-569A-4065-A14B-C03A9E6DD091@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eivind Sarto <eivindsarto@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/wSX4Exq4841ox9rDL85U.yx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 May 2014 18:35:11 -0700 Eivind Sarto <eivindsarto@gmail.com> wro=
te:

> This simple patch will reduce the number of times stripes are queued on t=
he release_list.
> Currently stripes are queued more than twice as many times on this list a=
s they need to be.
>=20
> -eivind

Applied, thanks.

NeilBrown

--Sig_/wSX4Exq4841ox9rDL85U.yx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU4VDaTnsnt1WYoG5AQJaAw/+JG531ERphXjMs5qpKjuaW9j/XPeW09Bl
wtooyQRnyunhXDHO4V54OAiA50hh442MOJl5XEOK19O+8wx/ZKETXKVUU+yZx93/
NQlXocsrqsZGo8ahimraHAskJ1kdIaLG76HStv3pRBZktr3J8dJFS7v0fcJxqN9p
1qosKFnC8KWDIFCs0sx4ytTWI8RESAWpKIWqeaLMNv7VF5rIRBY+QGKtp2NFcOpU
CihScDcIE3crpDld2U4ph6Jmvrb78Ts3YxyUx84bcvzO9jz/kwKq5KOFmUdPY7eB
6Mh9D/XGQF5Vrufv1fz46+DPCt4ontFAQkc2q3DqyXoHUp1uPN/s0csc5r2YNSkw
wv9a8y6mkg0X8VGKhAfyPSO/PP1V3aK+y9x1gEx1hxr8ai5CJnMV1zZJizUIgnRy
HLLRf1hUCahjBHLJy9bvoQkrwXtYWxCKmXFSw9eL4REM2B/z6m85cfMBcEhHjOTc
QMHsIOMgBSaEMNxMXSwVYwbKjcYnQnVlgozAanB5hsZBw/JPAduonDhFJrpAEtV1
o/wFwZx8nJgGLm9zf1oJHLnxE4cPvXnxGsKMOaKgcOBUXWQ6pt2AjxjArt2jMJi9
zJm/cYtLqTP3PlbnJugSmQCWOkNN+OP6zi3s81ChM5eRYX8CoQAiHM/isx80GK3a
VbjwAN8ZxFk=
=bk2n
-----END PGP SIGNATURE-----

--Sig_/wSX4Exq4841ox9rDL85U.yx--
