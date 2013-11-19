From: NeilBrown <neilb@suse.de>
Subject: Re: MDADM 3.3 broken?
Date: Wed, 20 Nov 2013 10:51:15 +1100
Message-ID: <20131120105115.27494ab6@notabene.brown>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>
	<528A7721.8080604@arcor.de>
	<CAGRSmLvRVQtrkYPLS8NfRS+DvyS0xZ72cwVdLygb0w5KbVrARA@mail.gmail.com>
	<20131119110110.396b2af3@notabene.brown>
	<528BBFEB.7050202@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Iamt99lmEDk8Mtf=8CgUVW6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <528BBFEB.7050202@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: "David F." <df7729@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Iamt99lmEDk8Mtf=8CgUVW6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Nov 2013 20:45:47 +0100 Martin Wilck <mwilck@arcor.de> wrote:

> On 11/19/2013 01:01 AM, NeilBrown wrote:
> > On Mon, 18 Nov 2013 15:13:58 -0800 "David F." <df7729@gmail.com> wrote:
> >=20
> >=20
> >> output of 'mdadm --assemble --scan --no-degraded -v' (mdadm 3.2.6):
> > ...
> >> mdadm: no RAID superblock on /dev/sdc2
> >=20
> >=20
> >=20
> >>
> >> output1 of 'mdadm --assemble --scan --no-degraded -v' (mdadm 3.3 -
> >> note using /dev/sdc2, not /dev/sdc):
> > .....
> >> mdadm: /dev/sdc2 is identified as a member of /dev/md/imsm0, slot -1.
> >=20
> > So there is the problem.  mdadm 3.2.6 sees no RAID superblock on sdc2, =
while
> > mdadm 3.3 does (but should not).
> >=20
> >=20
> > However that code hasn't changed!
> >=20
> > load_super_imsm() still starts with:
> >=20
> >=20
> > 	if (test_partition(fd))
> > 		/* IMSM not allowed on partitions */
> > 		return 1;
>=20
> Well not quite - you changed that code in commit b31df436 "intel,ddf:
> don't require partitions when ignore_hw_compat is set". Maybe there's
> something wrong with that ignore_hw_compat logic?
>=20
> In the strace I don't see indication of test_partition having been
> called, that's another hint in that direction.
>=20

Yes... I seems I was accidentally looking at an old version of mdadm.

I've just committed the following patch which should fix the problem.

(git clone git://neil.brown.name/mdadm/ ; cd mdadm ; make;make install)

Thanks,
NeilBrown

=46rom 357ac1067835d1cdd5f80acc28501db0ffc64957 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 20 Nov 2013 10:49:14 +1100
Subject: [PATCH] IMSM metadata really should be ignored when found on
 partitions.

commit b31df43682216d1c65813eae49ebdd8253db8907
changed load_super_imsm to not insist on finding a partition if
ignore_hw_compat was set.
Unfortunately this is set for '--assemble' so arrays could get
assembled badly.

The comment says this was to allow e.g. --examine of image files.
A better fixes for this is to change test_partitions to not report
a regular file as being a partition.
The errors from the BLKPG ioctl are:

 ENOTTY : not a block device.
 EINVAL : not a whole device (probably a partition)
 ENXIO  : partition doesn't exist (so not a partition)

Reported-by: "David F." <df7729@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/super-intel.c b/super-intel.c
index 7b2406866493..c103ffdd2dd8 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4423,7 +4423,7 @@ static int load_super_imsm(struct supertype *st, int =
fd, char *devname)
 	struct intel_super *super;
 	int rv;
=20
-	if (!st->ignore_hw_compat && test_partition(fd))
+	if (test_partition(fd))
 		/* IMSM not allowed on partitions */
 		return 1;
=20
diff --git a/util.c b/util.c
index 5f95f1f97c02..b29a3ee7ce47 100644
--- a/util.c
+++ b/util.c
@@ -307,7 +307,7 @@ int test_partition(int fd)
 	if (ioctl(fd, BLKPG, &a) =3D=3D 0)
 		/* Very unlikely, but not a partition */
 		return 0;
-	if (errno =3D=3D ENXIO)
+	if (errno =3D=3D ENXIO || errno =3D=3D ENOTTY)
 		/* not a partition */
 		return 0;
=20

--Sig_/Iamt99lmEDk8Mtf=8CgUVW6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUov5cznsnt1WYoG5AQIsIxAAiGbW/5lSiiwBSvawAeclC5NSv7mfQWC3
F5jJVIpqXKQFKVbewvDcdHBSbeIeVuMu8BQR1wIl26pHd5YwDxcPBLXMYLqdIxey
cqJpK4vGB3Kfe6ruMB9SXkJOH7l/fShZNUY/ASvyfRIvUu65iKsg4LwwLkHq3D/B
U/jRh4MHeuE/sGFX6iWdqXC1Hi7N5nrCxtDNnxPuuPBQ+aPvusfx3aK86R2extLX
2BUvjekzARCM0vO7x2bznPL4dSIQiR59yVYEQOokN4/jNJWyN6FNclVYCJ5zsd3m
uAEWoI7ac6+PzdsrVNYcNIYD6WJJhkwTiypZhrzsn8UFFVIua6C7VXF/T8dgtAkt
5MUqr8BYnsalDHgrso+OovN5bJrT2sN6xVlH2+Y8pmY6uvqPB0/GuBtS7Km+NTz9
7+S9KiWC/Kz8gNNFdcKNY9zjM1R/oMi61nrd1oAYm3ZPjzMpvyB+48PXb9B1gzge
XSi5FUNl0Yh+MeUC37euYQXV033kmWg0D6EYrQOfZBVK76GBV8YiZJbbqhaSURar
J1JXyTIHsEzXrYdz2SUEsvew5kjeikVAHdFJXc75LYY9gVz/IwkRambFUUT2Q1zx
4lgQmjPBLGAyu2nXNMenTsgk/GxuLgRbiGJJDXJARSEFTRoViVHykCAXIQWmdb99
q8OZ+4FR7AM=
=YrGI
-----END PGP SIGNATURE-----

--Sig_/Iamt99lmEDk8Mtf=8CgUVW6--
