From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch v3 5/5] raid5: only wakeup necessary threads
Date: Wed, 28 Aug 2013 14:31:59 +0800
Message-ID: <20130828063159.GC17163@kernel.org>
References: <20130827095038.303090029@kernel.org>
 <20130827095518.881234515@kernel.org>
 <20130828141304.5e6df26e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130828141304.5e6df26e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, tj@kernel.org, dan.j.williams@gmail.com
List-Id: linux-raid.ids

On Wed, Aug 28, 2013 at 02:13:04PM +1000, NeilBrown wrote:
> On Tue, 27 Aug 2013 17:50:43 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> 
> > @@ -229,8 +233,26 @@ static void raid5_wakeup_stripe_thread(s
> >  
> >  	group = conf->worker_groups + cpu_to_group(sh->cpu);
> >  
> > -	for (i = 0; i < conf->worker_cnt_per_group; i++)
> > -		queue_work_on(sh->cpu, raid5_wq, &group->workers[i].work);
> > +	group->workers[0].working = true;
> > +	/* at least one worker should run to avoid race */
> > +	queue_work_on(sh->cpu, raid5_wq, &group->workers[0].work);
> > +
> > +	thread_cnt = group->stripes_cnt / MAX_STRIPE_BATCH - 1;
> > +	/* wakeup more workers */
> > +	for (i = 1; i < conf->worker_cnt_per_group && thread_cnt > 0; i++) {
> > +		if (group->workers[i].working == false) {
> > +			group->workers[i].working = true;
> > +			queue_work_on(sh->cpu, raid5_wq,
> > +				      &group->workers[i].work);
> > +			thread_cnt--;
> > +		} else if (group->workers[i].working_cnt <=
> > +			   MAX_STRIPE_BATCH / 2)
> > +			/*
> > +			 * If a worker has no enough stripes handling, assume
> > +			 * it will fetch more stripes soon.
> > +			 */
> > +			thread_cnt--;
> > +	}
> >  }
> 
> I don't really understand this  "working_cnt <= MAX_STRIPE_BATCH / 2"
> heuristic.  It is at best a very coarse estimate of how long until the worker
> will get some more stripes to work on.
> I think I would simply not count any thread that is already working (except
> the first, which is always counted whether it is working or not)
> Do you see some particular gain from the counting?
> 
> 
> 
> > -#define MAX_STRIPE_BATCH 8
> > -static int handle_active_stripes(struct r5conf *conf, int group)
> > +static int handle_active_stripes(struct r5conf *conf, int group,
> > +		struct r5worker *worker)
> >  {
> >  	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
> >  	int i, batch_size = 0;
> > @@ -4921,6 +4955,9 @@ static int handle_active_stripes(struct
> >  			(sh = __get_priority_stripe(conf, group)) != NULL)
> >  		batch[batch_size++] = sh;
> >  
> > +	if (worker)
> > +		worker->working_cnt = batch_size;
> > +
> >  	if (batch_size == 0)
> >  		return batch_size;
> 
> I think this could possibly return with ->working still 'true'.
> I think it is safest to clear it on every exit from the function

I need do more tests on this one. Could you please apply other patches to your
tree, then I can rebase this patch against it when I'm done.

Thanks,
Shaohua
