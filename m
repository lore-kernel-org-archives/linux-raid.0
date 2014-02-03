From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: sequential versus random I/O
Date: Mon, 3 Feb 2014 13:28:39 -0600
Message-ID: <CAJvUf-Bv32ikqtNSTFOibXSj9dgFS6mZhdtMjxSYhQ2tXLiZiw@mail.gmail.com>
References: <CAJvUf-BbRMXvwwbVvstGPUV7xQpVBqVXLNvTHhYf_wv8=Ws9uw@mail.gmail.com>
	<52E9BB3B.7010600@hardwarefreak.com>
	<CAJvUf-DsN-z4rYjYC6Ki42ce6PzKjwsLjNGTW9QxEi=hKH_7Wg@mail.gmail.com>
	<52EA27D4.6060805@hardwarefreak.com>
	<CAJvUf-A3ERw-Omn2fRLcZJ=zDOEP-quLe7T5gT6RaVroOpFX3g@mail.gmail.com>
	<52ED3CD4.8090801@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52ED3CD4.8090801@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Feb 1, 2014 at 12:28 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> I was in lock step with you until this point.  We're talking about SSDs
> aren't we?  And a read-only workload?  RAID10 today is only for
> transactional workloads on rust to avoid RMW.  SSD doesn't suffer RMW
> ...

OK, I think I'm convinced, raid10 isn't appropriate here.  (If I get
the green light for this, I might still do it in the
buildup/experimentation stage, just for kicks and grin if nothing
else.)

So, just to be clear, you've implied that if I have an N-disk raid6,
then the (theoretical) sequential read throughput is
    (N-2) * T
where T is the throughput of a single drive (assuming uniform drives).
 Is this correct?

> If one of your concerns is decreased client throughput during rebuild,
> then simply turn down the rebuild priority to 50%.  Your rebuild will

The main concern was "high availability".  This isn't like my home
server, where I use raid as an excuse to de-prioritize my backups.  :)
 But raid for the actual designed purpose, to minimize service
interruptions in case of failure(s).

The thing is, I think consumer SSDs are still somewhat of an unknown
entity in terms of reliability, longevity, and failure modes.  Just
from the SSDs I've dealt with at home (tiny sample size), I've had two
fail the "bad way": that is, they die and are no longer recognizable
by the system (neither OS nor BIOS).  Presumably a failure of the SSDs
controller.  And with spinning rust, we have decades of experience and
useful public information like Google's HDD study and Backblaze's
blog.  SSDs just haven't been out in the wild long enough to have a
big enough sample size to do similar studies.

Those two SSDs I had die just abruptly went out, without any kind of
advance warning.  (To be fair, these were first-gen, discount,
consumer SSDs.)  Certainly, traditional spinning drives can also die
in this way, but with regular SMART monitoring and such, we (in
theory) have some useful means to predict impending death.  Not sure
if the SMART monitoring on SSDs is up to par with their rusty
counterparts.

> The modular approach has advantages.  But keep in mind that modularity
> increases complexity and component count, which increase the probability
> of a failure.  The more vehicles you own the more often one of them is
> in the shop at any given time, if even only for an oil change.

Good point.  Although if I have more cars than I actually need
(redundancy), I can afford to always have a car in the shop.  ;)

> Gluster has advantages here as it can redistribute data automatically
> among the storage nodes.  If you do distributed mirroring you can take a
> node completely offline for maintenance, and client's won't skip a beat,
> or at worst a short beat.  It costs half your storage for the mirroring,
> but using RAID6 it's still ~33% less than the RAID10 w/3 way mirrors.
> ...
> If you're going with multiple identical 24 bay nodes, you want a single
> 24 drive md/RAID6 in each directly formatted with XFS.  Or Gluster atop
> XFS.  It's the best approach for your read only workload with large files.


