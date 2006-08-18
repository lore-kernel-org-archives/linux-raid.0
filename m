From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Subject: Re: remark and RFC
Date: Fri, 18 Aug 2006 09:51:14 +0200 (MET DST)
Message-ID: <200608180751.k7I7pE609767@inv.it.uc3m.es>
Reply-To: ptb@inv.it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: From (env: ptb) at "Aug 17, 2006 08:28:07 am"
Sender: linux-raid-owner@vger.kernel.org
To: ptb@inv.it.uc3m.es
Cc: Neil Brown <neilb@suse.de>, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"Also sprach ptb:"
> 4) what the network device driver wants to do is be able to identify
>    the difference between primary requests and retries, and delay 
>    retries (or repeat them internally) with some reasonable backoff
>    scheme to give them more chance of working in the face of a
>    brownout, but it has no way of doing that.  You can make the problem
>    go away by delaying retries yourself (is there a timedue field in
>    requests, as well as a timeout field?  If so, maybe that can be used
>    to signal what kind of a request it is and how to treat it).

If one could set the 

    unsigned long start_time;

field in the outgoing retry request to now + 1 jiffy, that might be
helpful.  I can't see a functionally significant use of this field at
present in the kernel ...  ll_rw_blk rewrites the field when merging
requests and end_that_request then uses it for the accounting stats
(duration) __disk_stat_add(disk, ticks[rw], duration) which will add a
minus 1 at worst.

Shame there isn't a timedue field in the request struct.

Silly idea, maybe.

Peter
