From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: sequential versus random I/O
Date: Thu, 30 Jan 2014 04:22:12 -0600
Message-ID: <52EA27D4.6060805@hardwarefreak.com>
References: <CAJvUf-BbRMXvwwbVvstGPUV7xQpVBqVXLNvTHhYf_wv8=Ws9uw@mail.gmail.com>	<52E9BB3B.7010600@hardwarefreak.com> <CAJvUf-DsN-z4rYjYC6Ki42ce6PzKjwsLjNGTW9QxEi=hKH_7Wg@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJvUf-DsN-z4rYjYC6Ki42ce6PzKjwsLjNGTW9QxEi=hKH_7Wg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/29/2014 9:20 PM, Matt Garman wrote:
> On Wed, Jan 29, 2014 at 8:38 PM, Stan Hoeppner <stan@hardwarefreak.co=
m> wrote:
>> If your workflow description is accurate, and assuming you're trying=
 to
>> fix a bottleneck at the NFS server, the solution to this is simple, =
and
>> very well known:  local scratch space.  Given your workflow descript=
ion
>> it's odd that you're not already doing so.  Which leads me to believ=
e
>> that the description isn't entirely accurate.  If it is, you simply =
copy
>> each file to local scratch disk and iterate over it locally.  If you=
're
>> using diskless compute nodes then that's an architectural
>> flaw/oversight, as this workload as described begs for scratch disk.
>=20
> There really is no bottleneck now, but looking into the future, there
> will be a bottleneck at the next addition of compute nodes.  I've
> thought about local caching at the compute node level, but I don't
> think it will help.  The total collection of big files on the NFS
> server is upwards of 20 TB.  Processes are distributed randomly acros=
s
> compute nodes, and any process could access any part of that 20 TB
> file collection.  (My description may have implied there is a 1-to-1
> process-to-file mapping, but that is not the case.)  So the local
> scratch space would have to be quite big to prevent thrashing.  In
> other words, unless the local cache was multi-terrabyte in size, I'm
> quite confident that the local cache would actually degrade
> performance due to constant turnover.
>=20
> Furthermore, let's simplify the workflow: say there is only one
> compute server, and it's local disk is sufficiently large to hold the
> entire data set (assume 20 TB drives exist with performance
> characteristics similar to today's spinning drives).  In other words,
> there is no need for the NFS server now.  I believe even in this
> scenario, the single local disk would be a bottleneck to the dozens o=
f
> programs running on the node... these compute nodes are typically dua=
l
> socket, 6 or 8 core systems.  The computational part is fast enough o=
n
> modern CPUs that the I/O workload can be realistically approximated b=
y
> dozens of parallel "dd if=3D/random/big/file of=3D/dev/null" processe=
s,
> all accessing different files from the collection.  In other words,
> very much like my contrived example of multiple parallel read
> benchmark programs.
>
> FWIW, the current NFS server is from a big iron storage vendor.  It's
> made up of 96 15k SAS drives.  A while ago we were hitting a
> bottleneck on the spinning disks, so the vendor was happy to sell us =
1
> TB of their very expensive SSD cache module.  This worked quite well
> at reducing spinning disk utilization, and cache module utilization
> was quite high.  The recent compute node expansion has lowered cache
> utilization at the expense of spinning disk utilization... things are
> still chugging along acceptably, but we're at capacity.  We've maxed
> out at just under 3 GB/sec of throughput (that's gigabytes, not bits)=
=2E
>=20
> What I'm trying to do is decide if we should continue to pay expensiv=
e
> maintenance and additional cache upgrades to our current device, or i=
f
> I might be better served by a DIY big array of consumer SSDs, ala the
> "Dirt Cheap Data Warehouse" [1]. =20

I wouldn't go used as they do.  Not for something this critical.

> I don't see too many people building
> big arrays of consumer-grade SSDs, or even vendors selling pre-made
> big SSD based systems.  (To be fair, you can buy big SSD arrays, but
> with crazy-expensive *enterprise* SSD... we have effectively a WORM
> workload, so don't need the write endurance features of enterprise
> SSD.  I think that's where the value opportunity comes in for us.)

I absolutely agree.

> Anyway, I'm just looking for reasons why taking on such a project
> might blow up in my face=20

If you architect the system correctly, and use decent quality hardware,
it won't blow up on you.  If you don't get the OS environment tuned
correctly you'll simply get less throughput than desired.  But that can
always be remedied with tweaking.

> (assuming I can convince the check-writer to
> basically fund a storage R&D project).

How big a check?  24x 1TB Samsung SSDs will run you $12,000:
http://www.newegg.com/Product/Product.aspx?Item=3DN82E16820147251

A suitable server with 48 2.5" SAS bays sans HBAs and NICs will run
$5,225.00:
http://www.rackmountpro.com/products/servers/5u-servers/details/&pnum=3D=
YM5U52652&cpu=3Dint

CPU:	2x Intel=AE Xeon=AE Processor E5-2630v2 6 core (2.6/3.1 Ghz 80W)
RAM:	8x 8GB DDR3 1600MHz ECC Registered Memory
OSD:	2x 2.5" SSD 120GB SATA III 6Gb/s
NET:	Integrated Quad Intel GbE
Optical
Drive:	8x Slim Internal DVD-RW
PSU:	1140W R3G5B40V4V 2+1 redundant power supply
OS:	No OS
3 year warranty

3x LSI 9201-16i SAS HBAs:  $1,100
http://www.newegg.com/Product/Product.aspx?Item=3DN82E16816118142

Each of the two backplanes has 24 drive slots and 6 SFF-8087 connectors=
=2E
 Each 8087 carries 4 SAS channels.  You connect two ports of each HBA t=
o
the top backplane and the other two to the bottom backplane.  I.e. one
HBA controls the left 16 drives, one controls the middle 16 drives, and
one controls the right 16 drives.  Starting with 24 drives in the top
tray, each HBA controls 8 drives.

These 3 HBAs are 8 lane PCIe 2.0 and provide an aggregate peak
uni/bi-directional throughput of ~12/24 GB/s.  Samsung 840 EVO raw read
throughput is ~0.5GB/s * 24 drives =3D 12GB/s.  Additional SSDs will no=
t
provide much increased throughput, if any, as the HBAs are pretty well
maxed at 24 drives.  This doesn't matter as your network throughput wil=
l
be much less.

Speaking of network throughput, if you're not using Infiniband but
10GbE, you'll want to acquire this 6 port 10 GbE NIC.  I don't have a
price:  http://www.interfacemasters.com/pdf/Niagara_32716.pdf

With proper TX load balancing and the TCP stack well tuned you'll have =
a
potential peak of ~6GB/s of NFS throughput.  They offer dual and quad
port models as well if you want two cards for redundancy:

http://www.interfacemasters.com/products/server-adapters/server-adapter=
s-product-matrix.html#twoj_fragment1-5

Without the cost of NICs you're looking at roughly $19,000 for this
configuration, including shipping costs, for a ~22TB DIY SSD based NFS
server system expandable to 46TB.  With two quad port 10GbE NICs and
SFPs you're at less $25K with the potential for ~6GB/s NFS throughput.


In specifying HBAs instead of RAID controllers I am assuming you'll use
md/RAID.  With this many SSDs any current RAID controller would slow yo=
u
down anyway as the ASICs aren't fast enough.  You'll need minimum
redundancy to guard against an SSD failure, which means RAID5 with SSDs=
=2E
 Your workload is almost exclusively read heavy, which means you could
simply create a single 24 drive RAID5 or RAID6 with the default 512KB
chunk.  I'd go with RAID6.  That will yield a stripe width of
22*512KB=3D11MB.  Using RAID5/6 allows you to grow the array incrementa=
lly
without the need for LVM which may slow you down.

Surely you'll use XFS as it's the only Linux filesystem suitable for
such a parallel workload.  As you will certainly grow the array in the
future, I'd format XFS without stripe alignment and have it do 4KB IOs.
 Stripe alignment won't gain you anything with this workload on SSDs,
but it could cause performance problems after you grow the array, at
which point the XFS stripe alignment will not match the new array
geometry.  mkfs.xfs will auto align to the md geometry, so forcing it t=
o
use the default 4KB single FS block alignment will be necessary.  I can
help you with this if you indeed go down this path.

The last point I'll make is that it may require some serious tweaking o=
f
IRQ load balancing, md/RAID, NFS, Ethernet bonding driver, etc, to wrin=
g
peak throughput out of such a DIY SSD system.  Achieving ~1GB/s paralle=
l
NFS throughput from a DIY rig with a single 10GbE port isn't horribly
difficult.  3+GB/s parallel NFS via bonded 10GbE interfaces is a bit
more challenging.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
