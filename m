From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ext4 vs btrfs performance on SSD array
Date: Fri, 5 Sep 2014 09:08:08 -0700
Message-ID: <20140905160808.GA7967@infradead.org>
References: <CAEp=YLgzsLbmEfGB5YKVcHP4CQ-_z1yxnZ0tpo7gjKZ2e1ma5g@mail.gmail.com>
 <20140902000822.GA20473@dastard>
 <20140902012222.GA21405@infradead.org>
 <20140903100158.34916d34@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140903100158.34916d34@notabene.brown>
Sender: linux-fsdevel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Nikolai Grigoriev <ngrigoriev@gmail.com>, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-raid.ids

On Wed, Sep 03, 2014 at 10:01:58AM +1000, NeilBrown wrote:
> Do we still need maximums at all?

I don't think we do.  At least on any system I work with I have to
increase them to get good performance without any adverse effect on
throttling.

> So can we just remove the limit on max_sectors and the RAID5 stripe cache
> size?  I'm certainly keen to remove the later and just use a mempool if the
> limit isn't needed.
> I have seen reports that a very large raid5 stripe cache size can cause
> a reduction in performance.  I don't know why but I suspect it is a bug that
> should be found and fixed.
> 
> Do we need max_sectors ??

I'll send a patch to remove it and watch for the fireworks..
