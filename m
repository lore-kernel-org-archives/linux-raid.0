From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Tue, 22 Feb 2011 07:38:53 -0600
Message-ID: <4D63BC6D.8010209@hardwarefreak.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se> <4D5EFDD6.1020504@hardwarefreak.com> <Pine.GSO.4.64.1102211116030.7398@montezuma.acc.umu.se> <4D62DE55.8040705@hardwarefreak.com> <ijvtqg$pke$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ijvtqg$pke$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Brown put forth on 2/22/2011 2:57 AM:
> On 21/02/2011 22:51, Stan Hoeppner wrote:

>> RAID5/6 have decent single streaming read performance, but sub optimal
>> random read, less than sub optimal streaming write, and abysmal random
>> write performance.  They exhibit poor random read performance with high
>> client counts when compared to RAID0 or RAID10.  Additionally, with an
>> analysis "cluster" designed for overall high utilization (no idle
>> nodes), one node will be uploading data sets while others are doing
>> analysis.  Thus you end up with a mixed simultaneous random read and
>> streaming write workload on the server.  RAID10 will give many times the
>> throughput in this case compared to RAID5/6, which will bog down rapidly
>> under such a workload.
>>
> 
> I'm a little confused here.  It's easy to see why RAID5/6 have very poor
> random write performance - you need at least two reads and two writes
> for a single write access.  It's also easy to see that streaming reads
> will be good, as you can read from most of the disks in parallel.
> 
> However, I can't see that streaming writes would be so bad - you have to
> write slightly more than for a RAID0 write, since you have the parity
> data too, but the parity is calculated in advance without the need of
> any reads, and all the writes are in parallel.  So you get the streamed
> write performance of n-[12] disks.  Contrast this with RAID10 where you
> have to write out all data twice - you get the performance of n/2 disks.
> 
> I also cannot see why random reads would be bad - I would expect that to
> be of similar speed to a RAID0 setup.  The only exception would be if
> you've got atime enabled, and each random read was also causing a small
> write - then it would be terrible.
> 
> Or am I missing something here?

I misspoke.  What I meant to say is RAID5/6 have decent streaming and
random read performance, less than optimal *degraded* streaming and
random read performance.  The reason for this is that with one drive
down, each stripe for which that dead drive contained data and not
parity the stripe must be reconstructed with a parity calculation when read.

This is another huge advantage RAID 10 has over the parity RAIDs:  zero
performance loss while degraded.  The other two big ones are vastly
lower rebuild times and still very good performance during a rebuild
operation as only two drives in the array take an extra hit from the
rebuild: the survivor of the mirror pair and the spare being written.

-- 
Stan
