From: Shaohua Li <shli@kernel.org>
Subject: [patch]raid5: get_active_stripe avoids device_lock
Date: Tue, 8 Apr 2014 12:05:53 +0800
Message-ID: <20140408040553.GB20886@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids


For sequential workload (or request size big workload), get_active_stripe can
find cached stripe. In this case, we always hold device_lock, which exposes a
lot of lock contention for such workload. If stripe count isn't 0, we don't
need hold the lock actually, since we just increase its count. And this is the
hot code path for such workload. Unfortunately we must delete the BUG_ON.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2014-04-08 09:16:39.377536607 +0800
+++ linux/drivers/md/raid5.c	2014-04-08 09:16:39.369536607 +0800
@@ -679,14 +679,9 @@ get_active_stripe(struct r5conf *conf, s
 				init_stripe(sh, sector, previous);
 				atomic_inc(&sh->count);
 			}
-		} else {
+		} else if (!atomic_add_unless(&sh->count, 1, 0)) {
 			spin_lock(&conf->device_lock);
-			if (atomic_read(&sh->count)) {
-				BUG_ON(!list_empty(&sh->lru)
-				    && !test_bit(STRIPE_EXPANDING, &sh->state)
-				    && !test_bit(STRIPE_ON_UNPLUG_LIST, &sh->state)
-					);
-			} else {
+			if (!atomic_read(&sh->count)) {
 				if (!test_bit(STRIPE_HANDLE, &sh->state))
 					atomic_inc(&conf->active_stripes);
 				BUG_ON(list_empty(&sh->lru) &&
