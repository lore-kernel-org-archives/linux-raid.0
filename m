From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Wed, 19 Jan 2011 21:09:39 -0200
Message-ID: <AANLkTi=igTEuP4+NT+RFgc=k03z_qjhSWZKp_jcH1OdR@mail.gmail.com>
References: <20110118210112.D13A236C@gemini.denx.de>
	<4D361F26.3060507@stud.tu-ilmenau.de>
	<20110119192104.1FA92D30267@gemini.denx.de>
	<AANLkTimY8XWxnx1MZWXp2undt9J35U8vCyuCHaSF2KkJ@mail.gmail.com>
	<4D37677D.9010108@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D37677D.9010108@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: stefan.huebner@stud.tu-ilmenau.de
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

the problem....
if you use iostat, or iotop
with software raid:
   you just see disk i/o
   you don=B4t see memory (cache) i/o
when using hardware raid:
   you just see raid i/o (it can be a cache read or a real disk read)


if you check memory+disk i/o, you will get similar values, if not, you
will see high cpu usage
for example you are using raidx with 10disks on a hardware raid
change hardware raid to use only disks (10 disks for linux)
make the same raidx with 10disks
you will get a slower i/o since it have a controler between disk and cp=
u
try it without hardware raid cpu, just a (sas/sata) optimized
controller, or 10 (sata/sas) one port
you still with a slow i/o then hardware controller (that=B4s right!)

now let=B4s remove the sata/sas channel, let=B4s use a pci-express
revodrive or pci-express texas ssd drive
you will get better values then a hardware raid, but... why? you
changed the hardware (ok, i know) but you make cpu more close to disk
if you use disks with cache, you will get more speed (a memory ssd
harddisk is faster than a harddisk only disk)

why hardware are more faster than linux? i don=B4t think they are...
they can make smaller latencies with good memory cache
but if you computer use ddr3 and your hardware raid controller use i2c
memory, your ddr3 cache is faster...

how to benchmark? check disk i/o+memory cache i/o
if linux is faster ok, you use more cpu and memory of your computer
if linux is slower ok, you use less cpu and memory, but will have it
on hardware raid...
if you upgrade you memory and cpu, it can be faster than you hardware
raid controller, what=B4s better for you?

want a better read/write solution for software raid? make a new
read/write code, you can do it, linux is easier than hardware raid to
code!
want a better read/write solution for hardware raid? call your
hardware seller and talk, please i need a better firmware, could you
send me?

got?


