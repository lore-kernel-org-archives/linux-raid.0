From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: AWFUL reshape speed with raid5.
Date: Wed, 30 Jul 2008 13:24:25 -0400
Message-ID: <4890A3C9.9070409@tmr.com>
References: <cccedfc60807281039y67c27685n161708146d7c2b3d@mail.gmail.com>	 <alpine.DEB.1.10.0807281414020.3288@p34.internal.lan>	 <cccedfc60807281124w6301915bo88b8be45599f4fb3@mail.gmail.com> <cccedfc60807281155u7a6561a7jce3ca46799f46e4@mail.gmail.com> <48909578.9020307@tmr.com> <48909BBD.4030605@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48909BBD.4030605@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

David Greaves wrote:
> Bill Davidsen wrote:
>   
>> vmstat doesn't tell you enough, you need a tool to show per-device and
>> per-partition io, which will give you what you need. I can't put a
>> finger on the one I wrote, but there are others.
>>     
>
> iostat?
>   

dstat seems to do what he wants, the one I wrote produced a file which 
could be used by gnuplot to generate neat graphical output to make 
problems glaringly obvious.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


