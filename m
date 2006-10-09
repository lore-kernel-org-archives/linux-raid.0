From: Doug Ledford <dledford@redhat.com>
Subject: Re: avoiding the initial resync on --create
Date: Mon, 09 Oct 2006 12:32:00 -0400
Message-ID: <1160411520.2917.76.camel@fc6.xsintricity.com>
References: <20061009125700.GA10191@piper.madduck.net>
	 <20061009134946.GA26122@harddisk-recovery.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DgICZ2YuJ2/OzQVmnHdI"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061009134946.GA26122@harddisk-recovery.com>
Sender: linux-raid-owner@vger.kernel.org
To: Erik Mouw <erik@harddisk-recovery.com>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-DgICZ2YuJ2/OzQVmnHdI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2006-10-09 at 15:49 +0200, Erik Mouw wrote:

> There is no way to figure out what exactly is correct data and what is
> not. It might work right after creation and during the initial install,
> but after the next reboot there is no way to figure out what blocks to
> believe.

You don't really need to.  After a clean install, the operating system
has no business reading any block it didn't write to during the install
unless you are just reading disk blocks for the fun of it.  And any
program that depends on data that hasn't first been written to disk is
just wrong and stupid anyway.

> > Do you have any thoughts on the issue? If Debian were to --create
> > its arrays with --assume-clean just before slapping a filesystem on
> > them and installing the system, do you see any potential problems?
>=20
> If you want to speed up the initial install, I'd say it's better to
> create the array with one missing drive, install the system and let it
> resync upon the next boot. Be sure to tell the user about that, though.
>=20
>=20
> Erik
>=20
--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-DgICZ2YuJ2/OzQVmnHdI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFKnmATzP9PM7pjw8RAlf/AJ4oNa+kVmmRsyjaQJ9WyTmMWZYxMgCfRwxl
nyr2tpKKjp4QpuLEVBIO4w8=
=8XTQ
-----END PGP SIGNATURE-----

--=-DgICZ2YuJ2/OzQVmnHdI--

