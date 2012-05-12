From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Hot-replace for RAID5
Date: Sat, 12 May 2012 17:56:04 +0200
Message-ID: <CAAOsTSmS6uFFe1e1y+39fxHOEFWZEsM7thcPwoeV6FTNiPkM_Q@mail.gmail.com>
References: <CAAOsTS=4+eqRJXVrw2OaYibgNTEaGxJx4x1PPN4iU49tUO9zOg@mail.gmail.com>
	<4FAB6758.5050109@hesbynett.no>
	<CAAOsTSm9RH1c6OzFdAGf8hSag35YBD5Y1SuH4Tq-4GXnWgJpAw@mail.gmail.com>
	<20120511105027.34e95833@notabene.brown>
	<CAAOsTSmi17VF2B5-4PJ9GNfxD-EQaY7LbL_8hwr1FvBoBj1VvA@mail.gmail.com>
	<4FACBCCC.4060802@hesbynett.no>
	<CAAOsTSmwcXPhHqQ3QyS0_8ijXaC3E4bGtWJn1wrwRFeUpxu8tQ@mail.gmail.com>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAOsTSmwcXPhHqQ3QyS0_8ijXaC3E4bGtWJn1wrwRFeUpxu8tQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

so I further analyzed the behaviour and I found following:

- The bottleneck cca 1.7 MB/s is probably caused by backup file on one
of the drives, that drive is utilized almost 80% according to iostat
-x and its avg queue length is almost 4 while having await under 50
ms.

- The variable speed and low speeds down to 100 KB are caused by
problems on drive I suspected as problematic. Its service time is
sometimes going above 1 sec.. Total avg speed is about 0.8 MB/s. (I
tested the read speed on it by running check of array and it worked
with 30 MB/s. And because preserve should only read from it I did not
specifically test its write speed )

So my questions are:

- Is there a way I can move backup_file to other drive 100% safely? To
add another non-network drive I need to restart the server. I can boot
it then to some live distribution for example to 100% prevent
automatic assembly. I think speed should be couple of times higher.

- Is it safe to fail and remove problematic drive? The array will be
down to 6 from 8 drives in part where it is not reshaped. It should
double the speed.

- Why mdadm did ignore layout=3Dpreserve? I have other arrays in that
server in which I need replace the drive.

Thanks.

Patrik

