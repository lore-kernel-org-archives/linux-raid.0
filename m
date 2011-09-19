From: NeilBrown <neilb@suse.de>
Subject: Re: [Patch mdadm-3.2.2] Fix readding of a readwrite drive into a
 writemostly array
Date: Mon, 19 Sep 2011 13:07:31 +1000
Message-ID: <20110919130731.5f11259d@notabene.brown>
References: <4E305A3D.9000001@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ohd1JA4b0UnyBKQ5FOUjIxH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E305A3D.9000001@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ohd1JA4b0UnyBKQ5FOUjIxH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Jul 2011 14:34:37 -0400 Doug Ledford <dledford@redhat.com> wrote:

> If you create a two drive raid1 array with one device writemostly, then=20
> fail the readwrite drive, when you add a new device, it will get the=20
> writemostly bit copied out of the remaining device's superblock into=20
> it's own.  You can then remove the new drive and readd it as readwrite,=20
> which will work for the readd, but it leaves the stale WriteMostly1 bit=20
> in devflags resulting in the device going back to writemostly on the=20
> next assembly.
>=20
> The fix is to make sure that A) when we readd a device and we might have=
=20
> filled the st->sb info from a running device instead of the device being=
=20
> readded, then clear/set the WriteMostly1 bit in the super1 struct in=20
> addition to setting the disk state (ditto for super0, but slightly=20
> different mechanism) and B) when adding a clean device to an array (when=
=20
> we most certainly did copy the superblock info from an existing device),=
=20
> then clear any writemostly bits.
>=20
> Signed-off-by: Doug Ledford <dledford@redhat.com>

Applied - thanks.

This function really needs to be refactored though - some of that indenting
is WAY too deep!!

Thanks,
NeilBrown



diff -up mdadm-3.2.2/Manage.c.writemostly mdadm-3.2.2/Manage.c
--- mdadm-3.2.2/Manage.c.writemostly	2011-06-13 22:50:01.000000000 -0400
+++ mdadm-3.2.2/Manage.c	2011-07-27 14:12:18.629889841 -0400
@@ -741,11 +741,24 @@ int Manage_subdevs(char *devname, int fd
 						remove_partitions(tfd);
 						close(tfd);
 						tfd =3D -1;
-						if (update) {
+						if (update || dv->writemostly > 0) {
 							int rv =3D -1;
 							tfd =3D dev_open(dv->devname, O_RDWR);
+							if (tfd < 0) {
+								fprintf(stderr, Name ": failed to open %s for"
+									" superblock update during re-add\n", dv->devname);
+								return 1;
+							}
=20
-							if (tfd >=3D 0)
+							if (dv->writemostly =3D=3D 1)
+								rv =3D st->ss->update_super(
+									st, NULL, "writemostly",
+									devname, verbose, 0, NULL);
+							if (dv->writemostly =3D=3D 2)
+								rv =3D st->ss->update_super(
+									st, NULL, "readwrite",
+									devname, verbose, 0, NULL);
+							if (update)
 								rv =3D st->ss->update_super(
 									st, NULL, update,
 									devname, verbose, 0, NULL);
diff -up mdadm-3.2.2/mdadm.h.writemostly mdadm-3.2.2/mdadm.h
--- mdadm-3.2.2/mdadm.h.writemostly	2011-07-27 14:12:28.800779575 -0400
+++ mdadm-3.2.2/mdadm.h	2011-07-27 14:04:34.669932148 -0400
@@ -646,6 +646,8 @@ extern struct superswitch {
 	 *   linear-grow-new - add a new device to a linear array, but don't
 	 *                   change the size: so superblock still matches
 	 *   linear-grow-update - now change the size of the array.
+	 *   writemostly - set the WriteMostly1 bit in the superblock devflags
+	 *   readwrite - clear the WriteMostly1 bit in the superblock devflags
 	 */
 	int (*update_super)(struct supertype *st, struct mdinfo *info,
 			    char *update,
diff -up mdadm-3.2.2/super0.c.writemostly mdadm-3.2.2/super0.c
--- mdadm-3.2.2/super0.c.writemostly	2011-06-17 01:15:50.000000000 -0400
+++ mdadm-3.2.2/super0.c	2011-07-27 14:12:18.655889559 -0400
@@ -570,6 +570,10 @@ static int update_super0(struct supertyp
 		sb->state &=3D ~(1<<MD_SB_BITMAP_PRESENT);
 	} else if (strcmp(update, "_reshape_progress")=3D=3D0)
 		sb->reshape_position =3D info->reshape_progress;
+	else if (strcmp(update, "writemostly")=3D=3D0)
+		sb->state |=3D (1<<MD_DISK_WRITEMOSTLY);
+	else if (strcmp(update, "readwrite")=3D=3D0)
+		sb->state &=3D ~(1<<MD_DISK_WRITEMOSTLY);
 	else
 		rv =3D -1;
=20
@@ -688,6 +692,8 @@ static int add_to_super0(struct supertyp
 	dk->minor =3D dinfo->minor;
 	dk->raid_disk =3D dinfo->raid_disk;
 	dk->state =3D dinfo->state;
+	/* In case our source disk was writemostly, don't copy that bit */
+	dk->state &=3D ~(1<<MD_DISK_WRITEMOSTLY);
=20
 	sb->this_disk =3D sb->disks[dinfo->number];
 	sb->sb_csum =3D calc_sb0_csum(sb);
diff -up mdadm-3.2.2/super1.c.writemostly mdadm-3.2.2/super1.c
--- mdadm-3.2.2/super1.c.writemostly	2011-06-17 01:15:50.000000000 -0400
+++ mdadm-3.2.2/super1.c	2011-07-27 14:12:18.656889548 -0400
@@ -803,6 +803,10 @@ static int update_super1(struct supertyp
 		       __le64_to_cpu(sb->data_size));
 	} else if (strcmp(update, "_reshape_progress")=3D=3D0)
 		sb->reshape_position =3D __cpu_to_le64(info->reshape_progress);
+	else if (strcmp(update, "writemostly")=3D=3D0)
+		sb->devflags |=3D WriteMostly1;
+	else if (strcmp(update, "readwrite")=3D=3D0)
+		sb->devflags &=3D ~WriteMostly1;
 	else
 		rv =3D -1;
=20
@@ -923,6 +927,7 @@ static int add_to_super1(struct supertyp
 		sb->max_dev =3D __cpu_to_le32(dk->number+1);
=20
 	sb->dev_number =3D __cpu_to_le32(dk->number);
+	sb->devflags =3D 0; /* don't copy another disks flags */
 	sb->sb_csum =3D calc_sb_1_csum(sb);
=20
 	dip =3D (struct devinfo **)&st->info;

--Sig_/ohd1JA4b0UnyBKQ5FOUjIxH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOdrHzG5fc6gV+Wb0RAs43AJ9WlkQ1nqefdPeHteYY4qKlNo5kkwCdFnFa
6hdo/ljeoiorcBZR/qhiLEY=
=f0iO
-----END PGP SIGNATURE-----

--Sig_/ohd1JA4b0UnyBKQ5FOUjIxH--
