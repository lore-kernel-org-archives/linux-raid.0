From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Thu, 24 Mar 2011 03:05:02 -0500
Message-ID: <4D8AFB2E.7080203@hardwarefreak.com>
References: <4D837DAF.6060107@hardwarefreak.com>	<20110319090101.1786cc2a@notabene.brown>	<4D8559A2.6080209@hardwarefreak.com>	<20110320144147.29141f04@notabene.brown>	<AANLkTi=2k2=YuZAggonLfKmRFxFd-rXvNo=xkpqWyQNU@mail.gmail.com>	<4D868C36.5050304@hardwarefreak.com>	<20110321024452.GA23100@www2.open-std.org>	<4D875E51.50807@hardwarefreak.com>	<20110321221304.GA900@www2.open-std.org>	<20110322094658.GA21078@cthulhu.home.robinhill.me.uk>	<20110322101403.GA9329@www2.open-std.org>	<4D89B519.3020907@hardwarefreak.com> <AANLkTinONtwNh9KZKe98FL+u2GV_Fqaf1zR8eMyEDGBp@mail.gmail.com> <4D8A1D9B.7020100@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D8A1D9B.7020100@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Joe Landman put forth on 3/23/2011 11:19 AM:

> MD RAID0 or RAID10 would be the sanest approach, and xfs happily does
> talk nicely to the MD raid system, gathering the stripe information from
> it.

Surely you don't mean a straight mdraid0 over the 384 drives, I assume.
 You referring to the nested case I mentioned, yes?

Yes, XFS does read the mdraid parameters and sets block, stripe size,
etc, accordingly.

> The issue though is that xfs stores journals internally by default.  You
> can change this, and in specific use cases, an external journal is
> strongly advised.  This would be one such use case.

The target workload is read heavy, very few writes.  Even if we added a
write heavy workload to the system, with journal residing on an array
that's seeing heavy utilization from the primary workload, with delayed
logging enabled, this is a non issue.

Thus, this is not a case where an external log device is needed.  In
fact, now that we have the delayed logging feature, cases where an
external log device might be needed are very few and far between.

> Though, the OP wants a very read heavy machine, and not a write heavy
> machine.  So it makes more sense to have massive amounts of RAM for the

Assuming the same files aren't being re-read, how does massive RAM
quantity for buffer cache help?

> OP, and lots of high speed fabric (Infiniband HCA, 10-40 GbE NICs, ...).
>  However, a single system design for the OP's requirements makes very
> little economic or practical sense.  Would be very expensive to build.

I estimated the cost of my proposed 10GB/s NFS server at $150-250k
including all required 10GbE switches, the works.  Did you read that
post?  What is your definition of "very expensive"?  Compared to?

> And to keep this on target, MD raid could handle it.

mdraid was mentioned in my system as well.  And yes, Neil seems to think
mdraid would be fine, not a CPU hog.

> Unfortunately, xfs snapshots have to be done via LVM2 right now.  My
> memory isn't clear on this, there may be an xfs_freeze requirement for
> the snapshot to be really valid.  e.g.

Why do you say "unfortunately"?  *ALL* Linux filesystem snapshots are
performed with a filesystem freeze implemented in the VFS layer.  The
freeze 'was' specific to XFS.  It is such a valuable, *needed* feature
that it was bumped into the VFS so all filesystems could take advantage
of it.  Are you saying freezing writes to a filesystem before taking a
snapshot is a bad thing? (/incredulous)

http://en.wikipedia.org/wiki/XFS#Snapshots

>     xfs_freeze -f /mount/point
>     # insert your lvm snapshot command
>     xfs_freeze -u /mount/point
> 
> I am not sure if this is still required.

It's been fully automatic since 2.6.29, for all Linux filesystems.
Invoking an LVM snapshot automatically freezes the filesystem.

> At the end of the day, it will be *far* more economical to build a
> distributed storage cluster with a parallel file system atop it, than
> build a single large storage unit.  

I must call BS on the "far more economical" comment.  At the end of the
day, to use your phrase, the cost of any large scale high performance
storage system comes down to the quantity and price of the disk drives
needed to achieve the required spindle throughput.  Whether you use a
$20K server chassis to host the NICs, disk controllers and all the
drives, or you used six $3000 server chassis, the costs come out roughly
the same.  The big advantages a single chassis server has are simplicity
of design, maintenance, and use.  The only downside is single point of
failure, not higher cost, compared to a storage cluster.  Failures of
complete server chassis are very rare, BTW, especially quad socket HP
servers.

If it takes 8 of your JackRabbit boxen, 384 drives, to sustain 10+GB/s
using RAID10, maintaining that rate during a rebuild, with a load of 50+
concurrent 200MB/s clients, we're looking at about $200K USD, correct,
$25K per box? Your site doesn't show any pricing that I can find so I
making an educated guess.  That cost figure is not substantially
different than my hypothetical configuration, but mine includes $40K of
HP 10GbE switches to connect the clients and the server at full bandwidth.

> We've achieved well north of 10GB/s
> sustained reads and writes from thousands of simultaneous processes
> across thousands of cores (yes, with MD backed RAIDs being part of
> this), for hundreds of GB reads/writes (well into the TB range)

That's great.  Also, be honest with the fine folks on the list.  You use
mdraid0 or linear for stitching hardware RAID arrays together, similar
to what I mentioned.  You're not using mdraid across all 48 drives in
your chassis.  If you are, the information on your website is incorrect
at best, misleading at worst, as it mentions "RAID Controllers" and
quantity per system model, 1-4 in the case of the JackRabbit.

> Hardware design is very important here, as are many other features.  The
> BOM posted here notwithstanding, very good performance starts with good
> selection of underlying components, and a rational design.  Not all
> designs you might see are worth the electrons used to transport them to
> your reader.

Fortunately for the readers here, such unworthy designs you mention
aren't posted on this list.

-- 
Stan
