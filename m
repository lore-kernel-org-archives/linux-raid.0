From: NeilBrown <neilb@suse.de>
Subject: Re: want-replacement got stuck?
Date: Thu, 22 Nov 2012 15:22:49 +1100
Message-ID: <20121122152249.0adcc076@notabene.brown>
References: <20121121211910.22223.qmail@science.horizon.com>
	<20121122032504.12679.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hBT1hAwYrIUHUwyneZE/WwK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121122032504.12679.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: joystick@shiftmail.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/hBT1hAwYrIUHUwyneZE/WwK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On 21 Nov 2012 22:25:04 -0500 "George Spelvin" <linux@horizon.com> wrote:

...

> Now I've zeroed sdd2's uperblock and added it back, and things seem
> to be working okay.

All's well that ends well :-)

>=20
>=20
> NeilBrown <neilb@suse.de> wrote:
> > Yes.... this is a real worry.  Fortunately I know what is causing it.
>=20
> Yay!  Tell me when you have a patch to test.

OK, below are two patches.
The first fixes the data corruption race.  You'll almost never hit it with
the bug that the second patch fixes, but in theory you could.  Without the
second patch you can hit it easily.

The second patch fixes the problem where the replacement device stayed a
replacement even after the replacement operation completed.

The symptoms are easy to reproduce - once you know what to look for - and t=
he
patches work for me so I'll be sending them to Linus  tomorrow.  But extra
testing always helps.

Thanks,
NeilBrown


commit e7c0c3fa29280d62aa5e11101a674bb3064bd791
Author: NeilBrown <neilb@suse.de>
Date:   Thu Nov 22 14:42:49 2012 +1100

    md/raid10: close race that lose writes lost when replacement completes.
   =20
    When a replacement operation completes there is a small window
    when the original device is marked 'faulty' and the replacement
    still looks like a replacement.  The faulty should be removed and
    the replacement moved in place very quickly, bit it isn't instant.
   =20
    So the code write out to the array must handle the possibility that
    the only working device for some slot in the replacement - but it
    doesn't.  If the primary device is faulty it just gives up.  This
    can lead to corruption.
   =20
    So make the code more robust: if either  the primary or the
    replacement is present and working, write to them.  Only when
    neither are present do we give up.
   =20
    This bug has been present since replacement was introduced in
    3.3, so it is suitable for any -stable kernel since then.
   =20
    Reported-by: "George Spelvin" <linux@horizon.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d1295af..ad03251 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1334,18 +1334,21 @@ retry_write:
 			blocked_rdev =3D rrdev;
 			break;
 		}
+		if (rdev && (test_bit(Faulty, &rdev->flags)
+			     || test_bit(Unmerged, &rdev->flags)))
+			rdev =3D NULL;
 		if (rrdev && (test_bit(Faulty, &rrdev->flags)
 			      || test_bit(Unmerged, &rrdev->flags)))
 			rrdev =3D NULL;
=20
 		r10_bio->devs[i].bio =3D NULL;
 		r10_bio->devs[i].repl_bio =3D NULL;
