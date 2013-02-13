From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: Re: Set disk faulty / hot disk remove ioctl bug for read-only MD?
Date: Wed, 13 Feb 2013 13:56:45 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1302131255510.11804@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1302121559540.11804@jlaw-desktop.mno.stratus.com> <20130213133820.6496b074@notabene.brown> <511B7CE6.5060806@profitbricks.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511B7CE6.5060806@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>, Joe Lawrence <joe.lawrence@stratus.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 13 Feb 2013, Sebastian Riemer wrote:

> On 13.02.2013 03:38, NeilBrown wrote:
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 8b557d2..292cc2f 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -6529,7 +6529,17 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
> >  			mddev->ro = 0;
> >  			sysfs_notify_dirent_safe(mddev->sysfs_state);
> >  			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> > -			md_wakeup_thread(mddev->thread);
> > +			/* mddev_unlock will wake thread */
> > +			/* If a device failed while we were read-only, we
> > +			 * need to make sure the metadata is updated now.
> > +			 */
> > +			if (test_bit(MD_CHANGE_DEVS, &mddev->flags)) {
> > +				mddev_unlock(mddev);
> > +				wait_event(mddev->sb_wait,
> > +					   !test_bit(MD_CHANGE_DEVS, &mddev->flags) &&
> > +					   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
> > +				mddev_lock(mddev);
> > +			}
> >  		} else {
> >  			err = -EROFS;
> >  			goto abort_unlock;
> > 
> 
> Thanks, Neil!
> 
> I can confirm the issue on 3.4.y and that your patch fixes it reliably.
> 
> Acked-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>

Running with this patch against 3.8.0rc7 with the following results:

  auto-read-only
  * mdadm --fail   - success
  * mdadm --remove - success

  read-only
  * mdadm --fail   - success
  * mdadm --remove - EROFS

Quick question for Neil -- should the sysfs MD component device state 
file interface perform the same transition from auto-read-only to 
read-write, or is that route intended for more granular changes?

Thanks,

-- Joe
