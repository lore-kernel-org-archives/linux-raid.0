From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: Broken raid 5
Date: Fri, 23 May 2014 10:50:02 +0100
Message-ID: <537F19CA.30704@mpstor.com>
References: <43607931-ad0a-4dbc-b258-188297cbb951@email.android.com> <537DDC84.3010003@mpstor.com> <01734799-2b9f-4ab5-8be2-9f6dc928379f@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <01734799-2b9f-4ab5-8be2-9f6dc928379f@email.android.com>
Sender: linux-raid-owner@vger.kernel.org
To: "L. M. J" <linuxmasterjedi@free.fr>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 22/05/14 19:49, L. M. J wrote:
> On 22 mai 2014 13:16:20 CEST, Benjamin ESTRABAUD <be@mpstor.com> wrot=
e:
>> On 21/05/14 23:05, L. M. J wrote:
>>> Hi,
>>>
>>>    Very short story : I've created an array on top of another one,
>> I presume that you actually mean that you created an array ontop of =
the
>>
>> disks from another array.
>>
>>   so I lost my array and my data.
>>>
>>>    Is there =C3=A0 way to recover RAID 5 meta data on each disk to =
be able
>> to rebuilt the previous raid 5?
>>>
>> Well, if you used the same metadata version (like 1.2 for instance),
>> the
>> "old" metadata would have been overwritten by your new RAID metadata
>> (assuming you built the RAID on the same drives/partitions) so that
>> would be gone as well.
>>
>> Even if you were able to rebuild the "previous" RAID (also assuming =
it
>> was a RAID5), if your current RAID build has completed the data woul=
d
>> have been thoroughly destroyed by the build process and recovery wou=
ld
>> be insanely hard.
>>
>>> Thabks
>>>
>>
>> Regards,
>> Ben.
>
> Strange, answer 1 seems different speech, have a look : http://server=
fault.com/questions/499051/mdadm-mdadm-cannot-open-dev-sda1-device-or-r=
esource-busy
>
Hi,

I'm not sure this SO question (how to create a RAID10 with the contents=
=20
from one drive) relates to your problem. The first answer is about=20
creating a RAID10 with a device missing (the device that currently hold=
s=20
the data), formatting the RAID so that the data from the "missing" RAID=
=20
device can first be copied, and then adding the data to the RAID. This=20
is to avoid having to copy any data to an intermediate drive when=20
reusing a drive (with valid data) to create a RAID.

Regards,
Ben.

> Thanks
>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
