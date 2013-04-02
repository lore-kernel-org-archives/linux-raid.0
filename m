From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 2/2 v3]raid5: create multiple threads to handle stripes
Date: Tue, 2 Apr 2013 08:39:37 +0800
Message-ID: <20130402003937.GA7393@kernel.org>
References: <20120809085808.GB30111@kernel.org>
 <20130307073123.GA5819@kernel.org>
 <20130312123927.16e49ea9@notabene.brown>
 <513FCBE3.90205@hardwarefreak.com>
 <20130328174744.79b04058@notabene.brown>
 <20130329023407.GA19943@kernel.org>
 <5155608E.9050800@hardwarefreak.com>
 <20130401015741.GA24636@kernel.org>
 <5159E08A.2040203@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5159E08A.2040203@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, dan.j.williams@gmail.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Joe Landman <joe.landman@gmail.com>
List-Id: linux-raid.ids

On Mon, Apr 01, 2013 at 02:31:22PM -0500, Stan Hoeppner wrote:
> On 3/31/2013 8:57 PM, Shaohua Li wrote:
> > On Fri, Mar 29, 2013 at 04:36:14AM -0500, Stan Hoeppner wrote:
> >> I'm CC'ing Joe Landman as he's already building systems of the caliber
> >> that would benefit from this write threading and may need configurable
> >> CPU scheduling.  Joe I've not seen a post from you on linux-raid in a
> >> while so I don't know if you've been following this topic.  Shaohua has
> >> created patch sets to eliminate, or dramatically mitigate, the horrible
> >> single threaded write performance of md/RAID 1, 10, 5, 6 on SSD.
> >> Throughput no longer hits a wall due to peaking one core, as with the
> >> currently shipping kernel code.  Your thoughts?
> >>
> >> On 3/28/2013 9:34 PM, Shaohua Li wrote:
> >> ...
> >>> Frankly I don't like the cpuset way. It might just work, but it's just another
> >>> API to control process affinity and has no essential difference against my
> >>> approach (which directly sets process affinity). Generally we use cpuset
> >>> instead of process affinity is because of something like inherit affinity.
> >>> While the raid5 process doesn't involve those.
> >>
> >> First I should again state I'm not a developer, but a sysadmin, and this
> >> is the viewpoint from which I speak.
> >>
> >> The essential difference I see is the user interface the sysadmin will
> >> employ to tweak thread placement/behavior.  Hypothetically, say I have a
> >> 64 socket Altix UV machine w/8 core CPUs, 512 cores.  Each node board
> >> has two sockets, two distinct NUMA nodes, 64 total, but these share a
> >> NUMALink hub interface chip connection to the rest of the machine, and
> >> share a PCIe mezzanine interface.
> >>
> >> We obviously want to keep md/RAID housekeeping bandwidth (stripe cache,
> >> RMW reads, etc) isolated to the node where it is attached so it doesn't
> >> needlessly traverse NUMALink eating precious, limited, 'high' latency
> >> NUMAlink system interconnect bandwidth.  We need to keep that free for
> >> our parallel application which is eating 100% of the other 504 cores and
> >> saturating NUMAlink with MPI and file IO traffic.
> >>
> >> So lets say I have one NUMA node out of 64 dedicated to block device IO.
> >>  It has a PCIe x8 v2 IB 4x QDR HBA (4GB/s) connection to a SAN box with
> >> 18 SSDs (and 128 SAS rust).  The SAN RAID ASIC can't keep up with SSD
> >> RAID5 IO rates while also doing RAID for the rust.  So we export the
> >> SSDs individually and we make 2x 9 drive md/RAID5 arrays.  I've already
> >> created a cpuset with this NUMA node for strictly storage related
> >> processes including but not limited to XFS utils, backup processes,
> >> snapshots, etc, so that the only block IO traversing NUMAlink is user
> >> application data.  Now I add another 18 SSDs to the SAN chassis, and
> >> another IB HBA to this node board.
> >>
> >> Ideally, my md/RAID write threads should already be bound to this
> >> cpuset.  So all I should need to do is add this 2nd node to the cpuset
> >> and I'm done.  No need to monkey with additional md/RAID specific
> >> interfaces.
> >>
> >> Now, that's the simple scenario.  On this particular machine's
> >> architecture, you have two NUMA nodes per physical node, so expanding
> >> storage hardware on the same node board should be straightforward above.
> >>  However, most Altix UV machines will have storage HBAs plugged into
> >> many node boards.  If we create one cpuset and put all the md/RAID write
> >> theads in it, then we get housekeeping RAID IO traversing the NUMAlink
> >> interconnect.  So in this case we'd want to pin the threads to the
> >> physical node board where the PCIe cards, and thus disks, are attached.
> >>
> >> The 'easy' way to do this is simply create multiple cpusets, one for
> >> each storage node.  But then you have the downside of administration
> >> headaches, because you may need to pin your FS utils, backup, etc to a
> >> different storage cpuset depending on which HBAs the filesystem resides,
> >> and do this each and every time, which is a nightmare with scheduled
> >> jobs.  Thus in this case its probably best to retain the single storage
> >> cpuset and simply make sure the node boards share the same upstream
> >> switch hop, keeping the traffic as local as possible.  The kernel
> >> scheduler might already have some NUMA scheduling intelligence here that
> >> works automagically even within a cpuset, to minimize this.  I simply
> >> lack knowledge in this area.
> >>
> >>>> I still like the idea of an 'ioctl' which a process can call and will cause
> >>>> it to start handling requests.
> >>>> The process could bind itself to whatever cpu or cpuset it wanted to, then
> >>>> could call the ioctl on the relevant md array, and pass in a bitmap of cpus
> >>>> which indicate which requests it wants to be responsible for.  The current
> >>>> kernel thread will then only handle requests that no-one else has put their
> >>>> hand up for.  This leave all the details of configuration in user-space
> >>>> (where I think it belongs).
> >>>
> >>> The 'ioctl' way is interesting. But there are something we need answer:
> >>>
> >>> 1. How kernel knows if there will be process to handle one cpu's requests
> >>> before an 'ioctl' is called? I suppose you want 2 ioctls. One ioctl telles
> >>> kernel the process handles request from cpus of a cpumask. The other ioctl does
> >>> request handling. The process must sleep in the ioctl to wait requests.
> >>>
> >>> 2. If a process is killed in the middle, how kernel knows? Do you want to hook
> >>> something in task management code? For normal process exit, we need another
> >>> ioctl to tell kernel the process is exiting.
> >>>
> >>> The only difference between this way and my way is if the request handling task
> >>> is userspace or kernel space. In both ways, you need set affinity and uses
> >>> ioctl/sysfs to control requests source for the process.
> >>
> >> Being a non dev I lack requisite knowledge to comment on ioctls.  I'll
> >> simply reiterate that whatever you go with should make use of an
> >> existing familiar user interface where this same scheduling is already
> >> handled, which is cpusets.  The only difference being kernel vs user
> >> space.  Which may turn out to be a problem, I dunno.
> > 
> > Hmm, there might be misunderstanding here. In my way:
> 
> Very likely.
> 
> > #echo 3 > /sys/block/md0/md/auxthread_number. Create several kernel threads to
> > handle requests. You can use any approach to set smp affinity for the threads.
> > You can use cpuset to bind the threads too.
> 
> So you have verified that these kernel threads can be placed by the
> cpuset calls and shell commands?  Cool, then we're over one hurdle, so
> to speak.  So say I create 8 threads with a boot script.  I want to
> place 4 each in 2 different cpusets.  Will this work be left for every
> sysadmin to figure out and create him/herself, or will you include
> scripts/docs/etc to facilitate this integration?

