From: Michael Busby <michael.a.busby@gmail.com>
Subject: Re: Converting from Raid 5 to 6
Date: Mon, 2 Dec 2013 15:07:57 +0000
Message-ID: <2042216353575894098@unknownmsgid>
References: <CAFsPQ_85omy81WkxKkFg+OCGmdD7A+UtyKo64qMLZBBVKpbBDw@mail.gmail.com>
 <CADNH=7H90HX58zh8mSH54FdFgh46umEscj89t372PZjj9DnHtg@mail.gmail.com>
 <CAFsPQ__G3j3CbMDJyYO7BaJrxnPi=MAZFiRfgbruzMhiCVQYag@mail.gmail.com>
 <20111025071443.4c497656@notabene.brown> <CAFsPQ_9UBtLJX_5KZSVxiQfM7+mBnU1=8P_nNLmUKo7vHcQypQ@mail.gmail.com>
 <20111025073908.6d754588@notabene.brown> <CAFsPQ_-9BU_x_VKJSThTNhmQrcYZaoyJTfWgyGKVjhtEVe5-oA@mail.gmail.com>
 <CAFsPQ_87o6mB9jAP-bXRjyjWvOeb17-ke2fJCJOqeKQumoksiA@mail.gmail.com> <20131202165127.0fe2dd5f@notabene.brown>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131202165127.0fe2dd5f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Using -f seems to have worked just running e2fsck now

When running a command like mdadm --assemble -- force --verbose
/dev/md0 /dev/sa[abcde] how important it the drive order?


Sent from my iPad

> On 2 Dec 2013, at 05:51 am, NeilBrown <neilb@suse.de> wrote:
>
> On Sat, 30 Nov 2013 22:13:58 +0000 Michael Busby <michael.a.busby@gma=
il.com>
> wrote:
>
>> Sorry to bring up a old thread, last night i had a power cut and thi=
s
>> morning when the power has come back i have tried to boot the server=
,
>> but the raid will not assemble on using a live CD i have found that
>> one of the disk is reporting "possibly out of date" is there any way
>> to force this disk back in? the bigger problem i have is that my
>> external caddie has died so i was running a degraded raid 6 but now =
it
>> is only starting with 4 out of 6 devices. is there anyway to get thi=
s
>> back?
>
> It's really hard to know what is possible without precise details.
> Output of "mdadm -E" for each member device is always a good idea.
> If you are having trouble assembling, then output of the assemble com=
mand
> with -vv added never goes astray.
> Have you tried adding "-f" to the assemble command.  Often helps and =
is
> unlikely to hurt.
>
>>
>> i have though about recreating the array using the --assume-clean
>> option but not sure if that's a good idea
>
> Not a good idea except as a very last resort.
>
> NeilBrown
>
>
>>
>> any help will be much appreciated
>>
>>
>>
>>> On 24 October 2011 21:47, Michael Busby <michael.a.busby@gmail.com>=
 wrote:
>>>
>>> I was sure i added the device before, but when rebooted the system =
it
>>> has seemed to lose the extra drive and i had already restarted the
>>> grow command with out checking the disk was there, so more than lik=
ely
>>> a mistake by me
>>>
>>>
>>>
>>>> On 24 October 2011 21:39, NeilBrown <neilb@suse.de> wrote:
>>>> On Mon, 24 Oct 2011 21:19:22 +0100 Michael Busby <michael.a.busby@=
gmail.com>
>>>> wrote:
>>>>
>>>>> Ok thanks, i have 1 small issue, when added the extra disk its be=
en
>>>>> maked as spare, is this normal?
>>>>>
>>>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [rai=
d5]
>>>>> [raid4] [raid10]
>>>>> md0 : active raid6 sde[0] sdg[6](S) sda[4] sdb[3] sdd[2] sdc[1]
>>>>>      7814055936 blocks super 1.0 level 6, 512k chunk, algorithm 1=
8
>>>>> [6/5] [UUUUU_]
>>>>>      [>....................]  reshape =3D  3.0% (59244544/1953513=
984)
>>>>> finish=3D11122.8min speed=3D2837K/sec
>>>>
>>>> It looks like the extra drive was added after you started the grow=
=2E
>>>>
>>>> So it is still a spare.
>>>> Once the grow finishes you will have a singly-degraded RAID6.
>>>> Then it will immediately start recovering the missing device to th=
e spare.
>>>>
>>>> Did you add the extra drive after starting the grow - or before??
>>>>
>>>> NeilBrown
>>>
>>>
>>>>
>>>>>
>>>>>
>>>>>
>>>>>> On 24 October 2011 21:14, NeilBrown <neilb@suse.de> wrote:
>>>>>> On Mon, 24 Oct 2011 17:03:46 +0100 Michael Busby <michael.a.busb=
y@gmail.com>
>>>>>> wrote:
>>>>>>
>>>>>>> should the speed be very slow when doing this progress, its a l=
ot
>>>>>>> slower than a normal grow
>>>>>>
>>>>>> Yes.
>>>>>> The array is being reshaped in-place.  i.e. data is being read f=
rom part of
>>>>>> the array, rearranged, and written back to the same part of the =
array.
>>>>>> As you can imagine, this is risky - a crash will leave an incons=
istent state.
>>>>>> Hence the backup file.  Everything in the array is first written=
 to the
>>>>>> backup file, then back to the array.  So it is slow.
>>>>>>
>>>>>> A "normal" grow is writing to somewhere where there is no valid =
data, so it
>>>>>> doesn't need the backup.
>>>>>>
>>>>>> I do have a plan to make this faster.... but I have lots of plan=
s and little
>>>>>> time.
>>>>>>
>>>>>> NeilBrown
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>>
>>>>>>> reshape =3D  1.2% (25006080/1953513984) finish=3D12481.8min spe=
ed=3D2574K/sec
>>>>>>>
>>>>>>>> On 24 October 2011 15:11, Mathias Bur=E9n <mathias.buren@gmail=
=2Ecom> wrote:
>>>>>>>>> On 24 October 2011 14:11, Michael Busby <michael.a.busby@gmai=
l.com> wrote:
>>>>>>>>> At the moment i have a raid5 setup with 5 disks, i am looking=
 to add a
>>>>>>>>> 6th disk and change from raid 5 to raid 6
>>>>>>>>>
>>>>>>>>> having looked at Neil's site i have found the following comma=
nd, and
>>>>>>>>> just want to double check this is still the recommend way of
>>>>>>>>> converting
>>>>>>>>>
>>>>>>>>> mdadm --grow /dev/md0 --level=3D6 --raid-disks=3D6 --backup-f=
ile=3D/home/md.backup
>>>>>>>>>
>>>>>>>>> also would i need to add the extra disk before or after the c=
ommand?
>>>>>>>>>
>>>>>>>>> cheers
>>>>>>>>> --
>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe lin=
ux-raid" in
>>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info=
=2Ehtml
>>>>>>>>
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> I grew my 6 disk RAID5 to a 7 disk RAID6. First, add the drive=
=2E Then
>>>>>>>> partition it as required. Then add the drive to the array (I t=
hink
>>>>>>>> it'll become a spare?). Then you can grow it.
>>>>>>>>
>>>>>>>> Make sure you're using the latest mdadm tools available.
>>>>>>>>
>>>>>>>> Regards,
>>>>>>>> Mathias
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux=
-raid" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.h=
tml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
