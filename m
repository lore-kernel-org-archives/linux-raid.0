From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?  GPFS w/ 10GB/s throughput to
 the rescue
Date: Sun, 27 Feb 2011 08:55:56 -0600
Message-ID: <4D6A65FC.1030401@hardwarefreak.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>	<AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com>	<20110215044434.GA9186@septictank.raw-sewage.fake>	<4D5A98BF.3030704@gmail.com> <AANLkTin+BWOn+45Y8op7k6cFymmv1VgLrh9Ro9sU7nPJ@mail.gmail.com> <4D66CBB8.5010804@gmail.com> <4D6992CE.60803@hardwarefreak.com> <4D69A154.3030403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D69A154.3030403@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Joe Landman put forth on 2/26/2011 6:56 PM:

> Local drives (as you suggested
> later on) will deliver 75-100 MB/s of bandwidth, and he'd need 2 for
> RAID1, as well as a RAID0 (e.g. RAID10) for local bandwidth (150+ MB/s).
>  4 drives per unit, 50 units.  200 drives.

Yes, this is pretty much exactly what I mentioned.  ~5GB/s aggregate.
But we've still not received an accurate detailed description from Matt
regarding his actual performance needs.  He's not posted iostat numbers
from his current filer, or any similar metrics.

> Any admin want to admin 200+ drives in 50 chassis?  Admin 50 different
> file systems?

GPFS has single point administration for all storage in all nodes.

> Oh, and what is the impact if some of those nodes went away?  Would they
> take down the file system?  In the cloud of microdisk model Stan
> suggested, yes they would.  

No, they would not.  GPFS has multiple redundancy mechanisms and can
sustain multiple node failures.  I think you should read the GPFS
introductory documentation:

http://www.ibm.com/common/ssi/fcgi-bin/ssialias?infotype=SA&subtype=WH&appname=STGE_XB_XB_USEN&htmlfid=XBW03010USEN&attachment=XBW03010USEN.PDF

> Which is why you might not want to give that
> advice serious consideration.  Unless you built in replication.  Now we
> are at 400 disks in 50 chassis.

Your numbers are wrong, by a factor of 2.  He should research GPFS and
give it serious consideration.  It may be exactly what he needs.

> Again, this design keeps getting worse.

Actually it's getting better, which you'll see after reading the docs.

> Now this is sad, very sad.
> 
> Stan started out selling the Nexsan version of things (and why was he

For the record, I'm not selling anything.  I don't have a $$ horse in
this race.  I'm simply trying to show Matt some good options.  I don't
work for any company selling anything.  I'm just an SA, giving free
advice to another SA with regard to his request for information.  I just
happen to know a lot more about high performance storage than the
average SA.  I recommend Nexsan products because I've used them, they
work very well, and are very competitive WRT price/performance/capacity.

> doing it on the MD RAID list I wonder?), 

The OP asked for possible solutions to solve for his need.  This need
may not necessarily be best met by mdraid, regardless of the fact he
asked on the Linux RAID list.  LED identification of a failed drive is
enough reason for me to not recommend mdraid in this solution, given the
fact he'll only have 4 disks per chassis w/an inbuilt hardware RAID
chip.  I'm guessing fault LED is one of the reasons why you use a
combination of PCIe RAID cards and mdraid in your JackRabbit and Delta-V
systems instead of strictly mdraid.  I'm not knocking it.  That's the
only way to do it properly on such systems.  Likewise, please don't
knock me for recommending the obvious better solution in this case.
mdraid would have not materially positive impact, but would introduce
maintenance problems.

> which would have run into the
> same costs Stan noted later.  Now Stan is selling (actually mis-selling)
> GPFS (again, on an MD RAID list, seemingly having picked it off of a
> website), without having a clue as to the pricing, implementation,
> issues, etc.

