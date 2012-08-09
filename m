From: Shaohua Li <shli@kernel.org>
Subject: [patch 1/2 V3]MD: change the parameter of md thread
Date: Thu, 9 Aug 2012 16:57:35 +0800
Message-ID: <20120809085735.GA30111@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, dan.j.williams@gmail.com
List-Id: linux-raid.ids

Change the thread parameter, so the thread can carry extra info. Next patch
will use it.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/md.c        |    9 +++++----
 drivers/md/md.h        |    7 ++++---
 drivers/md/multipath.c |    3 ++-
 drivers/md/raid1.c     |    3 ++-
 drivers/md/raid10.c    |    3 ++-
 drivers/md/raid5.c     |    3 ++-
 6 files changed, 17 insertions(+), 11 deletions(-)

Index: linux/drivers/md/md.c
===================================================================
--- linux.orig/drivers/md/md.c	2012-08-08 11:18:52.486201816 +0800
+++ linux/drivers/md/md.c	2012-08-08 14:30:21.285768391 +0800
@@ -6676,7 +6676,7 @@ static int md_thread(void * arg)
 
 		clear_bit(THREAD_WAKEUP, &thread->flags);
 		if (!kthread_should_stop())
-			thread->run(thread->mddev);
+			thread->run(thread);
 	}
 
 	return 0;
@@ -6691,8 +6691,8 @@ void md_wakeup_thread(struct md_thread *
 	}
 }
 
-struct md_thread *md_register_thread(void (*run) (struct mddev *), struct mddev *mddev,
-				 const char *name)
+struct md_thread *md_register_thread(void (*run) (struct md_thread *),
+		struct mddev *mddev, const char *name)
 {
 	struct md_thread *thread;
 
@@ -7241,8 +7241,9 @@ EXPORT_SYMBOL_GPL(md_allow_write);
 
 #define SYNC_MARKS	10
 #define	SYNC_MARK_STEP	(3*HZ)
-void md_do_sync(struct mddev *mddev)
+void md_do_sync(struct md_thread *thread)
 {
+	struct mddev *mddev = thread->mddev;
 	struct mddev *mddev2;
 	unsigned int currspeed = 0,
 		 window;
Index: linux/drivers/md/md.h
===================================================================
--- linux.orig/drivers/md/md.h	2012-08-08 11:18:52.494201720 +0800
+++ linux/drivers/md/md.h	2012-08-08 14:28:49.298931668 +0800
@@ -540,12 +540,13 @@ static inline void sysfs_unlink_rdev(str
 	list_for_each_entry_rcu(rdev, &((mddev)->disks), same_set)
 
 struct md_thread {
-	void			(*run) (struct mddev *mddev);
+	void			(*run) (struct md_thread *thread);
 	struct mddev		*mddev;
 	wait_queue_head_t	wqueue;
 	unsigned long           flags;
 	struct task_struct	*tsk;
 	unsigned long		timeout;
+	void			*private;
 };
 
 #define THREAD_WAKEUP  0
@@ -584,7 +585,7 @@ static inline void safe_put_page(struct
 extern int register_md_personality(struct md_personality *p);
 extern int unregister_md_personality(struct md_personality *p);
 extern struct md_thread *md_register_thread(
-	void (*run)(struct mddev *mddev),
+	void (*run)(struct md_thread *thread),
 	struct mddev *mddev,
 	const char *name);
 extern void md_unregister_thread(struct md_thread **threadp);
@@ -603,7 +604,7 @@ extern void md_super_write(struct mddev
 extern void md_super_wait(struct mddev *mddev);
 extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size, 
 			struct page *page, int rw, bool metadata_op);
-extern void md_do_sync(struct mddev *mddev);
+extern void md_do_sync(struct md_thread *thread);
 extern void md_new_event(struct mddev *mddev);
 extern int md_allow_write(struct mddev *mddev);
 extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
Index: linux/drivers/md/multipath.c
===================================================================
--- linux.orig/drivers/md/multipath.c	2012-08-07 12:21:06.797276972 +0800
+++ linux/drivers/md/multipath.c	2012-08-08 11:19:15.673910298 +0800
@@ -335,8 +335,9 @@ abort:
  *	3.	Performs writes following reads for array syncronising.
  */
 
-static void multipathd (struct mddev *mddev)
+static void multipathd (struct md_thread *thread)
 {
+	struct mddev *mddev = thread->mddev;
 	struct multipath_bh *mp_bh;
 	struct bio *bio;
 	unsigned long flags;
Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c	2012-08-08 11:18:52.506201568 +0800
+++ linux/drivers/md/raid1.c	2012-08-08 11:19:15.677910253 +0800
@@ -2285,8 +2285,9 @@ read_more:
 	}
 }
 
-static void raid1d(struct mddev *mddev)
+static void raid1d(struct md_thread *thread)
 {
+	struct mddev *mddev = thread->mddev;
 	struct r1bio *r1_bio;
 	unsigned long flags;
 	struct r1conf *conf = mddev->private;
Index: linux/drivers/md/raid10.c
===================================================================
--- linux.orig/drivers/md/raid10.c	2012-08-07 12:21:06.813276770 +0800
+++ linux/drivers/md/raid10.c	2012-08-08 11:19:15.677910253 +0800
@@ -2667,8 +2667,9 @@ static void handle_write_completed(struc
 	}
 }
 
-static void raid10d(struct mddev *mddev)
+static void raid10d(struct md_thread *thread)
 {
+	struct mddev *mddev = thread->mddev;
 	struct r10bio *r10_bio;
 	unsigned long flags;
 	struct r10conf *conf = mddev->private;
Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-08-07 12:21:06.905275614 +0800
+++ linux/drivers/md/raid5.c	2012-08-08 19:10:03.578786155 +0800
@@ -4625,8 +4625,9 @@ static int handle_active_stripes(struct
  * During the scan, completed stripes are saved for us by the interrupt
  * handler, so that they will not have to wait for our next wakeup.
  */
-static void raid5d(struct mddev *mddev)
+static void raid5d(struct md_thread *thread)
 {
+	struct mddev *mddev = thread->mddev;
 	struct r5conf *conf = mddev->private;
 	int handled;
 	struct blk_plug plug;
