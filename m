From: Bill Davidsen <tmrbill@tmr.com>
Subject: Re: RAID 16?
Date: Thu, 2 Feb 2006 21:32:44 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0602022119380.12829-100000@firewall2.tmr.com>
References: <43E19FAB.4000603@cogweb.net>
Reply-To: davidsen@tmr.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43E19FAB.4000603@cogweb.net>
Sender: linux-raid-owner@vger.kernel.org
To: David Liontooth <liontooth@cogweb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 1 Feb 2006, David Liontooth wrote:

> 
> We're wondering if it's possible to run the following --
> 
>   * define 4 pairs of RAID 1 with an 8-port 3ware 9500S card
>   * the OS will see these are four normal drives
>   * use md to configure them into a RAID 6 array
> 
> Would this work? Would it be better than RAID 15? We're looking for a
> very high redundancy system.

You only get the size of two drives with that! I think you would get the 
same reliability and better performance with four RAID-1 mirror arrays and 
RAID-5 over that. You still have to lose four drives to lose data, but you 
get the size of three instead of two.

If you really care about it, use two controllers, put four sets mirrored 
one drive on each controller, then RAID-5 over that.

> 
> This is on a Debian system running the 2.6 kernel. We're contemplating
> running EVMS on top.
> 
> Dave
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
Doing interesting things with little computers since 1979

