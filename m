From: Shaohua Li <shli@fb.com>
Subject: Re: raid5-cache I/O path improvements
Date: Tue, 8 Sep 2015 09:56:22 -0700
Message-ID: <20150908165611.GA371379@devbig257.prn2.facebook.com>
References: <1441603250-5119-1-git-send-email-hch@lst.de>
 <20150908002840.GA3196542@devbig257.prn2.facebook.com>
 <20150908061215.GA23833@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150908061215.GA23833@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com, Tejun Heo <tj@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 08, 2015 at 08:12:15AM +0200, Christoph Hellwig wrote:
> On Mon, Sep 07, 2015 at 05:28:55PM -0700, Shaohua Li wrote:
> > Hi Christoph,
> > Thanks for these work. Yes, I/O error handling is in the plan. We could
> > simplify panic (people here like this option) or report error and bypass
> > log. Any way an option is good.
> 
> I think the sensible thing in general is to fail the I/O.  Once we have
> a cache devie the assumption is that a) write holes are properly handled,
> and we b) do all kinds of optimizations based on the presensce of the
> log device like not passing through flush requests or skippign resync.
> 
> Having the cache device suddenly disappear will alwasy break a) and
> require a lot of hairy code only used in failure cases to undo the
> rest.

Failing the I/O is ok too.
 
> > For the patches, FUA write does simplify things a lot. However, I tried
> > it before, the performance is quite bad in SSD. FUA is off in SATA by
> > default, the emulation is farily slow because FLUSH request isn't NCQ
> > command. I tried to enable FUA in SATA too, FUA write is still slow in
> > the SSD I tested. Other than this one, other patches look good:
> 
> Pretty much every SSD (and modern disk driver) supports FUA.  Please
> benchmark with libata.fua=Y, as I think the simplifcation is absolutely
> worth it.  On my SSDs using it gives far lower latency for writes,
> nevermind nvmdimm where it's also essential as the flush statemchine
> increases the write latency by an order of magnitude.
> 
> Tejun, do you have any updates on libata vs FUA?  We onable it
> by default for a while in 2012, but then Jeff reverted it with a rather
> non-descriptive commit message.
> 
> Also NVMe or SAS SSDs will benefit heavily from the FUA bit.

I agree the benefit of FUA. In the system I'm testing, an Intel ssd
supports FUA, a sandisk SSD doesn't support FUA (this is the SSD we will
deploy for the log). This is AHCI with libata.fua=1. FUA isn't supported
by every SSD. If the log uses FUA by default, we will have a lot of FUA
write and performance is impacted.

I'll benchmark on a SSD from another vendor, which supports FUA, but FUA
write has poor performance in my last test.

Thanks,
Shaohua
