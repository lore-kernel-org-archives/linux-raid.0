From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] [RFC] md raid10: use rcu to avoid NULL dereference in
 raid10d()
Date: Fri, 17 Nov 2017 12:03:26 -0800
Message-ID: <20171117200326.xqchu3r3elzvkg7z@kernel.org>
References: <20171017163637.17132-1-colyli@suse.de>
 <87efq1k0ef.fsf@notabene.neil.brown.name>
 <87zi8oginj.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87zi8oginj.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 19, 2017 at 10:06:56AM +1100, Neil Brown wrote:
> On Wed, Oct 18 2017, NeilBrown wrote:
> 
> > On Wed, Oct 18 2017, Coly Li wrote:
> >
> >> We have a bug report about NULL dereference in md raid10 code. The
> >> operations are,
> >>  - Create a raid10 device
> >>  - add a spare disk
> >>  - disconnect one of the online disks from the raid10 device
> >>  - wait to the recovery happens on the spare disk
> >>  - remove the spare disk which is recovering
> >> And sometimes a kernel oops of NULL dereference in md raid10 module can
> >> be observed, and crash tool reports the following information:
> >>> (gdb) list *(raid10d+0xad6)
> >>> 0x5de6 is in raid10d (../drivers/md/raid10.c:2300).
> >>> 2295		 * the latter is free to free wbio2.
> >>> 2296		 */
> >>> 2297		if (wbio2 && !wbio2->bi_end_io)
> >>> 2298			wbio2 = NULL;
> >>> 2299		if (wbio->bi_end_io) {
> >>> 2300			atomic_inc(&conf->mirrors[d].rdev->nr_pending);
> >>> 2301			md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(wbio));
> >>> 2302			generic_make_request(wbio);
> >>> 2303		}
> >>> 2304		if (wbio2) {
> >> At line 2300, conf->mirrors[d].rdev is NULL, this causes a NULL pointer
> >> dereference to conf->mirrors[d].rdev->nr_pending. After reading previous
> >> raid10 patches, I find conf->mirrors[d].rdev can be NULL at any point
> >> unless,
> >>  - a counted reference is held
> >>  - ->reconfig_mutex is held, or
> >>  - rcu_read_lock() is held
> >
> > There is one other condition: MD_RECOVERY_RUNNING is set (without
> > MD_RECOVERY_DONE).
> > mirrors[d].rdev is only set to NULL by ->hot_remove_disk() which is only
> > called from remove_and_add_spares(), and that is never called while
> > resync/recovery/reshape is happening.
> > So there is no need for RCU protection here.
> >
> > Only ... remove_and_add_spares() *can* sometimes be called during
> > resync -
> > Commit: 8430e7e0af9a ("md: disconnect device from personality before trying to remove it.")
> > added a called to remove_and_add_spares() when "remove" is written to
> > the device/state attribute.  That was wrong.
> > This:
> >
> >  	} else if (cmd_match(buf, "remove")) {
> > -		if (rdev->mddev->pers) {
> > +		if (rdev->mddev->pers &&
> > +		    !test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
> >  			clear_bit(Blocked, &rdev->flags);
> >  			remove_and_add_spares(rdev->mddev, rdev);
> >
> > should fix it.
> 
> Actually, that doesn't even compile :-(
> 
> I think this is a better fix.
> Thanks,
> NeilBrown
> 
> From: NeilBrown <neilb@suse.com>
> Date: Thu, 19 Oct 2017 09:58:19 +1100
> Subject: [PATCH] md: only allow remove_and_add_spares() when no sync_thread running.
> 
> The locking protocols in md assume that a device will
> never be removed from an array during resync/recovery/reshape.
> When that isn't happening, rcu or reconfig_mutex is needed
> to protect an rdev pointer while taking a refcount.  When
> it is happening, that protection isn't needed.
> 
> Unfortuantely there is a case were remove_and_add_spares() is
> called when recovery might be happening: when "remove" is
> written to the device/state sysfs attribute.
> 
> This call is an optimization and not essential so it doesn't
> matter if it fails.
> So change remove_and_add_spares() to abort early if
> resync/recovery/reshape is happening.
> 
> As this can result in a NULL dereference, the fix is suitable
> for -stable.
> 
> Cc: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> Fixes: 8430e7e0af9a ("md: disconnect device from personality before trying to remove it.")
> Cc: stable@ver.kernel.org (v4.8+)
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  drivers/md/md.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b3192943de7d..01eac0dbca98 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8563,6 +8563,10 @@ static int remove_and_add_spares(struct mddev *mddev,
>  	int removed = 0;
>  	bool remove_some = false;

Sorry, I missed this patch.

I'd really appreciate if you can add the locking protocol into comments here,
digging changelog is much painful.
  
> +	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
> +		/* Mustn't remove devices when resync thread is running */
> +		return 0;
> +

This will bypass hotadd too, is it what we want?

Thanks,
Shaohua
>  	rdev_for_each(rdev, mddev) {
>  		if ((this == NULL || rdev == this) &&
>  		    rdev->raid_disk >= 0 &&
> -- 
> 2.14.0.rc0.dirty
> 
> 


