From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: experiences with raid5: stripe_queue patches
Date: Tue, 16 Oct 2007 10:31:08 -0700
Message-ID: <1192555868.16656.30.camel@dwillia2-linux.ch.intel.com>
References: <200710151703.10404.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200710151703.10404.bs@q-leap.de>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Mon, 2007-10-15 at 08:03 -0700, Bernd Schubert wrote:
> Hi,
> 
> in order to tune raid performance I did some benchmarks with and
> without the
> stripe queue patches. 2.6.22 is only for comparison to rule out other
> effects, e.g. the new scheduler, etc.

Thanks for testing!

> It seems there is a regression with these patch regarding the re-write
> performance, as you can see its almost 50% of what it should be.
> 
> write      re-write   read       re-read
> 480844.26  448723.48  707927.55  706075.02 (2.6.22 w/o SQ patches)
> 487069.47  232574.30  709038.28  707595.09 (2.6.23 with SQ patches)
> 469865.75  438649.88  711211.92  703229.00 (2.6.23 without SQ patches)

A quick way to verify that it is a fairness issue is to simply not
promote full stripe writes to their own list, debug patch follows:

---

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index eb7fd10..755aafb 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -162,7 +162,7 @@ static void __release_queue(raid5_conf_t *conf, struct stripe_queue *sq)
 
 		if (to_write &&
 		    io_weight(sq->overwrite, disks) == data_disks) {
-			list_add_tail(&sq->list_node, &conf->io_hi_q_list);
+			list_add_tail(&sq->list_node, &conf->io_lo_q_list);
 			queue_work(conf->workqueue, &conf->stripe_queue_work);
 		} else if (io_weight(sq->to_read, disks)) {
 			list_add_tail(&sq->list_node, &conf->io_lo_q_list);


---


<snip>

> 
> An interesting effect to notice: Without these patches the pdflush
> daemons
> will take a lot of CPU time, with these patches, pdflush almost
> doesn't
> appear in the 'top' list.
> 
> Actually we would prefer one single raid5 array, but then one single
> raid5
> thread will run with 100% CPU time leaving 7 CPUs idle state, the
> status of
> the hardware raid says its utilization is only at about 50% and we
> only see
> writes at about 200 MB/s.
> On the contrary, with 3 different software raid5 sets the i/o to the
> harware
> raid systems is the bottleneck.
> 
> Is there any chance to parallize the raid5 code? I think almost
> everything is
> done in raid5.c make_request(), but the main loop there is spin_locked
> by
> prepare_to_wait(). Would it be possible not to lock this entire loop?

I made a rough attempt at multi-threading raid5[1] a while back.
However, this configuration only helps affinity, it does not address the
cases where the load needs to be further rebalanced between cpus.
> 
> 
> Thanks,
> Bernd
> 

[1] http://marc.info/?l=linux-raid&m=117262977831208&w=2
Note this implementation incorrectly handles the raid6 spare_page, we
would need a spare_page per cpu.