-		if (!rdev || test_bit(Faulty, &rdev->flags) ||
-		    test_bit(Unmerged, &rdev->flags)) {
+
+		if (!rdev && !rrdev) {
 			set_bit(R10BIO_Degraded, &r10_bio->state);
 			continue;
 		}
-		if (test_bit(WriteErrorSeen, &rdev->flags)) {
+		if (rdev && test_bit(WriteErrorSeen, &rdev->flags)) {
 			sector_t first_bad;
 			sector_t dev_sector =3D r10_bio->devs[i].addr;
 			int bad_sectors;
@@ -1387,8 +1390,10 @@ retry_write:
 					max_sectors =3D good_sectors;
 			}
 		}
-		r10_bio->devs[i].bio =3D bio;
-		atomic_inc(&rdev->nr_pending);
+		if (rdev) {
+			r10_bio->devs[i].bio =3D bio;
+			atomic_inc(&rdev->nr_pending);
+		}
 		if (rrdev) {
 			r10_bio->devs[i].repl_bio =3D bio;
 			atomic_inc(&rrdev->nr_pending);
@@ -1444,69 +1449,71 @@ retry_write:
 	for (i =3D 0; i < conf->copies; i++) {
 		struct bio *mbio;
 		int d =3D r10_bio->devs[i].devnum;
-		if (!r10_bio->devs[i].bio)
-			continue;
+		if (r10_bio->devs[i].bio) {
+			struct md_rdev *rdev =3D conf->mirrors[d].rdev;
+			mbio =3D bio_clone_mddev(bio, GFP_NOIO, mddev);
+			md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
+				    max_sectors);
+			r10_bio->devs[i].bio =3D mbio;
+
+			mbio->bi_sector	=3D (r10_bio->devs[i].addr+
+					   choose_data_offset(r10_bio,
+							      rdev));
+			mbio->bi_bdev =3D rdev->bdev;
+			mbio->bi_end_io	=3D raid10_end_write_request;
+			mbio->bi_rw =3D WRITE | do_sync | do_fua | do_discard;
+			mbio->bi_private =3D r10_bio;
=20
-		mbio =3D bio_clone_mddev(bio, GFP_NOIO, mddev);
-		md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
-			    max_sectors);
-		r10_bio->devs[i].bio =3D mbio;
+			atomic_inc(&r10_bio->remaining);
=20
-		mbio->bi_sector	=3D (r10_bio->devs[i].addr+
-				   choose_data_offset(r10_bio,
-						      conf->mirrors[d].rdev));
-		mbio->bi_bdev =3D conf->mirrors[d].rdev->bdev;
-		mbio->bi_end_io	=3D raid10_end_write_request;
-		mbio->bi_rw =3D WRITE | do_sync | do_fua | do_discard;
-		mbio->bi_private =3D r10_bio;
+			cb =3D blk_check_plugged(raid10_unplug, mddev,
+					       sizeof(*plug));
+			if (cb)
+				plug =3D container_of(cb, struct raid10_plug_cb,
+						    cb);
+			else
+				plug =3D NULL;
+			spin_lock_irqsave(&conf->device_lock, flags);
+			if (plug) {
+				bio_list_add(&plug->pending, mbio);
+				plug->pending_cnt++;
+			} else {
+				bio_list_add(&conf->pending_bio_list, mbio);
+				conf->pending_count++;
+			}
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+			if (!plug)
+				md_wakeup_thread(mddev->thread);
+		}
=20
-		atomic_inc(&r10_bio->remaining);
+		if (r10_bio->devs[i].repl_bio) {
+			struct md_rdev *rdev =3D conf->mirrors[d].replacement;
+			if (rdev =3D=3D NULL) {
+				/* Replacement just got moved to main 'rdev' */
+				smp_mb();
+				rdev =3D conf->mirrors[d].rdev;
+			}
+			mbio =3D bio_clone_mddev(bio, GFP_NOIO, mddev);
+			md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
+				    max_sectors);
+			r10_bio->devs[i].repl_bio =3D mbio;
+
+			mbio->bi_sector	=3D (r10_bio->devs[i].addr +
+					   choose_data_offset(
+						   r10_bio, rdev));
+			mbio->bi_bdev =3D rdev->bdev;
+			mbio->bi_end_io	=3D raid10_end_write_request;
+			mbio->bi_rw =3D WRITE | do_sync | do_fua | do_discard;
+			mbio->bi_private =3D r10_bio;
=20
-		cb =3D blk_check_plugged(raid10_unplug, mddev, sizeof(*plug));
-		if (cb)
-			plug =3D container_of(cb, struct raid10_plug_cb, cb);
-		else
-			plug =3D NULL;
-		spin_lock_irqsave(&conf->device_lock, flags);
-		if (plug) {
-			bio_list_add(&plug->pending, mbio);
-			plug->pending_cnt++;
-		} else {
+			atomic_inc(&r10_bio->remaining);
+			spin_lock_irqsave(&conf->device_lock, flags);
 			bio_list_add(&conf->pending_bio_list, mbio);
 			conf->pending_count++;
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+			if (!mddev_check_plugged(mddev))
+				md_wakeup_thread(mddev->thread);
 		}
-		spin_unlock_irqrestore(&conf->device_lock, flags);
-		if (!plug)
-			md_wakeup_thread(mddev->thread);
-
-		if (!r10_bio->devs[i].repl_bio)
-			continue;
-
-		mbio =3D bio_clone_mddev(bio, GFP_NOIO, mddev);
-		md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
-			    max_sectors);
-		r10_bio->devs[i].repl_bio =3D mbio;
-
-		/* We are actively writing to the original device
-		 * so it cannot disappear, so the replacement cannot
-		 * become NULL here
-		 */
-		mbio->bi_sector	=3D (r10_bio->devs[i].addr +
-				   choose_data_offset(
-					   r10_bio,
-					   conf->mirrors[d].replacement));
-		mbio->bi_bdev =3D conf->mirrors[d].replacement->bdev;
-		mbio->bi_end_io	=3D raid10_end_write_request;
-		mbio->bi_rw =3D WRITE | do_sync | do_fua | do_discard;
-		mbio->bi_private =3D r10_bio;
-
-		atomic_inc(&r10_bio->remaining);
-		spin_lock_irqsave(&conf->device_lock, flags);
-		bio_list_add(&conf->pending_bio_list, mbio);
-		conf->pending_count++;
-		spin_unlock_irqrestore(&conf->device_lock, flags);
-		if (!mddev_check_plugged(mddev))
-			md_wakeup_thread(mddev->thread);
 	}
