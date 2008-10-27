From: martin f krafft <madduck@debian.org>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Mon, 27 Oct 2008 17:59:49 +0100
Message-ID: <20081027165949.GC3061@piper.oerlikon.madduck.net>
References: <18692.62860.863118.727187@notabene.brown> <20081027082257.GB1801@piper.oerlikon.madduck.net> <1225120416.4845.128.camel@firewall.xsintricity.com> <20081027161000.GG17300@skl-net.de> <ac3eb2510810270937i3acd7c94r2817b8f4c79babec@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R+My9LyyhiUvIEro"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ac3eb2510810270937i3acd7c94r2817b8f4c79babec@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andre Noll <maan@systemlinux.org>, Doug Ledford <dledford@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids


--R+My9LyyhiUvIEro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Kay Sievers <kay.sievers@vrfy.org> [2008.10.27.1737 +0100]:
> It's very simple to setup and follows the same logic as udev running
> in the rootfs, There is absolutely no "increase of complexity"
> involved if you use udev in the real root anyway, you just copy the
> binaries and the rules, and on bootup you wait for /dev/root to show
> up, mount it and start /sbin/init. Custom busybox stuff does not
> support any non-trivial feature a "general purpose" distro needs to
> support today.

I would love to see some explicit instructions, then I could carry
them into Debian, which is currently using full-blown udev with
initramfs.

--=20
 .''`.   martin f. krafft <madduck@debian.org>
: :'  :  proud Debian developer, author, administrator, and user
`. `'`   http://people.debian.org/~madduck - http://debiansystem.info
  `-  Debian - when you have better things to do than fixing systems
=20
"if ever somethin' don't feel right to you, remember what pancho said
 to the cisco kid...  `let's win, before we are dancing at the end of
 a rope, without music.'"
                                                             -- sailor

--R+My9LyyhiUvIEro
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkF84QACgkQIgvIgzMMSnXu2gCggSVT+3GxAENY91SkdNrB3zcw
F70An1/3j5kTSwcD0LVwVvcJO5K/lSjt
=ZPq3
-----END PGP SIGNATURE-----

--R+My9LyyhiUvIEro--
