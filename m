From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: sequential versus random I/O
Date: Tue, 04 Feb 2014 09:16:13 -0600
Message-ID: <52F1043D.1090203@hardwarefreak.com>
References: <CAJvUf-BbRMXvwwbVvstGPUV7xQpVBqVXLNvTHhYf_wv8=Ws9uw@mail.gmail.com>	<52E9BB3B.7010600@hardwarefreak.com>	<CAJvUf-DsN-z4rYjYC6Ki42ce6PzKjwsLjNGTW9QxEi=hKH_7Wg@mail.gmail.com>	<52EA27D4.6060805@hardwarefreak.com>	<CAJvUf-A3ERw-Omn2fRLcZJ=zDOEP-quLe7T5gT6RaVroOpFX3g@mail.gmail.com>	<52ED3CD4.8090801@hardwarefreak.com> <CAJvUf-Bv32ikqtNSTFOibXSj9dgFS6mZhdtMjxSYhQ2tXLiZiw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJvUf-Bv32ikqtNSTFOibXSj9dgFS6mZhdtMjxSYhQ2tXLiZiw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/3/2014 1:28 PM, Matt Garman wrote:
> On Sat, Feb 1, 2014 at 12:28 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> I was in lock step with you until this point.  We're talking about SSDs
>> aren't we?  And a read-only workload?  RAID10 today is only for
>> transactional workloads on rust to avoid RMW.  SSD doesn't suffer RMW
>> ...
> 
> OK, I think I'm convinced, raid10 isn't appropriate here.  (If I get
> the green light for this, I might still do it in the
> buildup/experimentation stage, just for kicks and grin if nothing
> else.)
> 
> So, just to be clear, you've implied that if I have an N-disk raid6,
> then the (theoretical) sequential read throughput is
>     (N-2) * T
> where T is the throughput of a single drive (assuming uniform drives).
>  Is this correct?

Should be pretty close to that for parallel streaming read.

>> If one of your concerns is decreased client throughput during rebuild,
>> then simply turn down the rebuild priority to 50%.  Your rebuild will
> 
> The main concern was "high availability".  This isn't like my home
> server, where I use raid as an excuse to de-prioritize my backups.  :)
>  But raid for the actual designed purpose, to minimize service
> interruptions in case of failure(s).

The major problem with rust based RAID5/6 arrays is the big throughput
hit you take during a rebuild.  Concurrent access causes massive head
seeking, slowing everything down, both user IO and rebuild.  This
proposed SSD rig has disk throughput that is 4-8x the network
throughput.  And there are no heads to seek, thus no increased latency
nor reduced bandwidth.  You should be able to dial down the rebuild rate
by as little as 25% and the NFS throughput shouldn't vary from normal state.

This is the definition of high availability--failures don't affect
function or performance.

> The thing is, I think consumer SSDs are still somewhat of an unknown
> entity in terms of reliability, longevity, and failure modes.  Just
> from the SSDs I've dealt with at home (tiny sample size), I've had two
> fail the "bad way": that is, they die and are no longer recognizable
> by the system (neither OS nor BIOS).  Presumably a failure of the SSDs
> controller.  

I had one die like that in 2011, after 4 months, a Corsair V32, 1st gen
Indilinx drive.

> And with spinning rust, we have decades of experience and
> useful public information like Google's HDD study and Backblaze's
> blog.  SSDs just haven't been out in the wild long enough to have a
> big enough sample size to do similar studies.

As is the case with all new technologies.  Hybrid technology is much
newer still, but will probably start being adopted at a much faster pace
than pure SSD for most applications.  Speaking of SSHD I should have
mentioned it sooner because it's actually a perfect fit for your
workload, as you reread the same ~400MB files repeatedly.  Have you
considered hybrid SSHD drives?  These Seagate 1TB 2.5" drives have an
8GB SSD cache:

http://www.newegg.com/Product/Product.aspx?Item=N82E16822178340

24 of these yields the same capacity as the pure SSD solution, but at
*1/6th* the price per drive, ~$2600 for 24 drives vs ~$15,500.  You'd
have an aggregate 192GB of SSD cache per server node and close to 1GB/s
of network throughput even when hitting platters instead of cache.  So a
single GbE connection would be a good fit, and no bonding headaches.
The drives drop into the same chassis.  You'll save $10,000 per chassis.
 In essence you'd be duplicating the NetApp's disk + SSD cache setup but
inside each drive.  I worked up the totals, see down below.

...
>> The modular approach has advantages.  But keep in mind that modularity
>> increases complexity and component count, which increase the probability
>> of a failure.  The more vehicles you own the more often one of them is
>> in the shop at any given time, if even only for an oil change.
> 
> Good point.  Although if I have more cars than I actually need
> (redundancy), I can afford to always have a car in the shop.  ;)

