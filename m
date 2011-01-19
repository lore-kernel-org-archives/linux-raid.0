From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Wed, 19 Jan 2011 17:50:17 -0200
Message-ID: <AANLkTimY8XWxnx1MZWXp2undt9J35U8vCyuCHaSF2KkJ@mail.gmail.com>
References: <20110118210112.D13A236C@gemini.denx.de>
	<4D361F26.3060507@stud.tu-ilmenau.de>
	<20110119192104.1FA92D30267@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110119192104.1FA92D30267@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: stefan.huebner@stud.tu-ilmenau.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So can anybody help answering these questions:

- are there any special options when creating the RAID0 to make it
perform faster for such a use case?
- are there other tunables, any special MD / LVM / file system / read
ahead / buffer cache / ... parameters to look for?

lets see:
what=B4s your disk (ssd or sas or sata) best block size to write/read?
write this at ->(A)
what=B4s your work load? 50% write 50% read ?

raid0 block size should be multiple of (A)
*****filesystem size should be multiple of (A) of all disks
*****read ahead should be a multiple of (A)
for example
/dev/sda 1kb
/dev/sdb 4kb

you should use 6kb... you should use 4kb, 8kb, 16kb (multiple of 1kb an=
d 4kb)

check i/o sheduller per disk too (ssd should use noop, disks should
use cfq, deadline or another...)
async and sync option at mount /etc/fstab, noatime reduce a lot of i/o
too, you should optimize your application too
hdparm each disk to use dma and fastest i/o options

are you using only filesystem? are you using somethink more? samba?
mysql? apache? lvm?
each of this programs have some tunning, check their benchmarks


getting back....
what=B4s a raid controller?
cpu + memory + disk controller + disks
but... it only run raid software (it can run linux....)

if you computer is slower than raid cpu+memory+disk controller, you
will have a slower software raid, than hardware raid
it=B4s like load balance on cpu/memory utilization of disk i/o (use
dedicated hardware, or use your hardware?)
got it?
using a super fast xeon with ddr3 and optical fiber running software
raid, is faster than a hardware raid using a arm (or fpga) ddrX memory
and sas(fiber optical) connection to disks

two solutions for the same problem
what=B4s fast? benchmark it
i think that if your xeon run a database and a very workloaded apache,
a dedicated hardware raid can run faster, but a light xeon can run
faster than a dedicated hardware raid



2011/1/19 Wolfgang Denk <wd@denx.de>:
> Dear =3D?ISO-8859-15?Q?Stefan_/*St0fF*/_H=3DFCbner?=3D,
>
> In message <4D361F26.3060507@stud.tu-ilmenau.de> you wrote:
>>
>> [in German:] Sch=E4tzelein, Dein Problem sind die Platten, nicht der
>> Controller.
>>
>> [in English:] Dude, the disks are your bottleneck.
> ...
>
> Maybe we can stop speculations about what might be the cause of the
> problems in some setup I do NOT intend to use, and rather discuss the
> questions I asked.
>
>> > I will have 4 x 1 TB disks for this setup.
>> >
>> > The plan is to build a RAID0 from the 4 devices, create a physical
>> > volume and a volume group on the resulting /dev/md?, then create 2=
 or
>> > 3 logical volumes that will be used as XFS file systems.
>
> Clarrification: I'll run /dev/md* on the raw disks, without any
> partitions on them.
>
>> > My goal is to optimize for maximum number of I/O operations per
>> > second. ...
>> >
>> > Is this a reasonable approach for such a task?
>> >
>> > Should I do anything different to acchive maximum performance?
>> >
>> > What are the tunables in this setup? =A0[It seems the usual recipi=
es are
>> > more oriented in maximizing the data troughput for large, mostly
>> > sequential accesses - I figure that things like increasing read-ah=
ead
>> > etc. will not help me much here?]
>
> So can anybody help answering these questions:
>
> - are there any special options when creating the RAID0 to make it
> =A0perform faster for such a use case?
> - are there other tunables, any special MD / LVM / file system /
> =A0read ahead / buffer cache / ... parameters to look for?
>
> Thanks.
>
> Wolfgang Denk
>
> --
> DENX Software Engineering GmbH, =A0 =A0 MD: Wolfgang Denk & Detlev Zu=
ndel
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
> Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
> Boykottiert Microsoft - Kauft Eure Fenster bei OBI!
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
