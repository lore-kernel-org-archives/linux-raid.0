From: Michel Wilson <michel@crondor.net>
Subject: RAID1 won't run in degraded mode?
Date: Tue, 4 May 2004 18:41:36 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040504164136.GA2159@aeon.hgd.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I have the following problem with one of my raid1-arrays. One of the
drives has failed, but it isn't being marked as failed. The
reconstruction starts, and at 5% it borks out on the bad sectors. And
then it happily begins reconstructing again...
When I try to mark the drive as faulty, nothing happens. When I try to
hot-remove the drive, it complains about the drive being in use, because
it is reconstructing the array. When I try to start the array with only
one of the drives, it fails:

aeon root # mdadm --assemble /dev/md3 /dev/hde1
mdadm: /dev/md3 assembled from 0 drives - not enough to start it (use --run=
 to insist).
aeon root # mdadm --assemble --run /dev/md3 /dev/hde1
mdadm: failed to RUN_ARRAY /dev/md3: Invalid argument

And in the syslog, it says

May  4 18:26:02 [kernel] md: bind<hde1>
May  4 18:26:02 [kernel] raid1: no operational mirrors for md3

After the last command, in /proc/mdstat, it says

md3 : inactive hde1[2]
      120060736 blocks

and I can't do anything with it. When I do

aeon root # mdadm --manage --run /dev/md3
mdadm: failed to run array /dev/md3: Invalid argument
May  4 18:35:23 [kernel] md: bug in file drivers/md/md.c, line 1512

So, how do I tell the stupid thing to just run it in degraded mode, and
be happy with just one drive?

Any help would be greatly appreciated.

Regards,

Michel Wilson.
--=20
Michel Wilson     michel@crondor.net
PGP key ID        0xD2CB4B7E

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAl8fAL2ru+9LLS34RAr2uAJ9vIdCe/RWyr/exiemSt+gRkq1AtwCgiIkc
6j9wY8ztsGYH6R4nk1/5UiQ=
=iZEU
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
