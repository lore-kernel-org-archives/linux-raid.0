From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: high throughput storage server?
Date: Sun, 20 Mar 2011 02:32:38 -0300
Message-ID: <AANLkTi=2k2=YuZAggonLfKmRFxFd-rXvNo=xkpqWyQNU@mail.gmail.com>
References: <4D6AC288.20101@wildgooses.com>
	<AANLkTinjPJJrUYrA=fxcau02Q+4Z67YVsJhcGxeTpAAW@mail.gmail.com>
	<4D6DC585.90304@gmail.com>
	<AANLkTi=yWhnqY_RTd8GH+fvEQfHfQ6TpWxnzpx-Fv=aj@mail.gmail.com>
	<AANLkTimB2hv8aP01JdQyOJehtkX2j=G5HtgVi6eNjmLx@mail.gmail.com>
	<AANLkTin=0PN+ovNY=rLu21-VRiy2Ffzrf69_fWsS54iN@mail.gmail.com>
	<20110313201000.GA14090@infradead.org>
	<4D7E0994.3020303@hardwarefreak.com>
	<20110314124733.GA31377@infradead.org>
	<4D835B2A.1000805@hardwarefreak.com>
	<20110318140509.GA26226@infradead.org>
	<4D837DAF.6060107@hardwarefreak.com>
	<20110319090101.1786cc2a@notabene.brown>
	<4D8559A2.6080209@hardwarefreak.com>
	<20110320144147.29141f04@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110320144147.29141f04@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Christoph Hellwig <hch@infradead.org>, Drew <drew.kay@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

with 2 disks md raid0 i get 400MB/s SAS 10krpm 6gb/s channel
you will need at last 10000/400*2=3D25*2=3D50 disks to get a start numb=
er
memory/cpu/network speed?
memory must allow more than 10gb/s (ddr3 can do this, i don't know if
enabled ecc will be a problem or not, check with memtest86+)
cpu? hummm i don't know very well how to help here, since it's just
read and write memory/interfaces (network/disks), maybe a 'magic'
number like: 3ghz * 64bits/8bits=3D24.000 (maybe 24gbits/s) i don't kno=
w
how to estimate... but i think you will need a multicore cpu... maybe
one for network one for disks one for mdadm one for nfs and one for
linux, >=3D5 cores at least with 3ghz 64bits each (maybe starting with
xeon 6cores with hyper thread)
it's just a idea how to estimate, it's not correct/true/real
i think it's better contact ibm/dell/hp/compaq/texas/anyother and talk
about the problem, post results here, this is a nice hardware question
:)
don't tell about software raid, just the hardware to allow this
bandwidth (10gb/s) and share files

2011/3/20 NeilBrown <neilb@suse.de>:
> On Sat, 19 Mar 2011 20:34:26 -0500 Stan Hoeppner <stan@hardwarefreak.=
com>
> wrote:
>
>> NeilBrown put forth on 3/18/2011 5:01 PM:
>> > On Fri, 18 Mar 2011 10:43:43 -0500 Stan Hoeppner <stan@hardwarefre=
ak.com>
>> > wrote:
>> >
>> >> Christoph Hellwig put forth on 3/18/2011 9:05 AM:
>> >>
>> >> Thanks for the confirmations and explanations.
>> >>
>> >>> The kernel is pretty smart in placement of user and page cache d=
ata, but
>> >>> it can't really second guess your intention. =A0With the numactl=
 tool you
>> >>> can help it doing the proper placement for you workload. =A0Note=
 that the
>> >>> choice isn't always trivial - a numa system tends to have memory=
 on
>> >>> multiple nodes, so you'll either have to find a good partitionin=
g of
>> >>> your workload or live with off-node references. =A0I don't think
>> >>> partitioning NFS workloads is trivial, but then again I'm not a
>> >>> networking expert.
>> >>
>> >> Bringing mdraid back into the fold, I'm wondering what kinda of l=
oad the
>> >> mdraid threads would place on a system of the caliber needed to p=
ush
>> >> 10GB/s NFS.
>> >>
>> >> Neil, I spent quite a bit of time yesterday spec'ing out what I b=
elieve
>> >
>> > Addressing me directly in an email that wasn't addressed to me dir=
ectly seem
>> > a bit ... odd. =A0Maybe that is just me.
>>
>> I guess that depends on one's perspective. =A0Is it the content of e=
mail
>> To: and Cc: headers that matters, or the substance of the list
>> discussion thread? =A0You are the lead developer and maintainer of L=
inux
>> mdraid AFAIK. =A0Thus I would have assumed that directly addressing =
a
>> question to you within any given list thread was acceptable, regardl=
ess
>> of whose address was where in the email headers.
>
> This assumes that I read every email on this list. =A0I certainly do =
read a lot,
> but I tend to tune out of threads that don't seem particularly intere=
sting -
> and configuring hardware is only vaguely interesting to me - and I am=
 sure
> there are people on the list with more experience.
>
> But whatever... there is certainly more chance of me missing somethin=
g that
> isn't directly addressed to me (such messages get filed differently).
>
>
>>
>> >> How much of each core's cycles will we consume with normal random=
 read
