From: David Brown <david.brown@hesbynett.no>
Subject: Re: [patch 0/4 v2] optimize raid1 read balance for SSD
Date: Thu, 28 Jun 2012 08:31:31 +0200
Message-ID: <4FEBFA43.6060907@hesbynett.no>
References: <20120613090922.971820942@kernel.org>	<20120628110616.79d4481e@notabene.brown>	<20120628032901.GA21233@kernel.org> <20120628134004.729fb77f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120628134004.729fb77f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

On 28/06/12 05:40, NeilBrown wrote:
> On Thu, 28 Jun 2012 11:29:01 +0800 Shaohua Li<shli@kernel.org>  wrote:
>
>> On Thu, Jun 28, 2012 at 11:06:16AM +1000, NeilBrown wrote:
>>> On Wed, 13 Jun 2012 17:09:22 +0800 Shaohua Li<shli@kernel.org>  wrote:
<snip>
>>> General balancing is a little harder as the decision is made in the context
>>> of all active devices.  In particular we need to know how to choose between a
>>> seek-penalty device and a no-seek-penalty device, if they both have requests
>>> queued to them and the seek-penalty device is a long way from the target.
>>>
>>> Maybe:
>>>   - if the last request to some device is within optimal-io-size of this
>>>     requests, then send this request to that device.
>>>   - if either of two possible devices has no seek penalty, choose the one with
>>>     the fewest outstanding requests.
>>>   - if both of two possible devices have a seek-penalty, then choose the
>>>     closest
>>>
>>> I think this will do the same as the current code for 'rotational' devices,
>>> and will be close to what your code does for 'non-rotational' devices.
>>
>> This is close to what I did except for the case of one hard disk and one SSD.
>> Talking about heterogeneous arrary, I assume people only do it with two
>> different hard disks or two different ssd. Will people really mix hard disk and
>> SSD? A hard disk can only drive 600 IOPS while a lowend SATA SSD can drive 20k
>> ~ 40k IOPS. Plusing 600 to 20k doesn't significantly change IOPS.
>
> I'm fairly sure people will try it, even if it doesn't make sense. :-)
>
> It possibly would make sense if the slower device was marked "write-mostly",
> but that disables read-balance, so what we do with read balance might be
> irrelevant.

I would imagine that an SSD paired with an HD (or a partition on an HD) 
in RAID1 would be very common for small setups - at least until the 
current experimental flash cache systems solidify and mature.  You get 
the speed of the SSD, and the safety of RAID1 without the cost of two 
SSDs.  It is normal today to use write-mostly on the HD - but I'd guess 
a fair number of users don't think to do that.  And with good balancing 
from these patches, there is no need - and you can get the best from 
both devices.  SSD's are much faster than HD's when there is seeking 
involved - but for streamed accesses the difference is smaller, and it's 
good to have both devices available for reads.

>
> I don't want to assume devices have different speeds unless explicitly told
> so, and the "rotational" flag doesn't clearly imply anything about the speed
> of the device, only about seek latency.  So e.g. I wouldn't want to always
> assume that a non-rotational device were faster than a rotational device,
> even though that may be the case in lots of situations.
>
> I'd be less concerned about heterogeneous arrays with RAID10 as it makes less
> sense there.  But I certainly want to at least acknowledge the possibility
> for RAID1.
>
> thanks,
> NeilBrown
>

