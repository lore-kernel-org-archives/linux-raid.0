From: Caspar Smit <c.smit@truebit.nl>
Subject: Re: Striping does not increase performance.
Date: Tue, 13 Mar 2012 12:55:49 +0100
Message-ID: <CAKFseUMvepXdGumQVoei_TE3Ms-jK9U4BoKOVjaiz9PdOAU8pg@mail.gmail.com>
References: <CAKFseUN8-Rb1x5j-JM+q3CLEXnFO0ieAmBG_5tVcxu4NAz0ojA@mail.gmail.com>
	<jjl15t$iqb$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <jjl15t$iqb$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Op 12 maart 2012 15:20 heeft David Brown <david@westcontrol.com> het
volgende geschreven:
> On 12/03/2012 13:34, Caspar Smit wrote:
>>
>> Hi all,
>>
>> I don't know exactly which mailinglists to use for this one so I hop=
e
>> i used the right ones.
>>
>> I did some performance testing on a new system and found out some
>> things I couldn't explain or didn't expect.
>> At the end are some questions I hope to get answered to explain the
>> tings i'm seeing in the test.
>>
>>
>> For the next test I wanted to see if i could double the performance =
by
>> striping an LV over 2 md's (so instead of using 10 disks/spindles, u=
se
>> 20 disks/spindles)
>>
>> So i added md1 to the VG as PV.
>>
>> Created a fresh LV striped across the two PV's using a 64KB stripe
>> size and ran the test again.
>>
>>
>> Now the total IO's in 10 seconds are 16x larger than before. 190464 =
/
>> 10 =3D 19046,4 / 16 =3D 1190,4 /16 =3D the reported 75 IOPS above.
>> So the 64KB blocks seem to be split into 4KB blocks (64 / 16 =3D 4)
>> which results in a way larger total IO's.
>> The IO's per disk seem to be in 64KB blocks still only now with a
>> large MERGE figure besides it. (Now 4KB blocks are merged into 64KB
>> blocks?)
>>
>
> LVM will stripe the data between the two md's with a default stripe s=
ize of
> 4K - thus the first 4K will go to md0, the second to md1, etc. =A0Thi=
s is
> obviously terribly inefficient. =A0For 8+2 raid6 with 64KB chunks, yo=
u want a
> stripe size of 8x64K =3D 512KB when you create the logical volume.

Ok, that makes sense.
But if I for instance had created a 10 disk RAID5 md with a 64KB chunk
size it would have been a stripe size of 9x64KB=3D576KB which is not
possible. So I have to make sure I always create a raid5/6 md where
the stripe size is a power of 2 when i want to use raid0 and/or LVM
striping, correct?

Caspar
>
>
>> The performance does not double but stays the same as with 1 MD set
>> only the total IO's are spread among the MD's. Each disk now does
>> around 60 IOPS!
>>
>> I still wanted to see if I could double the performance and thought =
it
>> might have something to do with LVM striping so i ditched LVM and
>> created a RAID0 (md6) over md0 and md1 with a chunk size of 64KB
>> again.
>>
>
> Similarly here, you want your chunk sizes to fit a stripe on the raid
> devices, not to fit the underlying devices. =A0So try with a chunk si=
ze of
> 512KB (or higher).
>
> mvh.,
>
> David
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
