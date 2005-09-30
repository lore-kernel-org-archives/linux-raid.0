From: Gregory Seidman <gsslist+linuxraid@anthropohedron.net>
Subject: Re: Best way to achieve large, expandable, cheap storage?
Date: Fri, 30 Sep 2005 14:16:43 -0400
Message-ID: <20050930181643.GA23130@anthropohedron.net>
References: <dhje16$tmq$1@sea.gmane.org>
Reply-To: gsslist+linuxraid@anthropohedron.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dhje16$tmq$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Sep 30, 2005 at 02:20:11PM +0100, Robin Bowes wrote:
} I have a business opportunity which would involve a large amount of
} storage, possibly growing to 10TB in the first year, possibly more. This
} would be to store media files - probably mainly .flac or .mp3 files.
} 
} Concurrency wouldn't be particularly important as I'd be the only person
} access the storage and I have no need for lightning speed.

If you aren't overly concerned about speed, you can use LVM. If you want
redundancy as well as disk-spanning, you can use RAID as well. That is what
I am planning on doing for myself. There are shortcomings, however. See
below.

} It would be nice to be able to start smallish and grow as required, but
} my experience of linux raid to date is that it's not possible to resize
} arrays. (I have a 1TB array built from 6 x 250GB SATA discs on Promise
} SATA150 TX4 controllers).
} 
} Can anyone offer recommendations as to the most cost-effective way to
} achieve this sort of storage?
} 
} Are there any limitations I might run into using md on Linux?
} 
} For example, suppose I get something like this [1] and throw in an
} appropriate mobo/processor etc and 24 x 500 GB SATA discs; would md/mdadm
} be able to create a single 11TB RAID5 partition, ie (23-1) x 500, with a
} hot-spare? Would this be a sensible thing to do?
} 
} What about file-system limitations, e.g. would ext3/reiser/XFS support an
} 11TB partition?

AFAIK, all three of those filesystems can handle at least 16 exabytes of
data. I may be wrong, however.

} Would I be better off creating smaller volumes combining them with RAID0?
} 
} I'd appreciate any tips/suggestions/advice/pointers to further sources of
} information.

LVM allows you to add more PVs (physical volumes, a.k.a. disks or
partitions) to a VG (volume group). You can then extend an LV (logical
volume) and the filesystem on it. Basically it is like a growable RAID0. It
is even possible to retire old PVs as long as there is sufficient room on
other PVs to take up the slack. This means that in five years when you can
get a 3TB disk for $300 you'll be able to add them in and replace your old,
outdated 250GB drives.

One advantage of LVM is snapshotting. It allows you to basically keep a
cheap diff backup of your disk. It's a really cool feature, but I'm not
going to go into detail about it here.

The main disadvantage is that while you can have a hot spare as part of a
RAID10 to be automatically used in any RAID1 pair as needed, LVM does not
integrate closely enough with md to allow that. You can have a warm spare
all ready to go, but you would have to actually assign it to the
appropriate md device for it to be used. Your best bet is to do a RAID10 with
however many hot spares on your set of disks and put LVM on top of that.
When you want to expand, add another PV to the LVM. Don't rely on LVM to
make a single device from a group of disks bought at any one time, just to
add new storage.

} Thanks,
} R.
--Greg

