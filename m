From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: raid5d hangs when stopping an array during reshape
Date: Thu, 25 Feb 2016 17:05:17 +0100
Message-ID: <56CF263D.9020803@intel.com>
References: <5683E00C.1050005@intel.com>
 <CAA9_cmc3Ps2KZ6Ry-RRb96HRJxVHg51Rbnh5ckKpfhzShDnJDg@mail.gmail.com>
 <20160225000300.GA16254@kernel.org> <87r3g1ljg7.fsf@notabene.neil.brown.name>
 <20160225011710.GA27642@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160225011710.GA27642@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/25/2016 02:17 AM, Shaohua Li wrote:
> On Thu, Feb 25, 2016 at 11:31:04AM +1100, Neil Brown wrote:
>> On Thu, Feb 25 2016, Shaohua Li wrote:
>>
>>>
>>> As for the bug, write requests run in raid5d, mddev_suspend() waits for all IO,
>>> which waits for the write requests. So this is a clear deadlock. I think we
>>> should delete the check_reshape() in md_check_recovery(). If we change
>>> layout/disks/chunk_size, check_reshape() is already called. If we start an
>>> array, the .run() already handles new layout. There is no point
>>> md_check_recovery() check_reshape() again.
>>
>> Are you sure?
>> Did you look at the commit which added that code?
>> commit b4c4c7b8095298ff4ce20b40bf180ada070812d0
>>
>> When there is an IO error, reshape (or resync or recovery) will abort
>> and then possibly be automatically restarted.
> 
> thanks pointing out this. 
>> Without the check here a reshape might be attempted on an array which
>> has failed.  Not sure if that would be harmful, but it would certainly
>> be pointless.
>>
>> But you are right that this is causing the problem.
>> Maybe we should keep track of the size of the 'scribble' arrays and only
>> call resize_chunks if the size needs to change?  Similar to what
>> resize_stripes does.
> 
> yep, this is my first solution, but think check_reshape() is useless here
> later, apparently miss the restart case. I'll go this way.

My idea was to replace mddev_suspend()/mddev_resume() in resize_chunks()
with a rw lock that would prevent collisions with raid_run_ops(), since
scribble is used only there. But if the parity operations are executed
asynchronously this would also need to wait until all the submitted
operations have completed. Seems a bit overkill, but I came up with
this:

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a086014..3b7bbec 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -55,6 +55,7 @@
 #include <linux/ratelimit.h>
 #include <linux/nodemask.h>
 #include <linux/flex_array.h>
+#include <linux/delay.h>
 #include <trace/events/block.h>
 
 #include "md.h"
@@ -1267,6 +1268,8 @@ static void ops_complete_compute(void *stripe_head_ref)
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
+	atomic_dec(&sh->raid_conf->scribble_count);
+
 	/* mark the computed target(s) as uptodate */
 	mark_target_uptodate(sh, sh->ops.target);
 	mark_target_uptodate(sh, sh->ops.target2);
@@ -1314,6 +1317,9 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 
 	pr_debug("%s: stripe %llu block: %d\n",
 		__func__, (unsigned long long)sh->sector, target);
+
+	atomic_inc(&sh->raid_conf->scribble_count);
+
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 
 	for (i = disks; i--; )
@@ -1399,6 +1405,8 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
 	pr_debug("%s: stripe %llu block: %d\n",
 		__func__, (unsigned long long)sh->sector, target);
 
+	atomic_inc(&sh->raid_conf->scribble_count);
+
 	tgt = &sh->dev[target];
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 	dest = tgt->page;
@@ -1449,6 +1457,9 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 	BUG_ON(sh->batch_head);
 	pr_debug("%s: stripe %llu block1: %d block2: %d\n",
 		 __func__, (unsigned long long)sh->sector, target, target2);
+
+	atomic_inc(&sh->raid_conf->scribble_count);
+
 	BUG_ON(target < 0 || target2 < 0);
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt2->flags));
@@ -1545,6 +1556,8 @@ static void ops_complete_prexor(void *stripe_head_ref)
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
+
+	atomic_dec(&sh->raid_conf->scribble_count);
 }
 
 static struct dma_async_tx_descriptor *
