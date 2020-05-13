From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: raid6check extremely slow ?
Date: Wed, 13 May 2020 20:23:40 +0200
Message-ID: <20200513182340.GA10256@lazy.lzy>
References: <2cf55e5f-bdfb-9fef-6255-151e049ac0a1@cloud.ionos.com>
 <20200511064022.591C5240E1A@gemini.denx.de>
 <f003a8c7-e96d-ddc3-6d1d-42a13b70e0b6@cloud.ionos.com>
 <20200511161415.GA8049@lazy.lzy>
 <23d84744-9e3c-adc1-3af1-6498b9bcf750@cloud.ionos.com>
 <24249.54587.74070.71273@base.ty.sabi.co.uk>
 <20200512160943.GC7261@lazy.lzy>
 <34f66548-1fcf-d38b-4c2d-88d43c1b19d0@youngman.org.uk>
 <20200513161841.GA5530@lazy.lzy>
 <5EBC304E.7010402@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5EBC304E.7010402@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Peter Grandi <pg@lxraid.list.sabi.co.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, May 13, 2020 at 06:37:18PM +0100, Wols Lists wrote:
> On 13/05/20 17:18, Piergiorgio Sartor wrote:
> > On Tue, May 12, 2020 at 09:54:21PM +0100, antlists wrote:
> >> On 12/05/2020 17:09, Piergiorgio Sartor wrote:
> >>> About the check -> maybe lock -> re-check,
> >>> it is a possible workaround, but I find it
> >>> a bit extreme.
> >>
> >> This seems the best (most obvious?) solution to me.
> >>
> >> If the system is under light write pressure, and the disk is healthy, it
> >> will scan pretty quickly with almost no locking.
> > 
> > I've some concerns about optimization
> > solutions which can result in less
> > performances than the original status.
> > 
> > You mention "write pressure", but there
> > is an other case, which will cause
> > read -> lock -> re-read...
> > Namely, when some chunk is really corrupted.
> > 
> Yup. That's why I said "the disk is healthy" :-)

We need to consider all posibilities...
 
> > Now, I do not know, maybe there are other
> > things we overlook, or maybe not.
> > 
> > I do not know either how likely is that some
> > situations will occur to reduce performances.
> > 
> > I would prefer a solution which will *only*
> > improve, without any possible drawback.
> 
> Wouldn't we all. But if the *normal* case shows an appreciable
> improvement, then I'm inclined to write off a "shouldn't happen" case as
> "tough luck, shit happens".
> > 
> > Again, this does not mean this approach is
> > wrong, actually is to be considered.
> > 
> > In the end, I would like also to understand
> > why the lock / unlock is so expensive.
> 
> Agreed.
> > 
> >> If the system is under heavy pressure, chances are there'll be a fair few
> >> stripes needing rechecking, but even at it's worst it'll only be as bad as
> >> the current setup.
> > 
> > It will be worse (or worst, I'm always
> > confused...).
> > The read and the check will double.
> 
> Touche - my logic was off ...
> 
> But a bit of grammar - bad = descriptive, worse = comparative, worst =
> absolute, so you were correct with worse.

Ah! Thank you.
That's always confusing me. Usually I check
with some search engine, but sometimes I'm
too lazy... And then I forgot.

BTW, somehow related, please do not
refrain to correct my English.

> > I'm not sure about the read, but the
> > check is currently expensive.
> 
> But you're still going to need a very unlucky state of affairs for the
> optimised check to be worse. Okay, if the disk IS damaged, then the
> optimised check could easily be the worst, but if it's just write
> pressure, you're going to need every second stripe to be messed up by a
> collision. Rather unlikely imho.

Well, as Neil would say, patch are welcome! :-)

Really, I've too little time to make
changes to the code.
I can do some test and, hopefully,
some support.

bye,

pg

> > 
> > bye,
> > 
> > pg
> 
> Cheers,
> Wol
> > 
> >> And if the system is somewhere inbetween, you still stand a good chance of a
> >> fast scan.
> >>
> >> At the end of the day, the rule should always be "lock only if you need to"
> >> so looking for problems with an optimistic no-lock scan, then locking only
> >> if needed to check and fix the problem, just feels right.
> >>
> >> Cheers,
> >> Wol
> > 

-- 

piergiorgio
