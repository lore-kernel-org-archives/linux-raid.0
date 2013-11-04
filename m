From: Matt Garman <matthew.garman@gmail.com>
Subject: high read throughput storage server, take 2
Date: Mon, 4 Nov 2013 12:34:44 -0600
Message-ID: <20131104183444.GA13860@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Nearly three years ago, I started a thread on this mailing list[1]
soliciting feedback for DIY versus a purchased solution for a
storage server with massive (read) throughput.  After all the
helpful feedback, I concluded I wasn't ready to pull off DIY, and we
went with a purchased solution.

I recently ran across this article, "The Dirt Cheap Data
Warehouse"[2].  It got me thinking, maybe it's time to revisit the
DIY approach as the support contract on our purchased solution is
running out.

So I thought I'd re-ask the question, given that three years have
passed.

A recap on our requirements: we need a NAS with very high read
throughput.  The workload is nearly WORM: new data is added daily in
one bulk load; the performance of the loading time is un-important
(i.e. not write performance requirement).  The data is constantly
re-read by hundreds of simulation/analysis processes running on a
server farm.  Each individual process presents a sequential read
load to the NAS, but in aggregate, the total workload would be
fairly random read IO.  (While there is a lot of overlap in what
data each program reads, it is generally different.)  Once the NAS
gets too full, the oldest data is rolled off to make room for new
incoming data.

Our current solution came from a big name vendor; it has 96 15K SAS
disks and about 20 TB of total storage.  It cost about $200k at the
time.  Not too long ago, we were seeing 100% disk utilization, and
spent another $50k on some cache modules.  The warranty/support
period is ending within the next year, and continuing it for another
year will cost nearly $40k.  It also occupies 16U of rack space.

I did some quick back-of-the-napkin cost calculations on something
like the "Dirt Cheap Data Warehouse" (DCDW) using the Samsung 840
EVO 1TB drive as my basis ($600).  I came up with about $18k for 24
of those drives, 2U chassis, raid controller, dual 10 GbE NIC,
single-socket CPU and 32 GB of RAM.  That would give nearly 8 TB of
storage using RAID-10 with 3-way mirroring, 12 TB using RAID-10
2-way mirror, or 18 TB using a stripe of three 8-disk RAID-6 sets.

So, two of those DIY systems come in at roughly the same cost as one
year of support for our current system.  I could build four
systems---i.e. total redundancy to buy myself time in case of
non-obvious error---for "cheap" (about $80k, which is cheap relative
to what we've spent on the vendor solution).  Rack space is cut in
half, and power consumption is certainly also cut dramatically.

Any thoughts?  I haven't re-initiated my dialog with the big storage
vendors... maybe their pricing has caught up to what can be done
with something like the DCDW?  I would anticipate that the big
vendors would try to steer me away from consumer SSDs... but why
spend the big bucks on enterprise-grade SSDs for a workload that
does so little writing?


[1] "high throughput storage server?", Feb 14, 2011
    http://marc.info/?l=linux-raid&m=129772818924753&w=2
    
[2] "The Dirt Cheap Data Warehouse"
    http://www.openida.com/the-dirt-cheap-data-warehouse-an-introduction/

