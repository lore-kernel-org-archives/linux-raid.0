From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Severe slowdown with LVM on RAID, alignment problem?
Date: Sun, 02 Mar 2008 15:14:20 -0500
Message-ID: <47CB0A9C.7030902@tmr.com>
References: <872d9b69db95a1b08319e935595743cc@localhost> <47C7E086.5080203@rabbit.us> <47C9C086.4020805@tmr.com> <84E2E8E9-9E43-497E-9680-CC0377A8BEDF@it-loops.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84E2E8E9-9E43-497E-9680-CC0377A8BEDF@it-loops.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Guntsche <mike@it-loops.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Guntsche wrote:
>
> On Mar 1, 2008, at 21:45, Bill Davidsen wrote:
>
>>> blockdev --setra 65536 <your lv device>
>>>
>>> and run the tests again. You are almost certainly going to get the 
>>> results you are after.
>>
>> I will just comment that really large readahead values may cause 
>> significant memory usage and transfer of unused data. My observations 
>> and some posts indicate that very large readahead and/or chunk size 
>> may reduce random access performance. I believe you said you had 
>> 512MB RAM, that may be a factor as well.
>>
>
> I did not set such a large read-ahead. I had a look at the md0 device 
> which had a value of 3072 and set this on the LV device as well. 
> Performance really improved after this.
>
>>
>> Unless you are planning to use this machine mainly for running 
>> benchmarks, I would tune it for your actual load and a bit of worst 
>> case avoidance.
>>
>
> The last part is exactly what I am aiming at right now.
> I tried to keep my changes to a bare minimum.
>
> * Change chunk size to 256K
> * Align the physical extent of the LVM to it
> * Use the same parameters for mkfs.xfs that are choosen autmatically 
> by mkfs.xfs if called on the md0 device itself.
>
> * Set the read-ahead of the LVM block device to the same value as the 
> md0 device
> * Change the stripe_cache_size to 2048
>
>
> With these settings applied to my setup here, RAID+XFS and 
> RAID+LVM+XFS perform nearly identical and that was my goal from the 
> beginning.
>
> Now I am off to figure out what's happening during the initial rebuild 
> of the RAID-5 but see my other mail for this.
>
> Once again, thank you all for your valuable input and support.
Thank you for reporting results, hopefully will be useful to some future 
seeker of the same info.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


