From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid 10f2 vs 1 on 2 drives
Date: Sat, 26 May 2012 19:41:55 -0400
Message-ID: <4FC16A43.1020507@tmr.com>
References: <20120522193340.GM27769@electro-mechanical.com> <4FBC14DC.8070007@hesbynett.no> <20120523112545.GN27769@electro-mechanical.com> <4FBFD78D.1010503@tmr.com> <4FC0FFAA.1020009@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FC0FFAA.1020009@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Linux RAID <linux-raid@vger.kernel.org>, William Thompson <wt@electro-mechanical.com>
List-Id: linux-raid.ids

David Brown wrote:
> On 25/05/12 21:03, Bill Davidsen wrote:
>> William Thompson wrote:
>>> On Wed, May 23, 2012 at 12:36:12AM +0200, David Brown wrote:
>>>> On 22/05/12 21:33, William Thompson wrote:
>>>>> I understand that raid 10 f2 is slower on writes due to the location
>>>>> of the
>>>>> 2nd copy. My question is, if lots of writes are performed, could this
>>>>> layout wearout the drives quicker than raid 1?
>>>>
>>>> No, wear is not going to be significantly different.
>>>>
>>>> You didn't say whether you are talking about hard disks (where
>>>
>>> Sorry about that (Chief). Yes, I was refering to hard drives.
>>>
>>>> location makes a difference, but "wear" on the drive motor is
>>>> insignificant to the disk's expected lifetime), or flash disks
>>>
>>> I was thinking about how much more head movement there would be to
>>> write the
>>> 2nd copy of the data.
>>>
>> There _is_ no extra head motion. The location of consecutive blocks is
>> different on each drive, but as I read the mapping function the distance
>> between blocks on the same drive will be about the same, so amount of
>> head motion (both number and distance) is the same on each drive, but
>> the location of that motion is not the same.
>>
>> One drive may be seeking at the outer edge of the platter while another
>> seeks near the spindle, but there's the same amount of seeking on each.
>>
>>
>
> That's not the case for "far" layout.  When you write a block, it there will 
> be two copies - one in the first half of one disk (say, disk 1), and the other 
> in the second half of the other disk (disk 2).  The next sequential block will 
> be written to the first half of disk 2, and the second half of disk 1 - 
> exactly half a disk away from the first block. And no matter where the disk 
> head ends up after the write, raid10,far will always read from the outer half 
> of the disk since it is significantly faster.  (For SSDs it doesn't matter, 
> but then neither does head positioning.)
>
He was talking about head motion on write, or I was at any write. Although the 
writes go to different parts of the platter, they are platters on different 
drives. So for any large sequential write, the head motion is the same (in 
distance), but occurs at the outside of one platter and the inside of the other. 
We're saying the same thing. A the read will not always happen at the outer edge 
unless both drives are idle, otherwise if one is busy the other will be used. To 
do otherwise would limit the performance when many reads to adjacent sectors 
take place.

> Write merging, combining, re-ordering, etc., will minimise this effect, as 
> will write caches.  But there is no doubt that raid10,far sacrifices write 
> speed a little in order to get the fastest possible read speeds. For most 
> use-cases, with more reading than writing, this results in the best overall 
> speed.
>


-- 
Bill Davidsen<davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010