2011/1/19 Stefan /*St0fF*/ H=FCbner <stefan.huebner@stud.tu-ilmenau.de>=
:
> @Roberto: I guess you're right. BUT: i have not seen 900MB/s coming f=
rom
> (i.e. read access) a software raid, but I've seen it from a 9750 on a
> LSI SASx28 backplane, running RAID6 over 16disks (HDS722020ALA330). =A0=
So
> one might not be wrong assuming on current raid-controllers
> hardware/software matching and timing is way more optimized than what
> mdraid might get at all.
>
> The 9650 and 9690 are considerably slower, but I've seen 550MB/s thru=
put
> from those, also (I don't recall the setup anymore, tho).
>
> Max reading I saw from a software raid was around 350MB/s - so hence =
my
> answers. =A0And if people had problems with controllers which are 5 y=
ears
> or older by now, the numbers are not really comparable...
>
> Now again there's the point where there are also parameters on the
> controller that can be tweaked, and a simple way to recreate the test=
ing
> scenario. =A0We may discuss and throw in further numbers and experien=
ce,
> but not being able to recreate your specific scenario makes us talk p=
ast
> each other...
>
> stefan
>
> Am 19.01.2011 20:50, schrieb Roberto Spadim:
>> So can anybody help answering these questions:
>>
>> - are there any special options when creating the RAID0 to make it
>> perform faster for such a use case?
>> - are there other tunables, any special MD / LVM / file system / rea=
d
>> ahead / buffer cache / ... parameters to look for?
>>
>> lets see:
>> what=B4s your disk (ssd or sas or sata) best block size to write/rea=
d?
>> write this at ->(A)
>> what=B4s your work load? 50% write 50% read ?
>>
>> raid0 block size should be multiple of (A)
>> *****filesystem size should be multiple of (A) of all disks
>> *****read ahead should be a multiple of (A)
>> for example
>> /dev/sda 1kb
>> /dev/sdb 4kb
>>
>> you should use 6kb... you should use 4kb, 8kb, 16kb (multiple of 1kb=
 and 4kb)
>>
>> check i/o sheduller per disk too (ssd should use noop, disks should
>> use cfq, deadline or another...)
>> async and sync option at mount /etc/fstab, noatime reduce a lot of i=
/o
>> too, you should optimize your application too
>> hdparm each disk to use dma and fastest i/o options
>>
>> are you using only filesystem? are you using somethink more? samba?
>> mysql? apache? lvm?
>> each of this programs have some tunning, check their benchmarks
>>
>>
>> getting back....
>> what=B4s a raid controller?
>> cpu + memory + disk controller + disks
>> but... it only run raid software (it can run linux....)
>>
>> if you computer is slower than raid cpu+memory+disk controller, you
>> will have a slower software raid, than hardware raid
>> it=B4s like load balance on cpu/memory utilization of disk i/o (use
>> dedicated hardware, or use your hardware?)
>> got it?
>> using a super fast xeon with ddr3 and optical fiber running software
>> raid, is faster than a hardware raid using a arm (or fpga) ddrX memo=
ry
>> and sas(fiber optical) connection to disks
>>
>> two solutions for the same problem
>> what=B4s fast? benchmark it
>> i think that if your xeon run a database and a very workloaded apach=
e,
>> a dedicated hardware raid can run faster, but a light xeon can run
>> faster than a dedicated hardware raid
>>
>>
>>
>> 2011/1/19 Wolfgang Denk <wd@denx.de>:
>>> Dear =3D?ISO-8859-15?Q?Stefan_/*St0fF*/_H=3DFCbner?=3D,
>>>
>>> In message <4D361F26.3060507@stud.tu-ilmenau.de> you wrote:
>>>>
>>>> [in German:] Sch=E4tzelein, Dein Problem sind die Platten, nicht d=
er
>>>> Controller.
>>>>
>>>> [in English:] Dude, the disks are your bottleneck.
>>> ...
>>>
>>> Maybe we can stop speculations about what might be the cause of the
>>> problems in some setup I do NOT intend to use, and rather discuss t=
he
>>> questions I asked.
>>>
>>>>> I will have 4 x 1 TB disks for this setup.
>>>>>
>>>>> The plan is to build a RAID0 from the 4 devices, create a physica=
l
>>>>> volume and a volume group on the resulting /dev/md?, then create =
2 or
>>>>> 3 logical volumes that will be used as XFS file systems.
>>>
>>> Clarrification: I'll run /dev/md* on the raw disks, without any
>>> partitions on them.
>>>
>>>>> My goal is to optimize for maximum number of I/O operations per
>>>>> second. ...
>>>>>
>>>>> Is this a reasonable approach for such a task?
>>>>>
>>>>> Should I do anything different to acchive maximum performance?
>>>>>
>>>>> What are the tunables in this setup? =A0[It seems the usual recip=
ies are
>>>>> more oriented in maximizing the data troughput for large, mostly
>>>>> sequential accesses - I figure that things like increasing read-a=
head
>>>>> etc. will not help me much here?]
>>>
>>> So can anybody help answering these questions:
>>>
>>> - are there any special options when creating the RAID0 to make it
>>> =A0perform faster for such a use case?
>>> - are there other tunables, any special MD / LVM / file system /
>>> =A0read ahead / buffer cache / ... parameters to look for?
>>>
>>> Thanks.
>>>
>>> Wolfgang Denk
>>>
>>> --
>>> DENX Software Engineering GmbH, =A0 =A0 MD: Wolfgang Denk & Detlev =
Zundel
>>> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germa=
ny
>>> Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.=
de
>>> Boykottiert Microsoft - Kauft Eure Fenster bei OBI!
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
