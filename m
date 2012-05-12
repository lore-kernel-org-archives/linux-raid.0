From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Hot-replace for RAID5
Date: Sat, 12 May 2012 06:40:54 +0200
Message-ID: <CAAOsTSmwcXPhHqQ3QyS0_8ijXaC3E4bGtWJn1wrwRFeUpxu8tQ@mail.gmail.com>
References: <CAAOsTS=4+eqRJXVrw2OaYibgNTEaGxJx4x1PPN4iU49tUO9zOg@mail.gmail.com>
	<4FAB6758.5050109@hesbynett.no>
	<CAAOsTSm9RH1c6OzFdAGf8hSag35YBD5Y1SuH4Tq-4GXnWgJpAw@mail.gmail.com>
	<20120511105027.34e95833@notabene.brown>
	<CAAOsTSmi17VF2B5-4PJ9GNfxD-EQaY7LbL_8hwr1FvBoBj1VvA@mail.gmail.com>
	<4FACBCCC.4060802@hesbynett.no>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FACBCCC.4060802@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil, the migration to RAID6 is unfortunately not working as expected.

I added spare and used command mdadm --grow /dev/md6 --level 6
--layout=3Dpreserve, but I guess it ignored layout preserve.

It asked for backup_file and now it is writing the same amount of data
on all drives. I maybe can live with that, even if that is little
risky because I suspect one of the drives is not OK. But the problem
is I thought backup_file is only for some critical section, so I gave
it backup_file located on one of the drives used in the array. It is
of course not on a partition in the array, but it seems it is the I/O
bottleneck. The speed of reshaping is not constant and varies between
100 K/s and 1.6 MB/s and it seems it will take more than a week maybe
two.

It is kernel 3.2.0 amd64 and mdadm 3.2.2 from squezee backports, it
was seven and now it is eight drives.

What additional info you need to diagnose the problem? I am not yet
100% sure the botlleneck is backup file, but it looks like it from
iostat -d. Is there anything I can do about that? (Like stoping the
reshaping and changing the backup file. To do that I need to restart
server and I need the operation was 100% safe.)

