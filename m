From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Hot-replace for RAID5
Date: Thu, 10 May 2012 19:16:59 +0200
Message-ID: <CAAOsTSm9RH1c6OzFdAGf8hSag35YBD5Y1SuH4Tq-4GXnWgJpAw@mail.gmail.com>
References: <CAAOsTS=4+eqRJXVrw2OaYibgNTEaGxJx4x1PPN4iU49tUO9zOg@mail.gmail.com>
	<4FAB6758.5050109@hesbynett.no>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FAB6758.5050109@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Neil, can you please comment if separate operations mentioned in this
process are behaving and are stable enough as we expect? Thanks.

On Thu, May 10, 2012 at 8:59 AM, David Brown <david.brown@hesbynett.no>=
 wrote:
> (I accidentally sent my first reply directly to the OP, and forgot th=
e
> mailing list - I'm adding it back now, because I don't want the OP to=
 follow
> my advice until others have confirmed or corrected it!)
>
>
> On 09/05/2012 21:53, Patrik Horn=EDk wrote:
>> Great suggestion, thanks.
>>
>> So I guess steps with exact parameters should be:
>> 1, add spare S to RAID5 array
>> 2, mdadm --grow /dev/mdX --level 6 --raid-devices N+1 --layout=3Dpre=
serve
>> 3, remove faulty drive and add replacement, let it synchronize
>> 4, possibly remove added spare S
>> 5, mdadm --grow /dev/mdX --level 5 --raid-devices N
>
>
> Yes, that's what I was thinking. =A0You are missing "2b - let it sync=
hronise".

Sure :)

> Of course, another possibility is that if you have the space in the s=
ystem
> for another drive, you may want to convert to a full raid6 for the fu=
ture.
> =A0That way you have the extra safety built-in in advance. But that w=
ill
> definitely lead to a re-shape.

Actually I dont have free physical space, array already has 7 drives.
=46or the process I need place the additional drive on table near the P=
C
and cool it with fan standing by itself on table... :)

>>
>> My questions:
>> - Are you sure steps 3, 4 and 5 would not cause reshaping?
>
> I /believe/ it will avoid a reshape, but I can't say I'm sure. =A0Thi=
s is
> stuff that I only know about in theory, and have not tried in practic=
e.
>
>
>>
>> - My array has now left-symmetric layout, so after migration to RAID=
6
>> it should be left-symmetric-6. Is RAID6 working without problem in
>> degraded mode with this layout, no matter which one or two drives ar=
e
>> missing?
>>
>
> The layout will not affect the redundancy or the features of the raid=
 - it
> will only (slightly) affect the speed of some operations.

I know it should work, but it is probably configuration that is not
used much by users, so maybe it is not tested as much as standard
layouts. So the question was aiming more at practical experience and
stability...

>> - What happens in step 5 and how long does it take? (If it is withou=
t
>> reshaping, it should only upgrade superblocks and thats it.)
>
> That is my understanding.
>
>
>>
>> - What happens if I dont remove spare S before migration back to
>> RAID5? Will the array be reshaped and which drive will it make into
>> spare? (If step 5 is instantaneous, there is no reason for that. But
>> if it takes time, it is probably safer.)
>>
>
> I /think/ that the extra disk will turn into a hot spare. =A0But I am=
 getting
> out of my depth here - it all depends on how the disks get numbered a=
nd how
> that affects the layout, and I don't know the details here.
>
>
>> So all and alll, what guys do you think is more reliable now, new
>> hot-replace or these steps?
>
>
> I too am very curious to hear opinions. =A0Hot-replace will certainly=
 be much
> simpler and faster than these sorts of re-shaping - it's exactly the =
sort of
> situation the feature was designed for. =A0But I don't know if it is
> considered stable and well-tested, or "bleeding edge".
>
> mvh.,
>
> David
>
>
>
>>
>> Thanks.
>>
>> Patrik
>>
>> On Wed, May 9, 2012 at 8:09 AM, David Brown<david.brown@hesbynett.no=
>
>> =A0wrote:
>>> On 08/05/12 11:10, Patrik Horn=EDk wrote:
>>>>
>>>> Hello guys,
>>>>
>>>> I need to replace drive in big production RAID5 array and I am
>>>> thinking about using new hot-replace feature added in kernel 3.3.
>>>>
>>>> Does someone have experience with it on big RAID5 arrays? Mine is =
7 *
>>>> 1.5 TB. What do you think about its status / stability / reliabili=
ty?
>>>> Do you recommend it on production data?
>>>>
>>>> Thanks.
>>>>
>>>
>>> If you don't want to play with the "bleeding edge" features, you co=
uld
>>> add
>>> the disk and extend the array to RAID6, then remove the old drive. =
I
>>> think
>>> if you want to do it all without doing any re-shapes, however, then=
 you'd
>>> need a third drive (the extra drive could easily be an external USB=
 disk
>>> if
>>> needed - it will only be used for writing, and not for reading unle=
ss
>>> there's another disk failure). =A0Start by adding the extra drive a=
s a hot
>>> spare, then re-shape your raid5 to raid6 in raid5+extra parity layo=
ut.
>>> =A0Then
>>> fail and remove the old drive. =A0Put the new drive into the box an=
d add it
>>> as
>>> a hot spare. =A0It should automatically take its place in the raid5=
,
>>> replacing
>>> the old one. =A0Once it has been rebuilt, you can fail and remove t=
he extra
>>> drive, then re-shape back to raid5.
>>>
>>> If things go horribly wrong, the external drive gives you your pari=
ty
>>> protection.
>>>
>>> Of course, don't follow this plan until others here have commented =
on it,
>>> and either corrected or approved it.
>>>
>>> And make sure you have a good backup no matter what you decide to d=
o.
>>>
>>> mvh.,
>>>
>>> David
>>>
>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
