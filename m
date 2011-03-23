From: Joe Landman <joe.landman@gmail.com>
Subject: Re: high throughput storage server?
Date: Wed, 23 Mar 2011 12:19:39 -0400
Message-ID: <4D8A1D9B.7020100@gmail.com>
References: <4D837DAF.6060107@hardwarefreak.com>	<20110319090101.1786cc2a@notabene.brown>	<4D8559A2.6080209@hardwarefreak.com>	<20110320144147.29141f04@notabene.brown>	<AANLkTi=2k2=YuZAggonLfKmRFxFd-rXvNo=xkpqWyQNU@mail.gmail.com>	<4D868C36.5050304@hardwarefreak.com>	<20110321024452.GA23100@www2.open-std.org>	<4D875E51.50807@hardwarefreak.com>	<20110321221304.GA900@www2.open-std.org>	<20110322094658.GA21078@cthulhu.home.robinhill.me.uk>	<20110322101403.GA9329@www2.open-std.org>	<4D89B519.3020907@hardwarefreak.com> <AANLkTinONtwNh9KZKe98FL+u2GV_Fqaf1zR8eMyEDGBp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinONtwNh9KZKe98FL+u2GV_Fqaf1zR8eMyEDGBp@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/23/2011 11:57 AM, Roberto Spadim wrote:
> it's something like 'partitioning'? i don't know xfs very well, but ...
> if you use 99% ag16 and 1% ag1-15
> you should use a raid0 with stripe (for better write/read rate),
> linear wouldn't help like stripe, i'm right?
>
> a question... this example was with directories, how files (metadata)
> are saved? and how file content are saved? and jornaling?

I won't comment on the hardware design or choices aspects.  Will briefly 
touch on the file system and MD raid.

MD RAID0 or RAID10 would be the sanest approach, and xfs happily does 
talk nicely to the MD raid system, gathering the stripe information from it.

The issue though is that xfs stores journals internally by default.  You 
can change this, and in specific use cases, an external journal is 
strongly advised.  This would be one such use case.

Though, the OP wants a very read heavy machine, and not a write heavy 
machine.  So it makes more sense to have massive amounts of RAM for the 
OP, and lots of high speed fabric (Infiniband HCA, 10-40 GbE NICs, ...). 
  However, a single system design for the OP's requirements makes very 
little economic or practical sense.  Would be very expensive to build.

And to keep this on target, MD raid could handle it.

> i see a filesystem something like: read/write
> jornaling(metadata/files), read/write metadata, read/write file
> content, check/repair filesystem, features (backup, snapshot, garbage
> collection, raid1, increase/decrease fs size, others)

Unfortunately, xfs snapshots have to be done via LVM2 right now.  My 
memory isn't clear on this, there may be an xfs_freeze requirement for 
the snapshot to be really valid.  e.g.

	xfs_freeze -f /mount/point
	# insert your lvm snapshot command
	xfs_freeze -u /mount/point

I am not sure if this is still required.
	
> speed of write and read will be a function of how you designed it to
> use device layer (it's something like a virtual memory utilization, a
> big memory, and many programs trying to use small parts and when need
> use a big part)

At the end of the day, it will be *far* more economical to build a 
distributed storage cluster with a parallel file system atop it, than 
build a single large storage unit.  We've achieved well north of 10GB/s 
sustained reads and writes from thousands of simultaneous processes 
across thousands of cores (yes, with MD backed RAIDs being part of 
this), for hundreds of GB reads/writes (well into the TB range)

Hardware design is very important here, as are many other features.  The 
BOM posted here notwithstanding, very good performance starts with good 
selection of underlying components, and a rational design.  Not all 
designs you might see are worth the electrons used to transport them to 
your reader.

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
