From: Xiao Ni <xni@redhat.com>
Subject: Re: [MD PATCH 1/1] Use a new variable to count flighting sync
 requests
Date: Wed, 26 Apr 2017 10:01:26 -0400 (EDT)
Message-ID: <653687133.1320840.1493215286357.JavaMail.zimbra@redhat.com>
References: <1493213539-15970-1-git-send-email-xni@redhat.com> <38fd88c3-4ecd-2778-e6a0-187861faa183@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <38fd88c3-4ecd-2778-e6a0-187861faa183@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-raid@vger.kernel.org, shli@kernel.org, neilb@suse.com, ncroxon@redhat.com
List-Id: linux-raid.ids



----- Original Message -----
> From: "Coly Li" <colyli@suse.de>
> To: "Xiao Ni" <xni@redhat.com>, linux-raid@vger.kernel.org
> Cc: shli@kernel.org, neilb@suse.com, ncroxon@redhat.com
> Sent: Wednesday, April 26, 2017 9:55:30 PM
> Subject: Re: [MD PATCH 1/1] Use a new variable to count flighting sync requests
> 
> On 2017/4/26 下午9:32, Xiao Ni wrote:
> > In new barrier codes, raise_barrier waits if conf->nr_pending[idx] is not
> > zero.
> > After all the conditions are true, the resync request can go on be handled.
> > But
> > it adds conf->nr_pending[idx] again. The next resync request hit the same
> > bucket
> > idx need to wait the resync request which is submitted before. The
> > performance
> > of resync/recovery is degraded.
> > So we should use a new variable to count sync requests which are in flight.
> > 
> > Suggested-by: Shaohua Li <shli@kernel.org>
> > Suggested-by: Coly Li <colyli@suse.de>
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> 
> Hi Xiao,
> 
> The patch looks good to me. But I do have interest to have a look on the
> performance number, does this patch help to improve resync throughput ?
> Thanks.
> 
> Coly Li

Hi Coly

The server which I did test is down now. I'll give the test result ASAP.

Regards
Xiao
> 
> > ---
> >  drivers/md/raid1.c | 14 +++++++++++---
> >  drivers/md/raid1.h |  1 +
> >  2 files changed, 12 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index a34f587..3c304ef 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -869,7 +869,7 @@ static void raise_barrier(struct r1conf *conf, sector_t
> > sector_nr)
> >  			     atomic_read(&conf->barrier[idx]) < RESYNC_DEPTH,
> >  			    conf->resync_lock);
> >  
> > -	atomic_inc(&conf->nr_pending[idx]);
> > +	atomic_inc(&conf->nr_sync_pending[idx]);
> >  	spin_unlock_irq(&conf->resync_lock);
> >  }
> >  
> > @@ -880,7 +880,7 @@ static void lower_barrier(struct r1conf *conf, sector_t
> > sector_nr)
> >  	BUG_ON(atomic_read(&conf->barrier[idx]) <= 0);
> >  
> >  	atomic_dec(&conf->barrier[idx]);
> > -	atomic_dec(&conf->nr_pending[idx]);
> > +	atomic_dec(&conf->nr_sync_pending[idx]);
> >  	wake_up(&conf->wait_barrier);
> >  }
> >  
> > @@ -1018,7 +1018,8 @@ static int get_unqueued_pending(struct r1conf *conf)
> >  	int idx, ret;
> >  
> >  	for (ret = 0, idx = 0; idx < BARRIER_BUCKETS_NR; idx++)
> > -		ret += atomic_read(&conf->nr_pending[idx]) -
> > +		ret += atomic_read(&conf->nr_pending[idx]) +
> > +			atomic_read(&conf->nr_sync_pending[idx]) -
> >  			atomic_read(&conf->nr_queued[idx]);
> >  
> >  	return ret;
> > @@ -3024,6 +3025,11 @@ static struct r1conf *setup_conf(struct mddev
> > *mddev)
> >  	if (!conf->nr_pending)
> >  		goto abort;
> >  
> > +	conf->nr_sync_pending = kcalloc(BARRIER_BUCKETS_NR,
> > +				   sizeof(atomic_t), GFP_KERNEL);
> > +	if (!conf->nr_sync_pending)
> > +		goto abort;
> > +
> >  	conf->nr_waiting = kcalloc(BARRIER_BUCKETS_NR,
> >  				   sizeof(atomic_t), GFP_KERNEL);
> >  	if (!conf->nr_waiting)
> > @@ -3136,6 +3142,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
> >  		kfree(conf->mirrors);
> >  		safe_put_page(conf->tmppage);
> >  		kfree(conf->poolinfo);
> > +		kfree(conf->nr_sync_pending);
> >  		kfree(conf->nr_pending);
> >  		kfree(conf->nr_waiting);
> >  		kfree(conf->nr_queued);
> > @@ -3241,6 +3248,7 @@ static void raid1_free(struct mddev *mddev, void
> > *priv)
> >  	kfree(conf->mirrors);
> >  	safe_put_page(conf->tmppage);
> >  	kfree(conf->poolinfo);
> > +	kfree(conf->nr_sync_pending);
> >  	kfree(conf->nr_pending);
> >  	kfree(conf->nr_waiting);
> >  	kfree(conf->nr_queued);
> > diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
> > index dd22a37..a3580ee 100644
> > --- a/drivers/md/raid1.h
> > +++ b/drivers/md/raid1.h
> > @@ -85,6 +85,7 @@ struct r1conf {
> >  	wait_queue_head_t	wait_barrier;
> >  	spinlock_t		resync_lock;
> >  	atomic_t		*nr_pending;
> > +	atomic_t		*nr_sync_pending;
> >  	atomic_t		*nr_waiting;
> >  	atomic_t		*nr_queued;
> >  	atomic_t		*barrier;
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
