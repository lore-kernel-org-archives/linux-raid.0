From: NeilBrown <neilb@suse.de>
Subject: [PATCH] md/raid5: fix bug that could result in reads from a failed
 device.
Date: Thu, 15 Dec 2011 10:54:39 +1100
Message-ID: <20111215105439.628fe074@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CXr/I+/NlhO+kIHGMMfHyHO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: linux RAID <linux-raid@vger.kernel.org>, Alexander Lyakas <alex.bolshoy@gmail.com>, tim.gardner@canonical.com
List-Id: linux-raid.ids

--Sig_/CXr/I+/NlhO+kIHGMMfHyHO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


hi Greg,
 When I sent you a backport of 355840e for 3.0.y I messed up and missed half
 of the required patch.  This is the other half.  So if 3.0 is still open f=
or
 updates I would appreciate you applying this.

Thanks,
NeilBrown


From: NeilBrown <neilb@suse.de>
Date: Thu, 15 Dec 2011 10:49:58 +1100
Subject: [PATCH] md/raid5: fix bug that could result in reads from a failed
 device.

commit 355840e7a7e56bb2834fd3b0da64da5465f8aeaa upstream.

commit a847627709b3402163d99f7c6fda4a77bcd6b51b in linux-3.0.9
attempted to backport this to 3.0 but only made one change were two
were necessary.  This add the second change.

This bug was introduced in 415e72d034c50520ddb7ff79e7d1792c1306f0c9
which was in 2.6.36.

There is a small window of time between when a device fails and when
it is removed from the array.  During this time we might still read
from it, but we won't write to it - so it is possible that we could
read stale data.

We didn't need the test of 'Faulty' before because the test on
In_sync is sufficient.  Since we started allowing reads from the early
part of non-In_sync devices we need a test on Faulty too.

This is suitable for any kernel from 2.6.36 onwards, though the patch
might need a bit of tweaking in 3.0 and earlier.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cbb50d3..1f6c68d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3078,7 +3078,7 @@ static void handle_stripe5(struct stripe_head *sh)
 			/* Not in-sync */;
 		else if (test_bit(In_sync, &rdev->flags))
 			set_bit(R5_Insync, &dev->flags);
-		else {
+		else if (!test_bit(Faulty, &rdev->flags)) {
 			/* could be in-sync depending on recovery/reshape status */
 			if (sh->sector + STRIPE_SECTORS <=3D rdev->recovery_offset)
 				set_bit(R5_Insync, &dev->flags);
--=20
1.7.7


--Sig_/CXr/I+/NlhO+kIHGMMfHyHO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuk3Pznsnt1WYoG5AQKejg/+NQC/WpHWt3yhPCQXCL48l6rPRTbcWK2N
8exFLi+XibelO9UYahERceWC70dQ/M/P7gqGwx2F8ocpQsoIOXdrpz3FsppfHdaX
FnmNwjEJy1PHxPINVHNTH2vFbPpe3UeAHpIxwv/9OgzcMBOYT1uJdCIf/S9x50Rr
fMidaSYJKootuwwl7eO79c84s0wSKMQQKRfFg7sM92ao7dQ5nVZhZWuMFmOPB/2m
3dAEEhWHVWb5d8N08NoOZHNvacYehSyTxWBYOGkrY6M/18mvnk0+Vkig/9Ue6fcM
kBZjGq/782JoBXyt+k0X91fHY6Gh2bv0/O/7pSMgoP+O5DGNE0EemqsYjmXAnOPb
L9jtvkCVHvo9HFdeaNfFmCqBd4X+8N7N0xh/tHcZvb039KjfXhVynC6UFKau7v7X
Pc7yZeMSJCxqPIaKgYjy9P5dpwUmIRl7UVnc+SDv9nOtsVUOyNbcDEwlGst1QozI
aF1MVmJaDVmwaVBVJKv0JaPfzo7Q03rlOb09DsXGa/87f7R2qPlLjDElmR2CHdjw
PDAq0DL3F6sg7dEvQSQKTvmPe7dtEIGEyV1pvqisg3UDOvB+iQvb+iiHXXGbQBS8
p5rCgAmAjszvqeltLMH7CfgdJ7OgDmH88QhvI5+RRX+KWJUINrWlQDF26xBYpsoi
r4jJlsgJmFc=
=vVZn
-----END PGP SIGNATURE-----

--Sig_/CXr/I+/NlhO+kIHGMMfHyHO--
