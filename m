From: Dan Christensen <jdc@uwo.ca>
Subject: Re: RAID-5 streaming read performance
Date: Wed, 13 Jul 2005 23:58:50 -0400
Message-ID: <87r7e23uo5.fsf@uwo.ca>
References: <874qb14btr.fsf@uwo.ca>
 <1121220487.5552.34.camel@localhost.localdomain> <87mzorfmdx.fsf@uwo.ca>
 <1121257494.5504.4.camel@localhost.localdomain> <87eka2g9dp.fsf@uwo.ca>
 <1121259126.5504.14.camel@localhost.localdomain> <87vf3eeqe2.fsf@uwo.ca>
 <42D5573A.6090801@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <42D5573A.6090801@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>, Linux RAID <linux-raid@vger.kernel.org>
Cc: mingz@ele.uri.edu
List-Id: linux-raid.ids

David Greaves <david@dgreaves.com> writes:

> In my setup I get
>
> component partitions, e.g. /dev/sda7: 39MB/s
> raid device /dev/md2:                 31MB/s
> lvm device /dev/main/media:           53MB/s
>
> (oldish system - but note that lvm device is *much* faster)

Did you test component device and raid device speed using the
read-ahead settings tuned for lvm reads?  If so, that's not a fair
comparison.  :-)

> For your entertainment you may like to try this to 'tune' your readahead
> - it's OK to use so long as you're not recording:

Thanks, I played around with that a lot.  I tuned readahead to
optimize lvm device reads, and this improved things greatly.  It turns
out the default lvm settings had readahead set to 0!  But by tuning
things, I could get my read speed up to 59MB/s.  This is with raw
device readahead 256, md device readahead 1024 and lvm readahead 2048.
(The speed was most sensitive to the last one, but did seem to depend
on the other ones a bit too.)

I separately tuned the raid device read speed.  To maximize this, I
needed to set the raw device readahead to 1024 and the raid device
readahead to 4096.  This brought my raid read speed from 59MB/s to
78MB/s.  Better!  (But note that now this makes the lvm read speed
look bad.)

My raw device read speed is independent of the readahead setting,
as long as it is at least 256.  The speed is about 58MB/s.

Summary:

raw device:  58MB/s
raid device: 78MB/s
lvm device:  59MB/s

raid still isn't achieving the 106MB/s that I can get with parallel
direct reads, but at least it's getting closer.

As a simple test, I wrote a program like dd that reads and discards
64k chunks of data from a device, but which skips 1 out of every four
chunks (simulating skipping parity blocks).  It's not surprising that
this program can only read from a raw device at about 75% the rate of
dd, since the kernel readahead is probably causing the skipped blocks
to be read anyways (or maybe because the disk head has to pass over
those sections of the disk anyways).

I then ran four copies of this program in parallel, reading from the
raw devices that make up my raid partition.  And, like md, they only
achieved about 78MB/s.  This is very close to 75% of 106MB/s.  Again,
not surprising, since I need to have raw device readahead turned on
for this to be efficient at all, so 25% of the chunks that pass
through the controller are ignored.

But I still don't understand why the md layer can't do better.  If I
turn off readahead of the raw devices, and keep it for the raid
device, then parity blocks should never be requested, so they
shouldn't use any bus/controller bandwidth.  And even if each drive is
only acting at 75% efficiency, the four drives should still be able to
saturate the bus/controller.  So I can't figure out what's going on
here.

Is there a way for me to simulate readahead in userspace, i.e. can
I do lots of sequential asynchronous reads in parallel?

Also, is there a way to disable caching of reads?  Having to clear
the cache by reading 900M each time slows down testing.  I guess
I could reboot with mem=100M, but it'd be nice to disable/enable
caching on the fly.  Hmm, maybe I can just run something like
memtest which locks a bunch of ram...

Thanks for all of the help so far!

Dan
