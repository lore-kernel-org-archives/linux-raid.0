From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Shrinking a RAID1 device mounted as root?
Date: Wed, 14 Jul 2004 12:44:55 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407141644.i6EGit317836@watkins-home.com>
References: <66EEBBD3485BB84C90CFA900A0A96E55013BEC82@sumail03.studentuniverse.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66EEBBD3485BB84C90CFA900A0A96E55013BEC82@sumail03.studentuniverse.com>
To: "'Marlier, Ian'" <marlieri@studentuniverse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The superblock is at the end of the partition.  If the size is different, md
will not find the superblock.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Marlier, Ian
Sent: Wednesday, July 14, 2004 11:48 AM
To: linux-raid@vger.kernel.org
Subject: Shrinking a RAID1 device mounted as root?

Hey all...

I'm looking for some help figuring out how to shrink a RAID1 device
that's mounted as root on a Red Hat system.

The device setup is this:
Raiddev	/dev/md0
	Device	/dev/hda1
	Raid-disk	0
	Device	/dev/hdb1
	Raid-disk	1

Hda and hdb are both 36GB ATA hard drives, and each currently has a
partition of about 33GB formatted as Linux RAID autodetect.  Each also
has a swap partition.

What I'd like to do is shrink partition 1 on each disk to around 16GB,
and then create a second RAID1, /dev/md1, with a new partition /dev/hda3
and /dev/hdb3 (leaving the swap device alone.)

I booted off a rescue disk with mdadm, resize2fs, fdisk, etc, and I was
able to shrink /dev/md0 down to 16GB.

I then tried to delete /dev/hda1 and /dev/hdb1 using fdisk, and create 2
new equally-sized partitions in the free space created.  (/dev/hda1,
/dev/hda3, /dev/hdb1, /dev/hdb3, all type Linux RAID Autodetect).
Because /dev/hd[ab]1 is larger than /dev/md0, and the starting block of
the partitions is the same, the filesystem should remain intact.

However, upon rebooting, I ran into a problem.  /dev/md0 cannot be
mounted because of a problem with the superblocks.

I figure that something needs to be done with mdadm to get it to
recognize the "new" /dev/hda1 and /dev/hdb1 as /dev/md0 -- but I don't
want to do a mdadm --create because that will overwrite the filesystem
already on the disks (I think?). 

Is this something that mdadm --assemble can do?  If so, what switches
need to be fed to the command?

Other suggestions?



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

