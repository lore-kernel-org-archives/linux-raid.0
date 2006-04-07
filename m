From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm > 2.2 ver1 superblock regression?
Date: Fri, 7 Apr 2006 11:25:07 +1000
Message-ID: <17461.49011.622350.590931@cse.unsw.edu.au>
References: <170fa0d20604061418t6bd1d6d7yad02290e93fb04d3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Snitzer on Thursday April 6
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday April 6, snitzer@gmail.com wrote:
> When I try to create a RAID1 array with ver 1.0 superblock using mdadm
> > 2.2 I'm getting:
> WARNING - superblock isn't sized correctly
> 
> Looking at the code (and adding a bit more debugging) it is clear that
> all 3 checks fail in super1.c's calc_sb_1_csum()'s "make sure I can
> count..." test.
> 
> Is this a regression in mdadm 2.4, 2.3.1 and 2.3 (NOTE: mdadm 2.2's
> ver1 sb works!)?

Oh bother and tarnation!!!! (whatever that means).

I've put a 64bit quantity (reshape_position) on a 32bit boundary, not
a 64 bit boundary.  That works fine on x86, but not in some other
places.

Seeing this hasn't made it into a released kernel yet, I might just
change it.  But I'll have to make sure that old mdadm's don't mess
things up ... I wonder how I will do that :-(

Thanks for the report.

NeilBrown

> 
> please advise, thanks.
> Mike
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
