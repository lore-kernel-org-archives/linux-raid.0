From: Ray Morris <support@bettercgi.com>
Subject: Re: debugging md2_resync hang at raise_barrier
Date: Mon, 12 Mar 2012 13:46:03 -0500
Message-ID: <20120312134603.703352b8@bettercgi.com>
References: <20120229184413.13db7143@bettercgi.com>
	<20120301123418.1254f763@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120301123418.1254f763@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Wed, 29 Feb 2012 18:44:13 -0600 Ray Morris <support@bettercgi.com>
> wrote:
> 
> > I am attempting to debug a hang in raid1 and possibly one raid5.


On Thu, 1 Mar 2012 12:34:18 +1100
NeilBrown <neilb@suse.de> wrote:

> I might know what is happening.
> 
> It is kind-a complicated and involved the magic code in
> block/blk-core.c:generic_make_request which turns recursive calls
> into tail recursion.
...
> This patch might fix it.  Maybe.  If it compiles.

That appears to have solved it. Thanks so much. The delay in my
response is because I wanted to give it some time to recur, as it
didn't always manifest right away. Is there anything I should do
regarding this path in future versions? Is this patch already in or
planned to be in future versions, or should users possibly keep the
patch on hand in case it's still needed later? Is there any testing
or anything that I need to do to get included in future versions?


-- 
Ray Morris
support@bettercgi.com

Strongbox - The next generation in site security:
http://www.bettercgi.com/strongbox/

Throttlebox - Intelligent Bandwidth Control
http://www.bettercgi.com/throttlebox/

Strongbox / Throttlebox affiliate program:
http://www.bettercgi.com/affiliates/user/register.php




On Thu, 1 Mar 2012 12:34:18 +1100
NeilBrown <neilb@suse.de> wrote:

> On Wed, 29 Feb 2012 18:44:13 -0600 Ray Morris <support@bettercgi.com>
> wrote:
> 
> > I am attempting to debug a hang in raid1 and possibly one raid5.
> > I have experienced the same problem with many kernel versions
> > over a couple of years, and with disparate hardware.
> > 
> > My current plan, if noone more experienced suggests I do otherwise,
> > is to compile a kernel with some printk() in strategic locations
> > and try to narrow down the problem. I know very little about kernel
> > work, so I am seeking suggestions from those who know better than I.
> > 
> > In the case logged below, it appears to hang at raise_barrier in
> > md2_resync at raise_barrier, then further access to the device
> > hangs. I'm just a Perl programmer who dabbles in C, but my
> > intuition said I check that if perhaps lower_barrier had been
> > called with conf->barrier already at zero, so that's the one printk
> > I've added so far. It may take a week or more before it crashes
> > again, so is there any more debugging I should add before waiting
> > for it to hang?
> > 
> > Also below is some older logging from similar symptoms with raid5, 
> > hanging at raid5_quiesce. I got rid of the raid5 in hopes of
> > getting rid of the problem, but if anyone has suggestions on how to
> > further debug that I maybe be able to add a raid5 array.
> > 
> > The load when I've noticed it is rsync to LVM volumes with
> > snapshots. After some discussion, lvm-devel suggested linux-raid
> > would be the next logical step. Tested kernels include
> > 2.6.32-220.4.1.el6.x86_64 2.6.32.26-175.fc12.x86_64,
> > vmlinuz-2.6.32.9-70.fc12.x86_64, and others. Since I already have
> > updated the kernel several times in the last couple of years, I
> > figured I'd try some debugging with the current EL 6 kernel.
> > 
> > Anyway, any thoughts on how to debug, where to stick some printk,
> > other debugging functions? 
> 
> I might know what is happening.
> 
> It is kind-a complicated and involved the magic code in
> block/blk-core.c:generic_make_request which turns recursive calls
> into tail recursion.
> 
> The fs sends a request to dm.
> dm split it in 2 for some reason and sends them both to md.
> This involves them getting queued in generic_make_request.
> The first gets actioned by md/raid1 and converted into a request to
> the underlying device (it must be a read request for this to happen -
> so just one device).  This gets added to the queue and is counted in
> nr_pending.
> 
> At this point sync_request is called by another thread and it tries to
> raise_battier.  It gets past the first hurdle, increments ->barrier,
> and waits for nr_pending to hit zero.
> 
> Now the second request from dm to md is passed to
> raid1.c:make_request where it tries to wait_barrier.  This blocks
> because ->barrier is up, and we have a deadlock - the request to the
> underlying device will not progress until this md request progresses,
> and it is stuck.
> 
> This patch might fix it.  Maybe.  If it compiles.
> 
> NeilBrown
> 
> Index: linux-2.6.32-SLE11-SP1/drivers/md/raid1.c
> ===================================================================
> --- linux-2.6.32-SLE11-SP1.orig/drivers/md/raid1.c	2012-03-01
> 12:28:05.000000000 +1100 +++
> linux-2.6.32-SLE11-SP1/drivers/md/raid1.c	2012-03-01
> 12:28:22.427992913 +1100 @@ -695,7 +695,11 @@ static void
> wait_barrier(conf_t *conf) spin_lock_irq(&conf->resync_lock); if
> (conf->barrier) { conf->nr_waiting++;
> -
> wait_event_lock_irq(conf->wait_barrier, !conf->barrier,
> +		wait_event_lock_irq(conf->wait_barrier,
> +				    !conf->barrier ||
> +				    (current->bio_tail &&
> +				     current->bio_list &&
> +				     conf->nr_pending),
>  				    conf->resync_lock,
>  				    raid1_unplug(conf->mddev->queue));
>  		conf->nr_waiting--;
> 

