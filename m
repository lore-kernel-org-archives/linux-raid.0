From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Fix race between --create and --incremental
Date: Thu, 10 Apr 2014 10:33:37 +1000
Message-ID: <20140410103337.30c9dc7c@notabene.brown>
References: <1397056499-6743-1-git-send-email-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2hRNIv/LLuCY1KcKLXrc.pg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1397056499-6743-1-git-send-email-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/2hRNIv/LLuCY1KcKLXrc.pg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  9 Apr 2014 17:14:59 +0200 Artur Paszkiewicz
<artur.paszkiewicz@intel.com> wrote:

> This modifies locking in Create to eliminate a situation where
> --incremental can assemble a device between write_init_super() and
> add_disk(), which causes Create to fail.
>=20
> It sporadically occurs e.g. when metadata is written on a device,
> causing an udev change event which triggers mdadm --incremental.
>=20
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

Thanks for the patch.
I've taken the liberty of changing it a little.  I didn't like the fact that
we dropped the lock and then took it again.  It probably doesn't matter, but
it feels cleaner to hold it the whole time.

So this is the result.  Let me know if you disagree at all.

Thanks,
NeilBrown

=46rom a22b82ef078a37f98e0a08c23dca32fa38792d97 Mon Sep 17 00:00:00 2001
From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Date: Wed, 9 Apr 2014 17:14:59 +0200
Subject: [PATCH] Fix race between --create and --incremental

This modifies locking in Create to eliminate a situation where
--incremental can assemble a device between write_init_super() and
add_disk(), which causes Create to fail.

