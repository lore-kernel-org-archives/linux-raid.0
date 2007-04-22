From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: major performance drop on raid5 due to context switches caused
 by small max_hw_sectors [partially resolved]
Date: Sun, 22 Apr 2007 12:01:21 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0704221200030.537@filesrv1.baby-dragons.com>
References: <200704202306.14880.dap@mail.index.hu> <200704221638.11837.dap@mail.index.hu>
 <Pine.LNX.4.64.0704221047570.21579@p34.internal.lan> <200704221709.56271.dap@mail.index.hu>
 <Pine.LNX.4.64.0704221151250.23473@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704221151250.23473@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Pallai Roland <dap@mail.index.hu>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Justin ,

On Sun, 22 Apr 2007, Justin Piszcz wrote:
> On Sun, 22 Apr 2007, Pallai Roland wrote:
>> On Sunday 22 April 2007 16:48:11 Justin Piszcz wrote:
>>> Have you also optimized your stripe cache for writes?
>> Not yet. Is it worth it?
>> --
>> d
> Yes, it is-- well, if write speed is important to you that is?
> Each of these write tests are averaged over three runs:
>
> 128k_stripe: 69.2MB/s
> 256k_stripe: 105.3MB/s
> 512k_stripe: 142.0MB/s
> 1024k_stripe: 144.6MB/s
> 2048k_stripe: 208.3MB/s
> 4096k_stripe: 223.6MB/s
> 8192k_stripe: 226.0MB/s
> 16384k_stripe: 215.0MB/s
>
> What is your /sys/block/md[0-9]/md/stripe_cache_size?
 	On which filesystem type ?  ie: ext3,xfs,rieser?,...
 		Tia ,  JimL
-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
