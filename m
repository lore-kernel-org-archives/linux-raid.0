From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Thu, 17 Feb 2011 17:49:07 -0600
Message-ID: <4D5DB3F3.8050209@hardwarefreak.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <4D5D017B.50109@anonymous.org.uk> <4D5D9758.2080400@hardwarefreak.com> <4D5D9D70.9010603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5D9D70.9010603@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Matt Garman <matthew.garman@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Joe Landman put forth on 2/17/2011 4:13 PM:

> Well, the application area appears to be high performance cluster
> computing, and the storage behind it.  Its a somewhat more specialized
> version of storage, and not one that a typical IT person runs into
> often.  There are different, some profoundly so, demands placed upon
> such storage.

The OP's post described an ad hoc collection of 40-50 machines doing
various types of processing on shared data files.  This is not classical
cluster computing.  He didn't describe any kind of _parallel_
processing.  It sounded to me like staged batch processing, the
bandwidth demands of which are typically much lower than a parallel
compute cluster.

> Full disclosure:  this is our major market, we make/sell products in
> this space, have for a while.  Take what we say with that in your mind
> as a caveat, as it does color our opinions.

Thanks for the disclosure Joe.

> The spec's as stated, 50Gb/s ... its rare ... exceptionally rare ...
> that you ever see cluster computing storage requirements stated in such
> terms.  Usually they are stated in the MB/s or GB/s regime.  Using  a
> basic conversion of Gb/s to GB/s, the OP is looking for ~6GB/s support.

Indeed.  You typically don't see this kind of storage b/w need outside
the government labs and supercomputing centers (LLNL, Sandia, NCCS,
SDSC, etc).  Of course those sites' requirements are quite a bit higher
than a "puny" 6 GB/s.

> Some basic facts about this.
> 
> Fibre channel (FC-8 in particular), will give you, at best 1GB/s per
> loop, and that presumes you aren't oversubscribing the loop.  The vast
> majority of designs we see coming from IT shops, do, in fact, badly
> oversubscribe the bandwidth, which causes significant contention on the
> loops.  

Who is still doing loops on the front end?  Front end loops died many
years ago with the introduction of switches from Brocade, Qlogic,
McData, etc.  I've not hard of a front end loop being used in many many
years.  Some storage vendors still use loops on the _back_ end to
connect FC/SAS/SATA expansion chassis to the head controller, IBM and
NetApp come to mind, but it's usually dual loops per chassis, so you're
looking at ~3 GB/s per expansion chassis using 8 Gbit loops.  One would
be hard pressed to over subscribe such a system as most of these are
sold with multiple chassis.  And for systems such as the IBMs and
NetApps, you can get anywhere from 4-32 front end ports of 8 Gbit FC or
10 GbE.  In the IBM case you're limited to block access, whereas the
NetApp will do both block and file.

> The Nexsan unit you indicated (they are nominally a competitor
> of ours) is an FC device, though we've heard rumblings that they may
> even allow for SAS direct connections (though that would be quite cost
> ineffective as a SAS JBOD chassis compared to other units, and you still
> have the oversubscription problem).

Nexsan doesn't offer direct SAS connection on the big 42/102 drive Beast
units, only on the Boy units.  The Beast units all use dual or quad FC
front end ports, with a couple front end GbE iSCSI ports thrown in for
flexibility.  The SAS Boy units beat all competitors on price/TB, as do
all the Nexsan products.

I'd like to note that over subscription isn't intrinsic to a piece of
hardware.  It's indicative of an engineer or storage architect not
knowing what the blank he's doing.

> As I said, high performance storage design is a very ... very ...
> different animal from standard IT storage design.  There are very
> different decision points, and design concepts.

Depends on the segment of the HPC market.  It seems you're competing in
the low end of it.  Configurations get a bit exotic at the very high
end.  It also depends on what HPC storage tier you're looking at, and
the application area.  For pure parallel computing sites such as NCCS,
NCSA, PSSC, etc your storage infrastructure and the manner in which it
is accessed is going to be quite different than some of the NASA
sponsored projects, such as the Spitzer telescope project being handled
by Caltech.  The first will have persistent parallel data writing from
simulation runs across many hundreds or thousands of nodes.  The second
will have massive streaming writes as the telescope streams data in real
time to a ground station.  Then this data will be staged and processed
with massive streaming wrties.

So, again, it really depends on the application(s), as always,
regardless of whether it's HPC or IT, although there are few purely
streaming IT workloads, EDL of decision support databases comes to mind,
but these are usually relatively short duration.  They can still put
some strain on a SAN if not architected correctly.

>> You don't see many deployed filers on the planet with 5 * 10 GbE front
>> end connections.  In fact, today, you still don't see many deployed
>> filers with even one 10 GbE front end connection, but usually multiple
>> (often but not always bonded) GbE connections.
> 
> In this space, high performance cluster storage, this statement is
> incorrect.

The OP doesn't have a high performance cluster.  HPC cluster storage by
accepted definition includes highly parallel workloads.  This is not
what the OP described.  He described ad hoc staged data analysis.

> In high performance computing storage (again, the focus of the OP's
> questions), this is a reasonable configuration and request.

Again, I disagree.  See above.

>> A single 10 GbE front end connection provides a truly enormous amount of
>> real world bandwidth, over 1 GB/s aggregate sustained.  *This is
>> equivalent to transferring a full length dual layer DVD in 10 seconds*
> 
> Trust me.  This is not *enormous*.  Well, ok ... put another way, we

Given that the OP has nothing right now, this is *enormous* bandwidth.
It would surely meet his needs.  For the vast majority of
workloads/environments, 1GB/s sustained is enormous.  Sure, there are
environments that may need more, but those folks aren't typically going
to be asking for architecture assistance on this, or any other mailing
list. ;)

> 1 GB/s is nothing magical.  Again, not a commercial, but our DeltaV
> units, running MD raid, achieve 850-900MB/s (0.85-0.9 GB/s) for RAID6.

1 GB/s sustained random I/O is a bit magical, for many many
sites/applications.  I'm betting the 850-900MB/s RAID6 you quote is a
streaming read, yes?  What does that box peak at with a mixed random I/O
workload from 40-50 clients?

> To get good (great) performance you have to start out with a good
> (great) design.  One that will really optimize the performance on a per
> unit basis.

Blah blah.  You're marketing too much at this point. :)

> The sad part is that we often wind up fighting against others "marketing
> numbers".  Our real benchmarks are often comparable to their "strong
> wind a the back" numbers.  Heck, our MD raid numbers often are better
> than others hardware RAID numbers.

And they're all on paper.  It was great back in the day when vendors
would drop off an eval unit free of charge and let you bang on it for a
month.  Today, there are too many players, and margins are to small, for
most companies to have the motivation to do this.  Today you're invited
to the vendor to watch them run the hardware through a demo, which has
little bearing on your workload.  For a small firm like yours I'm
guessing it would be impossible to deploy eval units in any numbers due
to capitalization issues.

> Theoretical bandwidth from the marketing docs doesn't matter.  The only

This is always the case.  Which is one reason why certain trade mags are
still read--almost decent product reviews.

> thing that does matter is having a sound design and implementation at
> all levels.  This is why we do what we do, and why we do use MD raid.

No argument here.  This is one reason why some quality VARs/integrators
are unsung heroes in some quarters.  There is a plethora of fantastic
gear on the market today, from servers to storage to networking gear.
One could buy the best $$ products available and still get crappy
performance if it's not integrated properly, from the cabling to the
firmware to the application.

-- 
Stan
