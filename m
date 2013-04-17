From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: md dropping disks too early (was: Use RAID-6!)
Date: Wed, 17 Apr 2013 10:00:19 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1304170958500.23668@uplift.swm.pp.se>
References: <15345091.8.1366130671716.JavaMail.root@zimbra> <516DE1D1.1050704@bucksch.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516DE1D1.1050704@bucksch.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Bucksch <linux.news@bucksch.org>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 17 Apr 2013, Ben Bucksch wrote:

> I am also concerned about 2) bit errors and silently broken sectors, and 
> want my RAID to detect and fix those. I am not sure that Linux md does 
> that.

Yes it does, but you need to do frequent scrubbing to reduce the risk of 
hitting this when you actually need it, ie after complete drive failure.

> Given that this RAID array is for my personal use, and the amount of 
> disk slots in a machine is limited, and drives need 24/7 power, too, a 
> RAID5 is the right choice for me, given the above situation.

It's the combination of drive failure and other drive having read errors 
that RAID6 protects against. At least that's my primary use for it.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
