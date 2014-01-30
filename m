From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: sequential versus random I/O
Date: Thu, 30 Jan 2014 09:28:14 -0600
Message-ID: <CAJvUf-A3ERw-Omn2fRLcZJ=zDOEP-quLe7T5gT6RaVroOpFX3g@mail.gmail.com>
References: <CAJvUf-BbRMXvwwbVvstGPUV7xQpVBqVXLNvTHhYf_wv8=Ws9uw@mail.gmail.com>
	<52E9BB3B.7010600@hardwarefreak.com>
	<CAJvUf-DsN-z4rYjYC6Ki42ce6PzKjwsLjNGTW9QxEi=hKH_7Wg@mail.gmail.com>
	<52EA27D4.6060805@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52EA27D4.6060805@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jan 30, 2014 at 4:22 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> I wouldn't go used as they do.  Not for something this critical.

No, not for an actual production system.  I linked that as "conceptual
inspiration" not as an exact template for what I'd do.  Although, the
used route might be useful for building a cheap prototype to
demonstrate proof of concept.

> If you architect the system correctly, and use decent quality hardware,
> it won't blow up on you.  If you don't get the OS environment tuned
> correctly you'll simply get less throughput than desired.  But that can
> always be remedied with tweaking.

Right.  I think the general concept is solid, but, as with most
things, "the devil's in the details".  FWIW, the creator of the DCDW
enumerated some of the "gotchas" for a build like this[1].  He went
into more detail in some private correspondence with me.  It's a
little alarming that he got roughly 50% the performance with a tuned
Linux setup compared to a mostly out-of-the-box Solaris install.
Also, subtle latency issues with PCIe timings across different
motherboards sounds like a migraine-caliber headache.

> Each of the two backplanes has 24 drive slots and 6 SFF-8087 connectors.
>  Each 8087 carries 4 SAS channels.  You connect two ports of each HBA to
> the top backplane and the other two to the bottom backplane.  I.e. one
> ...

Your concept is similar to what I've sketched out in my mind.  My
twist is that I think I would actually build multiple servers, each
one would be a 24-disk 2U system.  Our data is fairly easy to
partition across multiple servers.  Also, we already have a big
"symlink index" directory that abstracts the actual location of the
files.  IOW, my users don't know/don't care where the files actually
live, as long as the symlinks are there and not broken.

> Without the cost of NICs you're looking at roughly $19,000 for this
> configuration, including shipping costs, for a ~22TB DIY SSD based NFS
> server system expandable to 46TB.  With two quad port 10GbE NICs and
> SFPs you're at less $25K with the potential for ~6GB/s NFS throughput.

Yup, and this amount is less than one year's maintenance on the big
iron system we have in place.  And, quoting the vendor, "Maintenance
costs only go up."

> In specifying HBAs instead of RAID controllers I am assuming you'll use
> md/RAID.  With this many SSDs any current RAID controller would slow you
> down anyway as the ASICs aren't fast enough.  You'll need minimum
> redundancy to guard against an SSD failure, which means RAID5 with SSDs.
>  Your workload is almost exclusively read heavy, which means you could
> simply create a single 24 drive RAID5 or RAID6 with the default 512KB
> chunk.  I'd go with RAID6.  That will yield a stripe width of
> 22*512KB=11MB.  Using RAID5/6 allows you to grow the array incrementally
> without the need for LVM which may slow you down.

At the expense of storage capacity, I was in my mind thinking of
raid10 with 3-way mirrors.  We do have backups, but downtime on this
system won't be taken lightly.

> Surely you'll use XFS as it's the only Linux filesystem suitable for
> such a parallel workload.  As you will certainly grow the array in the
> future, I'd format XFS without stripe alignment and have it do 4KB IOs.
> ...

I was definitely thinking XFS.  But one other motivation for multiple
2U systems (instead of one massive system) is that it's more modular.
Existing systems never have to be grown or reconfigured.  When we need
more space/throughput, I just throw another system in place.  I might
have to re-distribute the data, but this would be a very rare (maybe
once/year) event.

If I get the green light to do this, I'd actually test a few
configurations.  But some that come to mind:
    - raid10,f3
    - groups of 3-way raid1 mirrors striped together with XFS
    - groups of raid6 sets not striped together (our symlink index I
mentioned above makes this not as messy as it sounds)

> The last point I'll make is that it may require some serious tweaking of
> IRQ load balancing, md/RAID, NFS, Ethernet bonding driver, etc, to wring
> peak throughput out of such a DIY SSD system.  Achieving ~1GB/s parallel
> NFS throughput from a DIY rig with a single 10GbE port isn't horribly
> difficult.  3+GB/s parallel NFS via bonded 10GbE interfaces is a bit
> more challenging.

I agree, I think that comes back around to what we said above: the
concept is simple, but the details mean the difference between
brilliant and mediocre.

Thanks for your input Stan, I appreciate it.  I'm an infrequent poster
to this list, but a long-time reader, and I've learned a lot from your
posts over the years.

[1] http://forums.servethehome.com/diy-server-builds/2894-utterly-absurd-quad-xeon-e5-supermicro-server-48-ssd-drives.html
