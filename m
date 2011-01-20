From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Thu, 20 Jan 2011 01:53:09 -0200
Message-ID: <AANLkTi=Z0tnZvTskiu=0BpzJmp-ivA3o6efDjxhZwd80@mail.gmail.com>
References: <20110118210112.D13A236C@gemini.denx.de>
	<4D361F26.3060507@stud.tu-ilmenau.de>
	<20110119192104.1FA92D30267@gemini.denx.de>
	<AANLkTimY8XWxnx1MZWXp2undt9J35U8vCyuCHaSF2KkJ@mail.gmail.com>
	<4D37677D.9010108@stud.tu-ilmenau.de>
	<AANLkTi=igTEuP4+NT+RFgc=k03z_qjhSWZKp_jcH1OdR@mail.gmail.com>
	<AANLkTiki_FfRrLtL3dMsrDLXeT8jNO0ndnTNpXk1OXMW@mail.gmail.com>
	<20110120024807.GA11550@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110120024807.GA11550@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: stefan.huebner@stud.tu-ilmenau.de, Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=3D) i know, but since we have many proprietary firmware, a opensource
firmware (like openbios) could be very nice :D hehehehe

i will use linux raid (i=B4m sure it=B4s very good) it=B4s really fast,=
 and
work with hotswap too
(ok there=B4s some userspace programs to allow it to work ok even with
wrong kernel hotswap problems, but when kernel can release and replug
it without problems we don=B4t need userspace programs... userspace
check each new hotpluged volume, if uuid is =3D some raid uuid device,
it put the device in the right raid device (i made it with a php
script =3D) hehehe) )


2011/1/20 Keld J=F8rn Simonsen <keld@keldix.com>:
> On Wed, Jan 19, 2011 at 09:18:22PM -0200, Roberto Spadim wrote:
>> a good idea....
>> why not start a opensource raid controller?
>> what we need? a cpu, memory, power supply with battery or capacitor,
>> sas/sata (disk interfaces), pci-express or another (computer
>> interface)
>
> Why? because of some differences in memory speed?
>
> Normally software raid is faster than hardware raid, as wittnessed by
> many here on the list. The mentioning of max 350 MB/s on a SW raid
> is not true, 350 MB/S is what I get out of a simple box with 4 slight=
ly
> oldish SATA drives. 16 new fast SATA drives in SW raid6 should easily=
 go beyond
> 1000 MB/s, given that there are not other bottlenecks in the system.
>
> Linux SW raid goes fairly close to theoretical maxima, given adequate
> HW.
>
>
> best regards
> keld
>
>> it don?t need a operational system, since it will only run one progr=
am
>> with some threads (ok a small operational system to implement thread=
s
>> easly)
>>
>> we could use arm, fpga, intel core2duo, atlhon, xeon, or another sys=
tem...
>> instead using a computer with ethernet interface (nbd nfs samba or
>> another file/device sharing iscsi ethernet sata), we need a computer
>> with pci-express interface and native operational system module
>>
>>
>> 2011/1/19 Roberto Spadim <roberto@spadim.com.br>:
>> > the problem....
>> > if you use iostat, or iotop
>> > with software raid:
>> > =A0 you just see disk i/o
>> > =A0 you don?t see memory (cache) i/o
>> > when using hardware raid:
>> > =A0 you just see raid i/o (it can be a cache read or a real disk r=
ead)
>> >
>> >
>> > if you check memory+disk i/o, you will get similar values, if not,=
 you
>> > will see high cpu usage
>> > for example you are using raidx with 10disks on a hardware raid
>> > change hardware raid to use only disks (10 disks for linux)
>> > make the same raidx with 10disks
>> > you will get a slower i/o since it have a controler between disk a=
nd cpu
>> > try it without hardware raid cpu, just a (sas/sata) optimized
>> > controller, or 10 (sata/sas) one port
>> > you still with a slow i/o then hardware controller (that?s right!)
>> >
>> > now let?s remove the sata/sas channel, let?s use a pci-express
>> > revodrive or pci-express texas ssd drive
>> > you will get better values then a hardware raid, but... why? you
>> > changed the hardware (ok, i know) but you make cpu more close to d=
isk
>> > if you use disks with cache, you will get more speed (a memory ssd
>> > harddisk is faster than a harddisk only disk)
>> >
>> > why hardware are more faster than linux? i don?t think they are...
>> > they can make smaller latencies with good memory cache
>> > but if you computer use ddr3 and your hardware raid controller use=
 i2c
