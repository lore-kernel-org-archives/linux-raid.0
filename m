From: "Patrick J. LoPresti" <lopresti@gmail.com>
Subject: raid5/raid6 write performance question
Date: Thu, 17 Feb 2011 10:52:07 -0800
Message-ID: <AANLkTinRCMJq3bt5jmQfJ1PRfN1S-ZoJB0HXeMzFeqSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a fair amount of experience with hardware RAID devices, but now
I am investigating Linux software RAID and I have a question.  Well, a
few questions.

The classic problem for RAID5/RAID6 write performance, especially when
striping across many drives, is that a single small write requires
reading in the entire stripe from all disks to calculate the new
syndrome block(s).

Hardware RAID controllers typically mitigate this problem by using a
sizable (512MiB - 4GiB) non-volatile write-back cache, in the hopes
that enough blocks will be written in a short period of time to
populate an entire stripe.  Once an entire stripe is in the write-back
cache, it can be written out with its syndrome blocks without having
to read anything.

Of course, the cache has to be non-volatile (battery backed or solid
state), because the kernel is expecting stuff it has written to disk
not to vanish because of a power failure.

My question is this:  How does Linux RAID5/RAID6 avoid reading an
entire stripe every time the kernel flushes a single page?  Does it
have a (volatile?) cache?  Or does it rely on the kernel flushing lots
of contiguous data in a single request?  Or something else?

Does Linux RAID keep track of which disk blocks have already been
written at least once, so that there is a difference between writing a
block for the first time and updating it later?  (But I guess that
would not make sense, since eventually all writes become updates as
files are created and deleted.)

Thanks.

 - Pat
