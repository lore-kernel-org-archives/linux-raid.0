From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid 10f2 vs 1 on 2 drives
Date: Fri, 25 May 2012 15:03:41 -0400
Message-ID: <4FBFD78D.1010503@tmr.com>
References: <20120522193340.GM27769@electro-mechanical.com> <4FBC14DC.8070007@hesbynett.no> <20120523112545.GN27769@electro-mechanical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120523112545.GN27769@electro-mechanical.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: William Thompson <wt@electro-mechanical.com>
List-Id: linux-raid.ids

William Thompson wrote:
> On Wed, May 23, 2012 at 12:36:12AM +0200, David Brown wrote:
>> On 22/05/12 21:33, William Thompson wrote:
>>> I understand that raid 10 f2 is slower on writes due to the location of the
>>> 2nd copy.  My question is, if lots of writes are performed, could this
>>> layout wearout the drives quicker than raid 1?
>>
>> No, wear is not going to be significantly different.
>>
>> You didn't say whether you are talking about hard disks (where
>
> Sorry about that (Chief).  Yes, I was refering to hard drives.
>
>> location makes a difference, but "wear" on the drive motor is
>> insignificant to the disk's expected lifetime), or flash disks
>
> I was thinking about how much more head movement there would be to write the
> 2nd copy of the data.
>
There _is_ no extra head motion. The location of consecutive blocks is different 
on each drive, but as I read the mapping function the distance between blocks on 
the same drive will be about the same, so amount of head motion (both number and 
distance) is the same on each drive, but the location of that motion is not the 
same.

One drive may be seeking at the outer edge of the platter while another seeks 
near the spindle, but there's the same amount of seeking on each.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
