From: Chris Worley <worleys@gmail.com>
Subject: Re: Shouldn't the /sys/block/md*/queue/max_*sectors_kb be set to the
 chunk size?
Date: Thu, 18 May 2017 11:33:45 -1000
Message-ID: <CANWz5fhwLVxirvQ7j5Re66hD0uRsh4QpOapkKVM0+MK+pSXu+Q@mail.gmail.com>
References: <CANWz5fiQ1O5k43QKfurd84nwdeCZL0-EOD6p_2vp+wHaJmsVEw@mail.gmail.com>
 <20170518185023.3z5byy5uqpfb46w6@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170518185023.3z5byy5uqpfb46w6@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, May 18, 2017 at 8:50 AM, Shaohua Li <shli@kernel.org> wrote:
> On Thu, May 18, 2017 at 05:52:28AM -1000, Chris Worley wrote:
>> I'm obviously missing something...
>>
>> If chunk size is a stride, why is the
>> /sys/block/md*/queue/max_*sectors_kb being inherited from one of the
>> underlying devices rather than being set to the chunk size or the
>> drive multiple of their max sector settings?
>
> We set it to chunk size unless underlying disks have a smaller max_*sectors_kb.
> Underlying disks usually have much bigger max_sectors than chunk size.

And if not the case, then, for maximum efficiency/performance, the
chunk size should be lowered to the max sector size for the device...
or maybe the [devices max sector size] / [number of devices]?

>
>> Or, in other words, would the chunk size setting have a natural upper
>> bound/limit of one of the drives max_sectors, or the sum of all of the
>> constituent drives max sectors?
>
> I don't know such upper bound and don't think it matters. The max_sectors
> basically is the size we split the bio to fit for one underlying disk.

I realize that, but am thinking that, if the chunk size was larger,
you would want (for performance/efficiency) the max sector size for
the MD device to be larger than the underlying device too, which the
MD driver would then break-up into the underlying devices max sector
size?  Or, is it more efficient to have the OS break-up the bios into
the smaller sizes for the driver?

For example, if there are four devices, each with 128KB max sectors,
and the chunk size is 512K, wouldn't MD want the bio to show the users
complete 512K write in a single bio for MD to dole-out to the
different devices, rather than receiving four different bio's?

If you say it doesn't matter... then great, I'll move on... it just
seems to me like it would matter for performance/efficiency.

Thanks,

Chris
>
> Thanks,
> Shaohua
