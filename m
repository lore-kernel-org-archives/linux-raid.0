From: Doug Ledford <dledford@xsintricity.com>
Subject: Re: RAID1 and data safety?
Date: Mon, 04 Apr 2005 18:57:53 -0400
Message-ID: <1112655473.29559.139.camel@compaq-rhel4.xsintricity.com>
References: <76592C4D3DA1AC4FB8424084D10D31A80611527B@mchh2c4e.mchh.siemens.de>
	 <6kjnh2-qn4.ln1@news.it.uc3m.es> <16969.10587.679662.55065@cse.unsw.edu.au>
	 <8kqnh2-o1n.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8kqnh2-o1n.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2005-03-29 at 13:26 +0200, Peter T. Breuer wrote:
> Neil Brown <neilb@cse.unsw.edu.au> wrote:
> > On Tuesday March 29, ptb@lab.it.uc3m.es wrote:
> > > 
> > > Don't put the journal on the raid device, then - I'm not ever sure why
> > > people do that!  (they probably have a reason that is good - to them).
> > 
> > Not good advice.  DO put the journal on a raid device.  It is much
> > safer there.
> 
> Two journals means two possible sources of unequal information - plus the
> two datasets.  We have been through this before. You get the journal
> you deserve.

No, you don't.  You've been through this before and it wasn't any more
correct than it is now.  Most of this seems to center on the fact that
you aren't aware of a few constraints that the linux md subsystem and
the various linux journaling filesystems were written under and how each
of those meets those constraints at an implementation level, so allow me
to elucidate that for you.

1) All linux filesystems are designed to work on actual, physical hard
drives.

2) The md subsystem is designed to provide fault tolerance for hard
drive failures via redundant storage of information (except raid0 and
linear, those are ignored throughout the rest of this email).

3) The md subsystem is designed to seamlessly operate underneath any
linux filesystem.  This implies that it must *act* like an actual,
physical hard drive in order to not violate assumptions made at the
filesystem level.

So here's how those constraints are satisfied in linux.

For constraint #1, specifically as it relates to journaling filesystems,
all journaling filesystem currently in use started their lives at a time
when the linux block layer did not provide any means of write barriers.
As a result, they used completion events as write barriers.  That is to
say, if you needed a write barrier between the end of journal
transaction write and the start of the actual data writes to the drive,
you simply waited for the drive to say that the actual end of journal
transaction data had been written prior to issuing any of the writes to
the actual filesystem.  You then waited for all filesystem writes to
complete before allowing that journal transaction to be overwritten.

Additionally, people have mentioned the concept of rollbacks relating to
journaling filesystems.  At least ext3, and likely all journaling
filesystems on linux, don't do rollbacks.  They do replays.  In order to
do a rollback, you would have to first read the data you are going to
update, save it somewhere, then start the update and if you crash
somewhere in the update you then read the saved data and put it back in
place of the partially completed update.  Obviously, this has
performance impact because it means that any update requires a
corresponding read/write cycle to save the old data.  What they actually
do is transactional updates where they write the update to the journal,
wait for all of the journal writes relevant to a specific transaction
group to complete, then start the writes to the actual filesystem.  If
you crash during the update to the filesystem, you replay any and all
whole journal transactions in the ext3 journal which simply re-issues
the writes so that any that didn't complete, get completed.  You never
start the writes until you know they are already committed to the
journal, and you never remove them from the journal until you know they
are all committed to the filesystem proper.  That way you are 100%
guaranteed to be able to complete whatever group of filesystem proper
writes were in process at the time of a crash, returning you to a
consistent state.  The main assumption that the filesystem relies upon
to make this true is that an issued write request(s) is not returned
until it is complete and on media (or in the drive buffer and the drive
is claiming that even in the event of a power failure it will still make
media).

OK, that's the filesystem issues.  For constraint #2, md satisfies this
by storing data in a way that any single drive failure can be
compensated for transparently (or more if using a more than 2 disk raid1
array or using raid6).  The primary thing here is that on a recoverable
failure scenario, the layers above md must A) not know the error
occurred and B) must get the right data when reading and C) must be able
to continue writing to the device and those writes must be preserved
across reboots and other recovery operations that might take place to
bring the array out of degraded mode.  This is where the event counters
come into play.  That's what md uses to be able to tell which drives in
an array are up to date versus those that aren't, which is what's needed
to satisfy C.

