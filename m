From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: ext4 vs btrfs performance on SSD array
Date: Fri, 05 Sep 2014 12:40:49 -0400
Message-ID: <x497g1ivx4e.fsf@segfault.boston.devel.redhat.com>
References: <CAEp=YLgzsLbmEfGB5YKVcHP4CQ-_z1yxnZ0tpo7gjKZ2e1ma5g@mail.gmail.com>
	<20140902000822.GA20473@dastard>
	<20140902012222.GA21405@infradead.org>
	<20140903100158.34916d34@notabene.brown>
	<20140905160808.GA7967@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20140905160808.GA7967@infradead.org> (Christoph Hellwig's
	message of "Fri, 5 Sep 2014 09:08:08 -0700")
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@infradead.org>
Cc: NeilBrown <neilb@suse.de>, Dave Chinner <david@fromorbit.com>, Nikolai Grigoriev <ngrigoriev@gmail.com>, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-raid.ids

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Sep 03, 2014 at 10:01:58AM +1000, NeilBrown wrote:
>> Do we still need maximums at all?
>
> I don't think we do.  At least on any system I work with I have to
> increase them to get good performance without any adverse effect on
> throttling.
>
>> So can we just remove the limit on max_sectors and the RAID5 stripe cache
>> size?  I'm certainly keen to remove the later and just use a mempool if the
>> limit isn't needed.
>> I have seen reports that a very large raid5 stripe cache size can cause
>> a reduction in performance.  I don't know why but I suspect it is a bug that
>> should be found and fixed.
>> 
>> Do we need max_sectors ??

I'm assuming we're talking about max_sectors_kb in
/sys/block/sdX/queue/.

> I'll send a patch to remove it and watch for the fireworks..

:) I've seen SSDs that actually degrade in performance if I/O sizes
exceed their internal page size (using artificial benchmarks; I never
confirmed that with actual workloads).  Bumping the default might not be
bad, but getting rid of the tunable would be a step backwards, in my
opinion.

Are you going to bump up BIO_MAX_PAGES while you're at it?

Cheers,
Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
