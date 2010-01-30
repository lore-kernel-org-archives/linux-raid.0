From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Growing raid 5 to 6; /proc/mdstat reports a strange value?
Date: Fri, 29 Jan 2010 23:07:51 -0800
Message-ID: <4877c76c1001292307u6432d638w810322ba1da3a379@mail.gmail.com>
References: <4877c76c1001241949p20089932saae123a1c2871ac0@mail.gmail.com>
	 <20100129232334.45a4103c@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100129232334.45a4103c@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 29, 2010 at 4:23 AM, Neil Brown <neilb@suse.de> wrote:
> On Sun, 24 Jan 2010 19:49:31 -0800
> Michael Evans <mjevans1983@gmail.com> wrote:
>
>> mdX : active raid5 sdd1[8](S) sdb1[7](S) sdf8[0] sdl8[4] sdk2[5]
>> sdc1[6] sdj6[3] sdi8[1]
>> =A0 =A0 =A0Y blocks super 1.1 level 5, 128k chunk, algorithm 2 [6/6]=
 [UUUUUU]
>>
>> # mdadm --grow /dev/mdX --level=3D6 --raid-devices=3D8
>> --backup-file=3D/root/mdX.backupfile
>>
>> mdX : active raid6 sdd1[8] sdb1[7] sdf8[0] sdl8[4] sdk2[5] sdc1[6]
>> sdj6[3] sdi8[1]
>> =A0 =A0 =A0Y blocks super 1.1 level 6, 128k chunk, algorithm 18 [8/9=
] [UUUUUU_U]
>> =A0 =A0 =A0[>....................] =A0reshape =3D =A00.0% (33920/484=
971520)
>> finish=3D952.6min speed=3D8480K/sec
>>
>> !!! mdadm 3.1.1 I wanted an 8 device raid-6; =A0Why do you show 9?
>
> That is weird isn't it. =A0It is showing that 8 devices are in the ar=
ray, of
> which 9 are working. =A0That cannot be right.
> More worrying is that the second last device claim to not be present,=
 which
> doesn't seem right.
>
>
>>
>> What is it showing me now???
>>
>> blocks super 1.1 level 6, 128k chunk, algorithm 2 [8/10] [UUUUUUUU]
>>
>
> So now of the 8 devices, 10 are working!! =A0At least all are present=
=2E
>
>
>> ... Did it actually do what I want but just show me the wrong result
>> with kernel 2.6.32-gentoo-r2
>
> Some simple testing suggests it did do what you want, but reported so=
mething
> silly in /proc/mdstat.
>
> I'll see if I can work out what is happening.
>
> Thanks for the report.
>
> NeilBrown
>
>

As a follow-up:
* Looking at the device via mdadm --detail /dev/mdX (while still
invalid in /proc/mdstat) showed the correct information.
* When I stopped and re-started the array the information in
/proc/mdstat was valid.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
