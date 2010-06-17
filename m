From: Gilad Arnold <arnold@cs.berkeley.edu>
Subject: Re: migrating from RAID5 to RAID10
Date: Thu, 17 Jun 2010 10:44:46 -0700
Message-ID: <20100617174445.GB8450@libra.CS.Berkeley.EDU>
References: <20100609151132.GA10082@libra.CS.Berkeley.EDU>
 <20100611005231.401529c0@natsu>
 <20100610195851.GA8408@libra.CS.Berkeley.EDU>
 <4C18F39E.8010600@tmr.com>
 <20100617072631.09641f48@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100617072631.09641f48@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Bill Davidsen <davidsen@tmr.com>, Roman Mamedov <roman@rm.pp.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 17, 2010 at 07:26:31AM +1000, Neil Brown wrote:
> A RAID5 on 2 devices would be a little slower than RAID1 on two
> devices as there is more copying of data around in memory, and there
> is no read balancing, but it shouldn't be much slower.
> 
> However with recent mdadm and kernel you can trivially convert a 2 drive
> RAID1 to a 2 drive RAID5 while the array is online, so it should be easy to
> experiment and change you mind about how you want it configured.

Thanks for the interesting comments, Neil.

Preparing for the upgrade I've been cleaning up data and ended up
realizing that I won't need to add another drive in the near future ;-)
I would like to change my RAID level, though, to improve performance,
and the idea of online layout conversion is very appealing.

I understand that a 2-drive RAID5 can be converted to a RAID1 already,
but it is also my understanding that RAID1 currently does not benefit
from striped reading performance, either entirely (due to
implementation) or partly (compared to RAID10 in f2 mode).  This leads
me to think that even with 2 drives, RAID10/f2 is a better choice than
RAID1. Is this a fair assessment?  And, if it is the case, can RAID5 be
converted to RAID10/f2 on-the-fly, or would I have to take the longer
path?  (i.e.  degrade RAID5, start RAID10 in degraded mode, copy data,
kill RAID5 and rebuild RAID10)

Many thanks for all your help. I finally seem to be converging ;-)

Gilad
