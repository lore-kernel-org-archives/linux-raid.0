From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: Raid0 expansion problem in md
Date: Wed, 14 Dec 2011 12:15:05 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A05FBC3@IRSMSX101.ger.corp.intel.com>
References: <79556383A0E1384DB3A3903742AAC04A05F9CF@IRSMSX101.ger.corp.intel.com>
 <20111214154219.6eadf590@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111214154219.6eadf590@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Wednesday, December 14, 2011 5:42 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Raid0 expansion problem in md
> 
> On Tue, 13 Dec 2011 15:45:30 +0000 "Kwolek, Adam"
> <adam.kwolek@intel.com>
> wrote:
> 
> > Hi Neil,
> >
> > On the latest md neil_for-linus branch I've found raid0 migration problem.
> > During OLCE in user space everything goes fine, but in kernel process is not
> moved forward.
> > /older md works fine/
> >
> > It is stopped in md in reshape_request() in line (near raid5.c:3957)
> >     wait_event(conf->wait_for_overlap,
> > atomic_read(&conf->reshape_stripes)==0);
> >
> > I've found that this problem is a side effect of patch:
> >     md/raid5: abort any pending parity operations when array fails.
> > and added line in this patch:
> >      sh->reconstruct_state = 0;
> >
> > During OLCE we are going inside because condition
> >     if (s.failed > conf->max_degraded) with values:
> >      locked=1 uptodate=5 to_read=0 to_write=0 failed=2 failed_num=4,1
> >
> > and sh->reconstruct_state is set to 0 (reconstruct_state_idle) from 6
> > (reconstruct_state_result) When sh->reconstruct_state is not reset raid0
> migration is executed without problem.
> > Problem is probably in not executed code for finishing reconstruction
> > (around raid5.c:3300)
> >
> > In our case field s.failed should not reach value 2 but we've got it for
> failed_num = 4,1.
> > It seems that '1' is failed disk for stripe in old array geometry and 4 is failed
> disk for stripe in new array geometry.
> > This means that degradation during reshape is counted two times /final
> stripe degradation is sum of old and new geometry degradation/.
> > When we reading (from old array) and writing (to new geometry) a
> > degraded stripe  and degradation is on different positions (raid0 OLCE case)
> analyse_stripe() gives us false failure information. Possible that we should
> have old_failed and new_failed counters to know in what geometry
> (old/new) failure occurs.
> >
> >
> > Here is reproduction script:
> >
> > export IMSM_NO_PLATFORM=1
> > #create container
> > mdadm -C /dev/md/imsm0 -amd -e imsm -n 4 /dev/sdb /dev/sdc /dev/sde
> > /dev/sdd -R #create array mdadm -C /dev/md/raid0vol_0 -amd -l 0
> > --chunk 64 --size  1048 -n 1 /dev/sdb  -R --force #start reshape mdadm
> > --grow /dev/md/imsm0 --raid-devices 4
> >
> >
> > Please let me know your opinion.
> 
> Thanks for the excellent problem report.
> 
> I think it is best fixed by the following patch.
> I also need to fixed up the calculate of 'degraded' so it doesn't say '2' in this
> case, which is confusing.  Then I'll commit the fixes.
> 
> 
> Thanks,
> NeilBrown

Yes this helps :)
Thanks Neil,

BR
Adam

> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c index 31670f8..858fdbb
> 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3065,11 +3065,17 @@ static void analyse_stripe(struct stripe_head *sh,
> struct stripe_head_state *s)
>  			}
>  		} else if (test_bit(In_sync, &rdev->flags))
>  			set_bit(R5_Insync, &dev->flags);
> -		else {
> +		else if (sh->sector + STRIPE_SECTORS <= rdev-
> >recovery_offset)
>  			/* in sync if before recovery_offset */
> -			if (sh->sector + STRIPE_SECTORS <= rdev-
> >recovery_offset)
> -				set_bit(R5_Insync, &dev->flags);
> -		}
> +			set_bit(R5_Insync, &dev->flags);
> +		else if (test_bit(R5_UPTODATE, &dev->flags) &&
> +			 test_bit(R5_Expanded, &dev->flags))
> +			/* If we've reshaped into here, we assume it is
> Insync.
> +			 * We will shortly update recovery_offset to make
> +			 * it official.
> +			 */
> +			set_bit(R5_Insync, &dev->flags);
> +
>  		if (rdev && test_bit(R5_WriteError, &dev->flags)) {
>  			clear_bit(R5_Insync, &dev->flags);
>  			if (!test_bit(Faulty, &rdev->flags)) {
