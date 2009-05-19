From: raz ben yehuda <raziebe@gmail.com>
Subject: Re: Subject : [ md PATCHE 5/6] : 1K *n chunks.
Date: Tue, 19 May 2009 16:21:24 +0300
Message-ID: <1242739284.3293.18.camel@raz>
References: <1242688081.21201.19.camel@raz>
	 <18962.498.101162.146118@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18962.498.101162.146118@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux raid <linux-raid@vger.kernel.org>, yaronp@bitband.com
List-Id: linux-raid.ids


Neil Hello
Following this email is a set of 9 patches:
patch 1: raid0: MD_DEBUG compile fix.
patch 2: raid0: print zones after assembling
patch 3: raid0: 1K chunk size for raid0
patch 4: md : chunk size check moved. 
patch 5: raid0: check chunk size modulo 1K
patch 6: raid1: check chunk size
patch 7: raid10: check chunk size  
patch 8: raid5: check chunk size
patch 9: mdadm: check chunk size 


On Tue, 2009-05-19 at 10:48 +1000, Neil Brown wrote:
> On Tuesday May 19, raziebe@gmail.com wrote:
> > md to support 1K*n chunks only in the case of raid 0
> > Signed-off-by: raziebe@gmail.com
> > ---
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index aab183e..75a3634 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -4011,9 +4011,9 @@ static int do_md_run(mddev_t * mddev)
> >  			return -EINVAL;
> >  		}
> >  		/*
> > -		* raid0 chunk size has to divide by a page
> > +		* raid0 chunk size has to divide by a 1K
> >  		*/
> > -		if (mddev->level == 0 && (chunk_size % PAGE_SIZE)) {
> > +		if (mddev->level == 0 && (chunk_size % 1024)) {
> >  			printk(KERN_ERR "chunk_size of %d not valid\n",
> >  				chunk_size);
> >  			return -EINVAL;
> > 
> 
> Ah... 1K is the minimum now.  I cannot see why this is a separate
> patch, or why 1K is an appropriate limit.
> 
> NeilBrown

