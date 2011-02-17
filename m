From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Linux software RAID assistance
Date: Thu, 17 Feb 2011 20:42:21 +0500
Message-ID: <20110217204221.7a865364@natsu>
References: <4D540F6C.6050904@gmail.com>
	<20110215155315.55d35b8e@notabene.brown>
	<4D5A92F3.1090004@turmel.org>
	<4D5ACE4B.9040309@gmail.com>
	<4D5AD613.3040402@turmel.org>
	<20110216004524.67abe977@natsu>
	<AANLkTikLWmC1u3rMFktwULgSPh-zL+D-xgcyogcJfqnP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_+hBX8RuWkGbV/G3w3j_Tac"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikLWmC1u3rMFktwULgSPh-zL+D-xgcyogcJfqnP@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Mcnair <simonmcnair@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/_+hBX8RuWkGbV/G3w3j_Tac
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Feb 2011 15:10:32 +0000
Simon Mcnair <simonmcnair@gmail.com> wrote:

> proxmox:~# dpkg -S blkid
> libblkid1: /lib/libblkid.so.1.0
> libblkid1: /lib/libblkid.so.1
> libblkid1: /usr/share/doc/libblkid1/changelog.Debian.gz
> libblkid1: /usr/share/doc/libblkid1/copyright
> libblkid1: /usr/share/doc/libblkid1
> e2fsprogs-dbg: /usr/lib/debug/sbin/blkid
>=20
> proxmox:~# apt-get install e2fsprogs-dbg
> Reading package lists... Done
> Building dependency tree
> Reading state information... Done
> e2fsprogs-dbg is already the newest version.
> 0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
>=20
>=20
> I still can't blkid installed, even though I have e2fsprogs-dbg installed=
...

/usr/lib/debug/sbin/ is not in system 'path', so you won't be able to run t=
he
program just by entering 'blkid' into the shell prompt.
Either use the complete file name and path, e.g.=20

  # /usr/lib/debug/sbin/blkid --help

or symlink /usr/lib/debug/sbin/blkid to something like /usr/local/sbin/blki=
d.

--=20
With respect,
Roman

--Sig_/_+hBX8RuWkGbV/G3w3j_Tac
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1dQd0ACgkQTLKSvz+PZwi34ACferMv2HLit5FOWLHVKKBhrIMj
ZFYAnRRdNLho7QsjqbIXtEjwArdb6fi5
=WojE
-----END PGP SIGNATURE-----

--Sig_/_+hBX8RuWkGbV/G3w3j_Tac--
