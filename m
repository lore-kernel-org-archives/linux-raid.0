From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 4/4] md/bitmap: Don't write bitmap while earlier
 writes might be in-flight
Date: Mon, 7 Nov 2016 11:19:47 -0800
Message-ID: <20161107191947.mzdkby6kbqpqssbv@kernel.org>
References: <147823807607.6764.8460942745584467311.stgit@noble>
 <147823836359.6764.7855525110697020696.stgit@noble>
 <20161105003325.qnmcu363ocbli74x@kernel.org>
 <87r36onrt5.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87r36onrt5.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 07, 2016 at 09:53:42AM +1100, Neil Brown wrote:
> On Sat, Nov 05 2016, Shaohua Li wrote:
> 
> > On Fri, Nov 04, 2016 at 04:46:03PM +1100, Neil Brown wrote:
> >> As we don't wait for writes to complete in bitmap_daemon_work, they
> >> could still be in-flight when bitmap_unplug writes again.  Or when
> >> bitmap_daemon_work tries to write again.
> >> This can be confusing and could risk the wrong data being written last.
> >
> > Applied the first 3 patches, thanks!
> >
> > This one seems not completely solving the race condition. It's still possible
> > bitmap_daemon_work clears BITMAP_PAGE_NEEDWRITE but hasn't dispatch the IO yet,
> > bitmap_unplug then does nothing and thinks bitmap is updated to disk. Why don't
> > we add locking here?
> 
> Thanks for the review!
> 
> BITMAP_PAGE_NEEDWRITE is set for pages that need to be written out in
> order to clear bits that don't need to be set any more.  There is never
> any urgency to do this.
> BITMAP_PAGE_DIRTY is set of pages that need to be written out in order
> to set bits representing regions that are about to be written to.  These
> have to be flushed by bitmap_unplug().
> Pages can have both bits set, in which case bitmap_daemon_work() will
> leave them for bitmap_unplug() to deal with.
> 
> So if bitmap_daemon_work() clears BITMAP_PAGE_PENDING on a page, then it
> is a page that bitmap_unplug() doesn't need to wait for.

Oops, I misread the code. Yes, this is very clear, thanks for the explaination.

So I can understand the patch fixes the confusion. when is there risk wrong
data is written?

Thanks,
Shaohua