Sure, verified cpuset can apply to kernel threads. No, I don't have scripts.
 
> > #echo 1-3 > /sys/block/md0/md/auxth0/cpulist. This doesn't set above threads'
> > affinity. It sets which CPU's requests the thread should handle. Regardless
> > using my way, cpuset or ioctl, we need the similar way to notify worker thread
> > which CPU's requests it should handle (unless we have a hook in scheduler, when
> > a thread's affinity is changed, we get a notification)
> 
> I don't even know if this is necessary.  From a NUMA perspective, and
> all systems are now NUMA, it's far more critical to make sure a RAID
> thread is executing on a core/socket to which the HBA is attached via
> the PCIe bridge.  You should make it a priority to write code to
> identify this path and automatically set RAID thread affinity to that
> set of cores.  This keeps the extra mirror and parity write data, RMW
> read data, and stripe cache accesses off the NUMA interconnect, as I
> stated in a previous email.  This is critical to system performance, no
> matter how large or small the system.
> 
> Once this is accomplished, I see zero downside, from a NUMA standpoint,
> to having every RAID thread be able to service every core.  Obviously
> this would require some kind of hashing so we don't generate hot spots.
>  Does your code already prevent this?  Anyway, I think you can simply
> eliminate this tunable parm altogether.
> 
> On that note, it would make sense to modify every md/RAID driver to
> participate in this hashing.  Users run multiple RAID levels on a given
> box, and we want the bandwidth and CPU load spread as evenly as possible
> I would think.
> 
> > In the sumary, my approach doesn't prevent you to use CPUSET. Did I miss something?
> 
> IMO, it's not enough to simply make it work with cpusets, but to get
> some seamless integration.  Now that I think more about this, it should
> be possible to get optimal affinity automatically by identifying the
> attachment point of the HBA(s), and sticking all RAID threads to cores
> on that socket.  If the optimal number of threads to create could be
> calculated for any system, you could eliminate all of these tunables,
> and everything be be fully automatic.  No need for user defined parms,
> and no need for cpusets.

I understand. It's always preferred everything is automatic set with best
performance. But last time I checked, different optimal thread number applies
in different setup/workload. After some discussions, we decided to add some
tunables. This isn't convenient from user point of view, but it's hard to
determine the optimal tunable value.
