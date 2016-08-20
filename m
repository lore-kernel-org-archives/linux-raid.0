From: Chris Dunlop <chris@onthe.net.au>
Subject: Re: Rewrite md raid1 member
Date: Sat, 20 Aug 2016 11:43:36 +1000
Message-ID: <20160820014336.GA30642@onthe.net.au>
References: <20160818030451.GA17225@onthe.net.au>
 <2dca8e1f-8e80-408f-900e-36f9b1dd6f95@fnarfbargle.com>
 <20160818040151.GA21256@onthe.net.au>
 <57B6F2F5.8090800@youngman.org.uk>
 <20160819124615.GA23247@onthe.net.au>
 <CAJCQCtQs+z6rso4pc7CgRSia4tM5KK=T8ckh93X9HiDHytkcrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJCQCtQs+z6rso4pc7CgRSia4tM5KK=T8ckh93X9HiDHytkcrw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Brad Campbell <lists2009@fnarfbargle.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Aug 19, 2016 at 10:10:23AM -0600, Chris Murphy wrote:
> On Fri, Aug 19, 2016 at 6:46 AM, Chris Dunlop <chris@onthe.net.au> wrote:
>> On Fri, Aug 19, 2016 at 12:52:21PM +0100, Wols Lists wrote:
>>> On 18/08/16 05:01, Chris Dunlop wrote:
>>>> I'm interested to see if there's a way of essentially doing the above on a
>>>> live system, assuming there's appropriate care taken to not trash any
>>>> existing data (including superblocks).
>>>>
>>>> I.e. is it *theoretically* possible to write the same data back to the whole
>>>> disk safely. E.g. using 'dd' from/to the same disk is almost there, but, as
>>>> described, there's a window of opportunity where you could get stale data on
>>>> the disk and a raid repair could then copy that stale data to the good disk.
[snip]
>> If I do my 'dd' to write everything as previously described, with the window
>> of opportunity for stale data to end up on the written disk, one option
>> would to run a scrub / repair to check the data is the same - but if I'm
>> unlucky with my dd and the data isn't the same for some sector[s], I want to
>> ensure the correct data is copied over the stale data and not the other way
>> around, e.g. to specify "in the event of a mismatch, use the data from sda
>> and overwrite the data on sdb".
>>
>> Unfortunately I don't know how that can be done.
>>
>> Does anyone know?
> 
> Basically you want what Btrfs balance does, except simpler: rather
> than relocating extents into new allocation groups, you just want to
> read and rewrite everything as it is.

Sorry, I'm not familiar with btrfs at that level.

> You definitely can't do this with dd when md + mounted file system,
> that's inevitably going to result in the file system making changes
> after this operation has done a read, and therefore its write will
> clobber the file system's modifications. It'll be data loss at a
> minimum, and if it's file system metadata, it'll be worse in that
> it'll make the file system inconsistent.

I'm not convinced it's "inevitable" given the window between reading and
writing can be relatively small, and the filesystem would have to write
to those specific sectors during that window. But, yes, that's the
issue, there's certainly a chance of it happening.

> Further it's a problem overwriting good data, not accounting for the
> possibility of a crash or power failure.  You'd really want this
> operation to be CoW, so that the good data is effectively duplicated
> somewhere else and only once that operation is on stable media would
> it be pointed to, and the original data turned to free space.

It's raid-1, so I have good data at all times, on the disk I'm not
dd'ing to (sda). The problem is there may stale data on the disk dd'ed
to (sdb) due to the window of opportunity described previously, i.e. dd
reads data A from sda:X (sector X), the system writes data B to md0:X
(i.e. to both sda:X and sdb:X), then dd writes stale data A to sdb:X,
putting the disks out of sync.

In fact, the stale data problem is a larger problem than I first
thought: it's not only an issue when doing a repair (i.e. how to tell md
to use the data on the "good" disk in the event of discrepancies), but
also whilst the dd is underway: if you happen to issue a read to a
sector which has good data on one disk but stale data on the other, I
don't know if there's a way to ensure md reads the data on the "good"
disk.

So, in fact, I guess the facility I'm looking for, is a "write only"
flag for that disk, until a repair can be done (assuming the repair also
honours the "write only" flag.

Oh hey, from linux/Documentation/md.txt:

  state
    A file recording the current state of the device in the array
    which can be a comma separated list of
      ...
      writemostly - device will only be subject to read requests if
                    there are no other options. This applies only to
                    raid1 arrays.

I think that's *almost* exactly what I need, but to be safe I think I
really want something like:

  writeonly - no reads will be issued to this drive. If reads can't
              be satisfied from other drives, the array will be failed.

Then again, I guess in the end what I'd really like is to be able to
flag a particular disk to md for "write repair", and tell md to repair.
Then md would read data from unflagged disks to write to the flagged
disk (that could work for parity raids as well as mirrors).

This has the advantage, like "mdadm --replace", that you retain
redundancy at all times whilst still writing to the entire disk. The
advantage over "madm --replace" would be that you don't require another
disk.

But, in the absence of sufficient time and kernel knowledge to add
"write repair" to md myself, I'm interested to see if it can be done at
the user level.

> I'm not really understanding the use case of why you'd want to do
> this. At a fundamental level it sounds like you don't trust the
> devices the data resides on. If that's true, then there are related
> concerns that aren't mitigated by this rewrite feature alone.

My immediate use case is to try to clear the "pending sector" count by
writing to every sector on the disk. The pending sector count indicates
"something" went wrong at some point: it could be a permanent error
(e.g. disk surface is dodgy) or a soft error (e.g. a power supply droop
during a write). I.e. it may or may not indicate the disk itself is
going bad. If the count clears (either by confirming the sector is
good, or reallocating if the sector is really rubbish), I have a
confirmed good disk and life goes on. If something turns up during the
write attempt, I know the disk is bad and I can schedule a replacement.

As stated at the beginning, I know the safest way to do this is to add
in another disk, do a 'mdadm --replace', and then remove the suspect
disk and play with it as much as I like.

As a matter of interest I'm looking to see if there's a safe way of
doing it whilst the disk is online and live. Safe, that is, in that the
data is as safe as it would be on a normally functioning array, *if*
everything is done correctly.

So it's a "hey, it would be good if this can be done" issue rather than
a "help me, I'm afraid I might lose some data!" problem.

Cheers,

Chris
