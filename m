From: NeilBrown <neilb@suse.de>
Subject: Nasty md/raid bug in 3.2.{14,15,16} and 3.3.{1,2,3}
Date: Sun, 17 Jun 2012 17:46:09 +1000
Message-ID: <20120617174609.7a9eb973@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/sRtwT=AQ+zyXg0+Tg0OYzE7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/sRtwT=AQ+zyXg0+Tg0OYzE7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


The following is a copy of http://neil.brown.name/blog/20120615073245
which I posted a link to under a less obvious subject, so I'm posting
it again complete with a better subject to maximise the number of people
who will see it.

NeilBrown


A Nasty md/raid bug
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D


There is a rather nasty RAID bug in some released versions of the
Linux kernel.  It won't destroy your data, but it could make it hard
to access that data.

If you are concerned that this might affect you, the first thing you
should do (after not panicking) is to gather the output of

   mdadm -Evvvvs

and save this somewhere that is not on a RAID array.  The second thing
to do is read to the end of this note and then proceed accordingly.
You most likely will never need use the output of that command, but if you
do it could be extremely helpful.

Who is vulnerable
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The bug was introduced by

    commit c744a65c1e2d59acc54333ce8
        md: don't set md arrays to readonly on shutdown.

and fixed by

    commit 30b8aa9172dfeaac6d77897c67ee9f9fc574cdbb
        md: fix possible corruption of array metadata on shutdown.

These entered the upstream kernel for v3.4-rc1 and v3.4-rc5
respectively, so no main-line released kernel is vulnerable.

However the first patch was tagged "Cc: stable@vger.kernel.org" as it
fixed a bug, and so it was added to some stable releases.

For v3.3.y the bug was introduced by commit ed1b69c5592d1 in v3.3.1
and fixed by commit ff459d1ea87ea7 in v3.3.4, so v3.3.1, v3.3,2, and
v3.3.3 are vulnerable.

For v3.2.y the bug was introduced by commit 6bd620a44f7fd in v3.2.14
and fixed by commit 31097a1c490c in v3.2.17 so v3.2.14,
v3.2.15. v3.2.16 are all vulnerable.

The bug was not backported to any other kernel.org kernels. so only
those 6 are vulnerable.  Some distributors may have picked up the
patch applied it to their own kernel so it is possible that other
kernels are vulnerable too.

e.g SLES11-SP2 introduced the bug in 3.0.26-0.7 and fixed it in
3.0.31-0.9.

Ubuntu-precise introduced the bug in Ubuntu-3.2.0-22.35
and fixed the bug in Ubuntu-3.2.0-24.38


What does it do
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The bug only fires when you shutdown/poweroff/reboot the machine.
While the machine remains up the bug is completely inactive.  So you
will only notice the bug when you boot up again.

The effect of the bug is to erase important information from the
metadata that is stored on the disk drives.  In particular the level,
chunksize, number of devices, data_offset and role of each device in
the array are erased ... and probably some other information too.
This means that if you know those details you can recover your data,
but if you don't, it will be harder.  Hence the "mdadm -E" command
suggested earlier.

The bug will only fire if, while the machine is shutting down, and
array is partially assembled but not yet started.  If the array is
started and running it is safe ... as long as it stays that way.

The typical way that an array can get into this "partially assembled
by not started" start is for "mdadm --incremental" to have been run on
some, but not all, of the devices in the array.  If it had been run on
all it would have started the array, but until then it is assembled
but not started and this is the dangerous situation.

Another way it can happen is if you use "mdadm -A" to assemble the
array and explicitly list some, but not all, of the devices that make up
the array.  This also will assemble the array and not start it.

It is very unlikely that an array will be in this start at shutdown,
though certainly not impossible, so it seems unlikely that the bug
will affect many people.  But it has affected some.

Most of the people who have reported problems have been running
Ubuntu.  This might just be because Ubuntu happened to make a release
with a vulnerable kernel and no other distro did, or it might be that
Ubuntu does something during shutdown that makes triggering the bug
more likely.

