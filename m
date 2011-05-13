From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: mdadm does not create partition devices whatsoever, "partitionable"
 functionality broken
Date: Fri, 13 May 2011 22:00:07 +0200
Message-ID: <4DCD8DC7.1080707@grumpydevil.homelinux.org>
References: <4DCD4A83.8060202@pulseforce.com>	<4DCD6119.3080705@turmel.org>	<4DCD67EF.1070602@pulseforce.com>	<4DCD6B27.70402@pulseforce.com> <20110513234055.4307c536@natsu> <4DCD72AF.1070809@pulseforce.com> <4DCD75FE.8010703@turmel.org> <4DCD7E78.6050000@pulseforce.com> <4DCD800F.7080501@grumpydevil.homelinux.org> <4DCD8B32.9010901@pulseforce.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DCD8B32.9010901@pulseforce.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher White <linux@pulseforce.com>
Cc: Roman Mamedov <rm@romanrm.ru>, Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/13/2011 09:49 PM, Christopher White wrote:
> On 5/13/11 9:01 PM, Rudy Zijlstra wrote:
>> Hi Chris,
>>
>>
>> I've run paritioned MD disks for several years now. I do that on 
>> systems where i use md for the system partitions. One mirror with 
>> partitions for the different system aspects. I prefer that, as it 
>> reflects best the actual physical configuration, and all partitions 
>> will be degraded at the same time when 1 disk develops a problem 
>> (which is unfortunately not the case when you partition the disk and 
>> then mirror the partitions).
>>
>> As i am a bit lazy and have only limited wish to fight with 
>> BIOS/bootloader conflicts / vagaries, these systems typically boot 
>> from the network (kernel gets loaded from the network, from there 
>> onwards all is on the local disk).
>>
>> Cheers,
>>
>>
>>
>> Rudy
> Thank you for the information, Rudy,
>
> Your experience of running partitioned MD arrays for years shows that 
> it is indeed stable. The reason for wanting to skip LVM was that it's 
> one less performance-penalty layer, one less layer to configure, one 
> less possible point of failure, etc.

I skip LVM cause for my usage pattern it only gives me an additional 
management layer... an additional layer to configure

>
> However, Phil again brings up the main fear that's been nagging me, 
> and that is that MD's partitioning support receives less love (use) 
> and therefore risks having bugs that go undiscovered for ages and 
> (gasp) may even risk corrupting the data. People are just so used to 
> LVM since MD used to be single-partition only, that 
> LVM+single-partition MD array is far more mature and far more in use.
MD layer and LVM layer are independently maintained. There regular use 
together would trigger eventual bugs quicker though.

>
> My main reason against LVM was the performance penalty, where I had 
> read that it was in the 1-5% range, but I just did a new search and 
> saw threads showing that any performance hit claim is outdated and 
> that LVM2 is extremely efficient. In fact the CPU load didn't seem to 
> be impacted more than 0.1% or so in the graphs I saw.
>
> By the way, Rudy, as for your boot conflicts and the fact that you 
> resort to running a network boot, that was only a problem in the past 
> when bootloaders did not support software RAID. Grub2 supports GPT, MD 
> arrays with metadata 1.2, and can fully boot from a system (with 
> /boot) installation located on your MD array. All you'll have to do is 
> make sure your /boot partition (and the whole system if you want to) 
> is on a RAID 1 (mirrored) array, and that you install the Grub2 
> bootloader on every physical disk. This means that it goes:
>

I know... but i happen to dislike grub2, and my network boot environment 
is stable and well maintained.
Grub2 is for me a step backwards. more difficult to configure, and i've 
gone back to lilo as main bootloader.

