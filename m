From: rj <ratnadeep@gmail.com>
Subject: Re: RAID0 on disks with different sizes
Date: Mon, 15 Mar 2010 22:01:35 +0530
Message-ID: <d19eda751003150931h47d9509t9525e7768f025383@mail.gmail.com>
References: <d19eda751003142326j7bfec447ne64cfa50e22f089c@mail.gmail.com>
	 <aebf5d971003150058l66a84f4ak26b05b3c73a4d32c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <aebf5d971003150058l66a84f4ak26b05b3c73a4d32c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Beolach <beolach@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Okay, not it is confusing.. having two different answers to this
question :) Which answer is correct?
RAID0 takes approach 1 or approach2?

On Mon, Mar 15, 2010 at 1:28 PM, Beolach <beolach@gmail.com> wrote:
> On Sun, Mar 14, 2010 at 23:26, rj <ratnadeep@gmail.com> wrote:
>> Hi,
>>
>> How does MD RAID0 layer support disks with different sizes?
>> 1. Does it take the size of smallest disk and do the striping
>> accordingly? =C2=A0This way there would be wastage of space in bigge=
r
>> disks.
>> Or
>> 2. Does it stripe across all the space of disks? This way, if stripi=
ng
>> is not possible for a disk because it has exhausted the space,
>> striping will continue or remaining devices (although with
>> compromising performance for these stripes because they have one dis=
k
>> less).
>>
>> What approach md chooses? Also, what approach is taken for RAID5 in =
such cases?
>>
>
> MD RAID0 follows #2; 4/5/6 follow #1. =C2=A0From the man page for md:
>
> =C2=A0 RAID0
> <snip>
> =C2=A0 =C2=A0 =C2=A0 If devices in the array are not all the same siz=
e, then once the small=E2=80=90
> =C2=A0 =C2=A0 =C2=A0 est device has been =C2=A0exhausted, =C2=A0the =C2=
=A0RAID0 =C2=A0driver =C2=A0starts =C2=A0collecting
> =C2=A0 =C2=A0 =C2=A0 chunks =C2=A0into smaller stripes that only span=
 the drives which still have
> =C2=A0 =C2=A0 =C2=A0 remaining space.
>
> =C2=A0 RAID1
> <snip>
> =C2=A0 =C2=A0 =C2=A0 All devices in a RAID1 array should be the same =
size. =C2=A0If they are not,
> =C2=A0 =C2=A0 =C2=A0 then =C2=A0only the amount of space available on=
 the smallest device is used
> =C2=A0 =C2=A0 =C2=A0 (any extra space on other devices is wasted).
> <snip>
>
> =C2=A0 RAID4
> <snip>
> =C2=A0 =C2=A0 =C2=A0 Unlike RAID0, RAID4 also requires that all strip=
es span all drives, =C2=A0so
> =C2=A0 =C2=A0 =C2=A0 extra space on devices that are larger than the =
smallest is wasted.
> <snip>
>
> My understanding is that this is why MD RAID0 does not yet support
> --grow, while MD RAID456 does - since they take different striping
> approaches, it's much harder to reuse the --grow algorithm.
>
>
> Good luck,
> Conway S. Smith
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
