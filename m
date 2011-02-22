From: David Brown <david@westcontrol.com>
Subject: Re: high throughput storage server?
Date: Tue, 22 Feb 2011 10:49:18 +0100
Message-ID: <ik00s5$9do$1@dough.gmane.org>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se> <4D5EFDD6.1020504@hardwarefreak.com> <Pine.GSO.4.64.1102211116030.7398@montezuma.acc.umu.se> <4D62DE55.8040705@hardwarefreak.com> <ijvtqg$pke$1@dough.gmane.org> <Pine.GSO.4.64.1102221027330.7398@montezuma.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.64.1102221027330.7398@montezuma.acc.umu.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/02/2011 10:30, Mattias Wadenstein wrote:
> On Tue, 22 Feb 2011, David Brown wrote:
>
>> On 21/02/2011 22:51, Stan Hoeppner wrote:
>>> Mattias Wadenstein put forth on 2/21/2011 4:25 AM:
>>>> On Fri, 18 Feb 2011, Stan Hoeppner wrote:
>>>>
>>>>> Mattias Wadenstein put forth on 2/18/2011 7:49 AM:
>>>>>
>>>>> RAID 5/6 need not apply due the abysmal RMW partial stripe write
>>>>> penalty, unless of course you're doing almost no writes. But in that
>>>>> case, how did the data get there in the first place? :)
>>>
>>>> Actually, that's probably the common case for data analysis load. Lots
>>>> of random reads, but only occasional sequential writes when you add a
>>>> new file/fileset. So raid 5/6 performance-wise works out pretty much as
>>>> a stripe of n-[12] disks.
>>>
>>> RAID5/6 have decent single streaming read performance, but sub optimal
>>> random read, less than sub optimal streaming write, and abysmal random
>>> write performance. They exhibit poor random read performance with high
>>> client counts when compared to RAID0 or RAID10. Additionally, with an
>>> analysis "cluster" designed for overall high utilization (no idle
>>> nodes), one node will be uploading data sets while others are doing
>>> analysis. Thus you end up with a mixed simultaneous random read and
>>> streaming write workload on the server. RAID10 will give many times the
>>> throughput in this case compared to RAID5/6, which will bog down rapidly
>>> under such a workload.
>>>
>>
>> I'm a little confused here. It's easy to see why RAID5/6 have very
>> poor random write performance - you need at least two reads and two
>> writes for a single write access. It's also easy to see that streaming
>> reads will be good, as you can read from most of the disks in parallel.
>>
>> However, I can't see that streaming writes would be so bad - you have
>> to write slightly more than for a RAID0 write, since you have the
>> parity data too, but the parity is calculated in advance without the
>> need of any reads, and all the writes are in parallel. So you get the
>> streamed write performance of n-[12] disks. Contrast this with RAID10
>> where you have to write out all data twice - you get the performance
>> of n/2 disks.
>
> It's fine as long as you have only a few streaming writes, if you go up
> to many streams things might start breaking down.
>

That's always going to be the case when you have a lot of writes at the 
same time.  Perhaps RAID5/6 makes matters a little worse by requiring a 
certain ordering on the writes to ensure consistency (maybe you have to 
write a whole stripe before starting a new stripe?  I don't know how md 
raid balances performance and consistency here).  I think the choice of 
file system is likely to make a bigger impact in such cases.

>> I also cannot see why random reads would be bad - I would expect that
>> to be of similar speed to a RAID0 setup. The only exception would be
>> if you've got atime enabled, and each random read was also causing a
>> small write - then it would be terrible.
>>
>> Or am I missing something here?
>
> The thing I think you are missing is crappy implementations in several
> HW raid controllers. For linux software raid the situation is quite
> sanely as you describe in my experience.
>

Ah, okay.  Thanks!