For example, if Ubuntu stop arrays as part of shutdown (which is a
good idea) and if it has udev scripts which automatically pass changed
devices to "mdadm --incremental" in case they are part of an array
(which is also a good idea, and I think they do), and further if
something causes udev to think that the devices that were part of the
array had changed - which seems unlikely but is not completely
impossible, then arrays could get partially re-assembled late in the
shutdown sequence, which could trigger exactly the bug we see.

Note that I don't know that Ubuntu does this, and I'd be surprised if
they did, and there is probably some other explanation.  But I like
try to think of all possibilities to try to understand things.

What should I do to avoid being bitten by the bug
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

If you are running a newer kernel that those identified above which
contain the fix (3.4, 3.3.4, or 3.2.17) then you are not vulnerable
and there is nothing else that you need to do.

If you are running a kernel that was compiled before March 2012 (when
the bug was created), then you aren't vulnerable, and as long as you
don't upgraded to a vulnerable kernel you will continue to be safe.

If you are running a vendor kernel compiled since 19th Match 2012 but
with a version earlier than those listed above as containing the fix,
then I cannot tell you if you are vulnerable or not.  You might need
to check with your vendor.

If you decide to upgrade your kernel, you should do so carefully.
Remember that the bug triggers on shutdown/reboot so you aren't safe
until the new kernel is running.

To be completely safe you must ensure that no arrays are partially
assembled at the moment that the shutdown process in the kernel looks
at md array.  To do this you can

  mv /sbin/mdadm /sbin/mdadm.moved
  /sbin/mdadm.moved --stop --scan

Any array that is partially assembled (and any other array that is not
in use) will be stopped.  As "/sbin/mdadm" will not exist, no array
can be partially - or fully - assembled.

Doing this may cause the shutdown process to complain if it cannot
find mdadm to stop arrays itself, but this should not be a problem.

The boot process in the new kernel might also complain as it won't be
able to find /sbin/mdadm either.  You might have to boot into a rescue
mode and

   mv /sbin/mdadm.moved /sbin/mdadm

back into place.  Then boot again.

Also this fiddling with moving mdadm might be completely unnecessary.
Or it might not.   I cannot be sure.  What I can be sure of is that
doing it this way is safest.

Once you are running a non-vulnerable kernel, you are safe and cannot
be bitten - by this bug at least.

What should I do if I have already been bitten
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

You will know that you have been bitten if some array or arrays don't
seem to work and all the devices appear to be spares, and if you then
use "mdadm --examine" to look at the devices and find that the RAID
level is "-unknown-".  At this point you might want to send mail to
linux-raid@vger.kernel.org and ask for help.  Or you might be able to
work your way through the following and fix it by yourself.

The way to fix an array that has been affected by the bug is to
"Create" the array again with mdadm.  Only the metadata has been
destroyed and "mdadm --create" only writes new metadata so this is a
simple and effective fix and makes all data available again.
Constructing the correct "mdadm --create" command might be tricky.
If you have recent "mdadm --examine" output, then that will be a big
help.  If not, you can probably get some of the required information
from somewhere.  Maybe from your memory, maybe from kernel logs, maybe
from guessing and seeing if it works.

First you need to know the metadata version that was in use.  This is
one piece of information that is *not* destroyed so "mdadm --examine"
of one of the devices will give it to you.  It might be 0.90 for older
arrays, or 1.2 for newer arrays, or possibly 1.0 or 1.1 if they were
chosen when the array was originally created.

Next you need to know the number of devices, RAID level, layout, and
chunk size.  Some of these you might simply know (Maybe you know it is a
5-device RAID6 array) or can determine by examining kernel logs or
asking a colleague.  Others you can probably assume were the default
if you don't know otherwise.  People rarely set a non-default layout
for RAID5 or RAID6, though they do for RAID10.  If you have 0.90
metadata, you probably have 64K chunks while if you have 1.2 you
probably have 512K chunks so if you don't have any reason to think
otherwise, this is a good place to start.

It is entirely possible that there is one device that was in the
array in the recent past, but wasn't in the array at the moment when
it was corrupted.  If this happens, then that device is a good source
for some of this information.

