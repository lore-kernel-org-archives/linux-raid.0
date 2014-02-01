From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: sequential versus random I/O
Date: Sat, 01 Feb 2014 12:28:36 -0600
Message-ID: <52ED3CD4.8090801@hardwarefreak.com>
References: <CAJvUf-BbRMXvwwbVvstGPUV7xQpVBqVXLNvTHhYf_wv8=Ws9uw@mail.gmail.com>	<52E9BB3B.7010600@hardwarefreak.com>	<CAJvUf-DsN-z4rYjYC6Ki42ce6PzKjwsLjNGTW9QxEi=hKH_7Wg@mail.gmail.com>	<52EA27D4.6060805@hardwarefreak.com> <CAJvUf-A3ERw-Omn2fRLcZJ=zDOEP-quLe7T5gT6RaVroOpFX3g@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJvUf-A3ERw-Omn2fRLcZJ=zDOEP-quLe7T5gT6RaVroOpFX3g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/30/2014 9:28 AM, Matt Garman wrote:
> On Thu, Jan 30, 2014 at 4:22 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> I wouldn't go used as they do.  Not for something this critical.
> 
> No, not for an actual production system.  I linked that as "conceptual
> inspiration" not as an exact template for what I'd do.  Although, the
> used route might be useful for building a cheap prototype to
> demonstrate proof of concept.
> 
>> If you architect the system correctly, and use decent quality hardware,
>> it won't blow up on you.  If you don't get the OS environment tuned
>> correctly you'll simply get less throughput than desired.  But that can
>> always be remedied with tweaking.
> 
> Right.  I think the general concept is solid, but, as with most
> things, "the devil's in the details".  

Always.

> FWIW, the creator of the DCDW
> enumerated some of the "gotchas" for a build like this[1].  He went
> into more detail in some private correspondence with me.  It's a
> little alarming that he got roughly 50% the performance with a tuned
> Linux setup compared to a mostly out-of-the-box Solaris install.

Most x86-64 Linux distro kernels are built to perform on servers,
desktops, and laptops, thus performance on each is somewhat compromised.
 Solaris x86-64 is built primarily for server duty, and tuned for that
out of the box.  So what you state above isn't too surprising.

> Also, subtle latency issues with PCIe timings across different
> motherboards sounds like a migraine-caliber headache.

This is an issue of board design and Q.A., specifically trace routing
and resulting signal skew, that the buyer can't do anything about.  And
unfortunately this kind of information just isn't "out there" in reviews
and what not when you buy boards.  The best one can do is buy reputable
brand and cross fingers.

>> Each of the two backplanes has 24 drive slots and 6 SFF-8087 connectors.
>>  Each 8087 carries 4 SAS channels.  You connect two ports of each HBA to
>> the top backplane and the other two to the bottom backplane.  I.e. one
>> ...
> 
> Your concept is similar to what I've sketched out in my mind.  My
> twist is that I think I would actually build multiple servers, each
> one would be a 24-disk 2U system.  Our data is fairly easy to
> partition across multiple servers.  Also, we already have a big
> "symlink index" directory that abstracts the actual location of the
> files.  IOW, my users don't know/don't care where the files actually
> live, as long as the symlinks are there and not broken.

That makes tuning each box much easier if you go with a single 10GbE
port.  But this has some downside I'll address down below.

>> Without the cost of NICs you're looking at roughly $19,000 for this
>> configuration, including shipping costs, for a ~22TB DIY SSD based NFS
>> server system expandable to 46TB.  With two quad port 10GbE NICs and
>> SFPs you're at less $25K with the potential for ~6GB/s NFS throughput.
> 
> Yup, and this amount is less than one year's maintenance on the big
> iron system we have in place.  And, quoting the vendor, "Maintenance
> costs only go up."

Yes, it's sad.  "Maintenance Contract" = mostly pure profit.  This is
the Best Buy extended warranty of the big iron marketplace.  You pay a
ton of money and get very little, if anything, in return.

