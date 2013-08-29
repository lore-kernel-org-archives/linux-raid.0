From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch v3 5/5] raid5: only wakeup necessary threads
Date: Thu, 29 Aug 2013 15:40:32 +0800
Message-ID: <20130829074032.GA24012@kernel.org>
References: <20130827095038.303090029@kernel.org>
 <20130827095518.881234515@kernel.org>
 <20130828141304.5e6df26e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130828141304.5e6df26e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, tj@kernel.org, dan.j.williams@gmail.com
List-Id: linux-raid.ids

On Wed, Aug 28, 2013 at 02:13:04PM +1000, NeilBrown wrote:
> On Tue, 27 Aug 2013 17:50:43 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> 
> > @@ -229,8 +233,26 @@ static void raid5_wakeup_stripe_thread(s
> >  
> >  	group = conf->worker_groups + cpu_to_group(sh->cpu);
> >  
> > -	for (i = 0; i < conf->worker_cnt_per_group; i++)
> > -		queue_work_on(sh->cpu, raid5_wq, &group->workers[i].work);
> > +	group->workers[0].working = true;
> > +	/* at least one worker should run to avoid race */
> > +	queue_work_on(sh->cpu, raid5_wq, &group->workers[0].work);
> > +
> > +	thread_cnt = group->stripes_cnt / MAX_STRIPE_BATCH - 1;
> > +	/* wakeup more workers */
> > +	for (i = 1; i < conf->worker_cnt_per_group && thread_cnt > 0; i++) {
> > +		if (group->workers[i].working == false) {
> > +			group->workers[i].working = true;
> > +			queue_work_on(sh->cpu, raid5_wq,
> > +				      &group->workers[i].work);
> > +			thread_cnt--;
> > +		} else if (group->workers[i].working_cnt <=
> > +			   MAX_STRIPE_BATCH / 2)
> > +			/*
> > +			 * If a worker has no enough stripes handling, assume
> > +			 * it will fetch more stripes soon.
> > +			 */
> > +			thread_cnt--;
> > +	}
> >  }
> 
> I don't really understand this  "working_cnt <= MAX_STRIPE_BATCH / 2"
> heuristic.  It is at best a very coarse estimate of how long until the worker
> will get some more stripes to work on.
> I think I would simply not count any thread that is already working (except
> the first, which is always counted whether it is working or not)
> Do you see some particular gain from the counting?

Ok, looks no difference, I removed it.
 
