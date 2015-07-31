From: Matt Garman <matthew.garman@gmail.com>
Subject: Thoughts on big SSD arrays?
Date: Fri, 31 Jul 2015 10:23:26 -0500
Message-ID: <CAJvUf-AW08pcRkADn4Fgh46_vVAxgofiuB93+pzQYk99hx1nbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Every few years I reprise this topic on this mailing list[1], [2].
Basically I'm just brainstorming what is possible on the DIY front
versus purchased solutions from a traditional "big iron" storage
vendor.  Our particular use case is "ultra-high parallel sequential
read throughput".  Our workload is effectively WORM: we do a small
daily incremental write, and then the rest of the time it's constant
re-reading of the data.  Literally 99:1 read:write

I continue to be inspired by the "Dirt Cheap Data Warehouse (DCDW)"
[3].  SSD are getting bigger and prices are dropping rapidly (2 TB
SSDs available now for $800).  With our WORM-like workload, I believe
we can safely get away with consumer drives, as durability shouldn't
be an issue.

So at this point I'm just putting out a feeler---has anyone out there
actually built a massive SSD array, using either Linux software raid
or hardware raid (technically off-topic for this list, though I hope
the discussion is interesting enough to let it slide).  If so, how big
of an array (i.e. drives/capacity)?  What was the target versus actual
performance?  Any particularly challenging issues that came up?

FWIW, I'm thinking of something along the lines of a 24-disk chassis,
with 2 disks for OS (raid1), 2 disks as hot spares, and the remaining
20 in raid-6.  The 22 data disks (raid + hot spares) would be 2 TB
SSDs.

The "problem" with SSDs is that they're just so seductive:
back-of-the-envelope numbers are wonderful, so it's easy to get
overly-optimistic about builds that use them.  But as with most
things, the devil's in the details.

Off the top of my head, potential issues I can think of:

    - Subtle PCIe latency/timing issues of the motherboard
    - High variation in SSD latency
    - Software stacks still making assumptions based on spinning
drives (i.e. not adequately tuned for SSDs)
    - Non-parallel RAID implementation (i.e. single CPU bottleneck potential)
    - Potential bandwidth bottlenecks at various stages: SATA/SAS
interface, SAS expander/backplane, SATA/SAS controller (or HBA), PCIe
bus, CPU memory bus, network card, etc
    - I forget the exact number, but the DCDW guy told me with Linux
he was only able to get about 30% of the predicted throughput in his
SSD array
    - Wacky TRIM related issues (seem to be drive dependent)

Not asking any particular question here, just hoping to start an
open-ended discussion.  Of course I'd love to hear from anyone with
actual SSD RAID experience!

Thanks,
Matt


[1] "high throughput storage server?", Feb 14, 2011
    http://marc.info/?l=linux-raid&m=129772818924753&w=2

[2] "high read throughput storage server, take 2"
    http://marc.info/?l=linux-raid&m=138359009013781&w=2

[3] "The Dirt Cheap Data Warehouse"
    http://www.openida.com/the-dirt-cheap-data-warehouse-an-introduction/