But it requires two vehicles and two people to get the car to the shop
and get you back home.  This is the point I was making.  The more
complex the infrastructure, the more time/effort required for maintenance.

>> Gluster has advantages here as it can redistribute data automatically
>> among the storage nodes.  If you do distributed mirroring you can take a
>> node completely offline for maintenance, and client's won't skip a beat,
>> or at worst a short beat.  It costs half your storage for the mirroring,
>> but using RAID6 it's still ~33% less than the RAID10 w/3 way mirrors.
>> ...
>> If you're going with multiple identical 24 bay nodes, you want a single
>> 24 drive md/RAID6 in each directly formatted with XFS.  Or Gluster atop
>> XFS.  It's the best approach for your read only workload with large files.
> 
> 
> Now that you've convinced me RAID6 is the way to go, and if I can get
> 3 GB/s out of one of these systems, then two of these system would
> literally double the capability (storage capacity and throughput) of
> our current big iron system.  

The challenge will be getting 3GB/s.  You may spend weeks, maybe months,
in testing and development work to achieve it.  I can't say as I've
never tried this.  Getting close to 1GB/s from one interface is much
easier.  This fact, and cost, make the SSHD solution much much more
attractive.

> What would be ideal is to use something
> like Gluster to add a third system for redundancy, and have a "raid 5"
> at the server level.  I.e., same storage capacity of two systems, but
> one whole node could go down without losing service availability.  I
> have no experience with cluster filesystems, however, so this presents
> another risk vector.

Read up on Gluster and its replication capabilities.  Say "DFS" as
Gluster is a distributed filesystem.  A cluster filesystem or "CFS" is a
completely different technology.

>> I'm firmly an AMD guy.
> 
> Any reason for that?

We've seen ample examples in the US of what happens with a monopolist.
Prices increase and innovation decreases.  If AMD goes bankrupt or
simply exits the desktop/server x86 CPU market then Chipzilla has a
monopoly on x86 desktop/server CPUs.  They nearly do now simply based on
market share.  AMD still makes plenty capable CPUs, chipsets, etc, and
at a lower cost.  Intel chips may have superior performance at the
moment, but AMD was superior for half a decade.  As long as AMD has a
remotely competitive offering I'll support them with my business.  I
don't want to be at the mercy of a monopolist.

> Do the latest AMD server chips include the PCIe controller on-chip
> like the Sandy Bridge and newer Intel chips?  Or does AMD still put
> the PCIe controller on a separate chip (a northbridge)?
>
> Just wondering if having dual on-CPU-die PCIe controllers is an
> advantage here (assuming a dual-socket system).  I agree with you, CPU
> core count and clock isn't terribly important, it's all about being
> able to extract maximum I/O from basically every other component in
> the system.

Adding PCIe interfaces to the CPU die eliminates the need for an IO
support chip, simplifying board design and testing, and freeing up board
real estate.  This is good for large NUMA systems, such as SGI's Altix
UV, which contain dozens or hundreds of CPU boards.  It does not
increase PCIe channel throughput, though it does lower latency by a few
nanoseconds.  There may be a small noticeable gain here for HPC
applications sending MPI messages over PCIe Infiniband HCAs, but not for
any other device connected via PCIe.  Storage IO is typically not
latency bound and is always pipelined, so latency is largely irrelevant.

>> sideband signaling SAS cables should enable you to make drive failure
>> LEDs work with mdadm, using:
>> http://sourceforge.net/projects/ledmon/
>>
>> I've not tried the software myself, but if it's up to par, dead drive
>> identification should work the same as with any vendor storage array,
>> which to this point has been nearly impossible with md arrays using
>> plain non-RAID HBAs.
> 
> Ha, that's nice.  In my home server, which is idle 99% of the time,
> I've identified drives by simply doing a "dd if=/dev/target/drive
> of=/dev/null" and looking for the drive that lights up.  Although,
> I've noticed some drives (Samsung) don't even light up when I do that.

It's always good to have a fall back position.  This is another thing
you have to integrate yourself.  Part of the "DIY" thing.

...
>> All but one of the necessary parts are stocked by NewEgg believe it or
>> not.  The build consists of a 24 bay 2U SuperMicro 920W dual HS PSU,
>> SuperMicro dual socket C32 mobo w/5 PCIe 2.0 x8 slots, 2x Opteron 4334
>> ...
> 
> Thanks for that.  I integrated these into my planning spreadsheet,
> which incidentally already had 75% of what you spec'ed out.  Main
> difference is I spec'ed out an Intel-based system, and you used AMD.
> Big cost savings by going with AMD however!
> 
>> Total cost today:  $16,927.23
Corrected total:      $19,384.10

>> SSD cost:          $13,119.98
Corrected:	      $15,927.34

