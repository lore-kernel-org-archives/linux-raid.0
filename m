From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 1/2]MD: raid5 trim support
Date: Thu, 20 Sep 2012 12:25:41 +0800
Message-ID: <20120920042541.GA12704@kernel.org>
References: <20120918082511.GA6298@kernel.org>
 <20120920111517.54d05380@notabene.brown>
 <20120920013642.GA6798@kernel.org>
 <20120920114740.7e2c2d1f@notabene.brown>
 <20120920022717.GD6798@kernel.org>
 <20120920135914.63bf9ff4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120920135914.63bf9ff4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 20, 2012 at 01:59:14PM +1000, NeilBrown wrote:
> On Thu, 20 Sep 2012 10:27:17 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> in which wrong sectors were trimmed....
> > 
> > Ok, just confirmed, delete raid5_compute_sector is ok if I adjust
> > logical_sector calculation. Here is the new patch.
> > 
> 
> Thanks.  That looks better.  I've applied it with some minor formatting
> changes.
> 
> I then went to look at the follow-up page and .....
> I count 11 separate places where you test the new flag and possibly memset a
> page to zero.  This doesn't seem like an improvement to me.

We do the zero page just before the stripe is hit in cache, which is rare case.
 
> Why don't we just mark the page as not up-to-date when we discard it?  That
> would avoid storing inconsistent data, and would avoid needing to zero pages.

We need re-read the strip if it's hit in cache, but it's rare case, we don't
care. So when we clear the up-to-date flag? I saw a lot of places checking
up-to-date flag in the write path. Need close look to check if there is race.

Thanks,
Shaohua
