From: Wolfram Schlich <lists@schlich.org>
Subject: Re: "failed-disk" ?
Date: Thu, 20 Mar 2003 22:32:18 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030320213218.ALLYOURBASEAREBELONGTOUS.B13060@bla.fasel.org>
References: <20030320212250.GO13201@rdlg.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030320212250.GO13201@rdlg.net>
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Robert L. Harris <Robert.L.Harris@rdlg.net> [2003-03-20 22:25]:
>=20
>=20
> I'm trying to "mkraid /dev/md1" with the following:
>=20
> raiddev /dev/md1
>   raid-level 1
>   nr-raid-disks 2
>   nr-spare-disks 0
>   chunk-size 16
>   persistent-superblock 1
>   device failed-disk
>   raid-disk 0
>   device /dev/sdb1
>   raid-disk 1
>=20
> I'm trying to convert this machine to raid1 on root.  Don't ask about
> the md1, long story.  At any rate when I do the mkraid I get this:
>=20
> root@rharris-build2:~# mkraid /dev/md1
> handling MD device /dev/md1
> analyzing super-block
> couldn't call stat() on device failed-disk -- No such file or directory
> mkraid: aborted, see the syslog and /proc/mdstat for potential clues.
>=20
> root@rharris-build2.acs:~# mkraid -V
> mkraid version 0.90.0
>=20
> Thoughts?

You need to use "failed-disk" in place of "raid-disk", not anywhere
else :-)

E.g.:
--8<--
device /some/dev1
raid-disk 0

device /some/dev2
failed-fisk 1
--8<--
--=20
Wolfram Schlich; Friedhofstr. 8, D-88069 Tettnang; +49-(0)178-SCHLICH

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+ejNi06HFHc1N8gURApPIAKCQiCHybk15iNEqSzwKnspPB0xsFACfQzss
+pKQwqjFQRtacwVTGDWkOpI=
=S/G4
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
