From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH] MD: make bio mergeable
Date: Thu, 28 Apr 2016 14:19:10 -0700
Message-ID: <20160428211908.GA3116523@devbig084.prn1.facebook.com>
References: <384a0e0c7d6f2700aadbcbdef003cece88fa7dd7.1461626533.git.shli@fb.com>
 <alpine.LRH.2.20.1604281933200.31165@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.20.1604281933200.31165@diagnostix.dwd.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-block@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, qkrwngud825@gmail.com, Kernel-team@fb.com, Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@fb.com>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Thu, Apr 28, 2016 at 08:00:22PM +0000, Holger Kiehl wrote:
> Hello,
> 
> On Mon, 25 Apr 2016, Shaohua Li wrote:
> 
> > blk_queue_split marks bio unmergeable, which makes sense for normal bio.
> > But if dispatching the bio to underlayer disk, the blk_queue_split
> > checks are invalid, hence it's possible the bio becomes mergeable.
> > 
> > In the reported bug, this bug causes trim against raid0 performance slash
> > https://bugzilla.kernel.org/show_bug.cgi?id=117051
> > 
> This patch makes a huge difference. On a system with two Samsung 850 Pro
> in a MD Raid0 setup the time for fstrim went down from ~30min to 18sec!
> 
> However, on another system with two Intel P3700 1.6TB NVMe PCIe SSD's
> also setup as one big MD Raid0, the patch does not make any difference
> at all. fstrim takes more then 4 hours!

Does the raid0 cross two partitions or two SSD?

can you post blktrace data in the bugzilloa, I'll track the bug there.

Thanks,
Shaohua