Here is output of detail:

 Version : 0.91
  Creation Time : Tue Aug 18 14:51:41 2009
     Raid Level : raid6
     Array Size : 2933388288 (2797.50 GiB 3003.79 GB)
  Used Dev Size : 488898048 (466.25 GiB 500.63 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 6
    Persistence : Superblock is persistent

    Update Time : Sat May 12 06:37:48 2012
          State : clean, degraded, reshaping
 Active Devices : 7
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric-6
     Chunk Size : 64K

 Reshape Status : 0% complete
     New Layout : left-symmetric

           UUID : d8e679a2:5d6fa7a7:2e406ee4:439be8d3
         Events : 0.983549

    Number   Major   Minor   RaidDevice State
       0       8      115        0      active sync   /dev/sdh3
       1       8       67        1      active sync   /dev/sde3
       2       8       99        2      active sync   /dev/sdg3
       3       8       83        3      active sync   /dev/sdf3
       4       8        3        4      active sync   /dev/sda3
       5       8       19        5      active sync   /dev/sdb3
       6       8       35        6      active sync   /dev/sdc3
       7       8       51        7      spare rebuilding   /dev/sdd3


Patrik


On Fri, May 11, 2012 at 9:16 AM, David Brown <david.brown@hesbynett.no>=
 wrote:
> Just in case you missed it earlier...
>
> Remember to take a backup before you start this!
>
> Also make notes of things like the "mdadm --detail", version numbers,=
 the
> exact commands executed, etc. (and store this information on another
> computer!) =A0If something does go wrong, then that information can m=
ake it
> much easier for Neil or others to advise you.
>
> mvh.,
>
> David
>
>
>
> On 11/05/2012 04:44, Patrik Horn=EDk wrote:
>>
>> On Fri, May 11, 2012 at 2:50 AM, NeilBrown<neilb@suse.de> =A0wrote:
>>>
>>> On Thu, 10 May 2012 19:16:59 +0200 Patrik Horn=EDk<patrik@dsl.sk> =A0=
wrote:
>>>
>>>> Neil, can you please comment if separate operations mentioned in t=
his
>>>> process are behaving and are stable enough as we expect? Thanks.
>>>
>>>
>>> The conversion to and from RAID6 as described should work as expect=
ed,
>>> though
>>> it requires having an extra device and requires to 'recovery' cycle=
s.
>>> Specifying the number of --raid-devices is not necessary. =A0When y=
ou
>>> convert
>>> RAID5 to RAID6, mdadm assumes you are increasing number of devices =
by 1
>>> unless you say otherwise. =A0Similarly with RAID6->RAID5 the assump=
tion is
>>> a
>>> decrease by 1.
>>>
>>> Doing an in-place reshape with the new 3.3 code should work, though=
 with
>>> a
>>> softer "should" than above. =A0We will only know that it is "stable=
" when
>>> enough
>>> people (such as yourself) try it and report success. =A0If anything=
 does go
>>> wrong I would of course help you to put the array back together but=
 I can
>>> never guarantee no data loss. =A0You wouldn't be the first to test =
the code
>>> on
>>> live data, but you would be the second that I have heard of.
>>
>>
>> Thanks Neil, this answers my questions. I dont like being second, so
>> RAID5 - RAID6 - RAID5 it is... :)
>>
>> In addition my array has 0.9 metadata so hot-replace would also
>> require conversion of metadata, so all together it seems much riskie=
r.
>>
>>> The in-place reshape is not yet supported by mdadm but it is very e=
asy to
>>> manage directly. =A0Just
>>> =A0 echo replaceable> =A0/sys/block/mdXXX/md/dev-YYY/state
>>> and as soon as a spare is available the replacement will happen.
>>>
>>> NeilBrown
>>>
>>>
>>>>
>>>> On Thu, May 10, 2012 at 8:59 AM, David Brown<david.brown@hesbynett=
=2Eno>
>>>> =A0wrote:
>>>>>
>>>>> (I accidentally sent my first reply directly to the OP, and forgo=
t the
>>>>> mailing list - I'm adding it back now, because I don't want the O=
P to
>>>>> follow
>>>>> my advice until others have confirmed or corrected it!)
>>>>>
>>>>>
>>>>> On 09/05/2012 21:53, Patrik Horn=EDk wrote:
>>>>>>
>>>>>> Great suggestion, thanks.
>>>>>>
>>>>>> So I guess steps with exact parameters should be:
>>>>>> 1, add spare S to RAID5 array
>>>>>> 2, mdadm --grow /dev/mdX --level 6 --raid-devices N+1
>>>>>> --layout=3Dpreserve
>>>>>> 3, remove faulty drive and add replacement, let it synchronize
>>>>>> 4, possibly remove added spare S
>>>>>> 5, mdadm --grow /dev/mdX --level 5 --raid-devices N
>>>>>
>>>>>
>>>>>
>>>>> Yes, that's what I was thinking. =A0You are missing "2b - let it
>>>>> synchronise".
>>>>
>>>>
>>>> Sure :)
>>>>
>>>>> Of course, another possibility is that if you have the space in t=
he
>>>>> system
>>>>> for another drive, you may want to convert to a full raid6 for th=
e
>>>>> future.
>>>>> =A0That way you have the extra safety built-in in advance. But th=
at will
>>>>> definitely lead to a re-shape.
>>>>
>>>>
>>>> Actually I dont have free physical space, array already has 7 driv=
es.
>>>> For the process I need place the additional drive on table near th=
e PC
>>>> and cool it with fan standing by itself on table... :)
>>>>
>>>>>>
>>>>>> My questions:
>>>>>> - Are you sure steps 3, 4 and 5 would not cause reshaping?
>>>>>
>>>>>
>>>>> I /believe/ it will avoid a reshape, but I can't say I'm sure. =A0=
This is
>>>>> stuff that I only know about in theory, and have not tried in pra=
ctice.
>>>>>
>>>>>
>>>>>>
>>>>>> - My array has now left-symmetric layout, so after migration to =
RAID6
>>>>>> it should be left-symmetric-6. Is RAID6 working without problem =
in
>>>>>> degraded mode with this layout, no matter which one or two drive=
s are
>>>>>> missing?
>>>>>>
>>>>>
>>>>> The layout will not affect the redundancy or the features of the =
raid -
>>>>> it
>>>>> will only (slightly) affect the speed of some operations.
>>>>
>>>>
>>>> I know it should work, but it is probably configuration that is no=
t
>>>> used much by users, so maybe it is not tested as much as standard
>>>> layouts. So the question was aiming more at practical experience a=
nd
>>>> stability...
>>>>
>>>>>> - What happens in step 5 and how long does it take? (If it is wi=
thout
>>>>>> reshaping, it should only upgrade superblocks and thats it.)
>>>>>
>>>>>
>>>>> That is my understanding.
>>>>>
>>>>>
>>>>>>
>>>>>> - What happens if I dont remove spare S before migration back to
>>>>>> RAID5? Will the array be reshaped and which drive will it make i=
nto
>>>>>> spare? (If step 5 is instantaneous, there is no reason for that.=
 But
>>>>>> if it takes time, it is probably safer.)
>>>>>>
>>>>>
>>>>> I /think/ that the extra disk will turn into a hot spare. =A0But =
I am
>>>>> getting
>>>>> out of my depth here - it all depends on how the disks get number=
ed and
>>>>> how
>>>>> that affects the layout, and I don't know the details here.
>>>>>
>>>>>
>>>>>> So all and alll, what guys do you think is more reliable now, ne=
w
>>>>>> hot-replace or these steps?
>>>>>
>>>>>
>>>>>
>>>>> I too am very curious to hear opinions. =A0Hot-replace will certa=
inly be
>>>>> much
>>>>> simpler and faster than these sorts of re-shaping - it's exactly =
the
>>>>> sort of
>>>>> situation the feature was designed for. =A0But I don't know if it=
 is
