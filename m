From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: Re: does ext3 trample on mkraid superblocks and visa-versa?
Date: Wed, 10 Sep 2003 15:02:07 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0309101442180.1812@twinlark.arctic.org>
References: <107a01c376fe$a29bdc00$9100000a@intgrp.com>
 <03dd01c377d1$a28c9be0$9100000a@intgrp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <03dd01c377d1$a28c9be0$9100000a@intgrp.com>
To: Eric Wood <eric@interplas.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

you most certainly need to resize any filesystem if you want to convert a
partition in-place into a raid1 component, doesn't matter what filesystem
type it is.

i've done this process using mdadm... i find it much easier to deal with
than the old raidtools especially when creating a "degraded" array (which
is exactly what you want to do after you've shrunk the filesystem).

the "easiest" way to do this is probably as follows (from a bootable
rescue CD, i don't think you want to attempt this live):

- resize2fs the filesystem (via the /dev/hdaN or whatever partition
  device) to be 1MB smaller (be careful to use the right
  "blocks" here -- resize2fs blocks are the same size as the filesystem
  blocks, so most likely 4096 bytes, but could be 1024 bytes in some
  cases... tune2fs -l is your friend.)

- mdadm to create a raid1 with the /dev/hdaN partition and "missing" for
  the mirror device... this way the raid is created degraded

- resize2fs the filesystem again, this time via the /dev/mdX device so
  that it grows out to the actual size alloted by md.  you shouldn't need
  to specify the size this time, resize2fs will assume you want to grow
  to the size of /dev/mdX.

- bring up a new disk with the same partition table as the original (this
  is easiest done with dd to copy the first 512 bytes which contains the
  boot sector and partition table -- but you'll need to figure out how to
  get the ioctl() to occur so the kernel re-reads the new partition
  table... i use fdisk after dd to force this reread, a reboot is
  another option).

- mdadm to add a mirror device so that reconstruction can start.

- update your partition tables to type 0xfd, update your fstab, lilo.conf
  whatever else.

WARNING!  it's real easy to screw up your data if you don't know what
you're doing :)  i'm being deliberately vague in my description above
because it really does require a lot of care and understanding, and i'd
rather folks read the man pages and understand what they're doing than
cut-and-paste from some email from me.

i'm pretty sure 1MB is always enough to fit the raid1 superblock... in my
experience it always seems to chop between 64 and 127 512-byte sectors
from the partition.

-dean


On Wed, 10 Sep 2003, Eric Wood wrote:

> I wanted to reword my previous email a little different to hopefully get a
> response on this issue.
>
> If I want to mirror an existing ext3 filesystem, then I would
> "mkraid --really-force /dev/md0".  Then /dev/hda1 would copy over to
> /dev/hdc1 because /dev/hda1 is raid-disk 0  and /dev/hdc1 is raid-disk 1.
> If I had cross up this priority number in the raidtab file, then mkraid
> would have copied /dev/hdc1 over top of /dev/hda1 which would be a boo-boo.
>
> Now as I understand it, mkraid adds a superblock at the far-end block of the
> partition (whether or not that block is within the filesystem.  It looks
> like ext2 needs to be, but does ext3 need to be fsck'd and resized to
> protect this block?  Or does ext3 automatically see a raid superblock there
> and help protect it without fck'ing and resizing.  Or do you have to
> tune2fs -o ^nojournal the filesystem back into an ext2 system because ext3,
> journal block, mkraid, and raid superblocks step on each other's toes?
>
> -Eric Wood
>
> Eric Wood wrote:
> > http://unthought.net/Software-RAID.HOWTO/Software-RAID.HOWTO-4.html#ss4.14
> > 4. Sect. 4.14.14.  Do I first have to convert from ext3 back to ext2?
> > Since I use ext3 does this step still apply or does mkraid add the
> > second superblock in an acceptable manor for ext3?  Do I still have
> > to resize2fs the md devices?
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
