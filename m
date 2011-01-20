From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: cpu/memory use
Date: Thu, 20 Jan 2011 01:33:33 -0200
Message-ID: <AANLkTimssY+2hoEB+FnYVJgg82+u1u0CsrZ5NaWjY_of@mail.gmail.com>
References: <AANLkTincv7RsGN5mOwAiYhPqH9ryiJ31yoVsF_9-ywnQ@mail.gmail.com>
	<20110120122917.3eb0a888@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110120122917.3eb0a888@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hummmm nice
i asked it because there=B4s many questions about
is hardware raid better than software raid?
i think that software is easier to implement and cpu (intel x86) is
easier to upgrade than a arm(fpga or another) hardware raid cpu

but thinking about raid software i never read anything about cpu use/me=
mory use
now i see it=B4s very small footprint for raid0/raid1, just checksum
make thinks slower raid !=3D 0/1

could we implement a "real" hardware raid?
what=B4s "real"? a cpu just for raid, a memory just for raid (fixed siz=
e)
maybe with linux cpu afinity, and linux max memory use?
ok it=B4s not a good ide, but for benchmarks it=B4s the best scenario, =
and
we will never get a "on high load your software raid can be slower..."
got the problem? it=B4s not a numeric optimization, it=B4s just a human
feeling (social? professional?) "optimization"
and we know that we will always have a portion of memory and a portion
of cpu just for raid =3D)

2011/1/19 NeilBrown <neilb@suse.de>:
> On Wed, 19 Jan 2011 22:14:45 -0200 Roberto Spadim <roberto@spadim.com=
=2Ebr>
> wrote:
>
>> Hi, i wass thinking about cpu/memory use
>> i have a dual (three four) cpu
>> could i make linux to only use cpu1 for raid? and others to anythink
>> else, don=B4t migrate raid between cpus... and don=B4t allow others
>> programs to use raid cpu...
>> is it possible?
>> is it dificult?
>> it=B4s more linux related feature, not raid related, but could we im=
plement it?
>> what about memory usage? how many memory software raid use? is it pe=
r
>> device, per raid, does it have a hard limit (offcourse)? could we
>> calculate it? for example i want raid1 with two disks of 1tb, how ma=
ny
>> memory should i buy?
>>
>
> For levels other than RAID4/5/6, md/raid does not use any significant=
 amount
> of CPU or memory.
>
> For RAID4/5/6, md's use for CPU is single-threads so it will only use=
 a
> single CPU - which ever one the scheduler allocates it to from time t=
o time.
>
> The only room for improvement that I can see would be to allow the 'x=
or'
> calculation to be run in parallel on multiple CPUs and that would onl=
y help
> if the storage devices were nearly as fast as a CPU. =A0Where we have=
 tried
> parallelising xor, it has only made things slower.
>
>
> For your particular question about RAID1 - use a RAID1 across two dev=
ices
> would use less than 100K more than using just one of the devices.
> During resync it might use as much as a couple of megabytes of extra =
memory.
>
> NeilBrown
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
