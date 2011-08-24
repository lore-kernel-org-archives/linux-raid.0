From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Raid 5 to Raid 1 (half of the data not required)
Date: Wed, 24 Aug 2011 10:21:32 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1108241018180.4709@uplift.swm.pp.se>
References: <BAY148-W51F7F3A42E515F76BB76EFEF2E0@phx.gbl> <alpine.DEB.2.00.1108240851190.6833@unicorn.drogon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1108240851190.6833@unicorn.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 24 Aug 2011, Gordon Henderson wrote:

> This isn't as "glamorous" as Neils method involving lots of mdadm 
> commands, shrinks and grows, but sometimes it's good to keep things at a 
> simpler level?

Another way would be to add the new raid1 with missing drive to the lv, 
and pvmove all extents off of the existing raid5 md pv, then vgreduce away 
from it, stop the raid5, zero-superblock, and add one drive to add 
redundancy for the raid1.

But that has little to do with linux raid, and all to do with LVM. It also 
means you can do everything online since pvmove doesn't require to offline 
anything.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
