From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: 3 questions...
Date: Mon, 30 Sep 2002 01:57:39 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D977753.4010401@tls.msk.ru>
References: <C65F89D1AC0BB54B865127151A24DA780BAD5C7B@nbexchm2.aliant.icn>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Shaw, Marco wrote:
> 1. When using fdisk, is it really required (or a "good idea") to
 > create the partitions as type "fd"?  I've typically just created
 > a regular Linux partition, and would let mkraid to it's thing.

No.  Raid code will happily use any partition type you'll specify.
Partition type "fd" stands for "raid AUTODETECT" - that is, at
bootup, kernel looks at your partitions of this type (if any)
to automatically bring up an array that may be required for your
root filesystem.  But instead of guessing, it is better IMHO to
just tell kernel which devices to use for your root filesystem
(if your root is on raid device), by using something like
  append="md=2,/dev/hda1,/dev/hdb1"
in your lilo.conf or similar (to mean bring up /dev/md2 consisting
of /dev/hda1 and /dev/hdb1 - you should got an idea).
Non-root arrays may be set up just easily from your real root
filesystem.  In either way, do not bother using "fd" partition
type for non-automatically-started-root-fs device.  For me,
I don't use autodetect at all since it will be a PITA if I'll
need to insert drives from one machine to another - on another
machine I may get just unpredictable results after kernel will
try to bring up autodetected raid arrays from both own disks
and disk from foreign machine (btw, it will be nice to DISABLE
raid autodetection completely for this very reason, as it was
possible on 2.2 kernels).

 > (As a result, it seems strange that I ran into #2 below since I
 > didn't do this step of changing the type.)
> 
> 2. I can't seem to find a document describing how software RAID
 > really works technically.  (Yes, I could read the source, but I'm
 > not the most proficient C person, nor do I want to work all weekend
 > looking at the source either.)  I had a problem the other day,
 > where I had a md0 device that the system was not able to mount
 > (logical disks mounted from a SAN).  Because the system could not
 > mount the disks, it would fail to boot at the section where the
 > system would attempt to auto-detect md0 and would drop me to
 > single-user mode type prompt.

An array should be started before it can be mounted (that should
be obvious, right?).  You may got single-user prompt *only* if
your root filesystem was mounted successefully (or else you'd
got kernel panic instead).  So, an answer is in your startup
scripts -- there should be a script that brings raid arrays
up before mounting filesystems, and there should be some file
where an information about how to assemble arrays is stored
(maybe /etc/raidtab or /etc/mdadm.conf).  But this highly
depends on distribution you use, and I can't help you here.

> Taking the directory out of fstab, and tried to find something
 > in /etc/rc.d/init.d that was trying to do stuff with the md
 > devices at boot but couldn't find anything.  Ended up being
 > a problem with an old modular driver, and had to create a new
 > initrd with an updated driver, but I was stuck for a second
 > (well more than a second really).
> 
> 3. Is "persistent-superblock" supported with Linear and RAID0?
 > I think chunk-size is only supported in RAID0 and higher, but
 > Linear will just skip the configuration with an informational
 > warning at boot.

I think persistent-superblocks are supported with all raid levels,
but I may be wrong.  At least, raid0 has this feature for sure.

/mjt

