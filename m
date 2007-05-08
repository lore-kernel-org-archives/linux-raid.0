From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Recovery of software RAID5 using FC6 rescue?
Date: Wed, 09 May 2007 00:04:48 +0400
Message-ID: <4640D7E0.9010102@msgid.tls.msk.ru>
References: <Pine.LNX.4.64.0705080821350.16228@p34.internal.lan> <17984.29974.116526.922404@notabene.brown> <7EF2C690-263B-4437-BCE2-42762484CB5B@dartmouth.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7EF2C690-263B-4437-BCE2-42762484CB5B@dartmouth.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Mark A. O'Neil" <mark.a.oneil@Dartmouth.EDU>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark A. O'Neil wrote:
> Hello,
> 
> I hope this is the appropriate forum for this request if not please
> direct me to the correct one.
> 
> I have a system running FC6, 2.6.20-1.2925, software RAID5 and a power
> outage seems to have borked the file structure on the RAID.
> 
> Boot shows the following disks:
>     sda #first disk in raid5: 250GB
>     sdb #the boot disk: 80GB
>     sdc #second disk in raid5: 250GB
>     sdd #third disk in raid5: 250GB
>     sde #fourth disk in raid5: 250GB
>     
> When I boot the system kernel panics with the following info displayed:
> ...
> ata1.00: cd c8/00:08:e6:3e:13/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
> exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> ata1.00: (BMDMA stat 0x25)
> ata1.00: cd c8/00:08:e6:3e:13/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
> EXT3-fs error (device sda3) ext_get_inode_loc: unable to read inode block
>     -inode=8, block=1027
> EXT3-fs: invalid journal inode
> mount: error mounting /dev/root on /sysroot as ext3: invalid argument
> setuproot: moving /dev failed: no such file or directory
> setuproot: error mounting /proc:  no such file or directory
> setuproot: error mounting /sys:  no such file or directory
> switchroot: mount failed: no such file of directory
> Kernel panic - not synching: attempted to kil init!

Wug.

> At which point the system locks as expected.
> 
> Another perhaps not related tidbit is when viewing sda1 using  (I think
> I did not write down the command) mdadm --misc --examine device I see
> (inpart) data describing the device in the array:
> 
> sda1 raid 4, total 4, active 4, working 4
> and then a listing of disks sdc1, sdd1, sde1 all of which show
> 
> viewing the remaining disks in the list shows:
> sdX1 raid 4, total 3, active 3, working 3

You sure it's raid4, not raid5?  Because if it really is raid4, but before
you had a raid5 array, you're screwed, and the only way to recover is to
re-create the array (without losing data), re-writing superblocks (see below).

BTW, --misc can be omited - you only need

  mdadm -E /dev/sda1

> and then a listing of the disks with the first disk being shonw as removed.
> It seems that the other disks do not have a reference to sda1? That in
> itself is perplexing to me but I vaguely recall seeing that before - it
> has been awhile since I set the system up.

Check UUID values on all drives (also from mdadm -E output) - shoule be the
same.  And compare "Events" field in there too.  Maybe you had 4-disk array
before, but later re-created it to be 3-disks?  Another possible cause is the
disk failures resulting in bad superblock reads, but that's highly unlikely.

> Anyway, I think the ext3-fs error is less an issue with the software
> raid and more an issue that fsck could fix. My problem is how to
> non-destructively mount the raid from the rescue disk so that I can run
> fsck on the raid. I do not think mounting and running fsck on the
> individual disks is the correct solution.
> 
> Some straight forward instructions (or a pointer to some) on doing this
> from the rescue prompt would be most useful. I have been searching the
> last couple evenings and have yet to find something I completely
> understand. I have little experience with software raid and mdadm and
> while this is an excellent opportunity to learn a bit (and I am) I would
> like to successfully recover my data in a more timely fashion rather
> than mess it up beyond recovery as the result of a dolt interpretation
> of a man page. The applications and data itself is replaceable - just
> time consuming as in days rather than what I hope, with proper
> instruction, will amount to an evening or two worth of work to mount the
> RAID and run fsck.

