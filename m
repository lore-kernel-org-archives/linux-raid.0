From: Bill Davidsen <tmrbill@tmr.com>
Subject: Re: stripe_cache_size ?
Date: Fri, 9 Dec 2005 09:06:32 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0512090903370.5233-100000@firewall2.tmr.com>
References: <17305.21180.376781.954660@cse.unsw.edu.au>
Reply-To: davidsen@tmr.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17305.21180.376781.954660@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Kyle Wong <kylewong@southa.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 9 Dec 2005, Neil Brown wrote:

> On Friday December 9, kylewong@southa.com wrote:
> > Hi,
> > 
> > I found that there's a new sysfs "stripe_cache_size" variable. I want to
> > know how does it affect RAID5 read / write performance (if any) ?
> > Please cc to me if possible, thanks.
> 
> Would you like to try it out and see?
> Any value from about 10 to a few thousand should be perfectly safe,
> though very large values may cause the system to run short of memory.
> 
> The memory used is approximately
>    stripe_cache_size * 4K * number-of-drives

What??? I hope that's a typo...
 1 - there's no use of the sysfs variable?
 2 - that's going to be huge, 128k * 4k * 10 = 5.1GB !!!

> 
> NeilBrown

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
Doing interesting things with little computers since 1979

