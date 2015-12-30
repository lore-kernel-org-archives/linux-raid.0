From: Doug Dumitru <doug@easyco.com>
Subject: Re: Create Lock to Eliminate RMW in RAID/456 when writing perfect stripes
Date: Wed, 30 Dec 2015 11:28:39 -0800
Message-ID: <CAFx4rwQDX-Eu+b1Jv_OToUduwM_prRy_2YWp2=ptnS3UCv1c1Q@mail.gmail.com>
References: <CAFx4rwR1gtLZUF6MUx71QTvw3hT5GKhsEMU2xcBpAz5wZWBUCw@mail.gmail.com>
 <87h9j7yn5x.fsf@notabene.neil.brown.name>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87h9j7yn5x.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <nfbrown@novell.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

A new lock for RAID-4/5/6 to minimize read/modify/write operations.

The Problem:  The background thread for raid can wake up
asynchronously and will sometimes wake up and start processing a write
before the writing thread has finished updating the stripe cache
blocks.  If the calling thread write was a long write (longer than
chunk size), then the background thread will configure a raid write
operation that is sub-optimal resulting in extra IO operations, slower
performance, and higher wear on Flash storage.

The Easy Fix:  When the calling thread has a long write, it "locks"
the stripe number with a semaphore.  When the background thread wakes
up and starts working on a stripe, it locks the same lock, and then
immediately releases it.  This way the background thread will wait for
the write to fully populate the stripe caches before it start to build
a write request.

The Lock Structure:  ... is just a small, binary sized, array of
semaphores.  The lock is picked by just "stripe_number %
number_of_semaphores".  There will be collisions, but they should be
short and lots of IO is happening for each operation, so a semaphore
is cheap enough.

Memory Usage:  With 64 semaphores, this adds 1.5K to the raid control block.

A More Comprehensive Fix:  This Easy Fix assumes that updates are
contained within a single BIO request.  A better fix is to lock linear
operations that span BIOs by looking back on the queue.  I don't have
a lot of experience playing with queues, but this is probably workable
with only a little more complexity, provided that you don't try to do
this across cores and queues.  Again, I don't play much in queues, so
I may be totally missing the structures here.

The Really High Performance Fix:  If the application is well enough
behaved to write complete, perfect stripes contained in a single BIO
request, then the whole stripe cache logic can be bypassed.  This lets
you submit the member disk IO operations directly from the calling
thread.  I have this running in a patch in the field and it works
well, but the use case is very limited and something probably breaks
with more "normal" IO patterns.  I have hit 11GB/sec with RAID-5 and
8GB/sec with RAID-6 this way with 24 SSDs.

Tweak-ability:  All of these changes can be exposed in /sys to allow
sysadmins to tune their system possibly enabling or disabling
features.  Most useful for early code that might have broken use
cases.  Then again, too many knobs sometimes just increases confusion.

Asking for Feedback:  I am happy to write "all of the above" and
submit it and work with the group to get it tested etc.  If this
interests you, please comment on how far you think I should go.  Also,
if there are any notes on "submission style", how and where to post
patches, which kernel version to patch/develop against, documentation
style, sign-off requirements, etc. please point me at them.

Thanks in advance,

Doug Dumitru
WildFire Storage
