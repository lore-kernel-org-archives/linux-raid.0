From: Jay Strauss <me@heyjay.com>
Subject: Re: Raid 1 install revealed poor HD performance (I think)
Date: Tue, 17 May 2005 15:51:26 -0500
Message-ID: <428A594E.5080207@heyjay.com>
References: <428A09A3.9000802@heyjay.com> <Pine.LNX.4.56.0505171649090.32621@lion.drogon.net> <428A1924.8030801@heyjay.com> <Pine.LNX.4.56.0505171720070.32621@lion.drogon.net> <428A2133.4080202@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <428A2133.4080202@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: Gordon Henderson <gordon@drogon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> I was sure it would be DMA too :-). Wonder if multicount makes that much
> of a difference?

It doesn't, I tried just before leaving this morning.  No diff.

> 
> Either way, one of the first things I typically do on a server is add an
> hdparm line with whatever the disks need for that particular machine.

I don't understand the above "whatever the disks need" portion of this 
statement.  Can you give me a little more detail?

> So, even if you can't get your distribution to tune your IDE chipset and
> IDE hard drives perfectly, with something like multicount or write
> caching, its effective (IMHO) to just force your settings on boot.

What settings am I to force?  And to what values?  I guess I'm asking, 
are you saying just put the hdparm setting in a rc.local?  If so, I'm 
still stumped on what those settings need to be

Thanks
Jay
