From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sun, 5 Apr 2009 18:55:39 -0500
Message-ID: <20090405235540.KKYO1944.cdptpa-omta02.mail.rr.com@Leslie>
References: <18905.6980.631038.776261@tree.ty.sabi.co.uk>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18905.6980.631038.776261@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> [ ... ]
> 
> > Several, actually.  Since the RAID array kept crashing,
> 
> Someone who talks or thinks in vague terms like "RAID array kept
> crashing" is already on a bad path.

Into how much detail do you wish me to go?  I could write a small volume on
the various symptoms.  The array was taken offline numerous times due to
drives being disconnected or convicted as bad.  Usually I could recover the
array, but 3 times it proved to be completely unrecoverable.  After
replacing a convicted drive and placing it in another machine, destructive
diagnostics showed no problems.  This happened many times.

> > I had to re-create it numerous times. I tried ext3 more than
> > once, but the journal kept getting corrupted, and fixing it
> > lost several files.
> 
> Well, 'ext3' is *exceptionally* well tested, and this points to
> some problems with the storage system

It *WAS* the storage system, almost surely.  The first time ext3 was crashed
was when I performed an on-line RAID expansion while using a hardware RAID
controller.  Everything seemed to be fine after adding a drive, but the next
morning I could not write to the array.  I re-mounted the drive, and
everything seemed fine.  Fifteen minutes later, I could not write to the
array again.  After nosing around, I found the array was constantly trying
to seek beyond the end of the physical drive system when writing.  When I
tried to run fsck, it wouldn't let me because the journal inode was invalid
(I don't recall the exact error).  I converted to ext2, and once again ran
fsck.  It deleted and fixed a very large number of errors, and when the dust
settled, a number of newer files were lost.  During one of the numerous
array crashes, the journal got munched again.  This time, however, fsck was
able to recover all the errors without converting to ext2 and as far as I
could tell without losing any additional files.  I'm not saying ext3 cause
any of the problems, but it certainly allowed itself to be corrupted by
hardware issues.

> driver (e.g. use of some blob/binary proprietary driver in the
> kernel). In theory everything should work with everything else
> and everything should be bug free in every combination... In
> practice wise people try not to beg for trouble.
> 
> > Once I lost several important files during a RAID expansion.
> > In some cases I converted to ext2, and others I started out
> > with ext2, but last I checked, one cannot grow an ext2 file
> > system on the fly.
> 
> Modifying filesystem structure while the filesystem is operating
> is a very good way to beg for trouble. Especially if under load.

I am aware of the risk, but ext3 claims to be capable of the migration
(indeed I just did one on an LVM system employing ext3), and the RAID
controller has a very prominent utility for OLRE.  Taking the array offline
for 3 days every time I need to do an expansion is not a very thrilling
prospect.  If it were 3 or 4 hours, or even overnight...

> That something is *possible* does not mean that it is wise to
> rely on it.

I am aware of this, too.  I did not consider the option lightly.  At the
time, I did not have the money to put together a backup server, and having
the array offline for three days was not an attractive option.

> Good luck with that. Perhaps you need to think again about your
> requirements, and/or perhaps to get a much larger budget to do
> some research and development into "dynamic storage pools".

I would be happy to, as soon as someone offers me a large pay increase.  Are
you offering?

