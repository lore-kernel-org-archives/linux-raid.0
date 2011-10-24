From: Michael Busby <michael.a.busby@gmail.com>
Subject: Re: Converting from Raid 5 to 6
Date: Mon, 24 Oct 2011 17:34:00 +0100
Message-ID: <CAFsPQ_-ARgDL_v6Mkh92CN1TVMZz=77uf07mfygVQY=NYtnXiA@mail.gmail.com>
References: <CAFsPQ_85omy81WkxKkFg+OCGmdD7A+UtyKo64qMLZBBVKpbBDw@mail.gmail.com>
	<CADNH=7H90HX58zh8mSH54FdFgh46umEscj89t372PZjj9DnHtg@mail.gmail.com>
	<CAFsPQ__G3j3CbMDJyYO7BaJrxnPi=MAZFiRfgbruzMhiCVQYag@mail.gmail.com>
	<CADNH=7GEL2SabyRM_FYJHyGEJ5eibobwzmH=iKzibF-Tkt25kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7GEL2SabyRM_FYJHyGEJ5eibobwzmH=iKzibF-Tkt25kw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24 October 2011 17:27, Mathias Bur=E9n <mathias.buren@gmail.com> wro=
te:
> On 24 October 2011 17:03, Michael Busby <michael.a.busby@gmail.com> w=
rote:
>> should the speed be very slow when doing this progress, its a lot
>> slower than a normal grow
>>
>> reshape =3D =A01.2% (25006080/1953513984) finish=3D12481.8min speed=3D=
2574K/sec
>>
>> On 24 October 2011 15:11, Mathias Bur=E9n <mathias.buren@gmail.com> =
wrote:
>>> On 24 October 2011 14:11, Michael Busby <michael.a.busby@gmail.com>=
 wrote:
>>>> At the moment i have a raid5 setup with 5 disks, i am looking=A0to=
 add a
>>>> 6th disk and change from raid 5 to raid 6
>>>>
>>>> having looked at Neil's site i have found the following command, a=
nd
>>>> just want to double check this is still the recommend way of
>>>> converting
>>>>
>>>> mdadm --grow /dev/md0 --level=3D6 --raid-disks=3D6 --backup-file=3D=
/home/md.backup
>>>>
>>>> also would i need to add the extra disk before or after the comman=
d?
>>>>
>>>> cheers
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>>>
>>>
>>> Hi,
>>>
>>> I grew my 6 disk RAID5 to a 7 disk RAID6. First, add the drive. The=
n
>>> partition it as required. Then add the drive to the array (I think
>>> it'll become a spare?). Then you can grow it.
>>>
>>> Make sure you're using the latest mdadm tools available.
>>>
>>> Regards,
>>> Mathias
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> (please reply to the bottom of the email)
>
> What CPU are you using? What are the min/max kbps settings on the md
> device? What does top (or htop) show you?
>
> /M
>

Its a AMD 1.3ghz, in a HP microserver

max =3D 2000000
min =3D 200000

top - 17:33:49 up 4 days, 18:57,  2 users,  load average: 1.19, 1.32, 1=
=2E34
Tasks: 102 total,   1 running, 101 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.3%us,  4.8%sy,  0.0%ni, 61.6%id, 32.9%wa,  0.0%hi,  0.3%si, =
 0.0%st
Mem:   2958840k total,  2519944k used,   438896k free,   140868k buffer=
s
Swap:  3143676k total,   376112k used,  2767564k free,  1122084k cached
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
