From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Mon, 21 Feb 2011 15:51:17 -0600
Message-ID: <4D62DE55.8040705@hardwarefreak.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se> <4D5EFDD6.1020504@hardwarefreak.com> <Pine.GSO.4.64.1102211116030.7398@montezuma.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.64.1102211116030.7398@montezuma.acc.umu.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mattias Wadenstein <maswan@acc.umu.se>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mattias Wadenstein put forth on 2/21/2011 4:25 AM:
> On Fri, 18 Feb 2011, Stan Hoeppner wrote:
> 
>> Mattias Wadenstein put forth on 2/18/2011 7:49 AM:
>>
>>> Here you would either maintain a large list of nfs mounts for the read
>>> load, or start looking at a distributed filesystem. Sticking them all
>>> into one big fileserver is easier on the administration part, but
>>> quickly gets really expensive when you look to put multiple 10GE
>>> interfaces on it.
>>
>> This really depends on one's definition of "really expensive".  Taking
>> the total cost of such a system/infrastructure into account, these two
>> Intel dual port 10 GbE NICs seem rather cheap at $650-$750 USD:
>>
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16833106037
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16833106075
>>
>> 20 Gb/s (40 both ways) raw/peak throughput at this price seems like a
>> bargain to me (plus the switch module cost obviously, if required,
>> usually not for RJ-45 or CX4, thus my motivation for mentioning these).
>>
>> The storage infrastructure on the back end required to keep these pipes
>> full will be the "really expensive" piece.
> 
> Exactly my point, a storage server that can sustain 20-200MB/s is rather
> cheap, but one that can sustain 2GB/s is really expensive. Possibly to
> the point where 10-100 smaller file servers are much cheaper. The worst
> case here is very small random reads, and then you're screwed cost-wise
> whatever you choose, if you want to get the 2GB/s number.

"Screwed" may be a bit harsh, but I agree that one big fast storage
server will usually cost more than many smaller ones with equal
aggregate performance.  But looking at this from a TCO standpoint, the
administrative burden is higher for the many small case, and file layout
can be problematic, specifically in the case where all analysis nodes
need to share a file or group of files.  This can create bottlenecks at
individual storage servers.  Thus, acquisition cost must be weighed
against operational costs.  If any of the data is persistent, backing up
a single server is straight forward.  Backing up multiple servers, and
restoring them if necessary, is more complicated.

>> RAID 5/6 need not apply due the abysmal RMW partial stripe write
>> penalty, unless of course you're doing almost no writes.  But in that
>> case, how did the data get there in the first place? :)

> Actually, that's probably the common case for data analysis load. Lots
> of random reads, but only occasional sequential writes when you add a
> new file/fileset. So raid 5/6 performance-wise works out pretty much as
> a stripe of n-[12] disks.

RAID5/6 have decent single streaming read performance, but sub optimal
random read, less than sub optimal streaming write, and abysmal random
write performance.  They exhibit poor random read performance with high
client counts when compared to RAID0 or RAID10.  Additionally, with an
analysis "cluster" designed for overall high utilization (no idle
nodes), one node will be uploading data sets while others are doing
analysis.  Thus you end up with a mixed simultaneous random read and
streaming write workload on the server.  RAID10 will give many times the
throughput in this case compared to RAID5/6, which will bog down rapidly
under such a workload.

-- 
Stan
