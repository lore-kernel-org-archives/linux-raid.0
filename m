From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Is this expected RAID10 performance?
Date: Sun, 09 Jun 2013 19:02:20 -0500
Message-ID: <51B5178C.5050900@sandeen.net>
References: <CAO9HMNHVNQcU=FumFnLRd9b0msMr8fr0z6SmL82dksu+6CNXYA@mail.gmail.com> <51B47088.4000501@redhat.com> <CAO9HMNHPeXiMmXYtPb29Y2xiOFpznzmP8nBSV09UFCnMrYkEgQ@mail.gmail.com> <loom.20130610T000503-316@post.gmane.org> <CAO9HMNGwdLG7ubNP1gC7To9pNstuwZPDAeV03HDkUjh5MWB0Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO9HMNGwdLG7ubNP1gC7To9pNstuwZPDAeV03HDkUjh5MWB0Dg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 6/9/13 6:34 PM, Steve Bergman wrote:
> Hi Eric,
> 
> Yes, I understand what you are saying about the interaction between
> ordered data mode and DA in ext4. It's the combination of the 2
> options that makes the difference. Merely having a switch to turn off
> DA on XFS would not get me what I need for my data volumes. But thank
> you for making that explicit.
> 
> I intentionally disable DA on my ext4 data volumes specifically to get
> ext3-like behavior which results in a night and day difference in
> resiliency during... difficult times... for many of my customers, in
> my repeated experiences. I could just use ext3. But why give up
> extents, multiblock allocation, CRC protection of the journal, etc?
> (BTW, that's my vote *not* to remove the nodelalloc option of ext4 as
> I noticed you and Ted discussing last April. ;-)

I don't recommend nodelalloc just because I don't know that it's thoroughly
tested.  Anything that's not the default needs explicit and careful
test coverage to be sure that regressions etc. aren't popping up.

(One of ext4's weaknesses, IMHO, is its infinite matrix of options,
with wildly different behaviors.  It's more a filesystem multiplexer
than a filesystem itself.  ;)  Add enough knobs and there's no way you
can get coverage of all combinations.)

> So on a set of Cobol C/ISAM files which never get fsync'd or
> fdatasync'd, (because that concept does not exist in Cobol) would you
> expect there to be any difference in the resiliency of ext4 and xfs
> with both filesystems at completely default settings?

So back to the main point of this thread.

You probably need to define what _you_ mean by resiliency.  I have a hunch
that you have different, and IMHO unfounded, expectations.

I'm using a definition of resiliency for this conversation like this:

For properly configured, non-dodgey storage, 

1) Is metadata journaled such that the filesystem metadata is consistent
   after a crash or power loss, and fsck finds no errors?

and

2) Is data persistent on disk after either a periodic flush, or a data
   integrity syscall?

The answer to both had better be yes on ext3, ext4, xfs, or any other
journaling filesystem worth its salt.  If the answer is no, it's a broken
design or a bug.

And the answer for ext3, ext4, and xfs, barring the inevitable bugs that
come up from time to time on all filesystems, is yes, 1) and 2) are
satisfied.

Anything else you want in terms of data persistence (data from my careless
applications will be safe no matter what) is just wishful thinking.

> Or would it be
> about the same. I'm *very* interested in this topic, as I'd like the
> best speed and more filesystem options, but need the resiliency even
> more for many of my servers. Do I have an option with XFS to improve
> behavior on/after an unclean shutdown? If so, I'd sincerely like to
> know.

What you seem to want is an vanishingly small window for risk of data
loss for unsynced, buffered IO.

ext3 gave you about 5 seconds thanks to default jbd behavior and
data=ordered behavior.  ext4 & xfs are more on the order of
30s.

But this all boils down to:

Did you (or your app) fsync your data?  If not, you cannot guarantee
that it'll be there if you crash or lose power.  The window for risk
of loss depends on many things, but without data integrity syscalls,
there is a risk of data loss.  See also http://lwn.net/Articles/457667/

You said to Ric:

> I find that in practice, simply leaving the data volumes in
> data=ordered mode and turning off DA results in -osync-like
> data integrity.

It quite simply does not.  Write a new file, punch power 1-2s after
the write completes, reboot and see what you've got.  You're racing
against jbd2 waking up and getting work done, but most of the time,
you'll have data loss.

If you want a smaller window of opportunity for data loss, there
are plenty of tuneables at the fs & vm level to push data towards
disk more often, at the expense of performance.

Without data integrity syscalls, you're always exposed to a greater
or lesser degree.

(It'd probably be better to take this up on the filesystem lists,
since we've gotten awfully off-topic for linux-raid.  But I feel
like this is a rehash of the O_PONIES thread from long ago...)

-Eric
