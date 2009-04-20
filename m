From: Tapani Tarvainen <raid@tapanitarvainen.fi>
Subject: Re: RAID without superblock
Date: Mon, 20 Apr 2009 08:13:50 +0300
Message-ID: <20090420051350.GA13091@hamsu.tarvainen.info>
References: <20090419114743.GA29195@lazy.lzy> <e96b335a0ba8595e2921d164f9b15ff7.squirrel@neil.brown.name> <20090419210200.GA6942@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090419210200.GA6942@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 19, 2009 at 11:04:07PM +0200, Piergiorgio Sartor (piergiorgio.sartor@nexgo.de) wrote:

> > Why would you want a RAID-1 without superblock.

> Ah! I was thinking about it as a method to
> build a RAID with an already existing disk
> or partition, which cannot be modified.

Well, that it isn't. Although of course if you have
multiple partitions on the disk, you can build
RAID on them separately, possibly leaving some
out and it might be useful in some situaitions,
but that's apparently not what you had in mind.

> So, let's say I've already a disk with some
> data and I want/need to protect it with a
> RAID configuration, but I cannot re-create
> the RAID from scratch, because this will
> damage the content of the disk.

Well, you could create the RAID as degenerate on the
new disk(s) only, copy the data over and then add the
old disk to complete array.

> For example, I found consistent to create the
> array with the correct disk and "missing",
> then add the mirror.

I'm not sure what you mean, unless it's just what
I suggested above.

> Of course, if there is a known order for the
> resync, then it would be enough to build
> the array with this in mind.
> The issue could also be that the "primary"
> disk could be updated alone, sometimes.

What would "updating" the disk mean here?
If you want to have two disks of different
sizes so that the "extra" space in the bigger
one is usable, just not RAIDed, it's easy:
just build the RAID out of the entire smaller
disk and a similarly-sized partition in the
bigger one, and use the remainder of the latter
as a regular partition.
And upgrading the disks one at a time in such
a setup is perfectly possible, without any
backup/restore cycles, too.
(Although backups are still recommended, of course.)

-- 
Tapani Tarvainen
