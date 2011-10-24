From: Michael Busby <michael.a.busby@gmail.com>
Subject: Re: Converting from Raid 5 to 6
Date: Mon, 24 Oct 2011 21:47:19 +0100
Message-ID: <CAFsPQ_-9BU_x_VKJSThTNhmQrcYZaoyJTfWgyGKVjhtEVe5-oA@mail.gmail.com>
References: <CAFsPQ_85omy81WkxKkFg+OCGmdD7A+UtyKo64qMLZBBVKpbBDw@mail.gmail.com>
	<CADNH=7H90HX58zh8mSH54FdFgh46umEscj89t372PZjj9DnHtg@mail.gmail.com>
	<CAFsPQ__G3j3CbMDJyYO7BaJrxnPi=MAZFiRfgbruzMhiCVQYag@mail.gmail.com>
	<20111025071443.4c497656@notabene.brown>
	<CAFsPQ_9UBtLJX_5KZSVxiQfM7+mBnU1=8P_nNLmUKo7vHcQypQ@mail.gmail.com>
	<20111025073908.6d754588@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111025073908.6d754588@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was sure i added the device before, but when rebooted the system it
has seemed to lose the extra drive and i had already restarted the
grow command with out checking the disk was there, so more than likely
a mistake by me



On 24 October 2011 21:39, NeilBrown <neilb@suse.de> wrote:
> On Mon, 24 Oct 2011 21:19:22 +0100 Michael Busby <michael.a.busby@gma=
il.com>
> wrote:
>
>> Ok thanks, i have 1 small issue, when added the extra disk its been
>> maked as spare, is this normal?
>>
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md0 : active raid6 sde[0] sdg[6](S) sda[4] sdb[3] sdd[2] sdc[1]
>> =A0 =A0 =A0 7814055936 blocks super 1.0 level 6, 512k chunk, algorit=
hm 18
>> [6/5] [UUUUU_]
>> =A0 =A0 =A0 [>....................] =A0reshape =3D =A03.0% (59244544=
/1953513984)
>> finish=3D11122.8min speed=3D2837K/sec
>>
>
> It looks like the extra drive was added after you started the grow.
>
> So it is still a spare.
> Once the grow finishes you will have a singly-degraded RAID6.
> Then it will immediately start recovering the missing device to the s=
pare.
>
> Did you add the extra drive after starting the grow - or before??
>
> NeilBrown
>
>


>
>>
>>
>>
>> On 24 October 2011 21:14, NeilBrown <neilb@suse.de> wrote:
>> > On Mon, 24 Oct 2011 17:03:46 +0100 Michael Busby <michael.a.busby@=
gmail.com>
>> > wrote:
>> >
>> >> should the speed be very slow when doing this progress, its a lot
>> >> slower than a normal grow
>> >
>> > Yes.
>> > The array is being reshaped in-place. =A0i.e. data is being read f=
rom part of
>> > the array, rearranged, and written back to the same part of the ar=
ray.
>> > As you can imagine, this is risky - a crash will leave an inconsis=
tent state.
>> > Hence the backup file. =A0Everything in the array is first written=
 to the
>> > backup file, then back to the array. =A0So it is slow.
>> >
>> > A "normal" grow is writing to somewhere where there is no valid da=
ta, so it
>> > doesn't need the backup.
>> >
>> > I do have a plan to make this faster.... but I have lots of plans =
and little
>> > time.
>> >
>> > NeilBrown
>> >
>> >
>> >
>> >
>> >>
>> >> reshape =3D =A01.2% (25006080/1953513984) finish=3D12481.8min spe=
ed=3D2574K/sec
>> >>
>> >> On 24 October 2011 15:11, Mathias Bur=E9n <mathias.buren@gmail.co=
m> wrote:
>> >> > On 24 October 2011 14:11, Michael Busby <michael.a.busby@gmail.=
com> wrote:
>> >> >> At the moment i have a raid5 setup with 5 disks, i am looking=A0=
to add a
>> >> >> 6th disk and change from raid 5 to raid 6
>> >> >>
>> >> >> having looked at Neil's site i have found the following comman=
d, and
>> >> >> just want to double check this is still the recommend way of
>> >> >> converting
>> >> >>
>> >> >> mdadm --grow /dev/md0 --level=3D6 --raid-disks=3D6 --backup-fi=
le=3D/home/md.backup
>> >> >>
>> >> >> also would i need to add the extra disk before or after the co=
mmand?
>> >> >>
>> >> >> cheers
>> >> >> --
>> >> >> To unsubscribe from this list: send the line "unsubscribe linu=
x-raid" in
>> >> >> the body of a message to majordomo@vger.kernel.org
>> >> >> More majordomo info at =A0http://vger.kernel.org/majordomo-inf=
o.html
>> >> >>
>> >> >
>> >> > Hi,
>> >> >
>> >> > I grew my 6 disk RAID5 to a 7 disk RAID6. First, add the drive.=
 Then
>> >> > partition it as required. Then add the drive to the array (I th=
ink
>> >> > it'll become a spare?). Then you can grow it.
>> >> >
>> >> > Make sure you're using the latest mdadm tools available.
>> >> >
>> >> > Regards,
>> >> > Mathias
>> >> >
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-r=
aid" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>> >
>> >
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