On Sat, May 12, 2012 at 6:40 AM, Patrik Horn=EDk <patrik@dsl.sk> wrote:
> Neil, the migration to RAID6 is unfortunately not working as expected=
=2E
>
> I added spare and used command mdadm --grow /dev/md6 --level 6
> --layout=3Dpreserve, but I guess it ignored layout preserve.
>
> It asked for backup_file and now it is writing the same amount of dat=
a
> on all drives. I maybe can live with that, even if that is little
> risky because I suspect one of the drives is not OK. But the problem
> is I thought backup_file is only for some critical section, so I gave
> it backup_file located on one of the drives used in the array. It is
> of course not on a partition in the array, but it seems it is the I/O
> bottleneck. The speed of reshaping is not constant and varies between
> 100 K/s and 1.6 MB/s and it seems it will take more than a week maybe
> two.
>
> It is kernel 3.2.0 amd64 and mdadm 3.2.2 from squezee backports, it
> was seven and now it is eight drives.
>
> What additional info you need to diagnose the problem? I am not yet
> 100% sure the botlleneck is backup file, but it looks like it from
> iostat -d. Is there anything I can do about that? (Like stoping the
> reshaping and changing the backup file. To do that I need to restart
> server and I need the operation was 100% safe.)
>
> Here is output of detail:
>
> =A0Version : 0.91
> =A0Creation Time : Tue Aug 18 14:51:41 2009
> =A0 =A0 Raid Level : raid6
> =A0 =A0 Array Size : 2933388288 (2797.50 GiB 3003.79 GB)
> =A0Used Dev Size : 488898048 (466.25 GiB 500.63 GB)
> =A0 Raid Devices : 8
> =A0Total Devices : 8
> Preferred Minor : 6
> =A0 =A0Persistence : Superblock is persistent
>
> =A0 =A0Update Time : Sat May 12 06:37:48 2012
> =A0 =A0 =A0 =A0 =A0State : clean, degraded, reshaping
> =A0Active Devices : 7
> Working Devices : 8
> =A0Failed Devices : 0
> =A0Spare Devices : 1
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric-6
> =A0 =A0 Chunk Size : 64K
>
> =A0Reshape Status : 0% complete
> =A0 =A0 New Layout : left-symmetric
>
> =A0 =A0 =A0 =A0 =A0 UUID : d8e679a2:5d6fa7a7:2e406ee4:439be8d3
> =A0 =A0 =A0 =A0 Events : 0.983549
>
> =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> =A0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0115 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdh3
> =A0 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 67 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sde3
> =A0 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 99 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdg3
> =A0 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 83 =A0 =A0 =A0 =A03 =A0 =A0 =A0=
active sync =A0 /dev/sdf3
> =A0 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 =A03 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sda3
> =A0 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 19 =A0 =A0 =A0 =A05 =A0 =A0 =A0=
active sync =A0 /dev/sdb3
> =A0 =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0 35 =A0 =A0 =A0 =A06 =A0 =A0 =A0=
active sync =A0 /dev/sdc3
> =A0 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0 51 =A0 =A0 =A0 =A07 =A0 =A0 =A0=
spare rebuilding =A0 /dev/sdd3
>
>
> Patrik
>
>
> On Fri, May 11, 2012 at 9:16 AM, David Brown <david.brown@hesbynett.n=
o> wrote:
>> Just in case you missed it earlier...
>>
>> Remember to take a backup before you start this!
>>
>> Also make notes of things like the "mdadm --detail", version numbers=
, the
>> exact commands executed, etc. (and store this information on another
>> computer!) =A0If something does go wrong, then that information can =
make it
>> much easier for Neil or others to advise you.
>>
>> mvh.,
>>
>> David
>>
>>
>>
>> On 11/05/2012 04:44, Patrik Horn=EDk wrote:
>>>
>>> On Fri, May 11, 2012 at 2:50 AM, NeilBrown<neilb@suse.de> =A0wrote:
>>>>
>>>> On Thu, 10 May 2012 19:16:59 +0200 Patrik Horn=EDk<patrik@dsl.sk> =
=A0wrote:
>>>>
>>>>> Neil, can you please comment if separate operations mentioned in =
this
>>>>> process are behaving and are stable enough as we expect? Thanks.
>>>>
>>>>
>>>> The conversion to and from RAID6 as described should work as expec=
ted,
>>>> though
>>>> it requires having an extra device and requires to 'recovery' cycl=
es.
>>>> Specifying the number of --raid-devices is not necessary. =A0When =
you
>>>> convert
>>>> RAID5 to RAID6, mdadm assumes you are increasing number of devices=
 by 1
>>>> unless you say otherwise. =A0Similarly with RAID6->RAID5 the assum=
ption is
>>>> a
>>>> decrease by 1.
>>>>
>>>> Doing an in-place reshape with the new 3.3 code should work, thoug=
h with
>>>> a
>>>> softer "should" than above. =A0We will only know that it is "stabl=
e" when
>>>> enough
>>>> people (such as yourself) try it and report success. =A0If anythin=
g does go
>>>> wrong I would of course help you to put the array back together bu=
t I can
>>>> never guarantee no data loss. =A0You wouldn't be the first to test=
 the code
