From: Illtud Daniel <illtud.daniel@llgc.org.uk>
Subject: Re: building a large/fast server
Date: Thu, 30 Jan 2003 18:14:39 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E396B8F.65C18AC@llgc.org.uk>
References: <200301292012.MAA07478@astra.scripps.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andy,

> I'm in the process of designing a large server system. The primary
> consideration will be i/o performance (block read and write of large
> files and maximum i/o's per second) and a filesystem size of 2TB. I'm
> planning to go with 2 3ware 7500-8's, 16 Maxtor 4G160J8's (160GB) and
> do software raid0 between the 7500-8's (raid5).

I did this with dual Chaparral controllers on Fortra enclosures
with U160 disks. (h/w RAID 5 on the disks, dual U160 scsi 66/64
on the server, stripe both with md RAID 0). Two points:

1. It screamed. I've got all the iozone results here
somewhere for XFS, Reiser, Ext3 & Ext2. Reading is 400-500MB/s
(sometimes more, but that must be cache, since the bus can't
be much faster), writing is 150-250MB/s. IIRC, the filesystems
made little difference. I was going to publish these results,
but had a problem on production testing (ext3, if you're asking):

2. It crashed and burned badly. A disk problem became a controller
problem and one of the RAID 5 arrays went down, the other became
degraded (this is one of 5 similar Chaparral/Fortra setups we've
got, no problem with the others - 24x7x52. But don't touch IBM
ultrastars with a bargepole) which didn't do the md RAID 0 array
any favours. Eventually, we got the RAID 5 arrays up & running
again, and could mount the RAID 0. Everything seemed to be OK, but
accessing files would give i/o errors all over the shop. The
whole caboodle got powered down and I'm waiting for a free couple
of days to attempt a thorough post-mortem. It's been like that
for months now...

My tip - don't stripe two RAID5s on RAID0, cos when things go
wrong, they do so in style, and it's very hard to debug. Nice
and fast if you've got the (SCSI) kit, though.

Anybody interested in an autopsy and get to Aberystwyth would be
very welcome...

-- 
Illtud Daniel                                 illtud.daniel@llgc.org.uk
Uwch Ddadansoddwr Systemau                       Senior Systems Analyst
Llyfrgell Genedlaethol Cymru                  National Library of Wales
Yn siarad drosof fy hun, nid LlGC   -  Speaking personally, not for NLW
