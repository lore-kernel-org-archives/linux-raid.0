From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 5] md: Change ENOTSUPP to EOPNOTSUPP
Date: Fri, 28 Apr 2006 12:51:44 +1000
Message-ID: <1060428025144.30770@suse.de>
References: <20060428124313.29510.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Because that is what you get if a BIO_RW_BARRIER isn't supported !

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2006-04-28 12:17:27.000000000 +1000
+++ ./drivers/md/raid1.c	2006-04-28 12:17:27.000000000 +1000
@@ -315,7 +315,7 @@ static int raid1_end_write_request(struc
 		if (r1_bio->bios[mirror] == bio)
 			break;
 
-	if (error == -ENOTSUPP && test_bit(R1BIO_Barrier, &r1_bio->state)) {
+	if (error == -EOPNOTSUPP && test_bit(R1BIO_Barrier, &r1_bio->state)) {
 		set_bit(BarriersNotsupp, &conf->mirrors[mirror].rdev->flags);
 		set_bit(R1BIO_BarrierRetry, &r1_bio->state);
 		r1_bio->mddev->barriers_work = 0;
@@ -1404,7 +1404,7 @@ static void raid1d(mddev_t *mddev)
 			unplug = 1;
 		} else if (test_bit(R1BIO_BarrierRetry, &r1_bio->state)) {
 			/* some requests in the r1bio were BIO_RW_BARRIER
-			 * requests which failed with -ENOTSUPP.  Hohumm..
+			 * requests which failed with -EOPNOTSUPP.  Hohumm..
 			 * Better resubmit without the barrier.
 			 * We know which devices to resubmit for, because
 			 * all others have had their bios[] entry cleared.
