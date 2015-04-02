From: Simon Kirby <sim@hostway.ca>
Subject: Re: [neilb@suse.de: Re: MD request counter broken on 4.0-rc5 RAID1]
Date: Thu, 2 Apr 2015 12:54:29 -0700
Message-ID: <20150402195429.GA24657@hostway.ca>
References: <20150325173346.GF8519@hostway.ca>
 <551BA0C3.7090004@cn.fujitsu.com>
 <20150401220725.53ee8f99@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150401220725.53ee8f99@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 01, 2015 at 10:07:25PM +1100, NeilBrown wrote:

> On Wed, 1 Apr 2015 15:39:47 +0800 Gu Zheng <guz.fnst@cn.fujitsu.com> wrote:
> 
> > Hi Neil,
> > One question about md io stats account:
> > I find that we just accounting disk_stats.sectors[rw] and disk_stats.ios[rw] at
> > md_make_request, but I did not find accounting disk_stats.ticks[rw], do not we
> > need it? or I missed something?
> 
> No, I don't think you are missing anything.  md doesn't track 'ticks' - and
> no-one has ever complained.

Hmm, yes, I guess "working" before was "0% utilization". :)

Simon-
