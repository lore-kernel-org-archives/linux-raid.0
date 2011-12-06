From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH] md: Add ability for disable bad block management
Date: Tue, 6 Dec 2011 13:02:21 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A055919@IRSMSX101.ger.corp.intel.com>
References: <20111124121953.5509.28118.stgit@gklab-128-013.igk.intel.com>
	<20111130111403.7efd3875@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A054C28@IRSMSX101.ger.corp.intel.com>
 <20111206170525.1f4e32ab@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111206170525.1f4e32ab@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Tuesday, December 06, 2011 7:05 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin; Williams,
> Dan J
> Subject: Re: [PATCH] md: Add ability for disable bad block management
> 
> On Wed, 30 Nov 2011 08:17:32 +0000 "Kwolek, Adam"
> <adam.kwolek@intel.com>
> wrote:
> 
> >
> >
> > > -----Original Message-----
> > > From: NeilBrown [mailto:neilb@suse.de]
> > > Sent: Wednesday, November 30, 2011 1:14 AM
> > > To: Kwolek, Adam
> > > Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin;
> > > Williams, Dan J
> > > Subject: Re: [PATCH] md: Add ability for disable bad block
> > > management
> > >
> > > On Thu, 24 Nov 2011 13:19:53 +0100 Adam Kwolek
> > > <adam.kwolek@intel.com> wrote:
> > >
> > > > When external metadata doesn't support BBM, mdadm cannot answer
> > > > correctly for BBM requests. It causes reshape process being stopped.
> > > >
> > > > Add ability for external metadata /mdadm/ to disable BBM via sysfs.
> > > > md will ignore bad blocks as it is for metadata v0.90.
> > >
> > > This should not be necessary.
> > >
> > > The intention is that a device with a bad block looks exactly like a
> > > device with a failed device.  i.e. 'faulty' and 'blocked' appear in the 'state'
> > > file.
> > >
> > > If the metadata doesn't support a bad-block list, it will record
> > > that the device has failed and will unblock the device.  At that point the
> failure is forced.
> > > If the metadata does support a bad block list it will just record
> > > the bad blocks and acknowledge them, and the unblock the device.  At
> > > that point the device won't be failed, the 'faulty' state will
> > > disappear, and it will continue to be used with the known bad blocks.
> > >
> > > What exactly is going wrong that makes you think you need this patch?
> >
> >
> > When degradation occurs during migration BBM is signaled to mdmon and
> mdmon /monitor.c/ tries to mark disk  '-blocked'
> > This operation fails. Momon goes in to loop, and nothing can be done /I
> cannot make it using sysfs/ to signal or remove device.
> > In sysfs device is present in /sys/block/mdXXX/md but entry
> /sys/block/mdXXX/md/dev-sdX/~block is missing /disk was pulled out/.
> 
> 
> I've found a couple of issues.  I'm not sure if they completely explain what
> you are seeing.  Could you please test with these two fixes and tell me the
> results?
> 
> Firstly, I find that writing "-blocked" succeeds (no error returned) but the
> "blocked" flag does not get cleared, which is certainly confusing.
> 
> This is fixed by:
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c index 4adcbb4..7258dc1
> 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2562,7 +2562,8 @@ state_show(struct md_rdev *rdev, char *page)
>  		sep = ",";
>  	}
>  	if (test_bit(Blocked, &rdev->flags) ||
> -	    rdev->badblocks.unacked_exist) {
> +	    (rdev->badblocks.unacked_exist
> +	     && !test_bit(Faulty, &rdev->flags))) {
>  		len += sprintf(page+len, "%sblocked", sep);
>  		sep = ",";
>  	}
> 
> 
> Secondly mdmon writes "-blocked" even when the "blocked" flag is not set.
> This succeeds so state_store() calls
> 		sysfs_notify_dirent_safe(rdev->sysfs_state);
> 
> so mdmon/monitor.c is woken up to go around the loop again and it writes "-
> blocked" again and so it continues in a loop.
> 
> This is fixed by:
> 
> diff --git a/monitor.c b/monitor.c
> index b002e90..29bde18 100644
> --- a/monitor.c
> +++ b/monitor.c
> @@ -339,7 +339,8 @@ static int read_and_act(struct active_array *a)
>  			a->container->ss->set_disk(a, mdi->disk.raid_disk,
>  						   mdi->curr_state);
>  			check_degraded = 1;
> -			mdi->next_state |= DS_UNBLOCK;
> +			if (mdi->curr_state & DS_BLOCKED)
> +				mdi->next_state |= DS_UNBLOCK;
>  			if (a->curr_state == read_auto) {
>  				a->container->ss->set_array_state(a, 0);
>  				a->next_state = active;
> 
> 
> Finally, when a badblock is added to the list we don't currently notify
> rdev->sysfs_state so mdmon doesn't notice straight away and so is
> rdev->delayed in
> taking action.  It will only notice when a write blocks.
> 
> This is fixed by:
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c index 4adcbb4..9cc7983
> 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7940,6 +7941,7 @@ int rdev_set_badblocks(struct md_rdev *rdev,
> sector_t s, int sectors,
>  				  s + rdev->data_offset, sectors,
> acknowledged);
>  	if (rv) {
>  		/* Make sure they get written out promptly */
> +		sysfs_notify_dirent_safe(rdev->sysfs_state);
>  		set_bit(MD_CHANGE_CLEAN, &rdev->mddev->flags);
>  		md_wakeup_thread(rdev->mddev->thread);
>  	}
> 
> 
> With these 3 changes in place I get substantially improved behaviour on my
> simple test (just doing resync, not reshape).
> 
> Thanks,
> NeilBrown

I've applied those changes and:
1.  Migration:
	a) with additionally disabled BBM, reshape continues after degradation and performance is not lower (without your patches performance was poor and mdmon goes in to "crazy" run).
	b) with enabled BBM (without my change), metadata is updated correctly and md stops. mdstat shows that reshape is in progress but it is not moving forward
2. Rebuild:
	a) with additionally disabled BBM, rebuild is stopped  correctly in md and metadata just after degradation (I've got few additional corrections for metadata rebuild finalization, I'll post it shortly). 
	b) with enabled BBM (without my change), metadata is updated correctly and md stops. mdstat shows that rebuild is in progress but it is not moving forward


It seems that those changes helps for reshape performance drop after degradation and "crazy" mdmon run. 
In md without blocking BBM still md_do_sync() doesn't finish on degradation during reshape and rebuild. This causes process to be stopped.
The last information from md is print out from md_error() and it probably waits on BBM confirmation.

What can be different in my tests is that I physically pull out disks to get raid degraded (I'm not using sysfs to do this). After this rdev link in md device is invalid.

Please let me know if you want to any additional tests made by me /any specific logs?/.

BR
Adam











