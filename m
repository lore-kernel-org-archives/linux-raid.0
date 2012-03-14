From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 05/23] md/raid5: use atomic_dec_return() instead of
 atomic_dec() and atomic_read().
Date: Wed, 14 Mar 2012 15:40:39 +1100
Message-ID: <20120314044039.7978.6916.stgit@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314043555.7978.75486.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: majianpeng <majianpeng@gmail.com>

Signed-off-by: majianpeng <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3f55145..99b2bbf 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -208,11 +208,10 @@ static void __release_stripe(struct r5conf *conf, struct stripe_head *sh)
 			md_wakeup_thread(conf->mddev->thread);
 		} else {
 			BUG_ON(stripe_operations_active(sh));
-			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-				atomic_dec(&conf->preread_active_stripes);
-				if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
+			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+				if (atomic_dec_return(&conf->preread_active_stripes)
+				    < IO_THRESHOLD)
 					md_wakeup_thread(conf->mddev->thread);
-			}
 			atomic_dec(&conf->active_stripes);
 			if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
 				list_add_tail(&sh->lru, &conf->inactive_list);


