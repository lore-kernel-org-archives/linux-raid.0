From: Tommy Apel <tommyapeldk@gmail.com>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840 PRO
Date: Wed, 24 Apr 2013 12:24:18 +0200
Message-ID: <CAGA4a+EtGrgLaWnGreLMto_0WCWLxoBb3+OvQhENGE_uUaj1wA@mail.gmail.com>
References: <5171CBF9.9020701@redhost.ro>
	<51732E2B.6090607@hardwarefreak.com>
	<5174501F.80509@redhost.ro>
	<51747382.1010105@hardwarefreak.com>
	<5a749bb56c88b6d6b8a806694b163bda@redhost.ro>
	<5175F71A.8030805@hardwarefreak.com>
	<51765FD7.8090309@redhost.ro>
	<51775078.3000500@hardwarefreak.com>
	<51779720.6040109@redhost.ro>
	<5177A1E7.8030701@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5177A1E7.8030701@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Andrei Banu <andrei.banu@redhost.ro>, linux-raid Raid <linux-raid@vger.kernel.org>, stan@hardwarefreak.com
List-Id: linux-raid.ids

Looks to me like it's the journaled quota process that holds everything back.

2013/4/24 Adam Goryachev <mailinglists@websitemanagers.com.au>:
> On 24/04/13 18:26, Andrei Banu wrote:
>> Hello,
>>
>> I am sorry for the irrelevant feedback. Where I misunderstood your
>> request, I filled in the blanks (poorly).
>>
>> 1. SWAP
>> root [~]# blkid | grep cef1d19d-2578-43db-9ffc-b6b70e227bfa
>> /dev/md1: UUID="cef1d19d-2578-43db-9ffc-b6b70e227bfa" TYPE="swap"
>>
>> So yes, swap is on md1. This *md1 has a size of 2GB*. Isn't this way
>> too low for a system with 16GB of memory?
>>
> Provide the output of "free", if there is RAM available, then it isn't
> too small (that is my personal opinion, but at least it won't affect
> performance/operations until you are using most of that swap space).
>
>>
>> 3. root [~]# fdisk -lu /dev/sd*
>>
> My mistake, I should have said:
> fdisk -lu /dev/sd?
>
> In any case, all of the relevant information was included, so no harm done.
>> Disk /dev/sda: 512.1 GB, 512110190592 bytes
>> 255 heads, 63 sectors/track, 62260 cylinders, total 1000215216 sectors
>> Units = sectors of 1 * 512 = 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x00026d59
>>
>>    Device Boot      Start         End      Blocks   Id  System
>> /dev/sda1            2048     4196351     2097152   fd  Linux raid
>> autodetect
>> Partition 1 does not end on cylinder boundary.
>> /dev/sda2   *     4196352     4605951      204800   fd  Linux raid
>> autodetect
>> Partition 2 does not end on cylinder boundary.
>> /dev/sda3         4605952   814106623   404750336   fd  Linux raid
>> autodetect
>>
>> Disk /dev/sdb: 512.1 GB, 512110190592 bytes
>> 255 heads, 63 sectors/track, 62260 cylinders, total 1000215216 sectors
>> Units = sectors of 1 * 512 = 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x0003dede
>>
>>    Device Boot      Start         End      Blocks   Id  System
>> /dev/sdb1            2048     4196351     2097152   fd  Linux raid
>> autodetect
>> Partition 1 does not end on cylinder boundary.
>> /dev/sdb2   *     4196352     4605951      204800   fd  Linux raid
>> autodetect
>> Partition 2 does not end on cylinder boundary.
>> /dev/sdb3         4605952   814106623   404750336   fd  Linux raid
>> autodetect
>>
> I'm assuming from this you have three md RAID1 arrays where sda1/sdb1
> are a pair, sda2/sdb2 are a pair and sda3/sdb3 are a pair?
>
> Can you describe what is on each of these arrays?
> Output of
> cat /proc/mdstat
> df
> pvs
> lvs
>
> Might be helpful....
>
> Regards,
> Adam
>
> --
> Adam Goryachev
> Website Managers
> www.websitemanagers.com.au
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
