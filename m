From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 003 of 10] Make sure a user-request sync of raid5 ignores intent bitmap
Date: Wed, 2 Nov 2005 21:15:05 +1100
Message-ID: <1051102101505.23874@suse.de>
References: <20051102205640.22689.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


A sync of raid5 usually ignore blocks which the bitmap says are in-sync.
But a user-request check or repair should not ignore these.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    1 +
 1 file changed, 1 insertion(+)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-11-02 17:32:28.000000000 +1100
+++ ./drivers/md/raid5.c	2005-11-02 17:32:57.000000000 +1100
@@ -1649,6 +1649,7 @@ static sector_t sync_request(mddev_t *md
 		return rv;
 	}
 	if (!bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, 1) &&
+	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
 	    !conf->fullsync && sync_blocks >= STRIPE_SECTORS) {
 		/* we can skip this block, and probably more */
 		sync_blocks /= STRIPE_SECTORS;