@@ -1563,6 +1576,8 @@ ops_run_prexor5(struct stripe_head *sh, struct raid5_percpu *percpu,
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
+	atomic_inc(&sh->raid_conf->scribble_count);
+
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 		/* Only process blocks that are known to be uptodate */
@@ -1588,6 +1603,8 @@ ops_run_prexor6(struct stripe_head *sh, struct raid5_percpu *percpu,
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
+	atomic_inc(&sh->raid_conf->scribble_count);
+
 	count = set_syndrome_sources(blocks, sh, SYNDROME_SRC_WANT_DRAIN);
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_PQ_XOR_DST, tx,
@@ -1672,6 +1689,8 @@ static void ops_complete_reconstruct(void *stripe_head_ref)
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
+	atomic_dec(&sh->raid_conf->scribble_count);
+
 	for (i = disks; i--; ) {
 		fua |= test_bit(R5_WantFUA, &sh->dev[i].flags);
 		sync |= test_bit(R5_SyncIO, &sh->dev[i].flags);
@@ -1722,6 +1741,8 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
+	atomic_inc(&sh->raid_conf->scribble_count);
+
 	for (i = 0; i < sh->disks; i++) {
 		if (pd_idx == i)
 			continue;
@@ -1804,6 +1825,8 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 
 	pr_debug("%s: stripe %llu\n", __func__, (unsigned long long)sh->sector);
 
+	atomic_inc(&sh->raid_conf->scribble_count);
+
 	for (i = 0; i < sh->disks; i++) {
 		if (sh->pd_idx == i || sh->qd_idx == i)
 			continue;
@@ -1857,6 +1880,8 @@ static void ops_complete_check(void *stripe_head_ref)
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
+	atomic_dec(&sh->raid_conf->scribble_count);
+
 	sh->check_state = check_state_check_result;
 	set_bit(STRIPE_HANDLE, &sh->state);
 	raid5_release_stripe(sh);
@@ -1877,6 +1902,8 @@ static void ops_run_check_p(struct stripe_head *sh, struct raid5_percpu *percpu)
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
+	atomic_inc(&sh->raid_conf->scribble_count);
+
 	BUG_ON(sh->batch_head);
 	count = 0;
 	xor_dest = sh->dev[pd_idx].page;
@@ -1906,6 +1933,8 @@ static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu
 	pr_debug("%s: stripe %llu checkp: %d\n", __func__,
 		(unsigned long long)sh->sector, checkp);
 
+	atomic_inc(&sh->raid_conf->scribble_count);
+
 	BUG_ON(sh->batch_head);
 	count = set_syndrome_sources(srcs, sh, SYNDROME_SRC_ALL);
 	if (!checkp)
@@ -1927,6 +1956,7 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 	struct raid5_percpu *percpu;
 	unsigned long cpu;
 
+	down_read(&conf->scribble_lock);
 	cpu = get_cpu();
 	percpu = per_cpu_ptr(conf->percpu, cpu);
 	if (test_bit(STRIPE_OP_BIOFILL, &ops_request)) {
@@ -1985,6 +2015,7 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 				wake_up(&sh->raid_conf->wait_for_overlap);
 		}
 	put_cpu();
+	up_read(&conf->scribble_lock);
 }
 
 static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp)
@@ -2089,7 +2120,10 @@ static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
 	unsigned long cpu;
 	int err = 0;
 
-	mddev_suspend(conf->mddev);
+	down_write(&conf->scribble_lock);
+	/* wait for async operations using scribble to complete */
+	while (atomic_read(&conf->scribble_count))
+		udelay(10);
 	get_online_cpus();
 	for_each_present_cpu(cpu) {
 		struct raid5_percpu *percpu;
@@ -2109,7 +2143,8 @@ static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
 		}
 	}
 	put_online_cpus();
-	mddev_resume(conf->mddev);
+	up_write(&conf->scribble_lock);
+
 	return err;
 }
 
@@ -6501,6 +6536,8 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	spin_lock_init(&conf->device_lock);
 	seqcount_init(&conf->gen_lock);
 	mutex_init(&conf->cache_size_mutex);
+	init_rwsem(&conf->scribble_lock);
+	atomic_set(&conf->scribble_count, 0);
 	init_waitqueue_head(&conf->wait_for_quiescent);
 	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++) {
 		init_waitqueue_head(&conf->wait_for_stripe[i]);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index a415e1c..8361156 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -3,6 +3,7 @@
 
 #include <linux/raid/xor.h>
 #include <linux/dmaengine.h>
+#include <linux/rwsem.h>
 
 /*
  *
@@ -494,6 +495,9 @@ struct r5conf {
 	struct kmem_cache	*slab_cache; /* for allocating stripes */
 	struct mutex		cache_size_mutex; /* Protect changes to cache size */
 
+	struct rw_semaphore	scribble_lock;
+	atomic_t		scribble_count;
+
 	int			seq_flush, seq_write;
 	int			quiesce;
 
