From: NeilBrown <neilb@suse.de>
Subject: Re: md raid10 Oops on recent kernels
Date: Wed, 15 Aug 2012 14:44:01 +1000
Message-ID: <20120815144401.122152d7@notabene.brown>
References: <CANZ+j8dDLqe=30AFd7oJ9WjhTSTRfbkXPBfBdG3GH=7eHkUqeA@mail.gmail.com>
	<20120814105043.05c62805@notabene.brown>
	<CANZ+j8dT9PhokMroU-8bMDQGCnYJsmEn807j2GeyOC3gQ9OiEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/oWI8LaIIVB0F5CWfDOzG8/S"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANZ+j8dT9PhokMroU-8bMDQGCnYJsmEn807j2GeyOC3gQ9OiEA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ivan Vasilyev <ivan.vasilyev@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/oWI8LaIIVB0F5CWfDOzG8/S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Aug 2012 22:56:59 +0400 Ivan Vasilyev <ivan.vasilyev@gmail.com>
wrote:

> 2012/8/14 NeilBrown <neilb@suse.de>:
> > On Mon, 13 Aug 2012 16:49:26 +0400 Ivan Vasilyev <ivan.vasilyev@gmail.c=
om>
> > wrote:
> >
> >>  ---[ end trace b86c49ca25a6cdb2 ]---
> >> ----------
> >
> > It looks like the ->merge_bvec_fn is bad - the code is jumping to
> > 0xffffffff00000001, which strongly suggests some function pointer is ba=
d, and
> > merge_bvec_fn is the only one in that area of code.
> > However I cannot see how it could possibly get a bad value like that.
> >
> > There were changes to merge_bvec_fn handling in RAID10 in 3.4 which is =
when
> > you say the problem appeared.  However I cannot see how direct IO would=
 be
> > affected any differently to normal IO.
> >
> > If I were to try to debug this I'd build a kernel and put a printk in
> > __bio_add_page in fs/bio.c just before calling q->merge_bvec_fn to prin=
t a
> > message if that value has the low bit set. (i.e. if (q->merge_bvec_fn &=
 1) ...).
>=20
> Such printk is triggered right befire oops:
>=20
> DEBUG q-> merge_bvec_fn=3D0xffffffffa011a1c3 queue_flags=3D0x40
> queuedata=3D0xffff880058bf1520
> backing_dev_info.congested_fn=3D0xffffffffa011d39a
> BUG: unable to handle kernel paging request at ffffffff00000001
>=20
> although address is different (so this means the bug does not occur
> exactly on merge_bvec_fn() call?)
>=20
> Checked again - this problem affects only directIO:
>=20
> dd if=3D/dev/md/rtest_a count=3D10000 of=3D/dev/null
>  =3D> ok
> dd if=3D/dev/md/rtest_a iflag=3Ddirect count=3D10000 of=3D/dev/null
>  =3D> oops (first since boot)
>=20

Hmmm.. not what I expected. =20
I found it was indeed easy to reproduce and after being sure it was
impossible for half the afternoon I've found the problem.
The following patch fixes it.  I'm not sure yet if that it was what I'll
submit upstream.
The problem is that "struct r10bio" isn't by itself big enough.  It is
usually allocated with extra memory at the end.  So when declared on the
stack, the same is needed.

