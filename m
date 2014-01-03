From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Why 4k native drives haven't arrived
Date: Fri, 3 Jan 2014 12:23:34 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1401031220330.20074@uplift.swm.pp.se>
References: <52C61807.6050906@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C61807.6050906@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 2 Jan 2014, Stan Hoeppner wrote:

> The first units of native 4K drives will be, or possibly already have 
> been, to OEMs who exercise control over which systems and disk arrays in 
> which the drives will be installed.  This prevents such a problem in the 
> enterprise space, as purchasers typically rely on their vendors to do 
> compatibility matching.  Enterprise OEMs have long maintained such 
> product compatibility databases.

I fully agree with your analysis. I am sure there are lots of BIOS, 
controllers etc that have lots of bugs with 4k native drives, so even if 
the OS and tools supports it, there will be other issues.

On the other hand, if the 512 byte sectors are properly aligned so that 
the 4k page size always are written as 8 contigous sectors, then what does 
native 4k sector really give us? Lower IRQ rates? This is probably an 
additional reason why they haven't arrived. It's a complete ecosystem and 
taking the first step has huge downsides.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
