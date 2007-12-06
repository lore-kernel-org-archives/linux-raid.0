From: Michael Tokarev <mjt@tls.msk.ru>
Subject: external bitmaps.. and more
Date: Thu, 06 Dec 2007 19:08:42 +0300
Message-ID: <47581E8A.2010203@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I come across a situation where external MD bitmaps
aren't usable on any "standard" linux distribution
unless special (non-trivial) actions are taken.

First is a small buglet in mdadm, or two.

It's not possible to specify --bitmap= in assemble
command line - the option seems to be ignored.  But
it's honored when specified in config file.

Also, mdadm should probably warn or even refuse to
do things (unless --force is given) when an array being
assembled is using external bitmap, but the bitmap file
isn't specified.

Now for something more.. interesting.

The thing is that when a external bitmap is being used
for an array, and that bitmap resides on another filesystem,
all common distributions fails to start/mount and to
shutdown/umount arrays/filesystems properly, because
all starts/stops is done in one script, and all mounts/umounts
in another, but for bitmaps to work the two should be intermixed
with each other.

Here's why.

Suppose I've an array mdX which used bitmap /stuff/bitmap,
where /stuff is another separate filesystem.  In this case,
during startup, /stuff should be mounted before bringing up
mdX, and during shutdown, mdX should be stopped before
trying to umount /stuff.  Or else during startup mdX will
not find /stuff/bitmap, and during shutdown /stuff filesystem
is busy since mdX is holding a reference to it.

Doing things in "simple" way doesn't work: if I specify to
mount mdX as /data in /etc/fstab, -- since mdX hasn't been
assembled by mdadm (due to missing bitmap), the system will
not start, asking for emergency root password...

Oh well.

So the only solution for this so far is to convert md array
assemble/stop operation into... MOUNTS/UMOUNTS!  And specify
all necessary information in /etc/fstab - for both arrays and
filesystems, with proper ordering in "order" column.
Ghrm.

Technically speaking it's not difficult - mount.md and fsck.md
wrappers for mdadm are trivially to write (I even tried that
myself - a quick-n-dirty 5-minutes hack works).  But it's...
ugly.

But I don't see any other reasonable solutions.  Alternatives
are additional scripts to start/stop/mount/umount filesystems
residing on or related to "advanced" arrays (with external
bitmaps in this case) - but looking at how much code is in
current startup scripts around mounting/fscking, and having
in mind that mount/umount does not support alternative
/etc/fstab, this is umm.. even more ugly...

Comments anyone?

Thanks.

/mjt

P.S.  Why external bitmaps in the first place?  Well, that's
a good question, and here's a (hopefully good too) answer:
When there are sufficient disk drives available to dedicate
some of them for bitmap(s), and there's a large array(s)
with dynamic content (many writes), and the content is
important enough to care about data safety wrt possible
power losses and kernel OOPSes and whatnot, placing bitmap
into another disk(s) helps alot with resyncs (it's not
about resync speed, it's about resync general UNRELIABILITY,
which is another topic - hopefully a long-term linux
raid gurus will understand me here), but does not slow
down writes hugely due to constant disk seeks when updating
bitmaps.  Those seeks tends to have huge impact on random
write performance.
