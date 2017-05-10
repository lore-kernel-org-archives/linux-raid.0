From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v4 2/2] md/r5cache: gracefully handle journal device
 errors for writeback mode
Date: Wed, 10 May 2017 15:51:03 -0700
Message-ID: <20170510225103.gc34fpaqmesvadgi@kernel.org>
References: <20170509003925.3480693-1-songliubraving@fb.com>
 <20170509003925.3480693-2-songliubraving@fb.com>
 <20170510170043.4v4ijoxmfty6hndf@kernel.org>
 <72F7A8AB-A6BD-4C52-B8AF-11C5E71CFEF4@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <72F7A8AB-A6BD-4C52-B8AF-11C5E71CFEF4@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, "neilb@suse.com" <neilb@suse.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
List-Id: linux-raid.ids

On Wed, May 10, 2017 at 09:45:05PM +0000, Song Liu wrote:
> 
> > On May 10, 2017, at 10:01 AM, Shaohua Li <shli@kernel.org> wrote:
> > 
> > On Mon, May 08, 2017 at 05:39:25PM -0700, Song Liu wrote:
> >> For the raid456 with writeback cache, when journal device failed during
> >> normal operation, it is still possible to persist all data, as all
> >> pending data is still in stripe cache. However, it is necessary to handle
> >> journal failure gracefully.
> >> 
> >> During journal failures, this patch makes the follow changes to land data
> >> in cache to raid disks gracefully:
> >> 
> >> 1. In handle_stripe(), allow stripes with data in journal (s.injournal > 0)
> >>   to make progress;
> >> 2. In delay_towrite(), only process data in the cache (skip dev->towrite);
> >> 3. In __get_priority_stripe(), set try_loprio to true, so no stripe stuck
> >>   in loprio_list
> > 
> > Applied the first patch. For this patch, I don't have a clear picture about
> > what you are trying to do. Please describe the steps we are doing to do after
> > journal failure.
> 
> I will add more description to the next version. 
> 
> > 
> >> Signed-off-by: Song Liu <songliubraving@fb.com>
> >> ---
> >> drivers/md/raid5-cache.c | 13 ++++++++++---
> >> drivers/md/raid5-log.h   |  3 ++-
> >> drivers/md/raid5.c       | 29 +++++++++++++++++++++++------
> >> 3 files changed, 35 insertions(+), 10 deletions(-)
> >> 
> >> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> >> index dc1dba6..e6032f6 100644
> >> --- a/drivers/md/raid5-cache.c
> >> +++ b/drivers/md/raid5-cache.c
> >> @@ -24,6 +24,7 @@
> >> #include "md.h"
> >> #include "raid5.h"
> >> #include "bitmap.h"
> >> +#include "raid5-log.h"
> >> 
> >> /*
> >>  * metadata/data stored in disk with 4k size unit (a block) regardless
> >> @@ -679,6 +680,7 @@ static void r5c_disable_writeback_async(struct work_struct *work)
> >> 		return;
> >> 	pr_info("md/raid:%s: Disabling writeback cache for degraded array.\n",
> >> 		mdname(mddev));
> >> +	md_update_sb(mddev, 1);
> > 
> > Why this? And md_update_sb must be called within mddev->reconfig_mutex locked.
> 
> This is to avoid skipping in handle_stripe():
> 
>         if (s.handle_bad_blocks ||
>             test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags)) {
>                 set_bit(STRIPE_HANDLE, &sh->state);
>                 goto finish;
>         }
> 
> I haven't got a better idea than calling md_update_sb() somewhere. It is also tricky
> to lock mddev->reconfigured_mutex here, due to potential deadlocking with 
> mddev->open_mutex. 
> 
> Do you have suggestions on this?

This sounds not necessary then. The mddev->thread will call md_update_sb and
clear the MD_SB_CHANGE_PENDING bit. After that, the stripes will be handled.
This is running in a workqueue, I'm wondering what kind of deadlock issue there
is.

> 
> >> 	mddev_suspend(mddev);
> >> 	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
> >> 	mddev_resume(mddev);
> >> @@ -1557,6 +1559,8 @@ void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
> >> void r5l_quiesce(struct r5l_log *log, int state)
> >> {
> >> 	struct mddev *mddev;
> >> +	struct r5conf *conf;
> >> +
> >> 	if (!log || state == 2)
> >> 		return;
> >> 	if (state == 0)
> >> @@ -1564,10 +1568,12 @@ void r5l_quiesce(struct r5l_log *log, int state)
> >> 	else if (state == 1) {
> >> 		/* make sure r5l_write_super_and_discard_space exits */
> >> 		mddev = log->rdev->mddev;
> >> +		conf = mddev->private;
> >> 		wake_up(&mddev->sb_wait);
> >> 		kthread_park(log->reclaim_thread->tsk);
> >> 		r5l_wake_reclaim(log, MaxSector);
> >> -		r5l_do_reclaim(log);
> >> +		if (!r5l_log_disk_error(conf))
> >> +			r5l_do_reclaim(log);
> > 
> > I think r5c_disable_writeback_async() will call into this, so we flush all
> > stripe cache out to raid disks, why skip the reclaim?
> > 
> 
> r5l_do_reclaim() reclaims log space with 2 steps:
> 1. clear all io_unit lists (flushing_ios, etc.) by waking up mddev->thread. 
> 2. update log_tail in the journal device, and issue discard to journal device. 
> 
> When we are handling log failures in r5c_disable_writeback_async(), we are 
> flushing the cache, so it is not necessary to wake up mddev->thread. Also, 
> with log device error, it is not necessary update log_tail or issue discard. 
> 
> Therefore, r5l_do_reclaim is not necessary in log disk errors. 

Ok, there is no side effect, right? let's call it anyway.

Thanks,
Shaohua
