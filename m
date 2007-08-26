From: Abe Skolnik <abe_skolnik@yahoo.com>
Subject: Patch for boot-time assembly of v1.x-metadata-based soft (MD) arrays: reasoning and future plans
Date: Sun, 26 Aug 2007 13:38:00 -0700 (PDT)
Message-ID: <778663.11466.qm@web33606.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Mr./Dr. Williams,

> Because you can rely on the configuration file to be certain about
> which disks to pull in and which to ignore.  Without the config file
> the auto-detect routine may not always do the right thing because it
> will need to make assumptions.

But kernel parameters can provide the same data, no?  After all, it is
not the "file nature" of the "config file" that we are after,
but rather the configuration data itself.  My now-working setup uses a
line in my "grub.conf" (AKA "menu.lst") file in my boot partition that
says something like...
  "root=3D/dev/md0 md=3D0,v1,/dev/sda1,/dev/sdb1,/dev/sdc1".
This works just fine, and will not go bad unless a drive fails or I
rearrange the SCSI bus.  Even in a case like that, the worst that will
happen (AFAIK) is that my root-RAID will not come up and I will have to
boot the PC from e.g. Knoppix in order to fix the problem
(that, and maybe also replace a broken drive or re-plug a loose power
connector or whatever).  Another MD should not be corrupted, since they
are (supposedly) protected from that by supposedly-unique array UUIDs.

> So I turn the question around, why go through the exercise of trying
> to improve an auto-detect routine which can never be perfect when the
> explicit configuration can be specified by a config file?

I will turn your turning of my question back around at you; I hope it's
not rude to do so.  Why make root-RAID (based on MD, not hardware RAID)
require an initrd/initramfs, especially since (a) that's another system
component to manage, (b) that's another thing that can go wrong,
(c) many systems (the new one I just finished building included) do not
need an initrd/initramfs for any other reason, so why "trigger" the
need just out of laziness of maintaining some boot code?  Especially
since a patch has already been written and tested as working. ;-)

> I believe the real issue is the need to improve the distributions'
> initramfs build-scripts and relieve the hassle of handling MD
details.

I believe that the mission of the Linux kernel is two-fold: first of
all, to do the obvious stuff like providing hardware drivers and
otherwise providing userland something to stand on.  The second,
less-obvious mission is _choice_: not just a choice between using Free
software and proprietary software, but more; after all, even if Linux
had never been "born", we would still have the BSDs and all the
non-Unix-based Free OSes.  However, I _choose_ to use GNU/Linux,
because (to date) it has the design I like the best out of [GNU/Linux,
=46reeBSD, NetBSD, OpenBSD].  The fact that Linux (like Perl) provides
More Than One Way To Do It is a Good Thing, not a bad one.

I acknowledge that the present way of starting up an MD without an
init[rd/ramfs] is somewhat hackish; I don't like the requirement for
md=3D...,/dev/sda,... at all.  I prefer the way older Linux kernels
worked on PCDOS-formatted disks with the 0xFD partition type -
pure autodetect.  Nonetheless, I recognize the potential for problems
that would exist with reviving that old technique, as Neil Brown has
outlined on his blog.  The main source of trouble in the old strategy,
I think, is the na=EFve use of MD device names (e.g. "md0").  I really
do think that the kernel should have the ability to probe for MD
components on its own, so that, for example, [sda,sdb,sdc] becoming
[sdb,sdc,sdd] due to the addition of a new drive which (either through
unfortunate happenstance or some intentional reason) became "sda",
thus "pushing" all the other SCSI drives "down" in the letter sequence.
 The rational solution to this, I think, is one that is based on the
array's UUID.  After all, the objective is to bring up an array at boot
time for the purpose of being able to boot, not to have specific
devices activated as components.  I should be able to specify e.g.
"root=3D/dev/md0 md0=3D01234567:12345678:23456789:34567890" in my GRUB
configuration, and let the kernel do the work from that point on.
That way, even a change of a component from being stored on a partition
on a SCSI drive to being stored on a partition on an IDE or SATA drive
is totally tolerable, with no need to change the configuration data!

I have a plan in mind for future improvements, in case my patch
(or something like it) is accepted.  Here is what I have in mind...

* First of all, remove the spurious "bad raid superblock" messages for
  the cases (like the one I have now) that produces lots of "noise"
  even though it works (with nicer messages later on in the boot).

* Second, remove the need to manually specify the format version of
  the metadata.  This should be _correctly_ auto-detected on a
  per-array and per-component basis.

* Implement the kernel parameters "md0", "md1", ... using a format of
  e.g. "md0=3D01234567:12345678:23456789:34567890".

* If someone would ask me nicely, I would also do the same for
  partitionable MDs.  I'm not using them, so I don't need that
  functionality for myself.

* Once the preceding has been done, use the UUIDs to scan for array
  components at boot-time w/o needing an init[rd/ramfs], like so:
  * First, scan all partitions that are marked as "Linux MD",
    whether via the traditional PCDOS-style 0xFD code or some other
    marking strategy (I would like to add this ability to Linux on
Apple
    Partition Map disks, which use strings instead of numbers for type
    information; maybe "Linux software RAID" would be a good ID string)
  * Then, if and _only if_ not all components of all requested-by-UUID
    arrays have been found, search the remaining partitions for valid
    MD components of the requested array(s) and use them if found.

I think that this is a pretty good plan for future improvements.
Your comments and questions, of course, are welcome.  (Not just those
of Mr./Dr. Williams.)

Sincerely,

Abe

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
