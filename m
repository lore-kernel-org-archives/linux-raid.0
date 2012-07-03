From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 10/10 v3] raid5: create multiple threads to handle stripes
Date: Tue, 3 Jul 2012 16:04:49 +0800
Message-ID: <20120703080449.GD23488@kernel.org>
References: <20120625072447.268095276@kernel.org>
 <20120625072726.364743203@kernel.org>
 <CAA9_cmcGuxsYVv-NASWKwvUFryqu14znXfQw_kuYr8Ld=hCgCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAA9_cmcGuxsYVv-NASWKwvUFryqu14znXfQw_kuYr8Ld=hCgCA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk, shli@fusionio.com
List-Id: linux-raid.ids

On Mon, Jul 02, 2012 at 01:03:53PM -0700, Dan Williams wrote:
> On Mon, Jun 25, 2012 at 12:24 AM, Shaohua Li <shli@kernel.org> wrote:
> > Like raid 1/10, raid5 uses one thread to handle stripe. In a fast storage, the
> > thread becomes a bottleneck. raid5 can offload calculation like checksum to
> > async threads. And if storge is fast, scheduling async work and running async
> > work will introduce heavy lock contention of workqueue, which makes such
> > optimization useless. And calculation isn't the only bottleneck. For example,
> > in my test raid5 thread must handle > 450k requests per second. Just doing
> > dispatch and completion will make raid5 thread incapable. The only chance to
> > scale is using several threads to handle stripe.
> >
> > With this patch, user can create several extra threads to handle stripe. How
> > many threads are better depending on disk number, so the thread number can be
> > changed in userspace. By default, the thread number is 0, which means no extra
> > thread.
> >
> > In a 3-disk raid5 setup, 2 extra threads can provide 130% throughput
> > improvement (double stripe_cache_size) and the throughput is pretty close to
> > theory value. With >=4 disks, the improvement is even bigger, for example, can
> > improve 200% for 4-disk setup, but the throughput is far less than theory
> > value, which is caused by several factors like request queue lock contention,
> > cache issue, latency introduced by how a stripe is handled in different disks.
> > Those factors need further investigations.
> >
> > Signed-off-by: Shaohua Li <shli@fusionio.com>
> 
> Can you share a bit more about your test setup?  Is this
> single-threaded throughput?  I'm wondering if we can take advantage of
> keeping the work cpu local.

I use a 4-thread DIO randwrite 4k test. I'm thinking about keep work cpu local
too, that requires spearate the stripe lru list. Also async ops and request
completion is better cpu local aware to make this work well.

When I try the unbound workqueue, I set the max active work to online_cpus, so
there will be 24 worker threads. But even 24 threads are too many.

Thanks,
Shaohua
