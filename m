From: NeilBrown <neilb@suse.de>
Subject: Re: high throughput storage server?
Date: Sat, 19 Mar 2011 09:01:01 +1100
Message-ID: <20110319090101.1786cc2a@notabene.brown>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D837DAF.6060107@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Christoph Hellwig <hch@infradead.org>, Roberto Spadim <roberto@spadim.com.br>, Drew <drew.kay@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 18 Mar 2011 10:43:43 -0500 Stan Hoeppner <stan@hardwarefreak.com>
wrote:

> Christoph Hellwig put forth on 3/18/2011 9:05 AM:
> 
> Thanks for the confirmations and explanations.
> 
> > The kernel is pretty smart in placement of user and page cache data, but
> > it can't really second guess your intention.  With the numactl tool you
> > can help it doing the proper placement for you workload.  Note that the
> > choice isn't always trivial - a numa system tends to have memory on
> > multiple nodes, so you'll either have to find a good partitioning of
> > your workload or live with off-node references.  I don't think
> > partitioning NFS workloads is trivial, but then again I'm not a
> > networking expert.
> 
> Bringing mdraid back into the fold, I'm wondering what kinda of load the
> mdraid threads would place on a system of the caliber needed to push
> 10GB/s NFS.
> 
> Neil, I spent quite a bit of time yesterday spec'ing out what I believe

Addressing me directly in an email that wasn't addressed to me directly seem
a bit ... odd.  Maybe that is just me.

> is the bare minimum AMD64 based hardware needed to push 10GB/s NFS.
> This includes:
> 
>   4 LSI 9285-8e 8port SAS 800MHz dual core PCIE x8 HBAs
>   3 NIAGARA 32714 PCIe x8 Quad Port Fiber 10 Gigabit Server Adapter
> 
> This gives us 32 6Gb/s SAS ports and 12 10GbE ports total, for a raw
> hardware bandwidth of 20GB/s SAS and 15GB/s ethernet.
> 
> I made the assumption that RAID 10 would be the only suitable RAID level
> due to a few reasons:
> 
> 1.  The workload being 50+ NFS large file reads of aggregate 10GB/s,
> yielding a massive random IO workload at the disk head level.
> 
> 2.  We'll need 384 15k SAS drives to service a 10GB/s random IO load
> 
> 3.  We'll need multiple "small" arrays enabling multiple mdraid threads,
> assuming a single 2.4GHz core isn't enough to handle something like 48
> or 96 mdraid disks.
> 
> 4.  Rebuild times for parity raid schemes would be unacceptably high and
> would eat all of the CPU the rebuild thread would run on
> 
> To get the bandwidth we need and making sure we don't run out of
> controller chip IOPS, my calculations show we'd need 16 x 24 drive
> mdraid 10 arrays.  Thus, ignoring all other considerations momentarily,
> a dual AMD 6136 platform with 16 2.4GHz cores seems suitable, with one
> mdraid thread per core, each managing a 24 drive RAID 10.  Would we then
> want to layer a --linear array across the 16 RAID 10 arrays?  If we did
> this, would the linear thread bottleneck instantly as it runs on only
> one core?  How many additional memory copies (interconnect transfers)
> are we going to be performing per mdraid thread for each block read
> before the data is picked up by the nfsd kernel threads?
> 
> How much of each core's cycles will we consume with normal random read

For RAID10, the md thread plays no part in reads.  Which ever thread
submitted the read submits it all the way down to the relevant member device.
If the read fails the thread will come in to play.

For writes, the thread is used primarily to make sure the writes are properly
orders w.r.t. bitmap updates.  I could probably remove that requirement if a
bitmap was not in use...

> operations assuming 10GB/s of continuous aggregate throughput?  Would
> the mdraid threads consume sufficient cycles that when combined with
> network stack processing and interrupt processing, that 16 cores at
> 2.4GHz would be insufficient?  If so, would bumping the two sockets up
> to 24 cores at 2.1GHz be enough for the total workload?  Or, would we
> need to move to a 4 socket system with 32 or 48 cores?
> 
> Is this possibly a situation where mdraid just isn't suitable due to the
> CPU, memory, and interconnect bandwidth demands, making hardware RAID
> the only real option?

I'm sorry, but I don't do resource usage estimates or comparisons with
hardware raid.  I just do software design and coding.


>     And if it does requires hardware RAID, would it
> be possible to stick 16 block devices together in a --linear mdraid
> array and maintain the 10GB/s performance?  Or, would the single
> --linear array be processed by a single thread?  If so, would a single
> 2.4GHz core be able to handle an mdraid --leaner thread managing 8
> devices at 10GB/s aggregate?

There is no thread for linear or RAID0.

If you want to share load over a number of devices, you would normally use
RAID0.  However if the load had a high thread count and the filesystem
distributed IO evenly across the whole device space, then linear might work
for you.

NeilBrown


> 
> Unfortunately I don't currently work in a position allowing me to test
> such a system, and I certainly don't have the personal financial
> resources to build it.  My rough estimate on the hardware cost is
> $150-200K USD.  The 384 Hitachi 15k SAS 146GB drives at $250 each
> wholesale are a little over $90k.
> 
> It would be really neat to have a job that allowed me to setup and test
> such things. :)
> 

