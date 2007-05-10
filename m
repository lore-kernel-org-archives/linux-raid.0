From: Benjamin Schieder <blindcoder@scavenger.homeip.net>
Subject: Re: "No such device" on --remove
Date: Thu, 10 May 2007 07:28:45 +0200
Message-ID: <20070510052845.GA13472@scavenger.homeip.net>
References: <20070508170441.GB4333@scavenger.homeip.net> <f1sc2p$33q$1@sea.gmane.org> <46423BCF.3080702@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46423BCF.3080702@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.05.2007 01:23:27, Michael Tokarev wrote:
> Bernd Schubert wrote:
> > Benjamin Schieder wrote:
> >=20
> >=20
> >> root@crazyhorse:~# mdadm /dev/md/2 -r /dev/hdh5
> >> mdadm: hot remove failed for /dev/hdh5: No such device
> >>
> >> md1 and md2 are supposed to be raid5 arrays.
> >=20
> > You are probably using udev, don't you? Somehow there's presently
> > no /dev/hdh5, but to remove /dev/hdh5 out of the raid, mdadm needs this
> > device. There's a workaround, you need to create the device in /dev usi=
ng
> > mknod and then you can remove it with mdadm.
>=20
> In case the /dev/hdh5 device node is missing, mdadm will complain
> "No such file or directory" (ENOENT), instead of "No such device"
> (ENODEV).
>=20
> In this case, as I explained in my previous email, the arrays aren't
> running, and the error refers to manipulations (md ioctls) with existing
> /dev/md/2.
>=20
> It has nothing to do with udev.

Ah, that's good to know. I also thought that it couldn't find /dev/hdh5 from
the error message given.

The --force to -A worked fine, btw. Thanks for your help!


Greetings,
	Benjamin
--=20
Benjamin 'blindCoder' Schieder
Registered Linux User #289529: http://counter.li.org
finger blindcoder@scavenger.homeip.net | gpg --import
--=20
/lusr/bin/brain: received signal: SIGIDIOT

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGQq2NAsME5O4xgqgRAtoCAJ9qdqgEil/50Nd0YUNpjlxha2rNdgCg07c9
E27Hnt3fZZ0wTRa7g9ykDNg=
=a9x2
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