I first learned of GPFS in 2001 when it was deployed on the 256 node IBM
Netfinity dual P3 933 Myrinet cluster at Maui High Performance Computing
Center.  GPFS was deployed in this cluster using what is currently
called the Network Shared Disk protocol, spanning the 512 local disks.
GPFS has grown and matured significantly in the 10 years since.  Today
it is most commonly deployed with a dedicated file server node farm
architecture, but it still works just as well using NSD.  In the
configuration I suggested, each node will be an NSD client and NSD
server.  GPFS is renowned for its reliability and performance in the
world of HPC cluster computing due to its excellent 10+ year track
record in the field.  It is years ahead of any other cluster filesystem
in capability, performance, manageability, and reliability.

> I did suggest using GlusterFS as it will help with a number of aspects,
> has an open source version.  I did also suggest (since he seems to wish
> to build it himself) that he pursue a reasonable design to start with,

I don't believe his desire is to actually DIY the compute and/or storage
nodes.  If it is, for a production system of this size/caliber, *I*
wouldn't DIY in this case, and I'm the king of DIY hardware.  Actually,
I'm TheHardwareFreak.  ;)  I guess you've missed the RHS of my email
addy. :)  I was given that nickname, flattering or not, about 15 years
ago.  Obviously it stuck.  It's been my vanity domain for quite a few years.

> and avoid the filer based designs Stan suggested (two Nexsan's and some
> sort of filer head to handle them), or a SAN switch of some sort.

There's nothing wrong with a single filer, just because it's a single
filer.  I'm sure you've sold some singles.  They can be very performant.
 I could build a single DIY 10 GbE filer today from white box parts
using JBOD enclosures that could push highly parallel NFS client reads
at ~4GB/s all day long, about double the performance of your JackRabbit
5U.  It would take me some time to tune PCIe interrupt routing, TCP, NFS
server threading, etc, but it can be done.  Basic parts list would be
something like:

1 x SuperMicro H8DG6 w/dual 8 core 2GHz Optys, 8x4GB DDR3 ECC RDIMMs
3 x LSI MegaRAID SAS 9280-4i4e PCIe x8 512MB cache
1 x NIAGARA 32714L Quad Port Fiber 10 Gigabit Ethernet NIC
1 x SUPERMICRO CSE-825TQ-R700LPB Black 2U Rackmount 700W redundant PSU
3 x NORCO DS-24E External 4U 24 Bay 6G SAS w/LSI 4x6 SAS expander
74 x Seagate ST3300657SS 15K 300GB 6Gb/s SAS, 2 boot, 72 in JBOD chassis
Configure 24 drive HW RAID6 on each LSI HBA, mdraid linear over them
Format the mdraid device with mkfs.xfs with "-d agcount=66"

With this setup the disks will saturate the 12 SAS host channels at
7.2GB/s aggregate with concurrent parallel streaming reads, as each 22
drive RAID6 will be able to push over 3GB/s with 15k drives.  This
excess of disk bandwidth, and high random IOPS of the 15k drives,
ensures that highly random read loads from many concurrent NFS clients
will still hit in the 4GB/s range, again, after the system has been
properly tuned.

> Neither design works well in his scenario, or for that matter, in the
> vast majority of HPC situations.

Why don't you ask Matt, as I have, for an actual, accurate description
of his workload.  What we've been given isn't an accurate description.
If it was, his current production systems would be so overwhelmed he'd
already be writing checks for new gear.  I've seen no iostat or other
metrics, which are standard fair when asking for this kind of advice.

> I did make a full disclosure of my interests up front, and people are
> free to take my words with a grain of salt.  Insinuating based upon my
> disclosure?  Sad.

It just seems to me you're too willing to oversell him.  He apparently
doesn't have that kind of budget anyway.  If we, you, me, anyone, really
wants to give Matt good advice, regardless of how much you might profit,
or mere satisfaction I may gain because one of my suggestions was
implemented, why don't we both agree to get as much information as
possible from Matt before making any more recommendations?

