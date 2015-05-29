From: Shaohua Li <shli@fb.com>
Subject: [PATCH 1/4] raid5: wakeup raid5d when R5_ALLOC_MORE is set
Date: Thu, 28 May 2015 17:33:45 -0700
Message-ID: <a92a0c36813c740c5de65a95b75ef161c1f2ede1.1432859513.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

The run time stripe allocation is done at raid5d. When we set the
R5_ALLOC_MORE flag, we should notify raid5d to handle it

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 61e8e04..bfa2042 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -674,9 +674,11 @@ get_active_stripe(struct r5conf *conf, sector_t sector,
 			if (!test_bit(R5_INACTIVE_BLOCKED, &conf->cache_state)) {
 				sh = get_free_stripe(conf, hash);
 				if (!sh && llist_empty(&conf->released_stripes) &&
-				    !test_bit(R5_DID_ALLOC, &conf->cache_state))
+				    !test_bit(R5_DID_ALLOC, &conf->cache_state)) {
 					set_bit(R5_ALLOC_MORE,
 						&conf->cache_state);
+					md_wakeup_thread(conf->mddev->thread);
+				}
 			}
 			if (noblock && sh == NULL)
 				break;
-- 
1.8.1

