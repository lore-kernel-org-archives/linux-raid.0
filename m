From: Neil Brown <neilb@suse.de>
Subject: Re: [md PATCH 2/5]  md: Enable reshape for external metadata
Date: Thu, 17 Jun 2010 16:11:35 +1000
Message-ID: <20100617161135.73a377a0@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D11EECE8A2@irsmsx503.ger.corp.intel.com>
	<20100616145343.1fc13b4c@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D11F2FF471@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D11F2FF471@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Wed, 16 Jun 2010 15:52:06 +0100
"Kwolek, Adam" <adam.kwolek@intel.com> wrote:

> > -----Original Message-----
> > From: Neil Brown [mailto:neilb@suse.de]
> > Sent: Wednesday, June 16, 2010 6:54 AM
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed
> > Subject: Re: [md PATCH 2/5] md: Enable reshape for external metadata
> > 
> > On Wed, 9 Jun 2010 15:21:05 +0100
> > "Kwolek, Adam" <adam.kwolek@intel.com> wrote:
> > 
> > > (md: Online Capacity Expansion for IMSM)
> > > Reshape can't go forward for external metadatas due to fact, that
> > internal md flags are updated during native meta writing. For external
> > metadatas
> > > md_update_sb() is not called (reshape process is blocked).
> > > To take carry about md flags in external metadata array case and
> > allow reshape to roll over, md_update_sb() is called in similar way to
> > native metadata. The difference is that metadata is not stored to disks
> > by md, but externally by mdmon.
> > 
> > I agree there is a problem here but I think you are approaching it the
> > wrong
> > way.  We need to make sure the problem flag doesn't get set when
> > external
> > metadata is used.
> > 
> > I found something similar (maybe the same thing) when writing the dm-
> > raid456
> > module.  Does that patch:
> > 
> > http://neil.brown.name/git?p=md;a=commitdiff;h=3b930b37e50702f97f8fad6d
> > 7f5ee6d3f268394e
> > 
> > solve the problem for you?
> > 
> > Thanks,
> > NeilBrown
> 
> It almost solves problem.
> To make it solved the following change I have to add:
> 
> md/md.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/md/md.c b/md/md.c
> index e9b5d67..01e88cd 100644
> --- a/md/md.c
> +++ b/md/md.c
> @@ -6437,7 +6437,8 @@ int md_allow_write(mddev_t *mddev)
>  	spin_lock_irq(&mddev->write_lock);
>  	if (mddev->in_sync) {
>  		mddev->in_sync = 0;
> -		set_bit(MD_CHANGE_CLEAN, &mddev->flags);
> +		if (mddev->persistent)
> +			set_bit(MD_CHANGE_CLEAN, &mddev->flags);
>  		if (mddev->safemode_delay &&
>  		    mddev->safemode == 0)
>  			mddev->safemode = 1;
> 
> This closes MD_CHANGE_CLEAN flag management for me.
> What do you think about this?

No, that would be wrong.

If the array is 'clean' and a write happens, the array_state changes to
"write_pending" and the write blocks until mdmon updates the metadata and
then writes "active" to "array_state".

Setting MD_CHANGE_CLEAN is important for this handshake to work properly.


> 
> Another thing is waiting during reshape for metadata update on MD_CHANGE_DEVS flag. 
> To roll reshape I've added the following code (instead calling md_ubdate_sb()):

Yes, there is a real issue there...

I don't think we ever need the kernel to wait for an external metadata handler
to respond to device changes (apart from failure which is handled separately).
So maybe the best thing is to guard all settings of MD_CHANGE_DEVS with
if (mddev->persistent)

I think that would be best, but I've make a note to review that later.

Thanks,
NeilBrown


> 
> 
> diff --git a/md/md.c b/md/md.c
> index 01e88cd..539b323 100644
> --- a/md/md.c
> +++ b/md/md.c
> @@ -6896,8 +6896,17 @@ void md_check_recovery(mddev_t *mddev)
>  		(mddev->external == 0 && mddev->safemode == 1) ||
>  		(mddev->safemode == 2 && ! atomic_read(&mddev->writes_pending)
>  		 && !mddev->in_sync && mddev->recovery_cp == MaxSector)
> -		))
> +		)) {
> +			if ((mddev->external) && (mddev->flags)) {
> +				/* FIXME: 
> +				 * for external metadata checkpointing purposes
> +				 * put communication with userspace here
> +				 */
> +				clear_bit(MD_CHANGE_DEVS, &mddev->flags);
> +				wake_up(&mddev->sb_wait);
> +			}
>  			return;
> +		}
>  
>  	if (mddev_trylock(mddev)) {
>  		int spares = 0;
> 
> 
> This change we can reuse for checkpointing purposes.
> External metadata updates can be triggered in the same moments as native one (reuse internal md communication mechanisms).
> 
> What is your opinion about this?
> 
> BR
> Adam
> 

