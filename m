From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: AWFUL reshape speed with raid5.
Date: Mon, 28 Jul 2008 14:17:06 -0500
Message-ID: <488E1B32.6010002@gmail.com>
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

I *think* that internal md io is not being shown.

I know I can tell an array to check itself, and have mdstat indicate a speed of 
35MB/second and vmstat indicates no IO  was happening.   The same happens when 
an array is rebuilding, vmstat indicates no IO.   If you do IO to the md device 
from outside it does show that.   And in both cases visually checking the 
confirms that quite a lot appears to be going on.

                               Roger
