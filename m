From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH 3/3] raid5: allow r5l_io_unit allocations to fail
Date: Fri, 18 Dec 2015 15:07:11 -0800
Message-ID: <20151218230657.GA342953@devbig084.prn1.facebook.com>
References: <1450390197-19479-1-git-send-email-hch@lst.de>
 <1450390197-19479-4-git-send-email-hch@lst.de>
 <20151217234748.GA1860175@devbig084.prn1.facebook.com>
 <874mfg8qyc.fsf@notabene.neil.brown.name>
 <20151218015847.GA2146501@devbig084.prn1.facebook.com>
 <20151218112535.GB28224@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151218112535.GB28224@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 18, 2015 at 12:25:35PM +0100, Christoph Hellwig wrote:
> [can you trim your replies please?  I had to trim almost 150 lines of
>  junk before getting to your reply!]
> 
> > >  	spin_unlock_irqrestore(&log->io_list_lock, flags);
> > > 
> > > or is that too simplistic?
> > 
> > maybe add a new list and run the list at the begining of r5l_do_reclaim().
> 
> What's the advantage of another list?

I mean simply waking up reclaim thread doesn't work as r5l_do_reclaim()
will return if reclaimable == 0. There is no guarantee reclaimable space
is available in the allocation failure. So we'd better move the retry at
the begining of r5l_do_reclaim(). If yes, we can't reuse the
no_space_stripes list.

Thanks,
Shaohua
