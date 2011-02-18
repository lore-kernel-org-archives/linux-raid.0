From: Joe Landman <joe.landman@gmail.com>
Subject: Re: high throughput storage server?
Date: Thu, 17 Feb 2011 19:06:00 -0500
Message-ID: <4D5DB7E8.1020003@gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <4D5D017B.50109@anonymous.org.uk> <4D5D9758.2080400@hardwarefreak.com> <4D5D9D70.9010603@gmail.com> <4D5DB3F3.8050209@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5DB3F3.8050209@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Matt Garman <matthew.garman@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/17/2011 6:49 PM, Stan Hoeppner wrote:
> Joe Landman put forth on 2/17/2011 4:13 PM:
>
>> Well, the application area appears to be high performance cluster
>> computing, and the storage behind it.  Its a somewhat more specialized
>> version of storage, and not one that a typical IT person runs into
>> often.  There are different, some profoundly so, demands placed upon
>> such storage.
>
> The OP's post described an ad hoc collection of 40-50 machines doing
> various types of processing on shared data files.  This is not classical
> cluster computing.  He didn't describe any kind of _parallel_
> processing.  It sounded to me like staged batch processing, the

Semantics at best.  He is doing significant processing, in parallel, 
doing data analysis, in parallel, across a cluster of machines.  Doing 
MPI-IO?  No.  Does not using MPI make this not a cluster?  No.

> bandwidth demands of which are typically much lower than a parallel
> compute cluster.

See his original post.  He posits his bandwidth demands.

>
>> Full disclosure:  this is our major market, we make/sell products in
>> this space, have for a while.  Take what we say with that in your mind
>> as a caveat, as it does color our opinions.
>
> Thanks for the disclosure Joe.
>
>> The spec's as stated, 50Gb/s ... its rare ... exceptionally rare ...
>> that you ever see cluster computing storage requirements stated in such
>> terms.  Usually they are stated in the MB/s or GB/s regime.  Using  a
>> basic conversion of Gb/s to GB/s, the OP is looking for ~6GB/s support.
>
> Indeed.  You typically don't see this kind of storage b/w need outside
> the government labs and supercomputing centers (LLNL, Sandia, NCCS,
> SDSC, etc).  Of course those sites' requirements are quite a bit higher
> than a "puny" 6 GB/s.

Heh ... we see it all the time in compute cluster, large data analysis 
farms etc.  Not at the big labs.

[...]

> McData, etc.  I've not hard of a front end loop being used in many many
> years.  Some storage vendors still use loops on the _back_ end to
> connect FC/SAS/SATA expansion chassis to the head controller, IBM and

I am talking about the back end.

> NetApp come to mind, but it's usually dual loops per chassis, so you're
> looking at ~3 GB/s per expansion chassis using 8 Gbit loops.  One would

2 GB/s assuming FC-8, and 20 lower speed drives are sufficient to 
completely fill 2 GB/s.  So, as I was saying, the design matters.

[...]

> Nexsan doesn't offer direct SAS connection on the big 42/102 drive Beast
> units, only on the Boy units.  The Beast units all use dual or quad FC
> front end ports, with a couple front end GbE iSCSI ports thrown in for
> flexibility.  The SAS Boy units beat all competitors on price/TB, as do
> all the Nexsan products.

As I joked one time, many many years ago "broad sweeping generalizations 
tend to be incorrect".  Yes, it is a recursive joke, but there is a 
serious aspect to it.  Your proffered pricing per TB, which you claim 
Nexsan beats all ... is much higher than ours, and many others.  No, 
they don't beat all, or even many.


> I'd like to note that over subscription isn't intrinsic to a piece of
> hardware.  It's indicative of an engineer or storage architect not
> knowing what the blank he's doing.

Oversubscription and it corresponding resource contention, not to 
mention poor design of other aspects ... yeah, I agree that this is 
indicative of something.  One must question why people continue to 
deploy architectures which don't scale.

>
>> As I said, high performance storage design is a very ... very ...
>> different animal from standard IT storage design.  There are very
>> different decision points, and design concepts.
>
> Depends on the segment of the HPC market.  It seems you're competing in
> the low end of it.  Configurations get a bit exotic at the very high

I noted this about your previous responses, this particular tone you 
take.  I debated for a while responding, until I saw something I simply 
needed to correct.  I'll try not to take your bait.

[...]

> So, again, it really depends on the application(s), as always,
> regardless of whether it's HPC or IT, although there are few purely
> streaming IT workloads, EDL of decision support databases comes to mind,
> but these are usually relatively short duration.  They can still put
> some strain on a SAN if not architected correctly.
>
>>> You don't see many deployed filers on the planet with 5 * 10 GbE front
>>> end connections.  In fact, today, you still don't see many deployed
>>> filers with even one 10 GbE front end connection, but usually multiple
>>> (often but not always bonded) GbE connections.
>>
>> In this space, high performance cluster storage, this statement is
>> incorrect.
>
> The OP doesn't have a high performance cluster.  HPC cluster storage by

Again, semantics.  They are doing massive data ingestion and processing. 
  The view of this is called "big data" in HPC circles and it is *very 
much* an HPC problem.

> accepted definition includes highly parallel workloads.  This is not
> what the OP described.  He described ad hoc staged data analysis.

See above.  If you want to argue semantics, be my guest, I won't be 
party to such a waste of time.  The OP is doing analysis that requires a 
high performance architecture.  The architecture you suggested is not 
one people in the field would likely recommend.

[rest deleted]


--
joe

