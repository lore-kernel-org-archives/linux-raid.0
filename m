From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Booting from RAID1
Date: Sun, 20 Dec 2009 16:39:04 -0800
Message-ID: <4877c76c0912201639q6afb2c36m6eb374f87d5188fc@mail.gmail.com>
References: <4877c76c0912200115q4c91512cj119ff23f7d662d16@mail.gmail.com>
	 <67.C8.01567.DC44E2B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <67.C8.01567.DC44E2B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Dec 20, 2009 at 7:37 AM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>> >> Oh, and you'll also very likely want grub to read the /boot
>> >> filesystem, which is why it must be on a partition followed by th=
e
>> >> raid header, instead of a partition containing a raid header and =
raid
>> >> protected partition. =A0That use is OK since grub operates read-o=
nly.
>> >
>> > =A0 =A0 =A0 =A0I think I follow you, here. =A0IOW, partition the d=
rive, create the
>> md
>> > target, and then format the RAID array, right? =A0Or are you sayin=
g one
>> should
>> > format the partition and then create the RAID array on top of it?
>> >
>> >
>>
>> It works much more cleanly if you create the RAID array first, and
>> then use the container it provides;
>
> =A0 =A0 =A0 =A0Now I definitely don't follow you. =A0Are you saying o=
ne should create
> an array from the raw drive, partition it, format the first partition=
, then
> create secondary arrays from the second and third partition, and fina=
lly
> format the second and third array?
>
>> this way the end of your file-system does not overlap the raid super=
-
>> block.
>
> =A0 =A0 =A0 =A0I can follow that - there's a danger of wiping or movi=
ng the mdadm
> superblock if it is contained in the filesystem, but it seems to me
> partitioning the drive and then creating the array from a partition, =
as I
> first suggested, will accomplish that just fine.
>
>

It is an option to partition it after the fact; however generally it's
better to partition it first, and then apply whatever raid level you
like to each partition.

You misunderstand on the second half; the danger is that both the
'filesystem' and 'mdadm superblock' attempt to use the whole device.
That may appear to work for a while, but there is danger that the
filesystem could grow and store data in the same place the mdadm
superblock is; depending on if the filesystem or mdadm then filesystem
within the device was used this will either fail, or destroy the raid
information block.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
