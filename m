From: NeilBrown <neilb@suse.de>
Subject: Re: tarballs in www.kernel.org with wrong extension
Date: Wed, 9 May 2012 10:55:27 +1000
Message-ID: <20120509105527.0d01abac@notabene.brown>
References: <jo3mu3$s8l$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/y5l8vEjlU7XTh_B5.HaUV4Y"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <jo3mu3$s8l$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Joao Cardoso (Alt-F)" <whoami.jcard@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/y5l8vEjlU7XTh_B5.HaUV4Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 05 May 2012 18:10:26 +0100 "Joao Cardoso (Alt-F)"
<whoami.jcard@gmail.com> wrote:

> Hi,
>=20
> In the mdadm kernel.org download site,=20
> http://www.kernel.org/pub/linux/utils/raid/mdadm/
> all tarbals with extension 'tgz' are in reality plain tar, not gzip=20
> compressed tar as the extension suggests.
>=20

Thanks for letting me know.
I've uploaded .tar.gz files instead which should be properly compressed.
And I have replaced all the .tgz files with empty files (because I don't
think it is possible to directly delete them).
I'll see if the kernel.org admins will delete them for me.

Thanks,
NeilBrown

--Sig_/y5l8vEjlU7XTh_B5.HaUV4Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6nAfznsnt1WYoG5AQKQqRAAuILpi+Cab8NtXqjlQcDxaagN7cmorr73
9HcIG3fgsnzw5t8WVjUov0g1yqOY8J8PFZJNO3YqeZa2mN8bv19pTfMP/k/1sPIU
n2QgNRAoyG29agE0Fb5UFvWgEYsbsEwydXEQB7vhQdXcHL9VgAj/4Gg2IOW/BpmW
Xso0qtSZOCkOdCtO0B+EYC2qGBkdT1TFqJAPTg3Y8iwGNfkMBCFhUWAnfvDKNoH4
aJdrLp2vXuFpKxw/+KJAHRZ3Aydil4ObN8XLt43kRAKGky5ZQRG6mLNOheXrnBuI
qOxvHFoLiXX+yJmM5cv9hDH6ShDc/ObddQ/rdIlP4sfyR1Zi2Rmhe3p1SiVCXT6E
WPUYd+P4jKA25VbIZffzHwMT0foam4gAe/WWfw66B4wMTDeScPLeiHqJupAap08/
F3fV9FCj71ebfrmEMRyeJM0F05rj6lJSNYn9IIIYj6ILQx/eqiaZvHVgKp5JIxTB
K0i31+OYya8BKOgFMcJEXIapF8ThlmMIjpfNDafgBUX1LSSxACw9s/QbpHCkJi9G
Wu2dEBW/uHKRbEUtkCsANElIRliT9NA0WR8xeIxMjDNLmUNyzC9C7UYR+ifh7H1h
zMDxR8saOJTCXtmr9bmDUTnAS4jx2Ka7A8htTIzAphDk2onDx0Z3Uz8/0yaR8wPc
t2ygxC0UWEc=
=0r2R
-----END PGP SIGNATURE-----

--Sig_/y5l8vEjlU7XTh_B5.HaUV4Y--
