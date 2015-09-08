From: Shaohua Li <shli@fb.com>
Subject: Re: raid5-cache I/O path improvements
Date: Mon, 7 Sep 2015 17:28:55 -0700
Message-ID: <20150908002840.GA3196542@devbig257.prn2.facebook.com>
References: <1441603250-5119-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1441603250-5119-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Mon, Sep 07, 2015 at 07:20:40AM +0200, Christoph Hellwig wrote:
> Hi Shaohua, hi Neil,
> 
> this series contains a few updates to the raid5-cache feature.
> 
> The first patch just ports it to the post-4.2 block layer.  As part of that
> I noticed that it currently doesn't handle I/O errors - fixes for that will
> follow.
> 
> The second and third patch simplify the I/O unit state machine and reduce
> latency and memory usage for the I/O units.  The remainder are just a couple
> of cleanups in this area that I stumbled upon.

Hi Christoph,
Thanks for these work. Yes, I/O error handling is in the plan. We could
simplify panic (people here like this option) or report error and bypass
log. Any way an option is good.

For the patches, FUA write does simplify things a lot. However, I tried
it before, the performance is quite bad in SSD. FUA is off in SATA by
default, the emulation is farily slow because FLUSH request isn't NCQ
command. I tried to enable FUA in SATA too, FUA write is still slow in
the SSD I tested. Other than this one, other patches look good:

Reviewed-by: Shaohua Li <shli@fb.com>
