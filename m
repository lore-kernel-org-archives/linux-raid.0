From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: sequential versus random I/O
Date: Wed, 29 Jan 2014 21:20:43 -0600
Message-ID: <CAJvUf-DsN-z4rYjYC6Ki42ce6PzKjwsLjNGTW9QxEi=hKH_7Wg@mail.gmail.com>
References: <CAJvUf-BbRMXvwwbVvstGPUV7xQpVBqVXLNvTHhYf_wv8=Ws9uw@mail.gmail.com>
	<52E9BB3B.7010600@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52E9BB3B.7010600@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jan 29, 2014 at 8:38 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> If your workflow description is accurate, and assuming you're trying to
> fix a bottleneck at the NFS server, the solution to this is simple, and
> very well known:  local scratch space.  Given your workflow description
> it's odd that you're not already doing so.  Which leads me to believe
> that the description isn't entirely accurate.  If it is, you simply copy
> each file to local scratch disk and iterate over it locally.  If you're
> using diskless compute nodes then that's an architectural
> flaw/oversight, as this workload as described begs for scratch disk.

There really is no bottleneck now, but looking into the future, there
will be a bottleneck at the next addition of compute nodes.  I've
thought about local caching at the compute node level, but I don't
think it will help.  The total collection of big files on the NFS
server is upwards of 20 TB.  Processes are distributed randomly across
compute nodes, and any process could access any part of that 20 TB
file collection.  (My description may have implied there is a 1-to-1
process-to-file mapping, but that is not the case.)  So the local
scratch space would have to be quite big to prevent thrashing.  In
other words, unless the local cache was multi-terrabyte in size, I'm
quite confident that the local cache would actually degrade
performance due to constant turnover.

Furthermore, let's simplify the workflow: say there is only one
compute server, and it's local disk is sufficiently large to hold the
entire data set (assume 20 TB drives exist with performance
characteristics similar to today's spinning drives).  In other words,
there is no need for the NFS server now.  I believe even in this
scenario, the single local disk would be a bottleneck to the dozens of
programs running on the node... these compute nodes are typically dual
socket, 6 or 8 core systems.  The computational part is fast enough on
modern CPUs that the I/O workload can be realistically approximated by
dozens of parallel "dd if=/random/big/file of=/dev/null" processes,
all accessing different files from the collection.  In other words,
very much like my contrived example of multiple parallel read
benchmark programs.

FWIW, the current NFS server is from a big iron storage vendor.  It's
made up of 96 15k SAS drives.  A while ago we were hitting a
bottleneck on the spinning disks, so the vendor was happy to sell us 1
TB of their very expensive SSD cache module.  This worked quite well
at reducing spinning disk utilization, and cache module utilization
was quite high.  The recent compute node expansion has lowered cache
utilization at the expense of spinning disk utilization... things are
still chugging along acceptably, but we're at capacity.  We've maxed
out at just under 3 GB/sec of throughput (that's gigabytes, not bits).

What I'm trying to do is decide if we should continue to pay expensive
maintenance and additional cache upgrades to our current device, or if
I might be better served by a DIY big array of consumer SSDs, ala the
"Dirt Cheap Data Warehouse" [1].  I don't see too many people building
big arrays of consumer-grade SSDs, or even vendors selling pre-made
big SSD based systems.  (To be fair, you can buy big SSD arrays, but
with crazy-expensive *enterprise* SSD... we have effectively a WORM
workload, so don't need the write endurance features of enterprise
SSD.  I think that's where the value opportunity comes in for us.)
Anyway, I'm just looking for reasons why taking on such a project
might blow up in my face (assuming I can convince the check-writer to
basically fund a storage R&D project).


[1] http://www.openida.com/the-dirt-cheap-data-warehouse-an-introduction/