Then you need to know the order of devices, and whether the array was
degraded, in which case some devices will have to be specified as
"missing".  As devices can change order when there are failures and
spares are added, you cannot be sure that the obvious order is the
correct order.  e.g it might be sda1, sda2, sda3, and sda4, but it
could be sd1, sda2, sda4, sda3.  For RAID1, this doesn't matter of
course.  For RAID4,6,10 it is very important.  Your kernel logs might
have this information in a "RAID conf printout", so it is worth
checking.  Remember however that device names can change after a
reboot so prepare to be flexible.

If you have a recent output of "cat /proc/mdstat" that might be
useful, but be careful.  The number is brackets "sda1[3]" are not
always the position of the device in the array.  For 0.90 metadata
they are but for 1.x, they show the order in which devices were
added to the array.  When a spare is changed to being an active member of
the array, this number does not change.  So it might be an indicator,
but it is definitely not a promise.

Finally you need to know the "Data Offset" of each device.  This only
applies to 1.1 and 1.2 metadata.  Different versions of mdadm use
different values for the default Data Offset, so it is best to try to
recreate the array using the same version of mdadm as was used to
create the array.

Worse - if you created the array with an older version of mdadm, then
added a spare with a newer version then it is possible that different
devices have different data offsets.  If that seems to be the case it
would be best to ask for help on linux-raid@vger.kernel.org as you'll
need a special non-released version of mdadm to fix things up.

Once you have assembled all this information you can try creating the
array.  Note that you don't need information about whether there was a
write-intent bitmap or not.  Just assume there wasn't and don't try
adding one.  Once you have the data back you can always add a bitmap
later.

When you create the array, give all the details and make sure to
specify "--assume-clean".  This ensure that mdadm doesn't start any
resync.  This is import as if you get details wrong and need to try
again, then resync could corrupt data causing subsequent attempts to
be pointless.

So something like:

   mdadm --create /dev/md0 --assume-clean --level=3D5 --raid-disk=3D4 \
     --chunk 128 --metadata=3D1.2 /dev/sda1 /dev/sd2 missing /dev/sda4


This will write out new metadata, assemble the array, but not write to
any data.  You should then try to determine if the array contains the
correct data.  How you do this depends on what was there before.  If
you had an ext2/3/4 filesystem "fsck -n /dev/md0" is the thing to use.
If XFS, then xfs_check is the tool of choice.  If you used LVM, then
you might need to try starting LVM (vgchange -ay) and if that works,
run 'fsck' or whatever on the contents.

Only if 'fsck' reports positive results should you try mounting the
filesystem.  Even if you mount the filesystem read-only, some
filesytems might try to write to the device anyway, and you don't want
that until you are sure.

If you don't know the correct chunk size, or don't know the correct
order of devices you might need to try multiple permutations until you
find one that works.  To speed this up a little you can assume that
once "fsck" or "vgcreate" reports that it sees something that looks
vaguely right, even if there are lots of errors, then you probably
have the first device in the array correct, so you only need to
continue permuting the other devices.

If your array is RAID6, and if it is missing at most one device, then
an alternate approach to checking if the order is correct is to

  echo check > /sys/block/md0/md/sync_action

(where "md0" might be replaced by a different mdX in your case).

If /sys/block/md0/md/mismatch_cnt grows into the thousands quickly,
then you certainly have the order wrong and should stop the array and
try again.  If it reports zero or only a small number of hundreds then
the order is probably correct and it is worth running 'fsck' etc.

This does not work for RAID5, as the parity used for RAID5 is
insensitive to the order of devices.  It can be useful for RAID10 but
a positive result is not as strong as a positive result for RAID6.

Once you have a valid filesystem and you can see all your data, I
recommend a "check" and possibly a "repair" sync_action, a full
"fsck", and probably it's a good time to refresh your backups.

What was the bug anyway
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

So, you want to know the background do you? Well..... are you sitting
comfortably?

md has always had a "reboot notifier" that tried to make sure nice
things happened to arrays at shutdown.  The particular purpose was to
reduce the possibility that a resync might been needed on reboot,
even if the shutdown wasn't particularly clean.

