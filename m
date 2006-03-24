From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 3] md: Restore 'remaining' count when retrying an write operation.
Date: Fri, 24 Mar 2006 17:00:36 +1100
Message-ID: <1060324060036.2474@suse.de>
References: <20060324165531.2372.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


When retrying a write due to barrier failure, we don't reset
'remaining', so it goes negative and never hits 0 again.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |    3 +++
 1 file changed, 3 insertions(+)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2006-03-24 14:01:30.000000000 +1100
+++ ./drivers/md/raid1.c	2006-03-24 14:06:49.000000000 +1100
@@ -1402,6 +1402,9 @@ static void raid1d(mddev_t *mddev)
 			clear_bit(R1BIO_BarrierRetry, &r1_bio->state);
 			clear_bit(R1BIO_Barrier, &r1_bio->state);
 			for (i=0; i < conf->raid_disks; i++)
+				if (r1_bio->bios[i])
+					atomic_inc(&r1_bio->remaining);
+			for (i=0; i < conf->raid_disks; i++)
 				if (r1_bio->bios[i]) {
 					struct bio_vec *bvec;
 					int j;
