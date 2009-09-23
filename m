From: "Majed B." <majedb@gmail.com>
Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.
Date: Wed, 23 Sep 2009 03:14:17 +0300
Message-ID: <70ed7c3e0909221714n1ad1ef80oedf329f17f7dad1c@mail.gmail.com>
References: <70ed7c3e0909220823v40badc3fu4c11e8712028535b@mail.gmail.com>
	<200909221442804.SM02380@trainer>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200909221442804.SM02380@trainer>
Sender: linux-raid-owner@vger.kernel.org
To: Sunpyo Hong <sunpyo.hong@amac.com>
Cc: Robin Hill <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you are sure that you have created the array with the proper order
of disks (They MUST be in the correct order! Your disks may have
changed their names for some reason -- verify that they are in
order!!) and that you have assembled them properly, I would suggest
you run a tool called "testdisk"

You may have a corrupt filesystem, and testdisk would try to fix it.
Also, to make sure that you have assembled the array in the correct
order, and if the filesystem can't be fixed if it's corrupt, use a
file-recovery tool like foremost or magicrescue and see if they
recover your data.

On Tue, Sep 22, 2009 at 9:42 PM, Sunpyo Hong <sunpyo.hong@amac.com> wro=
te:
> Nothing showed up when I did =C2=A0"sudo lvscan". I'm pretty much stu=
mped.
>
> -----Original Message-----
> From: Majed B. [mailto:majedb@gmail.com]
> Sent: Tuesday, September 22, 2009 11:24 AM
> To: Sunpyo Hong
> Cc: Robin Hill; linux-raid@vger.kernel.org
> Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.
>
> When the array is properly assembled, "sudo lvscan" should show any
> logical volumes. Maybe even without the array assembled.
>
> If nothing shows up, then you don't have an LV configured.
>
> On Tue, Sep 22, 2009 at 6:15 PM, Sunpyo Hong <sunpyo.hong@amac.com> w=
rote:
>>> I am stopping and starting the array. I couldn't mount in both inst=
ances.
>>> The before is the initial assembly array that I force assembled thr=
ough
>>> mdadm -Af. This assembled the raid, but couldn't see an ext3 file s=
ystem.
>>
>>>I haven't followed all of this thread, so maybe I missed something,
>>>but have you considered the possibility that there is an LVM config
>>>on the md array, and that the ext3 filesystem is inside a logical
>>>volume?
>>
>>>NeilBrown
>>
>> Hi Neil, I already checked with western digital and its support team=
=2E What
>> they've told me is that the Raid is an EXT3 and is not LVM config on=
 the
> HD,
>> however knowing WD they might just say that so I'd fork over the cas=
h to
> get
>> my HD recovered for thousands of dollars from them. Is there a way I=
 can
>> check if it's LVM config-ed? Thanks!
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
>
> --
> =C2=A0 =C2=A0 =C2=A0 Majed B.
>
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
