From: Andre Noll <maan@systemlinux.org>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Mon, 27 Oct 2008 17:10:00 +0100
Message-ID: <20081027161000.GG17300@skl-net.de>
References: <18692.62860.863118.727187@notabene.brown> <20081027082257.GB1801@piper.oerlikon.madduck.net> <1225120416.4845.128.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MrRUTeZlqqNo1jQ9"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1225120416.4845.128.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: martin f krafft <madduck@debian.org>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Michal Marek <mmarek@novell.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-raid.ids


--MrRUTeZlqqNo1jQ9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11:13, Doug Ledford wrote:

> > I would really like to have a clear separation of competencies.
> > Ideally, mdadm never creates any devices but leaves it all to udev,
> > and all configuration about alternate names ("symlinks") is done in
> > the udev rules file.
>=20
> This would then require that we have a working udev in our initrd
> images.  It would greatly increase the complexity of early booting as a
> result.

Given that the initramfs usually contains busybox, one can also using
mdev. It's much simpler than udev and it's good enough if the only
thing you want to do is mounting the root partition that resides on
a software raid array.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--MrRUTeZlqqNo1jQ9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJBefXWto1QDEAkw8RAmFuAKCks6CDcamEsdhg9klviG9KlNsxvgCglcCk
XyDr653eN5apowTi5rD7Iy8=
=xi88
-----END PGP SIGNATURE-----

--MrRUTeZlqqNo1jQ9--
