From: Jojy Varghese <jojy.varghese@gmail.com>
Subject: Re: error injection
Date: Wed, 28 Sep 2011 19:06:17 -0700
Message-ID: <CAJD3hpU5YE5S93tDV1iK3_YReESh5NDnX877YMWc4JMMQkaN0A@mail.gmail.com>
References: <CAJD3hpWbkSGeiWDgYHP3ewnw7akoEY-ydoRJKLxwcp8+up5zKw@mail.gmail.com>
	<20110929091128.1488f267@notabene.brown>
	<CAJD3hpUNkLDRGQxNuo6m7=OQjBu3uc5xV7Fzy-XLvrUFHQJbiw@mail.gmail.com>
	<20110929110836.1dc9944d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110929110836.1dc9944d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Neil. Also, is there any way to find the current fault blocks be=
ing set?

On Wed, Sep 28, 2011 at 6:08 PM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 28 Sep 2011 17:59:49 -0700 Jojy Varghese <jojy.varghese@gmail=
=2Ecom>
> wrote:
>
>> Thanks Neil. I tried setting my sda7 partition to generate write
>> errors every 40 bytes(writing 1 byte at a time). I did :
>
> md doesn't see byte writes. =C2=A0It sees sectors or more - usually w=
hole pages or
> groups of pages.
>
>>
>> 1. Create a array with:
>> mdadm -C /dev/md/me0 -l faulty -n1 /dev/sda7
>
> -C will write a superblock to /dev/sda7 which you don't really want. =
=C2=A0It
> doesn't hurt, but I always used -B (--build) to avoid any metadata.
>
>>
>> After this step I can see /dev/md127 and when i do a mdadm -D /dev/m=
d127, i get:
>>
>> /dev/md127:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
>> =C2=A0 Creation Time : Wed Sep 28 17:35:50 2011
>> =C2=A0 =C2=A0 =C2=A0Raid Level : faulty
>> =C2=A0 =C2=A0 =C2=A0Array Size : 969410424 (924.50 GiB 992.68 GB)
>> =C2=A0 =C2=A0Raid Devices : 1
>> =C2=A0 Total Devices : 1
>> =C2=A0 =C2=A0 Persistence : Superblock is persistent
>>
>> =C2=A0 =C2=A0 Update Time : Wed Sep 28 17:35:50 2011
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
>> =C2=A0Active Devices : 1
>> Working Devices : 1
>> =C2=A0Failed Devices : 0
>> =C2=A0 Spare Devices : 0
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : eng-dev16.lab.local:=
me0 =C2=A0(local to host eng-dev16.lab.local)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UUID : 96f4be10:312f9574:f4=
0107aa:d9f278ba
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 0
>>
>> =C2=A0 =C2=A0 Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice Sta=
te
>> =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active syn=
c =C2=A0 /dev/sda7
>>
>>
>> 2. Set write fault level with:
>>
>> mdadm -G /dev/md/me0 --layout=3Dwp40
>>
>>
>>
>> =C2=A0 After this when i write > 40 bytes into /dev/md127, i dont ge=
t any
>> I/O errors. I am sure i am doing something wrong here.
>
> When you write to /dev/md127 it will just go into the page cache and
> eventually be flushed to the device in one write.
> Use O_DIRECT or O_SYNC and it will be flushed out more quickly, but a=
lways
> write at least 512 =C2=A0bytes at a time.
>
> NeilBrown
>
>
>
>>
>>
>> Any help is much appreciated.
>>
>> Thanks
>> Jojy
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
