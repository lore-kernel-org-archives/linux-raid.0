From: dean gaudet <dean@arctic.org>
Subject: Re: 2.6.24-rc6 reproducible raid5 hang
Date: Wed, 9 Jan 2008 23:13:45 -0800 (PST)
Message-ID: <alpine.DEB.0.999999.0801092309150.27277@twinlark.arctic.org>
References: <alpine.DEB.0.999999.0712270845150.5207@twinlark.arctic.org> <alpine.DEB.0.999999.0712270938160.5207@twinlark.arctic.org> <Pine.LNX.4.64.0712290842530.21114@twinlark.arctic.org> <e9c3a7c20712291247u7d5f6b76gf44a1770f5cdc2cf@mail.gmail.com>
 <alpine.DEB.0.999999.0712291248490.5207@twinlark.arctic.org> <e9c3a7c20712291406ve91e0d5h72979a8dbc4c6844@mail.gmail.com> <alpine.DEB.0.999999.0712300922520.20553@twinlark.arctic.org> <1199903330.18882.7.camel@dwillia2-linux.ch.intel.com>
 <18309.25170.258730.225322@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18309.25170.258730.225322@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 10 Jan 2008, Neil Brown wrote:

> On Wednesday January 9, dan.j.williams@intel.com wrote:
> > On Sun, 2007-12-30 at 10:58 -0700, dean gaudet wrote:
> > > i have evidence pointing to d89d87965dcbe6fe4f96a2a7e8421b3a75f634d1
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d89d87965dcbe6fe4f96a2a7e8421b3a75f634d1
> > > 
> > > which was Neil's change in 2.6.22 for deferring generic_make_request 
> > > until there's enough stack space for it.
> > > 
> > 
> > Commit d89d87965dcbe6fe4f96a2a7e8421b3a75f634d1 reduced stack utilization
> > by preventing recursive calls to generic_make_request.  However the
> > following conditions can cause raid5 to hang until 'stripe_cache_size' is
> > increased:
> > 
> 
> Thanks for pursuing this guys.  That explanation certainly sounds very
> credible.
> 
> The generic_make_request_immed is a good way to confirm that we have
> found the bug,  but I don't like it as a long term solution, as it
> just reintroduced the problem that we were trying to solve with the
> problematic commit.
> 
> As you say, we could arrange that all request submission happens in
> raid5d and I think this is the right way to proceed.  However we can
> still take some of the work into the thread that is submitting the
> IO by calling "raid5d()" at the end of make_request, like this.
> 
> Can you test it please?  Does it seem reasonable?


i've got this running now (against 2.6.24-rc6)... it has passed ~25 
minutes of testing so far, which is a good sign.  i'll report back 
tomorrow and hopefully we'll have survived 8h+ of testing.

thanks!

w.r.t. dan's cfq comments -- i really don't know the details, but does 
this mean cfq will misattribute the IO to the wrong user/process?  or is 
it just a concern that CPU time will be spent on someone's IO?  the latter 
is fine to me... the former seems sucky because with today's multicore 
systems CPU time seems cheap compared to IO.

-dean
