From: Gilad Arnold <arnold@cs.berkeley.edu>
Subject: Re: migrating from RAID5 to RAID10
Date: Thu, 17 Jun 2010 21:01:08 -0700
Message-ID: <20100618040107.GA13272@scorpio.mgarnold.homelinux.org>
References: <20100609151132.GA10082@libra.CS.Berkeley.EDU>
 <20100611005231.401529c0@natsu>
 <20100610195851.GA8408@libra.CS.Berkeley.EDU>
 <4C18F39E.8010600@tmr.com>
 <20100617072631.09641f48@notabene.brown>
 <20100617174445.GB8450@libra.CS.Berkeley.EDU>
 <20100617224657.GD8450@libra.CS.Berkeley.EDU>
 <20100618123910.711b527b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100618123910.711b527b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Bill Davidsen <davidsen@tmr.com>, Roman Mamedov <roman@rm.pp.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jun 18, 2010 at 12:39:10PM +1000, Neil Brown wrote:
> > 1. Shutdown the RAID5.
> > 
> > 2. Create a RAID10/f2 on top of one drive + missing, ignoring mdadm's
> >    warnings about an existing array. If I'm not terribly wrong, this
> >    will give me a degraded RAID10 that still has all my data in place.
> 
> I cannot imagine why you would think that all your data would be in place.
> I can assure that it would not.

I was thinking it would be a similar case to the one mentioned here:

http://scott.wallace.sh/2007/04/14/converting-raid1-to-raid5-with-no-data-loss/

Guess I was wrong. Thanks for the advice.

Gilad
