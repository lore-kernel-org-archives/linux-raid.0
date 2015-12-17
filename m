From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] raid5: allow r5l_io_unit allocations to fail
Date: Thu, 17 Dec 2015 23:09:57 +0100
Message-ID: <1450390197-19479-4-git-send-email-hch@lst.de>
References: <1450390197-19479-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1450390197-19479-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com, shli@fb.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

And propagate the error up the stack so we can add the stripe
to no_stripes_list and retry our log operation later.  This avoids
blocking raid5d due to reclaim, an it allows to get rid of the
deadlock-prone GFP_NOFAIL allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 49 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index e0a605f..ddee884 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -287,8 +287,10 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 	struct r5l_io_unit *io;
 	struct r5l_meta_block *block;
 
-	/* We can't handle memory allocate failure so far */
-	io = kmem_cache_zalloc(log->io_kc, GFP_NOIO | __GFP_NOFAIL);
+	io = kmem_cache_zalloc(log->io_kc, GFP_ATOMIC);
+	if (!io)
+		return NULL;
+
 	io->log = log;
 	INIT_LIST_HEAD(&io->log_sibling);
 	INIT_LIST_HEAD(&io->stripe_list);
@@ -326,8 +328,12 @@ static int r5l_get_meta(struct r5l_log *log, unsigned int payload_size)
 	    log->current_io->meta_offset + payload_size > PAGE_SIZE)
 		r5l_submit_current_io(log);
 
-	if (!log->current_io)
+	if (!log->current_io) {
 		log->current_io = r5l_new_meta(log);
+		if (!log->current_io)
+			return -ENOMEM;
+	}
+
 	return 0;
 }
 
@@ -372,11 +378,12 @@ static void r5l_append_payload_page(struct r5l_log *log, struct page *page)
 	r5_reserve_log_entry(log, io);
 }
 
-static void r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
+static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 			   int data_pages, int parity_pages)
 {
 	int i;
 	int meta_size;
+	int ret;
 	struct r5l_io_unit *io;
 
 	meta_size =
@@ -385,7 +392,10 @@ static void r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 		sizeof(struct r5l_payload_data_parity) +
 		sizeof(__le32) * parity_pages;
 
-	r5l_get_meta(log, meta_size);
+	ret = r5l_get_meta(log, meta_size);
+	if (ret)
+		return ret;
+
 	io = log->current_io;
 
 	for (i = 0; i < sh->disks; i++) {
@@ -415,6 +425,8 @@ static void r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 	list_add_tail(&sh->log_list, &io->stripe_list);
 	atomic_inc(&io->pending_stripe);
 	sh->log_io = io;
+
+	return 0;
 }
 
 static void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
@@ -429,6 +441,7 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 	int meta_size;
 	int reserve;
 	int i;
+	int ret = 0;
 
 	if (!log)
 		return -EAGAIN;
@@ -477,18 +490,24 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 	mutex_lock(&log->io_mutex);
 	/* meta + data */
 	reserve = (1 + write_disks) << (PAGE_SHIFT - 9);
-	if (r5l_has_free_space(log, reserve))
-		r5l_log_stripe(log, sh, data_pages, parity_pages);
-	else {
-		spin_lock(&log->no_space_stripes_lock);
-		list_add_tail(&sh->log_list, &log->no_space_stripes);
-		spin_unlock(&log->no_space_stripes_lock);
-
-		r5l_wake_reclaim(log, reserve);
-	}
-	mutex_unlock(&log->io_mutex);
+	if (!r5l_has_free_space(log, reserve))
+		goto err_retry;
 
+	ret = r5l_log_stripe(log, sh, data_pages, parity_pages);
+	if (ret)
+		goto err_retry;
+
+out_unlock:
+	mutex_unlock(&log->io_mutex);
 	return 0;
+
+err_retry:
+	spin_lock(&log->no_space_stripes_lock);
+	list_add_tail(&sh->log_list, &log->no_space_stripes);
+	spin_unlock(&log->no_space_stripes_lock);
+
+	r5l_wake_reclaim(log, reserve);
+	goto out_unlock;
 }
 
 void r5l_write_stripe_run(struct r5l_log *log)
-- 
1.9.1

