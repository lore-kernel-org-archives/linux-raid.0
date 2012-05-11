From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Hot-replace for RAID5
Date: Fri, 11 May 2012 04:44:54 +0200
Message-ID: <CAAOsTSmi17VF2B5-4PJ9GNfxD-EQaY7LbL_8hwr1FvBoBj1VvA@mail.gmail.com>
References: <CAAOsTS=4+eqRJXVrw2OaYibgNTEaGxJx4x1PPN4iU49tUO9zOg@mail.gmail.com>
	<4FAB6758.5050109@hesbynett.no>
	<CAAOsTSm9RH1c6OzFdAGf8hSag35YBD5Y1SuH4Tq-4GXnWgJpAw@mail.gmail.com>
	<20120511105027.34e95833@notabene.brown>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120511105027.34e95833@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 11, 2012 at 2:50 AM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 10 May 2012 19:16:59 +0200 Patrik Horn=EDk <patrik@dsl.sk> wr=
ote:
>
>> Neil, can you please comment if separate operations mentioned in thi=
s
>> process are behaving and are stable enough as we expect? Thanks.
>
> The conversion to and from RAID6 as described should work as expected=
, though
> it requires having an extra device and requires to 'recovery' cycles.
> Specifying the number of --raid-devices is not necessary. =A0When you=
 convert
> RAID5 to RAID6, mdadm assumes you are increasing number of devices by=
 1
> unless you say otherwise. =A0Similarly with RAID6->RAID5 the assumpti=
on is a
> decrease by 1.
>
> Doing an in-place reshape with the new 3.3 code should work, though w=
ith a
> softer "should" than above. =A0We will only know that it is "stable" =
when enough
> people (such as yourself) try it and report success. =A0If anything d=
oes go
> wrong I would of course help you to put the array back together but I=
 can
> never guarantee no data loss. =A0You wouldn't be the first to test th=
e code on
> live data, but you would be the second that I have heard of.

Thanks Neil, this answers my questions. I dont like being second, so
RAID5 - RAID6 - RAID5 it is... :)

In addition my array has 0.9 metadata so hot-replace would also
require conversion of metadata, so all together it seems much riskier.

> The in-place reshape is not yet supported by mdadm but it is very eas=
y to
> manage directly. =A0Just
> =A0 echo replaceable > /sys/block/mdXXX/md/dev-YYY/state
> and as soon as a spare is available the replacement will happen.
>
> NeilBrown
>
>
>>
>> On Thu, May 10, 2012 at 8:59 AM, David Brown <david.brown@hesbynett.=
no> wrote:
>> > (I accidentally sent my first reply directly to the OP, and forgot=
 the
>> > mailing list - I'm adding it back now, because I don't want the OP=
 to follow
>> > my advice until others have confirmed or corrected it!)
>> >
>> >
>> > On 09/05/2012 21:53, Patrik Horn=EDk wrote:
>> >> Great suggestion, thanks.
>> >>
>> >> So I guess steps with exact parameters should be:
>> >> 1, add spare S to RAID5 array
>> >> 2, mdadm --grow /dev/mdX --level 6 --raid-devices N+1 --layout=3D=
preserve
>> >> 3, remove faulty drive and add replacement, let it synchronize
>> >> 4, possibly remove added spare S
>> >> 5, mdadm --grow /dev/mdX --level 5 --raid-devices N
>> >
>> >
>> > Yes, that's what I was thinking. =A0You are missing "2b - let it s=
ynchronise".
>>
>> Sure :)
>>
>> > Of course, another possibility is that if you have the space in th=
e system
>> > for another drive, you may want to convert to a full raid6 for the=
 future.
>> > =A0That way you have the extra safety built-in in advance. But tha=
t will
>> > definitely lead to a re-shape.
>>
>> Actually I dont have free physical space, array already has 7 drives=
=2E
>> For the process I need place the additional drive on table near the =
PC
>> and cool it with fan standing by itself on table... :)
>>
>> >>
>> >> My questions:
>> >> - Are you sure steps 3, 4 and 5 would not cause reshaping?
>> >
>> > I /believe/ it will avoid a reshape, but I can't say I'm sure. =A0=
This is
>> > stuff that I only know about in theory, and have not tried in prac=
tice.
>> >
>> >
>> >>
>> >> - My array has now left-symmetric layout, so after migration to R=
AID6
>> >> it should be left-symmetric-6. Is RAID6 working without problem i=
n
>> >> degraded mode with this layout, no matter which one or two drives=
 are
