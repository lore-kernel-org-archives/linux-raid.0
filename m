From: Christoph Hellwig <hch@infradead.org>
Subject: Re: high throughput storage server?
Date: Fri, 18 Mar 2011 10:05:09 -0400
Message-ID: <20110318140509.GA26226@infradead.org>
References: <4D6AC288.20101@wildgooses.com>
 <AANLkTinjPJJrUYrA=fxcau02Q+4Z67YVsJhcGxeTpAAW@mail.gmail.com>
 <4D6DC585.90304@gmail.com>
 <AANLkTi=yWhnqY_RTd8GH+fvEQfHfQ6TpWxnzpx-Fv=aj@mail.gmail.com>
 <AANLkTimB2hv8aP01JdQyOJehtkX2j=G5HtgVi6eNjmLx@mail.gmail.com>
 <AANLkTin=0PN+ovNY=rLu21-VRiy2Ffzrf69_fWsS54iN@mail.gmail.com>
 <20110313201000.GA14090@infradead.org>
 <4D7E0994.3020303@hardwarefreak.com>
 <20110314124733.GA31377@infradead.org>
 <4D835B2A.1000805@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D835B2A.1000805@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Christoph Hellwig <hch@infradead.org>, Roberto Spadim <roberto@spadim.com.br>, Drew <drew.kay@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Mar 18, 2011 at 08:16:26AM -0500, Stan Hoeppner wrote:
> The context of this thread was high throughput NFS serving.  If we
> wanted to do 10 GB/s kernel NFS serving, would we still only have two
> memory copies, since the NFS server runs in kernel, not user, space?
> I.e. in addition to the block device DMA read into the page cache, would
> we also have a memcopy into application buffers from the page cache, or
> does the kernel NFS server simply work with the data directly from the
> page cache without an extra memory copy being needed?  If the latter,
> adding in the DMA copy to the NIC would yield two total memory copies.
> Is this correct?  Or would we have 3 memcopies?

When reading from the NFS server you get away with two memory "copies":

 1) DMA from the storage controller into the page cache
 2) DMA from the page cache into the network card

but when writing to the NFS server you usually need three:

 1) DMA from the network card into the socket buffer
 2) copy from the socket buffer into the page cache
 3) DMA from the page cache to the storage controller

That's because we can't do proper zero copy receive.  It's possible in
theory with hardware than can align payload headers on page boundaries,
and while such hardware exists on the highend I don't think we support
it yet, nor do typical setups have the network card firmware smarts for
it.

> Not to mention hardware interrupt processing load, which, in addition to
> eating some interconnect bandwidth, will also take a toll on CPU cycles
> given the number of RAID HBAs and NIC required to read and push 10GB/s
> NFS to clients.

> Will achieving 10GB/s NFS likely require intricate manual process
> placement, along with spreading interrupt processing across only node
> cores which are directly connected to the IO bridge chips, preventing
> interrupt packets from consuming interconnect bandwidth?

Note that we do have a lot of infrastructure for high end NFS serving in
the kernel, e.g. the per-node NFSD thread that Greg Banks wrote for SGI
a couple of years ago.  All this was for big SGI NAS servers running
XFS.  But as you mentioned it's not quite trivial to setup.

> > In short you need to review your configuration pretty carefully.  With
> > direct I/O it's a lot easier as you save a copy.
> 
> Is O_DIRECT necessary in this scenario, or does the kernel NFS server
> negate the need for direct IO since the worker threads execute in kernel
> space not user space?  If not, is it possible to force to kernel NFS
> server to always do O_DIRECT reads and writes, or is that the
> responsibility of the application on the NFS client?

The kernel NFS server doesn't use O_DIRECT - in fact the current
O_DIRECT code can't be used on kernel pages at all.  For some NFS
workloads it would certainly be interesting to make use of it, though.
E.g. large stable writes.

> I was under the impression that the memory manager in recent 2.6
> kernels, similar to IRIX on Origin, is sufficiently NUMA aware in the
> default configuration to automatically take care of memory placement,
> keeping all of a given process/thread's memory on the local node, and in
> cases where thread memory ends up on another node for some reason, block
> copying that memory to the local node and invalidating the remote CPU
> caches, or in certain cases, simply moving the thread execution pointer
> to a core in the remote node where the memory resides.
> 
> WRT the page cache, if the kernel doesn't automatically place page cache
> data associated with a given thread in that thread's local node memory,
> is it possible to force this?  It's been a while since I read the
> cpumemsets and other related documentation, and I don't recall if page
> cache memory is manually locatable.  That doesn't ring a bell.
> Obviously it would be a big win from an interconnect utilization and
> overall performance standpoint if the thread's working memory and page
> cache memory were both on the local node.

The kernel is pretty smart in placement of user and page cache data, but
it can't really second guess your intention.  With the numactl tool you
can help it doing the proper placement for you workload.  Note that the
choice isn't always trivial - a numa system tends to have memory on
multiple nodes, so you'll either have to find a good partitioning of
your workload or live with off-node references.  I don't think
partitioning NFS workloads is trivial, but then again I'm not a
networking expert.

