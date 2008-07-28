From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: AWFUL reshape speed with raid5.
Date: Mon, 28 Jul 2008 15:43:32 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0807281543000.3288@p34.internal.lan>
References: <cccedfc60807281039y67c27685n161708146d7c2b3d@mail.gmail.com>  <alpine.DEB.1.10.0807281414020.3288@p34.internal.lan>  <cccedfc60807281124w6301915bo88b8be45599f4fb3@mail.gmail.com> <cccedfc60807281155u7a6561a7jce3ca46799f46e4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60807281155u7a6561a7jce3ca46799f46e4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

There once was a bug in an earlier kernel, in which the min_speed is what 
the rebuild ran at if you had a specific chunk size, have you tried to 
echo 30000 > to min_speed?  Does it increase it to 30mb/s for the rebuild?

On Mon, 28 Jul 2008, Jon Nelson wrote:

> Some more data points, observations, and questions.
>
> For each test, I'd --create the array, drop the caches, --grow, and
> then watch vmstat and also record the time between
>
> kernel: md: resuming resync of md99 from checkpoint.
> and
> kernel: md: md99: resync done.
>
> I found two things:
>
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
> 2. If no I/O is taking place, why does it take so long? [ NOTE: I/O
> must be taking place but why doesn't vmstat show it? ]
>
> -- 
> Jon
>
