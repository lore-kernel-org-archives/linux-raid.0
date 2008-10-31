From: martin f krafft <madduck@debian.org>
Subject: Debian and udev (was: RFC - device names and mdadm with some
	reference to udev.)
Date: Fri, 31 Oct 2008 21:54:34 +0100
Message-ID: <20081031205434.GB9554@piper.oerlikon.madduck.net>
References: <18692.62860.863118.727187@notabene.brown> <ac3eb2510810270541g2ac57bd1p5576f15959e849e@mail.gmail.com> <18694.19834.523955.697048@notabene.brown> <ac3eb2510810271703k7d9c97caob0f1d2eee28b8b7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3lcZGd9BuhuYXNfi"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ac3eb2510810271703k7d9c97caob0f1d2eee28b8b7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Kay Sievers <kay.sievers@vrfy.org> [2008.10.28.0103 +0100]:
> All stuff in /lib/udev/rules.d/ is not marked as "config" in the
> package and will be overwritten with a udev update, regardless if the
> content has been edited or not. We moved the "default" rules there
> because people edited the files in /etc and wondered why stuff broke
> in weird ways on updates. /etc/udev/rules.d/ is for "user rules" or
> on-the-fly created system specific ones, like persistent net names and
> cdrom rules. In an ideal setup you would be able to do rm -rf
> /etc/udev/rules.d/*, reboot, and start device configuration from
> scratch.
>=20
> Debian didn't catch up the last months, they use an older version of
> udev, and have always had thier very own idea of rules, that didn't
> match the udev default.

Debian is nearing a release, we have other things to worry about.

But to clarify Kay's statement:
yes, we cannot follow the udev default if we accept that users might
want to edit udev rules, even if they risk breaking stuff. We very
specifically discourage the administrator to write to anywhere but
/usr/local and /etc for good reasons. Thus, the rules have to go to
/etc/udev.

--=20
 .''`.   martin f. krafft <madduck@debian.org>
: :'  :  proud Debian developer, author, administrator, and user
`. `'`   http://people.debian.org/~madduck - http://debiansystem.info
  `-  Debian - when you have better things to do than fixing systems
=20
/.ing an issue is like asking an infinite number of monkeys for advice
                                                   -- in #debian-devel

--3lcZGd9BuhuYXNfi
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkLcIkACgkQIgvIgzMMSnX/AACeJIvxN2WNkAewWnL4ojA5Af7f
FtcAoL9Uti3nF9w9oHHAub8kqD6f5Gxy
=6/fb
-----END PGP SIGNATURE-----

--3lcZGd9BuhuYXNfi--
