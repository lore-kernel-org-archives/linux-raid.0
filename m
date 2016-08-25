From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/3] MD: hold mddev lock for .quiesce in md_do_sync
Date: Thu, 25 Aug 2016 10:17:17 -0700
Message-ID: <20160825171717.GA64999@kernel.org>
References: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com>
 <87y44epwb5.fsf@notabene.neil.brown.name>
 <87y44dnrz2.fsf@notabene.neil.brown.name>
 <20160806041428.GB9281@kernel.org>
 <87h9aqluoa.fsf@notabene.neil.brown.name>
 <20160817012803.GA86961@kernel.org>
 <87k2f6g496.fsf@notabene.neil.brown.name>
 <20160824052512.GA1921@kernel.org>
 <87bn0hfnq6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87bn0hfnq6.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Aug 25, 2016 at 02:59:13PM +1000, Neil Brown wrote:
> On Wed, Aug 24 2016, Shaohua Li wrote:
> 
> > On Wed, Aug 24, 2016 at 02:49:57PM +1000, Neil Brown wrote:
> >> On Wed, Aug 17 2016, Shaohua Li wrote:
> >> >> >
> >> >> > We will have the same deadlock issue with just stopping/restarting the reclaim
> >> >> > thread. As stopping the thread will wait for the thread, which probably is
> >> >> > doing r5l_do_reclaim and writting the superblock. Since we are writting the
> >> >> > superblock, we must hold the reconfig_mutex.
> >> >> 
> >> >> When you say "writing the superblock" you presumably mean "blocked in
> >> >> r5l_write_super_and_discard_space(), waiting for  MD_CHANGE_PENDING to
> >> >> be cleared" ??
> >> > right
> >> >> With a bit of care you could wait for MD_CHANGE_PENDING to clear, or for
> >> >> ->quiesce to be set, and then exit gracefully.
> >> >
> >> > Can you give details about this please? .quiesce is called with reconfig_mutex
> >> > hold, so the MD_CHANGE_PENDING will never get cleared.
> >> 
> >> raid5_quiesce(mddev, 1) sets conf->quiesce and then calls r5l_quiesce().
> >> 
> >> r5l_quiesce() tells the reclaim_thread to exit and waits for it to do so.
> >> 
> >> But the reclaim thread might be in
> >>    r5l_do_reclaim() -> r5l_write_super_and_discard_space()
> >> waiting for MD_CHANGE_PENDING to clear.  That will only get cleared when
> >> the main thread can get the reconfig_mutex, which the thread calling
> >> raid5_quiesce() might hold.  So we get a deadlock.
> >> 
> >> My suggestion is to change r5l_write_super_and_discard_space() so that
> >> it waits for *either* MD_CHANGE_PENDING to be clear, or conf->quiesce
> >> to be set.  That will avoid the deadlock.
> >> 
> >> Whatever thread called raid5_quiesce() will now be in control of the
> >> array without any async IO going on.  If it needs the metadata to be
> >> sync, it can do that itself.  If not, then it doesn't really matter that
> >> r5l_write_super_and_discard_space() didn't wait.
> >
> > I'm afraid waiting conf->quiesce set isn't safe. The reason to wait for
> > superblock write isn't because of async IO. discard could zero data, so before
> > we do discard, we must make sure superblock points to correct log tail,
> > otherwise recovery will not work. This is the reason we wait for superblock
> > write.
> >
> >> r5l_write_super_and_discard_space() shouldn't call discard if the
> >> superblock write didn't complete, and probably r5l_do_reclaim()
> >> shouldn't update last_checkpoint and last_cp_seq in that case.
> >> This is what I mean by "with a bit of care" and "exit gracefully".
> >> Maybe I should have said "abort cleanly".  The goal is to get the thread
> >> to exit.  It doesn't need to complete what it was doing, it just needs
> >> to make sure that it leaves things in a tidy state so that when it
> >> starts up again, it can pick up where it left off.
> >
> > Agree, we could ignore discard sometime, which happens occasionally, so impact
> > is little. I tested something like below recently. Assume this is the solution
> > we agree on?
> 
> Yes, this definitely looks like it is heading in the right direction.
> 
> I thought that
> 
> > -		set_mask_bits(&mddev->flags, 0,
> > -			      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
> > -		md_wakeup_thread(mddev->thread);
> 
> would still be there in the case that the lock cannot be claimed.

yep, this makes sense.
> You could even record the ->events value before setting the flags,
> and record the range that needs to be discarded.  Next time
> r5l_do_reclaim is entered, if ->events has moved on, then it should be
> safe to discard the recorded range.  Maybe.

I thought something like this too, but looks there are more works to do to make
this happen. We updated the log, so the range could be reused soon. And if it's
a raid array stop, we don't have the chance to reenter reclaim, which I believe
it's the most common case the lock can't be hold. And missing discard isn't a
big issue especially since the miss happens rarely. I'm going to commit below
if no objection.

Thanks,
Shaohua


commit 93e297c0b152667cc4a17db6fe7360dab7e3e9d5
Author: Shaohua Li <shli@fb.com>
Date:   Thu Aug 25 10:09:39 2016 -0700

    raid5-cache: fix a deadlock in superblock write
    
    There is a potential deadlock in superblock write. Discard could zero data, so
    before discard we must make sure superblock is updated to new log tail.
    Updating superblock (either directly call md_update_sb() or depend on md
    thread) must hold reconfig mutex. On the other hand, raid5_quiesce is called
    with reconfig_mutex hold. The first step of raid5_quiesce() is waitting for all
    IO finish, hence waitting for reclaim thread, while reclaim thread is calling
    this function and waitting for reconfig mutex. So there is a deadlock. We
    workaround this issue with a trylock. The downside of the solution is we could
    miss discard if we can't take reconfig mutex. But this should happen rarely
    (mainly in raid array stop), so miss discard shouldn't be a big problem.
    
    Cc: NeilBrown <neilb@suse.com>
    Signed-off-by: Shaohua Li <shli@fb.com>

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 5504ce2..2b0589f 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -96,7 +96,6 @@ struct r5l_log {
 	spinlock_t no_space_stripes_lock;
 
 	bool need_cache_flush;
-	bool in_teardown;
 };
 
 /*
@@ -704,31 +703,22 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
 
 	mddev = log->rdev->mddev;
 	/*
-	 * This is to avoid a deadlock. r5l_quiesce holds reconfig_mutex and
-	 * wait for this thread to finish. This thread waits for
-	 * MD_CHANGE_PENDING clear, which is supposed to be done in
-	 * md_check_recovery(). md_check_recovery() tries to get
-	 * reconfig_mutex. Since r5l_quiesce already holds the mutex,
-	 * md_check_recovery() fails, so the PENDING never get cleared. The
-	 * in_teardown check workaround this issue.
+	 * Discard could zero data, so before discard we must make sure
+	 * superblock is updated to new log tail. Updating superblock (either
+	 * directly call md_update_sb() or depend on md thread) must hold
+	 * reconfig mutex. On the other hand, raid5_quiesce is called with
+	 * reconfig_mutex hold. The first step of raid5_quiesce() is waitting
+	 * for all IO finish, hence waitting for reclaim thread, while reclaim
+	 * thread is calling this function and waitting for reconfig mutex. So
+	 * there is a deadlock. We workaround this issue with a trylock.
+	 * FIXME: we could miss discard if we can't take reconfig mutex
 	 */
-	if (!log->in_teardown) {
-		set_mask_bits(&mddev->flags, 0,
-			      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
-		md_wakeup_thread(mddev->thread);
-		wait_event(mddev->sb_wait,
-			!test_bit(MD_CHANGE_PENDING, &mddev->flags) ||
-			log->in_teardown);
-		/*
-		 * r5l_quiesce could run after in_teardown check and hold
-		 * mutex first. Superblock might get updated twice.
-		 */
-		if (log->in_teardown)
-			md_update_sb(mddev, 1);
-	} else {
-		WARN_ON(!mddev_is_locked(mddev));
-		md_update_sb(mddev, 1);
-	}
+	set_mask_bits(&mddev->flags, 0,
+		BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
+	if (!mddev_trylock(mddev))
+		return;
+	md_update_sb(mddev, 1);
+	mddev_unlock(mddev);
 
 	/* discard IO error really doesn't matter, ignore it */
 	if (log->last_checkpoint < end) {
@@ -827,7 +817,6 @@ void r5l_quiesce(struct r5l_log *log, int state)
 	if (!log || state == 2)
 		return;
 	if (state == 0) {
-		log->in_teardown = 0;
 		/*
 		 * This is a special case for hotadd. In suspend, the array has
 		 * no journal. In resume, journal is initialized as well as the
@@ -838,11 +827,6 @@ void r5l_quiesce(struct r5l_log *log, int state)
 		log->reclaim_thread = md_register_thread(r5l_reclaim_thread,
 					log->rdev->mddev, "reclaim");
 	} else if (state == 1) {
-		/*
-		 * at this point all stripes are finished, so io_unit is at
-		 * least in STRIPE_END state
-		 */
-		log->in_teardown = 1;
 		/* make sure r5l_write_super_and_discard_space exits */
 		mddev = log->rdev->mddev;
 		wake_up(&mddev->sb_wait);