Now, what Peter has been saying can happen on a raid1 array (but which
can't) is creeping data corruption that's only noticed later because a
write to md array gets completed on one device but not the other and it
isn't until you read it later that this shows up.  Under normal failure
scenarios (aka, not the rather unlikely one posted to this list recently
that involves random drives disappearing and then reappearing at just
the right time), this isn't an issue.  From a very high level
perspective, there are only two type of raid1 restarts: ones where the
event counters of constituent devices match, and ones where they don't.
If you don't have a raid restart then we aren't really interested in
what's going on because without a crash, things are going to eventually
get written identical on all devices, it's just a matter of time, and
while waiting on that to happen the page cache returns the right data.
So, if the event counters don't match, then the freshest device is taken
and the non-fresh devices are kicked from the array, so you only get the
most recent data.  This is what you get if a raid devices is failed out
of the array prior to a system crash or raid restart.  If the array
counters match and the state matches on all devices, then we simply pick
a device as the "in sync" device and resync to all the other mirrors.
This mimics the behavior of a physical hard drive in the sense that if
you had multiple writes in flight, it isn't guaranteed that they all
completed, just that whatever we return is all consistent and that it
isn't possible to read the same block twice and get two different
values.  This is what happens when a system crashes with all devices
active.  For less common situations, such as a 3 disk raid1 array, you
can actually get a combination of the two above behaviors if you have
something like 1 disk fail, then a crash.  We'll pick one of the two up
to date disks as the master (we always simply take the first active-sync
disk in the rdev array, so which disk it actually is depends on the
disk's position in the rdev array), sync it over to the other active-
sync disk, and kick the failed disk entirely out of the array.  It is
entirely possible that prior to the crash, a write might have completed
on one of the disks, but not on the one selected as the master for the
resync operation.  This write will then be lost upon restart.  Again,
this is consistent with a physical hard drive since the ordering of
multiple outstanding writes is indeterminate.

Raid4/5/6 is similar in that any disk that doesn't have an up to date
superblock is kicked from the array.  However, we can't just pick a disk
to sync to all the others, but we still need to provide a guarantee that
two reads won't get different data where two different reads means a
read from a data block versus a read from a reconstructed from parity
data block, so we resync all the parity blocks from all the data blocks
so that should a degraded state happen in the future, stale parity won't
cause the data returned to change.  The one failing here relative to
mimicking a real hard drive is that it's possible that with a raid5
array with say a 64k chunk size and a 256k write, that you could end up
with the first 64k chunk making it to disk, then not the second, then
the third making it, etc.  Generally speaking this doesn't happen on
real disks because sequential writes are done sequentially to media.

So, now we get to the interactions between the md raid devices and the
filesystem level of the OS.  This is where ext3 or other journaling
filesystems actually solve that problem I just noted with lost writes on
raid1 arrays and with partial writes with stale data in the middle of
new data on raid4/5/6 arrays.  If you use a journaling filesystem, then
any in flight writes to the filesystem proper at the time of a crash are
replayed in their entirety to ensure that they all make it to disk.  Any
in flight writes to the journal will be thrown away and never go to the
filesystem proper.  This means that even if two disks are inconsistent
with each other, the resync operation makes them consistent and the
journal replay guarantees they are up to date with the last completed
journal group entry.  This is true even when the journal is on the same
raid device as the filesystem because the journal is written with a
write completion barrier and the md subsystem doesn't complete the
barrier write until it has hit the media on all constituent devices,
which ensures that regardless of which device is picked as a master for
resync purposes after an unclean shutdown that it is impossible for any
of the filesystem proper writes to have started without a complete
journal transaction to replay in the event of failure.

Now, if I recall correctly, Peter posted a patch that changed this
semantic in the raid1 code.  The raid1 code does not complete a write to
the upper layers of the kernel until it's been completed on all devices
and his patch made it such that as soon as it hit 1 device it returned
the write to the upper layers of the kernel.  Doing this would introduce
the very problem Peter has been thinking that the default raid1 stack
had all along.  Let's say you are using ext3 and are writing an end of
journal transaction marker.  That marker is sent to drive A and B.
Assume drive A is busy completing some reads at the moment, and drive B
isn't and completes the end of journal write quickly.  The patch Peter
posted (or at least talked about, can't remember which) would then
return a completion event to the ext3 journal code.  The ext3 code would
then assume the journal was all complete and start issuing the writes
related to that journal transaction en-masse.  These writes will then go
to drives A and B.  Since drive A was busy with some reads, it gets
these writes prior to completing the end of transaction write it already
had in its queue.  Being a nice, smart SCSI disk with tagged queuing
enabled, it then proceeds to complete the whole queue of writes in
whatever order is most efficient for it.  It completes two of the writes
that were issued by the ext3 filesystem after the ext3 filesystem
thought the journal entry was complete, and then the machine has a power
supply failure and nothing else gets written.  As it turns out, drive A
is the first drive in the rdev array, so on reboot, it's selected as the
master for resync.  Now, that means that all the data, journal and
everything else, is going to be copied from drive A to drive B.  And
guess what.  We never completed that end of journal write on drive A, so
when the ext3 filesystem is mounted, that journal transaction is going
to be considered incomplete and *not* get replayed.  But we've also
written a couple of the updates from that transaction to disk A already.
Well, there you go, data corruption.  So, Peter, if you are still toying
with that patch, it's a *BAAAAAD* idea.

That's what using a journaling filesystem on top of an md device gets
you in terms of what problems the journaling solves for the md device.
In turn, a weakness of any journaling filesystem is that it is
inherently vulnerable to hard disk failures.  A drive failure takes out
the filesystem and your machine becomes unusable.  Obviously, this very
problem is what md solves for filesystems.  Whether talking about the
journal or the rest of the filesystem, if you let a hard drive error
percolate up to the filesystem, then you've failed in the goal of
software raid.  I remember talk once about how putting the journal on
the raid device was bad because it would cause the media in that area of
the drive to wear out faster.  The proper response to that is: "So.  I
don't care.  If that section of media wears out faster, fine by me,
because I'm smart and put both my journal and my filesystem on a
software raid device that allows me to replace the worn out device with
a fresh one without ever loosing any data or suffering a crash."  The
goal of the md layer is not to prevent drive wear out, the goal is to
make us tolerant of drive failures so we don't care when they happen, we
simply replace the bad drive and go on.  Since drive failures happen on
a fairly regular basis without md, if the price of not suffering
problems as a result of those failures is that we slightly increase the
failure rate due to excessive writing in the journal area, then fine by
me.

In addition, if you use raid5 arrays like I do, then putting the journal
on the raid array is a huge win because of the outrageously high
sequential throughput of a raid5 array.  Journals are preallocated at
filesystem creation time and occupy a more or less sequential area on
the disks.  Journals are also more or less a ring buffer.  You can tune
the journal size to a reasonable multiple of a full stripe size on the
raid5 array (say something like 1 to 10 MB per disk, so in a 5 disk
raid5 array, I'd use between a 4 and 40MB journal, depending on whether
I thought I would be doing a lot of large writes of sufficient enough
size to utilize a large journal), turn on journaling of not just meta-
data but all data, and then benefit from the fact that the journal
writes take place as more or less sequential writes as seen by things
like tiobench benchmark runs, and because the typical filesystem writes
are usually much more random in nature, the journaling overhead can be
reduced to no more than, say, 25% performance loss while getting the
benefit of both meta-data and regular data journaled.  It's certainly
*far* faster than sticking the journal on some other device unless it's
another very fast raid array.

Anyway, I think the situation can be summed up as this:

See Peter try to admin lots of machines.
See Peter imagine problems that don't exist.
See Peter disable features that would make his life easier as Peter
	takes steps to circumvent his imaginary problems.
See Peter stay at work over New Years holiday fixing problems that
	were likely a result of his own efforts to avoid problems.
Don't be a Peter, listen to Neil.


-- 
Doug Ledford <dledford@xsintricity.com>


