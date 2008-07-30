From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: AWFUL reshape speed with raid5.
Date: Wed, 30 Jul 2008 12:23:20 -0400
Message-ID: <48909578.9020307@tmr.com>
References: <cccedfc60807281039y67c27685n161708146d7c2b3d@mail.gmail.com>	 <alpine.DEB.1.10.0807281414020.3288@p34.internal.lan>	 <cccedfc60807281124w6301915bo88b8be45599f4fb3@mail.gmail.com> <cccedfc60807281155u7a6561a7jce3ca46799f46e4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60807281155u7a6561a7jce3ca46799f46e4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jon Nelson wrote:
> 1. metadata version matters. Why?
> 2. VERY LITTLE I/O takes place (between 0 and 100KB/s, typically no
> I/O at all) according to vmstat. Why? If it takes 1m34s to "grow" the
> array, but no I/O is taking place, then what is actually taking so
> long?
> 3. I removed the bitmap for these tests. Having a bitmap meant that
> the overall speed was REALLY HORRIBLE.
>
> The results:
>
> metadata: time taken
>
> 0.9: 27s
> 1.0: 27s
> 1.1: 37s
> 1.2: 1m34s
>
> Questions (repeated):
>
> 1. Why does the metadata version matter so much?
>   

I have no idea.

> 2. If no I/O is taking place, why does it take so long? [ NOTE: I/O
> must be taking place but why doesn't vmstat show it? ]
>   

vmstat doesn't tell you enough, you need a tool to show per-device and 
per-partition io, which will give you what you need. I can't put a 
finger on the one I wrote, but there are others.


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


