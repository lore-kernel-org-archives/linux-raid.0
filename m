From: Shaohua Li <shli@fb.com>
Subject: Re: fix use after free in raid5-cache
Date: Wed, 2 Sep 2015 09:55:24 -0700
Message-ID: <20150902165522.GA2792971@devbig257.prn2.facebook.com>
References: <1441203288-22515-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1441203288-22515-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: neilb@suse.de, dan.j.williams@intel.com, linux-raid@vger.kernel.org, Kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

On Wed, Sep 02, 2015 at 04:14:45PM +0200, Christoph Hellwig wrote:
> Hi Shaohua, hi Neil,
> 
> this series fixes a use after free of the r5l_io_unit structure I ran into
> while testing the caching code.  The real fix is in patch 3, but other two
> patches contain refactoring to enable the fix.

Hi Christoph,
Thanks for looking at it. I had some patches hold on my side, which fix
the use after free issue too. I changed the io_unit list handling a
little bit. Specifically making r5l_flush_stripe_to_raid run flush in
asynchronous way and also fix io_unit free issue.

For this patch set, the 1st is a good cleanup. I think the 2 & 3 have
the same issue changing the list order. For example, io_unit A is
dispatched to log earlier than io_unit B, but io_unit B can finish
earlier than io_unit A. If we move io_unit B to io_end_ios first, and
there is a crash, the metadata of io_unit A could be corrupt, recovery
can't find io_unit B. Please see the comments at
r5l_flush_stripe_to_raid().

I can rebase the 1st against my patches, what do you think?

Thanks,
Shaohua
