From: Gilad Arnold <arnold@cs.berkeley.edu>
Subject: Re: migrating from RAID5 to RAID10
Date: Wed, 16 Jun 2010 11:30:31 -0700
Message-ID: <20100616183031.GB2513@scorpio.mgarnold.homelinux.org>
References: <20100609151132.GA10082@libra.CS.Berkeley.EDU>
 <20100611005231.401529c0@natsu>
 <20100610195851.GA8408@libra.CS.Berkeley.EDU>
 <4C18F39E.8010600@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C18F39E.8010600@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Roman Mamedov <roman@rm.pp.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Bill,

On Wed, Jun 16, 2010 at 11:54:06AM -0400, Bill Davidsen wrote:
> If it were me, I would leave the raid up, install the new drive, and
> just copy the data to it. That way you have error tolerance on the
> original data, while your method doesn't. After doing that and reading
> the entire new drive to be sure it's valid, configure the two original
> drives as a degraded three drive raid10. After that's done AND TESTED
> to see that the data are still all valid, then you add the new drive
> to the raid10 and get full operation.

Thanks for the thorough evaluation and thoughtful advice! Much
appreciated.  I agree it makes a lot more sense and I will follow your
suggested procedure (when I get to purchase the extra drive ;-) )

> Actually, if it were me I'd have a backup, too. And be damn sure to
> run on a UPS.

Great points. I will use a remote backup. I should get a UPS, really...
that'll be a good incentive to stop procrastinating this ;-)

Thanks again.

Gilad
