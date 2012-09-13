From: David Brown <david.brown@hesbynett.no>
Subject: Re: make filesystem failed while the capacity of raid5 is big than
 16TB
Date: Thu, 13 Sep 2012 09:13:11 +0200
Message-ID: <50518787.4010501@hesbynett.no>
References: <505033fe.8aec440a.5d52.ffffe37b@mx.google.com> <50504094.2040302@hesbynett.no> <CACY-59cLmV2SRY+FrvhHxseDD1+r-B-3bOKPGzJdGttW+9U2mw@mail.gmail.com> <505059DD.8000108@hesbynett.no> <CACY-59dAbS=8ncRAeZrAYBAvo7G6FEyoGREHtC-ze4cwhiF9GQ@mail.gmail.com> <5051542A.4090901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5051542A.4090901@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias Buren <mathias.buren@gmail.com>
Cc: GuoZhong Han <hanguozhong@meganovo.com>, stan@hardwarefreak.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/09/2012 05:34, Mathias Buren wrote:
> On 13/09/12 11:21, GuoZhong Han wrote:
>> Hi David:
>>
>>           I am sorry for last mail that I had not described the
>> requirements of the system very clear.
>>
>>           I will detail for you to describe the requirements of the
>> system.
>>
>
> (snip)
>
>>
>>           As you said, the performance for write of 16*2T raid5 will be
>> terrible, so what do you think that how many disks to be build to a
>> raid5 will be more appropriate?
>
> Personally I wouldn't use more than 5 drives in a RAID5 with drives
> larger than 1TB, the failure risk is too high. With 16x 2TB drives, how
> about two RAID6 arrays of 8 drives each, then RAID0 them? (RAID60)
>
> Or, two RAID6 arrays with 7 drives each, 2 hotspares, and RAID0 on top.
> (RAID10 + 2 HSP)
>

I wouldn't bother with hotspares with RAID6 unless service and 
replacement of a dead disk is going to take a long time - you already 
have double redundancy with the raid6.  Raid6 on 8 disks is already 
orders of magnitude safer than raid5 with 16 disks - once you have a 
higher risk of the power supply taking fire and burning /all/ your 
disks, you don't benefit from even greater redundancy!

> You mention 36 cores. Perhaps you should try the very latest mdadm
> versions and Linux kernels (perhaps from the MD Linux git tree), and
> enable the multicore option.
>

If that is possible for the OP, then that is definitely worth trying. 
It is this kind of setup that will benefit most from the newer 
multithreading support.


