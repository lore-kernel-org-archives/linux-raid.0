From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: cpu/memory use
Date: Thu, 20 Jan 2011 10:12:32 -0200
Message-ID: <AANLkTi=Km5qKWi0pSCPHwN+6z1nwbe9t6Abbjf41vC59@mail.gmail.com>
References: <AANLkTincv7RsGN5mOwAiYhPqH9ryiJ31yoVsF_9-ywnQ@mail.gmail.com>
	<20110120122917.3eb0a888@notabene.brown>
	<AANLkTimssY+2hoEB+FnYVJgg82+u1u0CsrZ5NaWjY_of@mail.gmail.com>
	<ih92qs$q24$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ih92qs$q24$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

yes, it's what i think too
i will try some userspace cpu affinity to be sure that benchmarks are
'real' enoght
another question... when using beowolf, or another "cpu hot plug"
(network cpu), can raid don't use these "external" cpus, just local
ones?

2011/1/20 David Brown <david@westcontrol.com>:
> On 20/01/2011 04:33, Roberto Spadim wrote:
>>
>> hummmm nice
>> i asked it because there=B4s many questions about
>> is hardware raid better than software raid?
>> i think that software is easier to implement and cpu (intel x86) is
>> easier to upgrade than a arm(fpga or another) hardware raid cpu
>>
>> but thinking about raid software i never read anything about cpu
>> use/memory use
>> now i see it=B4s very small footprint for raid0/raid1, just checksum
>> make thinks slower raid !=3D 0/1
>>
>> could we implement a "real" hardware raid?
>
> "Hardware raid" means there is dedicated hardware that handles things=
 like
> parity calculations and raid1 duplication - the host cpu only sees th=
e
> un-raided transactions. =A0Hardware raid controllers will also often =
have
> battery backup to make sure stripes are consistent in the event of fa=
ilures.
>
> You can't make software raid work as "real hardware raid", because it
> doesn't have these hardware features.
>
> Software raid can easily be as fast, or often significantly faster, t=
han
> hardware raid cards. =A0The host processor is typically much faster a=
t parity
> calculations than raid card processors. =A0I haven't done benchmarks =
(and have
> no hardware raid card for comparison), but I expect that with a moder=
n cpu
> and motherboard, the performance bottleneck would be PCIExpress IO if=
 you
> have a lot of duplication (for example, raid 15).
>
> I don't think cpu core affinity would make a significant difference, =
but it
> should be easy enough to try it. =A0And I'm sure md raid already uses
> non-paged kernel memory as necessary (and I believe it is possible to=
 tune
> the number of stripe buffers used for raid5/6). =A0Linux will always =
use as
> much free main memory as it can for disk caching, which will be far m=
ore
> than you will get on a hardware raid card.
>
>
> If you set up a Linux box as a NAS with mdadm raid, so that it is jus=
t a
> disk server (iSCSI, for example), and have an UPS, then you effective=
ly have
> a hardware raid system.
>
>> what=B4s "real"? a cpu just for raid, a memory just for raid (fixed =
size)
>> maybe with linux cpu afinity, and linux max memory use?
>> ok it=B4s not a good ide, but for benchmarks it=B4s the best scenari=
o, and
>> we will never get a "on high load your software raid can be slower..=
=2E"
>> got the problem? it=B4s not a numeric optimization, it=B4s just a hu=
man
>> feeling (social? professional?) "optimization"
>> and we know that we will always have a portion of memory and a porti=
on
>> of cpu just for raid =3D)
>>
>> 2011/1/19 NeilBrown<neilb@suse.de>:
>>>
>>> On Wed, 19 Jan 2011 22:14:45 -0200 Roberto Spadim<roberto@spadim.co=
m.br>
>>> wrote:
>>>
>>>> Hi, i wass thinking about cpu/memory use
>>>> i have a dual (three four) cpu
>>>> could i make linux to only use cpu1 for raid? and others to anythi=
nk
>>>> else, don=B4t migrate raid between cpus... and don=B4t allow other=
s
>>>> programs to use raid cpu...
>>>> is it possible?
>>>> is it dificult?
>>>> it=B4s more linux related feature, not raid related, but could we
>>>> implement it?
>>>> what about memory usage? how many memory software raid use? is it =
per
>>>> device, per raid, does it have a hard limit (offcourse)? could we
>>>> calculate it? for example i want raid1 with two disks of 1tb, how =
many
>>>> memory should i buy?
>>>>
>>>
>>> For levels other than RAID4/5/6, md/raid does not use any significa=
nt
>>> amount
>>> of CPU or memory.
>>>
>>> For RAID4/5/6, md's use for CPU is single-threads so it will only u=
se a
>>> single CPU - which ever one the scheduler allocates it to from time=
 to
>>> time.
>>>
>>> The only room for improvement that I can see would be to allow the =
'xor'
>>> calculation to be run in parallel on multiple CPUs and that would o=
nly
>>> help
>>> if the storage devices were nearly as fast as a CPU. =A0Where we ha=
ve tried
>>> parallelising xor, it has only made things slower.
>>>
>>>
>>> For your particular question about RAID1 - use a RAID1 across two d=
evices
>>> would use less than 100K more than using just one of the devices.
>>> During resync it might use as much as a couple of megabytes of extr=
a
>>> memory.
>>>
>>> NeilBrown
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
