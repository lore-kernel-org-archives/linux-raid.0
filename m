From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: RAID5 reconstruction ?
Date: Sat, 30 May 2009 18:58:00 +0530
Message-ID: <37d33d830905300628h28fdc162j834db675836dfd@mail.gmail.com>
References: <37d33d830905292244w685499b3h391aa2ca7a5b1ad@mail.gmail.com>
	 <921ca19c0905300552g7697e4c6of8c357d9b456ad0d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <921ca19c0905300552g7697e4c6of8c357d9b456ad0d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sujit Karataparambil <sjt.kar@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I

On Sat, May 30, 2009 at 6:22 PM, Sujit Karataparambil <sjt.kar@gmail.co=
m> wrote:
> Are you talking about hardware raid or software raid.
>
> I donot think hardware raid can by itself do much of the
> book keeping.
>
> Software Raid I think is different from having raid 0 to raid 1
> to raid 2 to raid 3 to raid 4 to raid 5.
>

I am taking about mdraid.

> hope this is correct information.
>
> Thanks,
>
>
> On Sat, May 30, 2009 at 11:14 AM, SandeepKsinha <sandeepksinha@gmail.=
com> wrote:
>> Hi all,
>>
>> Say If I have a RAID 5 array of 50GB of five disks of 10GB each.
>>
>> I have data of 5GB. When a disk fails and replaced with a spare disk=
=2E
>> Will the reconstruction happen only for the 5GB allocated disk block=
s
>> or it will happen for the whole disk size.
>>
>>
>> Is it possible to make =A0reconstruction intelligent enough to keep =
it optimized ?
>>
>> Thanks.
>>
>> --
>> Regards,
>> Sandeep.
>>
>>
>>
>>
>>
>>
>> =93To learn is to change. Education is a process that changes the le=
arner.=94
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
> -- Sujit K M
>



--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
