From: raz ben yehuda <raziebe@gmail.com>
Subject: Re: Subject: [PATCH 002/009]: have raid0 report its formation
Date: Wed, 20 May 2009 16:50:49 +0300
Message-ID: <1242827449.3322.83.camel@raz>
References: <1242749181.3293.59.camel@raz>
	 <18963.23693.620765.31533@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18963.23693.620765.31533@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux raid <linux-raid@vger.kernel.org>, ofer <ofer@bitband.com>, yaron <yaronp@bitband.com>
List-Id: linux-raid.ids


On Wed, 2009-05-20 at 11:27 +1000, Neil Brown wrote:
> On Tuesday May 19, raziebe@gmail.com wrote:
> > Report to the user what are the raid zones
> 
> You didn't reply to my question of:
>  - why did you want this?
>  - can it be combined with other information printed by
>    make_strip_zones?
>  - if not, can it be combined with the MD_DEBUG part of
>    raid0_status??
> 
> I've applied it for now, but I need answers before I can promise to
> keep it.
I will use raid0_status. Please drop it and I will post a new patch in
the reshape patch set ( in a different patch obviously ). I think
create_strip_zones printouts are NOT clear to the naive user while
raid0_status output is;
Also, I would like to note that i have tested these patches several
times.The MD_DEBUG failure was due to bad git commit id i accidentally
used.sorry about that.

> NeilBrown
> 
> 
> > 
> >  raid0.c |   33 +++++++++++++++++++++++++++++++++
> >  1 file changed, 33 insertions(+)
> > 
> > Signed-off-by: raziebe@gmail.com
> > ---
> > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> > index 8049a92..0a6d0fa 100644
> > --- a/drivers/md/raid0.c
> > +++ b/drivers/md/raid0.c
> > @@ -52,6 +52,38 @@ static int raid0_congested(void *data, int bits)
> >  	return ret;
> >  }
> >  
> > +/*
> > + * inform the user of the raid configuration
> > +*/
> > +static void dump_zones(mddev_t *mddev)
> > +{
> > +	int j, k, h;
> > +	sector_t zone_size = 0;
> > +	sector_t zone_start = 0;
> > +	char b[BDEVNAME_SIZE];
> > +	raid0_conf_t *conf = mddev->private;
> > +	printk(KERN_INFO "******* %s configuration *********",
> > +		mdname(mddev));
> > +	h = 0;
> > +	for (j = 0; j < conf->nr_strip_zones; j++) {
> > +		printk("\nzone%d", j);
> > +		printk("=[");
> > +		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
> > +			printk("%s/",
> > +			bdevname(conf->devlist[j*mddev->raid_disks
> > +						+ k]->bdev, b));
> > +
> > +		zone_size  = conf->strip_zone[j].zone_end - zone_start;
> > +		printk("]\n\t zone offset=%llukb "
> > +				"device offset=%llukb size=%llukb\n",
> > +			(unsigned long long)zone_start>>1,
> > +			(unsigned long long)conf->strip_zone[j].dev_start>>1,
> > +			(unsigned long long)zone_size>>1);
> > +		zone_start = conf->strip_zone[j].zone_end;
> > +	}
> > +	printk(KERN_INFO "**********************************\n\n");
> > +}
> > +
> >  static int create_strip_zones(mddev_t *mddev)
> >  {
> >  	int i, c, j, err;
> > @@ -291,6 +323,7 @@ static int raid0_run(mddev_t *mddev)
> >  	}
> >  
> >  	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
> > +	dump_zones(mddev);
> >  	return 0;
> >  }
> >  
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

