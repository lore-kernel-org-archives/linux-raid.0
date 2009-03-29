From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: raid5 degraded twice, what happened here?
Date: Sun, 29 Mar 2009 22:38:20 +0200
Message-ID: <200903292238.23416.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1276764.pYbuyAQoSF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--nextPart1276764.pYbuyAQoSF
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

During the last two weeks my raid5 array degraded while shutting down.
Here's what happened at shutdown last time according to logs:

Mar 29 05:16:27 xerxes shutdown[5690]: shutting down for system halt
Mar 29 05:16:58 xerxes kernel:          res=20
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 29 05:16:58 xerxes kernel: ata3: soft resetting port
Mar 29 05:17:03 xerxes kernel: ata3: port is slow to respond, please be=20
patient (Status 0xd0)
Mar 29 05:17:07 xerxes kernel: ata3: SATA link up 1.5 Gbps (SStatus 113=20
SControl 310)
Mar 29 05:17:37 xerxes kernel: ata3.00: qc timeout (cmd 0xec)
Mar 29 05:17:37 xerxes kernel: ata3.00: failed to IDENTIFY (I/O error,=20
err_mask=3D0x4)
Mar 29 05:17:37 xerxes kernel: ata3: failed to recover some devices, retryi=
ng=20
in 5 secs
Mar 29 05:17:42 xerxes kernel: ata3: hard resetting port
Mar 29 05:17:48 xerxes kernel: ata3: port is slow to respond, please be=20
patient (Status 0xff)
Mar 29 05:17:52 xerxes kernel: ata3: SATA link up 1.5 Gbps (SStatus 113=20
SControl 310)
Mar 29 05:17:52 xerxes kernel: ata3.00: failed to IDENTIFY (I/O error,=20
err_mask=3D0x3)
Mar 29 05:17:52 xerxes kernel: ata3.00: limiting speed to UDMA/100:PIO3
Mar 29 05:17:52 xerxes kernel: ata3: failed to recover some devices, retryi=
ng=20
in 5 secs
Mar 29 05:17:57 xerxes kernel: ata3: hard resetting port
Mar 29 05:18:02 xerxes kernel: ata3: port is slow to respond, please be=20
patient (Status 0xff)
Mar 29 05:18:06 xerxes kernel: ata3: SATA link up 1.5 Gbps (SStatus 113=20
SControl 310)
Mar 29 05:18:06 xerxes kernel: ata3.00: failed to IDENTIFY (I/O error,=20
err_mask=3D0x3)
Mar 29 05:18:06 xerxes kernel: ata3.00: disabled
Mar 29 05:18:07 xerxes kernel: ata3: EH complete
Mar 29 05:18:07 xerxes kernel: sd 2:0:0:0: [sdb] Result:=20
hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK,SUGGEST_OK
Mar 29 05:18:07 xerxes kernel: end_request: I/O error, dev sdb, sector=20
976751807
Mar 29 05:18:07 xerxes kernel: md: super_written gets error=3D-5, uptodate=
=3D0
Mar 29 05:18:07 xerxes kernel: RAID5 conf printout:


What is this? Controller screwup? Disk oops? Software thing?

Debian Etch r7, mdadm 2.5.6.

Dex


=2D-=20
=2D----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@=20
b++(+++) DI+++ D- G++ e* h>++ r* y?
=2D-----END GEEK CODE BLOCK------

http://www.vorratsdatenspeicherung.de

--nextPart1276764.pYbuyAQoSF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBJz9w/m6TdMk9WhQ0RArJGAKDMbHuAtzWmvpxhMbKUaI35yBLYLgCfdmtq
Lit+IL8jvJHmaZcZMKL/uOY=
=KQVw
-----END PGP SIGNATURE-----

--nextPart1276764.pYbuyAQoSF--
