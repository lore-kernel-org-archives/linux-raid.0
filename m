From: tj <lists@jager.no>
Subject: Re: Raid-5 long write wait while reading
Date: Sun, 03 Jun 2007 02:14:27 +0200
Message-ID: <466207E3.60307@jager.no>
References: <4653306B.4090500@jager.no> <4658CB8A.8080503@jager.no> <465AFCC6.8040006@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <465AFCC6.8040006@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> tj wrote:
>> Thomas Jager wrote:
>>> Hi list.
>>>
>>> I run a file server on MD raid-5.
>>> If a client reads one big file and at the same time another client 
>>> tries to write a file, the thread writing just sits in 
>>> uninterruptible sleep until the reader has finished. Only very small 
>>> amount of writes get trough while the reader is still working.
>>> I'm having some trouble pinpointing the problem.
>>> It's not consistent either sometimes it works as expected both the 
>>> reader and writer gets some transactions. On huge reads I've seen 
>>> the writer blocked for 30-40 minutes without any significant writes 
>>> happening (Maybe a few megabytes, of several gigs waiting). It 
>>> happens with NFS, SMB and FTP, and local with dd. And seems to be 
>>> connected to raid-5. This does not happen on block devices without 
>>> raid-5. I'm also wondering if it can have anything to do with 
>>> loop-aes? I use loop-aes on top of the md, but then again i have not 
>>> observed this problem on loop-devices with disk backend. I do know 
>>> that loop-aes degrades performance but i didn't think it would do 
>>> something like this?
>>>
>>> I've seen this problem in 2.6.16-2.6.21
>>>
>>> All disks in the array is connected to a controller with a SiI 3114 
>>> chip.
>>
>> I just noticed something else. A couple of slow readers where running 
>> on my raid-5 array. Then i started a copy from another local disk to 
>> the array. Then i got the extremely long wait. I noticed something in 
>> iostat:
>>
>> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>>           3.90    0.00   48.05   31.93    0.00   16.12
>>
>> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
>> ....
>> sdg               0.80        25.55         0.00        128          0
>> sdh             154.89       632.34         0.00       3168          0
>> sdi               0.20        12.77         0.00         64          0
>> sdj               0.40        25.55         0.00        128          0
>> sdk               0.40        25.55         0.00        128          0
>> sdl               0.80        25.55         0.00        128          0
>> sdm               0.80        25.55         0.00        128          0
>> sdn               0.60        23.95         0.00        120          0
>> md0             199.20       796.81         0.00       3992          0
>>
>> All disks are member of the same raid array (md0). One of the disks 
>> has a ton of transactions compared to the other disks. Read 
>> operations as far as i can tell. Why? May be connected with my problem? 
> Two thoughts on that, if you are doing a lot of directory operations, 
> it's possible that the inodes being used most are all in one chunk.
Hi thanks for the reply.

It's not directory operations AFAIK. Reading a few files (3 in this 
case) and writing one.
>
> The other possibility is that these a journal writes and reflect 
> updates to the atime. The way to see if this is in some way  related 
> is to mount (remount) with noatime: "mount -o remount,noatime /dev/md0 
> /wherever" and retest. If this is journal activity you can do several 
> things to reduce the problem, which I'll go into (a) if it seems to be 
> the problem, and (b) if someone else doesn't point you to an existing 
> document or old post on the topic. Oh, you could also try mounting the 
> filesystem as etc2, assuming that it's ext3 now. I wouldn't run that 
> way, but it's useful as a diagnostic tool.
I don't use ext3 i use ReiserFS. ( It seemed like a good idea at the 
time. ) It's mounted with  -o  noatime.
I've done some more testing and i seems like it might be connected to 
mount --bind. If i write to a binded mount i get the slow writes. But if 
i write directly to the real mount i don't. It might just be a random 
occurrence, as the problem always has been inconsistent. Thoughts?