Now that you've convinced me RAID6 is the way to go, and if I can get
3 GB/s out of one of these systems, then two of these system would
literally double the capability (storage capacity and throughput) of
our current big iron system.  What would be ideal is to use something
like Gluster to add a third system for redundancy, and have a "raid 5"
at the server level.  I.e., same storage capacity of two systems, but
one whole node could go down without losing service availability.  I
have no experience with cluster filesystems, however, so this presents
another risk vector.

> I'm firmly an AMD guy.

Any reason for that?  That's an honest question, not veiled argument.
Do the latest AMD server chips include the PCIe controller on-chip
like the Sandy Bridge and newer Intel chips?  Or does AMD still put
the PCIe controller on a separate chip (a northbridge)?

Just wondering if having dual on-CPU-die PCIe controllers is an
advantage here (assuming a dual-socket system).  I agree with you, CPU
core count and clock isn't terribly important, it's all about being
able to extract maximum I/O from basically every other component in
the system.

> sideband signaling SAS cables should enable you to make drive failure
> LEDs work with mdadm, using:
> http://sourceforge.net/projects/ledmon/
>
> I've not tried the software myself, but if it's up to par, dead drive
> identification should work the same as with any vendor storage array,
> which to this point has been nearly impossible with md arrays using
> plain non-RAID HBAs.

Ha, that's nice.  In my home server, which is idle 99% of the time,
I've identified drives by simply doing a "dd if=/dev/target/drive
of=/dev/null" and looking for the drive that lights up.  Although,
I've noticed some drives (Samsung) don't even light up when I do that.

I could do this in reverse on a system that's 99% busy: just offline
the target drive, and look for the one light that's NOT lit.

Failing that, I had planned to use the old school paper and pencil
method of just keeping good notes of which drive (identified by serial
number) was in which bay.

> All but one of the necessary parts are stocked by NewEgg believe it or
> not.  The build consists of a 24 bay 2U SuperMicro 920W dual HS PSU,
> SuperMicro dual socket C32 mobo w/5 PCIe 2.0 x8 slots, 2x Opteron 4334
> ...

Thanks for that.  I integrated these into my planning spreadsheet,
which incidentally already had 75% of what you spec'ed out.  Main
difference is I spec'ed out an Intel-based system, and you used AMD.
Big cost savings by going with AMD however!

> Total cost today:  $16,927.23
> SSD cost:          $13,119.98

Looks like you're using the $550 sale price for those 1TB Samsung
SSDs.  Normal price is $600.  Newegg usually has a limit of 5 (IIRC)
on sale-priced drives.

> maxing out the rest of the hardware so I spec'd 4 ports.  With the
> correct bonding setup you should be able to get between 3-4GB/s.  Still
> only 1/4th - 1/3rd the SSD throughput.

Right.  I might start with just a single dual-port 10gig NIC, and see
if I can saturate that.  Let's be pessimistic, and assume I can only
wrangle 250 MB/sec out of each SSD.  And I'll have designate two hot
spares, leaving a 22-drive raid6.  So that's: 250 MB/s * 20 = 5 GB/s.
Now that's not so far away from the 4 GB/sec theoretical with 4x 10gig
NICs.

> Hope you at least found this an interesting read, if not actionable.
> Maybe others will as well.  I had some fun putting this one together.  I

Absolutely interesting, thanks again for all the detailed feedback.

> think the only things I omitted were Velcro straps and self stick lock
> loops for tidying up the cables for optimum airflow.  Experienced
> builders usually have these on hand, but I figured I'd mention them just
> in case.

Of course, but why can't I ever find them when I actually need them?  :)

Anyway, thanks again for your feedback.  The first roadblock is
definitely getting manager buy-in.  He tends to dismiss projects like
this because (1) we're not a storage company / we don't DIY servers,
(2) why isn't anyone else doing this / why can't you buy an OTS system
like this, (3) even though the cost savings are dramatic, it's still a
~$20k risk - what if I can't get even 50% of the theoretical
throughput? what if those SSDs require constant replacement? what if
there is some subtle kernel- or driver-level bug(s) that are in
"landmine" status waiting for something like this to expose them?

-Matt