So at shutdown, md would try to switch all arrays to "read-only" mode
so no more writes are allowed, and so the array would be marked as
clean.

This originally applied only to arrays which were not active, but when
people started have root on md more often, they started getting
complaints that md couldn't stop all arrays - because the array
holding the root filesystem would still be busy at this point.

So in 2008, for 2.6.27, md changed to switch any array to read-only,
even if it was still in use.  No more writes should be happening at
this point, the only use should effectively be read-only, so everyone
should be happy.

However sometime around the 3.0 kernel there were changes to the way
filesystem write-back was happening so that writes could still arrive
while the reboot was progressing.  A normal clean shutdown that called
"sync" first should avoid that, but people don't always do that -
sometimes with good reason.

md strongly believes that no-one should be writing to a read-only
device so it has a BUG_ON if a write arrives while the device is
readonly.  Around 3.0/3.1 people started reporting this bug being
triggered at shutdown.  Obviously a BUG at shutdown isn't a very big
problem, but it is untidy so once the problem was identified it should
be fixed.

As switching to read-only was no longer an option, I decided to switch
to immediate-safemode instead.

'safemode' is a precursor to write-intent bitmaps.  It is like a WIB,
but with only one bit.  Before writing, md makes sure the "dirty" bit
is set in the metadata.  200ms after the last write the bit is cleared
in the metadata.  immediate-safemode is the same without the 200ms
delay. So as soon as there are no outstanding writes, the bit is
cleared.  This is very nearly as safe as switching to readonly mode, and
if people a rebooting without calling 'sync' first, then they are
deliberately giving up some safety and I don't feel the need to try
any harder.  If no writes comes, immediate safe mode is just as good
as read-only.

So the code was changed to set immediate-safemode instead of
read-only, and this patch was marked for 'stable' kernels as it fixed
a BUG_ON crash.

Unfortunately the patch was imperfect.  Setting immediate-safemode
involves clearing the bit and writing the metadata out immediately (if
there are no outstanding writes).  This is normally good ... unless
the array is not actually active.  If the array is not active, the
code still writes out the metadata, but does this from its knowledge
of the array, which is that the array is inactive.  The result is that
it corrupts the metadata exactly as described above.

The fix, once the problem was understood, was simple.  Only set
immediate-safemode if the array is active.




--Sig_/sRtwT=AQ+zyXg0+Tg0OYzE7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT92LQTnsnt1WYoG5AQIp7hAAuEgdjb7nUfezJ/hyh/nWAazZ0E9Mqg9W
Cx88dyKffQ096TBSCaByoPqId84pmtA4GYpyYIeGsUFdmf9fH/zgA5Z9VFBJ8jSJ
OZQMxCaSVhWzVPNFkhxbqGmuceMVsk6hoJFe9NsD8zJlQf54yuhhou4Bybq8krBA
MnrYvy0y2aSe+Za52H7UQobJ3W5an+QUypxhssnhaMuQnqDyANeJx9O02kqHu1L0
E07anm8snIwXnQT3JjzTRjpBFOJwFONu+VIhq/Zf87bdAiZT04x+41VDWkI3OtKS
zJu2zeghZfxovgGii107zTcoz5/by/nGTNiTFcEC56GcxtH2286EayGwI+L698CX
0/RNPyFcynq/EU9SURqaBQiBVji3l3P+twSuqHhw9wbz61Xf4C2HTEct056JLcBj
ZbE4aB57bzQuucjkSn2zraXkHqfTLppvPCbNS48xMwz9FJcrFD+LpEGemRLZZksC
0ds3dBCCDx4BB+1mkkGtsYTxd2yv9bH08whm+dGC5671fwkiSkTx0bzTlXoThHST
F8QfUCnSp3MbVkxngUXDEKs28kecXLdKdRD6KlMhdafIQhqPkwl51Fxq1wIsv51Q
flgF6SgoIyev6zsDFdkoCGv1JING4FemfnD/v+tREnKBfVplCxju1Yoq1HQs/22R
wnR/xPZUP5Q=
=jeJU
-----END PGP SIGNATURE-----

--Sig_/sRtwT=AQ+zyXg0+Tg0OYzE7--
