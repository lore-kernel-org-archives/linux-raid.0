From: Shaohua Li <shli@kernel.org>
Subject: Re: Shouldn't the /sys/block/md*/queue/max_*sectors_kb be set to the
 chunk size?
Date: Thu, 18 May 2017 11:50:23 -0700
Message-ID: <20170518185023.3z5byy5uqpfb46w6@kernel.org>
References: <CANWz5fiQ1O5k43QKfurd84nwdeCZL0-EOD6p_2vp+wHaJmsVEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANWz5fiQ1O5k43QKfurd84nwdeCZL0-EOD6p_2vp+wHaJmsVEw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, May 18, 2017 at 05:52:28AM -1000, Chris Worley wrote:
> I'm obviously missing something...
> 
> If chunk size is a stride, why is the
> /sys/block/md*/queue/max_*sectors_kb being inherited from one of the
> underlying devices rather than being set to the chunk size or the
> drive multiple of their max sector settings?

We set it to chunk size unless underlying disks have a smaller max_*sectors_kb.
Underlying disks usually have much bigger max_sectors than chunk size.
 
> Or, in other words, would the chunk size setting have a natural upper
> bound/limit of one of the drives max_sectors, or the sum of all of the
> constituent drives max sectors?

I don't know such upper bound and don't think it matters. The max_sectors
basically is the size we split the bio to fit for one underlying disk.

Thanks,
Shaohua
