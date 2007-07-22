From: "Indan Zupancic" <indan@nul.nu>
Subject: Re: [RFH] Partition table recovery
Date: Sun, 22 Jul 2007 23:23:24 +0200 (CEST)
Message-ID: <54649.81.207.0.53.1185139404.squirrel@secure.samage.net>
References: <200707200813.03553.a1426z@gawab.com>
    <46A24846.7050803@gmail.com> <20070722011141.GJ26752@thunk.org>
    <200707220710.31402.a1426z@gawab.com>
    <20070722162802.GA20174@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764928AbXGVVXm@vger.kernel.org>
In-Reply-To: <20070722162802.GA20174@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Sun, July 22, 2007 18:28, Theodore Tso wrote:
> On Sun, Jul 22, 2007 at 07:10:31AM +0300, Al Boldi wrote:
>> Sounds great, but it may be advisable to hook this into the partition
>> modification routines instead of mkfs/fsck.  Which would mean that the
>> partition manager could ask the kernel to instruct its fs subsystem to
>> update the backup partition table for each known fs-type that supports such
>> a feature.
>
> Well, let's think about this a bit.  What are the requirements?
>
> 1) The partition manager should be able explicitly request that a new
> backup of the partition tables be stashed in each filesystem that has
> room for such a backup.  That way, when the user affirmatively makes a
> partition table change, it can get backed up in all of the right
> places automatically.
>
> 2) The fsck program should *only* stash a backup of the partition
> table if there currently isn't one in the filesystem.  It may be that
> the partition table has been corrupted, and so merely doing an fsck
> should not transfer a current copy of the partition table to the
> filesystem-secpfic backup area.  It could be that the partition table
> was only partially recovered, and we don't want to overwrite the
> previously existing backups except on an explicit request from the
> system administrator.
>
> 3) The mkfs program should automatically create a backup of the
> current partition table layout.  That way we get a backup in the newly
> created filesystem as soon as it is created.
>
> 4) The exact location of the backup may vary from filesystem to
> filesystem.  For ext2/3/4, bytes 512-1023 are always unused, and don't
> interfere with the boot sector at bytes 0-511, so that's the obvious
> location.  Other filesystems may have that location in use, and some
> other location might be a better place to store it.  Ideally it will
> be a well-known location, that isn't dependent on finding an inode
> table, or some such, but that may not be possible for all filesystems.

To be on the safe side, maybe also add a checksum, timestamp and
something identifying the disk the filesystem was created on.

Regards,

Indan
