From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 2/2 v3]raid5: create multiple threads to handle stripes
Date: Mon, 13 Aug 2012 14:22:55 +0800
Message-ID: <20120813062255.GB20261@kernel.org>
References: <20120809085808.GB30111@kernel.org>
 <20120813142947.4b161df6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120813142947.4b161df6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dan.j.williams@gmail.com
List-Id: linux-raid.ids

On Mon, Aug 13, 2012 at 02:29:47PM +1000, NeilBrown wrote:
> On Thu, 9 Aug 2012 16:58:08 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > This is a new tempt to make raid5 handle stripes in multiple threads, as
> > suggested by Neil to have maxium flexibility and better numa binding. It
> > basically is a combination of my first and second generation patches. By
> > default, no multiple thread is enabled (all stripes are handled by raid5d).
> > 
> > An example to enable multiple threads:
> > #echo 3 > /sys/block/md0/md/auxthread_number
> > This will create 3 auxiliary threads to handle stripes. The threads can run
> > on any cpus and handle stripes produced by any cpus.
> > 
> > #echo 1-3 > /sys/block/md0/md/auxth0/cpulist
> > This will bind auxiliary thread 0 to cpu 1-3, and this thread will only handle
> > stripes produced by cpu 1-3. User tool can further change the thread's
> > affinity, but the thread can only handle stripes produced by cpu 1-3 till the
> > sysfs entry is changed again.
> > 
> > If stripes produced by a CPU aren't handled by any auxiliary thread, such
> > stripes will be handled by raid5d. Otherwise, raid5d doesn't handle any
> > stripes.
> > 
> > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > ---
> >  drivers/md/md.c    |    8 -
> >  drivers/md/md.h    |    8 +
> >  drivers/md/raid5.c |  406 ++++++++++++++++++++++++++++++++++++++++++++++++++---
> >  drivers/md/raid5.h |   19 ++
> >  4 files changed, 418 insertions(+), 23 deletions(-)
> > 
> > Index: linux/drivers/md/raid5.c
> > ===================================================================
> > --- linux.orig/drivers/md/raid5.c	2012-08-09 10:43:04.800022626 +0800
> > +++ linux/drivers/md/raid5.c	2012-08-09 16:44:39.663278511 +0800
> > @@ -196,6 +196,21 @@ static int stripe_operations_active(stru
> >  	       test_bit(STRIPE_COMPUTE_RUN, &sh->state);
> >  }
> >  
> > +static void raid5_wakeup_stripe_thread(struct stripe_head *sh)
> > +{
> > +	struct r5conf *conf = sh->raid_conf;
> > +	struct raid5_percpu *percpu;
> > +	int i, orphaned = 1;
> > +
> > +	percpu = per_cpu_ptr(conf->percpu, sh->cpu);
> > +	for_each_cpu(i, &percpu->handle_threads) {
> > +		md_wakeup_thread(conf->aux_threads[i]->thread);
> > +		orphaned = 0;
> > +	}
> > +	if (orphaned)
> > +		md_wakeup_thread(conf->mddev->thread);
> > +}
> > +
> >  static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh)
> >  {
> >  	BUG_ON(!list_empty(&sh->lru));
> > @@ -208,9 +223,19 @@ static void do_release_stripe(struct r5c
> >  			   sh->bm_seq - conf->seq_write > 0)
> >  			list_add_tail(&sh->lru, &conf->bitmap_list);
> >  		else {
> > +			int cpu = sh->cpu;
> > +			struct raid5_percpu *percpu;
> > +			if (!cpu_online(cpu)) {
> > +				cpu = cpumask_any(cpu_online_mask);
> > +				sh->cpu = cpu;
> > +			}
> > +			percpu = per_cpu_ptr(conf->percpu, cpu);
> > +
> >  			clear_bit(STRIPE_DELAYED, &sh->state);
> >  			clear_bit(STRIPE_BIT_DELAY, &sh->state);
> > -			list_add_tail(&sh->lru, &conf->handle_list);
> > +			list_add_tail(&sh->lru, &percpu->handle_list);
> > +			raid5_wakeup_stripe_thread(sh);
> > +			return;
> 
> I confess that I don't know a lot about cpu hotplug, but this looks like it
> should have some locking.  In particular,  "get_online_cpus()" before we
> check "cpu_online()", and "put_online_cpus()" after we have added to the
> per_cpu->handle_list().
> 
> Maybe that isn't needed, but if it isn't  I'd like to understand why.

We already hold conf->device_lock. The same in the sectond place you mentioned.
What I learned is CPU hot remove can't happen between spinlock hold or
preemption disabled, which is how stop_machine() is designed.

Thanks,
Shaohua
