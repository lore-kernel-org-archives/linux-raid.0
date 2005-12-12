From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 006 of 20] Make a couple of names in md.c static
Date: Mon, 12 Dec 2005 14:14:06 +1100
Message-ID: <1051212031406.4993@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


.. because they aren't used outside md.c

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c           |    4 ++--
 ./include/linux/raid/md_k.h |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-12 10:45:30.000000000 +1100
+++ ./drivers/md/md.c	2005-12-12 10:45:36.000000000 +1100
@@ -144,7 +144,7 @@ static int start_readonly;
  *  start array, stop array, error, add device, remove device,
  *  start build, activate spare
  */
-DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
+static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
 static atomic_t md_event_count;
 void md_new_event(mddev_t *mddev)
 {
@@ -279,7 +279,7 @@ static inline void mddev_unlock(mddev_t 
 	md_wakeup_thread(mddev->thread);
 }
 
-mdk_rdev_t * find_rdev_nr(mddev_t *mddev, int nr)
+static mdk_rdev_t * find_rdev_nr(mddev_t *mddev, int nr)
 {
 	mdk_rdev_t * rdev;
 	struct list_head *tmp;

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-12-12 10:45:26.000000000 +1100
+++ ./include/linux/raid/md_k.h	2005-12-12 10:45:36.000000000 +1100
@@ -263,8 +263,6 @@ static inline char * mdname (mddev_t * m
 	return mddev->gendisk ? mddev->gendisk->disk_name : "mdX";
 }
 
-extern mdk_rdev_t * find_rdev_nr(mddev_t *mddev, int nr);
-
 /*
  * iterates through some rdev ringlist. It's safe to remove the
  * current 'rdev'. Dont touch 'tmp' though.
