From: Andre Noll <maan@systemlinux.org>
Subject: Re: auto-assembling arrays without a configuration file
Date: Mon, 10 Mar 2008 16:08:45 +0100
Message-ID: <20080310150845.GF32242@skl-net.de>
References: <20080308004009.GA32251@rap.rap.dk> <18388.27742.907731.241140@notabene.brown> <20080310134828.GF9348@rap.rap.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z0eOaCaDLjvTGF2l"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080310134828.GF9348@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--z0eOaCaDLjvTGF2l
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14:48, Keld J=F8rn Simonsen wrote:

> Hmm, I am still looking for a way to boot a lin=FAx raid as root.

Here's an init script that works for me on a server that has its root
partition on a software raid5 on /dev/md1. It uses busybox for all
commands except mdadm.

	#! /bin/sh
	export PATH=3D/bin:/sbin
	echo initramfs startup

	cat > /etc/fstab << EOF
	proc /proc proc defaults 0 0
	sysfs /sys sysfs rw 0 0
	EOF

	cat > /etc/mdev.conf << EOF
	null 0:0 666
	ptmx 0:0 666
	EOF

	mount /proc
	mount /sys
	mdev -s
	mknod /dev/md1 b 9 1
	echo 'DEVICE partitions' > /etc/mdadm/mdadm.conf
	mdadm -E --scan >> /etc/mdadm/mdadm.conf
	mdadm -A --scan || sh
	mount -oro /dev/md1 /mnt || sh
	mount --move /proc /mnt/proc
	mount --move /sys /mnt/sys
	cd /mnt
	mount --move . /
	exec chroot . /sbin/init 2 > /dev/console 2>/dev/console < /dev/console

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--z0eOaCaDLjvTGF2l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH1U79Wto1QDEAkw8RAtc8AJ9g0Cw9lhPeju6Fw1F84TiOjlhJ6wCfcrNt
1C64hr7kMgCrCrSufhSvZBI=
=6VbT
-----END PGP SIGNATURE-----

--z0eOaCaDLjvTGF2l--