> > -#define MAX_STRIPE_BATCH 8
> > -static int handle_active_stripes(struct r5conf *conf, int group)
> > +static int handle_active_stripes(struct r5conf *conf, int group,
> > +		struct r5worker *worker)
> >  {
> >  	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
> >  	int i, batch_size = 0;
> > @@ -4921,6 +4955,9 @@ static int handle_active_stripes(struct
> >  			(sh = __get_priority_stripe(conf, group)) != NULL)
> >  		batch[batch_size++] = sh;
> >  
> > +	if (worker)
> > +		worker->working_cnt = batch_size;
> > +
> >  	if (batch_size == 0)
> >  		return batch_size;
> 
> I think this could possibly return with ->working still 'true'.
> I think it is safest to clear it on every exit from the function

Ok, this one doesn't matter too, I fixed it.
 
Subject:raid5: only wakeup necessary threads

If there are no enough stripes to handle, we'd better not always queue all
available work_structs. If one worker can only handle small or even none
stripes, it will impact request merge and create lock contention.

With this patch, the number of work_struct running will depend on pending
stripes number. Note: some statistics info used in the patch are accessed without
locking protection. This should doesn't matter, we just try best to avoid queue
unnecessary work_struct.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   44 ++++++++++++++++++++++++++++++++++++++------
 drivers/md/raid5.h |    4 ++++
 2 files changed, 42 insertions(+), 6 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2013-08-28 16:49:51.744491417 +0800
+++ linux/drivers/md/raid5.c	2013-08-29 15:35:57.420380732 +0800
@@ -77,6 +77,7 @@ static struct workqueue_struct *raid5_wq
 #define BYPASS_THRESHOLD	1
 #define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
 #define HASH_MASK		(NR_HASH - 1)
+#define MAX_STRIPE_BATCH	8
 
 static inline struct hlist_head *stripe_hash_list(struct r5conf *conf,
 						sector_t sect)
@@ -267,6 +268,7 @@ static void raid5_wakeup_stripe_thread(s
 {
 	struct r5conf *conf = sh->raid_conf;
 	struct r5worker_group *group;
+	int thread_cnt;
 	int i, cpu = sh->cpu;
 
 	if (!cpu_online(cpu)) {
@@ -278,6 +280,8 @@ static void raid5_wakeup_stripe_thread(s
 		struct r5worker_group *group;
 		group = conf->worker_groups + cpu_to_group(cpu);
 		list_add_tail(&sh->lru, &group->handle_list);
+		group->stripes_cnt++;
+		sh->group = group;
 	}
 
 	if (conf->worker_cnt_per_group == 0) {
@@ -287,8 +291,20 @@ static void raid5_wakeup_stripe_thread(s
 
 	group = conf->worker_groups + cpu_to_group(sh->cpu);
 
-	for (i = 0; i < conf->worker_cnt_per_group; i++)
-		queue_work_on(sh->cpu, raid5_wq, &group->workers[i].work);
+	group->workers[0].working = true;
+	/* at least one worker should run to avoid race */
+	queue_work_on(sh->cpu, raid5_wq, &group->workers[0].work);
+
+	thread_cnt = group->stripes_cnt / MAX_STRIPE_BATCH - 1;
+	/* wakeup more workers */
+	for (i = 1; i < conf->worker_cnt_per_group && thread_cnt > 0; i++) {
+		if (group->workers[i].working == false) {
+			group->workers[i].working = true;
+			queue_work_on(sh->cpu, raid5_wq,
+				      &group->workers[i].work);
+			thread_cnt--;
+		}
+	}
 }
 
 static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh)
@@ -673,6 +689,10 @@ get_active_stripe(struct r5conf *conf, s
 				    !test_bit(STRIPE_EXPANDING, &sh->state))
 					BUG();
 				list_del_init(&sh->lru);
+				if (sh->group) {
+					sh->group->stripes_cnt--;
+					sh->group = NULL;
+				}
 			}
 		}
 	} while (sh == NULL);
@@ -4259,15 +4279,18 @@ static struct stripe_head *__get_priorit
 {
 	struct stripe_head *sh = NULL, *tmp;
 	struct list_head *handle_list = NULL;
+	struct r5worker_group *wg = NULL;
 
 	if (conf->worker_cnt_per_group == 0) {
 		handle_list = &conf->handle_list;
 	} else if (group != ANY_GROUP) {
 		handle_list = &conf->worker_groups[group].handle_list;
+		wg = &conf->worker_groups[group];
 	} else {
 		int i;
 		for (i = 0; i < conf->group_cnt; i++) {
 			handle_list = &conf->worker_groups[i].handle_list;
+			wg = &conf->worker_groups[i];
 			if (!list_empty(handle_list))
 				break;
 		}
@@ -4314,11 +4337,16 @@ static struct stripe_head *__get_priorit
 			if (conf->bypass_count < 0)
 				conf->bypass_count = 0;
 		}
+		wg = NULL;
 	}
 
 	if (!sh)
 		return NULL;
 
+	if (wg) {
+		wg->stripes_cnt--;
+		sh->group = NULL;
+	}
 	list_del_init(&sh->lru);
 	atomic_inc(&sh->count);
 	BUG_ON(atomic_read(&sh->count) != 1);
@@ -5025,8 +5053,8 @@ static int  retry_aligned_read(struct r5
 	return handled;
 }
 
-#define MAX_STRIPE_BATCH 8
-static int handle_active_stripes(struct r5conf *conf, int group)
+static int handle_active_stripes(struct r5conf *conf, int group,
+		struct r5worker *worker)
 {
 	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
 	int i, batch_size = 0;
@@ -5035,6 +5063,9 @@ static int handle_active_stripes(struct
 			(sh = __get_priority_stripe(conf, group)) != NULL)
 		batch[batch_size++] = sh;
 
+	if (worker)
+		worker->working_cnt = batch_size;
+
 	if (batch_size == 0)
 		return batch_size;
 	spin_unlock_irq(&conf->device_lock);
@@ -5069,7 +5100,8 @@ static void raid5_do_work(struct work_st
 
 		released = release_stripe_list(conf);
 
-		batch_size = handle_active_stripes(conf, group_id);
+		batch_size = handle_active_stripes(conf, group_id, worker);
+		worker->working = false;
 		if (!batch_size && !released)
 			break;
 		handled += batch_size;
@@ -5131,7 +5163,7 @@ static void raid5d(struct md_thread *thr
 			handled++;
 		}
 
-		batch_size = handle_active_stripes(conf, ANY_GROUP);
+		batch_size = handle_active_stripes(conf, ANY_GROUP, NULL);
 		if (!batch_size && !released)
 			break;
 		handled += batch_size;
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2013-08-28 16:49:51.744491417 +0800
+++ linux/drivers/md/raid5.h	2013-08-28 16:49:51.744491417 +0800
@@ -214,6 +214,7 @@ struct stripe_head {
 	enum reconstruct_states reconstruct_state;
 	spinlock_t		stripe_lock;
 	int			cpu;
+	struct r5worker_group	*group;
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
@@ -370,12 +371,15 @@ struct disk_info {
 struct r5worker {
 	struct work_struct work;
 	struct r5worker_group *group;
+	int working_cnt:8;
+	bool working;
 };
 
 struct r5worker_group {
 	struct list_head handle_list;
 	struct r5conf *conf;
 	struct r5worker *workers;
+	int stripes_cnt;
 };
 
 #define NR_STRIPE_HASH_LOCKS 8
