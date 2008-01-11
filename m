From: Neil Brown <neilb@suse.de>
Subject: Re: 2.6.24-rc6 reproducible raid5 hang
Date: Fri, 11 Jan 2008 12:46:34 +1100
Message-ID: <18310.51834.334017.700075@notabene.brown>
References: <alpine.DEB.0.999999.0712270845150.5207@twinlark.arctic.org>
	<alpine.DEB.0.999999.0712270938160.5207@twinlark.arctic.org>
	<Pine.LNX.4.64.0712290842530.21114@twinlark.arctic.org>
	<e9c3a7c20712291247u7d5f6b76gf44a1770f5cdc2cf@mail.gmail.com>
	<alpine.DEB.0.999999.0712291248490.5207@twinlark.arctic.org>
	<e9c3a7c20712291406ve91e0d5h72979a8dbc4c6844@mail.gmail.com>
	<alpine.DEB.0.999999.0712300922520.20553@twinlark.arctic.org>
	<1199903330.18882.7.camel@dwillia2-linux.ch.intel.com>
	<18309.25170.258730.225322@notabene.brown>
	<alpine.DEB.0.999999.0801092309150.27277@twinlark.arctic.org>
	<e9c3a7c20801101049r435548e9t5fb552750ca20310@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Thursday January 10
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: dean gaudet <dean@arctic.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 10, dan.j.williams@gmail.com wrote:
> On Jan 10, 2008 12:13 AM, dean gaudet <dean@arctic.org> wrote:
> > w.r.t. dan's cfq comments -- i really don't know the details, but does
> > this mean cfq will misattribute the IO to the wrong user/process?  or is
> > it just a concern that CPU time will be spent on someone's IO?  the latter
> > is fine to me... the former seems sucky because with today's multicore
> > systems CPU time seems cheap compared to IO.
> >
> 
> I do not see this affecting the time slicing feature of cfq, because
> as Neil says the work has to get done at some point.   If I give up
> some of my slice working on someone else's I/O chances are the favor
> will be returned in kind since the code does not discriminate.  The
> io-priority capability of cfq currently does not work as advertised
> with current MD since the priority is tied to the current thread and
> the thread that actually submits the i/o on a stripe is
> non-deterministic.  So I do not see this change making the situation
> any worse.  In fact, it may make it a bit better since there is a
> higher chance for the thread submitting i/o to MD to do its own i/o to
> the backing disks.
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Thanks.
But I suspect you didn't test it with a bitmap :-)
I ran the mdadm test suite and it hit a problem - easy enough to fix.

I'll look out for any other possible related problem (due to raid5d
running in different processes) and then submit it.

Thanks,
NeilBrown
