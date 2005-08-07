From: Trevor Cordes <trevor@tecnopolis.ca>
Subject: SOLVED: forcing boot ordering of multilevel RAID arrays
Date: Sun, 7 Aug 2005 16:08:35 -0500 (CDT)
Message-ID: <200508072108.j77L8ZPt019570@pog.tecnopolis.ca>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

How to have raid-based subcomponents autorun before a superset raid array
(ie: RAID6+0 or RAID1+0/RAID10) in a multilevel/multilayer array setup:

(It would be nice if the autodetect during boot would be intelligent
about starting subarrays first, but it currently is not.  It would not
be that hard to code smart autodetection, or even easier (for the
programmers), read some kernel command line parameters that allows the
user to specify a manual start order.  But for now, here's the way to
fudge it.)

Any array that is a superset of other arrays (a multilevel array) must
set to non-autodetect.  Use fdisk to change the parition type to 83
(standard linux), NOT "fd" (linux raid autodetect).  That stops the
kernel autodetect boot process on that array.  Then, for Fedora Core
(FC3 tested) add that array manually to /etc/mdadm.conf:

#cat /etc/mdadm.conf
DEVICE partitions
ARRAY /dev/md5 UUID=9b3c3ca9:9637ed8a:4da282fe:63e5a3ab
MAILADDR my@email.foo

(Get the UUID for the array with mdadm -D /dev/md5.)

Then because of the mdadm call in /etc/rc.d/rc.sysinit (in FC at least),
the higher-order array will get run automatically during the boot
process but (hopefully) after the kernel autodetect (of the lower-order
arrays) is done.  This is tested working fine on FC3 at the following
level:

initscripts-7.93.7-1
kernel-2.6.12-1.1372_FC3

If your distro doesn't have a line in /etc/rc.d/rc.sysinit that calls
"mdadm -As", then figure a way to add it to the boot process scripts
early enough that it comes up just after RAID autodetection.  If you
aren't running any boot daemons off that array, it would probably be ok
to start the array really late in the boot process like in rc.local.

Note, the log output shows some interleaving of these commands so
perhaps there may be a race condition and rc.sysinit may have to be
modified to enforce a wait for the kernel autodetect to finish.  So
far this hasn't happened to me yet.

(PS: Thanks guys for all your input.)

