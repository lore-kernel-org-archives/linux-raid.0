From: Stone <stone@heisl.org>
Subject: Re: Brocken Raid & LUKS
Date: Wed, 27 Feb 2013 20:51:09 +0100
Message-ID: <512E63AD.6080600@heisl.org>
References: <5123A1CC.2000003@heisl.org> <512DB532.2080306@heisl.org> <512E58C9.8080701@heisl.org> <2545996.qZhdRSH3AH@xrated>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2545996.qZhdRSH3AH@xrated>
Sender: linux-raid-owner@vger.kernel.org
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Phil Turmel <philip@turmel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 27.02.2013 20:33, schrieb Hans-Peter Jansen:
> Am Mittwoch, 27. Februar 2013, 20:04:41 schrieb Stone:
>> sorry :-)
>> the last night was very short...
>>
>> know i have tested case #2
>> for x in /dev/sd[efh] ; do parted $x unit s print ; done
>> Model: ATA WDC WD20EARS-00M (scsi)
>> Disk /dev/sde: 3907029168s
>> Sector size (logical/physical): 512B/512B
>> Partition Table: gpt
>>
>> Number  Start  End          Size         File system  Name  Flags
>>    1      34s    3907029118s  3907029085s                     raid
>>
>> Model: ATA WDC WD20EARS-00M (scsi)
>> Disk /dev/sdf: 3907029168s
>> Sector size (logical/physical): 512B/512B
>> Partition Table: gpt
>>
>> Number  Start  End          Size         File system  Name     Flags
>>    1      2048s  3907029118s  3907027071s               prmiary
>>
>> Model: ATA WDC WD20EARS-00M (scsi)
>> Disk /dev/sdh: 3907029168s
>> Sector size (logical/physical): 512B/512B
>> Partition Table: gpt
>>
>> Number  Start  End          Size         File system  Name  Flags
>>    1      34s    3907029118s  3907029085s                     raid
> Your whole partitioning looks garbled. /dev/sdf1 starts at 2048, while the
> others start at 34 (even 34 is a strange value), but all end on the same
> sector, sdf carries no raid flag, but primary (with a funny letter swap - my
> parted gets this word right, at least).
>
> I would compare the first sectors of these devices (especially around sector
> 34). Probably you managed to destroy your former partition table on sdf, e.g.
> try to adjust this one similar to the others.
>
> Cheers,
> Pete
i also have set all drives to start with sector 34 and then i started a 
fsck -y but the output was the same...
