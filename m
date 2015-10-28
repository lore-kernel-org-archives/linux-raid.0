From: Sheng Yang <sheng@yasker.org>
Subject: Re: Raid array name by mdadm
Date: Wed, 28 Oct 2015 15:01:09 -0700
Message-ID: <CA+2rt40+GxLeSUaQYouHjg=1pC8tJFJrEZFj5ZV0cm03hOJb5g@mail.gmail.com>
References: <CA+2rt40JQcxv8CTw-+bpXDGFNorgS53B+thrkNeGN6B2JRQmBw@mail.gmail.com>
	<CALtW_agEVF9x83WP6GO0mJ9zjggS_7_9TJ5dJEdijmR8wHf49A@mail.gmail.com>
	<CA+2rt40zrLoUuGhVcq2DxLiX39PRryeygFN=AZEu_5g0TwR=pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+2rt40zrLoUuGhVcq2DxLiX39PRryeygFN=AZEu_5g0TwR=pQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Oct 28, 2015 at 2:40 PM, Sheng Yang <sheng@yasker.org> wrote:
> On Wed, Oct 28, 2015 at 12:56 PM, Dragan Milivojevi=C4=87
> <galileo@pkm-inc.com> wrote:
>>> I tried to create a raid using:
>>>
>>> # mdadm --create device-123 --verbose --level=3Dmirror --raid-devic=
es=3D2
>>> --name=3Ddevice-123 /dev/sda /dev/sdb
>>> mdadm: Defaulting to version 1.2 metadata
>>> mdadm: array /dev/md/device-123 started.
>>>
>>> But what I got in the end is only /dev/md127. The directory of
>>> /dev/md/ doesn't exist.
>>
>>
>> try mdadm --create /dev/md/device-123,
>>
>> for example:
>>
>> truncate -s 512M disk0
>> truncate -s 512M disk1
>>
>> losetup /dev/loop0 disk0
>> losetup /dev/loop1 disk1
>>
>> mdadm --create /dev/md/device-123 --verbose --level=3Dmirror
>> --raid-devices=3D2 /dev/loop0 /dev/loop1
>>
>> [root@eos ~]# ll /dev/md/device-123
>> lrwxrwxrwx 1 root root 8 Oct 28 20:53 /dev/md/device-123 -> ../md127
>>
>> [root@eos ~]# mdadm --detail --scan
>> ARRAY /dev/md/device-123 metadata=3D1.2 name=3Ddevice-123
>> UUID=3D03ba5df7:7c5cc933:367e19ef:384665c5
>
> Thank Dragan! It works!
>
> Seems it's mdadm itself create the link rather than do through kernel=
,
> which gave me a little trouble. :D

Hi Dragan,

One more question if you don't mind:

When you do

mdadm --stop /dev/md/device-123

Would mdadm remove the broken link file /dev/md/device-123 automaticall=
y?

I found I have to remove the link file manually later...

--Sheng
>
> --Sheng
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