>> In specifying HBAs instead of RAID controllers I am assuming you'll use
>> md/RAID.  With this many SSDs any current RAID controller would slow you
>> down anyway as the ASICs aren't fast enough.  You'll need minimum
>> redundancy to guard against an SSD failure, which means RAID5 with SSDs.
>>  Your workload is almost exclusively read heavy, which means you could
>> simply create a single 24 drive RAID5 or RAID6 with the default 512KB
>> chunk.  I'd go with RAID6.  That will yield a stripe width of
>> 22*512KB=11MB.  Using RAID5/6 allows you to grow the array incrementally
>> without the need for LVM which may slow you down.
> 
> At the expense of storage capacity, I was in my mind thinking of
> raid10 with 3-way mirrors.  We do have backups, but downtime on this
> system won't be taken lightly.

I was in lock step with you until this point.  We're talking about SSDs
aren't we?  And a read-only workload?  RAID10 today is only for
transactional workloads on rust to avoid RMW.  SSD doesn't suffer RMW
latency.  And this isn't a transactional workload, but parallel linear
read.  Three-way mirroring within a RAID 10 setup is used strictly to
avoid losing the 2nd disk in a mirror while its partner is rebuilding in
a standard RAID10.  This is suitable when using large rusty drives where
rebuild times are 8+ hours.  With a RAID10 triple mirror setup 2/3rds of
your capacity is wasted.  This isn't a sane architecture for SSDs and a
read-only workload.  Here's why.  Under optimal conditions

a 4TB 7.2K SAS/SATA mirror rebuild takes 4TB / 130MB/s= ~8.5 hours
a 1TB Sammy 840 EVO mirror rebuild takes 1TB / 500MB/s= ~34 minutes.

A RAID6 rebuild will take a little longer, but still much less than an
hour, say 45 minutes max.  With RAID6 you would have to sustain *two*
additional drive failures within that 45 minute rebuild window to lose
the array.  Only HBA, backplane, or PSU failure could take down two more
drives in 45 minutes, and if that happens you're losing many drives,
probably all of them, and you're sunk anyway.  No matter how you slice
it, I can't see RAID10 being of any benefit here, and especially not
3-way mirror RAID10.

If one of your concerns is decreased client throughput during rebuild,
then simply turn down the rebuild priority to 50%.  Your rebuild will
take 1.5 hours, in which you'd have to lose 2 additional drives to lose
the array, and you'll still have more client throughput at the array
than the network interface can push:

((22*500MB/s) = 11GB/s)/2 = 5.5GB/s client B/W during rebuild
10GbE interface B/W =       1.0GB/s max

Using RAID10 yields no gain but increases cost.  Using RAID10 with 3
mirrors is simply 3 times more cost and 2/3rds wasted capacity.  Any
form of mirroring just isn't suitable for this type of SSD system.

>> Surely you'll use XFS as it's the only Linux filesystem suitable for
>> such a parallel workload.  As you will certainly grow the array in the
>> future, I'd format XFS without stripe alignment and have it do 4KB IOs.
>> ...
> 
> I was definitely thinking XFS.  But one other motivation for multiple
> 2U systems (instead of one massive system) is that it's more modular.

The modular approach has advantages.  But keep in mind that modularity
increases complexity and component count, which increase the probability
of a failure.  The more vehicles you own the more often one of them is
in the shop at any given time, if even only for an oil change.

> Existing systems never have to be grown or reconfigured.  When we need
> more space/throughput, I just throw another system in place.  I might
> have to re-distribute the data, but this would be a very rare (maybe
> once/year) event.

Gluster has advantages here as it can redistribute data automatically
among the storage nodes.  If you do distributed mirroring you can take a
node completely offline for maintenance, and client's won't skip a beat,
or at worst a short beat.  It costs half your storage for the mirroring,
but using RAID6 it's still ~33% less than the RAID10 w/3 way mirrors.

> If I get the green light to do this, I'd actually test a few
> configurations.  But some that come to mind:
>     - raid10,f3