Not sure about pointers.  But here are some points.

Figure out which arrays/disks you really had.  The raid level and number
of drives are really important.

Now two "mantras":

  mdadm --assemble /dev/md0 /dev/sda1 /dev/sdc1 /dev/sdd1 /dev/sde1

This will try to bring the array up.  It will either come ok, or will
fail due to event count mismatches (more than 1 difference).

In case you have more than 1 mismatch, you can try adding --force option,
to tell mdadm to ignore mismatches and try the best it can.  The array
wont resync, it will be started from "best" (n-1) drives.

If there's a drive error, you can omit the bad drive from the command
and assemble a degraded array, but before doing so, see which drives
are more fresh (by examining Event counts in mdadm -E output).  If
one of the remaining drives has (much) lower event count than the rest,
while the bad one is (more-or-less) good, you've a good chance to have
bad (unrecoverable) filesystem.  This happens if the lower-events drive
has been kicked off the array (for whatever reason) long before your
last disaster happened, and hence it contains very old data and you've
very few chances to recover it without the bad drive.

And another mantra, which can be helpful if assemble doesn't work for
some reason:

  mdadm --create /dev/md0 --level=5 --num-devices=4 --layout=x --chunk-size=c \
     --assume-clean \
     /dev/sda1 /dev/sdc1 /dev/sdd1 /dev/sde1

This will re-create the superblock, but not touch any data inside.  The
magic word is --assume-clean - to stop md subsystem from starting any
resync, assuming the array is already all ok.

For this to work, you have to have all the parameters correct, including
order of the component devices.  You can collect that information from
your existing superblocks, and you can experiment with different options
till you see something that looks like a filesystem.

Instead of giving all the 4 devices, you can use the literal word "missing"
in place of any of them, like this:

  mdadm --create /dev/md0 --level=5 --num-devices=4 --layout=x --chunk-size=c \
     /dev/sda1 missing /dev/sdd1 /dev/sde1

(no need to specify --assume-clean as there's nothing to resync on a
degraded array).  With the same note: you still have to specify all the
correct parameters (if you didn't specify chunk-size and layout when
initially creating the array, you can omit them here as well, since
mdadm will pick the same defaults).

And finally, when everything looks ok, you can add the missing drive by
using

   mdadm --add /dev/md0 /dev/sdX1

(where sdX1 is the missing drive).  Or, in case of re-creating superblocks
with --create --assume-clean, you probably should start repair on the
array, echo repair > /sys/block/md0/md/sync_action -- but I bet it will
not work this way, ie, such build will not be satisfactory).

And oh, in case you will need to re-create the array (the 2nd "mantra"),
you probably will have to rebuild your initial ramdisk too.  Depending
on the way your initrd built, it may use UUID to find parts of the
array, which will be rewritten.

One additional note.  You may have hard time with ext3fs trying to
forcible replay the journal while experimenting with different
options.  It's sad thing, but if ext3 isn't umounted correctly,
it insists on replaying journal and refuses to work (even fsck)
without that.  But while trying different combinations to find
the best set to work with, writing to the array is a no-no.
To ensure it doesn't happen, you can start the array read-only,
echo 1 > /sys/module/md_mod/parameters/start_ro will help here.
But I'm not sure if ext3fsck will be able to do anything with
a read-only device...

BTW, for such recovery purposes, I use initrd (initramfs really, but
does not matter) with a normal (but tiny) set of commands inside,
thanks to busybox.  So everything can be done without any help from
external "recovery CD".  Very handy at times, especially since all
the network drivers are here on the initramfs too, so I can even
start a netcat server while in initramfs, and perform recovery from
remote system... ;)

Good luck!

/mjt