I think we've both forgotten once or twice in this thread that it's not
about us, but about Matt's requirement.

> See GlusterFS.  Open source at zero cost.  However, and this is a large
> however, this design, using local storage for a pooled "cloud" of disks,
> has some often problematic issues (resiliency, performance, hotspots). A
> truly hobby design would use this.  Local disk is fine for scratch
> space, for a few other things.  Managing the disk spread out among 50
> nodes?  Yeah, its harder.

Gluster isn't designed as a high performance parallel filesystem.  It
was never meant to be such.  There are guys on the dovecot list who have
tried it as a maildir store and it just falls over.  It simply cannot
handle random IO workloads, period.  And yes, it is difficult to design
a high performance parallel network based filesystem.  Much so.  IBM has
a massive lead on the other cluster filesystems as IBM started work back
in the mid/late 90s for their Power clusters.

> I'm gonna go out on a limb here and suggest Matt speak with HPC cluster
> and storage people.  He can implement things ranging from effectively
> zero cost through things which can be quite expensive.  If you are
> talking to Netapp about HPC storage, well, probably move onto a real HPC
> storage shop.  His problem is squarely in the HPC arena.

I'm still not convinced of that.  Simply stating "I have 50 compute
nodes each w/one GbE port, so I need 6GB/s of bandwidth" isn't actual
application workload data.  From what Matt did describe of how the
application behaves, simply time shifting the data access will likely
solve all of his problems, cheaply.  He might even be able to get by
with his current filer.  We simply need more information.  I do anyway.
 I'd hope you would as well.

> However, I would strongly advise against designs such as a single
> centralized unit, or a cloud of micro disks.  The first design is
> decidedly non-scalable, which is in part why the HPC community abandoned
> it years ago.  The second design is very hard to manage and guarantee
> any sort of resiliency.  You get all the benefits of a RAID0 in what
> Stan proposed.

A single system filer is scalable up to the point you run out of PCIe
slots.  The system I mentioned using the Nexsan array can scale 3x
before running out of slots.

I think some folks at IBM would tend to vehemently disagree with your
assertions here about GPFS. :)  It's the only filesystem used on IBM's
pSeries clusters and supercomputers.  I'd wager that IBM has shipped
more GPFS nodes into the HPC marketplace than Joe's company has shipped
nodes, total, ever, into any market, or ever will, by a factor of at
least 100.

This isn't really a fair comparison, as IBM has shipped single GPFS
supercomputers with more nodes than Joe's company will sell in its
entire lifespan.  Case in point:  ASCI Purple has 1640 GPFS client
nodes, and 134 GPFS server nodes.  This machine ships GPFS traffic over
the IBM HPS network at 4GB/s per node link, each node having two links
for 8GB/s per client node--a tad faster than GbE. ;).

For this environment, and most HPC "centers", using a few fat GPFS
storage servers with hundreds of terabytes of direct attached fiber
channel storage makes more sense than deploying every compute node as a
GPFS client *and* server using local disk.  In Matt's case it makes more
sense to do the latter, called NSD.

For the curious, here are the details of the $140 million ASCI Purple
system including the GPFS setup:
https://computing.llnl.gov/tutorials/purple/

> Start out talking with and working with experts, and its pretty likely
> you'll come out with a good solution.   The inverse is also true.

If by experts you mean those working in the HPC field, not vendors,
that's a great idea.  Matt, fire off a short polite email to Jack
Dongarra and one to Bill Camp.  Dr. Dongarra is the primary author of
the Linpack benchmark, which is used to rate the 500 fastest
supercomputers in the world twice yearly, among other things.  His name
is probably the most well known in the field of supercomputing.

Bill Camp designed the Red Storm supercomputer, which is now the
architectural basis for Cray's large MPP supercomputers.  He works for
Sandia National Laboratory, which is one of the 4 US nuclear weapons
laboratories.

