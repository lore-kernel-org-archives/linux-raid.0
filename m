From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: [PATCH] bcache: Remove deprecated create_workqueue
Date: Wed, 8 Jun 2016 01:57:19 +0530
Message-ID: <20160607202719.GA16208@Karyakshetra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, Eric Wheeler <git@linux.ewheeler.net>, Zheng Liu <wenqing.lz@taobao.com>, Hannes Reinecke <hare@suse.de>, Jeff Moyer <jmoyer@redhat.com>, Pekka Enberg <penberg@kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

alloc_workqueue replaces deprecated create_workqueue().

Dedicated workqueues have been used since bcache_wq and moving_gc_wq
are workqueues for writes and are being used on a memory reclaim path.
WQ_MEM_RECLAIM has been set to ensure forward progress under memory
pressure.
Since there are only a fixed number of work items, explicit concurrency
limit is unnecessary here.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/md/bcache/super.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index f5dbb4e..055c869 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1518,7 +1518,8 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	    !(c->fill_iter = mempool_create_kmalloc_pool(1, iter_size)) ||
 	    !(c->bio_split = bioset_create(4, offsetof(struct bbio, bio))) ||
 	    !(c->uuids = alloc_bucket_pages(GFP_KERNEL, c)) ||
-	    !(c->moving_gc_wq = create_workqueue("bcache_gc")) ||
+	    !(c->moving_gc_wq = alloc_workqueue("bcache_gc",
+						WQ_MEM_RECLAIM, 0)) ||
 	    bch_journal_alloc(c) ||
 	    bch_btree_cache_alloc(c) ||
 	    bch_open_buckets_alloc(c) ||
@@ -2097,7 +2098,7 @@ static int __init bcache_init(void)
 		return bcache_major;
 	}

-	if (!(bcache_wq = create_workqueue("bcache")) ||
+	if (!(bcache_wq = alloc_workqueue("bcache", WQ_MEM_RECLAIM, 0)) ||
 	    !(bcache_kobj = kobject_create_and_add("bcache", fs_kobj)) ||
 	    sysfs_create_files(bcache_kobj, files) ||
 	    bch_request_init() ||
--
2.1.4
