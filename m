From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: OT: Tips for good hard drives for a home server
Date: Fri, 14 Nov 2008 00:04:06 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0811132357390.10993@uplift.swm.pp.se>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B299C974A5A@SE-EX008.groupinfra.com> <7d86ddb90811120619vca13676tb0192676ece0cb93@mail.gmail.com> <491CA255.4070402@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <491CA255.4070402@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 13 Nov 2008, Bill Davidsen wrote:

> These are probably a good fit with your budget and reliability needs.

It's important to note the difference between the drives aimed for raid 
use and the ones aimed for non-raid use. This has been said before, but I 
think it's worth saying again, as I was hit by this.

If there is a problem reading a block the raid capable drives will return 
an uncorrectable error very quickly, relying on the raid controller to 
re-calculate parity and re-write the block. A desktop drive will try to 
read the block for several seconds until it fails, and in my case, it 
usually succeeded in reading it, meaning my reads from the raid were 
stalling.

So, if you want your raid to work well, get the enterprise class drives, 
they are rated for long term use, and more importantly, they have the 
firmware to play well in a raid environment.

Looking at the md code in linux, would it be possible to do some work 
around here in that if a drive read operationstalls, let's try to read 
from the other drives and then re-write the block on the drive that 
stalled?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
