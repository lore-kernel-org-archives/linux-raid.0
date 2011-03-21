From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: high throughput storage server?
Date: Mon, 21 Mar 2011 03:44:52 +0100
Message-ID: <20110321024452.GA23100@www2.open-std.org>
References: <4D7E0994.3020303@hardwarefreak.com> <20110314124733.GA31377@infradead.org> <4D835B2A.1000805@hardwarefreak.com> <20110318140509.GA26226@infradead.org> <4D837DAF.6060107@hardwarefreak.com> <20110319090101.1786cc2a@notabene.brown> <4D8559A2.6080209@hardwarefreak.com> <20110320144147.29141f04@notabene.brown> <AANLkTi=2k2=YuZAggonLfKmRFxFd-rXvNo=xkpqWyQNU@mail.gmail.com> <4D868C36.5050304@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D868C36.5050304@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Mdadm <linux-raid@vger.kernel.org>, Roberto Spadim <roberto@spadim.com.br>, NeilBrown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids

On Sun, Mar 20, 2011 at 06:22:30PM -0500, Stan Hoeppner wrote:
> Roberto Spadim put forth on 3/20/2011 12:32 AM:
> 
> > i think it's better contact ibm/dell/hp/compaq/texas/anyother and talk
> > about the problem, post results here, this is a nice hardware question
> > :)
> 
> I don't need vendor assistance to design a hardware system capable of
> the 10GB/s NFS throughput target.  That's relatively easy.  I've already
> specified one possible hardware combination capable of this level of
> performance (see below).  The configuration will handle 10GB/s using the
> RAID function of the LSI SAS HBAs.  The only question is if it has
> enough individual and aggregate CPU horsepower, memory, and HT
> interconnect bandwidth to do the same using mdraid.  This is the reason
> for my questions directed at Neil.
> 
> > don't tell about software raid, just the hardware to allow this
> > bandwidth (10gb/s) and share files
> 
> I already posted some of the minimum hardware specs earlier in this
> thread for the given workload I described.  Following is a description
> of the workload and a complete hardware specification.
> 
> Target workload:
> 
> 10GB/s continuous parallel NFS throughput serving 50+ NFS clients whose
> application performs large streaming reads.  At the storage array level
> the 50+ parallel streaming reads become a random IO pattern workload
> requiring a huge number of spindles due to the high seek rates.
> 
> Minimum hardware requirements, based on performance and cost.  Ballpark
> guess on total cost of the hardware below is $150-250k USD.  We can't
> get the data to the clients without a network, so the specification
> starts with the switching hardware needed.
> 
> Ethernet switches:
>    One HP A5820X-24XG-SFP+ (JC102A) 24 10 GbE SFP ports
>       488 Gb/s backplane switching capacity
>    Five HP A5800-24G Switch (JC100A) 24 GbE ports, 4 10GbE SFP
>       208 Gb/s backplane switching capacity
>    Maximum common MTU enabled (jumbo frame) globally
>    Connect 12 server 10 GbE ports to A5820X
>    Uplink 2 10 GbE ports from each A5800 to A5820X
>        2 open 10 GbE ports left on A5820X for cluster expansion
>        or off cluster data transfers to the main network
>    Link aggregate 12 server 10 GbE ports to A5820X
>    Link aggregate each client's 2 GbE ports to A5800s
>    Aggregate client->switch bandwidth = 12.5 GB/s
>    Aggregate server->switch bandwidth = 15.0 GB/s
>    The excess server b/w of 2.5GB/s is a result of the following:
>        Allowing headroom for an additional 10 clients or out of cluster
>           data transfers
>        Balancing the packet load over the 3 quad port 10 GbE server NICs
>           regardless of how many clients are active to prevent hot spots
>           in the server memory and interconnect subsystems
> 
> Server chassis
>    HP Proliant DL585 G7 with the following specifications
>    Dual AMD Opteron 6136, 16 cores @2.4GHz
>    20GB/s node-node HT b/w, 160GB/s aggregate
>    128GB DDR3 1333, 16x8GB RDIMMS in 8 channels
>    20GB/s/node memory bandwidth, 80GB/s aggregate
>    7 PCIe x8 slots and 4 PCIe x16
>    8GB/s/slot, 56 GB/s aggregate PCIe x8 bandwidth
> 
> IO controllers
>    4 x LSI SAS 9285-8e 8 port SAS, 800MHz dual core ROC, 1GB cache
>    3 x NIAGARA 32714 PCIe x8 Quad Port Fiber 10 Gigabit Server Adapter
> 
> JBOD enclosures
>    16 x LSI 620J 2U 24 x 2.5" bay SAS 6Gb/s, w/SAS expander
>    2 SFF 8088 host and 1 expansion port per enclosure
>    384 total SAS 6GB/s 2.5" drive bays
>    Two units are daisy chained with one in each pair
>       connecting to one of 8 HBA SFF8088 ports, for a total of
>       32 6Gb/s SAS host connections, yielding 38.4 GB/s full duplex b/w
> 
> Disks drives
>    384 HITACHI Ultrastar C15K147 147GB 15000 RPM 64MB Cache 2.5" SAS
>       6Gb/s Internal Enterprise Hard Drive
> 
> 
> Note that the HBA to disk bandwidths of 19.2GB/s one way and 38.4GB/s
> full duplex are in excess of the HBA to PCIe bandwidths, 16 and 32GB/s
> respectively, by approximately 20%.  Also note that each drive can
> stream reads at 160MB/s peak, yielding 61GB/s aggregate streaming read
> capacity for the 384 disks.  This is almost 4 times the aggregate one
> way transfer rate of the 4 PCIe x8 slots, and is 6 times our target host
> to parallel client data rate of 10GB/s.  There are a few reasons why
> this excess of capacity is built into the system:
> 
> 1.  RAID10 is the only suitable RAID level for this type of system with
> this many disks, for many reasons that have been discussed before.
> RAID10 instantly cuts the number of stripe spindles in two, dropping the
> data rate by a factor of 2, giving us 30.5GB/s potential aggregate
> throughput.  Now we're only at 3 times out target data rate.
> 
> 2.  As a single disk drive's seek rate increases, its transfer rate
> decreases in relation to its single streaming read performance.
> Parallel streaming reads will increase seek rates as the disk head must
> move between different regions of the disk platter.
> 
> 3.  In relation to 2, if we assume we'll lose no more than 66% of our
> single streaming performance with a multi stream workload, we're down to
> 10.1GB/s throughput, right at our target.
> 
> By using relatively small arrays of 24 drives each (12 stripe spindles),
> concatenating (--linear) the 16 resulting arrays, and using a filesystem
> such as XFS across the entire array with its intelligent load balancing
> of streams using allocation groups, we minimize disk head seeking.
> Doing this can in essence divide our 50 client streams across 16 arrays,
> with each array seeing approximately 3 of the streaming client reads.
> Each disk should be able to easily maintain 33% of its max read rate
> while servicing 3 streaming reads.
> 
> I hope you found this informative or interesting.  I enjoyed the
> exercise.  I'd been working on this system specification for quite a few
> days now but have been hesitant to post it due to its length, and the
> fact that AFAIK hardware discussion is a bit OT on this list.
> 
> I hope it may be valuable to someone Google'ing for this type of
> information in the future.
> 
> -- 
> Stan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Are you then building the system yourself, and running Linux MD RAID?

Anyway, with 384 spindles and only 50 users, each user will have in
average 7 spindles for himself. I think much of the time this would mean 
no random IO, as most users are doing large sequential reading. 
Thus on average you can expect quite close to striping speed if you
are running RAID capable of striping. 

I am puzzled about the --linear concatenating. I think this may cause
the disks in the --linear array to be considered as one spindle, and thus
no concurrent IO will be made. I may be wrong there.

best regards
Keld
