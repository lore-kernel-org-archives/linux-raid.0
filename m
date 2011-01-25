From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Tue, 25 Jan 2011 12:10:17 -0500
Message-ID: <20110125171017.GA24921@infradead.org>
References: <20110118210112.D13A236C@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110118210112.D13A236C@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 18, 2011 at 10:01:12PM +0100, Wolfgang Denk wrote:
> Hi,
> 
> I'm going to replace a h/w based RAID system (3ware 9650SE) by a plain
> s/w RAID0, because the existing system appears to be seriously limited
> in terms of numbers of I/O operations per second.
> 
> Our workload is mixed read / write (something between 80% read / 20%
> write and 50% / 50%), consisting of a very large number of usually
> very small files.
> 
> There may be 20...50 millions of files, or more. 65% of the files are
> smaller than 4 kB; 80% are smaller than 8 kB; 90% are smaller than 16
> kB; 98.4% are smaller than 64 kB.

I don't think you even want a RAID0 in that case.  For small IOPs
you're much better off with a simple concatenation of devices.

> The plan is to build a RAID0 from the 4 devices, create a physical
> volume and a volume group on the resulting /dev/md?, then create 2 or
> 3 logical volumes that will be used as XFS file systems.

Especially if you're running XFS the concetantion will work beautifully
for this setup.  Make sure that your AG boundaries align to the physical
devices, and they can be used completely independently for small IOPs.

> Should I do anything different to acchive maximum performance?

Make sure to disable the disk write caches and if not using the newest
kernel also mount the filesystem with -o nobarrier.  With lots of small
I/Os and metadata intensive workloads that's usually a lot faster.

Also if you have a lot of log traffic an external log devices will
help a lot.  It's doesn't need to be larger, but it will keep the
amount of seeks on the other devices down.

