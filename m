From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 3/3] raid5: relieve lock contention in get_active_stripe()
Date: Thu, 12 Sep 2013 09:55:07 +0800
Message-ID: <20130912015507.GA3459@kernel.org>
References: <20130909043318.GA27517@kernel.org>
 <20130910111318.1d19e8d3@notabene.brown>
 <20130910023555.GA17907@kernel.org>
 <20130910140629.702683da@notabene.brown>
 <20130910042438.GA16797@kernel.org>
 <20130910152032.48631492@notabene.brown>
 <20130910065912.GA12038@kernel.org>
 <20130910172836.43e23cbf@notabene.brown>
 <20130910073756.GB12038@kernel.org>
 <20130911113412.5ac91a65@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130911113412.5ac91a65@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Wed, Sep 11, 2013 at 11:34:12AM +1000, NeilBrown wrote:
> On Tue, 10 Sep 2013 15:37:56 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> 
> > Below is my latest patch.
> > 
> 
> Thanks.  It looks good.
> I have pushed it out to me for-next branch (which a few cosmetic white-space
> adjustments).
> I will need to review it again but it is certainly very close to 'right'.
> 
> One thing I'm a bit concerned about is the md_raid5_congested function.
> It can return "false", yet a write can still block.
> That isn't a huge problem, but it could have some negative consequences.
> Maybe we could have an atomic_t which counts how many hash values as "full"
> and we report "congested" when any are full.  Maybe.

Since there is no overhead in hot code patch, I agree. Here is the patch:


Subject: raid5: track empty inactive list count

track empty inactive list count, so md_raid5_congested() can use it to make
decision.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |    8 +++++++-
 drivers/md/raid5.h |    1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2013-09-12 08:31:07.740146654 +0800
+++ linux/drivers/md/raid5.c	2013-09-12 09:49:32.816360986 +0800
@@ -355,6 +355,9 @@ static void release_inactive_stripe_list
 		 */
 		if (!list_empty_careful(list)) {
 			spin_lock_irqsave(conf->hash_locks + hash, flags);
+			if (list_empty(conf->inactive_list + hash) &&
+			    !list_empty(list))
+				atomic_dec(&conf->empty_inactive_list_nr);
 			list_splice_tail_init(list, conf->inactive_list + hash);
 			do_wakeup = true;
 			spin_unlock_irqrestore(conf->hash_locks + hash, flags);
@@ -475,6 +478,8 @@ static struct stripe_head *get_free_stri
 	remove_hash(sh);
 	atomic_inc(&conf->active_stripes);
 	BUG_ON(hash != sh->hash_lock_index);
+	if (list_empty(conf->inactive_list + hash))
+		atomic_inc(&conf->empty_inactive_list_nr);
 out:
 	return sh;
 }
@@ -4035,7 +4040,7 @@ int md_raid5_congested(struct mddev *mdd
 		return 1;
 	if (conf->quiesce)
 		return 1;
-	if (atomic_read(&conf->active_stripes) == conf->max_nr_stripes)
+	if (atomic_read(&conf->empty_inactive_list_nr))
 		return 1;
 
 	return 0;
@@ -5721,6 +5726,7 @@ static struct r5conf *setup_conf(struct
 
 	memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
 		 max_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
+	atomic_set(&conf->empty_inactive_list_nr, NR_STRIPE_HASH_LOCKS);
 	if (grow_stripes(conf, NR_STRIPES)) {
 		printk(KERN_ERR
 		       "md/raid:%s: couldn't allocate %dkB for buffers\n",
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2013-09-12 08:31:07.740146654 +0800
+++ linux/drivers/md/raid5.h	2013-09-12 08:33:45.666153078 +0800
@@ -470,6 +470,7 @@ struct r5conf {
 	 */
 	atomic_t		active_stripes;
 	struct list_head	inactive_list[NR_STRIPE_HASH_LOCKS];
+	atomic_t		empty_inactive_list_nr;
 	struct llist_head	released_stripes;
 	wait_queue_head_t	wait_for_stripe;
 	wait_queue_head_t	wait_for_overlap;
