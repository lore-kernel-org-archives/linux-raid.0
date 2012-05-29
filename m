From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: Reason for md raid 01 blksize limited to 4 KiB?
Date: Tue, 29 May 2012 11:30:27 +0200
Message-ID: <4FC49733.9050905@profitbricks.com>
References: <4FBA0047.5050208@profitbricks.com>	<20120522092817.1b5946b8@notabene.brown>	<4FBF7CAD.7000307@profitbricks.com> <20120528140505.6eb49b26@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120528140505.6eb49b26@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28/05/12 06:05, NeilBrown wrote:
> What do you mean by "doesn't work"?  Returns errors? crashes? hangs? kills
> you cat?
> 

dd with oflag=direct returned an IO error.

> It works for me.
> 
> When I use 32K direct writes to a RAID1, both underlying RAID0 arrays see
> 64-sector writes.
> 
> (when I do normal buffered writes I see 8-sector writes which seems odd,
>  but clearly md/RAID1 is allowing large writes through)
> 

Now, I've updated mdadm to version 3.2.5 and it works like you've
described it. Thanks for your help! But the buffered IO is what matters.
4k isn't enough there. Please inform me about changes which increase the
size in buffered IO. I'll have a look at this, too.

Cheers,
Sebastian
