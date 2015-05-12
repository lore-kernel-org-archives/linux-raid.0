From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Installing Linux directly onto RAID6 Array...........
Date: Tue, 12 May 2015 17:31:47 +0500
Message-ID: <20150512173147.0d2c3363@natsu>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com>
	<5551D3F2.8020007@grumpydevil.homelinux.org>
	<5551F01A.4050705@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5CfbIugfEuo.DHe2ts+dVa/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5551F01A.4050705@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, Another Sillyname <anothersname@googlemail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/5CfbIugfEuo.DHe2ts+dVa/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 12 May 2015 08:20:42 -0400
Phil Turmel <philip@turmel.org> wrote:

> > Doing something like that... and using network boot to solve those issu=
es
> >=20
> > Last i tried grub2 could not handle a raid6 directly (could be changed =
now)
>=20
> You could also boot from a USB device, possibly one that memory caches
> its root filesystem (like System Rescue CD).

Just place GRUB and the /boot partition with kernel and initrd on a USB sti=
ck,
the rest (root FS) can be on RAID6. That's what I do on one machine.

--=20
With respect,
Roman

--Sig_/5CfbIugfEuo.DHe2ts+dVa/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlVR8rMACgkQTLKSvz+PZwi8NACfYEPJO8g388QIhN1Hu4n/91T/
OOUAn0wDP1vClwmtd9EjPX0Wr6NPB0L9
=PYkV
-----END PGP SIGNATURE-----

--Sig_/5CfbIugfEuo.DHe2ts+dVa/--
