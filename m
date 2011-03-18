From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: high throughput storage server?
Date: Fri, 18 Mar 2011 19:23:19 -0300
Message-ID: <AANLkTikeAdGaBqKkbZZR+FUr+em9VAZz1t9A2h++Qtrp@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110319090101.1786cc2a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Christoph Hellwig <hch@infradead.org>, Drew <drew.kay@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i think linux can do this job without problems, md code is very
mature. the problem here is: what size/speed of cpu/ram/network/disk
should we use?
slow disk use raid0
mirror use raid1

raid 4,5,6 are cpu intensive, maybe a problem on very high speed (if
you have money buy more cpu and no problems)

2011/3/18 NeilBrown <neilb@suse.de>:
> On Fri, 18 Mar 2011 10:43:43 -0500 Stan Hoeppner <stan@hardwarefreak.=
com>
> wrote:
>
>> Christoph Hellwig put forth on 3/18/2011 9:05 AM:
>>
>> Thanks for the confirmations and explanations.
>>
>> > The kernel is pretty smart in placement of user and page cache dat=
a, but
>> > it can't really second guess your intention. =A0With the numactl t=
ool you
>> > can help it doing the proper placement for you workload. =A0Note t=
hat the
>> > choice isn't always trivial - a numa system tends to have memory o=
n
>> > multiple nodes, so you'll either have to find a good partitioning =
of
>> > your workload or live with off-node references. =A0I don't think
>> > partitioning NFS workloads is trivial, but then again I'm not a
>> > networking expert.
>>
>> Bringing mdraid back into the fold, I'm wondering what kinda of load=
 the
>> mdraid threads would place on a system of the caliber needed to push
>> 10GB/s NFS.
>>
>> Neil, I spent quite a bit of time yesterday spec'ing out what I beli=
eve
>
> Addressing me directly in an email that wasn't addressed to me direct=
ly seem
> a bit ... odd. =A0Maybe that is just me.
>
>> is the bare minimum AMD64 based hardware needed to push 10GB/s NFS.
>> This includes:
>>
>> =A0 4 LSI 9285-8e 8port SAS 800MHz dual core PCIE x8 HBAs
>> =A0 3 NIAGARA 32714 PCIe x8 Quad Port Fiber 10 Gigabit Server Adapte=
r
>>
>> This gives us 32 6Gb/s SAS ports and 12 10GbE ports total, for a raw
>> hardware bandwidth of 20GB/s SAS and 15GB/s ethernet.
>>
>> I made the assumption that RAID 10 would be the only suitable RAID l=
evel
>> due to a few reasons:
>>
>> 1. =A0The workload being 50+ NFS large file reads of aggregate 10GB/=
s,
>> yielding a massive random IO workload at the disk head level.
>>
>> 2. =A0We'll need 384 15k SAS drives to service a 10GB/s random IO lo=
ad
>>
>> 3. =A0We'll need multiple "small" arrays enabling multiple mdraid th=
reads,
>> assuming a single 2.4GHz core isn't enough to handle something like =
48
>> or 96 mdraid disks.
>>
>> 4. =A0Rebuild times for parity raid schemes would be unacceptably hi=
gh and
>> would eat all of the CPU the rebuild thread would run on
>>
>> To get the bandwidth we need and making sure we don't run out of
>> controller chip IOPS, my calculations show we'd need 16 x 24 drive
>> mdraid 10 arrays. =A0Thus, ignoring all other considerations momenta=
rily,
>> a dual AMD 6136 platform with 16 2.4GHz cores seems suitable, with o=
ne
>> mdraid thread per core, each managing a 24 drive RAID 10. =A0Would w=
e then
>> want to layer a --linear array across the 16 RAID 10 arrays? =A0If w=
e did
>> this, would the linear thread bottleneck instantly as it runs on onl=
y
>> one core? =A0How many additional memory copies (interconnect transfe=
rs)
>> are we going to be performing per mdraid thread for each block read
>> before the data is picked up by the nfsd kernel threads?
>>
>> How much of each core's cycles will we consume with normal random re=
ad
>
> For RAID10, the md thread plays no part in reads. =A0Which ever threa=
d
> submitted the read submits it all the way down to the relevant member=
 device.
> If the read fails the thread will come in to play.
>
> For writes, the thread is used primarily to make sure the writes are =
properly
> orders w.r.t. bitmap updates. =A0I could probably remove that require=
ment if a
> bitmap was not in use...
>
>> operations assuming 10GB/s of continuous aggregate throughput? =A0Wo=
uld
>> the mdraid threads consume sufficient cycles that when combined with
>> network stack processing and interrupt processing, that 16 cores at
>> 2.4GHz would be insufficient? =A0If so, would bumping the two socket=
s up
>> to 24 cores at 2.1GHz be enough for the total workload? =A0Or, would=
 we
>> need to move to a 4 socket system with 32 or 48 cores?
>>
>> Is this possibly a situation where mdraid just isn't suitable due to=
 the
>> CPU, memory, and interconnect bandwidth demands, making hardware RAI=
D
>> the only real option?
>
> I'm sorry, but I don't do resource usage estimates or comparisons wit=
h
> hardware raid. =A0I just do software design and coding.
>
>
>> =A0 =A0 And if it does requires hardware RAID, would it
>> be possible to stick 16 block devices together in a --linear mdraid
>> array and maintain the 10GB/s performance? =A0Or, would the single
>> --linear array be processed by a single thread? =A0If so, would a si=
ngle
>> 2.4GHz core be able to handle an mdraid --leaner thread managing 8
>> devices at 10GB/s aggregate?
>
> There is no thread for linear or RAID0.
>
> If you want to share load over a number of devices, you would normall=
y use
> RAID0. =A0However if the load had a high thread count and the filesys=
tem
> distributed IO evenly across the whole device space, then linear migh=
t work
> for you.
>
> NeilBrown
>
>
>>
>> Unfortunately I don't currently work in a position allowing me to te=
st
>> such a system, and I certainly don't have the personal financial
>> resources to build it. =A0My rough estimate on the hardware cost is
>> $150-200K USD. =A0The 384 Hitachi 15k SAS 146GB drives at $250 each
>> wholesale are a little over $90k.
>>
>> It would be really neat to have a job that allowed me to setup and t=
est
>> such things. :)
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
