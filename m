From: Andre Noll <maan@systemlinux.org>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Mon, 27 Oct 2008 18:30:28 +0100
Message-ID: <20081027173028.GH17300@skl-net.de>
References: <18692.62860.863118.727187@notabene.brown> <20081027082257.GB1801@piper.oerlikon.madduck.net> <1225120416.4845.128.camel@firewall.xsintricity.com> <20081027161000.GG17300@skl-net.de> <ac3eb2510810270937i3acd7c94r2817b8f4c79babec@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uJrvpPjGB3z5kYrA"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ac3eb2510810270937i3acd7c94r2817b8f4c79babec@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Doug Ledford <dledford@redhat.com>, martin f krafft <madduck@debian.org>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids


--uJrvpPjGB3z5kYrA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17:37, Kay Sievers wrote:
> >> This would then require that we have a working udev in our initrd
> >> images.  It would greatly increase the complexity of early booting as a
> >> result.
> >
> > Given that the initramfs usually contains busybox, one can also using
> > mdev. It's much simpler than udev and it's good enough if the only
> > thing you want to do is mounting the root partition that resides on
> > a software raid array.
>=20
> Depends on your definition of "usual". Debian, Fedora, openSUSE,
> Ubuntu, Gentoo (as far as Gentoo counts as a distro with a default
> setup) none of them uses any busybox/mdev setup, and all use udev in
> initramfs.

At least Ubuntu's initramfs contains busybox and starts up a shell
during initramfs startup if the root partition could not be mounted.

Anyway, my point is that it's currently possible to mount a root
partition that resides on an md device without using udev.  Even plain
mknod instead of mdev is enough if you know exactly which device node
you have to create.

Of course you might want to do that only if your system doesn't boot
anymore. But I think it's important that in this rescue situation
also the new mdadm can bring up the system without support from udev.

In short: It's good to be able to do the plumbing manually in case
the porcelain isn't flushing.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--uJrvpPjGB3z5kYrA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJBfq0Wto1QDEAkw8RAkFpAJ0WSQbHlASYahmea51kI7S1yX9s6gCdFysf
IsIQgX3hdjqwPZNDczJSFUM=
=+FXe
-----END PGP SIGNATURE-----

--uJrvpPjGB3z5kYrA--
