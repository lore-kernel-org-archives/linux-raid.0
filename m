From: Markus Hochholdinger <Markus@hochholdinger.net>
Subject: raid1 bitmap=internal fails for specific sizes
Date: Mon, 1 Dec 2008 12:07:31 +0100
Message-ID: <200812011207.35074.Markus@hochholdinger.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1579145.sdldeREJyA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

--nextPart1579145.sdldeREJyA
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

i've hit a weird problem with creating raid1 bitmaps. Setting a internal=20
bitmap while creating a raid1=20
(mdadm --create /dev/mdX --level=3D1 --raid-disks=3D2 --bitmap=3Dinternal /=
dev/vg0/a /dev/vg0/b)=20
or growing a raid1 with a internal bitmap=20
(mdadm --grow /dev/mdX --bitmap=3Dinternal) i a got a failure for specific=
=20
device sizes of /dev/vg0/a and /dev/vg0/b.

The sizes i get errors are 7680MB, 15GB, 30GB, 60GB, 120GB and 240GB. I get=
 no=20
errors with 10GB, 16GB, 17GB, 20GB, 25GB, 29GB, 31GB, 38GB, 40GB, 50GB, 59G=
B,=20
70GB, 75GB and 90GB.

It doesn't matter if i set the bitmap while creating the raid1 or after the=
=20
raid1 is created and synced.

I'm using Debian lenny with mdadm 2.6.7 (2.6.7.1-1) and the problem occurs=
=20
with kernel 2.6.26-1-xen-amd64 and also with kernel 2.6.18 from xensource.

The mdadm message is (while create):
  mdadm: RUN_ARRAY failed: Input/output error
  mdadm: stopped /dev/md9
The kernel message is:
  md: bind<dm-1>
  md: bind<dm-2>
  md: md9: raid array is not clean -- starting background reconstruction
  raid1: raid set md9 active with 2 out of 2 mirrors
  md9: bitmap file is out of date (0 < 1) -- forcing full recovery
  md9: bitmap file is out of date, doing full recovery
  attempt to access beyond end of device
  dm-2: rw=3D16, want=3D31457288, limit=3D31457280
  attempt to access beyond end of device
  dm-1: rw=3D16, want=3D31457288, limit=3D31457280
  md9: bitmap initialized from disk: read 15/16 pages, set 489472 bits,=20
status: -5
  md9: failed to create bitmap (-5)
  md: pers->run() failed ...
  md: md9 stopped.
  md: unbind<dm-2>
  md: export_rdev(dm-2)
  md: unbind<dm-1>
  md: export_rdev(dm-1)

Perhaps the important message is "dm-2: rw=3D16, want=3D31457288, limit=3D3=
1457280"=20
which i think is some sort of rounding error?

Is this some known bug or perhaps is this bug allready fixed (i didn't find=
=20
anything similar on this list)?

=46or now i'll avoid these sizes for raid1.


=2D-=20
greetings

eMHa

--nextPart1579145.sdldeREJyA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBJM8V3XT3LE+AjWCsRAg9QAJ9nNnZ0hsvYXOwjBkMm/uPuNgkeJwCfRSwC
AWrImnis4izNRHX1hQegxL0=
=PkNq
-----END PGP SIGNATURE-----

--nextPart1579145.sdldeREJyA--
