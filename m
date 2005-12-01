From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 001 of 14] Support check-without-repair of raid10 arrays
Date: Thu, 1 Dec 2005 14:22:51 +1100
Message-ID: <1051201032251.29554@suse.de>
References: <20051201141508.29384.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Also keep count on the number of errors found.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c |    4 ++++
 1 file changed, 4 insertions(+)

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-11-28 10:12:52.000000000 +1100
+++ ./drivers/md/raid10.c	2005-11-28 14:01:41.000000000 +1100
@@ -1206,6 +1206,10 @@ static void sync_request_write(mddev_t *
 				break;
 		if (j == vcnt)
 			continue;
+		mddev->resync_mismatches += r10_bio->sectors;
+		if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
+			/* Don't fix anything. */
+			continue;
 		/* Ok, we need to write this bio
 		 * First we need to fixup bv_offset, bv_len and
 		 * bi_vecs, as the read request might have corrupted these