>>>> on
>>>> live data, but you would be the second that I have heard of.
>>>
>>>
>>> Thanks Neil, this answers my questions. I dont like being second, s=
o
>>> RAID5 - RAID6 - RAID5 it is... :)
>>>
>>> In addition my array has 0.9 metadata so hot-replace would also
>>> require conversion of metadata, so all together it seems much riski=
er.
>>>
>>>> The in-place reshape is not yet supported by mdadm but it is very =
easy to
>>>> manage directly. =A0Just
>>>> =A0 echo replaceable> =A0/sys/block/mdXXX/md/dev-YYY/state
>>>> and as soon as a spare is available the replacement will happen.
>>>>
>>>> NeilBrown
>>>>
>>>>
>>>>>
>>>>> On Thu, May 10, 2012 at 8:59 AM, David Brown<david.brown@hesbynet=
t.no>
>>>>> =A0wrote:
>>>>>>
>>>>>> (I accidentally sent my first reply directly to the OP, and forg=
ot the
>>>>>> mailing list - I'm adding it back now, because I don't want the =
OP to
>>>>>> follow
>>>>>> my advice until others have confirmed or corrected it!)
>>>>>>
>>>>>>
>>>>>> On 09/05/2012 21:53, Patrik Horn=EDk wrote:
>>>>>>>
>>>>>>> Great suggestion, thanks.
>>>>>>>
>>>>>>> So I guess steps with exact parameters should be:
>>>>>>> 1, add spare S to RAID5 array
>>>>>>> 2, mdadm --grow /dev/mdX --level 6 --raid-devices N+1
>>>>>>> --layout=3Dpreserve
>>>>>>> 3, remove faulty drive and add replacement, let it synchronize
>>>>>>> 4, possibly remove added spare S
>>>>>>> 5, mdadm --grow /dev/mdX --level 5 --raid-devices N
>>>>>>
>>>>>>
>>>>>>
>>>>>> Yes, that's what I was thinking. =A0You are missing "2b - let it
>>>>>> synchronise".
>>>>>
>>>>>
>>>>> Sure :)
>>>>>
>>>>>> Of course, another possibility is that if you have the space in =
the
>>>>>> system
>>>>>> for another drive, you may want to convert to a full raid6 for t=
he
>>>>>> future.
>>>>>> =A0That way you have the extra safety built-in in advance. But t=
hat will
>>>>>> definitely lead to a re-shape.
>>>>>
>>>>>
>>>>> Actually I dont have free physical space, array already has 7 dri=
ves.
>>>>> For the process I need place the additional drive on table near t=
he PC
>>>>> and cool it with fan standing by itself on table... :)
>>>>>
>>>>>>>
>>>>>>> My questions:
>>>>>>> - Are you sure steps 3, 4 and 5 would not cause reshaping?
>>>>>>
>>>>>>
>>>>>> I /believe/ it will avoid a reshape, but I can't say I'm sure. =A0=
This is
>>>>>> stuff that I only know about in theory, and have not tried in pr=
actice.
>>>>>>
>>>>>>
>>>>>>>
>>>>>>> - My array has now left-symmetric layout, so after migration to=
 RAID6
>>>>>>> it should be left-symmetric-6. Is RAID6 working without problem=
 in
>>>>>>> degraded mode with this layout, no matter which one or two driv=
es are
>>>>>>> missing?
>>>>>>>
>>>>>>
>>>>>> The layout will not affect the redundancy or the features of the=
 raid -
>>>>>> it
>>>>>> will only (slightly) affect the speed of some operations.
>>>>>
>>>>>
>>>>> I know it should work, but it is probably configuration that is n=
ot
>>>>> used much by users, so maybe it is not tested as much as standard
>>>>> layouts. So the question was aiming more at practical experience =
and
>>>>> stability...
>>>>>
>>>>>>> - What happens in step 5 and how long does it take? (If it is w=
ithout
>>>>>>> reshaping, it should only upgrade superblocks and thats it.)
>>>>>>
>>>>>>
>>>>>> That is my understanding.
>>>>>>
>>>>>>
>>>>>>>
>>>>>>> - What happens if I dont remove spare S before migration back t=
o
>>>>>>> RAID5? Will the array be reshaped and which drive will it make =
into
>>>>>>> spare? (If step 5 is instantaneous, there is no reason for that=
=2E But
>>>>>>> if it takes time, it is probably safer.)
>>>>>>>
>>>>>>
>>>>>> I /think/ that the extra disk will turn into a hot spare. =A0But=
 I am
