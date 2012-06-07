From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 8/8] raid5: create multiple threads to handle stripes
Date: Thu, 7 Jun 2012 14:45:51 +0800
Message-ID: <20120607064551.GD779@kernel.org>
References: <20120604080152.098975870@kernel.org>
 <20120604080354.686050081@kernel.org>
 <20120607113958.04b9d5b8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120607113958.04b9d5b8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

On Thu, Jun 07, 2012 at 11:39:58AM +1000, NeilBrown wrote:
> On Mon, 04 Jun 2012 16:02:00 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
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
> I think it is great that you have got RAID5 to the point where multiple
> threads improve performance.
> I really don't like the idea of having to configure that number of threads.
> 
> It would be great if it would auto-configure.
> Maybe the main thread could fork aux threads when it notices a high load.
> e.g. if it has been servicing requests for more than 100ms without a break,
> and the number of threads is less than the number of CPUs, then it forks a new
> helper and resets the timer.
> 
> If a thread has been idle for more than 30 minutes, it exits.
> 
> Might that be reasonable?

Yep, I bet this patch needs more discussion. auto-configure is preferred. Your
idea is worthy doing. However, the concern is if doing auto fork/kill thread,
user can't do numa binding, which is important for high speed storage. Maybe
have a reasonable default thread number, like one thread one disk? Need more
investigations, I'm open to any suggestion in this side.
