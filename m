From: Lars Ellenberg <Lars.Ellenberg@linbit.com>
Subject: Re: [patch] latency problem in md driver
Date: Tue, 26 Dec 2006 14:09:37 +0100
Message-ID: <20061226130937.GA19869@barkeeper1.linbit>
References: <20061222143215.GD7477@soda.linbit> <17804.17074.430522.825100@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17804.17074.430522.825100@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

/ 2006-12-23 07:40:18 +1100
\ Neil Brown:
> On Friday December 22, Lars.Ellenberg@linbit.com wrote:
> > 
> > md raidX make_request functions strip off the BIO_RW_SYNC flag,
> > this introducing additional latency.
> > 
> > below is a suggested patch for the raid1.c .
> > other suggested solutions would be to let the bio_clone do its work,
> > and not reassign thereby stripping off all flags.
> > at most strip off known unwanted flags (the BARRIER flag).
> > 
> > similar pattern in the other raid versions.
> 
> Thanks.  I think your patch is appropriate.
> I don't like the idea of passing down any flags by default.  If a flag
> makes failure more likely (like BIO_RW_AHEAD or BIO_RW_FAILFAST) then
> I *don't* want it passed down without making a conscious decision that
> it is a good idea.
> 
> So yes, _SYNC should be passed down in raid1/raid10.  More interesting
> stuff would be needed in raid456.
> _FAILFAST should probably never be passed down (well, maybe in
> multipath, but who uses md/multipath??)
> _META ... what is that ?? I'm not passing it down until I know!!
> 
> I'll look into this after the holidays.  Meanwhile if you want to be
> certain that this is in 2.6.20,
>   - Fix the retry-read case as well (where ->bi_rw is assigned about
>     10 lines from the end of raid1d()

I don't think thats necessary,
since an explicit unplug is in place there.
but ok.

>   - Create a 'perfect patch',
>   - add Acked-by: NeilBrown <neilb@suse.de>
>   - and post it to akpm@osdl.org (and appropriate lists).

-- 
: Lars Ellenberg                            Tel +43-1-8178292-55 :
: LINBIT Information Technologies GmbH      Fax +43-1-8178292-82 :
: Vivenotgasse 48, A-1120 Vienna/Europe    http://www.linbit.com :