>>>>>> getting
>>>>>> out of my depth here - it all depends on how the disks get numbe=
red and
>>>>>> how
>>>>>> that affects the layout, and I don't know the details here.
>>>>>>
>>>>>>
>>>>>>> So all and alll, what guys do you think is more reliable now, n=
ew
>>>>>>> hot-replace or these steps?
>>>>>>
>>>>>>
>>>>>>
>>>>>> I too am very curious to hear opinions. =A0Hot-replace will cert=
ainly be
>>>>>> much
>>>>>> simpler and faster than these sorts of re-shaping - it's exactly=
 the
>>>>>> sort of
>>>>>> situation the feature was designed for. =A0But I don't know if i=
t is
>>>>>> considered stable and well-tested, or "bleeding edge".
>>>>>>
>>>>>> mvh.,
>>>>>>
>>>>>> David
>>>>>>
>>>>>>
>>>>>>
>>>>>>>
>>>>>>> Thanks.
>>>>>>>
>>>>>>> Patrik
>>>>>>>
>>>>>>> On Wed, May 9, 2012 at 8:09 AM, David Brown<david.brown@hesbyne=
tt.no>
>>>>>>> =A0wrote:
>>>>>>>>
>>>>>>>> On 08/05/12 11:10, Patrik Horn=EDk wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Hello guys,
>>>>>>>>>
>>>>>>>>> I need to replace drive in big production RAID5 array and I a=
m
>>>>>>>>> thinking about using new hot-replace feature added in kernel =
3.3.
>>>>>>>>>
>>>>>>>>> Does someone have experience with it on big RAID5 arrays? Min=
e is 7
>>>>>>>>> *
>>>>>>>>> 1.5 TB. What do you think about its status / stability /
>>>>>>>>> reliability?
>>>>>>>>> Do you recommend it on production data?
>>>>>>>>>
>>>>>>>>> Thanks.
>>>>>>>>>
>>>>>>>>
>>>>>>>> If you don't want to play with the "bleeding edge" features, y=
ou
>>>>>>>> could
>>>>>>>> add
>>>>>>>> the disk and extend the array to RAID6, then remove the old dr=
ive. I
>>>>>>>> think
>>>>>>>> if you want to do it all without doing any re-shapes, however,=
 then
>>>>>>>> you'd
>>>>>>>> need a third drive (the extra drive could easily be an externa=
l USB
>>>>>>>> disk
>>>>>>>> if
>>>>>>>> needed - it will only be used for writing, and not for reading=
 unless
>>>>>>>> there's another disk failure). =A0Start by adding the extra dr=
ive as a
>>>>>>>> hot
>>>>>>>> spare, then re-shape your raid5 to raid6 in raid5+extra parity
>>>>>>>> layout.
>>>>>>>> =A0Then
>>>>>>>> fail and remove the old drive. =A0Put the new drive into the b=
ox and
>>>>>>>> add it
>>>>>>>> as
>>>>>>>> a hot spare. =A0It should automatically take its place in the =
raid5,
>>>>>>>> replacing
>>>>>>>> the old one. =A0Once it has been rebuilt, you can fail and rem=
ove the
>>>>>>>> extra
>>>>>>>> drive, then re-shape back to raid5.
>>>>>>>>
>>>>>>>> If things go horribly wrong, the external drive gives you your=
 parity
>>>>>>>> protection.
>>>>>>>>
>>>>>>>> Of course, don't follow this plan until others here have comme=
nted on
>>>>>>>> it,
>>>>>>>> and either corrected or approved it.
>>>>>>>>
>>>>>>>> And make sure you have a good backup no matter what you decide=
 to do.
>>>>>>>>
>>>>>>>> mvh.,
>>>>>>>>
>>>>>>>> David
>>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>
>>>>
>>>
>>>
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
