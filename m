From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: [PATCH 2/2] md/raid5: trivial coding style fix
Date: Thu, 30 Apr 2015 15:23:15 +0800
Message-ID: <20150430072315.GB3858@yliu-dev.sh.intel.com>
References: <1430377277-6167-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1430377277-6167-2-git-send-email-yuanhan.liu@linux.intel.com>
 <20150430171650.4db1bcca@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150430171650.4db1bcca@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 30, 2015 at 05:16:50PM +1000, NeilBrown wrote:
> On Thu, 30 Apr 2015 15:01:17 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
> wrote:
> 
> > Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > ---
> >  drivers/md/raid5.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 2651bda..bae3e2c 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -5789,8 +5789,7 @@ static void raid5d(struct md_thread *thread)
> >  		if (released)
> >  			clear_bit(R5_DID_ALLOC, &conf->cache_state);
> >  
> > -		if (
> > -		    !list_empty(&conf->bitmap_list)) {
> > +		if (!list_empty(&conf->bitmap_list)) {
> >  			/* Now is a good time to flush some bitmap updates */
> >  			conf->seq_flush++;
> >  			spin_unlock_irq(&conf->device_lock);
> 
> 
> I'm happy for these sorts of changes when you are fixing up nearby code, or
> if the change significantly improves readability.
> But I'd rather not bother is one-off trivial fixes like this.

Got it.

	--yliu
