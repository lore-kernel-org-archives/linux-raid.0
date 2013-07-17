From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 repair GPF crash w/3.10-rc7
Date: Wed, 17 Jul 2013 16:12:30 +1000
Message-ID: <20130717161230.2d96fa62@notabene.brown>
References: <alpine.DEB.2.02.1307012118450.6694@jlaw-desktop.mno.stratus.com>
	<alpine.DEB.2.02.1307031634440.9749@jlaw-desktop.mno.stratus.com>
	<20130704105337.2a06cbfd@notabene.brown>
	<20130708160656.6cb8e74b@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/caX1TKNUL7d8.SJOYU++/uh"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130708160656.6cb8e74b@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-raid@vger.kernel.org, kmo@daterainc.com
List-Id: linux-raid.ids

--Sig_/caX1TKNUL7d8.SJOYU++/uh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Jul 2013 16:06:56 -0400 Joe Lawrence <joe.lawrence@stratus.com>
wrote:

> [+cc Kent's new mail?]
>=20
> On Thu, 4 Jul 2013 10:53:37 +1000
> NeilBrown <neilb@suse.de> wrote:
> >=20
> > I would propose "bio_rewind" that exactly undoes any "bio_advance".=20
> >
> > [ ... snip ...]
> >=20
> > Then call that on pbio at the same place we call bio_reset on sbio.
> >=20
> > You could probably also call bio_rewind on sbio, and remove lots of that
> > code for setting the bio up again.
>=20
> This appears to work for my test case (no crashes or post repair
> mismatch_cnt):
>=20
>   mdadm --fail /dev/$MD /dev/sda3
>   mdadm --remove /dev/$MD /dev/sda3
>   dd if=3D/dev/urandom of=3D/dev/$MD bs=3D1M count=3D500
>   mdadm --stop /dev/$MD
>=20
>   mdadm --create /dev/$MD --level=3D1 --assume-clean --raid-devices=3D2 \
>   	--bitmap=3Dinternal /dev/sda3 /dev/sdi3
>   echo repair > /sys/block/$MD/md/sync_action
>=20
> I'll reply to this email with the patches that implement your
> suggested changes.  Feel free to combine or redo them, posting them here
> was the easiest way to provide my signed-off should you need it.
>=20
> Although it works, having to rewind the bio io_vec index (and
> clearing the bi_next pointers) before calling bio_copy_data feels a
> bit clunky.  What bio_copy_data is really doing is
> "bio_copy_remaining_data in a bio chain," whereas MD wants=20
> "bio_copy_completed_data from a single bio".
>=20
> I took a look at Kent's tree and a lot of the block layer handling was
> simplified through the bvec_iter.  I don't know if that code is
> destined for 3.11.  If so, it would probably be easier to retest and
> base any MD changes off of his.  And for 3.10 stable, the minimal
> fix would be for MD to just manipulate the bi_idx itself (or revert
> calling bio_copy_data altogether.)
>=20

Hi,
 just letting you know I've decided to fix this differently for 3.11 and
 3.10.y.

I noticed there was another problem in that code, in that the len argument
passed to memcmp was bv_len which might have been modified.

So I moved the "fix up the bio" code to the top of the function and applied
it to all relevant bios.

I'd still like to go with bio_rewind or similar, but it's probably best for
that to wait for the other bio stuff to settle.  Maybe it won't be needed.

NeilBrown


commit 9a3856f56b467425e13a19d95524524e76eab040
Author: NeilBrown <neilb@suse.de>
Date:   Wed Jul 17 15:19:29 2013 +1000

    md/raid1: fix bio handling problems in process_checks()
   =20
    Recent change to use bio_copy_data() in raid1 when repairing
    an array is faulty.
   =20
    The underlying may have changed the bio in various ways using
    bio_advance and these need to be undone not just for the 'sbio' which
    is being copied to, but also the 'pbio' (primary) which is being
    copied from.
   =20
    So perform the reset on all bios that were read from and do it early.
   =20
    This also ensure that the sbio->bi_io_vec[j].bv_len passed to
    memcmp is correct.
   =20
    Reported-by: Joe Lawrence <joe.lawrence@stratus.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ec73458..d60412c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1849,6 +1849,36 @@ static int process_checks(struct r1bio *r1_bio)
 	int i;
 	int vcnt;
=20
+	/* Fix variable parts of all bios */
+	vcnt =3D (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
+	for (i =3D 0; i < conf->raid_disks * 2; i++) {
+		int j;
+		int size;
+		struct bio *b =3D r1_bio->bios[i];
+		if (b->bi_end_io !=3D end_sync_read)
+			continue;
+		/* fixup the bio for reuse */
+		bio_reset(b);
+		b->bi_vcnt =3D vcnt;
+		b->bi_size =3D r1_bio->sectors << 9;
+		b->bi_sector =3D r1_bio->sector +
+			conf->mirrors[i].rdev->data_offset;
+		b->bi_bdev =3D conf->mirrors[i].rdev->bdev;
+		b->bi_end_io =3D end_sync_read;
+		b->bi_private =3D r1_bio;
+
+		size =3D b->bi_size;
+		for (j =3D 0; j < vcnt ; j++) {
+			struct bio_vec *bi;
+			bi =3D &b->bi_io_vec[j];
+			bi->bv_offset =3D 0;
+			if (size > PAGE_SIZE)
+				bi->bv_len =3D PAGE_SIZE;
+			else
+				bi->bv_len =3D size;
+			size -=3D PAGE_SIZE;
+		}
+	}
 	for (primary =3D 0; primary < conf->raid_disks * 2; primary++)
 		if (r1_bio->bios[primary]->bi_end_io =3D=3D end_sync_read &&
 		    test_bit(BIO_UPTODATE, &r1_bio->bios[primary]->bi_flags)) {
@@ -1857,12 +1887,10 @@ static int process_checks(struct r1bio *r1_bio)
 			break;
 		}
 	r1_bio->read_disk =3D primary;
-	vcnt =3D (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
 	for (i =3D 0; i < conf->raid_disks * 2; i++) {
 		int j;
 		struct bio *pbio =3D r1_bio->bios[primary];
 		struct bio *sbio =3D r1_bio->bios[i];
-		int size;
=20
 		if (sbio->bi_end_io !=3D end_sync_read)
 			continue;
@@ -1888,27 +1916,6 @@ static int process_checks(struct r1bio *r1_bio)
 			rdev_dec_pending(conf->mirrors[i].rdev, mddev);
 			continue;
 		}
-		/* fixup the bio for reuse */
-		bio_reset(sbio);
-		sbio->bi_vcnt =3D vcnt;
-		sbio->bi_size =3D r1_bio->sectors << 9;
-		sbio->bi_sector =3D r1_bio->sector +
-			conf->mirrors[i].rdev->data_offset;
-		sbio->bi_bdev =3D conf->mirrors[i].rdev->bdev;
-		sbio->bi_end_io =3D end_sync_read;
-		sbio->bi_private =3D r1_bio;
-
-		size =3D sbio->bi_size;
-		for (j =3D 0; j < vcnt ; j++) {
-			struct bio_vec *bi;
-			bi =3D &sbio->bi_io_vec[j];
-			bi->bv_offset =3D 0;
-			if (size > PAGE_SIZE)
-				bi->bv_len =3D PAGE_SIZE;
-			else
-				bi->bv_len =3D size;
-			size -=3D PAGE_SIZE;
-		}
=20
 		bio_copy_data(sbio, pbio);
 	}

--Sig_/caX1TKNUL7d8.SJOYU++/uh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUeY1zjnsnt1WYoG5AQLBWxAAmNaq/6Wq7e1nn1Hdsxr3hFP6ELeQCmEx
YJq2d3bakdAd3Rhokohjp0dG/dHbuG89fRjwwq35ZNjwHlm/Vx83doro1mq/5wZ6
zPjCWVVlob3U1Da1Jh/xOLDjYV24REhDnfVULCP7bdLvgzqYOCPzmAr2tBr1XxkK
+aF+5+chjNx1bKvYkP69PBSwNizJOjuI2qz1V5xS7X1kCF3XfYQXBM/gQokLfZp1
/G3r0eTA9ClF3tqgUR8/nx25ZYunct/G1d8oiKms5HHKZzvjEvXZcrdVjjsFQT2W
pjdiObwI2iG1ZPx7lqpt/I+Us0XN3HOfPT6WpqJanf+mbiuA0o+LZFJ0y8sUc38e
FG8p2SANTOaCoJGNLqEH7hnh8mb7WPOFRtm7nINbqhdNQTtWcaQNoubtPeiPUyT+
WW3uRZgZl3ycO1BVH9KV/G6a6Gc/I9yehnb3bt8bxrlH8ZTQs/Szz1RYetg9zbxh
w1hiOC9kvGzSf6QXyl7i1/4+tLdndRdhIWrNeYZomnv5k8NutqAHIF8YLZgj6RBI
4296tyyNtqIvdhr5TuV92t4w4p+QJRkx0ee+Nu5jkigKxU/M3++sjLgfKRmNuOX4
zRU8EltniK2BnW+vZXeiSSAhLUYYnX6jgk+WOKruODAiRT6Hsh2htd42gETLgN4e
QFNCKUrf0q0=
=PAeT
-----END PGP SIGNATURE-----

--Sig_/caX1TKNUL7d8.SJOYU++/uh--