If neither of these two men has an answer for you, nor can point you to
folks who do, the answer simply doesn't exist.  Out of consideration I'm
not going to post their email addresses.  You can find them at the
following locations.  While you're at it, read the Red Storm document.
It's very interesting.

http://www.netlib.org/utk/people/JackDongarra/

http://www.google.com/url?sa=t&source=web&cd=3&ved=0CCEQFjAC&url=http%3A%2F%2Fwww.lanl.gov%2Forgs%2Fhpc%2Fsalishan%2Fsalishan2003%2Fcamp.pdf&rct=j&q=bill%20camp%20asci%20red&ei=VxRqTdTuEYOClAf4xKH_AQ&usg=AFQjCNFl420n6HAwBkDs5AFBU2TKpsiHvA&cad=rja

I've not corresponded with Professor Dongarra for many years, but back
then he always answered my emails rather promptly, within a day or two.
 The key is to keep it short and sweet, as the man is pretty busy I'd
guess.  I've never corresponded with Dr. Camp, but I'm sure he'd respond
to you, one way or another.  My experience is that technical people
enjoy talking tech shop, at least to a degree.

> MD RAID, which Stan dismissed as a "hobby RAID" at first can work well

That's a mis-characterization of the statement I made.

> for Matt.  GlusterFS can help with the parallel file system atop this.
> Starting with a realistic design, an MD RAID based system (self built or
> otherwise) could easily provide everything Matt needs, at the data rates
> he needs it, using entirely open source technologies.  And good designs.

I don't recall Matt saying he needed a solution based entirely on FOSS.
 If he did I missed it.  If he can accomplish his goals with all FOSS
that's always a plus in my book.  However, I'm not averse to closed
source when it's a better fit for a requirement.

> You really won't get good performance out of a bad design.  The folks

That's brilliant insight. ;)

> doing HPC work who've responded have largely helped frame good design
> patterns.  The folks who aren't sure what HPC really is, haven't.

The folks who use the term HPC as a catch all, speaking as if there is
one workload pattern, or only one file access pattern which comprises
HPC, as Joe continues to do, and who attempt to tell others they don't
know what they're talking about, when they most certainly do, should be
viewed with some skepticism.

Just as in the business sector, there are many widely varied workloads
in the HPC space.  At opposite ends of the disk access spectrum,
analysis applications tend to read a lot and write very little.
Simulation applications, on the other hand, tend to read very little,
and generate a tremendous amount of output.  For each of these, some
benefit greatly from highly parallel communication and disk throughput,
some don't.  Some benefit from extreme parallelism, and benefit from
using message passing and Lustre file access over infiniband, some with
lots of serialization don't.  Some may benefit from openmp parallelism
but only mild amounts of disk parallelism.  In summary, there are many
shades of HPC.

For maximum performance and ROI, just as in the business or any other
computing world, one needs to optimize his compute and storage system to
meet his particular workload.  There isn't one size that fits all.
Thus, contrary to what Joe may have anyone here believe, NFS filers are
a perfect fit for some HPC workloads.  For Joe to say that any workload
that works fine with an NFS filer isn't an HPC workload is simply
rubbish.  One need look no further than a little ways back in this
thread to see this.  In one hand, Joe says Matt's workload is absolutely
an HPC workload.  Matt currently uses an NFS filer for this workload.
Thus, Joe would say this isn't an HPC workload because it's working fine
with an NFS filer.  Just a bit of self contradiction there.

Instead of arguing what is and is not HPC, and arguing that Matt's
workload is "an HPC workload", I think, again, that nailing down his
exact data access profile and making a recommendation on that, is what
he needs.  I'm betting he could care less if his workload is "an HPC
workload" or not.  I'm starting to tire of this thread.  Matt has plenty
of conflicting information to sort out.  I'll be glad to answer any
questions he may have of me.

-- 
Stan
