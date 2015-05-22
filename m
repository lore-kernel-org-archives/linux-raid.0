From: NeilBrown <neilb@suse.de>
Subject: [PATCH 3/8] md/raid5: remove condition test from
 check_break_stripe_batch_list.
Date: Fri, 22 May 2015 15:30:58 +1000
Message-ID: <20150522053058.2117.93202.stgit@notabene.brown>
References: <20150522052802.2117.40527.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150522052802.2117.40527.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

handle_stripe_clean_event() contains a chunk of code very
similar to check_break_stripe_batch_list().
If we make the latter more like the former, we can end up
with just one copy of this code.

This  first step removed the condition (and the 'check_') part
of the name.  This has the added advantage of making it clear
what check is being performed at the point where the function is
called.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9a803b735848..4952205460e5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4226,16 +4226,11 @@ static int clear_batch_ready(struct stripe_head *sh)
 	return 0;
 }
 
-static void check_break_stripe_batch_list(struct stripe_head *sh)
+static void break_stripe_batch_list(struct stripe_head *head_sh)
 {
-	struct stripe_head *head_sh, *next;
+	struct stripe_head *sh, *next;
 	int i;
 
-	if (!test_and_clear_bit(STRIPE_BATCH_ERR, &sh->state))
-		return;
-
-	head_sh = sh;
-
 	list_for_each_entry_safe(sh, next, &head_sh->batch_list, batch_list) {
 
 		list_del_init(&sh->batch_list);
@@ -4282,7 +4277,8 @@ static void handle_stripe(struct stripe_head *sh)
 		return;
 	}
 
-	check_break_stripe_batch_list(sh);
+	if (test_and_clear_bit(STRIPE_BATCH_ERR, &sh->state))
+		break_stripe_batch_list(sh);
 
 	if (test_bit(STRIPE_SYNC_REQUESTED, &sh->state) && !sh->batch_head) {
 		spin_lock(&sh->stripe_lock);


