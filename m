From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Grub-install, superblock corrupted/erased and other animals
Date: Tue, 02 Aug 2011 23:02:14 -0500
Message-ID: <4E38C846.3030607@hardwarefreak.com>
References: <CADz4AWHJU5GGBji9uVbvGjPZCZ0CxseiPsQbssCULWxqyKvG8A@mail.gmail.com> <20110802163907.29fc40b4@notabene.brown> <4E37AEE8.1080108@hardwarefreak.com> <CADz4AWFJHah=OkZ0JaC8ZZD+E13D6tOvhz7cRR0oc19OfsOQew@mail.gmail.com> <4E3828B5.2050202@hardwarefreak.com> <CADz4AWErquXh=UszTKrMg7QkT4XbXVdDTa82Nj9Or1huHXQ3bQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADz4AWErquXh=UszTKrMg7QkT4XbXVdDTa82Nj9Or1huHXQ3bQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aaron Scheiner <blue@aquarat.za.net>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/2/2011 4:13 PM, Aaron Scheiner wrote:
> Oh right, I see, my mistake.
> 
> The file is just one of a set of files that I duplicated across two
> arrays. The entire folder (with almost all the duplicated files in it)
> was approximately 2TBs in size. The file I'm using for comparison is
> 11GBs in size.
> The array was originally 8TBs in size, but I upgraded it recently (May
> 2011) to 16TBs (using 2TB drives). As part of the upgrade process I
> copied all the data from the older array to the new array in one large
> cp command.I expect this would have had the effect of defragmenting
> the files... which is great seeing as I'm relying on low fragmentation
> for this process :P .

Ok, so you didn't actually *upgrade* the existing array.  You built a
new array, laid a new filesystem on it, and copied everything over.
Yes, the newly written files would not be fragmented.

> So there's a good chance then that searching on all the drives for
> 512-byte samples from various points in the "example" file will allow
> me to work out the order of the drives.

This seems like a lot of time.  Were you unable to retrieve the
superblocks from the two drives?

> Scalpel is 70% through the first drive. Scans of both the first and
> second drives should be complete by tomorrow morning (my time) yay :)

Disk access is slow compared to CPU.  Why not run 10 instances of
scalpel in parallel, one for each disk, and be done in one big shot?

> Just of interest; machines on a Gigabit LAN used to be able to read
> data off the array at around 60MB/sec... which I was very happy with.
> Since the upgrade to 2TB drives the array has been reading at over
> 100MB/sec, saturating the ethernet interface. Do you think the new
> drives are the reason for the speed increase ? (the new drives are
> cheap Seagate 5900 rpm drives "Green Power", the old drives were
> Samsung 7200 rpm units) or do you think the switch from JFS to XFS
> (and aligning partitions with cylinder boundaries) may have been part
> of it ?

Any answer I could give would be pure speculation, as the arrays in
question are both down and cannot be tested head to head.  The answer
could be as simple as the new SAS/SATA controller(s) being faster than
the old interface(s).  As you've changed so many things, it's probably a
combination of all of them yielding the higher performance.  Or maybe
you changed something in the NFS/CIFS configuration, changed your
kernel, something ancillary to the array that increased network
throughput.  Hard to say at this point with so little information provided.

-- 
Stan
