From: Keld Simonsen <keld@keldix.com>
Subject: Re: migrating from RAID5 to RAID10
Date: Fri, 18 Jun 2010 10:40:28 +0200
Message-ID: <20100618084028.GA23230@rap.rap.dk>
References: <20100609151132.GA10082@libra.CS.Berkeley.EDU>
 <20100611005231.401529c0@natsu>
 <20100610195851.GA8408@libra.CS.Berkeley.EDU>
 <4C18F39E.8010600@tmr.com>
 <20100617072631.09641f48@notabene.brown>
 <20100617174445.GB8450@libra.CS.Berkeley.EDU>
 <20100618083053.7df5248b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100618083053.7df5248b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Gilad Arnold <arnold@cs.berkeley.edu>, Bill Davidsen <davidsen@tmr.com>, Roman Mamedov <roman@rm.pp.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jun 18, 2010 at 08:30:53AM +1000, Neil Brown wrote:
> 
> 2-drive RAID10 f2  would be expected to provide better read throughput
> (possibly twice as fast) at some cost to write throughput.  For many people
> this is a worthwhile trade-off.  So it might be better for you.
> Read throughput would degraded down to write throughput (i.e. slower than
> RAID1) if the RAID10 were degraded.

The slowdown of write thruput is on the raw raid, and on file systems
without elevator algorithms. If you employ a file system with an
elevator algorithm, then there will be no noticeable slowdown for
writes, as witnessed by many benchmarks.

best regards
keld
