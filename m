From: NeilBrown <neilb@suse.de>
Subject: Re: [BUG 2.6.32] md/raid1: barrier disabling does not work
 correctly in all cases
Date: Fri, 21 Jan 2011 07:25:15 +1100
Message-ID: <20110121072515.07dc2b74@notabene.brown>
References: <AANLkTimp7eGLu5UEr-wH9MVSGrQWA3PKMakW74_48gk7@mail.gmail.com>
	<AANLkTikGsB=ZdA-TpjC+npqW-TM9NjwZkWpjWtUEzswn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikGsB=ZdA-TpjC+npqW-TM9NjwZkWpjWtUEzswn@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@us.sios.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 20 Jan 2011 11:52:32 -0500 Paul Clements <paul.clements@us.sios=
=2Ecom>
wrote:

> I'm having a problem with the 2.6.32 kernel (RHEL 6, actually) and th=
e
> barrier disabling code in raid1.
>=20
> The gist of the problem is that when an fsync is done directly to
> /dev/md0 (fsck.ext4 performs an fsync), the kernel
> (blkdev_issue_flush, specifically) translates this into a zero-length
> write with-barrier-attached. raid1 of course sends this down to its
> component devices, which then return EOPNOTSUPP (in my case, a xen
> block device, which doesn't support barriers). raid1 then strips the
> BIO_RW_BARRIER off and retries the write.
>=20
> Apparently, a zero-length write (bio) without barrier makes some/all
> block drivers very unhappy (IDE, cciss, and xen-blkfront have been
> tested and all failed on this). I think these zero-length writes must
> normally get filtered out and discarded by filesystem/block layer
> before drivers ever see them, but in this particular case, where md i=
s
> submitting the write directly to the underlying component driver, it
> doesn't get filtered and causes -EIO to be returned (the disk gets
> marked failed, the mirror breaks, chaos ensues...)
>=20
> I can do an obvious hack, which is to assume all the time that
> barriers don't work. That is, mark mddev->barriers_work as 0 or just
> disable that check:
>=20
> --- drivers/md/raid1.c.PRISTINE 2011-01-14 14:51:56.959809669 -0500
> +++ drivers/md/raid1.c =A02011-01-20 10:17:11.001701186 -0500
> @@ -819,6 +833,7 @@ static int make_request(mddev_t *mddev,
> =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0finish_wait(&conf->wait_barrier, &w=
);
> =A0=A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0if (unlikely(!mddev->barriers_work &&
> + =A0 =A0 =A0 if ((
> =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio_rw_flagged(bio, BIO_RW=
_BARRIER))) {
> =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rw =3D=3D WRITE)
> =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0md_write_end(mddev)=
;
>=20
> That fixes things, but does Neil or someone else have an idea how bes=
t
> to fix this?=A0Could we specifically just not retry a zero-length
> barrier write? I think that would fix it, but is kind of a hack too.
>=20
> I know barriers are being pulled out of the kernel, so this isn't a
> problem for recent kernels, but as 2.6.32 is a long-term support
> kernel, this may be something that others run into and will want
> fixed.

Normally the first thing that md/raid1 writes to a member device is the
metadata.  This is written with a barrier write if possible.  If that f=
ails
then barriers_work is cleared, so all barrier writes from the filesyste=
m
(empty or otherwise) will be rejected.

As you are getting an error here I assume that you are using non-persis=
tent
metadata - correct?

Nonetheless, I think the correct fix is to add a special case for retry=
ing a
zero-length.

Something like this maybe?

NeilBrown


Index: linux-2.6.32.orig/drivers/md/raid1.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.32.orig.orig/drivers/md/raid1.c	2011-01-21 07:23:59.00000=
0000 +1100
+++ linux-2.6.32.orig/drivers/md/raid1.c	2011-01-21 07:24:40.498354896 =
+1100
@@ -236,14 +236,18 @@ static void raid_end_bio_io(r1bio_t *r1_
=20
 	/* if nobody has done the final endio yet, do it now */
 	if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
+		int err =3D 0;
 		PRINTK(KERN_DEBUG "raid1: sync end %s on sectors %llu-%llu\n",
 			(bio_data_dir(bio) =3D=3D WRITE) ? "write" : "read",
 			(unsigned long long) bio->bi_sector,
 			(unsigned long long) bio->bi_sector +
 				(bio->bi_size >> 9) - 1);
=20
-		bio_endio(bio,
-			test_bit(R1BIO_Uptodate, &r1_bio->state) ? 0 : -EIO);
+		if (test_bit(R1BIO_BarrierRetry, &r1_bio->state))
+			err =3D -EOPNOTSUPP;
+		else if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
+			err =3D -EIO;
+		bio_endio(bio, err);
 	}
 	free_r1bio(r1_bio);
 }
@@ -1607,6 +1611,11 @@ static void raid1d(mddev_t *mddev)
 			 */
 			int i;
 			const bool do_sync =3D bio_rw_flagged(r1_bio->master_bio, BIO_RW_SY=
NCIO);
+			if (r1_bio->master_bio->bi_size =3D=3D 0) {
+				/* cannot retry empty barriers, just fail */
+				raid_end_bio_io(r1_bio);
+				continue;
+			}
 			clear_bit(R1BIO_BarrierRetry, &r1_bio->state);
 			clear_bit(R1BIO_Barrier, &r1_bio->state);
 			for (i=3D0; i < conf->raid_disks; i++)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
