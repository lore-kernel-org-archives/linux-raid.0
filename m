From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: [PATCH] MD: make bio mergeable
Date: Fri, 29 Apr 2016 09:23:54 +0000 (UTC)
Message-ID: <alpine.LRH.2.20.1604290915560.24906@diagnostix.dwd.de>
References: <384a0e0c7d6f2700aadbcbdef003cece88fa7dd7.1461626533.git.shli@fb.com> <alpine.LRH.2.20.1604281933200.31165@diagnostix.dwd.de> <20160428211908.GA3116523@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160428211908.GA3116523@devbig084.prn1.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-block@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, qkrwngud825@gmail.com, Kernel-team@fb.com, Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@fb.com>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Thu, 28 Apr 2016, Shaohua Li wrote:

> On Thu, Apr 28, 2016 at 08:00:22PM +0000, Holger Kiehl wrote:
> > Hello,
> > 
> > On Mon, 25 Apr 2016, Shaohua Li wrote:
> > 
> > > blk_queue_split marks bio unmergeable, which makes sense for normal bio.
> > > But if dispatching the bio to underlayer disk, the blk_queue_split
> > > checks are invalid, hence it's possible the bio becomes mergeable.
> > > 
> > > In the reported bug, this bug causes trim against raid0 performance slash
> > > https://bugzilla.kernel.org/show_bug.cgi?id=117051
> > > 
> > This patch makes a huge difference. On a system with two Samsung 850 Pro
> > in a MD Raid0 setup the time for fstrim went down from ~30min to 18sec!
> > 
> > However, on another system with two Intel P3700 1.6TB NVMe PCIe SSD's
> > also setup as one big MD Raid0, the patch does not make any difference
> > at all. fstrim takes more then 4 hours!
> 
> Does the raid0 cross two partitions or two SSD?
> 
Two SSD's. Where it works, for the two Samsung 850 Pro SATA SSD it was
via partitions.

> can you post blktrace data in the bugzilloa, I'll track the bug there.
> 
I did the blktrace on the two md raid0 devices /dev/nvme[01]n1 for 2 minutes
and attached them to the bug 117051 as a tar.bz2 file:

   https://bugzilla.kernel.org/show_bug.cgi?id=117051

Please just ask if I have forgotten anything. And many thanks for looking
at this and all the good work!

Regards,
Holger
