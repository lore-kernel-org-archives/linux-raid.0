From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: RAID needs more to survive a power hit, different /boot layout
 for example (was Re: draft howto on making raids for surviving a disk crash)
Date: Sun, 03 Feb 2008 23:28:30 +0300
Message-ID: <47A623EE.4050305@msgid.tls.msk.ru>
References: <47A612BE.5050707@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A612BE.5050707@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
> I've been reading the draft and checking it against my experience.
> Because of local power fluctuations, I've just accidentally checked my
> system:  My system does *not* survive a power hit. This has happened
> twice already today.
> 
> I've got /boot and a few other pieces in a 4-disk RAID 1 (three running,
> one spare). This partition is on /dev/sd[abcd]1.
> 
> I've used grub to install grub on all three running disks:
> 
> grub --no-floppy <<EOF
> root (hd0,1)
> setup (hd0)
> root (hd1,1)
> setup (hd1)
> root (hd2,1)
> setup (hd2)
> EOF
> 
> (To those reading this thread to find out how to recover: According to
> grub's "map" option, /dev/sda1 maps to hd0,1.)

I usually install all the drives identically in this regard -
to be treated as first bios disk (disk 0x80).  As already
pointed out in this thread - not all BIOSes are able to boot
off a second or third disk, so if your first disk (sda) fail
your only option is to put your sdb into place of sda and boot
from it - this way, grub needs to think it's first boot drive
too.

By the way, lilo works here more easily and more reliable.
You just install a standard mbr (lilo has it too) which just
boots from an active partition, and install lilo onto the
raid array, and tell it to NOT do anything fancy with raid
at all (raid-extra-boot none).  But for this to work, you
have to have identical partitions with identical offsets -
at least for the boot partitions.

> After the power hit, I get:
> 
>> Error 16
>> Inconsistent filesystem mounted

But did it actually mount it?

> I then tried to boot up on hda1,1, hdd2,1 -- none of them worked.

Which is in fact expected after the above.  You have 3 identical
copies (thanks to raid) of your boot filesystem, all 3 equally
broken.  When it boots, it assembles your /boot raid array - the
same regardless if you boot off hda, hdb or hdc.

> The culprit, in my opinion, is the reiserfs file system. During the
> power hit, the reiserfs file system of /boot was left in an inconsistent
> state; this meant I had up to three bad copies of /boot.

I've never seen any problem with ext[23] wrt unexpected power loss, so
far.  Running several 100s of different systems, some since 1998, some
since 2000.  Sure there was several inconsistencies, sometimes (maybe
once or twice) some minor data loss (only few newly created files were
lost), but most serious was to find a few items in lost+found after an
fsck - that's ext2, never seen that with ext3.

More, I tried hard to "force" a power failure at "unexpected" time, by
doing massive write operations and cutting power while at it - I was
never able to trigger any problem this way, at all.

In any case, even if ext[23] is somewhat damaged, it can be mounted
still - access to some files may return I/O errors (in the parts
where it's really damaged), but the rest will work.

On the other hand, I had several immediate issues with reiserfs.  It
was long time ago, when the filesystem first has been included into
mainline kernel, so that doesn't reflect current situation.  Yet even
at that stage, reiserfs was declared "stable" by the authors.  Issues
were trivially triggerable by cutting the power at an "unexpected"
time, and fsck didn't help several times.

So I tend to avoid reiserfs - due to my own experience, and due to
numerous problems elsewhere.

> Recommendations:
> 
> 1. I'm going to try adding a data=journal option to the reiserfs file
> systems, including the /boot. If this does not work, then /boot must be
> ext3 in order to survive a power hit.

By the way, if your /boot is separate filesystem (ie, there's nothing
more there), I see absolutely, zero no reason for it to crash.  /boot
is modified VERY rarely (only when installing a kernel), and only when
it's modified there's a chance for it to be damaged somehow.  During
the rest of the time, it's constant, and any power cut should not hurt
it at all.  If even for a non-modified filesystem reiserfs shows such
behavour (

> 2. We discussed what should be on the RAID1 bootable portion of the
> filesystem. True, it's nice to have the ability to boot from just the
> RAID1 portion. But if that RAID1 portion can't survive a power hit,
> there's little sense. It might make a lot more sense to put /boot on its
> own tiny partition.

Hehe.

/boot doesn't matter really.  Separate /boot were used for 3 purposes:

1) to work around bios 1024th cylinder issues (long gone with LBA)
2) to be able to put the rest of the system onto an unsupported-by-
 bootloader filesystem/raid/lvm/etc.  Like, lilo didn't support
 reiserfs (and still doesn't with tail packing enabled), so if you
 want to use reiserfs for your root fs, put /boot into a separate
 ext2fs.  The same is true for raid - you can put the rest of the
 system into a raid5 array (unsupported by grub/lilo), and in order
 to boot, create small raid1 (or any other supported level) /boot.
3) to keep it as less volatile as possible. Like, an area of the
 disk which never changes (except of a few very rare cases).  For
 example, if the first sector of a disk fails, it will be unbootable, --
 so the less writes we do to that sector, the better.  This was mostly
 before sector relocation were standard.

Currently, points 1 and 3 are mostly moot.  2 stands still, but it
does not prevent us from "joining" /boot and / together, for easier
repair if one's needed.

Speaking of repairs.  As I already mentioned, I always use small
(256M..1G) raid1 array for my root partition, including /boot,
/bin, /etc, /sbin, /lib and so on (/usr, /home, /var are on
their own filesystems).  And I had the following scenarios
happened already:

a) raid does not start (either operator error (most of the
  cases) or disk failure (mdadm were unable to read superblocks).
  This works by booting off of any component device (passing
  root=/dev/hda1 to the bootloader).

  Sadly, many initrd/initramfs things in use to day - I'd say all
  but mine - don't let to pass additional arguments (or, rather,
  don't recognize those arguments properly).  For example, early
  redhat stuff was using hardcoded root= argument and didn't parse
  the corresponding root= kernel parameter - so it was not possible
  to change root to mount.  No of current initramfs builders as I'm
  aware of allows to pass raid options on the kernel command line -
  for example, instead of hardcoded md1=$GUUID_OF_THE_ARRAY, I
  sometimes pass md1=/dev/sda1,/dev/sdc1 (omitting failed sdb),
  and my initrd builds that instead of hardcoded... very handy
  (but it's best to not encounter such situation where it might
  be handy ;)

b) damaged filesystem.  As I mentioned above, it happened once
  or twice during all those years.  Here, boot off any component
  device (don't build raid), readonly.  And I've all the tools
  to check the root (and other) filesystem here - by examining
  and even *modifying* (trying fsck for real) the other component(s)
  of the raid1.  At this stage I know it's easy to screw things up
  because once I modify only a component of raid1, and next assemble
  the array, I'll be reading random data - one read from modified
  component, one read from original component etc.  So this situation
  needs extreme care, -- as is dealing with unbootable system where
  the root filesystem is seriously damaged.

  So basically, if I've 2-component raid1 for root, I can mount a
  (damaged) first component and try to repair the second using fsck
  and see if something will work from there.  And if I were really
  able to fix the 2nd component, I assemble the raid again - by
  rebooting and specifying md1=/dev/sdB1 (only the 2nd component
  which I just fsck'ed and fixed) - and resyncing sda1 later...
  And so on... ;)

That's basically 2 cases covering everything.

/mjt
