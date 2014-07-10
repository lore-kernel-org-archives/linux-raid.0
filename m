From: Phil Turmel <philip@turmel.org>
Subject: Re: Partitioning on top of raid mirror device questions.
Date: Thu, 10 Jul 2014 09:17:14 -0400
Message-ID: <53BE925A.1000509@turmel.org>
References: <BLU436-SMTP80DC26546309D9E205B561E10E0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU436-SMTP80DC26546309D9E205B561E10E0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Wilson Jonathan <i400s@hotmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Good morning Jonathan,

On 07/10/2014 07:24 AM, Wilson Jonathan wrote:

[trim /]

> However I know from experience that raw files can be a bit slow (totally
> different setup, raid6), so I wondered about the possibility of creating
> 3 individual partitions on top of the raid and if this would improve
> performance.

Yes, likely.  There would be no filesystem overhead.  I do this all the
time with md raid and LVM.

> Having read the man, it seems that partitions on top of raid are fine,
> and no special options are required in the raid creation.

Correct.  However, if you use metadata v0.9 or v1.0, the raid data area
starts at the raid underlying device start.  It's then possible for the
kernel to "see" the partions as if they are on the underlying device
instead of in the array.  This is actually quite handy for /boot,
allowing a BIOS to boot from any of several identical mirrors.  But
hazardous for pretty much everything else.

Modern mdadm defaults to v1.2, so not a problem.

> Now the questions.
> 
> Alignment... 
> 
> Now I understand that the base disk partitions require alignment based
> on the drive... and I assume mdadm then creates its internal structure
> so that it is also aligned, or does it? 

MD raid simply accepts whatever underlying alignment is present, and
sets up the data area by default at no less than 64k intervals (early
versions), and typically 1M intervals (later versions).  So if the
underlying partions are aligned, MD's structures will be aligned.  So
any partitions created within the array that are aligned to the array
will also be aligned to the disks.

> My wondering here is that I know mdadm has an area that holds data bout
> the raid, then another area that holds the data... if the data area
> (chunks? I may have the wrong term) was not aligned to the underlying
> drives then would a write of "chunkX" potentially partially write to
> disk area62 and disk area63 (for example) causing the underlying disk to
> do a RMR.

MD reserves space on the devices for *metadata*, which includes the
*superblock*.  There are various versions and layouts, all reasonably
well documented in the various man pages.

Where the raid level needs it, MD breaks the data area down into
*chunks* to create the boundaries for spreading the array data among the
multiple underlying devices.  The chunk size is configurable, but the
defaults are also alignment-friendly.  Some *filesystems* are smart
enough to take this into account, but I'm not an expert on that.

> If we assume that raid/base disk is all hunky dory alignment wise, this
> then brings me on to partitions on top of the raid...
> 
> As raid when partitioned pretends to be a block disk device; when I used
> gdisk to look at it without performing anything except a look at its
> layout it reports its a normal disk, 512bytes, first usable sector 34,
> partitions will be aligned on 2048 sector boundaries.
> 
> So my question is am I correct in thinking that "md85 partition 01" will
> align to (an imaginary) 2048 boundary on "md85" which will align to the
> real 2048 boundary on "sda5/sdb5"?

Yes.

> I may just stick with raw files but as I am in the process of upgrading
> it piqued my interest and might be worth converting to partitions, or
> possibly LVM which seems the preferred or most documented option (bit
> I'm not sure I want to add a whole new set of skills and learning curve
> at the moment). 

I always use LVM on top of my arrays.  It is also alignment-friendly,
and is *very* handy when you need to rearrange a machine's storage
without downtime.  I prefer it over partitions within the raid.

> My intention is to add 2 more disks to the mirror raid, which while not
> changing the write performance I believe will improve the read
> performance... at least as far as I can tell, again is this assumption
> correct?

It will improve multiple-threaded reads, or multiple simultaneous
programs' reads.  It will not improve single-threaded streaming reads.

HTH,

Phil
