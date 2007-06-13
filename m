From: Michael Tokarev <mjt@tls.msk.ru>
Subject: RFC: dealing with bad blocks: another view
Date: Wed, 13 Jun 2007 11:15:31 +0400
Message-ID: <466F9993.6040007@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Now MD subsystem does a very good job at trying to
recover a bad block on a disk, by re-writing its
content (to force drive to reallocate the block in
question) and verifying it's written ok.

But I wonder if it's worth the effort to go further
than that.

Now, md can use bitmaps.  And a bitmap can be used
not only to mark "clean vs dirty" chunks, but also,
for example, "good vs bad" chunks.

That to say.  If we discover a read error on one
component of an array, we tried to re-write it but
rewrite (or reread) failed.  Now current implementation
will kick the bad drive from the array.  But here it
is possible to not kick it, but to turn corresponding
bit(s) in the bitmap that says the data on this location
on this drive is wrong, don't try to read from it.  And
continue using this drive as before (modulo the bits/parts
just turned on).

The rationale is -- each time we kick the whole drive from
an array, for whatever reason, -- we greatly reduce chances
of the whole array to be in working condition.

For some reason, drives from the same batch tend to discover
bad blocks close to each other - i mean, we see a bad block
on one drive, and pretty soon we see another bad block on
another drive (at least from our expirience).  So by kicking
one drive, we increase failure probability even more.

We had a large batch of seagate 36g scsi drives, which all
has some issue with firmware -- each time a drive detects
a bad sector, and we try to mitigate it (by rewriting it),
the drive reports "defect list manipulation error" (I don't
remember exact sense code), and only on second attempt it
rewrites the sector in question successefully.  Seagate
refused to acknowlege this problem, no matter how we
argued -- they said it's "mishandling" (like, we improperly
handled the drives).

That to show just one example of numerous cases when such
kicking of the whole drive is not good idea.

Even more.  If we see *read* error, there's no need to mark
this chunk as "bad" in the bitmap -- only if we see *write*
error while writing some *new* data.  Ie, that "bad" bit in
the bitmap may mean "data at this place is out of sync", like
"extended dirty".  When interpreted like that, there's no
need to allocate new bit, but existing "dirty" bit can be
used.  On resync, we try to write again, and just keep that
"dirty" bit if write failed.

Obviously, we should not try to read from those "dirty"
places.  And if there's no components left to read from,
just return read error - for this single read, but continue
running the array (maybe in read-only mode, whatever).

It seems like it's pretty simple to implement with existing
code.  The only requiriment is to have a bitmap - obviously,
without the bitmap the whole idea does not work.

This fits perfectly the "policy does not belong to the kernel"
model as well.  Never, ever, try to do something "large" (like
kicking off the whole disk), but let userspace to descide what
to do...  Mdadm event handlers (scripts called when something
goes wrong) can kick the disk off just fine.

Comments, anyone?

/mjt
