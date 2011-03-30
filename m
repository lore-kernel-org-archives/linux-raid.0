From: Christoph Hellwig <hch@lst.de>
Subject: blk_flush_plug in the MD code, was Re: [xfs-masters] linux-next:
	manual merge of the xfs tree with Linus' tree
Date: Wed, 30 Mar 2011 13:57:38 +0200
Message-ID: <20110330115738.GA16484@lst.de>
References: <20110328122148.1b48a742.sfr@canb.auug.org.au> <20110328104753.GA27327@lst.de> <20110328105348.GA27458@lst.de> <4D9069C1.4080602@fusionio.com> <20110329200813.GA9687@lst.de> <4D93177B.50505@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D93177B.50505@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Wed, Mar 30, 2011 at 01:43:55PM +0200, Jens Axboe wrote:
> On 2011-03-29 22:08, Christoph Hellwig wrote:
> > FYI, the blk_flush_plug call in ufs_truncate also seem to be almost
> > certainly incorrect as it's followed by a yield.
> > 
> > That only leaves the RAID code as remaining modular users of it, and
> > I suspect it really is something that shouldn't need to be exported.
> 
> Agree, once things have settled down we can reap the remaining and keep
> it internal.

In fact I think the blk_flush_plug calls in the raid1/raid10 code can
simply be removed without a replacement.  They are in wait_even_loops
which schedule before/after the call so we do get the implicit context
switch plugs there.  Even more they are generally called from the
make_request handler, which for MD is in the loop around
__generic_make_request and thus can't actually unplug in a sensible
way.
