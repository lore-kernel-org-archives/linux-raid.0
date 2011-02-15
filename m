From: Joe Landman <joe.landman@gmail.com>
Subject: Re: high throughput storage server?
Date: Tue, 15 Feb 2011 10:16:15 -0500
Message-ID: <4D5A98BF.3030704@gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com> <20110215044434.GA9186@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110215044434.GA9186@septictank.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Doug Dumitru <doug@easyco.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[disclosure: vendor posting, ignore if you wish, vendor html link at 
bottom of message]

On 02/14/2011 11:44 PM, Matt Garman wrote:
> On Mon, Feb 14, 2011 at 06:06:43PM -0800, Doug Dumitru wrote:
>> You have a whole slew of questions to answer before you can decide
>> on a design.  This is true if you build it yourself or decide to
>> go with a vendor and buy a supported server.  If you do go with a
>> vendor, the odds are actually quite good you will end up with
>> Linux anyway.
>
> I kind of assumed/wondered if the vendor-supplied systems didn't run
> Linux behind the scenes anyway.

We've been using Linux as the basis for our storage systems. 
Occasionally there are other OSes required by customers, but for the 
most part, Linux is the preferred platform.

[...]

>> Next, is the space all the same.  Perhaps some of it is "active"
>> and some of it is archival.  If you need 4TB of "fast" storage and
>> ...
>> well.  You can probably build this for around $5K (or maybe a bit
>> less) including a 10GigE adapter and server class components.
>
> The whole system needs to be "fast".

Ok ... sounds strange, but ...

Define what you mean by "fast".  Seriously ... we've had people tell us 
about their "huge" storage needs that we can easily fit onto a single 
small unit, no storage cluster needed.  We've had people say "fast" when 
they mean "able to keep 1 GbE port busy".

Fast needs to be articulated really in terms of what you will do with 
it.  As you noted in this and other messages, you are scaling up from 10 
compute nodes to 40 compute nodes.  4x change in demand, and I am 
guessing bandwidth (if these are large files you are streaming) or IOPs 
(if these are many small files you are reading).  Small and large here 
would mean less than 64kB for small, and greater than 4MB for large.


> Actually, to give more detail, we currently have a simple system I
> built for backup/slow access.  This is exactly what you described, a
> bunch of big, slow disks.  Lots of space, lowsy I/O performance, but
> plenty adequate for backup purposes.

Your choice is simple.  Build or buy.  Many folks have made suggestions, 
and some are pretty reasonable, though a pure SSD or Flash based 
machine, while doable (and we sell these), is quite unlikely to be close 
to the realities of your budget.  There are use cases for which this 
does make sense, but the costs are quite prohibitive for all but a few 
users.

> As of right now, we actually have about a dozen "users", i.e.
> compute servers.  The collection is basically a home-grown compute
> farm.  Each server has a gigabit ethernet connection, and 1 TB of
> RAID-1 spinning disk storage.  Each storage mounts every other
> server via NFS, and the current data is distributed evenly across
> all systems.

Ok ... this isn't something thats great to manage.  I might suggest 
looking at GlusterFS for this.  You can aggregate and distribute your 
data.  Even build in some resiliency if you wish/need.  GlusterFS 3.1.2 
is open source, so you can deploy fairly easily.

>
> So, loosely speaking, right now we have roughly 10 TB of
> "live"/"fast" data available at 1 to 10 gbps, depending on how you
> look at it.
>
> While we only have about a dozen servers now, we have definitely
> identified growing this compute farm about 4x (to 40--50 servers)
> within the next year.  But the storage capacity requirements
> shouldn't change too terribly much.  The 20 TB number was basically
> thrown out there as a "it would be nice to have 2x the live
> storage".

Without building a storage unit, you could (in concept) use GlusterFS 
for this.  In practice, this model gets harder and harder to manage as 
you increase the number of nodes.  Adding the N+1 th node means you have 
N+1 nodes to modify and manage storage on.  This does not scale well at all.

>
> I'll also add that this NAS needs to be optimized for *read*
> throughput.  As I mentioned, the only real write process is the
> daily "harvesting" of the data files.  Those are copied across
> long-haul leased lines, and the copy process isn't really
> performance sensitive.  In other words, in day-to-day use, those
> 40--50 client machines will do 100% reading from the NAS.

Ok.

This isn't a commercial.  I'll keep this part short.

We've built systems like this which sustain north of 10GB/s (big B not 
little b) for concurrent read and write access from thousands of cores. 
  20TB (and 40TB) are on the ... small ... side for this, but it is very 
doable.

As a tie in to the Linux RAID list, we use md raid for our OS drives 
(SSD pairs), and other utility functions within the unit, as well as 
striping over our hardware accelerated RAIDs.  We would like to use 
non-power of two chunk sizes, but haven't delved into the code as much 
as we'd like to see if we can make this work.

As a rule, we find mdadm to be an excellent tool, and the whole md RAID 
system to be quite good.  We may spend time at some point on figuring 
out whats wrong with the multi-threaded raid456 bit (allocated 200+ 
kernel threads last I played with it), but apart from bits like that, we 
do find it very good for production use.  It isn't as fast as some 
dedicated accelerated RAID hardware (though we have our md + kernel 
stack very well tuned so some of our software RAIDs are faster than many 
of our competitors hardware RAIDs).

You could build a fairly competent unit using md RAID.

It all gets back to build versus buy.  In either case, I'd recommend 
grabbing a copy of dstat (http://dag.wieers.com/home-made/dstat/) and 
watching your IO/network system throughput.  I am assuming 1 GbE 
switches as the basis for your cluster.  I assume this will not change. 
  The cost of your time/effort and any opportunity cost and productivity 
loss should also be accounted for in the cost-benefit analysis.  That 
is, if it costs you less overall to buy than to build, should you build 
anyway?  Generally no, but some people simply want the experience.

Big issues you need to be aware of with md raid are the hotswap problem. 
  Your SATA link needs to allow you to pull a drive out without crashing 
the machine.  Many of the on-motherboard SATA connections we've used 
over the years don't tolerate unplugs/plugins very well.  I'd recommend 
at least an reasonable HBA for this that understands hot swap and 
handles it correctly (you need hardware and driver level support to 
correctly signal the kernel of these events).

If you decide to buy, have a really clear idea of your performance 
regime, and a realistic eye towards budget.  A 48 TB server with > 2GB/s 
streaming performance for TB sized files is very doable, well under $30k 
USD.  A 48 TB software RAID version would be quite a bit less than that.

Good luck with this, and let us know what you do.

vendor html link:  http://scalableinformatics.com , our storage clusters 
http://scalableinformatics.com/sicluster
