From: colyli@suse.de
Subject: [PATCH v3 1/4] md: use memalloc scope APIs in mddev_suspend()/mddev_resume()
Date: Thu,  9 Apr 2020 22:17:20 +0800
Message-ID: <20200409141723.24447-2-colyli@suse.de>
References: <20200409141723.24447-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200409141723.24447-1-colyli@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: songliubraving@fb.com, linux-raid@vger.kernel.org
Cc: mhocko@suse.com, kent.overstreet@gmail.com, guoqing.jiang@cloud.ionos.com, Coly Li <colyli@suse.de>
List-Id: linux-raid.ids

From: Coly Li <colyli@suse.de>

In raid5.c:resize_chunk(), scribble_alloc() is called with GFP_NOIO
flag, then it is sent into kvmalloc_array() inside scribble_alloc().

The problem is kvmalloc_array() eventually calls kvmalloc_node() which
does not accept non GFP_KERNEL compatible flag like GFP_NOIO, then
kmalloc_node() is called indeed to allocate physically continuous
pages. When system memory is under heavy pressure, and the requesting
size is large, there is high probability that allocating continueous
pages will fail.

But simply using GFP_KERNEL flag to call kvmalloc_array() is also
progblematic. In the code path where scribble_alloc() is called, the
raid array is suspended, if kvmalloc_node() triggers memory reclaim I/Os
and such I/Os go back to the suspend raid array, deadlock will happen.

What is desired here is to allocate non-physically (a.k.a virtually)
continuous pages and avoid memory reclaim I/Os. Michal Hocko suggests
to use the mmealloc sceope APIs to restrict memory reclaim I/O in
allocating context, specifically to call memalloc_noio_save() when
suspend the raid array and to call memalloc_noio_restore() when
resume the raid array.

This patch adds the memalloc scope APIs in mddev_suspend() and
mddev_resume(), to restrict memory reclaim I/Os during the raid array
is suspended. The benifit of adding the memalloc scope API in the
unified entry point mddev_suspend()/mddev_resume() is, no matter which
md raid array type (personality), we are sure the deadlock by recursive
memory reclaim I/O won't happen on the suspending context.

Please notice that the memalloc scope APIs only take effect on the raid
array suspending context, if the memory allocation is from another new
created kthread after raid array suspended, the recursive memory reclaim
I/Os won't be restricted. The mddev_suspend()/mddev_resume() entries are
used for the critical section where the raid metadata is modifying,
creating a kthread to allocate memory inside the critical section is
queer and very probably being buggy.

Fixes: b330e6a49dc3 ("md: convert to kvmalloc")
Suggested-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/md.c | 4 ++++
 drivers/md/md.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 271e8a587354..1a8e1bb3a7f4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -527,11 +527,15 @@ void mddev_suspend(struct mddev *mddev)
 	wait_event(mddev->sb_wait, !test_bit(MD_UPDATING_SB, &mddev->flags));
 
 	del_timer_sync(&mddev->safemode_timer);
+	/* restrict memory reclaim I/O during raid array is suspend */
+	mddev->noio_flag = memalloc_noio_save();
 }
 EXPORT_SYMBOL_GPL(mddev_suspend);
 
 void mddev_resume(struct mddev *mddev)
 {
+	/* entred the memalloc scope from mddev_suspend() */
+	memalloc_noio_restore(mddev->noio_flag);
 	lockdep_assert_held(&mddev->reconfig_mutex);
 	if (--mddev->suspended)
 		return;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index acd681939112..612814d07d35 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -497,6 +497,7 @@ struct mddev {
 	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
 	struct md_cluster_info		*cluster_info;
 	unsigned int			good_device_nr;	/* good device num within cluster raid */
+	unsigned int			noio_flag; /* for memalloc scope API */
 
 	bool	has_superblocks:1;
 	bool	fail_last_dev:1;
-- 
2.25.0
