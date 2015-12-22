From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] raid5: allow r5l_io_unit allocations to fail
Date: Tue, 22 Dec 2015 16:20:50 +0100
Message-ID: <20151222152050.GA28310@lst.de>
References: <1450390197-19479-1-git-send-email-hch@lst.de> <1450390197-19479-4-git-send-email-hch@lst.de> <20151217234748.GA1860175@devbig084.prn1.facebook.com> <874mfg8qyc.fsf@notabene.neil.brown.name> <20151218015847.GA2146501@devbig084.prn1.facebook.com> <20151218112535.GB28224@lst.de> <20151218230657.GA342953@devbig084.prn1.facebook.com> <87vb7s680r.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87vb7s680r.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I wonder if we should have a mempool for these io units too.
> We would allocate with GFP_ATOMIC (or similar) so the allocation woult
> fail instead of blocking, but we would then know that an allocation
> could only fail if there was another request in flight.  So the place
> where we free an io_unit would be the obviously correct place to trigger
> a retry of the delayed-due-to-mem-allocation-failure stripes.
> 
> So I think I would prefer two lists, another mempool, and very well
> defined places to retry the two lists.  Is that over-engineering?

How about the variant below (relative to md/for-next)?  This implements
the above and passes testing fine:

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 18de1fc..4fa9457 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -75,7 +75,10 @@ struct r5l_log {
 	struct list_head finished_ios;	/* io_units which settle down in log disk */
 	struct bio flush_bio;
 
+	struct list_head no_mem_stripes;   /* pending stripes, -ENOMEM */
+
 	struct kmem_cache *io_kc;
+	mempool_t *io_pool;
 	struct bio_set *bs;
 	mempool_t *meta_pool;
 
@@ -287,9 +290,10 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 	struct r5l_io_unit *io;
 	struct r5l_meta_block *block;
 
-	io = kmem_cache_zalloc(log->io_kc, GFP_ATOMIC);
+	io = mempool_alloc(log->io_pool, GFP_ATOMIC);
 	if (!io)
 		return NULL;
+	memset(io, 0, sizeof(*io));
 
 	io->log = log;
 	INIT_LIST_HEAD(&io->log_sibling);
@@ -490,24 +494,25 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 	mutex_lock(&log->io_mutex);
 	/* meta + data */
 	reserve = (1 + write_disks) << (PAGE_SHIFT - 9);
-	if (!r5l_has_free_space(log, reserve))
-		goto err_retry;
+	if (!r5l_has_free_space(log, reserve)) {
+		spin_lock(&log->no_space_stripes_lock);
+		list_add_tail(&sh->log_list, &log->no_space_stripes);
+		spin_unlock(&log->no_space_stripes_lock);
+
+		r5l_wake_reclaim(log, reserve);
+		goto out_unlock;
+	}
 
 	ret = r5l_log_stripe(log, sh, data_pages, parity_pages);
-	if (ret)
-		goto err_retry;
+	if (ret) {
+		spin_lock_irq(&log->io_list_lock);
+		list_add_tail(&sh->log_list, &log->no_mem_stripes);
+		spin_unlock_irq(&log->io_list_lock);
+	}
 
 out_unlock:
 	mutex_unlock(&log->io_mutex);
 	return 0;
-
-err_retry:
-	spin_lock(&log->no_space_stripes_lock);
-	list_add_tail(&sh->log_list, &log->no_space_stripes);
-	spin_unlock(&log->no_space_stripes_lock);
-
-	r5l_wake_reclaim(log, reserve);
-	goto out_unlock;
 }
 
 void r5l_write_stripe_run(struct r5l_log *log)
@@ -559,6 +564,21 @@ static sector_t r5l_reclaimable_space(struct r5l_log *log)
 				 log->next_checkpoint);
 }
 
+static void r5l_run_no_mem_stripe(struct r5l_log *log)
+{
+	struct stripe_head *sh;
+
+	assert_spin_locked(&log->io_list_lock);
+
+	if (!list_empty(&log->no_mem_stripes)) {
+		sh = list_first_entry(&log->no_mem_stripes,
+				      struct stripe_head, log_list);
+		list_del_init(&sh->log_list);
+		set_bit(STRIPE_HANDLE, &sh->state);
+		raid5_release_stripe(sh);
+	}
+}
+
 static bool r5l_complete_finished_ios(struct r5l_log *log)
 {
 	struct r5l_io_unit *io, *next;
@@ -575,7 +595,8 @@ static bool r5l_complete_finished_ios(struct r5l_log *log)
 		log->next_cp_seq = io->seq;
 
 		list_del(&io->log_sibling);
-		kmem_cache_free(log->io_kc, io);
+		mempool_free(io, log->io_pool);
+		r5l_run_no_mem_stripe(log);
 
 		found = true;
 	}
@@ -1189,6 +1210,10 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	if (!log->io_kc)
 		goto io_kc;
 
+	log->io_pool = mempool_create_slab_pool(R5L_POOL_SIZE, log->io_kc);
+	if (!log->io_pool)
+		goto io_pool;
+
 	log->bs = bioset_create(R5L_POOL_SIZE, 0);
 	if (!log->bs)
 		goto io_bs;
@@ -1203,6 +1228,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 		goto reclaim_thread;
 	init_waitqueue_head(&log->iounit_wait);
 
+	INIT_LIST_HEAD(&log->no_mem_stripes);
+
 	INIT_LIST_HEAD(&log->no_space_stripes);
 	spin_lock_init(&log->no_space_stripes_lock);
 
@@ -1219,6 +1246,8 @@ reclaim_thread:
 out_mempool:
 	bioset_free(log->bs);
 io_bs:
+	mempool_destroy(log->io_pool);
+io_pool:
 	kmem_cache_destroy(log->io_kc);
 io_kc:
 	kfree(log);
