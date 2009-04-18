From: Prakash Punnoor <prakash@punnoor.de>
Subject: Proposal: make RAID6 code optional
Date: Sat, 18 Apr 2009 09:46:21 +0200
Message-ID: <200904180946.27722.prakash@punnoor.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1477116.W2K06ykKeC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

--nextPart1477116.W2K06ykKeC
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

as I am using only RAID5 I wonder why the RAID6 code also needs to be built.
Here is a rough patch of making RAID6 optional (but depending on raid456)
without reording of functions to minimize ifdef scattering.
(I also haven't checked yet who needs ASYNC_MEMCPY and ASYNC_XOR...)
It would probably be nicer to make RAID4/5 and RAID6 independently selectab=
le
of each other. But that requires more refactoring, as I can see.

I am willing to do more cleanups, so please provide some comments. I am not=
 a
kernel hacker so please bear with me. ;-)

Greetings,

Prakash

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 36e0675..0d98b3a 100644
=2D-- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -121,7 +121,6 @@ config MD_RAID10
 config MD_RAID456
 	tristate "RAID-4/RAID-5/RAID-6 mode"
 	depends on BLK_DEV_MD
=2D	select MD_RAID6_PQ
 	select ASYNC_MEMCPY
 	select ASYNC_XOR
 	---help---
@@ -152,8 +151,15 @@ config MD_RAID456
=20
 	  If unsure, say Y.
=20
=2Dconfig MD_RAID6_PQ
=2D	tristate
+config MD_RAID6
+	boolean "Include RAID-6 support"
+	depends on MD_RAID456
+	select ASYNC_MEMCPY
+	select ASYNC_XOR
+	---help---
+	  If you want to use such a RAID-6 set, say Y.
+
+	  If unsure, say Y.
=20
 config MD_MULTIPATH
 	tristate "Multipath I/O support"
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 45cc595..5084b23 100644
=2D-- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -27,7 +27,7 @@ obj-$(CONFIG_MD_LINEAR)		+=3D linear.o
 obj-$(CONFIG_MD_RAID0)		+=3D raid0.o
 obj-$(CONFIG_MD_RAID1)		+=3D raid1.o
 obj-$(CONFIG_MD_RAID10)		+=3D raid10.o
=2Dobj-$(CONFIG_MD_RAID6_PQ)	+=3D raid6_pq.o
+obj-$(CONFIG_MD_RAID6)		+=3D raid6_pq.o
 obj-$(CONFIG_MD_RAID456)	+=3D raid456.o
 obj-$(CONFIG_MD_MULTIPATH)	+=3D multipath.o
 obj-$(CONFIG_MD_FAULTY)		+=3D faulty.o
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3bbc6d6..fc29b4b 100644
=2D-- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -128,6 +128,7 @@ static inline void raid5_set_bi_hw_segments(struct bio =
*bio, unsigned int cnt)
 	bio->bi_phys_segments =3D raid5_bi_phys_segments(bio) || (cnt << 16);
 }
