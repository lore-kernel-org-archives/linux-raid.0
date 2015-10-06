From: Shaohua Li <shli@fb.com>
Subject: Re: raid5-cache I/O path improvements V3
Date: Tue, 6 Oct 2015 11:14:03 -0700
Message-ID: <20151006181335.GA3367313@devbig084.prn1.facebook.com>
References: <1444030276-30850-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1444030276-30850-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: neilb@suse.de, dan.j.williams@intel.com, Kernel-team@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 05, 2015 at 09:31:05AM +0200, Christoph Hellwig wrote:
> Hi Shaohua, hi Neil,
> 
> this series contains a few updates to the raid5-cache feature, and goes
> on top of dm/devel + the series Shaohua sent yesterday.
> 
> Besides the rebase the only changes compared to the previous version
> is that we only bypasss the batch and flush state for devices that
> do not have a volatile cache at all like persistent memory or high
> performance flash devices.

Thanks Christoph, patches look great.

Reviewed-by: Shaohua Li <shli@fb.com>