It sporadically occurs e.g. when metadata is written on a device,
causing an udev change event which triggers mdadm --incremental.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Create.c b/Create.c
index 9247d46bbfac..98bbdd40a161 100644
--- a/Create.c
+++ b/Create.c
@@ -740,7 +740,9 @@ int Create(struct supertype *st, char *mddev,
=20
 	map_update(&map, fd2devnm(mdfd), info.text_version,
 		   info.uuid, chosen_name);
-	map_unlock(&map);
+	/* Keep map locked until devices have been added to array
+	 * to stop another mdadm from finding and using those devices.
+	 */
=20
 	if (s->bitmap_file && vers < 9003) {
 		major_num =3D BITMAP_MAJOR_HOSTENDIAN;
@@ -753,18 +755,18 @@ int Create(struct supertype *st, char *mddev,
 	if (s->bitmap_file && strcmp(s->bitmap_file, "internal")=3D=3D0) {
 		if ((vers%100) < 2) {
 			pr_err("internal bitmaps not supported by this kernel.\n");
-			goto abort;
+			goto abort_locked;
 		}
 		if (!st->ss->add_internal_bitmap) {
 			pr_err("internal bitmaps not supported with %s metadata\n",
 				st->ss->name);
-			goto abort;
+			goto abort_locked;
 		}
 		if (!st->ss->add_internal_bitmap(st, &s->bitmap_chunk,
 						 c->delay, s->write_behind,
 						 bitmapsize, 1, major_num)) {
 			pr_err("Given bitmap chunk size not supported.\n");
-			goto abort;
+			goto abort_locked;
 		}
 		s->bitmap_file =3D NULL;
 	}
@@ -790,7 +792,7 @@ int Create(struct supertype *st, char *mddev,
 		if (container_fd < 0) {
 			pr_err("Cannot get exclusive "
 				"open on container - weird.\n");
-			goto abort;
+			goto abort_locked;
 		}
 		if (mdmon_running(st->container_devnm)) {
 			if (c->verbose)
@@ -805,7 +807,7 @@ int Create(struct supertype *st, char *mddev,
 	if (rv) {
 		pr_err("failed to set array info for %s: %s\n",
 			mddev, strerror(errno));
-		goto abort;
+		goto abort_locked;
 	}
=20
 	if (s->bitmap_file) {
@@ -816,18 +818,18 @@ int Create(struct supertype *st, char *mddev,
 				 c->delay, s->write_behind,
 				 bitmapsize,
 				 major_num)) {
-			goto abort;
+			goto abort_locked;
 		}
 		bitmap_fd =3D open(s->bitmap_file, O_RDWR);
 		if (bitmap_fd < 0) {
 			pr_err("weird: %s cannot be openned\n",
 				s->bitmap_file);
-			goto abort;
+			goto abort_locked;
 		}
 		if (ioctl(mdfd, SET_BITMAP_FILE, bitmap_fd) < 0) {
 			pr_err("Cannot set bitmap file for %s: %s\n",
 				mddev, strerror(errno));
-			goto abort;
+			goto abort_locked;
 		}
 	}
=20
@@ -884,7 +886,7 @@ int Create(struct supertype *st, char *mddev,
 						pr_err("failed to open %s "
 							"after earlier success - aborting\n",
 							dv->devname);
-						goto abort;
+						goto abort_locked;
 					}
 					fstat(fd, &stb);
 					inf->disk.major =3D major(stb.st_rdev);
@@ -896,7 +898,7 @@ int Create(struct supertype *st, char *mddev,
 							 fd, dv->devname,
 							 dv->data_offset)) {
 					ioctl(mdfd, STOP_ARRAY, NULL);
-					goto abort;
+					goto abort_locked;
 				}
 				st->ss->getinfo_super(st, inf, NULL);
 				safe_mode_delay =3D inf->safe_mode_delay;
@@ -922,7 +924,7 @@ int Create(struct supertype *st, char *mddev,
 					pr_err("ADD_NEW_DISK for %s "
 					       "failed: %s\n",
 					       dv->devname, strerror(errno));
-					goto abort;
+					goto abort_locked;
 				}
 				break;
 			}
@@ -939,7 +941,6 @@ int Create(struct supertype *st, char *mddev,
 			 * the subarray cursor such that ->getinfo_super once
 			 * again returns container info.
 			 */
-			map_lock(&map);
 			st->ss->getinfo_super(st, &info_new, NULL);
 			if (st->ss->external && s->level !=3D LEVEL_CONTAINER &&
 			    !same_uuid(info_new.uuid, info.uuid, 0)) {
@@ -964,12 +965,12 @@ int Create(struct supertype *st, char *mddev,
 					   info_new.uuid, path);
 				free(path);
 			}
-			map_unlock(&map);
=20
 			flush_metadata_updates(st);
 			st->ss->free_super(st);
 		}
 	}
+	map_unlock(&map);
 	free(infos);
=20
 	if (s->level =3D=3D LEVEL_CONTAINER) {

--Sig_/2hRNIv/LLuCY1KcKLXrc.pg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU0Xm5znsnt1WYoG5AQIHXw//aF/bDUAw8FRhJem3jrL2om6TmIs9hH4B
13E2h3B268wAeFnmx2PK4hQpXijbi010LAKKg+ZvBfuyHkASR/zHnS4DBZwRXTvf
zomrtehc6Y5yLwNhF1nsrPLtlOHfj6w9g+z7k5eUS5NAiM1CSp5y/I+e6sqRhL+Z
cQXAYhVjl+DG4jamh73/5UA2tP/sqHx/vbfB62b7OKfjkmw1Qh7e7naQ+6nhtM//
/fKgZVe8YO2LSV6Y9lTGfotpqmsmCgPi6y3/6hbWVK71mSTboRjme4y2Ue1qckbe
EzjJ5uQHxnvaGLoNdfKFhBWW8kL60gfqkzMuSIjhdxwMmKO8885yDLfwIQZ0Y2ZS
0RpgvdmVC7szDLHBivTjgmVCJGORqHzhe/iGefYTZoVoZ8XZgU1hyBQc0PippV1N
0Z7ebmsukyxT/0YDrq8AM0Gtjr0Syob2Y4gf9D2xY1R80m+3wtcaIIrazL8OGVu/
IIv8o4O60KIF7UCvLh/dCFjFb1vPsikT3jRMTobFokE1gfqvxcV8IkD4kZs1xujm
9CueJ87ZGVSt5avy/OPuxC+1+hJrS9CGG9HG5j32GXfATcV/Q1gGPHLehPSEWB5L
p9z+NkGVTFLvHA4GTRJ1fKd4xJYNo2/d9gacoG63FjAq3B8KbSMmfy98zbYs2Y2B
K/C64FIGYRQ=
=F7hO
-----END PGP SIGNATURE-----

--Sig_/2hRNIv/LLuCY1KcKLXrc.pg--
