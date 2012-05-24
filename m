From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 2/4] raid1: percpu dispatch for write request if bitmap
 supported
Date: Thu, 24 May 2012 13:50:15 +0800
Message-ID: <20120524055015.GA5579@kernel.org>
References: <20120523072619.670179001@kernel.org>
 <20120523072838.580242059@kernel.org>
 <20120524133402.0f217e71@notabene.brown>
 <20120524051709.GA1191@kernel.org>
 <20120524153412.106d5a0c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120524153412.106d5a0c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, shli@fusionio.com
List-Id: linux-raid.ids

On Thu, May 24, 2012 at 03:34:12PM +1000, NeilBrown wrote:
> On Thu, 24 May 2012 13:17:09 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > On Thu, May 24, 2012 at 01:34:02PM +1000, NeilBrown wrote:
> > > On Wed, 23 May 2012 15:26:21 +0800 Shaohua Li <shli@kernel.org> wrote:
> > > 
> > > > In raid1, all write requests are dispatched in raid1d thread. In fast storage,
> > > > the raid1d thread is a bottleneck, because it dispatches request too slow. Also
> > > > raid1d thread migrates freely, which makes request completion cpu not match
> > > > with submission cpu even driver/block layer has such capability. This will
> > > > cause bad cache issue.
> > > > 
> > > > If bitmap support is enabled, write requests can only be dispatched after dirty
> > > > bitmap is flushed out. After bitmap is flushed, how write requests are
> > > > dispatched doesn't impact correctness. A natural idea is to distribute request
> > > > dispatch to several threads. With this patch, requests are added to a percpu
> > > > list first. After bitmap is flushed, then the percpu list requests will
> > > > dispatched in a workqueue. In this way, above bottleneck is removed.
> > > > 
> > > > In a 4k randwrite test with a 2 disks setup, below patch can provide 10% ~ 50%
> > > > performance improvements depending on numa binding.
> > > 
> > > Those numbers are quite impressive so there is certainly room for improvement
> > > here.  I'm not sure that I'm entirely comfortable with the approach though.
> > > 
> > > Passing the request to a per-cpu thread does make sense, but a generic
> > > per-cpu thread feels dangerous as we don't know what else might be queued to
> > > that thread and because of the potential for deadlocks between memory
> > > allocation and generic_make_request (as mentioned in previous email) I find
> > > it hard to convince myself that this approach is entirely safe.
> > 
> > No problem, we can use a separate workqueue.
> 
> A separate set of per-cpu workqueues for each md array doesn't sound like a
> good idea to me - if we can possibly avoid it.

Can be a separate workqueue sharing for all md arrays.
  
> > > I wonder if we might take a very different approach and try to do everything
> > > in the one process.  i.e. don't hand tasks off to other threads at all - at
> > > least in the common case. 
> > > So we could change plugger_unplug (in md.c) so that:
> > > 
> > >  - if current->bio_list is NULL, (meaning all requests have been submitted
> > >    and there is no risk of deadlock) we call bitmap_unplug and then submit
> > >    all the queued writes.
> > >  - if current->bio_list is not NULL, then we just wakeup the md thread to
> > >    do the work.
> > 
> > The current->bio_list check does make sense. I'm going to do the check for the
> > 1 and 3 patches.
> > 
> > But I believe we can't call generic_make_request in unplug. For example,
> > schedule()->unplug->generic_make_request->get_request_wait()->schedule(). At
> 
> My ideas was to only submit the queued writes from a normal call to
> blk_finish_plug.  Calls that come from schedule would use the current
> approach of signalling the md thread to take over.  There must be a way to
> tell the difference - maybe just a new flag to the unplug callback.

Should be the same I think. For exmaple, blk_finish_plug unplug, plug_cb should
generate several bios, but for the first bio, get_request_wait sleeps and flush
plug list again. later bio hasn't a chance to be queued actually till next time
the task runs. Then unplug loses its meaning.

Thanks,
Shaohua
