From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch] md: pass down BIO_RW_SYNC in raid{1,10}
Date: Tue, 9 Jan 2007 08:12:25 +0100
Message-ID: <20070109071224.GG11203@kernel.dk>
References: <20070108090833.GF8125@soda.linbit> <20070108150242.1b39eda2.akpm@osdl.org> <17826.55504.264610.856196@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17826.55504.264610.856196@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, Lars Ellenberg <Lars.Ellenberg@linbit.com>, Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids

On Tue, Jan 09 2007, Neil Brown wrote:
> On Monday January 8, akpm@osdl.org wrote:
> > On Mon, 8 Jan 2007 10:08:34 +0100
> > Lars Ellenberg <Lars.Ellenberg@linbit.com> wrote:
> > 
> > > md raidX make_request functions strip off the BIO_RW_SYNC flag,
> > > thus introducing additional latency.
> > > 
> > > fixing this in raid1 and raid10 seems to be straight forward enough.
> > > 
> > > for our particular usage case in DRBD, passing this flag improved
> > > some initialization time from ~5 minutes to ~5 seconds.
> > 
> > That sounds like a significant fix.
> > 
> > This patch also applies to 2.6.19 and I have tagged it for a -stable
> > backport.  Neil, are you OK with that?
> 
> Yes, I'm OK with that, thanks.

Ack from me as well, it's really a quite nasty bug from a performance
POV. Not just for DRDB, but for io schedulers as well.

-- 
Jens Axboe

