From: Shaohua Li <shli@fb.com>
Subject: Re: raid5-cache I/O path improvements
Date: Tue, 8 Sep 2015 10:07:36 -0700
Message-ID: <20150908170736.GA423191@devbig257.prn2.facebook.com>
References: <1441603250-5119-1-git-send-email-hch@lst.de>
 <20150908002840.GA3196542@devbig257.prn2.facebook.com>
 <20150908061215.GA23833@lst.de>
 <20150908165611.GA371379@devbig257.prn2.facebook.com>
 <20150908170226.GI13749@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150908170226.GI13749@mtj.duckdns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, neilb@suse.de, linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 08, 2015 at 01:02:26PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Sep 08, 2015 at 09:56:22AM -0700, Shaohua Li wrote:
> > I'll benchmark on a SSD from another vendor, which supports FUA, but FUA
> > write has poor performance in my last test.
> 
> lolwut?  Was it slower than write + flush?

I need double confirm. But for write + flush, we aggregrate several
writes and do a flush; for FUA, we do every meta write with FUA. So this
is not apple to apple comparison.

Thanks,
Shaohua
