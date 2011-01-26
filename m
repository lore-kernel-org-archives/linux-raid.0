From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Wed, 26 Jan 2011 02:32:49 -0600
Message-ID: <4D3FDC31.3010502@hardwarefreak.com>
References: <20110118210112.D13A236C@gemini.denx.de> <20110125171017.GA24921@infradead.org> <20110125184115.1119FB187@gemini.denx.de> <20110125213523.GA14375@infradead.org> <20110126071616.824BEBB0B9@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110126071616.824BEBB0B9@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wolfgang Denk put forth on 1/26/2011 1:16 AM:

> I will not have a single file system, but several, so I'd probably go
> with LVM. But - when I then create a LV, eventually smaller than any
> of the disks, will the data (and thus the traffic) be really distri-
> buted over all drives, or will I not basicly see the same results as
> when using a single drive?

If creating multiple filesystems then concatenation is probably not what you
want, for the reasons you suspect, if you want the IO spread across all 4 disks
for all operations on all filesystems.

> # lvcreate -L 32G -n test castor0
>   Logical volume "test" created
> # mkfs.xfs /dev/mapper/castor0-test

Is this on that set of 4 low end Maxtor disks?  Is the above LV sitting atop
RAID 0, RAID 5, or concatenation?

> [[Only 2/3 of the speed of XFS for block write, but nearly 20% faster
> for block read.  But magnitudes faster for file creates / deletes!]]

Try adding some concurrency, say 8, to bonnie++ and retest both XFS and ext4.
XFS was designed/optimized for parallel workloads, not single thread workloads
(although it can extract some concurrency from a single thread workload).  XFS
really shines with parallel workloads  (assuming the underlying hardware isn't
junk, and the mdraid/lvm configuration is sane).  ext4 will probably always beat
XFS performance with single thread workloads, and I don't believe anyone is
surprised by that.  For most moderate to heavy parallel workloads, XFS usually
trounces ext4 (and all other Linux filesystems).

-- 
Stan
