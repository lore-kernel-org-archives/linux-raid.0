From: Shaohua Li <shli@fb.com>
Subject: [PATCH 3/4] raid5: ignore released_stripes check
Date: Thu, 28 May 2015 17:33:47 -0700
Message-ID: <a1dc1deca50ae3e6cf45b94e75df3a0271a43ecd.1432859513.git.shli@fb.com>
References: <a92a0c36813c740c5de65a95b75ef161c1f2ede1.1432859513.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a92a0c36813c740c5de65a95b75ef161c1f2ede1.1432859513.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

conf->released_stripes list ins't always related if there is free
stripes pending. active stripes can be in the list too.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0cceb71..67626f3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -673,8 +673,8 @@ get_active_stripe(struct r5conf *conf, sector_t sector,
 		if (!sh) {
 			if (!test_bit(R5_INACTIVE_BLOCKED, &conf->cache_state)) {
 				sh = get_free_stripe(conf, hash);
-				if (!sh && llist_empty(&conf->released_stripes) &&
-				    !test_bit(R5_DID_ALLOC, &conf->cache_state)) {
+				if (!sh && !test_bit(R5_DID_ALLOC,
+				    &conf->cache_state)) {
 					set_bit(R5_ALLOC_MORE,
 						&conf->cache_state);
 					md_wakeup_thread(conf->mddev->thread);
-- 
1.8.1

