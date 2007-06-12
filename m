From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: below 10MB/s write on raid5
Date: Tue, 12 Jun 2007 13:14:55 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706121314440.12460@p34.internal.lan>
References: <200706111446.55813.Dexter.Filmore@gmx.de> <466ED4F6.5060204@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <466ED4F6.5060204@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Dexter Filmore <Dexter.Filmore@gmx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 12 Jun 2007, Bill Davidsen wrote:

> Dexter Filmore wrote:
>> I recently upgraded my file server, yet I'm still unsatisfied with the 
>> write speed.
>> Machine now is a Athlon64 3400+ (Socket 754) equipped with 1GB of RAM.
>> The four RAID disks are attached to the board's onbaord sATA controller 
>> (Sil3114 attached via PCI)
>> Kernel is 2.6.21.1, custom on Slackware 11.0.
>> RAID is on four Samsung SpinPoint disks, has LVM, 3 volumes atop of each 
>> XFS.
>> 
>> The machine does some other work, too, but still I would have suspected to 
>> get into the 20-30MB/s area. Too much asked for?
>> 
>
> Increase your stripe cache size in /sys/block/mdX/md/stripe_cache_size. If 
> you have a chunk size of 256, try setting the cache size to 8192 and see if 
> your write performance ends up ~100MB/s or so.
>
>  echo 8192 > /sys/block/mdX/md/stripe_cache_size
>
> Where "X" is your array name, of course.
>
> Note, larger values will help more, but it's definitely diminishing returns, 
> so don't get carried away. There was a report of problems with size > 32768, 
> I don't remember the details, so I would avoid that as well.
>
> -- 
> bill davidsen <davidsen@tmr.com>
> CTO TMR Associates, Inc
> Doing interesting things with small computers since 1979
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I was the one who tried > 32768 it crashed the machine (on an older box).

Justin.
