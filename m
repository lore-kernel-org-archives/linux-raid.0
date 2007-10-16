From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Subject: Re: Partitionable raid array... How to create devices ?
Date: Tue, 16 Oct 2007 12:01:35 +0200
Message-ID: <47148BFF.3000505@systella.fr>
References: <471474D6.5090704@systella.fr> <18196.34718.434070.857620@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18196.34718.434070.857620@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday October 16, joel.bertrand@systella.fr wrote:
>> 	Hello,
>>
>> 	I use software raid for a long time without any trouble. Today, I have 
>> to install a partitionable raid1 array over iSCSI. I have some questions 
>> because I don't understand how make this kind of array.
>>
>> 	I have a sparc64 (T1000) with a JBOD (U320 SCSI) that runs a 2.6.23 
>> linux kernel and debian testing distribution.
>>
>> /dev/sda : internal SAS drive -> OS
>> /dev/sdb : internal SAS drive -> OS
>>
>> I have made on /dev/sda and /dev/sdb seven raid1 volumes (non 
>> partitionables arrays).
>>
>> /dev/sd[c-h] : external U320 drives. Each 300 GB drive only contains one 
>> "type fd" partition.
>>
>> I have tried to create a partitionable array with :
>>
>> Root gershwin:[/usr/src/linux-2.6.23] > mdadm -C /dev/mdp0 -l5 
>> --auto=mdp4 -n6 /dev/sd[c-h]1
> 
> Try
>   /dev/md/d0
> or
>   /dev/md_d0
> 
> as suggested in the "DEVICE NAMES" section of the man page.
> However what you used should work.  I'll get that fixed for the next
> release.

	Thanks, it works now. I have seen this note, thus I have remaned my 
array mdp0, but it was not enough ;-)

	Regards,

	JKB