>>>>> considered stable and well-tested, or "bleeding edge".
>>>>>
>>>>> mvh.,
>>>>>
>>>>> David
>>>>>
>>>>>
>>>>>
>>>>>>
>>>>>> Thanks.
>>>>>>
>>>>>> Patrik
>>>>>>
>>>>>> On Wed, May 9, 2012 at 8:09 AM, David Brown<david.brown@hesbynet=
t.no>
>>>>>> =A0wrote:
>>>>>>>
>>>>>>> On 08/05/12 11:10, Patrik Horn=EDk wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> Hello guys,
>>>>>>>>
>>>>>>>> I need to replace drive in big production RAID5 array and I am
>>>>>>>> thinking about using new hot-replace feature added in kernel 3=
=2E3.
>>>>>>>>
>>>>>>>> Does someone have experience with it on big RAID5 arrays? Mine=
 is 7
>>>>>>>> *
>>>>>>>> 1.5 TB. What do you think about its status / stability /
>>>>>>>> reliability?
>>>>>>>> Do you recommend it on production data?
>>>>>>>>
>>>>>>>> Thanks.
>>>>>>>>
>>>>>>>
>>>>>>> If you don't want to play with the "bleeding edge" features, yo=
u
>>>>>>> could
>>>>>>> add
>>>>>>> the disk and extend the array to RAID6, then remove the old dri=
ve. I
>>>>>>> think
>>>>>>> if you want to do it all without doing any re-shapes, however, =
then
>>>>>>> you'd
>>>>>>> need a third drive (the extra drive could easily be an external=
 USB
>>>>>>> disk
>>>>>>> if
>>>>>>> needed - it will only be used for writing, and not for reading =
unless
>>>>>>> there's another disk failure). =A0Start by adding the extra dri=
ve as a
>>>>>>> hot
>>>>>>> spare, then re-shape your raid5 to raid6 in raid5+extra parity
>>>>>>> layout.
>>>>>>> =A0Then
>>>>>>> fail and remove the old drive. =A0Put the new drive into the bo=
x and
>>>>>>> add it
>>>>>>> as
>>>>>>> a hot spare. =A0It should automatically take its place in the r=
aid5,
>>>>>>> replacing
>>>>>>> the old one. =A0Once it has been rebuilt, you can fail and remo=
ve the
>>>>>>> extra
>>>>>>> drive, then re-shape back to raid5.
>>>>>>>
>>>>>>> If things go horribly wrong, the external drive gives you your =
parity
>>>>>>> protection.
>>>>>>>
>>>>>>> Of course, don't follow this plan until others here have commen=
ted on
>>>>>>> it,
>>>>>>> and either corrected or approved it.
>>>>>>>
>>>>>>> And make sure you have a good backup no matter what you decide =
to do.
>>>>>>>
>>>>>>> mvh.,
>>>>>>>
>>>>>>> David
>>>>>>>
>>>>>>
>>>>>>
>>>>>
>>>
>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
