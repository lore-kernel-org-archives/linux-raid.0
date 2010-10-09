From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: Re: RAID0 size bug (?)
Date: Sat, 9 Oct 2010 21:09:16 +0200
Message-ID: <0c3201cb67e5$7b064010$0400a8c0@dcccs>
References: <0a7401cb673c$12820280$0400a8c0@dcccs> <20101009104516.129c60e2@notabene>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "Neil Brown" <neilb@suse.de>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Saturday, October 09, 2010 1:45 AM
Subject: Re: RAID0 size bug (?)


> On Sat, 9 Oct 2010 00:56:38 +0200
> "Janos Haar" <janos.haar@netcenter.hu> wrote:
>
>> Hello list,
>>
>> Maybe a known old bug, but i don't know.
>>
>> The size is wrong of the md8:
>>
>> [root@UNISTORE ~]# fdisk -l /dev/sdh
>>
>> Disk /dev/sdh: 750.1 GB, 750156374016 bytes
>                 ^^^^^^^^^
>> 255 heads, 63 sectors/track, 91201 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>
> So 750GB
>
>>
>> Disk /dev/sdh doesn't contain a valid partition table
>> [root@UNISTORE ~]# fdisk -l /dev/sdf
>>
>> Disk /dev/sdf: 500.1 GB, 500107862016 bytes
>                 ^^^^^^^^^
>> 255 heads, 63 sectors/track, 60801 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>
> This one is 500GB
>
>
>>
>> Disk /dev/sdf doesn't contain a valid partition table
>> [root@UNISTORE ~]# mdadm --detail /dev/md8
>> /dev/md8:
>>         Version : 00.90.03
>>   Creation Time : Sat Oct  9 06:36:36 2010
>>      Raid Level : raid0
>>      Array Size : 1220961088 (1164.40 GiB 1250.26 GB)
>                                            ^^^^^^^^^^^
>
> 750GB + 500GB == 1250 GB
>
> So what is your problem?

Shouldn't be 2x500GB?
...because this is stripe, not linear array. :-)

I mean should be used the smallest drive's size, no?

>
> NeilBrown
>
>
>>    Raid Devices : 2
>>   Total Devices : 2
>> Preferred Minor : 8
>>     Persistence : Superblock is not persistent
>>
>>     Update Time : Sat Oct  9 06:36:36 2010
>>           State : clean
>>  Active Devices : 2
>> Working Devices : 2
>>  Failed Devices : 0
>>   Spare Devices : 0
>>
>>      Chunk Size : 64K
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       8      112        0      active sync   /dev/sdh
>>        1       8       80        1      active sync   /dev/sdf
>> [root@UNISTORE ~]#
>> [root@UNISTORE ~]# uname -a
>> Linux UNISTORE 2.6.28.10 #5 SMP Fri Jan 29 07:40:35 CET 2010 x86_64 
>> x86_64
>> x86_64 GNU/Linux
>> [root@UNISTORE ~]# mdadm -V
>> mdadm - v2.5.4 - 13 October 2006
>> [root@UNISTORE ~]#
>>
>>
>> Cheers,
>> Janos
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html 

