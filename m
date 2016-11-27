From: Avi Kivity <avi@scylladb.com>
Subject: Re: raid0 vs. mkfs
Date: Sun, 27 Nov 2016 19:25:18 +0200
Message-ID: <14c4b1d4-2fd3-b97f-934e-414a8d45fb18@scylladb.com>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
 <470ba5d0-e54d-3e5e-c639-4591549b9574@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <470ba5d0-e54d-3e5e-c639-4591549b9574@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/27/2016 07:09 PM, Coly Li wrote:
> On 2016/11/27 下午11:24, Avi Kivity wrote:
>> mkfs /dev/md0 can take a very long time, if /dev/md0 is a very large
>> disk that supports TRIM/DISCARD (erase whichever is inappropriate).
>> That is because mkfs issues a TRIM/DISCARD (erase whichever is
>> inappropriate) for the entire partition. As far as I can tell, md
>> converts the large TRIM/DISCARD (erase whichever is inappropriate) into
>> a large number of TRIM/DISCARD (erase whichever is inappropriate)
>> requests, one per chunk-size worth of disk, and issues them to the RAID
>> components individually.
>>
>>
>> It seems to me that md can convert the large TRIM/DISCARD (erase
>> whichever is inappropriate) request it gets into one TRIM/DISCARD (erase
>> whichever is inappropriate) per RAID component, converting an O(disk
>> size / chunk size) operation into an O(number of RAID components)
>> operation, which is much faster.
>>
>>
>> I observed this with mkfs.xfs on a RAID0 of four 3TB NVMe devices, with
>> the operation taking about a quarter of an hour, continuously pushing
>> half-megabyte TRIM/DISCARD (erase whichever is inappropriate) requests
>> to the disk. Linux 4.1.12.
> It might be possible to improve a bit for DISCARD performance, by your
> suggestion. The implementation might be tricky, but it is worthy to try.
>
> Indeed, it is not only for DISCARD, for read or write, it might be
> helpful for better performance as well. We can check the bio size, if,
> 	bio_sectors(bio)/conf->nr_strip_zones >= SOMETHRESHOLD
> it means on each underlying device, we have more then SOMETHRESHOLD
> continuous chunks to issue, and they can be merged into a larger bio.

It's true that this does not strictly apply to TRIM/DISCARD (erase 
whichever is inappropriate), but to see any gain for READ/WRITE, you 
need a request that is larger than (chunk size) * (raid elements), which 
is unlikely for reasonable values of those parameters.  But a common 
implementation can of course work for multiple request types.

> IMHO it's interesting, good suggestion!

Looking forward to seeing an implementation!

>
> Coly
>

