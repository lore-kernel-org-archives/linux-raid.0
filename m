From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Linux software-RAID and bootloader
Date: Fri, 7 Mar 2014 18:58:37 +0000
Message-ID: <21274.5853.421683.526973@tree.ty.sabi.co.uk>
References: <CAJx5YvGGM7yziWQEefs=_Wte4jy13w1x1oG6MuUOggSgTfodMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJx5YvGGM7yziWQEefs=_Wte4jy13w1x1oG6MuUOggSgTfodMQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]
> how is it ensured that superblock(for example version 1.2) can
> be created at 4KiB from the beginning of the drive?

By paying a huge salary :-) to a system administrator? 

> I mean isn't there a hazard that this area on the disk is
> already occupied for example by the bootloader stage 1.5?

MD RAID set members are *block devices* not necessarily "disks",
and what is put in that block device will be whatever has been
planned by the system administrator; in general system
administrators don't just store superblocks around onto some
block device and hope they don't overwrite something, they
design the storage system structure ahead of time so that it all
fits together.

> ..then how should one ensure that for example MBR/GPT is
> mirrored or bootloader data is mirrored which both are located
> out of partition boundaries?

Perhaps the highly paid :-) system administrator ensures that?
Maybe by using 'sfdisk -d ... | sfdisk' or equivalent and
running GRUB or LILO multiple times for multiple targets?

The questions above may be based on the assumption that MD RAID
is a high level automatic storage management solution for end
users, where instead it is (and should remain) a low level
building block.
