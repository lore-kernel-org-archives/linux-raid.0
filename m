From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: [PATCH 2.6] md debug fixes
Date: Thu, 22 Jan 2004 15:59:13 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <401039A1.D82E8B8D@SteelEye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------CDB33BFCD49FA98D6CE5C15E"
Return-path: <linux-raid-owner@vger.kernel.org>
To: neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------CDB33BFCD49FA98D6CE5C15E
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Neil,

While running md with debug turned on, I noticed a couple of things that
could maybe use changing. 

The first change simply makes one of the debug messages a little more
useful (printing a thread's name rather than just a hex pointer value). 

The second fix is necessary to avoid an oops when md_error is called.
Because md_error is generally called when a device has failed, the
chance of the rdev parameter being NULL is fairly high. I hit this oops
several times in testing.

Patch attached, please apply.

Thanks,
Paul
--------------CDB33BFCD49FA98D6CE5C15E
Content-Type: text/x-patch; charset=us-ascii;
 name="md_error_debug_fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_error_debug_fix.diff"

Index: drivers/md/md.c
===================================================================
RCS file: /home/cvs/CVSROOT/kernel/linux-2.6.0/drivers/md/md.c,v
retrieving revision 1.6
diff -p -u -r1.6 md.c
--- drivers/md/md.c	2004/01/12 20:33:10	1.6
+++ drivers/md/md.c	2004/01/22 19:00:35
@@ -2903,7 +2892,7 @@ int md_thread(void * arg)
 void md_wakeup_thread(mdk_thread_t *thread)
 {
 	if (thread) {
-		dprintk("md: waking up MD thread %p.\n", thread);
+		dprintk("md: waking up MD thread %s.\n", thread->tsk->comm);
 		set_bit(THREAD_WAKEUP, &thread->flags);
 		wake_up(&thread->wqueue);
 	}
@@ -2964,12 +2953,6 @@ void md_unregister_thread(mdk_thread_t *
 
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
@@ -2977,6 +2960,13 @@ void md_error(mddev_t *mddev, mdk_rdev_t
 
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

--------------CDB33BFCD49FA98D6CE5C15E--