>> >
>> > For RAID10, the md thread plays no part in reads. =A0Which ever th=
read
>> > submitted the read submits it all the way down to the relevant mem=
ber device.
>> > If the read fails the thread will come in to play.
>>
>> So with RIAD10 read scalability is in essence limited to the executi=
on
>> rate of the block device layer code and the interconnect b/w require=
d.
>
> Correct.
>
>>
>> > For writes, the thread is used primarily to make sure the writes a=
re properly
>> > orders w.r.t. bitmap updates. =A0I could probably remove that requ=
irement if a
>> > bitmap was not in use...
>>
>> How compute intensive is this thread during writes, if at all, at
>> extreme IO bandwidth rates?
>
> Not compute intensive at all - just single threaded. =A0So it will on=
ly
> dispatch a single request at a time. =A0Whether single threading the =
writes is
> good or bad is not something that I'm completely clear on. =A0It seem=
s bad in
> the sense that modern machines have lots of CPUs and we are fore-goin=
g any
> possible benefits of parallelism. =A0However the current VM seems to =
do all
> (or most) writeout from a single thread per device - the 'bdi' thread=
s.
> So maybe keeping it single threaded in the md level is perfectly natu=
ral and
> avoids cache bouncing...
>
>
>>
>> >> operations assuming 10GB/s of continuous aggregate throughput? =A0=
Would
>> >> the mdraid threads consume sufficient cycles that when combined w=
ith
>> >> network stack processing and interrupt processing, that 16 cores =
at
>> >> 2.4GHz would be insufficient? =A0If so, would bumping the two soc=
kets up
>> >> to 24 cores at 2.1GHz be enough for the total workload? =A0Or, wo=
uld we
>> >> need to move to a 4 socket system with 32 or 48 cores?
>> >>
>> >> Is this possibly a situation where mdraid just isn't suitable due=
 to the
>> >> CPU, memory, and interconnect bandwidth demands, making hardware =
RAID
>> >> the only real option?
>> >
>> > I'm sorry, but I don't do resource usage estimates or comparisons =
with
>> > hardware raid. =A0I just do software design and coding.
>>
>> I probably worded this question very poorly and have possibly made
>> unfair assumptions about mdraid performance.
>>
>> >> =A0 =A0 And if it does requires hardware RAID, would it
>> >> be possible to stick 16 block devices together in a --linear mdra=
id
>> >> array and maintain the 10GB/s performance? =A0Or, would the singl=
e
>> >> --linear array be processed by a single thread? =A0If so, would a=
 single
>> >> 2.4GHz core be able to handle an mdraid --leaner thread managing =
8
>> >> devices at 10GB/s aggregate?
>> >
>> > There is no thread for linear or RAID0.
>>
>> What kernel code is responsible for the concatenation and striping
>> operations of mdraid linear and RAID0 if not an mdraid thread?
>>
>
> When the VM or filesystem or whatever wants to start an IO request, i=
t calls
> into the md code to find out how big it is allowed to make that reque=
st. =A0The
> md code returns a number which ensures that the request will end up b=
eing
> mapped onto just one drive (at least in the majority of cases).
> The VM or filesystem builds up the request (a struct bio) to at most =
that
> size and hands it to md. =A0md simply assigns a different target devi=
ce and
> offset in that device to the request, and hands it over the the targe=
t device.
>
> So whatever thread it was that started the request carries it all the=
 way
> down to the device which is a member of the RAID array (for RAID0/lin=
ear).
> Typically it then gets placed on a queue, and an interrupt handler ta=
kes it
> off the queue and acts upon it.
>
> So - no separate md thread.
>
> RAID1 and RAID10 make only limited use of their thread, doing as much=
 of the
> work as possible in the original calling thread.
> RAID4/5/6 do lots of work in the md thread. =A0The calling thread jus=
t finds a
> place in the stripe cache to attach the request, attaches it, and sig=
nals the
> thread.
> (Though reads on a non-degraded array can by-pass the cache and are h=
andled
> much like reads on RAID0).
>
>> > If you want to share load over a number of devices, you would norm=
ally use
>> > RAID0. =A0However if the load had a high thread count and the file=
system
>> > distributed IO evenly across the whole device space, then linear m=
ight work
>> > for you.
>>
>> In my scenario I'm thinking I'd want to stay away RAID0 because of t=
he
>> multi-level stripe width issues of double nested RAID (RAID0 over
>> RAID10). =A0I assumed linear would be the way to go, as my scenario =
calls
>> for using XFS. =A0Using 32 allocation groups should evenly spread th=
e
>> load, which is ~50 NFS clients.
>
> You may well be right.
>
>>
>> What I'm trying to figure out is how much CPU time I am going to nee=
d for:
>>
>> 1. =A0Aggregate 10GB/s IO rate
>> 2. =A0mdraid managing 384 drives
>> =A0 =A0 A. =A016 mdraid10 arrays of 24 drives each
>> =A0 =A0 B. =A0mdraid linear concatenating the 16 arrays
>
> I very much doubt that CPU is going to be an issue. =A0Memory bandwid=
th might -
> but I'm only really guessing here, so it is probably time to stop.
>
>
>>
>> Thanks for your input Neil.
>>
> Pleasure.
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
