From: Xiao Ni <xni@redhat.com>
Subject: Re: Bad raid0 bio too large problem
Date: Thu, 24 Sep 2015 04:48:14 -0400 (EDT)
Message-ID: <2052819084.27720659.1443084494906.JavaMail.zimbra@redhat.com>
References: <wrfjoagucvyq.fsf@redhat.com> <87k2rhyiqe.fsf@notabene.neil.brown.name> <wrfjvbb12xl8.fsf@redhat.com> <87io70wmst.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87io70wmst.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, yizhan@redhat.com
List-Id: linux-raid.ids



----- Original Message -----
> From: "Neil Brown" <neilb@suse.de>
> To: "Jes Sorensen" <Jes.Sorensen@redhat.com>
> Cc: "Xiao Ni" <xni@redhat.com>, "linux-raid" <linux-raid@vger.kernel.org>, yizhan@redhat.com
> Sent: Thursday, September 24, 2015 10:53:06 AM
> Subject: Re: Bad raid0 bio too large problem
> 
> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> 
> > Neil Brown <neilb@suse.de> writes:
> >> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> >>
> >>> Hi Neil,
> >>>
> >>> I think we have some bad side effects with this patch:
> >>>
> >>> commit 199dc6ed5179251fa6158a461499c24bdd99c836
> >>> Author: NeilBrown <neilb@suse.com>
> >>> Date:   Mon Aug 3 13:11:47 2015 +1000
> >>>
> >>>     md/raid0: update queue parameter in a safer location.
> >>>     
> >>>     When a (e.g.) RAID5 array is reshaped to RAID0, the updating
> >>>     of queue parameters (e.g. max number of sectors per bio) is
> >>>     done in the wrong place.
> >>>     It should be part of ->run, but it is actually part of ->takeover.
> >>>     This means it happens before level_store() calls:
> >>>     
> >>>         blk_set_stacking_limits(&mddev->queue->limits);
> >>>     
> >>> Running the '03r0assem' test suite fills my kernel log with output like
> >>> below. Yi Zhang also had issues where writes failed too.
> >>>
> >>> robably something we need to resolve for 4.2-final or revert the
> >>> offending patch.
> >>>
> >>> Cheers,
> >>> Jes
> >>>
> >>> md: bind<loop0>
> >>> md: bind<loop1>
> >>> md: bind<loop2>
> >>> md/raid0:md2: md_size is 116736 sectors.
> >>> md: RAID0 configuration for md2 - 1 zone
> >>> md: zone0=[loop0/loop1/loop2]
> >>>       zone-offset=         0KB, device-offset=         0KB, size=
> >>>       58368KB
> >>>
> >>> md2: detected capacity change from 0 to 59768832
> >>> bio too big device loop0 (296 > 255)
> >>> bio too big device loop0 (272 > 255)
> >>
> >> 1/ Why do you blame that particular patch?
> >>
> >> 2/ Where is that error message coming from?  I cannot find "bio too big"
> >>   in the kernel (except in a comment).
> >>   Commit: 54efd50bfd87 ("block: make generic_make_request handle
> >> arbitrarily sized bios")
> >>   removed the only instance of the error message that I know of.
> >>
> >> Which kernel exactly are you testing?
> >
> > I blame it because of bisect - I revert that patch and the issue goes
> > away.
> >
> > I checked out 199dc6ed5179251fa6158a461499c24bdd99c836 in Linus' tree,
> > see the bio too large. I revert it and it goes away.
> 
> Well that's pretty convincing - thanks.
> And as you say - it is tagged for -stable so really needs to be fixed.
> 
> Stares at the code again.  And again.
> 
> Ahhh.  that patch moved the
>   blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
> to after
>  disk_stack_limits(...);
> 
> That is wrong.
> 
> Could you confirm that this fixes your test?
> 
> Thanks,
> NeilBrown
> 
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 4a13c3cb940b..0875e5e7e09a 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -431,12 +431,6 @@ static int raid0_run(struct mddev *mddev)
>  		struct md_rdev *rdev;
>  		bool discard_supported = false;
>  
> -		rdev_for_each(rdev, mddev) {
> -			disk_stack_limits(mddev->gendisk, rdev->bdev,
> -					  rdev->data_offset << 9);
> -			if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
> -				discard_supported = true;
> -		}
>  		blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
>  		blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
>  		blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sectors);
> @@ -445,6 +439,12 @@ static int raid0_run(struct mddev *mddev)
>  		blk_queue_io_opt(mddev->queue,
>  				 (mddev->chunk_sectors << 9) * mddev->raid_disks);
>  
> +		rdev_for_each(rdev, mddev) {
> +			disk_stack_limits(mddev->gendisk, rdev->bdev,
> +					  rdev->data_offset << 9);
> +			if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
> +				discard_supported = true;
> +		}
>  		if (!discard_supported)
>  			queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
>  		else
> 

Hi Neil, Jes

The problem is fixed with this patch.

Best Regards
Xiao
