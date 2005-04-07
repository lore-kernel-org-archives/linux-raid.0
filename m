From: Doug Ledford <dledford@xsintricity.com>
Subject: Re: AW: RAID1 and data safety?
Date: Thu, 07 Apr 2005 12:05:35 -0400
Message-ID: <1112889935.7025.17.camel@compaq-rhel4.xsintricity.com>
References: <76592C4D3DA1AC4FB8424084D10D31A8061152B0@mchh2c4e.mchh.siemens.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <76592C4D3DA1AC4FB8424084D10D31A8061152B0@mchh2c4e.mchh.siemens.de>
Sender: linux-raid-owner@vger.kernel.org
To: Schuett Thomas EXT <Thomas.Schuett.extern@mchh.siemens.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2005-04-07 at 17:35 +0200, Schuett Thomas EXT wrote:
> [Please excuse, my mailtool breaks threads ...]
> Reply to mail from 2005-04-05
> 
> Hello Doug,
> 
> many thanks for this highly detailed and structured posting.

You're welcome.

> A few questions are left: Is it common today, that a (eide) HD does
> not state a write as finished (aka send completion events, if I got this 
> right), before it was written to *media*?

Depends on the state of the Write Cache bit in the drive's configuration
page.  If this bit is enabled, the drive is allowed to cache writes in
the on board RAM and complete the command.  Should the drive have a
power failure event before the data is written to drive, then it might
get lost.  If the bit is not set, then the drive is suppossed to
actually have the data on media before returning (or at the very
absolute least, it should be in a small enough queue of pending writes
that should the power get lost, it can still write the last bits out
during spin down).

> I am happy to hear about this "write barriers", even as I am astonished, that 
> it doesn't bring down the whole system performance (at least for raid1).

It doesn't bring down system performance because the journaling
filesystem isn't single task so to speak.  What this means is that when
you have a large number of writes queued up to be flushed, the
journaling fs can create a journal transaction for just some of the
writes, then issue an end of journal transaction, wait for that to
complete, then it can proceed to release all those writes to the
filesystem proper.  At the same time that the filesystem proper writes
are getting under way, it can issue another stream of writes to start
the next journal transaction.  As soon as all the journal writes are
complete, it can issue an end of journal transaction, wait for it to
complete, then issue all those writes to the filesystem proper.  So you
see, it's not that writes to the filesystem and the journal are
exclusive of each other so that one waits entirely on the other, it's
that writes from a single journal transaction are exclusive to writes to
the filesystem for *that particular transaction*.  By keeping ongoing
journal transactions in process, the journaling filesystem is able to
also stream data to the filesystem proper without much degradation, it's
just that the filesystem proper writes are delayed somewhat from the
corresponding journal transaction writes.  Make sense?

> 
> > This is where the event counters
> > come into play.  That's what md uses to be able to tell which drives in
> > an array are up to date versus those that aren't, which is what's needed
> > to satisfy C.
> 
> So event counters are the 2nd type of information, that gets written with write 
> barriers. One is the journal data from the (j)fs (and actually the real data 
> too, to make it gain sence, otherwise the end-of-transaction-write is like a 
> semaphor with only one of the two parties using it), and the other is the event 
> counter.

Not really.  The event counter is *much* courser grained than journal
entries.  A raid array may be in use for years and never have the event
counter get above 20 or so if it stays up most of the time and doesn't
suffer disk add/remove events.  It's really only intended to mark events
like drive failures so that if you have a drive fail on shutdown, then
on reboot we know that it failed because we did an immediate superblock
event counter update on all drives except the failed one when the
failure happened.

> > Now, if I recall correctly, Peter posted a patch that changed this
> > semantic in the raid1 code.  The raid1 code does not complete a write to
> > the upper layers of the kernel until it's been completed on all devices
> > and his patch made it such that as soon as it hit 1 device it returned
> > the write to the upper layers of the kernel.
> 
> I am glad to hear, that the behaviour is such, that the barrier stops, until 
> *all* media got written. That was one of the things that really made me 
> worrying. I hope, the patch is backed out and didn't went into any distros.

No it never went anywhere.  It was just a "Hey guys, I played with this
optimization, here's the patch" type posting and no one picked it up for
inclusion in any upstream or distro kernels.

> > had in its queue.  Being a nice, smart SCSI disk with tagged queuing
> > enabled, it then proceeds to complete the whole queue of writes in
> > whatever order is most efficient for it.
> 
> But just to make sure: Your previous statement "...when the linux block layer 
> did not provide any means of write barriers. As a result, they used completion 
> events as write barriers." indicates, that even "nice, smart SCSI disk with 
> tagged queuing enabled" will act as demanded, because the special way of write 
> with appended "completion events testing" will make sure they do?

Yes.  We know that drives are allowed to reorder writes, so anytime we
want a barrier for a given write (say you want all journal transactions
complete before writing the end of journal entry), then you basically
wait for all your journal transactions to complete before sending the
end of journal transaction.  You don't have to wait for *all* writes to
the drive to complete, just the journal writes.  This is why performance
isn't killed by journaling.  The filesystem proper writes for previous
journal transactions can be taking place while you are doing this
waiting.

> ---
> 
> You mentioned data journaling, and it sounded like it is reliable working. 
> Which one of the existing journaling fs did you have in your mind?

I use ext3 personally.  But that's as much because it's the default
filesystem and I know Stephen Tweedie will fix it if it's broken ;-)

> ---
> 
> Afaik a read only reads from *one* HD (in raid1). So how to be sure, 
> that *both* HDs are still perfectly o.k.? Am I am fine to do a 
>    cat /dev/hda2 > /dev/null ; cat /dev/hdb2 > /dev/null
> even *during* the md is active and getting used r/w?

It's ok to do this.  However, reads happen from both hard drives in a
raid1 array in a sort of round robin fashion.  You don't really know
which reads are going to go where, but each drive will get read from.
Doing what you suggest will get you a full read check on each drive and
do so safely.  Of course, if it's supported on your system, you could
also just enable the SMART daemon and have it tell the drives to do
continuous background media checks to detect sectors that are either
already bad or getting ready to go bad (corrected error conditions).

-- 
Doug Ledford <dledford@xsintricity.com>
http://www.xsintricity.com/dledford
http://www.livejournal.com/users/deerslayer
AIM: DeerObliterator


