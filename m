From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: Re: [neilb@suse.de: Re: MD request counter broken on 4.0-rc5 RAID1]
Date: Wed, 1 Apr 2015 15:39:47 +0800
Message-ID: <551BA0C3.7090004@cn.fujitsu.com>
References: <20150325173346.GF8519@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150325173346.GF8519@hostway.ca>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: Simon Kirby <sim@hostway.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,
One question about md io stats account:
I find that we just accounting disk_stats.sectors[rw] and disk_stats.ios[rw] at
md_make_request, but I did not find accounting disk_stats.ticks[rw], do not we
need it? or I missed something?

Regards,
Gu

On 03/26/2015 01:33 AM, Simon Kirby wrote:

> Hello!
> 
> Please note the following.
> 
> Thanks,
> 
> Simon-
> 
> ----- Forwarded message from NeilBrown <neilb@suse.de> -----
> 
> Date: Wed, 25 Mar 2015 11:46:18 +1100
> From: NeilBrown <neilb@suse.de>
> To: Simon Kirby <sim@hostway.ca>
> Cc: linux-raid@vger.kernel.org
> Subject: Re: MD request counter broken on 4.0-rc5 RAID1
> X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
> 
> On Tue, 24 Mar 2015 17:04:03 -0700 Simon Kirby <sim@hostway.ca> wrote:
> 
>> Hello :)
>>
>> I'm seeing "iostat -x -k 1" print this after a RAID1 rebuild on 4.0-rc5.
>> It's not abnormal other than it's 3-disk, with one being SSD (sdc) and
>> the other two being write-mostly:
>>
>> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
>> sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
>> sdb               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
>> sdc               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
>> md0               0.00     0.00    0.00    0.00     0.00     0.00     0.00   345.00    0.00    0.00    0.00   0.00 100.00
>> md2               0.00     0.00    0.00    0.00     0.00     0.00     0.00 58779.00    0.00    0.00    0.00   0.00 100.00
>> md1               0.00     0.00    0.00    0.00     0.00     0.00     0.00    12.00    0.00    0.00    0.00   0.00 100.00
>>
>> This was working on 3.18. Shall I bisect, or is it obvious?
> 
> Almost certainly 18c0b223cf9901727ef3b02da6711ac930b4e5d4 in 3.19.
> 
> It adds 'part_inc_in_flight' and never decrements it.
> 
> Complain to the author.
> 
> Thanks,
> NeilBrown
> 
>>
>> It seems to just be leaking as the counters were going up gradually while
>> it was rebuilding.
>>
>> Personalities : [linear] [raid0] [raid1] [raid10]
>> md1 : active raid1 sdb2[1](W) sda2[0](W) sdc2[2]
>>       530048 blocks [3/3] [UUU]
>>
>> md2 : active raid1 sdb3[0](W) sdc3[2] sda3[1](W)
>>       153613440 blocks [3/3] [UUU]
>>
>> md0 : active raid1 sdb1[0](W) sdc1[2] sda1[1](W)
>>       2104384 blocks [3/3] [UUU]
>>
>> unused devices: <none>
>>
>> Simo-
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> ----- End forwarded message -----
> .
> 


