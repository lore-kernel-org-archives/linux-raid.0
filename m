From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Software RAID 6 initial sync very slow
Date: Tue, 03 Jun 2008 15:47:52 -0400
Message-ID: <48459FE8.6080604@tmr.com>
References: <8CA91F18992AC9E-1724-EAF@webmail-ne13.sysops.aol.com> <4843E8FD.8000601@tmr.com> <8CA92FCA38FE330-1A8-162F@webmail-nb02.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8CA92FCA38FE330-1A8-162F@webmail-nb02.sysops.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

thomas62186218@aol.com wrote:
> Thank you Bill and Richard for your responses.
>
> In sync_speed_max, I had already set it to 250000 (250MB/sec). For 
> sync_speed_min, I have 249900 set. My rational behind doing this was 
> to "force" it to go as fast as it can. Any problem with this?
>
Other than possibly totally killing your response if you use some other 
raid levels, no. I usually set the min speed to something I can tolerate 
in the background, and still have a useful system.

> However, adjusting stripe_cache_size did improve performance. It was 
> 256 at first, and my sync rate was 28MB/sec. When I increased it to 
> 4096, my sync rate jumped to 38MB/sec. Then I increased it to 16384, 
> and it jumped again to 40MB/sec. Increasing stripe_cache_size above 
> that did not seem to have any effect.
>
You definitely hit diminishing returns on cache_size. There are people 
on this list who swear by 32k or 64k, but even when I can spare the 
memory I don't see any benefit to looking for that last tiny gain.

> My question then is, how do I set the stripe_cache_size at the time of 
> md creation? I would rather set it then, as opposed to having to echo 
> stripe_cache_size variable with a new setting. In other words, where 
> is this default value of 256 coming from? Thanks all!!

rc.local is my usual choice for things like that, and if you want to 
really spend a lot of time chasing performance, be aware that you can 
use blockdev to play with readahead on the devince and filesystem, and 
generally spend days trying to create a test which will show benefits in 
a statistically valid manner. Add chunk size and knock yourself out. I 
am convinced that the answer to better performance is "it depends," so 
just boosting readahead and cache_size a bit usually gets 80-90% of 
anything you can get with tons of playing.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


