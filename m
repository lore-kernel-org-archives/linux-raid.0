From: Tejun Heo <tj@kernel.org>
Subject: Re: raid5-cache I/O path improvements
Date: Tue, 8 Sep 2015 13:34:20 -0400
Message-ID: <20150908173420.GJ13749@mtj.duckdns.org>
References: <1441603250-5119-1-git-send-email-hch@lst.de>
 <20150908002840.GA3196542@devbig257.prn2.facebook.com>
 <20150908061215.GA23833@lst.de>
 <20150908165611.GA371379@devbig257.prn2.facebook.com>
 <20150908170226.GI13749@mtj.duckdns.org>
 <20150908170736.GA423191@devbig257.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150908170736.GA423191@devbig257.prn2.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, neilb@suse.de, linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Hello,

On Tue, Sep 08, 2015 at 10:07:36AM -0700, Shaohua Li wrote:
> I need double confirm. But for write + flush, we aggregrate several
> writes and do a flush; for FUA, we do every meta write with FUA. So this
> is not apple to apple comparison.

Does that mean that upper layers are taking different actions
depending on whether the underlying device supports FUA?  That at
least wasn't the original model that I had on mind when implementing
the current incarnation of REQ_FLUSH and FUA.  The only difference FUA
was expected to make was optimizing out the flush after REQ_FUA and
the upper layers were expected to issue REQ_FLUSH/FUA the same whether
the device supports FUA or not.

Hmmm... grep tells me that dm and md actually are branching on whether
the underlying device supports FUA.  This is tricky.  I didn't even
mean flush_flags to be used directly by upper layers.  For rotational
devices, doing multiple FUAs compared multiple writes followed by
REQ_FLUSH is probably a lot worse - the head gets moved multiple times
likely skipping over data which can be written out while traversing
and it's not like stalling write pipeline and draining write queue has
much impact on hard drives.

Maybe it's different on SSDs.  I'm not sure about how expensive flush
itself would be given that a lot of write cost is paid asynchronously
anyway during gc but flush stalls IO pipeline and that could be very
noticeable on high iops devices.  Also, unless the implementation is
braindead FUA IOs are unlikely to be expensive on SSDs, so maybe what
we should do is making block layer hint upper layers regarding what's
likely to perform better.

But, ultimately, I don't think it'd be too difficult for high-depth
SSD devices to report write-through w/o losing any performance one way
or the other and it'd be great if we eventually can get there.

Thanks.

-- 
tejun
