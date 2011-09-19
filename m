From: NeilBrown <neilb@suse.de>
Subject: Re: [Patch mdadm-3.2.2] Fix the fix for the readd bug
Date: Mon, 19 Sep 2011 13:06:23 +1000
Message-ID: <20110919130623.28c29250@notabene.brown>
References: <4E30594B.9030306@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OVUfIGYWhf.XjtF2vIl0h2H"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E30594B.9030306@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/OVUfIGYWhf.XjtF2vIl0h2H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Jul 2011 14:30:35 -0400 Doug Ledford <dledford@redhat.com> wrote:

> The readd bug fix didn't work due to a faulty test.  We need to check=20
> raid_disks to get an upper bound of the found slots to check since=20
> nr_disks only counts good disks and we could have faulty or spares that=20
> aren't counted but amount to an occupied slot.
>=20
> Signed-off-by: Doug Ledford <dledford@redhat.com>

Sorry for late review.

I don't agree with this patch.
'nr_disks' is exactly the number of devices in the mddev->disks list in the
kernel.   get_array_info() counts them.  This includes failed and spare
devices.

When GET_DISK_INFO is used, these devices will return a meaningful
major/minor and all others will return '0' for major and minor.
So the code should work as is.

Do you remember if you had a case where this failed?  Can you describe it?
Can you reproduce it?
Thanks,
NeilBrown


--- mdadm-3.2.2/util.c.readd	2011-06-17 01:15:50.000000000 -0400
+++ mdadm-3.2.2/util.c	2011-07-18 14:43:40.776150946 -0400
@@ -364,19 +364,21 @@ int enough_fd(int fd)
 	struct mdu_disk_info_s disk;
 	int avail_disks =3D 0;
 	int i;
+	int raid_disks;
 	char *avail;
=20
 	if (ioctl(fd, GET_ARRAY_INFO, &array) !=3D 0 ||
 	    array.raid_disks <=3D 0)
 		return 0;
 	avail =3D calloc(array.raid_disks, 1);
-	for (i=3D0; i < 1024 && array.nr_disks > 0; i++) {
+	raid_disks =3D array.raid_disks;
+	for (i=3D0; i < 1024 && raid_disks > 0; i++) {
 		disk.number =3D i;
 		if (ioctl(fd, GET_DISK_INFO, &disk) !=3D 0)
 			continue;
 		if (disk.major =3D=3D 0 && disk.minor =3D=3D 0)
 			continue;
-		array.nr_disks--;
+		raid_disks--;
=20
 		if (! (disk.state & (1<<MD_DISK_SYNC)))
 			continue;

--Sig_/OVUfIGYWhf.XjtF2vIl0h2H
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOdrGvG5fc6gV+Wb0RAkRIAKCfxnWbnKOPkxlS5mmb2jCnSg16lwCfditJ
X6D7ax3M5tVyIrKB+Lxr90Y=
=bXOZ
-----END PGP SIGNATURE-----

--Sig_/OVUfIGYWhf.XjtF2vIl0h2H--
