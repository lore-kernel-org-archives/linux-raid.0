From: David Brown <david@westcontrol.com>
Subject: Re: cpu/memory use
Date: Thu, 20 Jan 2011 11:31:45 +0100
Message-ID: <ih92qs$q24$1@dough.gmane.org>
References: <AANLkTincv7RsGN5mOwAiYhPqH9ryiJ31yoVsF_9-ywnQ@mail.gmail.com>	<20110120122917.3eb0a888@notabene.brown> <AANLkTimssY+2hoEB+FnYVJgg82+u1u0CsrZ5NaWjY_of@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimssY+2hoEB+FnYVJgg82+u1u0CsrZ5NaWjY_of@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/01/2011 04:33, Roberto Spadim wrote:
> hummmm nice
> i asked it because there=B4s many questions about
> is hardware raid better than software raid?
> i think that software is easier to implement and cpu (intel x86) is
> easier to upgrade than a arm(fpga or another) hardware raid cpu
>
> but thinking about raid software i never read anything about cpu use/=
memory use
> now i see it=B4s very small footprint for raid0/raid1, just checksum
> make thinks slower raid !=3D 0/1
>
> could we implement a "real" hardware raid?

"Hardware raid" means there is dedicated hardware that handles things=20
like parity calculations and raid1 duplication - the host cpu only sees=
=20
the un-raided transactions.  Hardware raid controllers will also often=20
have battery backup to make sure stripes are consistent in the event of=
=20
failures.

You can't make software raid work as "real hardware raid", because it=20
doesn't have these hardware features.

Software raid can easily be as fast, or often significantly faster, tha=
n=20
hardware raid cards.  The host processor is typically much faster at=20
parity calculations than raid card processors.  I haven't done=20
benchmarks (and have no hardware raid card for comparison), but I expec=
t=20
that with a modern cpu and motherboard, the performance bottleneck woul=
d=20
be PCIExpress IO if you have a lot of duplication (for example, raid 15=
).

I don't think cpu core affinity would make a significant difference, bu=
t=20
it should be easy enough to try it.  And I'm sure md raid already uses=20
non-paged kernel memory as necessary (and I believe it is possible to=20
tune the number of stripe buffers used for raid5/6).  Linux will always=
=20
use as much free main memory as it can for disk caching, which will be=20
far more than you will get on a hardware raid card.


If you set up a Linux box as a NAS with mdadm raid, so that it is just =
a=20
disk server (iSCSI, for example), and have an UPS, then you effectively=
=20
have a hardware raid system.

> what=B4s "real"? a cpu just for raid, a memory just for raid (fixed s=
ize)
> maybe with linux cpu afinity, and linux max memory use?
> ok it=B4s not a good ide, but for benchmarks it=B4s the best scenario=
, and
> we will never get a "on high load your software raid can be slower...=
"
> got the problem? it=B4s not a numeric optimization, it=B4s just a hum=
an
> feeling (social? professional?) "optimization"
> and we know that we will always have a portion of memory and a portio=
n
> of cpu just for raid =3D)
>
> 2011/1/19 NeilBrown<neilb@suse.de>:
>> On Wed, 19 Jan 2011 22:14:45 -0200 Roberto Spadim<roberto@spadim.com=
=2Ebr>
>> wrote:
>>
>>> Hi, i wass thinking about cpu/memory use
>>> i have a dual (three four) cpu
>>> could i make linux to only use cpu1 for raid? and others to anythin=
k
>>> else, don=B4t migrate raid between cpus... and don=B4t allow others
>>> programs to use raid cpu...
>>> is it possible?
>>> is it dificult?
>>> it=B4s more linux related feature, not raid related, but could we i=
mplement it?
>>> what about memory usage? how many memory software raid use? is it p=
er
>>> device, per raid, does it have a hard limit (offcourse)? could we
>>> calculate it? for example i want raid1 with two disks of 1tb, how m=
any
>>> memory should i buy?
>>>
>>
>> For levels other than RAID4/5/6, md/raid does not use any significan=
t amount
>> of CPU or memory.
>>
>> For RAID4/5/6, md's use for CPU is single-threads so it will only us=
e a
>> single CPU - which ever one the scheduler allocates it to from time =
to time.
>>
>> The only room for improvement that I can see would be to allow the '=
xor'
>> calculation to be run in parallel on multiple CPUs and that would on=
ly help
>> if the storage devices were nearly as fast as a CPU.  Where we have =
tried
>> parallelising xor, it has only made things slower.
>>
>>
>> For your particular question about RAID1 - use a RAID1 across two de=
vices
>> would use less than 100K more than using just one of the devices.
>> During resync it might use as much as a couple of megabytes of extra=
 memory.
>>
>> NeilBrown
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