Thanks,
NeilBrown

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 93fe561..12565c3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -659,7 +659,10 @@ static int raid10_mergeable_bvec(struct request_queue =
*q,
 		max =3D biovec->bv_len;
=20
 	if (mddev->merge_check_needed) {
-		struct r10bio r10_bio;
+		struct {
+			struct r10bio r10_bio;
+			struct r10dev devs[conf->copies];
+		} x;
 		int s;
 		if (conf->reshape_progress !=3D MaxSector) {
 			/* Cannot give any guidance during reshape */
@@ -667,18 +670,18 @@ static int raid10_mergeable_bvec(struct request_queue=
 *q,
 				return biovec->bv_len;
 			return 0;
 		}
-		r10_bio.sector =3D sector;
-		raid10_find_phys(conf, &r10_bio);
+		x.r10_bio.sector =3D sector;
+		raid10_find_phys(conf, &x.r10_bio);
 		rcu_read_lock();
 		for (s =3D 0; s < conf->copies; s++) {
-			int disk =3D r10_bio.devs[s].devnum;
+			int disk =3D x.r10_bio.devs[s].devnum;
 			struct md_rdev *rdev =3D rcu_dereference(
 				conf->mirrors[disk].rdev);
 			if (rdev && !test_bit(Faulty, &rdev->flags)) {
 				struct request_queue *q =3D
 					bdev_get_queue(rdev->bdev);
 				if (q->merge_bvec_fn) {
-					bvm->bi_sector =3D r10_bio.devs[s].addr
+					bvm->bi_sector =3D x.r10_bio.devs[s].addr
 						+ rdev->data_offset;
 					bvm->bi_bdev =3D rdev->bdev;
 					max =3D min(max, q->merge_bvec_fn(
@@ -690,7 +693,7 @@ static int raid10_mergeable_bvec(struct request_queue *=
q,
 				struct request_queue *q =3D
 					bdev_get_queue(rdev->bdev);
 				if (q->merge_bvec_fn) {
-					bvm->bi_sector =3D r10_bio.devs[s].addr
+					bvm->bi_sector =3D x.r10_bio.devs[s].addr
 						+ rdev->data_offset;
 					bvm->bi_bdev =3D rdev->bdev;
 					max =3D min(max, q->merge_bvec_fn(
@@ -4434,14 +4437,17 @@ static int handle_reshape_read_error(struct mddev *=
mddev,
 {
 	/* Use sync reads to get the blocks from somewhere else */
 	int sectors =3D r10_bio->sectors;
-	struct r10bio r10b;
 	struct r10conf *conf =3D mddev->private;
+	struct {
+		struct r10bio r10b;
+		struct r10dev devs[conf->copies];
+	} x;
 	int slot =3D 0;
 	int idx =3D 0;
 	struct bio_vec *bvec =3D r10_bio->master_bio->bi_io_vec;
=20
-	r10b.sector =3D r10_bio->sector;
-	__raid10_find_phys(&conf->prev, &r10b);
+	x.r10b.sector =3D r10_bio->sector;
+	__raid10_find_phys(&conf->prev, &x.r10b);
=20
 	while (sectors) {
 		int s =3D sectors;
@@ -4452,7 +4458,7 @@ static int handle_reshape_read_error(struct mddev *md=
dev,
 			s =3D PAGE_SIZE >> 9;
=20
 		while (!success) {
-			int d =3D r10b.devs[slot].devnum;
+			int d =3D x.r10b.devs[slot].devnum;
 			struct md_rdev *rdev =3D conf->mirrors[d].rdev;
 			sector_t addr;
 			if (rdev =3D=3D NULL ||
@@ -4460,7 +4466,7 @@ static int handle_reshape_read_error(struct mddev *md=
dev,
 			    !test_bit(In_sync, &rdev->flags))
 				goto failed;
=20
-			addr =3D r10b.devs[slot].addr + idx * PAGE_SIZE;
+			addr =3D x.r10b.devs[slot].addr + idx * PAGE_SIZE;
 			success =3D sync_page_io(rdev,
 					       addr,
 					       s << 9,
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 007c2c6..1054cf6 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -110,7 +110,7 @@ struct r10bio {
 	 * We choose the number when they are allocated.
 	 * We sometimes need an extra bio to write to the replacement.
 	 */
-	struct {
+	struct r10dev {
 		struct bio	*bio;
 		union {
 			struct bio	*repl_bio; /* used for resync and

--Sig_/oWI8LaIIVB0F5CWfDOzG8/S
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCspETnsnt1WYoG5AQJxuA/+MK5TigB6HnZ07PpDQ3qpNPFdcodaAydY
Bk1OKIpE72JleR+jEygLkpk7HXbYZnRFTDQxK742+6uVPiDPKKOznh0O12hiL7Mk
jbB7BDSMh2eWvHarRtX/sbIqJTiO5XWssggOGP/NxR+Y4SDUM6pAIbpD1ejd7hdC
+3+zRP1axzxw5IsmUZyJxdfrWl4V2nLwJG2vpoDH1w5Jg+5rW6Q85E2Sst2PR40+
1sY9y/S809qgvk1n8aVI0l6CuUxd6HT5SKreugC3JGLU51Fg/qSpyssz2OQmXNyW
XoGrJY0l47XH+LCkK3d61O0+TltIIiLV7Rr6Wbh8iMkRHRQwXP7x3Vu22MqKI+X3
jfXSVacKwmXH4OfMA1CyOWPc//I8po2kTMVJw3+snYfdqySgm2kk2dkwEieAp1Mb
CmJDflG/E6AO1PHTKV+KZ3E2kZ1apVmbc/gXtC7PGO0sS7/o5HZGGPZJEWb+7qfi
gY9qtQ0B0TRfS4L4UVDCPAZr9ZD+wM9ky4trGcIQ9Py/74iOoNJu2a7nJkXUXdbv
tAD3qWE5d7aHQ1CjbTx67mSGWvYkEEJvXKDqNantsqAp5zyT50Oyl5HpSr26jOTw
9w7g/8qMTJJzdm7P5lR5iMzp90RBV2Q90JCguri6BHpz53/C6OyZO40PhHhn0EX5
1shuYpoofa8=
=wRqH
-----END PGP SIGNATURE-----

--Sig_/oWI8LaIIVB0F5CWfDOzG8/S--
