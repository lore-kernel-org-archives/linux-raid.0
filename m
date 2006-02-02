From: Neil Brown <neilb@suse.de>
Subject: Re: RAID 16?
Date: Thu, 2 Feb 2006 17:03:38 +1100
Message-ID: <17377.41146.565087.713849@cse.unsw.edu.au>
References: <43E19FAB.4000603@cogweb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Liontooth on Wednesday February 1
Sender: linux-raid-owner@vger.kernel.org
To: David Liontooth <liontooth@cogweb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday February 1, liontooth@cogweb.net wrote:
> 
> We're wondering if it's possible to run the following --
> 
>   * define 4 pairs of RAID 1 with an 8-port 3ware 9500S card
>   * the OS will see these are four normal drives
>   * use md to configure them into a RAID 6 array
> 
> Would this work? Would it be better than RAID 15? We're looking for a
> very high redundancy system.

There is no reason why this shouldn't work.  Go for it....

NeilBrown


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
