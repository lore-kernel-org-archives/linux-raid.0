From: Ben Bucksch <linux.news@bucksch.org>
Subject: Re: md dropping disks too early
Date: Wed, 17 Apr 2013 12:57:08 +0200
Message-ID: <516E8004.8020103@bucksch.org>
References: <15345091.8.1366130671716.JavaMail.root@zimbra> <516DE1D1.1050704@bucksch.org> <alpine.DEB.2.00.1304170958500.23668@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1304170958500.23668@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mikael Abrahamsson wrote, On 17.04.2013 10:00:
> Yes it does, but you need to do frequent scrubbing to reduce the risk 
> of hitting this when you actually need it, ie after complete drive 
> failure.

No, it's not "me" who needs to do that. The software needs to be set up 
by default to do that, be it the kernel or some userland cron job from 
the distro (advantage of latter: configurable). Apparently, Ubuntu 10.04 
didn't do that.
Please stop blaming users, start blaming the software, and fix it.

> It's the combination of drive failure and other drive having read 
> errors that RAID6 protects against. At least that's my primary use for 
> it. 

But a single read error is no reason to send the whole array to the 
trash. RAID6 is merely a workaround here.

With joy, I read that this problem was described, recognized and 
intended to be fixed by the developers:
http://neil.brown.name/blog/20110216044002#1 "Bad Block Log"
Unfortunately, that doesn't seem to be done, as I was running into 
exactly that problem he describes. I hope somebody will fix that, 
because he eloquently describes how the RAID achieves the opposite of 
what it's intended to do.

Ben