=20
 	/* Don't remove the bias on 'remaining' (one_write_done) until



commit 884162df2aadd7414bef4935e1a54976fd4e3988
Author: NeilBrown <neilb@suse.de>
Date:   Thu Nov 22 15:12:09 2012 +1100

    md/raid10: decrement correct pending counter when writing to replacemen=
t.
   =20
    When a write to a replacement device completes, we carefully
    and correctly found the rdev that the write actually went to
    and the blithely called rdev_dec_pending on the primary rdev,
    even if this write was to the replacement.
   =20
    This means that any writes to an array while a replacement
    was ongoing would cause the nr_pending count for the primary
    device to go negative, so it could never be removed.
   =20
    This bug has been present since replacement was introduced in
    3.3, so it is suitable for any -stable kernel since then.
   =20
    Reported-by: "George Spelvin" <linux@horizon.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ad03251..0d5d0ff 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -499,7 +499,7 @@ static void raid10_end_write_request(struct bio *bio, i=
nt error)
 	 */
 	one_write_done(r10_bio);
 	if (dec_rdev)
-		rdev_dec_pending(conf->mirrors[dev].rdev, conf->mddev);
+		rdev_dec_pending(rdev, conf->mddev);
 }
=20
 /*

--Sig_/hBT1hAwYrIUHUwyneZE/WwK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUK2omjnsnt1WYoG5AQJZBA/+PFSevV6MALHU8IQbCkM3dSgXLAGJMjkr
z0GflIqLj6QA9T2bfx/CTSmvgjtuoiuFqtRKwZ+Q1NI7WWfEWJQmfciNvc0ROAzR
fDJgkkHylic+HvrMmzPxBmxMGFQor8NMgKi6pkYGZHWWqa7szOotG6XOZsSN015b
sRYbNVee0CEa9a5WrUDR9K3aAOV/L8e/LPBg5k/pNEpIZzPFvMhSx09COYFYayqE
bcl6feFkNti9lfivMOSHVDnQlMi2QJJ5cpmYbyFY/qpy/7m5ursK/ewgi57pSCRP
R4MZfOLDohtJvTBti5a9sRNUtIhVOGvhbme0ioxQaPXIBp11yO885nhs+9QfApO1
XnH43dLV3FE63laeHkzrDzGjShg6KZGZ7ot2t1iTAvh4OXiURsHPeRSykVavj0Ce
42jaGmQds+EMtH+t2N10VPix+prdR625bnui6K8dvfe3uWxKCZCpAaJZ+iW0gT3k
CqXiidRFpAJ5L813MmdtRLTKPGnoIXp2xgARtXXfPkBt2oNU9mZhGB0FG1CutpGL
KbQKmq2TjkHU40F0yFP2p3qMQBkyc4ySeQqLRAUJBYDD6yRBmkOZugqFcl9EUFlg
2r9LsZJgiaiE421uNp/CfPxcYvvKx5s9x6udPaGC6nRi8Ejw0WwQRPjuwybAElP2
ke6y2qWNa9U=
=CLsQ
-----END PGP SIGNATURE-----

--Sig_/hBT1hAwYrIUHUwyneZE/WwK--