>> > memory, your ddr3 cache is faster...
>> >
>> > how to benchmark? check disk i/o+memory cache i/o
>> > if linux is faster ok, you use more cpu and memory of your compute=
r
>> > if linux is slower ok, you use less cpu and memory, but will have =
it
>> > on hardware raid...
>> > if you upgrade you memory and cpu, it can be faster than you hardw=
are
>> > raid controller, what?s better for you?
>> >
>> > want a better read/write solution for software raid? make a new
>> > read/write code, you can do it, linux is easier than hardware raid=
 to
>> > code!
>> > want a better read/write solution for hardware raid? call your
>> > hardware seller and talk, please i need a better firmware, could y=
ou
>> > send me?
>> >
>> > got?
>> >
>> >
>> > 2011/1/19 Stefan /*St0fF*/ H=FCbner <stefan.huebner@stud.tu-ilmena=
u.de>:
>> >> @Roberto: I guess you're right. BUT: i have not seen 900MB/s comi=
ng from
>> >> (i.e. read access) a software raid, but I've seen it from a 9750 =
on a
>> >> LSI SASx28 backplane, running RAID6 over 16disks (HDS722020ALA330=
). =A0So
>> >> one might not be wrong assuming on current raid-controllers
>> >> hardware/software matching and timing is way more optimized than =
what
>> >> mdraid might get at all.
>> >>
>> >> The 9650 and 9690 are considerably slower, but I've seen 550MB/s =
thruput
>> >> from those, also (I don't recall the setup anymore, tho).
>> >>
>> >> Max reading I saw from a software raid was around 350MB/s - so he=
nce my
>> >> answers. =A0And if people had problems with controllers which are=
 5 years
>> >> or older by now, the numbers are not really comparable...
>> >>
>> >> Now again there's the point where there are also parameters on th=
e
>> >> controller that can be tweaked, and a simple way to recreate the =
testing
>> >> scenario. =A0We may discuss and throw in further numbers and expe=
rience,
>> >> but not being able to recreate your specific scenario makes us ta=
lk past
>> >> each other...
>> >>
>> >> stefan
>> >>
>> >> Am 19.01.2011 20:50, schrieb Roberto Spadim:
>> >>> So can anybody help answering these questions:
>> >>>
>> >>> - are there any special options when creating the RAID0 to make =
it
>> >>> perform faster for such a use case?
>> >>> - are there other tunables, any special MD / LVM / file system /=
 read
>> >>> ahead / buffer cache / ... parameters to look for?
>> >>>
>> >>> lets see:
>> >>> what?s your disk (ssd or sas or sata) best block size to write/r=
ead?
>> >>> write this at ->(A)
>> >>> what?s your work load? 50% write 50% read ?
>> >>>
>> >>> raid0 block size should be multiple of (A)
>> >>> *****filesystem size should be multiple of (A) of all disks
>> >>> *****read ahead should be a multiple of (A)
>> >>> for example
>> >>> /dev/sda 1kb
>> >>> /dev/sdb 4kb
>> >>>
>> >>> you should use 6kb... you should use 4kb, 8kb, 16kb (multiple of=
 1kb and 4kb)
>> >>>
>> >>> check i/o sheduller per disk too (ssd should use noop, disks sho=
uld
>> >>> use cfq, deadline or another...)
>> >>> async and sync option at mount /etc/fstab, noatime reduce a lot =
of i/o
>> >>> too, you should optimize your application too
>> >>> hdparm each disk to use dma and fastest i/o options
>> >>>
>> >>> are you using only filesystem? are you using somethink more? sam=
ba?
>> >>> mysql? apache? lvm?
>> >>> each of this programs have some tunning, check their benchmarks
>> >>>
>> >>>
>> >>> getting back....
>> >>> what?s a raid controller?
>> >>> cpu + memory + disk controller + disks
>> >>> but... it only run raid software (it can run linux....)
>> >>>
>> >>> if you computer is slower than raid cpu+memory+disk controller, =
you
>> >>> will have a slower software raid, than hardware raid
>> >>> it?s like load balance on cpu/memory utilization of disk i/o (us=
e
>> >>> dedicated hardware, or use your hardware?)
>> >>> got it?
>> >>> using a super fast xeon with ddr3 and optical fiber running soft=
ware
>> >>> raid, is faster than a hardware raid using a arm (or fpga) ddrX =
memory
>> >>> and sas(fiber optical) connection to disks
>> >>>
>> >>> two solutions for the same problem
>> >>> what?s fast? benchmark it
>> >>> i think that if your xeon run a database and a very workloaded a=
pache,
>> >>> a dedicated hardware raid can run faster, but a light xeon can r=
un
>> >>> faster than a dedicated hardware raid
>> >>>
>> >>>
>> >>>
>> >>> 2011/1/19 Wolfgang Denk <wd@denx.de>:
>> >>>> Dear =3D?ISO-8859-15?Q?Stefan_/*St0fF*/_H=3DFCbner?=3D,
>> >>>>
>> >>>> In message <4D361F26.3060507@stud.tu-ilmenau.de> you wrote:
>> >>>>>
>> >>>>> [in German:] Sch=E4tzelein, Dein Problem sind die Platten, nic=
ht der
>> >>>>> Controller.
>> >>>>>
>> >>>>> [in English:] Dude, the disks are your bottleneck.
>> >>>> ...
>> >>>>
>> >>>> Maybe we can stop speculations about what might be the cause of=
 the
>> >>>> problems in some setup I do NOT intend to use, and rather discu=
ss the
>> >>>> questions I asked.
>> >>>>
>> >>>>>> I will have 4 x 1 TB disks for this setup.
>> >>>>>>
>> >>>>>> The plan is to build a RAID0 from the 4 devices, create a phy=
sical
>> >>>>>> volume and a volume group on the resulting /dev/md?, then cre=
ate 2 or
>> >>>>>> 3 logical volumes that will be used as XFS file systems.
>> >>>>
>> >>>> Clarrification: I'll run /dev/md* on the raw disks, without any
>> >>>> partitions on them.
>> >>>>
>> >>>>>> My goal is to optimize for maximum number of I/O operations p=
er
>> >>>>>> second. ...
>> >>>>>>
>> >>>>>> Is this a reasonable approach for such a task?
>> >>>>>>
>> >>>>>> Should I do anything different to acchive maximum performance=
?
>> >>>>>>
>> >>>>>> What are the tunables in this setup? =A0[It seems the usual r=
ecipies are
>> >>>>>> more oriented in maximizing the data troughput for large, mos=
tly
>> >>>>>> sequential accesses - I figure that things like increasing re=
ad-ahead
>> >>>>>> etc. will not help me much here?]
>> >>>>
>> >>>> So can anybody help answering these questions:
>> >>>>
>> >>>> - are there any special options when creating the RAID0 to make=
 it
>> >>>> =A0perform faster for such a use case?
>> >>>> - are there other tunables, any special MD / LVM / file system =
/
>> >>>> =A0read ahead / buffer cache / ... parameters to look for?
>> >>>>
>> >>>> Thanks.
>> >>>>
>> >>>> Wolfgang Denk
>> >>>>
>> >>>> --
>> >>>> DENX Software Engineering GmbH, =A0 =A0 MD: Wolfgang Denk & Det=
lev Zundel
>> >>>> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, G=
ermany
>> >>>> Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@d=
enx.de
>> >>>> Boykottiert Microsoft - Kauft Eure Fenster bei OBI!
>> >>>> --
>> >>>> To unsubscribe from this list: send the line "unsubscribe linux=
-raid" in
>> >>>> the body of a message to majordomo@vger.kernel.org
>> >>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info=
=2Ehtml
>> >>>>
>> >>>
>> >>>
>> >>>
>> >>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-r=
aid" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>> >>
>> >
>> >
>> >
>> > --
>> > Roberto Spadim
>> > Spadim Technology / SPAEmpresarial
>> >
>>
>>
>>
>> --
>> Roberto Spadim
>> Spadim Technology / SPAEmpresarial
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
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
