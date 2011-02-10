From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: raid related kernel hang in 2.6.36
Date: Thu, 10 Feb 2011 11:28:24 -0500
Message-ID: <4D541228.2090700@cdf.toronto.edu>
References: <4CED17A4.7050604@perabytes.com>	 <AANLkTinfbPDQhmKRVibUv+Rm50wDkGizeYLGXQqY_xOu@mail.gmail.com>	 <4CED226D.6090602@perabytes.com>  <20101125070155.277a0d62@notabene.brown> <1290654763.5416.31.camel@dujun.perabytes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1290654763.5416.31.camel@dujun.perabytes.com>
Sender: linux-raid-owner@vger.kernel.org
To: dujun <dujun@perabytes.com>
Cc: Neil Brown <neilb@suse.de>, =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>, linux-raid@vger.kernel.org, CDF Admin <admin@cdf.toronto.edu>
List-Id: linux-raid.ids

Hi Neil,

We are currently using 2.6.36 on a production machine running mdadm, and 
this morning we experienced a very similar issue, but we didn't have the 
LOCKUP_DETECTOR config options set, so there was absolutely no output. 
We also experienced this on a non-production test platform a few days 
ago (same hardware and software as our production machine).

Has this bug been diagnosed/resolved? If so, past which kernel version? 
If not, can you suggest some recourse for us, like perhaps moving back 
to 2.6.35 for our production server, and moving up to the latest stable 
on our test platform, and enabling the LOCKUP_DETECTOR options?

Is this bug totally reproducible Du Jun? If so, should I just try what 
you outlined in your previous message?

Many thanks,
Iordan Iordanov