SSHD system:	      $ 6,238.50
Savings:	      $13,145.60

Specs same as before, but with one dual port 10GbE NIC and 26x Seagate
1TB 2.5" SSHDs displacing the Samsung SSDs.  These drives target the
laptop market.  As such they are built for vibration and should fair
well in a multi-drive chassis.

$6,300 may be more palatable to the boss for an experimental development
system.  It shouldn't be difficult to reach maximum potential throughput
of the 10GbE interface with a little tweaking.  Your time to proof of
concept should be minimal.  Once proven you could put it into limited
production with a subset of the data to see how the drives standup with
continuous use.  If it holds up for a month, purchase components for
another 4 units for ~$25,000.  Put 3 nodes into production for 4 total,
keep the other set of parts as spares for the 4 production units since
consumer parts availability is volatile, even on a 6 month time scale.
You'll have ~$32,000 in the total system.

Once you've racked the 3 systems and burned them in, install and
configure Gluster and load your datasets.  By then you'll know Gluster
well, how to spread data for load balancing, configure fault tolerance,
etc.  You'll have the cheap node concept you originally mentioned.  You
should be able to get close to 4GB/s out of the 4 node farm, and scale
up by ~1GB/s with each future node.

> Looks like you're using the $550 sale price for those 1TB Samsung
> SSDs.  Normal price is $600.  Newegg usually has a limit of 5 (IIRC)
> on sale-priced drives.

I didn't look closely enough.  It's actually $656.14, corrected all
figures above.

>> maxing out the rest of the hardware so I spec'd 4 ports.  With the
>> correct bonding setup you should be able to get between 3-4GB/s.  Still
>> only 1/4th - 1/3rd the SSD throughput.
> 
> Right.  I might start with just a single dual-port 10gig NIC, and see
> if I can saturate that.  Let's be pessimistic, and assume I can only
> wrangle 250 MB/sec out of each SSD.  And I'll have designate two hot
> spares, leaving a 22-drive raid6.  So that's: 250 MB/s * 20 = 5 GB/s.
> Now that's not so far away from the 4 GB/sec theoretical with 4x 10gig
> NICs.

You'll get near full read bandwidth from the SSDs without any problems.
 That's not an issue.  The problem will likely be getting 3-4GB/s of
NFS/TCP throughput from your bonded stack.  The one thing in your favor
is you only need transmit load balancing for your workload, which is
much easier to do than receive load balancing.

>> Hope you at least found this an interesting read, if not actionable.
>> Maybe others will as well.  I had some fun putting this one together.  I
> 
> Absolutely interesting, thanks again for all the detailed feedback.

They don't call me "HardwareFreak" for nothin. :)

...
> Anyway, thanks again for your feedback.  The first roadblock is
> definitely getting manager buy-in.  He tends to dismiss projects like
> this because (1) we're not a storage company / we don't DIY servers,
> (2) why isn't anyone else doing this / why can't you buy an OTS system
> like this, (3) even though the cost savings are dramatic, it's still a
> ~$20k risk - what if I can't get even 50% of the theoretical
> throughput? what if those SSDs require constant replacement? what if
> there is some subtle kernel- or driver-level bug(s) that are in
> "landmine" status waiting for something like this to expose them?

(1)  I'm not an HVAC contractor nor an electrician, but I rewired my
     entire house and replaced the HVAC system, including all new duct
     work.  I did it because I know how, and it saved me ~$10,000.  And
     the results are better than if I'd hired a contractor.  If you can
     do something yourself at lower cost and higher quality, do so.

(2)  Because an OTS "system" is not a DIY system.  You're paying for
     expertise and support more than for the COTS gear.  Hardware at
     the wholesale OEM level is inexpensive.  When you buy a NetApp,
     their unit cost from the supplier is less than 1/4th what you pay
     NetApp for the hardware.  The rest is profit, R&D, cust support,
     employee overhead, etc.  When you buy hardware for a DIY build,
     you're buying the hardware, and paying 10-20% profit to the
     wholesaler depending on the item.

(3)  The bulk of storage systems on the market today use embedded Linux.
     So any kernel or driver level bugs that may affect a DIY system
     will also affect such vendor solutions.

The risks boil down to one thing:  competence.  If your staff is
competent, your risk is extremely low.  Your boss has competent staff.

The problem with most management is they know they can buy X for Y cost
from company Z and get some kind of guarantee for paying cost Y.  They
feel they have "assurance" that things will just work.  We all know from
experience, journals, word of mouth, that one can spend $100K to
$millions on hardware or software and/or "expert" consultants, and a
year later it still doesn't work right.  There are no real guarantees.

Frankly, I'd much rather do everything myself, because I can, and have
complete control of it.  That's a much better guarantee for me than any
contract or SLA a vendor could ever provide.

-- 
Stan


