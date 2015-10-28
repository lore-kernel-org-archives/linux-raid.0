From: Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH] md/raid5: fix locking in handle_stripe_clean_event()
Date: Wed, 28 Oct 2015 11:52:20 +0300
Message-ID: <1446022340-1453-1-git-send-email-klamm@yandex-team.ru>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Roman Gushchin <klamm@yandex-team.ru>, Neil Brown <neilb@suse.de>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-raid.ids

After commit 566c09c53455 ("raid5: relieve lock contention in get_active_stripe()")
__find_stripe() is called under conf->hash_locks + hash.
But handle_stripe_clean_event() calls remove_hash() under
conf->device_lock.

Under some cirscumstances the hash chain can be circuited,
and we get an infinite loop with disabled interrupts and locked hash
lock in __find_stripe(). This leads to hard lockup on multiple CPUs
and following system crash.

I was able to reproduce this behavior on raid6 over 6 ssd disks.
The devices_handle_discard_safely option should be set to enable trim
support. The following script was used:

for i in `seq 1 32`; do
    dd if=/dev/zero of=large$i bs=10M count=100 &
done

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
Cc: Neil Brown <neilb@suse.de>
Cc: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
Cc: <stable@vger.kernel.org> # 3.10 - 3.19
---
 drivers/md/raid5.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e421016..5fa7549 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3060,6 +3060,8 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 		}
 	if (!discard_pending &&
 	    test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags)) {
+		int hash = sh->hash_lock_index;
+
 		clear_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
 		clear_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags);
 		if (sh->qd_idx >= 0) {
@@ -3073,9 +3075,9 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 		 * no updated data, so remove it from hash list and the stripe
 		 * will be reinitialized
 		 */
-		spin_lock_irq(&conf->device_lock);
+		spin_lock_irq(conf->hash_locks + hash);
 		remove_hash(sh);
-		spin_unlock_irq(&conf->device_lock);
+		spin_unlock_irq(conf->hash_locks + hash);
 		if (test_bit(STRIPE_SYNC_REQUESTED, &sh->state))
 			set_bit(STRIPE_HANDLE, &sh->state);
 
-- 
2.4.3
