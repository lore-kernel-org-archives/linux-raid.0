From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch v2 0/6] raid5: automatically batch adjacent full stripe
 write
Date: Thu, 11 Sep 2014 22:38:12 +0800
Message-ID: <20140911143812.GA12404@kernel.org>
References: <20140910124009.810771309@kernel.org>
 <20140911171525.4ec2a88d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140911171525.4ec2a88d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 11, 2014 at 05:15:25PM +1000, NeilBrown wrote:
> On Wed, 10 Sep 2014 20:40:09 +0800 shli@kernel.org wrote:
> 
> > This is the 2nd attempt to make adjacent full stripe write together. The main
> > change against v1 is how to detect if stripes can be batched. Also some bugs
> > are fixed.
> > 
> 
> Thanks a lot for this - it looks quite good.  I've read through most of it
> and don't see anything worth mentioning.... except maybe to wonder why
> to_addr_page() has an unused 'sh' argument.  Maybe I'll just remove that(?).

Can be removed. I just want the parameters of to_addr_conv/page are the same.

> I've pushed it you the 'devel' branch of my md git tree.  I'll try to do some
> testing of my own next week.

Thanks!

Thanks,
Shaohua
