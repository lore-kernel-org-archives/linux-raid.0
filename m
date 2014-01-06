From: NeilBrown <neilb@suse.de>
Subject: Re: raid5: R5_WriteError is not cleared after rdev is marked as
 Faulty
Date: Tue, 7 Jan 2014 09:46:19 +1100
Message-ID: <20140107094619.102c7abe@notabene.brown>
References: <CAGRgLy6w=_nspVHu9YF9JHz3ADc5CkGL5N0bv6TGgopUpeaxGw@mail.gmail.com>
	<20140106131505.0ee4c490@notabene.brown>
	<CAGRgLy5wy54cCiXkuwTTqUugaKCukUgUNq7vzf75TV0=f2+2bA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/z_dD6UR95Ofy98mX3Ap9iip"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5wy54cCiXkuwTTqUugaKCukUgUNq7vzf75TV0=f2+2bA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/z_dD6UR95Ofy98mX3Ap9iip
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Jan 2014 17:12:10 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Thanks, Neil!
> The test that was failing, passes now.
>=20
> Thanks for the patch,
> Alex.
>=20
>=20

Thanks for testing.  I'll send the fix upstream shortly.

NeilBrown


--Sig_/z_dD6UR95Ofy98mX3Ap9iip
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUssyOznsnt1WYoG5AQIiSBAAqXNlfThDaZBkjkhO+pCtIfT3CcoE1e7x
YqrBB91fC84HBmrs+QEc5Vk7jwNaRCOwryNMoq7Vjoi0Hv7deXh14XDUWmmyqdss
FSdD7l0z94sQhOown3G0JRspi7q8epZ14TozofrWOhksyK0F0NMD6CiQeVN/g0eu
2PRvidChlA4oL90tKo235ZwUL50QN7nC9g9xnOu55naEceRPiuHAgvXVqhTM83cA
VpkemYxaljtst6MNi3LVW7Ru6siY3WphIYe3iTGSq/VA5lkqPZ51LrU66AIgrIsC
CwbcRDefFOh/yoNsTbMUs0U+wNy9bT63CnVA6iGN9FgX842WBtsGTk3iarpetD9L
y0dnwvYup5IkWjlIbtpUTZD5FKU219TQzdJ+Mku3j3MdRDZ7ZFa3twLBo/2Vu74k
XQWUlEvLy+E3asnOFsMVl/lx40qAk698seKINVrTP+euHzyYpAzun+wvPRdhYWgH
Kvb+niC8iIWfmMovll3PX4JRI7NKI8hVgehE4LqKQWZ0oA4ALmnWDALOul4kz2R7
2r67V/kyiY0W8BN923Ul5Y3iQU5XxCI85Yd9SQgVzzh4bIsru+GrKzlyvlyNxot+
GknlToo/CeDLQHw5zX95OYdvi/yzb8E/N2602PSy5Hol3Y1okrWB/F5nbL4DA6nk
1s0dzhk1AV0=
=FITW
-----END PGP SIGNATURE-----

--Sig_/z_dD6UR95Ofy98mX3Ap9iip--
