From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: [PATCH 00/19] Hardware Accelerated MD RAID5: Introduction
Date: Thu, 14 Sep 2006 09:42:48 +0200
Message-ID: <20060914074248.GD23492@unthought.net>
References: <1158015632.4241.31.camel@dwillia2-linux.ch.intel.com> <20060913071512.GA23492@unthought.net> <e9c3a7c20609131217q145fb234q36f70b23f1acf950@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e9c3a7c20609131217q145fb234q36f70b23f1acf950@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, christopher.leech@intel.com
List-Id: linux-raid.ids

On Wed, Sep 13, 2006 at 12:17:55PM -0700, Dan Williams wrote:
...
> >Out of curiosity; how does accelerated compare to non-accelerated?
> 
> One quick example:
> 4-disk SATA array rebuild on iop321 without acceleration - 'top'
> reports md0_resync and md0_raid5 dueling for the CPU each at ~50%
> utilization.
> 
> With acceleration - 'top' reports md0_resync cpu utilization at ~90%
> with the rest split between md0_raid5 and md0_raid5_ops.
> 
> The sync speed reported by /proc/mdstat is ~40% higher in the accelerated 
> case.

Ok, nice :)

> 
> That being said, array resync is a special case, so your mileage may
> vary with other applications.

Every-day usage I/O performance data would be nice indeed :)

> I will put together some data from bonnie++, iozone, maybe contest,
> and post it on SourceForge.

Great!

-- 

 / jakob

