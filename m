From: Michael Evans <mjevans1983@gmail.com>
Subject: Idea for new RAID type - background extended recovery information
Date: Wed, 9 Dec 2009 01:06:50 -0800
Message-ID: <4877c76c0912090106i684924edn7915c6609ab574f5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Summary:

New raid level between 0 and 1; version tracking and 'bad sector'
recovery parity.

Rational:
* For that extra .001% assurance that could be the difference between
a few bad sectors and otherwise valid data.
* Possibility to 'inform' upper layers about stale/bad checksum copies
of data; thus allowing improvement of recovery decisions.

Rambling train of thought:

One of the main problems that still remains unsolved with current RAID
operations is determining which set of data has gone bad.  The most
obvious choice is to use a data recovery scheme like PAR2 uses, which
keeps a checksum for every storage segment.  However that conflicts
with the 'zero it before creation and assume-clean works' idea.  It
also very likely has extremely poor write performance.  However it may
be sufficient to use a different approach.

If stripes still in memory are buffered the parity update might be
deferred.  Additional stripes or an external (hopefully independent)
logging device/file could be provided to record any pending changes.
Any modification which flushes an entire stripe to disk needn't be
logged once all the data had been written, so a separate ring buffer
for that section might be a good performance idea.  Ideally lots of
small, stripe-clustered changes could be buffered until they could be
combined in to a single recalculation and write; or at least until
idle cpu/io allowed them to be written anyway.

In addition to the per-stripe approaches deferring the calculations
might allow for the PAR2 style method to work as well.  A second
extended recovery data-set could be stored which would add to the
existing stripes of whatever type. It would only be updated by
explicit request, or during lulls in activity.  Storing N-1 (or less)
recovery units might also allow for a copy of that device's blocks or
all device's blocks to be stored.  That would allow easier
verification of data-version and consistency.  A more bold approach
then also presents it's self.  Using the other parity blocks in
conjunction with the extended set.  It would mean far worse on the fly
recovery, but the trade-off would be the ability to recover from more
partial disk failure/unreadable sector scenarios.  However in my mind
it seems a better trade to use an extra .001% of each storage device
to gain that tiny extra assurance against all normal parity units PLUS
one bad sector on a data drive crippling everything.  Also, again, the
consistency/version data would make determining which chunk to replace
far easier.

Given the zeros operation, a sparse (zero filled) device could be made
and then cleaned up by the first recovery process with but a single
information message in the system log.  "Detected newly assembled
pre-zeroed device, filling in missing checksum values.".  All of the
checksums would be the same and could be calculated at compile time.
The parity values might differ, depending on the algorithm, but could
assuredly be cached at runtime, leading to a series of easy to process
asynchronous writes.  Storing ranges of sparse information would
likely defer the write operation until after all reads are completed
anyway.
