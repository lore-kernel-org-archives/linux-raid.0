From: Neil Brown <neilb@suse.de>
Subject: Re: 4.1-rc6 radi5 OOPS
Date: Thu, 11 Jun 2015 16:48:47 +1000
Message-ID: <20150611164847.7cd87c13@home.neil.brown.name>
References: <wrfjlhg0mtmi.fsf@jes.lga.redhat.com>
	<20150604064048.0cb2d7c9@notabene.brown>
	<wrfjzj4glajs.fsf@jes.lga.redhat.com>
	<20150610101942.0bc26a25@home.neil.brown.name>
	<20150610115721.64c474fa@home.neil.brown.name>
	<wrfjk2vbv894.fsf@carbonite.lan.trained-monkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjk2vbv894.fsf@carbonite.lan.trained-monkey.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
List-Id: linux-raid.ids

On Wed, 10 Jun 2015 12:27:35 -0400
Jes Sorensen <Jes.Sorensen@redhat.com> wrote:

> Neil Brown <neilb@suse.de> writes:
> > On Wed, 10 Jun 2015 10:19:42 +1000 Neil Brown <neilb@suse.de> wrote:
> >
> >> So it looks like some sort of race.  I have other evidence of a race
> >> with the resync/reshape thread starting/stopping.  If I track that
> >> down it'll probably fix this issue too.
> >
> > I think I have found just such a race.  If you request a reshape just
> > as a recovery completes, you can end up with two reshapes running.
> > This causes confusion :-)
> >
> > Can you try this patch?  If I can remember how to reproduce my race
> > I'll test it on that too.
> >
> > Thanks,
> > NeilBrown
> 
> Hi Neil,
> 
> Thanks for the patch - I tried with this applied, but it still crashed
> for me :( I had to mangle it manually, somehow it got modified in the
> email.

Very :-(

I had high hopes for that patch.  I cannot find anything else that could lead
to what you are seeing.  I wish I could reproduce it but it is probably highly
sensitive to timing so some hardware shows it and others don't.

It looks very much like two 'resync' threads are running at the same time.
When one finishes, it sets ->reshape_progress to -1 (MaxSector), which trips up
the other one.

In the hang that I very rarely see, one thread (presumably) finishes and sets
MD_RECOVERY_DONE, so the raid5d threads waits for the resync thread to
complete, and that thread is waiting for the raid5d to retire some stripe_heads.

... though the 'resync' thread is probably actually doing a 'reshape'...

Did you get a chance to bisect it?  I must admit that I doubt that would be
useful.  It probably starts when "md_start_sync" was introduced and maybe made
worse when some locking with mddev_lock was relaxed.

The only way I can see a race is if MD_RECOVERY_DONE gets left set.  When a new
thread is started.  md_check_recovery always clears it before starting a thread,
but raid5_start_reshape doesn't - or didn't before the patch I gave you.

It might make more sense to clear the bit in md_reap_sync_thread as below,
but if the first patch didn't work, this one is unlikely to.

Would you be able to test with the following patch?  There is a chance it might
confirm whether two sync threads are running at the same time.

Thanks,
NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d4f31e1..8eed951 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6945,7 +6945,7 @@ static int md_thread(void *arg)
 	 * bdflush, otherwise bdflush will deadlock if there are too
 	 * many dirty RAID5 blocks.
 	 */
-
+	printk("Started thread %p %s\n", thread, current->comm);
 	allow_signal(SIGKILL);
 	while (!kthread_should_stop()) {
 
@@ -6967,6 +6967,7 @@ static int md_thread(void *arg)
 		if (!kthread_should_stop())
 			thread->run(thread);
 	}
+	printk("Finished thread %p %s\n", thread, current->comm);
 
 	return 0;
 }
@@ -6992,6 +6993,7 @@ struct md_thread *md_register_thread(void (*run) (struct md_thread *),
 
 	init_waitqueue_head(&thread->wqueue);
 
+	printk("Register thread %p %s_%s\n", thread, mdname(mddev), name);
 	thread->run = run;
 	thread->mddev = mddev;
 	thread->timeout = MAX_SCHEDULE_TIMEOUT;
@@ -7954,7 +7956,7 @@ void md_do_sync(struct md_thread *thread)
 		mddev->resync_min = mddev->curr_resync_completed;
 	mddev->curr_resync = 0;
 	spin_unlock(&mddev->lock);
-
+	printk("Finished thread %p\n", thread);
 	wake_up(&resync_wait);
 	set_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
@@ -8231,6 +8233,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 	struct md_rdev *rdev;
 
 	/* resync has finished, collect result */
+	printk("Reap thread %p\n", mddev->sync_thread);
 	md_unregister_thread(&mddev->sync_thread);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
@@ -8259,6 +8262,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 	if (mddev_is_clustered(mddev))
 		md_cluster_ops->metadata_update_finish(mddev);
 	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 	clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 	clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
