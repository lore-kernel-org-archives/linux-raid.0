From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: Re: [PATCH] md: fix unchecked interruptible mutex locks
Date: Thu, 14 Apr 2011 11:56:57 +0400
Message-ID: <4DA6A8C9.3060705@ispras.ru>
References: <4DA698BE.70903@ispras.ru> <20110414170814.40f4d3eb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110414170814.40f4d3eb@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 04/14/2011 11:08 AM, NeilBrown wrote:
> 
> I would mark mddev_lock as __must_check__ (or however it is spelt) and fix
> the errors produced.
> 
> I think the call in md_stop_writes is the only one where an uninterruptible
> wait is needed - I'd probaby just change that to an explicit "mutex_lock",
> but I wouldn't be against creating "mddev_lock_uninterruptible" for that case.
> 

That is fine for me, but actually I do not see a good way to fix 
rdev_size_store as well (at least for mddev_lock(my_mddev)).
Please find another try.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/md/md.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b12b377..4f83f16 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -623,11 +623,16 @@ static mddev_t * mddev_find(dev_t unit)
 	goto retry;
 }
 
-static inline int mddev_lock(mddev_t * mddev)
+static inline int __must_check mddev_lock(mddev_t *mddev)
 {
 	return mutex_lock_interruptible(&mddev->reconfig_mutex);
 }
 
+static inline void mddev_lock_uninterruptible(mddev_t *mddev)
+{
+	return mutex_lock(&mddev->reconfig_mutex);
+}
+
 static inline int mddev_is_locked(mddev_t *mddev)
 {
 	return mutex_is_locked(&mddev->reconfig_mutex);
@@ -2610,13 +2615,18 @@ rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 		 */
 		mddev_t *mddev;
 		int overlap = 0;
+		int intr = 0;
 		struct list_head *tmp;
 
 		mddev_unlock(my_mddev);
 		for_each_mddev(mddev, tmp) {
 			mdk_rdev_t *rdev2;
 
-			mddev_lock(mddev);
+			if (mddev_lock(mddev)) {
+				mddev_put(mddev);
+				intr = 1;
+				break;
+			}
 			list_for_each_entry(rdev2, &mddev->disks, same_set)
 				if (rdev->bdev == rdev2->bdev &&
 				    rdev != rdev2 &&
@@ -2632,8 +2642,8 @@ rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 				break;
 			}
 		}
-		mddev_lock(my_mddev);
-		if (overlap) {
+		mddev_lock_uninterruptible(my_mddev);
+		if (overlap || intr) {
 			/* Someone else could have slipped in a size
 			 * change here, but doing so is just silly.
 			 * We put oldsectors back because we *know* it is
@@ -2641,7 +2651,7 @@ rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 			 * itself
 			 */
 			rdev->sectors = oldsectors;
-			return -EBUSY;
+			return overlap ? -EBUSY : -EINTR;
 		}
 	}
 	return len;
@@ -4748,7 +4758,7 @@ static void __md_stop_writes(mddev_t *mddev)
 
 void md_stop_writes(mddev_t *mddev)
 {
-	mddev_lock(mddev);
+	mddev_lock_uninterruptible(mddev);
 	__md_stop_writes(mddev);
 	mddev_unlock(mddev);
 }
-- 
1.7.1
