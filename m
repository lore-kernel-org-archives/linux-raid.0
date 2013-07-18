From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: shown disk sizes
Date: Thu, 18 Jul 2013 09:35:01 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1307180929280.8891@uplift.swm.pp.se>
References: <1374071867.25339.14.camel@heisenberg.scientia.net> <20130718094327.7d46949e@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130718094327.7d46949e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 18 Jul 2013, NeilBrown wrote:

>> Last but not least... when the tools print values like "10.00 GiB 10.74
>> GB"... wouldn't it be better if they printed "~10.00 GiB ~10.74 GB" or
>> something like this to show that the values are rounded and not
>> _exactly_ 10 GiB... could be helpful to avoid misalignment issues.
>
> Would that really help?  Given that 10.00GiB is not exactly the same as
> 10.74GB, isn't it obvious that they must be approximations?
>
> I'm not exactly against adding '~' but it doesn't seem necessary.
> Does anyone else have thoughts?

When I studied rounding I was taught that 10.74 implied values could be 
between 10.744999999... and 10.735000000... Same goes with 10.00 can be 
between 10.004999999... and 99.995000000...

As long as the value numbers are correctly rounded, I don't feel there is 
a need to put the "~" in there. 10.74GB doesn't imply 10.7400000000000.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
