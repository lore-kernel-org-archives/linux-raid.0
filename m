From: Nate Byrnes <nate@qabal.org>
Subject: Re: RAID5 recovery trouble, bd_claim failed?
Date: Wed, 19 Apr 2006 10:20:17 -0400
Message-ID: <44464721.3080702@qabal.org>
References: <1145106091.18173.18.camel@nemo.qabal.org>	 <44456474.9040201@harddata.com> <1145403579.15773.1.camel@nemo.qabal.org> <44463E0A.8090906@harddata.com> <444640F1.3020008@qabal.org> <44464368.2080406@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44464368.2080406@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: Nate Byrnes <nate@nemo.qabal.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
    I replaced the failed disk. The configuration is /dev/hde, /dev/hdf 
(replaced), on IDE channel 0, /dev/hdg, /dev/hdh on IDE channel 1, on a 
single PCI controller card. The issue here is that hde in now also not 
accessible after the failure of hdf.  I cannot see the jumper configs as 
the server is at home, and I am at work. The general thinking was that 
the hde superblock got hosed with the loss of hdf.

My initial post only did discuss the disk ordering and device names. As 
I had replaced the disk which had failed (in a previously fully 
functioning array), with a new disk with exactly the same configuration 
(jumpers, cable locations, etc), and each of the disks could be 
accessed, my thinking was that there would not be a hardware problem to 
sort through. Is this logic flawed?
    Thanks again,
    Nate

Maurice Hilarius wrote:
> Nate Byrnes wrote:
>   
>> Hi All,
>>    I'm not sure that is entirely the case. From a hardware
>> perspective, I can access all the disks from the OS, via fdisk and dd.
>> It is really just mdadm that is failing.  Would I still need to work
>> the jumper issue?
>>    Thanks,
>>    Nate
>>
>>     
> IF the disks are as we suspect (master and slave relationships) and IF
> you now have either a failed or a removed drive, then you  MUST correct
> the jumpering.
> Sure, you can often see a disk that is misconfigured.
> It is almost certain, however, that when you write to it you will simply
> cause corruption on it.
>
> Of course, so far this is all speculation, as you have not actually said
> what the disks, controller interfaces, and jumpering and so forth are at.
> I was merely speculating, based on what you have said.
>
> No amount of software magic will "cure" a hardware problem..
>
>
>   
