From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 2/7] bcache: disable lockdep, enable CONFIG_BCACHE=m
Date: Fri, 11 May 2012 12:46:21 -0700
Message-ID: <20120511194621.25770.42902.stgit@dwillia2-linux.jf.intel.com>
References: <20120511194327.25770.79292.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120511194327.25770.79292.stgit-p8uTFz9XbKgaePuBGzJMJzMJUdESFZ8XQQ4Iyu8u01E@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: neilb-l3A5Bk7waGM@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Of course checkpatch rightly complains:

  ERROR: lockdep_no_validate class is reserved for device->mutex.

...so this is only hack for debugging.

Without this compiling as a module is not possible because the calls to
__up_write() cause:

  ERROR: "call_rwsem_wake" [drivers/block/bcache/bcache.ko] undefined!

...because __up_write is an internal rwsem detail.

lockdep_no_validate at least makes it explicit that lockdep support is a
work-in-progress.

Not-signed-off-by... need a better workaround
---
 drivers/block/bcache/btree.c |   18 ++++--------------
 kernel/lockdep.c             |    1 +
 2 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/block/bcache/btree.c b/drivers/block/bcache/btree.c
index 7e9975f..e2fc357 100644
--- a/drivers/block/bcache/btree.c
+++ b/drivers/block/bcache/btree.c
@@ -538,6 +538,7 @@ static struct btree *mca_bucket_alloc(struct cache_set *c,
 		return NULL;
 
 	init_rwsem(&b->lock);
+	lockdep_set_novalidate_class(&b->lock);
 	INIT_LIST_HEAD(&b->list);
 	INIT_DELAYED_WORK(&b->work, btree_write_work);
 	b->c = c;
@@ -1116,9 +1117,7 @@ static struct btree *btree_gc_alloc(struct btree *b, struct bkey *k,
 		b->prio_blocked++;
 
 		btree_free(n, op);
-		__up_write(&n->lock);
-
-		rwsem_release(&b->lock.dep_map, 1, _THIS_IP_);
+		up_write(&n->lock);
 	}
 
 	return b;
@@ -1218,7 +1217,7 @@ static void btree_gc_coalesce(struct btree *b, struct btree_op *op,
 	}
 
 	btree_free(r->b, op);
-	__up_write(&r->b->lock);
+	up_write(&r->b->lock);
 
 	pr_debug("coalesced %u nodes", nodes);
 
@@ -1244,7 +1243,7 @@ static int btree_gc_recurse(struct btree *b, struct btree_op *op,
 			btree_write(r, true, NULL);
 		}
 
-		__up_write(&r->lock);
+		up_write(&r->lock);
 	}
 
 	int ret = 0, stale;
@@ -1260,15 +1259,6 @@ static int btree_gc_recurse(struct btree *b, struct btree_op *op,
 			break;
 		}
 
-		/*
-		 * Fake out lockdep, because I'm a terrible person: it's just
-		 * not possible to express our lock ordering to lockdep, because
-		 * lockdep works at most in terms of a small fixed number of
-		 * subclasses, and we're just iterating through all of them in a
-		 * fixed order.
-		 */
-		rwsem_release(&r->b->lock.dep_map, 1, _THIS_IP_);
-
 		r->keys	= 0;
 		stale = btree_gc_mark(r->b, &r->keys, gc);
 
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 8889f7d..d203b16 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2997,6 +2997,7 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 EXPORT_SYMBOL_GPL(lockdep_init_map);
 
 struct lock_class_key __lockdep_no_validate__;
+EXPORT_SYMBOL_GPL(__lockdep_no_validate__);
 
 /*
  * This gets called for every mutex_lock*()/spin_lock*() operation.
