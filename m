From: David Brown <david@westcontrol.com>
Subject: Re: high throughput storage server?
Date: Tue, 22 Feb 2011 15:18:21 +0100
Message-ID: <ik0gkm$nn$1@dough.gmane.org>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se> <4D5EFDD6.1020504@hardwarefreak.com> <Pine.GSO.4.64.1102211116030.7398@montezuma.acc.umu.se> <4D62DE55.8040705@hardwarefreak.com> <ijvtqg$pke$1@dough.gmane.org> <4D63BC6D.8010209@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D63BC6D.8010209@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/02/2011 14:38, Stan Hoeppner wrote:
> David Brown put forth on 2/22/2011 2:57 AM:
>> On 21/02/2011 22:51, Stan Hoeppner wrote:
>
>>> RAID5/6 have decent single streaming read performance, but sub optimal
>>> random read, less than sub optimal streaming write, and abysmal random
>>> write performance.  They exhibit poor random read performance with high
>>> client counts when compared to RAID0 or RAID10.  Additionally, with an
>>> analysis "cluster" designed for overall high utilization (no idle
>>> nodes), one node will be uploading data sets while others are doing
>>> analysis.  Thus you end up with a mixed simultaneous random read and
>>> streaming write workload on the server.  RAID10 will give many times the
>>> throughput in this case compared to RAID5/6, which will bog down rapidly
>>> under such a workload.
>>>
>>
>> I'm a little confused here.  It's easy to see why RAID5/6 have very poor
>> random write performance - you need at least two reads and two writes
>> for a single write access.  It's also easy to see that streaming reads
>> will be good, as you can read from most of the disks in parallel.
>>
>> However, I can't see that streaming writes would be so bad - you have to
>> write slightly more than for a RAID0 write, since you have the parity
>> data too, but the parity is calculated in advance without the need of
>> any reads, and all the writes are in parallel.  So you get the streamed
>> write performance of n-[12] disks.  Contrast this with RAID10 where you
>> have to write out all data twice - you get the performance of n/2 disks.
>>
>> I also cannot see why random reads would be bad - I would expect that to
>> be of similar speed to a RAID0 setup.  The only exception would be if
>> you've got atime enabled, and each random read was also causing a small
>> write - then it would be terrible.
>>
>> Or am I missing something here?
>
> I misspoke.  What I meant to say is RAID5/6 have decent streaming and
> random read performance, less than optimal *degraded* streaming and
> random read performance.  The reason for this is that with one drive
> down, each stripe for which that dead drive contained data and not
> parity the stripe must be reconstructed with a parity calculation when read.
>

That makes lots of sense - I was missing the missing word "degraded"!

I don't think the degraded streaming reads will be too bad - after all, 
you are reading the full stripe anyway, and the data reconstruction will 
be fast on a modern cpu.  But random reads will be very bad.  For 
example, if you have 4+1 drives in a RAID5, then one in every 5 random 
reads will be on the dead drive, and will require 4 reads.  That means 
random reads will take 180% of the normal time, or almost half the 
performance.

> This is another huge advantage RAID 10 has over the parity RAIDs:  zero
> performance loss while degraded.  The other two big ones are vastly
> lower rebuild times and still very good performance during a rebuild
> operation as only two drives in the array take an extra hit from the
> rebuild: the survivor of the mirror pair and the spare being written.
>

Yes, this is definitely true - RAID10 is less affected by running 
degraded, and recovering is faster and involves less disk wear.  The 
disadvantage compared to RAID6 is, of course, if the other half of a 
disk pair dies during recovery then your raid is gone - with RAID6 you 
have better worst-case redundancy.

Once md raid has support for bad block lists, hot replace, and non-sync 
lists, then the differences will be far less clear.  If a disk in a RAID 
5/6 set has a few failures (rather than dying completely), then it will 
run as normal except when bad blocks are accessed.  This means for all 
but the few bad blocks, the degraded performance will be full speed. 
And if you use "hot replace" to replace the partially failed drive, the 
rebuild will have almost exactly the same characteristics as RAID10 
rebuilds - apart from the bad blocks, which must be recovered by parity 
calculations, you have a straight disk-to-disk copy.



