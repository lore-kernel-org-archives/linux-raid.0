From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: RAID1 detection of faulty disks
Date: Wed, 9 Feb 2005 21:08:29 +0100
Message-ID: <t67qd2-48u.ln1@news.it.uc3m.es>
References: <200502091849.TAA05566@node130.rhm.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

bernd@rhm.de wrote:
> just for my understanding of RAID1. When is a partition set faulty?
> As soon as a read hits a bad block or only when a write attempts to
> write to a bad block?
> 
> I'm a little bit confused as I read the thread 'Robust read patch for raid1'.
> Does it mean that a read succeeds even if one disk is already gone?

As far as I recall (and I wrote that patch, but I do not have a perfect
memory of every bit of code I have studied or written ...) in ordinary
unpatched raid1 the read request is rescheduled, but

   1) it will be retried on disk 0 on the array only (and every time,
      if it fails again, if it can fail again). That's probably an
      oversight, though I see the reasoning - if it fails again disk 0
      will be ejected and disk 0 becomes something else, so the array
      rotates under the call.

   2) the disk is faulted out of the array when the read error occurs.

The patch changes the code - or intends, anyway! - to make (1) into
"retry on the NEXT disk in the array", and changes (2) to "the disk
is NOT faulted out of the array under any circumstances under a read
error".

At the very worst, the read error will result in a perceived error
at user level, when every disk in the array errors on the read. In
my judgment that is morally correct, since "error" is the unanimous
opinion of all the disks, then.  It is another question if it is
strategically correct, against some measure of an objective function,
and some disaster scenario.

Normally, the read will be retried on another disk and succeed.

After the patch, disks will be faulted out of the array on a write
error, only.

The patch has another inactive and untried patch within it, which
triggers a "write repair" request, using the information from a
successful read. Volunteers needed to test and work on it!


Peter