Skip it.  RAID10 is a no go.  And, none of the alternate layouts will
provide any benefit because SSDs are not spinning rust.  The alternate
layouts exist strictly to reduce rotational latency.

>     - groups of 3-way raid1 mirrors striped together with XFS

I covered this above.  Skip it.  And you're thinking of XFS over
concatenated mirror sets here.  This architecture is used only for high
IOPS transactional workloads on rust.  It won't gain you anything with SSDs.

>     - groups of raid6 sets not striped together (our symlink index I
> mentioned above makes this not as messy as it sounds)

If you're going with multiple identical 24 bay nodes, you want a single
24 drive md/RAID6 in each directly formatted with XFS.  Or Gluster atop
XFS.  It's the best approach for your read only workload with large files.

>> The last point I'll make is that it may require some serious tweaking of
>> IRQ load balancing, md/RAID, NFS, Ethernet bonding driver, etc, to wring
>> peak throughput out of such a DIY SSD system.  Achieving ~1GB/s parallel
>> NFS throughput from a DIY rig with a single 10GbE port isn't horribly
>> difficult.  3+GB/s parallel NFS via bonded 10GbE interfaces is a bit
>> more challenging.
> 
> I agree, I think that comes back around to what we said above: the
> concept is simple, but the details mean the difference between
> brilliant and mediocre.

The details definitely become a bit easier with one array and one NIC
per node.  But one thing really bothers me about such a setup.  You have
~11GB/s read throughput with 22 SSDs (24 RAID6).  It doesn't make sense
to waste ~10GB/s of SSD throughput by using a single 10GbE interface.
At the very least you should be using 4x 10GbE ports per box to achieve
potentially 3+ GB/s.

I think what's happening here is that you're saving so much money
compared to the proprietary NAS filer that you're intoxicated by the
savings.  You're throwing money around on SSDs like a drunken sailor on
6 month leave at a strip club. :)  And without fully understanding the
implications, the capability that you're buying, and putting in each box.

> Thanks for your input Stan, I appreciate it.  I'm an infrequent poster
> to this list, but a long-time reader, and I've learned a lot from your
> posts over the years.

Glad someone actually reads my drivel on occasion. :)


I'm firmly an AMD guy.  I used the YMI 48 bay Intel server in my
previous example for expediency, and to avoid what I'm doing here now.
Please allow me to indulge you with a complete parts list for one fully
DIY NFS server node build.  I've matched and verified compatibility of
all of the components, using manufacturer specs, down to the iPASS/SGPIO
SAS cables.  Combined with the LSI HBAs and this SM backplane, these
sideband signaling SAS cables should enable you to make drive failure
LEDs work with mdadm, using:
http://sourceforge.net/projects/ledmon/

I've not tried the software myself, but if it's up to par, dead drive
identification should work the same as with any vendor storage array,
which to this point has been nearly impossible with md arrays using
plain non-RAID HBAs.

Preemptively flashing the mobo and SAS HBAs with the latest firmware
image should prevent any issues with the hardware.  These products have
"shelf" firmware which is often quite a few revs old by the time the
customer receives product.

All but one of the necessary parts are stocked by NewEgg believe it or
not.  The build consists of a 24 bay 2U SuperMicro 920W dual HS PSU,
SuperMicro dual socket C32 mobo w/5 PCIe 2.0 x8 slots, 2x Opteron 4334
3.1GHz 6 core CPUs, 2 Dynatron C32/1207 2U CPU coolers, 8x Kingston 4GB
ECC registered DDR3-1333 single rank DIMMs, 3x LSI 9207-8i PCIe 3.0 x8
SAS HBAs, rear 2 drive HS cage, 2x Samsung 120GB boot SSDs, 24x Samsung
1TB data SSDs, 6x 2ft LSI SFF-8087 sideband cables, and two dual port
Intel 10GbE NICs sans SFPs as you probably already have some spares.
You may prefer another NIC brand/model.  These are <$800 of the total.

