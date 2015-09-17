From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/12] raid5-cache: free I/O units earlier
Date: Thu, 17 Sep 2015 03:48:06 +0200
Message-ID: <20150917014806.GA22809@lst.de>
References: <1442038638-6947-1-git-send-email-hch@lst.de> <1442038638-6947-3-git-send-email-hch@lst.de> <87zj0o5cnj.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87zj0o5cnj.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Tue, Sep 15, 2015 at 10:07:12AM +0200, Neil Brown wrote:
> Christoph Hellwig <hch@lst.de> writes:
> 
> > +	sector_t reclaimable;
> 
> sector_t is unsigned (u64 or "unsigned long"), so
> 
> > +	BUG_ON(reclaimable < 0);
> 
> This could only be a compiler bug.

Indeed, I'll fix this up.
