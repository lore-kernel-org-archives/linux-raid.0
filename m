From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Raid5 to raid6 reshape or recreate?
Date: Wed, 13 Aug 2014 11:02:03 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1408131100170.7929@uplift.swm.pp.se>
References: <53EAB9F1.5030905@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53EAB9F1.5030905@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 12 Aug 2014, Ram Ramesh wrote:

> 100G). I also took a fresh backup before the reshape and unmounted md0. 
> Would it be faster if I trash the raid5 and create raid6 from scratch 
> instead of reshape? Any guess on how much faster? I typically got 100+M 
> on checkarray cron jobs.  It would fire around 1-2AM and finish by 6-7AM 
> on first Sun. Reshape has been running more than a day and has only 
> about 45% done.

Creating a new array would be almost as fast as checkarray, much faster 
than reshape. Re-shape moves data around where when you create, it just 
writes parity blocks, so it's a lot faster.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