1x  http://www.newegg.com/Product/Product.aspx?Item=N82E16811152565
1x  http://www.newegg.com/Product/Product.aspx?Item=N82E16813182320
2x  http://www.newegg.com/Product/Product.aspx?Item=N82E16819113321
2x  http://www.newegg.com/Product/Product.aspx?Item=N82E16835114139
8x  http://www.newegg.com/Product/Product.aspx?Item=N82E16820239618
3x  http://www.newegg.com/Product/Product.aspx?Item=N82E16816118182
24x http://www.newegg.com/Product/Product.aspx?Item=N82E16820147251
2x  http://www.newegg.com/Product/Product.aspx?Item=N82E16820147247
6x  http://www.newegg.com/Product/Product.aspx?Item=N82E16812652015
2x  http://www.newegg.com/Product/Product.aspx?Item=N82E16833106044

1x
http://www.costcentral.com/proddetail/Supermicro_Storage_drive_cage/MCP220826090N/11744345/

Total cost today:  $16,927.23
SSD cost:          $13,119.98

Note all SSDs are direct connected to the HBAs.  This system doesn't
suffer any disk bandwidth starvation due to SAS expanders as with most
storage arrays.  As such you get nearly full bandwidth per drive, being
limited only by the NorthBridge to CPU HT link.  At the hardware level
the system bandwidth breakdown is as follow:

Memory:		42.6 GB/s
PCIe to CPU:	10.4 GB/s unidirectional x2
HBA to PCIe:	12 GB/s unidirectional x2
SSD to HBA:	12 GB/s unidirectional x2
PCIe to NIC:	8 GB/s unidirectional x2
NIC to client:  4 GB/s unidirectional x2

Your HBA traffic will flow on the HT uplink and your NIC traffic on the
down link, so you are non constrained here with this NFS read only workload.

Assuming an 8:1 bandwidth ratio between file bytes requested and memory
bandwidth consumed by the kernel in the form of DMA xfers to/from buffer
cache, memory-memory copies for TCP and NFS, and hardware overhead in
the form of coherency traffic between the CPUs and HBAs, interrupts in
the form of MSI-X writes to memory, etc, then 4GB/s of requested data
generates ~32GB/s at the memory controllers before transmitted over the
wire.  Beyond tweaking parameters, it may require building a custom
kernel to achieve this throughput.  But the hardware is capable.  Using
a single 10GbE interface yields 1/10th of the SSD b/w to clients.  This
is a huge waste of $$ spent on the SSDs.  Using 4 will come close to
maxing out the rest of the hardware so I spec'd 4 ports.  With the
correct bonding setup you should be able to get between 3-4GB/s.  Still
only 1/4th - 1/3rd the SSD throughput.

To get close to taking near full advantage of the 12GB/s read bandwidth
offered by these 24 SSDs requires a box with dual Socket G34 processors
to get 8 DDR3-1333 memory channels--85GB/s--two SR5690 PCIe to HT
controllers, 8x 10GbE ports (or 2x QDR Infiniband 4x).  Notice I didn't
discuss CPU frequency or core count anywhere?  That's because it's not a
factor.  The critical factor is memory bandwidth.  Any single/dual
Opteron 4xxx/6xxx system with ~8 or more cores should do the job as long
as IRQs are balanced across cores.

Hope you at least found this an interesting read, if not actionable.
Maybe others will as well.  I had some fun putting this one together.  I
think the only things I omitted were Velcro straps and self stick lock
loops for tidying up the cables for optimum airflow.  Experienced
builders usually have these on hand, but I figured I'd mention them just
in case.  Locating certified DIMMs in the clock speed and rank required
took too much time, but this was not unforeseen.  The only easy way to
spec memory for server boards and allow max expansion is to go with the
lowest clock speed.  If I'd done that here you'd lose 17GB/s of memory
bandwidth, a 40% reduction.  I also wanted to use a single socket G34
board, but unfortunately nobody makes one with more than 3 PCIe slots.
This design required at least 4.

-- 
Stan
