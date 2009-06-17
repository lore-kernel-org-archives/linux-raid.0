From: raz ben yehuda <raziebe@gmail.com>
Subject: Re: Subject:[PATCH 001:013]: md: Raid0 reshape
Date: Wed, 17 Jun 2009 13:25:07 +0300
Message-ID: <1245234307.3333.7.camel@raz>
References: <1245189112.3478.94.camel@raz>  <4A382993.1070702@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A382993.1070702@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids


On Tue, 2009-06-16 at 19:24 -0400, Bill Davidsen wrote:
> raz ben yehuda wrote:
> > md assumes that personality has all its membes of the same
> > size,A fact that is incorrect for raid0.
> >
> >  md.c |   11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > Signed-off-by: razb <raziebe@gmail.com>
> > ---
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 0f11fd1..e14fb90 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -5683,7 +5683,8 @@ static void status_resync(struct seq_file *seq, mddev_t * mddev)
> >  		max_sectors = mddev->resync_max_sectors;
> >  	else
> >  		max_sectors = mddev->dev_sectors;
> > -
> > +	if (mddev->level == 0)
> > +		max_sectors = mddev->resync_max_sectors;
> >  	/*
> >  	 * Should not happen.
> >  	 */
> > @@ -6280,7 +6281,13 @@ void md_do_sync(mddev_t *mddev)
> >  			    rdev->recovery_offset < j)
> >  				j = rdev->recovery_offset;
> >  	}
> > -
> > +	/*
> > +	* raid0 members may not be of the same size,use array_size.
> > +	*/
> > +	if (mddev->level == 0) {
> > +		max_sectors = mddev->array_sectors;
> > +		j = mddev->recovery_cp;
> > +	}
> >  	printk(KERN_INFO "md: %s of RAID array %s\n", desc, mdname(mddev));
> >  	printk(KERN_INFO "md: minimum _guaranteed_  speed:"
> >  		" %d KB/sec/disk.\n", speed_min(mddev));
> >   
> 
> If I admit I only spent about 20 minutes looking at this code will you 
> explain why you use different fields of the struct to set max_sectors? I 

md_sync uses max_sectors as an ending point of the reshape process.
problem is that md assumes all raid's members are of the same size, so
it uses dev_sectors and this is not true to raid0 with multiple zones
> guess my real confusion is why resync_max_sectors would be valid, given 
> that raid0 has no redundancy. Or are you using it in some obscure way 
> for reshape values?  The values stored in the field don't really to be 
> what you want... Yes, the reshape is new to me.
It has nothing to do with redundancy, but with the state machine of md.
I agree that there should be more elegant way to fix this, but it means
bigger fixes in md, and this is something I definitely don't want
to do.



