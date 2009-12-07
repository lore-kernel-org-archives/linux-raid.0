From: Matthieu Patou <mat@matws.net>
Subject: Re: Random IO with md raid
Date: Tue, 08 Dec 2009 01:59:30 +0300
Message-ID: <4B1D88D2.9000001@matws.net>
References: <4B198DBA.5000906@matws.net> <4B1A6C28.20800@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B1A6C28.20800@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/12/2009 17:20, Asdo wrote:
> Matthieu Patou wrote:
>> * 1 raid 1 volume of 2 1TB hard drive
> Are these drives also on the 3ware?
I suppose that you are speaking of the 2 single drives. If so yes they 
are also connected to the 3ware controller, they are not exported as 
jbod but as seperate hard drives.
Are they exported as jbod?
>> * 2 single volume of 1 TB hard drive each
>> ...
>> Does anyone has an any idea ?
>
> Try anticipatory, deadline and noop schedulers on disks (not CFQ)
> Try setting readahead to exactly 4K, or set it to lowest possible value
I tried all the different scheduler both with 4K and with the default 
value and I still have raid1 software that do 1/2 or 1/3 of the raid1 
hardware for random write I/O.
> (I'm not sure what is best), since this is random access...
> Increase stripe_cache_size as high as you can, p
So for raid1 there is no stripe_cache_size so I didn't set it ...
> Let us/me know the results afterwards...

I also made a simple tests with the CFQ scheduler without any other 
tunning but turning of the controller cache and at this moment the 
results of the RAID1 hardware and the RAID1 software are very close.
Looks like linux is not able to use the onboard cache of controller as 
efficiently as the 3ware controller it self at least for random IO.

Any other ideas ?

Matthieu
