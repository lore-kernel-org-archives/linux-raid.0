From: "fibreraid@gmail.com" <fibreraid@gmail.com>
Subject: Re: md array does not detect drive removal: mdadm 3.2.1, Linux 2.6.38
Date: Tue, 7 Jun 2011 00:01:04 -0700
Message-ID: <BANLkTikD0x7AHpbJZ2AESV_eRwrYz08oOQ@mail.gmail.com>
References: <BANLkTikv0avX6tYoG8g+pgUznopHCA4tyA@mail.gmail.com>
	<BANLkTi=HkQNQgow-47Mr7cofNGAhO0vOiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=HkQNQgow-47Mr7cofNGAhO0vOiQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I did test IO, and upon issuing IO, then md correctly detected the
failure and began a rebuild. However, my opinion is that this is
inadequate and actually, I do not believe this is correct behavior. As
I recall from prior experiences with md, md would initiate a rebuild
based on drive removal only as well, even without any pending IO.

I would appreciate some further feedback as to this behavior. Thanks!

-Tommy


On Mon, Jun 6, 2011 at 2:25 PM, CoolCold <coolthecold@gmail.com> wrote:
> On Mon, Jun 6, 2011 at 10:20 PM, fibreraid@gmail.com
> <fibreraid@gmail.com> wrote:
>> Hello,
>>
>> I am running Linux kernel 2.6.38 64-bit version with mdadm 3.2.1. Th=
e
>> server hardware has dual socket Westmere CPUs (4 cores each), 24 GB =
of
>> RAM, and 24 hard drives connected via SAS.
>>
>> I create an md0 array with 23 active drives, 1 hot-spare, RAID 5, an=
d
>> 64K chunk. After synchronization is complete, I have:
>>
>> root::~# cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md0 : active raid5 sdf1[23](S) sdi1[22] sdh1[21] sdg1[20] sde1[19]
>> sdd1[18] sdc1[17] sdo1[16] sdn1[15] sdq1[14] sdp1[13] sdr1[12]
>> sdm1[11] sdl1[10] sdk1[9] sdj1[8] sdv1[7] sdu1[6] sdt1[5] sds1[4]
>> sdy1[3] sdx1[2] sdb1[1] sdw1[0]
>> =A0 =A0 =A02149005056 blocks super 1.2 level 5, 64k chunk, algorithm=
 2
>> [23/23] [UUUUUUUUUUUUUUUUUUUUUUU]
>>
>> Then I remove an active drive from the system by unplugging it. udev
>> catches the event, and fdisk -l reports one less drive. In this case=
,
>> I remove /dev/sdv.
>>
>> However, /proc/mdstat remains unchanged. It's as if md has no idea
>> that the drive disappeared. I would expect md at this point to have
>> detected the removal, and to have automatically kicked-off a resync
>> using the included hot-spare. But this does not occur.
>>
>> If I then run mdadm -R /dev/md0, in an attempt to "wake up" md, then
>> md does realize the change, and does start the resyncing.
> I guess md realizes there is no drive when write/read error occurs,
> which gonna happen pretty soon if array is in usage, can you set some
> dd reading and then remove drive?
>
>>
>> I do not believe this is normal behavior. Can you advise?
>>
>> Thank you!
>> -Tommy
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Best regards,
> [COOLCOLD-RIPN]
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