>> >> missing?
>> >>
>> >
>> > The layout will not affect the redundancy or the features of the r=
aid - it
>> > will only (slightly) affect the speed of some operations.
>>
>> I know it should work, but it is probably configuration that is not
>> used much by users, so maybe it is not tested as much as standard
>> layouts. So the question was aiming more at practical experience and
>> stability...
>>
>> >> - What happens in step 5 and how long does it take? (If it is wit=
hout
>> >> reshaping, it should only upgrade superblocks and thats it.)
>> >
>> > That is my understanding.
>> >
>> >
>> >>
>> >> - What happens if I dont remove spare S before migration back to
>> >> RAID5? Will the array be reshaped and which drive will it make in=
to
>> >> spare? (If step 5 is instantaneous, there is no reason for that. =
But
>> >> if it takes time, it is probably safer.)
>> >>
>> >
>> > I /think/ that the extra disk will turn into a hot spare. =A0But I=
 am getting
>> > out of my depth here - it all depends on how the disks get numbere=
d and how
>> > that affects the layout, and I don't know the details here.
>> >
>> >
>> >> So all and alll, what guys do you think is more reliable now, new
>> >> hot-replace or these steps?
>> >
>> >
>> > I too am very curious to hear opinions. =A0Hot-replace will certai=
nly be much
>> > simpler and faster than these sorts of re-shaping - it's exactly t=
he sort of
>> > situation the feature was designed for. =A0But I don't know if it =
is
>> > considered stable and well-tested, or "bleeding edge".
>> >
>> > mvh.,
>> >
>> > David
>> >
>> >
>> >
>> >>
>> >> Thanks.
>> >>
>> >> Patrik
>> >>
>> >> On Wed, May 9, 2012 at 8:09 AM, David Brown<david.brown@hesbynett=
=2Eno>
>> >> =A0wrote:
>> >>> On 08/05/12 11:10, Patrik Horn=EDk wrote:
>> >>>>
>> >>>> Hello guys,
>> >>>>
>> >>>> I need to replace drive in big production RAID5 array and I am
>> >>>> thinking about using new hot-replace feature added in kernel 3.=
3.
>> >>>>
>> >>>> Does someone have experience with it on big RAID5 arrays? Mine =
is 7 *
>> >>>> 1.5 TB. What do you think about its status / stability / reliab=
ility?
>> >>>> Do you recommend it on production data?
>> >>>>
>> >>>> Thanks.
>> >>>>
>> >>>
>> >>> If you don't want to play with the "bleeding edge" features, you=
 could
>> >>> add
>> >>> the disk and extend the array to RAID6, then remove the old driv=
e. I
>> >>> think
>> >>> if you want to do it all without doing any re-shapes, however, t=
hen you'd
>> >>> need a third drive (the extra drive could easily be an external =
USB disk
>> >>> if
>> >>> needed - it will only be used for writing, and not for reading u=
nless
>> >>> there's another disk failure). =A0Start by adding the extra driv=
e as a hot
>> >>> spare, then re-shape your raid5 to raid6 in raid5+extra parity l=
ayout.
>> >>> =A0Then
>> >>> fail and remove the old drive. =A0Put the new drive into the box=
 and add it
>> >>> as
>> >>> a hot spare. =A0It should automatically take its place in the ra=
id5,
>> >>> replacing
>> >>> the old one. =A0Once it has been rebuilt, you can fail and remov=
e the extra
>> >>> drive, then re-shape back to raid5.
>> >>>
>> >>> If things go horribly wrong, the external drive gives you your p=
arity
>> >>> protection.
>> >>>
>> >>> Of course, don't follow this plan until others here have comment=
ed on it,
>> >>> and either corrected or approved it.
>> >>>
>> >>> And make sure you have a good backup no matter what you decide t=
o do.
>> >>>
>> >>> mvh.,
>> >>>
>> >>> David
>> >>>
>> >>
>> >>
>> >
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
