From: Christoph Hellwig <hch@lst.de>
Subject: Re: raid5-cache I/O path improvements
Date: Wed, 9 Sep 2015 17:59:41 +0200
Message-ID: <20150909155941.GA28608@lst.de>
References: <1441603250-5119-1-git-send-email-hch@lst.de> <20150908002840.GA3196542@devbig257.prn2.facebook.com> <20150908061215.GA23833@lst.de> <20150908165611.GA371379@devbig257.prn2.facebook.com> <20150908170226.GI13749@mtj.duckdns.org> <20150908170736.GA423191@devbig257.prn2.facebook.com> <20150908173420.GJ13749@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150908173420.GJ13749@mtj.duckdns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Shaohua Li <shli@fb.com>, Christoph Hellwig <hch@lst.de>, neilb@suse.de, linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 08, 2015 at 01:34:20PM -0400, Tejun Heo wrote:
> Hmmm... grep tells me that dm and md actually are branching on whether
> the underlying device supports FUA.  This is tricky.  I didn't even
> mean flush_flags to be used directly by upper layers.  For rotational
> devices, doing multiple FUAs compared multiple writes followed by
> REQ_FLUSH is probably a lot worse - the head gets moved multiple times
> likely skipping over data which can be written out while traversing
> and it's not like stalling write pipeline and draining write queue has
> much impact on hard drives.

Well, that's what we'd need to do for the raid cache as well, given
the resulst that Shaohua sees.  Unless you have a good idea for another
way to handle the issue we'll need to support both behaviors there.
