From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Severe slowdown with LVM on RAID, alignment problem?
Date: Sat, 01 Mar 2008 15:45:58 -0500
Message-ID: <47C9C086.4020805@tmr.com>
References: <872d9b69db95a1b08319e935595743cc@localhost> <47C7E086.5080203@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47C7E086.5080203@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: Michael Guntsche <mike@it-loops.com>, Maurice Hilarius <maurice@harddata.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> Michael Guntsche wrote:
>>
>> Is it possible that my computer is just too slow to get good read 
>> results?
> unlikely
>
>> While reading is a little bit faster it's nowhere near the speed I 
>> get on
>> md0 itself.
>>
>
> I would guess that you did not set the correct read-ahead values for 
> the LV. If you do not specify anything it will default to 128k (256 
> sectors), which is terribly small for sequential reads. On the 
> contrary the MD device will do some clever calculations and set its 
> read-ahead correctly depending on the raid level and the number of 
> disks. Do:
>
> blockdev --setra 65536 <your lv device>
>
> and run the tests again. You are almost certainly going to get the 
> results you are after.

I will just comment that really large readahead values may cause 
significant memory usage and transfer of unused data. My observations 
and some posts indicate that very large readahead and/or chunk size may 
reduce random access performance. I believe you said you had 512MB RAM, 
that may be a factor as well.

Also, blockdev will allow you to diddle readahead on the device, 
/dev/sdX, the array /dev/mdX, and the lv /dev/mapper/NAME. The 
interaction of these, and the performance results of having the same 
exact amount of readhead memory used in different way is a fine topic 
for a thesis, conference paper, magazine article, or nightmare.

Unless you are planning to use this machine mainly for running 
benchmarks, I would tune it for your actual load and a bit of worst case 
avoidance.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


