From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 001 of 4] md: Define backing_dev_info.congested_fn for
 raid0 and linear
Date: Mon, 4 Sep 2006 15:32:28 +1000
Message-ID: <17659.47724.27700.54965@cse.unsw.edu.au>
References: <20060829153414.6475.patches@notabene>
	<1060829053924.6610@suse.de>
	<20060828225908.af114751.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Monday August 28
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 28, akpm@osdl.org wrote:
> On Tue, 29 Aug 2006 15:39:24 +1000
> NeilBrown <neilb@suse.de> wrote:
> 
> > 
> > Each backing_dev needs to be able to report whether it is congested,
> > either by modulating BDI_*_congested in ->state, or by
> > defining a ->congested_fn.
> > md/raid did neither of these.  This patch add a congested_fn
> > which simply checks all component devices to see if they are
> > congested.
> > 
> > Signed-off-by: Neil Brown <neilb@suse.de>
> > 
> > +static int linear_congested(void *data, int bits)
> > +{
> > +	mddev_t *mddev = data;
> > +	linear_conf_t *conf = mddev_to_conf(mddev);
> > +	int i, ret = 0;
> > +
> > +	for (i = 0; i < mddev->raid_disks && !ret ; i++) {
> > +		request_queue_t *q = bdev_get_queue(conf->disks[i].rdev->bdev);
> > +		ret |= bdi_congested(&q->backing_dev_info, bits);
> 
> nit: `ret = ' would suffice here.
> 

Yeh.... I was looking at  linear_issue_flush, which aborts when
ret == 0, and dm_table_any_congested, which 'or's together the results
and combining to two.  And I kept changing my mind as to which way I
wanted to go for linear_congested et.al, and ended up going both ways
:-(
I hate indecision.  I think.  Well, probably I do.  Maybe.

NeilBrown

-- 
VGER BF report: U 0.5
