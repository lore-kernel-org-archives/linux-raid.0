From: Tejun Heo <tj@kernel.org>
Subject: Re: raid5-cache I/O path improvements
Date: Tue, 8 Sep 2015 11:25:46 -0400
Message-ID: <20150908152546.GB13749@mtj.duckdns.org>
References: <1441603250-5119-1-git-send-email-hch@lst.de>
 <20150908002840.GA3196542@devbig257.prn2.facebook.com>
 <20150908061215.GA23833@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150908061215.GA23833@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Shaohua Li <shli@fb.com>, neilb@suse.de, linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Hello, Christoph.

On Tue, Sep 08, 2015 at 08:12:15AM +0200, Christoph Hellwig wrote:
> Tejun, do you have any updates on libata vs FUA?  We onable it
> by default for a while in 2012, but then Jeff reverted it with a rather
> non-descriptive commit message.

IIRC, some controllers and/or controllers were choking on it and it
didn't make any noticeable difference on rotating disks.  Maybe we can
try again with controller white list and enabling by default on SSds.

Thanks.

-- 
tejun
