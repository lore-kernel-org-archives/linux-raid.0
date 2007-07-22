From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFH] Partition table recovery
Date: Sun, 22 Jul 2007 12:28:02 -0400
Message-ID: <20070722162802.GA20174@thunk.org>
References: <200707200813.03553.a1426z@gawab.com> <46A24846.7050803@gmail.com> <20070722011141.GJ26752@thunk.org> <200707220710.31402.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200707220710.31402.a1426z@gawab.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jul 22, 2007 at 07:10:31AM +0300, Al Boldi wrote:
> Sounds great, but it may be advisable to hook this into the partition 
> modification routines instead of mkfs/fsck.  Which would mean that the 
> partition manager could ask the kernel to instruct its fs subsystem to 
> update the backup partition table for each known fs-type that supports such 
> a feature.

Well, let's think about this a bit.  What are the requirements?

1) The partition manager should be able explicitly request that a new
backup of the partition tables be stashed in each filesystem that has
room for such a backup.  That way, when the user affirmatively makes a
partition table change, it can get backed up in all of the right
places automatically.

2) The fsck program should *only* stash a backup of the partition
table if there currently isn't one in the filesystem.  It may be that
the partition table has been corrupted, and so merely doing an fsck
should not transfer a current copy of the partition table to the
filesystem-secpfic backup area.  It could be that the partition table
was only partially recovered, and we don't want to overwrite the
previously existing backups except on an explicit request from the
system administrator.

3) The mkfs program should automatically create a backup of the
current partition table layout.  That way we get a backup in the newly
created filesystem as soon as it is created.

4) The exact location of the backup may vary from filesystem to
filesystem.  For ext2/3/4, bytes 512-1023 are always unused, and don't
interfere with the boot sector at bytes 0-511, so that's the obvious
location.  Other filesystems may have that location in use, and some
other location might be a better place to store it.  Ideally it will
be a well-known location, that isn't dependent on finding an inode
table, or some such, but that may not be possible for all filesystems.

OK, so how about this as a solution that meets the above requirements?

/sbin/partbackup <device> [<fspart>]

	Will scan <device> (i.e., /dev/hda, /dev/sdb, etc.) and create
	a 512 byte partition backup, using the format I've previously
	described.  If <fspart> is specified on the command line, it
	will use the blkid library to determine the filesystem type of
	<fspart>, and then attempt to execute
	/dev/partbackupfs.<fstype> to write the partition backup to
	<fspart>.  If <fspart> is '-', then it will write the 512 byte
	partition table to stdout.  If <fspart> is not specified on
	the command line, /sbin/partbackup will iterate over all
	partitions in <device>, use the blkid library to attempt to
	determine the correct filesystem type, and then execute 
	/sbin/partbackupfs.<fstype> if such a backup program exists.

/sbin/partbackupfs.<fstype> <fspart>

	... is a filesystem specific program for filesystem type
	<fstype>.  It will assure that <fspart> (i.e., /dev/hda1,
	/dev/sdb3) is of an appropriate filesystem type, and then read
	512 bytes from stdin and write it out to <fspart> to an
	appropriate place for that filesystem.

Partition managers will be encouraged to check to see if
/sbin/partbackup exists, and if so, after the partition table is
written, will check to see if /sbin/partbackup exists, and if so, to
call it with just one argument (i.e., /sbin/partbackup /dev/hdb).
They SHOULD provide an option for the user to suppress the backup from
happening, but the backup should be the default behavior.

An /etc/mkfs.<fstype> program is encouraged to run /sbin/partbackup
with two arguments (i.e., /sbin/partbackup /dev/hdb /dev/hdb3) when
creating a filesystem.

An /etc/fsck.<fstype> program is encouraged to check to see if a
partition backup exists (assuming the filesystem supports it), and if
not, call /sbin/partbackup with two arguments.

A filesystem utility package for a particular filesystem type is
encouraged to make the above changes to its mkfs and fsck programs, as
well as provide an /sbin/partbackupfs.<fstype> program.

I would do this all in userspace, though.  Is there any reason to get
the kernel involved?  I don't think so.

						- Ted
