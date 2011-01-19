From: =?UTF-8?B?U3RlZmFuIC8qU3QwZkYqLyBIw7xibmVy?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Wed, 19 Jan 2011 23:36:45 +0100
Message-ID: <4D37677D.9010108@stud.tu-ilmenau.de>
References: <20110118210112.D13A236C@gemini.denx.de>	<4D361F26.3060507@stud.tu-ilmenau.de>	<20110119192104.1FA92D30267@gemini.denx.de> <AANLkTimY8XWxnx1MZWXp2undt9J35U8vCyuCHaSF2KkJ@mail.gmail.com>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimY8XWxnx1MZWXp2undt9J35U8vCyuCHaSF2KkJ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

@Roberto: I guess you're right. BUT: i have not seen 900MB/s coming fro=
m
(i.e. read access) a software raid, but I've seen it from a 9750 on a
LSI SASx28 backplane, running RAID6 over 16disks (HDS722020ALA330).  So
one might not be wrong assuming on current raid-controllers
hardware/software matching and timing is way more optimized than what
mdraid might get at all.

The 9650 and 9690 are considerably slower, but I've seen 550MB/s thrupu=
t
from those, also (I don't recall the setup anymore, tho).

Max reading I saw from a software raid was around 350MB/s - so hence my
answers.  And if people had problems with controllers which are 5 years
or older by now, the numbers are not really comparable...

Now again there's the point where there are also parameters on the
controller that can be tweaked, and a simple way to recreate the testin=
g
scenario.  We may discuss and throw in further numbers and experience,
but not being able to recreate your specific scenario makes us talk pas=
t
each other...

stefan

Am 19.01.2011 20:50, schrieb Roberto Spadim:
> So can anybody help answering these questions:
>=20
> - are there any special options when creating the RAID0 to make it
> perform faster for such a use case?
> - are there other tunables, any special MD / LVM / file system / read
> ahead / buffer cache / ... parameters to look for?
>=20
> lets see:
> what=C2=B4s your disk (ssd or sas or sata) best block size to write/r=
ead?
> write this at ->(A)
> what=C2=B4s your work load? 50% write 50% read ?
>=20
> raid0 block size should be multiple of (A)
> *****filesystem size should be multiple of (A) of all disks
> *****read ahead should be a multiple of (A)
> for example
> /dev/sda 1kb
> /dev/sdb 4kb
>=20
> you should use 6kb... you should use 4kb, 8kb, 16kb (multiple of 1kb =
and 4kb)
>=20
> check i/o sheduller per disk too (ssd should use noop, disks should
> use cfq, deadline or another...)
> async and sync option at mount /etc/fstab, noatime reduce a lot of i/=
o
> too, you should optimize your application too
> hdparm each disk to use dma and fastest i/o options
>=20
> are you using only filesystem? are you using somethink more? samba?
> mysql? apache? lvm?
> each of this programs have some tunning, check their benchmarks
>=20
>=20
> getting back....
> what=C2=B4s a raid controller?
> cpu + memory + disk controller + disks
> but... it only run raid software (it can run linux....)
>=20
> if you computer is slower than raid cpu+memory+disk controller, you
> will have a slower software raid, than hardware raid
> it=C2=B4s like load balance on cpu/memory utilization of disk i/o (us=
e
> dedicated hardware, or use your hardware?)
> got it?
> using a super fast xeon with ddr3 and optical fiber running software
> raid, is faster than a hardware raid using a arm (or fpga) ddrX memor=
y
> and sas(fiber optical) connection to disks
>=20
> two solutions for the same problem
> what=C2=B4s fast? benchmark it
> i think that if your xeon run a database and a very workloaded apache=
,
> a dedicated hardware raid can run faster, but a light xeon can run
> faster than a dedicated hardware raid
>=20
>=20
>=20
> 2011/1/19 Wolfgang Denk <wd@denx.de>:
>> Dear =3D?ISO-8859-15?Q?Stefan_/*St0fF*/_H=3DFCbner?=3D,
>>
>> In message <4D361F26.3060507@stud.tu-ilmenau.de> you wrote:
>>>
>>> [in German:] Sch=C3=A4tzelein, Dein Problem sind die Platten, nicht=
 der
>>> Controller.
>>>
>>> [in English:] Dude, the disks are your bottleneck.
>> ...
>>
>> Maybe we can stop speculations about what might be the cause of the
>> problems in some setup I do NOT intend to use, and rather discuss th=
e
>> questions I asked.
>>
>>>> I will have 4 x 1 TB disks for this setup.
>>>>
>>>> The plan is to build a RAID0 from the 4 devices, create a physical
>>>> volume and a volume group on the resulting /dev/md?, then create 2=
 or
>>>> 3 logical volumes that will be used as XFS file systems.
>>
>> Clarrification: I'll run /dev/md* on the raw disks, without any
>> partitions on them.
>>
>>>> My goal is to optimize for maximum number of I/O operations per
>>>> second. ...
>>>>
>>>> Is this a reasonable approach for such a task?
>>>>
>>>> Should I do anything different to acchive maximum performance?
>>>>
>>>> What are the tunables in this setup?  [It seems the usual recipies=
 are
>>>> more oriented in maximizing the data troughput for large, mostly
>>>> sequential accesses - I figure that things like increasing read-ah=
ead
>>>> etc. will not help me much here?]
>>
>> So can anybody help answering these questions:
>>
>> - are there any special options when creating the RAID0 to make it
>>  perform faster for such a use case?
>> - are there other tunables, any special MD / LVM / file system /
>>  read ahead / buffer cache / ... parameters to look for?
>>
>> Thanks.
>>
>> Wolfgang Denk
>>
>> --
>> DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zunde=
l
>> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, German=
y
>> Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.d=
e
>> Boykottiert Microsoft - Kauft Eure Fenster bei OBI!
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
