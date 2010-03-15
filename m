From: Joachim Otahal <Jou@gmx.net>
Subject: Re: RAID0 on disks with different sizes
Date: Mon, 15 Mar 2010 18:46:55 +0100
Message-ID: <4B9E728F.1000503@gmx.net>
References: <d19eda751003142326j7bfec447ne64cfa50e22f089c@mail.gmail.com>	 <aebf5d971003150058l66a84f4ak26b05b3c73a4d32c@mail.gmail.com> <d19eda751003150931h47d9509t9525e7768f025383@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d19eda751003150931h47d9509t9525e7768f025383@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: rj <ratnadeep@gmail.com>
Cc: Beolach <beolach@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

My RAID0 answer was outdated. All space is used as described by=20
"Beolach". In the example with 250/500/750 GB:
It would automatically stripe on all three for the for the first 250 GB=
,=20
then switch to two drives on the 250GB to 500GB space, and to one drive=
=20
for the rest.

I would play with it on files used via loopback first though.

Joachim Otahal

rj schrieb:
> Okay, not it is confusing.. having two different answers to this
> question :) Which answer is correct?
> RAID0 takes approach 1 or approach2?
>
> On Mon, Mar 15, 2010 at 1:28 PM, Beolach<beolach@gmail.com>  wrote:
>   =20
>> On Sun, Mar 14, 2010 at 23:26, rj<ratnadeep@gmail.com>  wrote:
>>     =20
>>> Hi,
>>>
>>> How does MD RAID0 layer support disks with different sizes?
>>> 1. Does it take the size of smallest disk and do the striping
>>> accordingly?  This way there would be wastage of space in bigger
>>> disks.
>>> Or
>>> 2. Does it stripe across all the space of disks? This way, if strip=
ing
>>> is not possible for a disk because it has exhausted the space,
>>> striping will continue or remaining devices (although with
>>> compromising performance for these stripes because they have one di=
sk
>>> less).
>>>
>>> What approach md chooses? Also, what approach is taken for RAID5 in=
 such cases?
>>>
>>>       =20
>> MD RAID0 follows #2; 4/5/6 follow #1.  From the man page for md:
>>
>>    RAID0
>> <snip>
>>        If devices in the array are not all the same size, then once =
the small=E2=80=90
>>        est device has been  exhausted,  the  RAID0  driver  starts  =
collecting
>>        chunks  into smaller stripes that only span the drives which =
still have
>>        remaining space.
>>
>>    RAID1
>> <snip>
>>        All devices in a RAID1 array should be the same size.  If the=
y are not,
>>        then  only the amount of space available on the smallest devi=
ce is used
>>        (any extra space on other devices is wasted).
>> <snip>
>>
>>    RAID4
>> <snip>
>>        Unlike RAID0, RAID4 also requires that all stripes span all d=
rives,  so
>>        extra space on devices that are larger than the smallest is w=
asted.
>> <snip>
>>
>> My understanding is that this is why MD RAID0 does not yet support
>> --grow, while MD RAID456 does - since they take different striping
>> approaches, it's much harder to reuse the --grow algorithm.
>>
>>
>> Good luck,
>> Conway S. Smith
>>
>>     =20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
