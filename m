From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID 5 write performance advice
Date: Mon, 29 Aug 2005 09:28:42 +1000
Message-ID: <17170.18602.592283.92772@cse.unsw.edu.au>
References: <430C2EA6.2050103@web.de>
	<1124887589.5550.27.camel@localhost.localdomain>
	<430C798B.1030107@web.de>
	<17164.59261.540591.841830@cse.unsw.edu.au>
	<430DF416.1070101@web.de>
	<1124988876.5552.59.camel@localhost.localdomain>
	<430ECA18.10405@web.de>
	<1125066621.5549.27.camel@localhost.localdomain>
	<430F3565.2070302@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mirko Benz on Friday August 26
Sender: linux-raid-owner@vger.kernel.org
To: Mirko Benz <mirko.benz@web.de>
Cc: mingz@ele.uri.edu, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday August 26, mirko.benz@web.de wrote:
> Hello,
> 
> Here are the results using 5 disks for RAID 5 $,1rs(B basically the same 
> results but with lower values.
> Again, much slower than it could be.

Yes, there definitely does seem to be something wrong with raid5 write
speed, doesn't there!!

I will try to look into it over the next couple of weeks.

NeilBrown
