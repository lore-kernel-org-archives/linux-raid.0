From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.20: stripe_cache_size goes boom with 32mb
Date: Fri, 23 Feb 2007 07:42:26 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0702230741540.3781@p34.internal.lan>
References: <Pine.LNX.4.64.0702230640430.3781@p34.internal.lan>
 <1172234460.4419.7.camel@merlin>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1172234460.4419.7.camel@merlin>
Sender: linux-raid-owner@vger.kernel.org
To: Jason Rainforest <l3mming@iinet.net.au>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have 2GB On this machine.  For me, 8192 seems to be the sweet spot, I 
will probably keep it at 8mb.

On Fri, 23 Feb 2007, Jason Rainforest wrote:

> Hi Justin,
>
> I'm not a RAID or kernel developer, but .. do you have enough RAM to
> support a 32mb stripe_cache_size?! Here on my 7*250Gb SW RAID5 array,
> decreasing a stripe_cache_size of 8192 to 4096 frees up no less than
> 120mb of RAM. Using that as a calculation tool, a 32mb stripe_cache_size
> would require approximately 960mb of RAM! My RAID box only has 1Gb of
> RAM, so I'm not game to test such a thing. Others on these lists would
> definitely have a good idea on what's happening :-)
>
> Cheers,
> Jason
>
>
> On Fri, 2007-02-23 at 06:41 -0500, Justin Piszcz wrote:
>> Each of these are averaged over three runs with 6 SATA disks in a SW RAID
>> 5 configuration:
>>
>> (dd if=/dev/zero of=file_1 bs=1M count=2000)
>>
>> 128k_stripe: 69.2MB/s
>> 256k_stripe: 105.3MB/s
>> 512k_stripe: 142.0MB/s
>> 1024k_stripe: 144.6MB/s
>> 2048k_stripe: 208.3MB/s
>> 4096k_stripe: 223.6MB/s
>> 8192k_stripe: 226.0MB/s
>> 16384k_stripe: 215.0MB/s
>>
>> When I tried a 32768k stripe, this happened:
>> p34:~# echo 32768 > /sys/block/md4/md/stripe_cache_size
>> Connection to p34 closed
>>
>> I was able to Alt-SysRQ+b but I could not access the console/X/etc, it
>> appeared to be frozen.
>>
>> FYI.
>>
>> Justin.
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
