From: Neil Brown <neilb@suse.de>
Subject: Re: [patch] md: pass down BIO_RW_SYNC in raid{1,10}
Date: Tue, 9 Jan 2007 10:50:40 +1100
Message-ID: <17826.55504.264610.856196@notabene.brown>
References: <20070108090833.GF8125@soda.linbit>
	<20070108150242.1b39eda2.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Monday January 8
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Lars Ellenberg <Lars.Ellenberg@linbit.com>, Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, stable@kernel.org
List-Id: linux-raid.ids

On Monday January 8, akpm@osdl.org wrote:
> On Mon, 8 Jan 2007 10:08:34 +0100
> Lars Ellenberg <Lars.Ellenberg@linbit.com> wrote:
> 
> > md raidX make_request functions strip off the BIO_RW_SYNC flag,
> > thus introducing additional latency.
> > 
> > fixing this in raid1 and raid10 seems to be straight forward enough.
> > 
> > for our particular usage case in DRBD, passing this flag improved
> > some initialization time from ~5 minutes to ~5 seconds.
> 
> That sounds like a significant fix.
> 
> This patch also applies to 2.6.19 and I have tagged it for a -stable
> backport.  Neil, are you OK with that?

Yes, I'm OK with that, thanks.

NeilBrown
