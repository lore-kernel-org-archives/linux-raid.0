From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Fri, 18 Mar 2011 08:16:26 -0500
Message-ID: <4D835B2A.1000805@hardwarefreak.com>
References: <AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com> <20110215044434.GA9186@septictank.raw-sewage.fake> <4D6AC288.20101@wildgooses.com> <AANLkTinjPJJrUYrA=fxcau02Q+4Z67YVsJhcGxeTpAAW@mail.gmail.com> <4D6DC585.90304@gmail.com> <AANLkTi=yWhnqY_RTd8GH+fvEQfHfQ6TpWxnzpx-Fv=aj@mail.gmail.com> <AANLkTimB2hv8aP01JdQyOJehtkX2j=G5HtgVi6eNjmLx@mail.gmail.com> <AANLkTin=0PN+ovNY=rLu21-VRiy2Ffzrf69_fWsS54iN@mail.gmail.com> <20110313201000.GA14090@infradead.org> <4D7E0994.3020303@hardwarefreak.com> <20110314124733.GA31377@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110314124733.GA31377@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Roberto Spadim <roberto@spadim.com.br>, Drew <drew.kay@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Christoph Hellwig put forth on 3/14/2011 7:47 AM:
> On Mon, Mar 14, 2011 at 07:27:00AM -0500, Stan Hoeppner wrote:
>> Is this only an issue with multi-chassis cabled NUMA systems such as
>> Altix 4000/UV and the (discontinued) IBM x86 NUMA systems (x440/445)
>> with their relatively low direct node-node bandwidth, or is this also of
>> concern with single chassis systems with relatively much higher
>> node-node bandwidth, such as the AMD Opteron systems, specifically the
>> newer G34, which have node-node bandwidth of 19.2GB/s bidirectional?
> 
> Just do your math.  Buffered I/O will do two memory copies - a
> copy_to_user into the pagecache and DMA from the pagecache to the device
> (yes, that's also a copy as far as the memory subsystem is concerned,
> even if it is access from the device).

The context of this thread was high throughput NFS serving.  If we
wanted to do 10 GB/s kernel NFS serving, would we still only have two
memory copies, since the NFS server runs in kernel, not user, space?
I.e. in addition to the block device DMA read into the page cache, would
we also have a memcopy into application buffers from the page cache, or
does the kernel NFS server simply work with the data directly from the
page cache without an extra memory copy being needed?  If the latter,
adding in the DMA copy to the NIC would yield two total memory copies.
Is this correct?  Or would we have 3 memcopies?

> So to get 10GB/s throughput you spends 20GB/s on memcpys for the actual
> data alone.  Add to that other system activity and metadata.  Wether you
> hit the interconnect or not depends on your memory configuration, I/O
> attachment, and process locality.  If you have all memory that the
> process uses and all I/O on one node you won't hit the interconnect at
> all, but depending on memory placement and storage attachment you might
> hit it twice:
> 
>  - userspace memory on node A to pagecache on node B to device on node
>    C (or A again for that matter).

Not to mention hardware interrupt processing load, which, in addition to
eating some interconnect bandwidth, will also take a toll on CPU cycles
given the number of RAID HBAs and NIC required to read and push 10GB/s
NFS to clients.

Will achieving 10GB/s NFS likely require intricate manual process
placement, along with spreading interrupt processing across only node
cores which are directly connected to the IO bridge chips, preventing
interrupt packets from consuming interconnect bandwidth?

> In short you need to review your configuration pretty carefully.  With
> direct I/O it's a lot easier as you save a copy.

Is O_DIRECT necessary in this scenario, or does the kernel NFS server
negate the need for direct IO since the worker threads execute in kernel
space not user space?  If not, is it possible to force to kernel NFS
server to always do O_DIRECT reads and writes, or is that the
responsibility of the application on the NFS client?

I was under the impression that the memory manager in recent 2.6
kernels, similar to IRIX on Origin, is sufficiently NUMA aware in the
default configuration to automatically take care of memory placement,
keeping all of a given process/thread's memory on the local node, and in
cases where thread memory ends up on another node for some reason, block
copying that memory to the local node and invalidating the remote CPU
caches, or in certain cases, simply moving the thread execution pointer
to a core in the remote node where the memory resides.

WRT the page cache, if the kernel doesn't automatically place page cache
data associated with a given thread in that thread's local node memory,
is it possible to force this?  It's been a while since I read the
cpumemsets and other related documentation, and I don't recall if page
cache memory is manually locatable.  That doesn't ring a bell.
Obviously it would be a big win from an interconnect utilization and
overall performance standpoint if the thread's working memory and page
cache memory were both on the local node.

-- 
Stan
