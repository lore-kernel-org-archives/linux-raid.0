From: "Gunny Smith" <gunny74@gmail.com>
Subject: RAID & ext dire straits
Date: Mon, 5 Mar 2007 14:38:51 +1100
Message-ID: <905a9b190703041938t14d948f0q6a68ea21ef60ec0@mail.gmail.com>
References: <905a9b190703041929jbf71e6bk1097abfe40775a98@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905a9b190703041929jbf71e6bk1097abfe40775a98@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all.

I've run into some dire straits (punishment for not using one's brains
when called for) and would appreciate any help.

I formerly had a gentoo box with a 4x250GB software RAID5, no LVM,
ext3 filesystem, using disks sdc,sdd,sde and sdf. sda and sdb were the
OS disks.
I was to move the RAID over to a new machine running debian. Further
to this, my backup of the data turned out to be only partial.

The new disks in the system appeared as sda, sdb, sdc and sdd.

I've then done a series of damaging things with them:

1. I've added 3 of them as spares rather than as drives with existing data.
2. When trying to assemble the array, this started rebuilding
(effectively, wiping) the fourth disk. I did this several times (and I
suspect I've clobbered data on more than one drive) before realizing I
can sidestep this by assembling three drives at a time - which raises
the array as degraded and doesn't kick off anything that can be
destructive.
3. I've run --create
4. I've cleared the persistent superblocks off the drives and
attempted to recreate them.

Roughly at this point I decided this was unsalvageable and went to the
backup, only to find out it failed to back up parts of the data. A
memorable moment in my life.

I've then blocked together a bunch of other harddrives to assemble a
~800GB volume, plonked an LVM on it, shared it as nfs, and made "dd
if=/dev/sdX ..." copies in files of all raw RAID drives over LAN. At
least I have a snapshot of things as they are right now before I start
"fixing" things again.

I attempted assembling a, b and c (d is the one I suspect is most
damaged) - Raid5 degraded with 1 drive missing, and asking mke2fs
where superblocks should lie.
Half of these locations have superblocks fsck is willing to go on. The
other doesn't. I just ran fsck -y on the md device, it's been "fixing"
things for 6 hours now and I suspect whatever is left afterwards will
not be of much use. I think the RAID mechanism is getting the stripes
wrong, resulting in a total mish-mash of filesystem internals for
e2fsck.

I can attempt doing that with all the valid superblocks I found (about
8) and I can attempt assembling other combinations of the four
physical drives. My most serious concern is a lot of photos that lived
on this box, so mild filesystem corruption that will affect some
percent of the small files would be more than tolerable.

My questions:
1. Short of seeing a specialist shop, is there any recommended course
of action to restore data off the array data? (technical suggestions
more than welcome, recommendations for sanely-priced commercial
software are also welcome)
My current plan is to try and salvage some stuff attempting fsck using
the various valid superblocks, copy off any files that look half-sane,
then trying again with a different subset of the four drives. This is
very time-consuming (a restoration of the 3 drives is ~10hrs over Gig
ethernet) but seems the first thing to try.

2. Is there some minimally-destructive and readily available way to
pool all four drives together and rather than reconstruct one entire
drive from the data on the other thre, attempt reconstructing every
stripe separately (based on the assumption drive X can help
reconstruct a stripe where drive Y got clobbered and vice versa)?

3. If you think I should be flogged for not verifying the backup is
AOK before diving in, kindly take a number and stand in line. I shall
be distributing low-differential SCSI cables for flogging shortly.

Thank you!
