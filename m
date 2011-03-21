From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Mon, 21 Mar 2011 09:18:57 -0500
Message-ID: <4D875E51.50807@hardwarefreak.com>
References: <4D7E0994.3020303@hardwarefreak.com> <20110314124733.GA31377@infradead.org> <4D835B2A.1000805@hardwarefreak.com> <20110318140509.GA26226@infradead.org> <4D837DAF.6060107@hardwarefreak.com> <20110319090101.1786cc2a@notabene.brown> <4D8559A2.6080209@hardwarefreak.com> <20110320144147.29141f04@notabene.brown> <AANLkTi=2k2=YuZAggonLfKmRFxFd-rXvNo=xkpqWyQNU@mail.gmail.com> <4D868C36.5050304@hardwarefreak.com> <20110321024452.GA23100@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110321024452.GA23100@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Mdadm <linux-raid@vger.kernel.org>, Roberto Spadim <roberto@spadim.com.br>, NeilBrown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids

Keld J=F8rn Simonsen put forth on 3/20/2011 9:44 PM:

> Are you then building the system yourself, and running Linux MD RAID?

No.  These specifications meet the needs of Matt Garman's analysis
cluster, and extend that performance from 6GB/s to 10GB/s.  Christoph's
comments about 10GB/s throughput with XFS on large CPU count Altix 4000
series machines from a few years ago prompted me to specify a single
chassis multicore AMD Opteron based system that can achieve the same
throughput at substantially lower cost.

> Anyway, with 384 spindles and only 50 users, each user will have in
> average 7 spindles for himself. I think much of the time this would m=
ean=20
> no random IO, as most users are doing large sequential reading.=20
> Thus on average you can expect quite close to striping speed if you
> are running RAID capable of striping.=20

This is not how large scale shared RAID storage works under a
multi-stream workload.  I thought I explained this in sufficient detail=
=2E
 Maybe not.

> I am puzzled about the --linear concatenating. I think this may cause
> the disks in the --linear array to be considered as one spindle, and =
thus
> no concurrent IO will be made. I may be wrong there.

You are puzzled because you are not familiar with the large scale
performance features built into the XFS filesystem.  XFS allocation
groups automatically enable large scale parallelism on a single logical
device comprised of multiple arrays or single disks, when configured
correctly.  See:

http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US=
/html/Allocation_Groups.html

The storage pool in my proposed 10GB/s NFS server system consists of 16
RAID10 arrays comprised of 24 disks of 146GB capacity, 12 stripe
spindles per array, 1.752TB per array, 28TB total raw.  Concatenating
the 16 array devices with mdadm --linear creates a 28TB logical device.
 We format it with this simple command, not having to worry about strip=
e
block size, stripe spindle width, stripe alignment, etc:

~# mkfs.xfs -d agcount=3D64

Using this method to achieve parallel scalability is simpler and less
prone to configuration errors when compared to multi-level striping,
which often leads to poor performance and poor space utilization.  With
64 XFS allocation groups the kernel can read/write 4 concurrent streams
from/to each array of 12 spindles, which should be able to handle this
load with plenty of headroom.  This system has 32 SAS 6G channels, each
able to carry two 300MB/s streams, 19.8GB/s aggregate, substantially
more than our 10GB/s target.  I was going to state that we're limited t=
o
10.4GB/s due to the PCIe/HT bridge to the processor.  However, I just
realized I made an error when specifying the DL585 G7 with only 2
processors.  See [1] below for details.

Using XFS in this manner allows us to avoid nested striped arrays and
the inherent problems associated with them.  For example, in absence of
using XFS allocation groups to get our parallelism, we could do the
following:

1.  Width 16 RAID0 stripe over width 12 RAID10 stripe
2.  Width 16 LVM   stripe over width 12 RAID10 stripe

In either case, what is the correct/optimum stripe block size for each
level when nesting the two?  The answer is that there really aren't
correct or optimum stripe sizes in this scenario.  Writes to the top
level stripe will be broken into 16 chunks.  Each of these 16 chunks
will then be broken into 12 more chunks.  You may be thinking, "Why
don't we just create one 384 disk RAID10?  It would SCREAM with 192
spindles!!"  There are many reasons why nobody does this, one being the
same stripe block size issue as with nested stripes.  Extremely wide
arrays have a plethora of problems associated with them.

In summary, concatenating many relatively low stripe spindle count
arrays, and using XFS allocation groups to achieve parallel scalability=
,
gives us the performance we want without the problems associated with
other configurations.


[1]  In order to get all 11 PCIe slots in the DL585 G7 one must use the
4 socket model, as the additional PCIe slots of the mezzanine card
connect to two additional SR5690 chips, each one connecting to an HT
port on each of the two additional CPUs.  Thus, I'm re-specifying the
DL585 G7 model to have 4 Opteron 6136 CPUs instead of two, 32 cores
total.  The 128GB in 16 RDIMMs will be spread across all 16 memory
channels.  Memory bandwidth thus doubles to 160GB/s and interconnect b/=
w
doubles to 320GB/s.  Thus, we now have up to 19.2 GB/s of available one
way disk bandwidth as we're no longer limited by a 10.4GB/s HT/PCIe
link.  Adding the two required CPUs may have just made this system
capable of 15GB/s NFS throughput for less than $5000 additional cost,
not due to the processors, but the extra IO bandwidth enabled as a
consequence of their inclusion.  Adding another quad port 10 GbE NIC
will take it close to 20GB/s NFS throughput.  Shame on me for not
digging far deeper into the DL585 G7 docs.

--=20
Stan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
