From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Raid reconstructing and process hanging in D state
Date: Fri, 16 Oct 2009 05:48:17 -0400 (EDT)
Message-ID: <alpine.DEB.2.00.0910160547220.2841@p34.internal.lan>
References: <Pine.LNX.4.64.0910160703260.2463@praktifix.dwd.de> <alpine.DEB.2.00.0910160436160.2841@p34.internal.lan> <Pine.LNX.4.64.0910160840400.2463@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0910160840400.2463@praktifix.dwd.de>
Sender: linux-raid-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids



On Fri, 16 Oct 2009, Holger Kiehl wrote:

> On Fri, 16 Oct 2009, Justin Piszcz wrote:
>> Hi,
>> 
>> I have the same problem with mdadm/raid-1, if you do not limit the speed in 
>> the speed_limit_min paramter, it will starve the I/O from all other 
>> processes and result in the same problem you are having.
>> 
> But in my case speed_limit_min was set to 1000 and speed_limit_max was 200000
> (ie. the default) and this still caused all process to hang in D-state. Only
> lowering speed_limit_max helped to make the system responsive again.
>
>> But for me I'm not sure about the reconstruction-- this happens for me 
>> during a raid verify/check.
>> 
> This was also the case for me, during a raid verify/check.
>
> Holger
>

Oops,

I meant the max speed has to be capped too.

Example, my old script (Velociraptors did 120MB/s) but anything over 
90MB/s it would start to starve the I/O;


# Set minimum and maximum raid rebuild speed to 30MB/s.
#echo "Setting maximum resync speed to 90 MiB/s..."
#echo 30000 > /sys/block/md0/md/sync_speed_min
#echo 90000 > /sys/block/md0/md/sync_speed_max

This would eat 90MB/s of the 120MB/s but still leave some breathing room.

Justin.
