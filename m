From: Neil Brown <neilb@suse.de>
Subject: Re: migrating from RAID5 to RAID10
Date: Fri, 18 Jun 2010 12:39:10 +1000
Message-ID: <20100618123910.711b527b@notabene.brown>
References: <20100609151132.GA10082@libra.CS.Berkeley.EDU>
	<20100611005231.401529c0@natsu>
	<20100610195851.GA8408@libra.CS.Berkeley.EDU>
	<4C18F39E.8010600@tmr.com>
	<20100617072631.09641f48@notabene.brown>
	<20100617174445.GB8450@libra.CS.Berkeley.EDU>
	<20100617224657.GD8450@libra.CS.Berkeley.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100617224657.GD8450@libra.CS.Berkeley.EDU>
Sender: linux-raid-owner@vger.kernel.org
To: Gilad Arnold <arnold@cs.berkeley.edu>
Cc: Bill Davidsen <davidsen@tmr.com>, Roman Mamedov <roman@rm.pp.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 17 Jun 2010 15:46:57 -0700
Gilad Arnold <arnold@cs.berkeley.edu> wrote:

> On Thu, Jun 17, 2010 at 10:44:45AM -0700, Gilad Arnold wrote:
> > This leads me to think that even with 2 drives, RAID10/f2 is a better
> > choice than RAID1. Is this a fair assessment?
> 
> Okay, I found the benchmarks that support this hypothesis ;-)
> 
> > And, if it is the case, can RAID5 be converted to RAID10/f2
> > on-the-fly, or would I have to take the longer path?  (i.e. degrade
> > RAID5, start RAID10 in degraded mode, copy data, kill RAID5 and
> > rebuild RAID10)
> 
> Some more reading leads me to think that on-the-fly RAID5 to RAID10/f2
> conversion wouldn't work.  However, I'm tempted to believe that I can
> avoid the data copy phase entirely and skip straight to RAID10 rebuild:
> 
> 1. Shutdown the RAID5.
> 
> 2. Create a RAID10/f2 on top of one drive + missing, ignoring mdadm's
>    warnings about an existing array. If I'm not terribly wrong, this
>    will give me a degraded RAID10 that still has all my data in place.

I cannot imagine why you would think that all your data would be in place.
I can assure that it would not.

NeilBrown

> 
> 3. Add the second drive to the RAID10 and watch it rebuild.
> 
> 
> Apologies for my petty questions ;-)  Advice appreciated.
> 
> Gilad

