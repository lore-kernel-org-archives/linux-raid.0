From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 2/2] md/raid5: remove unnecessary sh->count check
Date: Wed,  6 May 2015 17:45:50 +0800
Message-ID: <1430905550-6142-2-git-send-email-yuanhan.liu@linux.intel.com>
References: <1430905550-6142-1-git-send-email-yuanhan.liu@linux.intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1430905550-6142-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
List-Id: linux-raid.ids

Remove the unnecessary "!atomic_read(&sh->count)" check, as the previous
"atomic_inc_not_zero(&sh->count)" check assures sh->count to be 0.

The only reason I can think of that we need such check is to consider
the lock race issue.

First of all, I doubt there is another process could modify an in-cache
but zero referenced sh while it's being protected by a hash lock. Hence,
I would say sh->count will be consistent to 0 in that  "if !atomic_inc_not_zero"
block.

Secondly, just assume there is a chance that someone outside the lock
modifies sh->count(by atomic_inc?). It could lead to some problem.

To make it clear, here I paste few lines of key code:

	if (!atomic_inc_not_zero(&sh->count)) {
		spin_lock(&conf->device_lock);
		if (!atomic_read(&sh->count)) {
			....
		}
		...
	}

At the time we enter the first if block, sh->count is zero. And just assume
someone increases sh->count from somewhere while acquiring the lock,
the following if block will not be executed then, leaving some fileds,
such as conf->active_stripes, not being set properly.

So, we should execute the second if block whenever we entered the first
if block no matter sh->count stays with 0 or not.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---

Neil, I'm a bit concerned that I missed something in this patch. Please
kindly correct me if I'm wrong :)

---
 drivers/md/raid5.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e7fa818..17ece2a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -570,16 +570,14 @@ static struct stripe_head *__find_stripe(struct r5conf *conf, sector_t sector,
 		if (sh->sector == sector && sh->generation == generation) {
 			if (!atomic_inc_not_zero(&sh->count)) {
 				spin_lock(&conf->device_lock);
-				if (!atomic_read(&sh->count)) {
-					if (!test_bit(STRIPE_HANDLE, &sh->state))
-						atomic_inc(&conf->active_stripes);
-					BUG_ON(list_empty(&sh->lru) &&
-					       !test_bit(STRIPE_EXPANDING, &sh->state));
-					list_del_init(&sh->lru);
-					if (sh->group) {
-						sh->group->stripes_cnt--;
-						sh->group = NULL;
-					}
+				if (!test_bit(STRIPE_HANDLE, &sh->state))
+					atomic_inc(&conf->active_stripes);
+				BUG_ON(list_empty(&sh->lru) &&
+				       !test_bit(STRIPE_EXPANDING, &sh->state));
+				list_del_init(&sh->lru);
+				if (sh->group) {
+					sh->group->stripes_cnt--;
+					sh->group = NULL;
 				}
 				atomic_inc(&sh->count);
 				spin_unlock(&conf->device_lock);
-- 
1.9.0

