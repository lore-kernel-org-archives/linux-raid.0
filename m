From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Tue, 25 Jan 2011 16:35:23 -0500
Message-ID: <20110125213523.GA14375@infradead.org>
References: <20110118210112.D13A236C@gemini.denx.de>
 <20110125171017.GA24921@infradead.org>
 <20110125184115.1119FB187@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110125184115.1119FB187@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 25, 2011 at 07:41:15PM +0100, Wolfgang Denk wrote:
> > I don't think you even want a RAID0 in that case.  For small IOPs
> > you're much better off with a simple concatenation of devices.
> 
> What exactly do you mean by "conatenation"? LVM striping?
> At least the discussion here does not show any significant advantages
> for this concept:
> http://groups.google.com/group/ubuntu-user-community/web/pick-your-pleasure-raid-0-mdadm-striping-or-lvm-striping

No, concatenation means not using any striping, but just concatenating
the disk linearly, e.g.

 +-----------------------------------+
 |            Filesystem             |
 +--------+--------+--------+--------+
 | Disk 1 | Disk 2 | Disk 3 | Disk 4 |
 +--------+--------+--------+--------+

This can be done using the using the MD linear target, or simply
by having multiple PVs in a VG with LVM.

> 
> > Make sure to disable the disk write caches and if not using the newest
> > kernel also mount the filesystem with -o nobarrier.  With lots of small
> > I/Os and metadata intensive workloads that's usually a lot faster.
> 
> Tests if done recently indicate that on the other hand nobarrier causes
> a serious degradation of read and write performance (down to some 40%
> of the values before).

Do you have a pointer to your results?