=20
+#ifdef CONFIG_MD_RAID6
 /* Find first data disk in a raid6 stripe */
 static inline int raid6_d0(struct stripe_head *sh)
 {
@@ -163,6 +164,7 @@ static int raid6_idx_to_slot(int idx, struct stripe_hea=
d *sh,
 	slot =3D (*count)++;
 	return slot;
 }
+#endif
=20
 static void return_io(struct bio *return_bi)
 {
@@ -1594,7 +1596,7 @@ static sector_t compute_blocknr(struct stripe_head *s=
h, int i, int previous)
 }
=20
=20
=2D
+#ifdef CONFIG_MD_RAID6
 /*
  * Copy data between a page in the stripe cache, and one or more bion
  * The page could align with the middle of the bio, or there could be
@@ -1738,7 +1740,6 @@ static void compute_parity6(struct stripe_head *sh, i=
nt method)
 	}
 }
=20
=2D
 /* Compute one missing block */
 static void compute_block_1(struct stripe_head *sh, int dd_idx, int nozero)
 {
@@ -1840,6 +1841,7 @@ static void compute_block_2(struct stripe_head *sh, i=
nt dd_idx1, int dd_idx2)
 	set_bit(R5_UPTODATE, &sh->dev[dd_idx1].flags);
 	set_bit(R5_UPTODATE, &sh->dev[dd_idx2].flags);
 }
+#endif
=20
 static void
 schedule_reconstruction5(struct stripe_head *sh, struct stripe_head_state =
*s,
@@ -1986,12 +1988,14 @@ static int add_stripe_bio(struct stripe_head *sh, s=
truct bio *bi, int dd_idx, in
=20
 static void end_reshape(raid5_conf_t *conf);
=20
+#ifdef CONFIG_MD_RAID6
 static int page_is_zero(struct page *p)
 {
 	char *a =3D page_address(p);
 	return ((*(u32*)a) =3D=3D 0 &&
 		memcmp(a, a+4, STRIPE_SIZE-4)=3D=3D0);
 }
+#endif
=20
 static void stripe_set_idx(sector_t stripe, raid5_conf_t *conf, int previo=
us,
 			    struct stripe_head *sh)
@@ -2174,6 +2178,7 @@ static void handle_stripe_fill5(struct stripe_head *s=
h,
 	set_bit(STRIPE_HANDLE, &sh->state);
 }
=20
+#ifdef CONFIG_MD_RAID6
 static void handle_stripe_fill6(struct stripe_head *sh,
 			struct stripe_head_state *s, struct r6_state *r6s,
 			int disks)
@@ -2231,7 +2236,7 @@ static void handle_stripe_fill6(struct stripe_head *s=
h,
 	}
 	set_bit(STRIPE_HANDLE, &sh->state);
 }
=2D
+#endif
=20
 /* handle_stripe_clean_event
  * any written block on an uptodate or failed drive can be returned.
@@ -2373,6 +2378,7 @@ static void handle_stripe_dirtying5(raid5_conf_t *con=
f,
 		schedule_reconstruction5(sh, s, rcw =3D=3D 0, 0);
 }
=20
+#ifdef CONFIG_MD_RAID6
 static void handle_stripe_dirtying6(raid5_conf_t *conf,
 		struct stripe_head *sh,	struct stripe_head_state *s,
 		struct r6_state *r6s, int disks)
@@ -2472,6 +2478,7 @@ static void handle_stripe_dirtying6(raid5_conf_t *con=
f,
 		}
 	}
 }
+#endif
=20
 static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *=
sh,
 				struct stripe_head_state *s, int disks)
@@ -2559,7 +2566,7 @@ static void handle_parity_checks5(raid5_conf_t *conf,=
 struct stripe_head *sh,
 	}
 }
=20
=2D
+#ifdef CONFIG_MD_RAID6
 static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *=
sh,
 				struct stripe_head_state *s,
 				struct r6_state *r6s, struct page *tmp_page,
@@ -2652,6 +2659,7 @@ static void handle_parity_checks6(raid5_conf_t *conf,=
 struct stripe_head *sh,
 		set_bit(STRIPE_INSYNC, &sh->state);
 	}
 }
+#endif
=20
 static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head=
 *sh,
 				struct r6_state *r6s)
@@ -3003,6 +3011,7 @@ static bool handle_stripe5(struct stripe_head *sh)
 	return blocked_rdev =3D=3D NULL;
 }
=20
+#ifdef CONFIG_MD_RAID6
 static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 {
 	raid5_conf_t *conf =3D sh->raid_conf;
@@ -3239,13 +3248,16 @@ static bool handle_stripe6(struct stripe_head *sh, =
struct page *tmp_page)
=20
 	return blocked_rdev =3D=3D NULL;
 }
+#endif
=20
 /* returns true if the stripe was handled */
 static bool handle_stripe(struct stripe_head *sh, struct page *tmp_page)
 {
+#ifdef CONFIG_MD_RAID6
 	if (sh->raid_conf->level =3D=3D 6)
 		return handle_stripe6(sh, tmp_page);
 	else
+#endif
 		return handle_stripe5(sh);
 }
=20
@@ -5190,6 +5202,7 @@ static int raid5_reconfig(mddev_t *mddev, int new_lay=
out, int new_chunk)
 	return 0;
 }
=20
+#ifdef CONFIG_MD_RAID6
 static int raid6_reconfig(mddev_t *mddev, int new_layout, int new_chunk)
 {
 	if (new_layout >=3D 0 && !algorithm_valid_raid6(new_layout))
@@ -5214,7 +5227,7 @@ static int raid6_reconfig(mddev_t *mddev, int new_lay=
out, int new_chunk)
=20
 	return 0;
 }
=2D
+#endif
 static void *raid5_takeover(mddev_t *mddev)
 {
 	/* raid5 can take over:
@@ -5242,6 +5255,7 @@ static void *raid5_takeover(mddev_t *mddev)
=20
 static struct mdk_personality raid5_personality;
=20
+#ifdef CONFIG_MD_RAID6
 static void *raid6_takeover(mddev_t *mddev)
 {
 	/* Currently can only take over a raid5.  We map the
@@ -5288,7 +5302,6 @@ static void *raid6_takeover(mddev_t *mddev)
 	return setup_conf(mddev);
 }
=20
=2D
 static struct mdk_personality raid6_personality =3D
 {
 	.name		=3D "raid6",
@@ -5312,6 +5325,7 @@ static struct mdk_personality raid6_personality =3D
 	.takeover	=3D raid6_takeover,
 	.reconfig	=3D raid6_reconfig,
 };
+#endif
 static struct mdk_personality raid5_personality =3D
 {
 	.name		=3D "raid5",
@@ -5360,7 +5374,9 @@ static struct mdk_personality raid4_personality =3D
=20
 static int __init raid5_init(void)
 {
+#ifdef CONFIG_MD_RAID6
 	register_md_personality(&raid6_personality);
+#endif
 	register_md_personality(&raid5_personality);
 	register_md_personality(&raid4_personality);
 	return 0;
@@ -5368,7 +5384,9 @@ static int __init raid5_init(void)
=20
 static void raid5_exit(void)
 {
+#ifdef CONFIG_MD_RAID6
 	unregister_md_personality(&raid6_personality);
+#endif
 	unregister_md_personality(&raid5_personality);
 	unregister_md_personality(&raid4_personality);
 }


--nextPart1477116.W2K06ykKeC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAknphVMACgkQxU2n/+9+t5ivuACfUIfgveXZt+96eQArnpEOsu7E
RH8An07HJ67Zu9KshEX6xHGDvtGv91J8
=zglx
-----END PGP SIGNATURE-----

--nextPart1477116.W2K06ykKeC--
