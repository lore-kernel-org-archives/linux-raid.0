From: Doug Dumitru <doug@easyco.com>
Subject: Create Lock to Eliminate RMW in RAID/456 when writing perfect stripes
Date: Wed, 23 Dec 2015 11:20:51 -0800
Message-ID: <CAFx4rwR1gtLZUF6MUx71QTvw3hT5GKhsEMU2xcBpAz5wZWBUCw@mail.gmail.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The issue:

The background thread in RAID-5 can wake up in the middle of a process
populating stripe cache entries with a long write.  If the long write
contains a complete stripe, the background thread "should" be able to
process the require without doing any reads.

Sometimes the background thread is too quick at starting up a write
and schedules a RMW (Read Modify Write) even though the needed blocks
will soon be available.

Seeing this happen:

You can see this happen by creating an MD set with a small stripe size
and then doing DIRECT_IO writes that are exactly aligned on a stripe.
For example, with 4 disks and 64K stripes, write 192K blocks aligned
on 192K boundaries.  You can do this from C or with 'dd' or 'fio'.

If you have this running, you can then run iostat and you should see
absolutely no read activity on the disks.

The probability of this happening goes up when there are more disks.
It may also go up the faster the disks are.  My use case is 24 SSDs.

The problem with this:

There are really three issues.

1)  The code does not need to work this way.  It is not "broken" but
just seems wrong.
2)  There is a performance penalty here.
3)  There is a Flash wear penalty here.

It is 3) that most interests me.

The fix:

Create a waitq or semaphore based lock so that if a write includes a
complete stripe, the background thread will wait for the write to
completely populate the thread.

I would do this with a small array of locks.  When a write includes a
complete stripe, it sets a lock (stripe_number % sizeof_lock_array).
This lock is released as soon as the write finishes populating the
stripe cache.  The background thread checks this lock before it starts
a write.  If the lock is set, it waits until the stripe cache is
completely populated which should eliminate the RMW.

If no writes are full stripes, then the lock never gets set, so most
code runs without any real overhead.

Implementing this:

I am happy to implement this.  I have quite a bit of experience with
lock structures like this.  I can also test on x86 and x86_64, but
will need help with other arch's.

Then again, if this is too much of an "edge case", I will just keep my
patches in-house.

-- 
Doug Dumitru
WildFire Storage
