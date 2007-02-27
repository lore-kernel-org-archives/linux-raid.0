From: berk walker <berk@panix.com>
Subject: Re: Linux Software RAID a bit of a weakness?
Date: Mon, 26 Feb 2007 23:10:08 -0500
Message-ID: <45E3AF20.7030303@panix.com>
References: <1172258378.21648.51.camel@cowie> <45DF46B7.3040707@maine.edu>	 <1172406243.3765.29.camel@cowie> <45E1E051.1020908@sauce.co.nz> <72dbd3150702260856p5053d028je85cacffb15a5536@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3150702260856p5053d028je85cacffb15a5536@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: Richard Scobie <richard@sauce.co.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



David Rees wrote:
> On 2/25/07, Richard Scobie <richard@sauce.co.nz> wrote:
>> Colin Simpson wrote:
>> > They therefore do not have the "check" option in the kernel. Is there
>> > anything else I can do? Would forcing a resync achieve the same result
>> > (or is that down right dangerous as the array is not considered
>> > consistent for a while). Any thoughts apart from my one being to 
>> upgrade
>> > them to RH5 when that appears with a probably 2.6.18 kernel (which 
>> will
>> > presumably have "check")? Any thoughts?
>>
>> You could configure smartd to do regular long selftests, which would
>> notify you on failures and allow you to take the drive offline and dd,
>> replace etc.
>
> So what do you do when your drives in your array don't support SMART
> self tests for some reason?
>
> The best solution I have thought of so far is to do a `dd if=/dev/mdX
> of=/dev/null` periodically, but this isn't as nice as running a check
> in the later kernels as it's not guaranteed to read blocks from all
> disks. I guess you could instead do the same thing but with the
> underlying disks instead of the raid device, then make sure you watch
> the logs for disk read errors.
>
> -Dave
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

> Doing a dd to each drive always seemed to work for me
> .

b-

