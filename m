From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid1 mirror optimizations
Date: Wed, 26 Jan 2011 12:18:02 -0200
Message-ID: <AANLkTincmY_qUp4xGckdgweVqg5adRF1vGY3SdtmELv8@mail.gmail.com>
References: <AANLkTimUbWcHi8w6UzxKjkavpOihV7V5Nm58mV7HA0AE@mail.gmail.com>
	<ihoqek$nu4$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ihoqek$nu4$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

nice :) i never read about it on raid 10, maybe i could use, thanks!

2011/1/26 David Brown <david@westcontrol.com>:
> On 25/01/2011 19:56, Roberto Spadim wrote:
>>
>> hi guys... i have a damaged disk...
>> i=E6=83=B4 using raid1
>> the computer crashed with the floor :P hihiih sorry, but the disks a=
re
>> damaged at the same position
>> check: http://www.spadim.com.br/hd%20agra.zip
>> the problem: since raid1 (mirror) is done with real mirror, the disk
>> position are the same...
>> if i was using a mirror but on disk 1 i write from beggining to end,
>> and disk 2 from end to beggining , i don=E6=84=92 crash the disk at =
the same
>> position, for disk 1 i crash it some bytes, for disk 2 i crash some
>> others bytes, since beggining is a small cilinder and end a bigger, =
i
>> could loose less information than mirror
>> could we implement a 'inverted' mirror? just for hard disks (for ssd
>> it=E6=84=80 a small loss of cpu/memory)
>> thanks
>>
>
> If you are worried about the disks being in the same position, then I=
 assume
> you mean the heads were in the same position when they crashed into t=
he
> disk. =C2=A0If that's the case, then it doesn't really matter too muc=
h if the
> same bytes on the disk were hit - your disks are trashed anyway, and =
you'll
> need expensive professional recovery services to deal with it.
>
> If you are not talking about head crashes, and merely about corruptio=
n
> because the disks were being written to in the same place on both dis=
ks,
> then the layout on the disk will make little difference - the same da=
ta will
> be written to the same logical place at roughly the same time. =C2=A0=
It doesn't
> matter where this data is located physically on the disk, since it is=
 the
> data that matters. =C2=A0The same thing actually applies to head cras=
hes too.
>
> If you really want an "inverted" mirror, there is an easy way to get =
much of
> the same effect. =C2=A0Instead of setting up raid1, use raid10 with "=
far 2"
> positioning. =C2=A0The effect is roughly like this:
>
> disk1 (stripe 1) (mirror of stripe 2)
> disk2 (stripe 2) (mirror of stripe 1)
>
> So the two copies of the data are in different physical positions on =
each
> disk. =C2=A0It's not a full reversal, but you can think of disk 2 as =
being split
> in two and its two halves swapped.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
