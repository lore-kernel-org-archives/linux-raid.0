From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 3 of 7 - Fixes to make debuging output nicer.
Date: Fri, 23 Jan 2004 11:14:24 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Ajoxs-0000jZ-00@notabene>
References: <20040123105615.2237.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This patch thanks to  Paul Clements <Paul.Clements@SteelEye.com>
and only has effect if md compile with
#define  DEBUG 1


 ----------- Diffstat output ------------
 ./drivers/md/md.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-01-23 10:32:51.000000000 +1100
+++ ./drivers/md/md.c	2004-01-23 10:34:49.000000000 +1100
@@ -2690,7 +2690,7 @@ int md_thread(void * arg)
 void md_wakeup_thread(mdk_thread_t *thread)
 {
 	if (thread) {
-		dprintk("md: waking up MD thread %p.\n", thread);
+		dprintk("md: waking up MD thread %s.\n", thread->tsk->comm);
 		set_bit(THREAD_WAKEUP, &thread->flags);
 		wake_up(&thread->wqueue);
 	}
@@ -2751,12 +2751,6 @@ void md_unregister_thread(mdk_thread_t *
 
 void md_error(mddev_t *mddev, mdk_rdev_t *rdev)
 {
-	dprintk("md_error dev:(%d:%d), rdev:(%d:%d), (caller: %p,%p,%p,%p).\n",
-		MD_MAJOR,mdidx(mddev),
-		MAJOR(rdev->bdev->bd_dev), MINOR(rdev->bdev->bd_dev),
-		__builtin_return_address(0),__builtin_return_address(1),
-		__builtin_return_address(2),__builtin_return_address(3));
-
 	if (!mddev) {
 		MD_BUG();
 		return;
@@ -2764,6 +2758,13 @@ void md_error(mddev_t *mddev, mdk_rdev_t
 
 	if (!rdev || rdev->faulty)
 		return;
+
+	dprintk("md_error dev:(%d:%d), rdev:(%d:%d), (caller: %p,%p,%p,%p).\n",
+		MD_MAJOR,mdidx(mddev),
+		MAJOR(rdev->bdev->bd_dev), MINOR(rdev->bdev->bd_dev),
+		__builtin_return_address(0),__builtin_return_address(1),
+		__builtin_return_address(2),__builtin_return_address(3));
+
 	if (!mddev->pers->error_handler)
 		return;
 	mddev->pers->error_handler(mddev,rdev);
