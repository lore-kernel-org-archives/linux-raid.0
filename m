From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] raid1: prevent freeze_array/wait_all_barriers deadlock
Date: Wed, 18 Oct 2017 21:10:30 -0700
Message-ID: <20171019041030.jaonyeadhlovkgf5@kernel.org>
References: <20171017121703.7915-1-nate.dailey@stratus.com>
 <6fc9ddf3-8c65-aee1-06da-e56692826899@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6fc9ddf3-8c65-aee1-06da-e56692826899@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Nate Dailey <nate.dailey@stratus.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Oct 18, 2017 at 12:31:31AM +0800, Coly Li wrote:
> On 2017/10/17 下午8:17, Nate Dailey wrote:
> > If freeze_array is attempted in the middle of close_sync/
> > wait_all_barriers, deadlock can occur.
> > 
> > freeze_array will wait for nr_pending and nr_queued to line up.
> > wait_all_barriers increments nr_pending for each barrier bucket, one
> > at a time, but doesn't actually issue IO that could be counted in
> > nr_queued. So freeze_array is blocked until wait_all_barriers
> > completes and allow_all_barriers runs. At the same time, when
> > _wait_barrier sees array_frozen == 1, it stops and waits for
> > freeze_array to complete.
> > 
> > Prevent the deadlock by making close_sync call _wait_barrier and
> > _allow_barrier for one bucket at a time, instead of deferring the
> > _allow_barrier calls until after all _wait_barriers are complete.
> > 
> > Signed-off-by: Nate Dailey <nate.dailey@stratus.com>
> 
> Reviewed-by: Coly Li <colyli@suse.de>
> 
> Thank you for the great effort on analyzing this deadlock, and provide a
> simpler and clean fix :-)

Nice catch, thanks Nate and Coly! I'll mark this for-stable.

> 
> Coly Li
> 
> > ---
> >  drivers/md/raid1.c | 24 ++++++------------------
> >  1 file changed, 6 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index f3f3e40dc9d8..e4e8f9e565b7 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -990,14 +990,6 @@ static void wait_barrier(struct r1conf *conf, sector_t sector_nr)
> >  	_wait_barrier(conf, idx);
> >  }
> >  
> > -static void wait_all_barriers(struct r1conf *conf)
> > -{
> > -	int idx;
> > -
> > -	for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++)
> > -		_wait_barrier(conf, idx);
> > -}
> > -
> >  static void _allow_barrier(struct r1conf *conf, int idx)
> >  {
> >  	atomic_dec(&conf->nr_pending[idx]);
> > @@ -1011,14 +1003,6 @@ static void allow_barrier(struct r1conf *conf, sector_t sector_nr)
> >  	_allow_barrier(conf, idx);
> >  }
> >  
> > -static void allow_all_barriers(struct r1conf *conf)
> > -{
> > -	int idx;
> > -
> > -	for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++)
> > -		_allow_barrier(conf, idx);
> > -}
> > -
> >  /* conf->resync_lock should be held */
> >  static int get_unqueued_pending(struct r1conf *conf)
> >  {
> > @@ -1654,8 +1638,12 @@ static void print_conf(struct r1conf *conf)
> >  
> >  static void close_sync(struct r1conf *conf)
> >  {
> > -	wait_all_barriers(conf);
> > -	allow_all_barriers(conf);
> > +	int idx;
> > +
> > +	for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++) {
> > +		_wait_barrier(conf, idx);
> > +		_allow_barrier(conf, idx);
> > +	}
> >  
> >  	mempool_destroy(conf->r1buf_pool);
> >  	conf->r1buf_pool = NULL;
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
