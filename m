From: Shaohua Li <shli@fb.com>
Subject: Re: [RFC] using mempools for raid5-cache
Date: Wed, 2 Dec 2015 20:49:12 -0800
Message-ID: <20151203044912.GB3111265@devbig084.prn1.facebook.com>
References: <1449072638-15409-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449072638-15409-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: neilb@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 02, 2015 at 05:10:36PM +0100, Christoph Hellwig wrote:
> Currently the raid5-cache code is heavily relying on GFP_NOFAIL allocations.
> 
> I've looked into replacing these with mempools and biosets, and for the
> bio and the meta_page that's pretty trivial as they have short life times
> and do make guaranteed progress.  I'm massively struggling with the iounit
> allocation, though.  These can live on for a long time over log I/O, cache
> flushing and last but not least RAID I/O, and every attempt at something
> mempool-like results in reproducible deadlocks.  I wonder if we need to
> figure out some more efficient data structure to communicate the completion
> status that doesn't rely on these fairly long living allocations from
> the I/O path.
> 
> FYI, my last attempt to use the bio frontpad is below, but a mempool showed
> pretty similar results:

yep, the io unit and metadata are used to be allocated with a mempool,
but it's hard to calculate the pool size, so fall back to GFP_NOFAIL ...
