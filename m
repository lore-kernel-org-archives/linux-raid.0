From: Matthias Urlichs <matthias@urlichs.de>
Subject: [PATCH] Re: raid6 recovery with read errors
Date: Tue, 22 Sep 2009 10:56:58 +0000 (UTC)
Message-ID: <h9aahq$e1m$1@ger.gmane.org>
References: <h567hm$u6a$1@ger.gmane.org> <h5ttls$g3u$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>> [ block-level restoration of RAID6 data ] Is there a standalone program
>> that can do that?
> 
> Seems that the answer is "no", at least as far as anybody on this list
> is concerned.
> 
> *Sigh* So I'll have to write one, it seems.

The code is available from http://netz.smurf.noris.de/git/mdadm.git 
(branch "repair"). This is off mdadm's 3.1 development branch; the bugfix 
changes since 3.0 have been merged in.

Restoration of RAID5 and RAID6 partitions is tested, given a workable 
badblock list (i.e. ddrescue's log). Restoration of RAID6 and purging 
unrecoverable ranges (plus restoring the parity sectors) is untested.

The test suite includes a helper program which can find bad parity or 
inconsistent RAID1. I didn't add an option to mdadm to do that, because 
I'm lazy :-P besides, the kernel can do that already.

Also included are some changes in the test suite which ensure that the 
test suite works on a machine which has udev running -- or loopback or 
raid drivers in use. :-/

Usage: mdadm --repair-blocks=0:bad-sda1.log,1:bad-sdb1.log /dev/sd[a-d]1
(The numbers correspond to the disk numbers within the RAID, not to the 
n'th non-option argument.) Specifying a UUID instead of a bunch of 
devices should also work, but is untested.

Any feedback is of course welcome.

Now for the difficult part -- how to do automagic remapping. I tend to 
think that extending the staging/cowloop (copy-on-write) driver to be a 
coeloop (copy-on-error) driver would be a good idea. (It should also be 
possible to force a copy of the RAID superblocks, and overwrite that with 
some sort of cowloop metadata on the original disk, so that the kernel 
doesn't mount the underlying device with its obsolete blocks. :-/ )

TODO: (a) containers. Somebody else please uncomment and re-enable the 
code in Repair.c; (b) testing of RAID1 and uuid-etc.-based RAID selection,
(c) auto-selection among 'identical' RAID partitions, if scanning finds 
more than one (the idea is to choose the partition that's _not_ on the 
device where the superblock says it should be, assuming identical event 
numbers).

I haven't tested this on my production system yet -- that's the next 
step. But the test suite says it should work. Famous last words. :-P

