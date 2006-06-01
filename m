From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 10] md: Fix bug that stops raid5 resync from happening
Date: Thu, 1 Jun 2006 15:13:37 +1000
Message-ID: <1060601051337.27577@suse.de>
References: <20060601150955.27444.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


As data_disks is *less* than raid_disks, the current test here is
obviously wrong.  And as the difference is already available in
conf->max_degraded, it makes much more sense to use that.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2006-06-01 15:03:29.000000000 +1000
+++ ./drivers/md/raid5.c	2006-06-01 15:05:28.000000000 +1000
@@ -2858,7 +2858,7 @@ static inline sector_t sync_request(mdde
 	 * to resync, then assert that we are finished, because there is
 	 * nothing we can do.
 	 */
-	if (mddev->degraded >= (data_disks - raid_disks) &&
+	if (mddev->degraded >= conf->max_degraded &&
 	    test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
 		sector_t rv = (mddev->size << 1) - sector_nr;
 		*skipped = 1;
