From: Doug Dumitru <doug@easyco.com>
Subject: Raid/5 optimization for linear writes
Date: Tue, 28 Dec 2010 19:38:07 -0800
Message-ID: <AANLkTinEuKzKxWTOY7Mpj207Y2t_mzjy9_8D5O5dP+Qe@mail.gmail.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I have been using an in-house mod to the raid5.c driver to optimize
for linear writes.=A0 The optimization is probably too specific for
general kernel inclusion, but I wanted to throw out what I have been
doing in case anyone is interested.

The application involves a kernel module that can produce precisely
aligned, long, linear writes.  In the case of raid-5, the obvious plan
is to issue writes that are complete raid stripes of
'optimal_io_length'.

Unfortunately, optimal_io_length is often less than the advertised max
io_buf size value and sometime less than the system max io_buf size
value.  Thus just pumping up the max value inside of raid5 is dubious.
 Even though dubious, just punching up the
mddev->queue->limits.max_hw_sectors does seem to work, not break
anything obvious, and does help performance out a little.

In looking at long linear writes with the stock raid5 driver, I am
seeing a small amount of reads to individual devices.  The test
application code calling the raid layer has > 100MB of locked kernel
buffer slamming the raid5 driver, so exactly why raid5 needs to
back-fill some reads is not very clear to me.  Looking at the raid5
code, it does not look like there is a real "scheduler" for deciding
when to back-fill the stripe cache, but instead it just relies on
thread round trips.  In my case, I am testing on server-class systems
with 8 or 16 3GHz threads, so availability of CPU cycles for the raid5
code is very high.

My patch ended up special casing a single inbound bio that contained a
write for a single full raid stripe.  So for 8 drives raid-5, this is
7 * 64K or an IO 448KB long.  With 4K pages this is a bi_io_vec array
of 112 pages.  Big for kernel memory generally, but easily handled by
server systems.  With more drives, you can be talking well over 1MB in
a single bio call.

The patch takes this special case write, makes sure it is raid-5 and
layout 2, is not degraded and is not migrating.  If all of these are
true, the code allocates a new bi_io_vec and pages for the parity
stripe, new bios for each drive, computes parity "in thread", and then
issues simultanious IOs to all of the devices.  A single bio complete
function catches any errors and completes the IO.

My testing is all done using SSDs.  I have tests for 8 drives and for
32 partition on the 8 drives.  The drives themselves do about
100MB/sec per drive.  With the stock code I tend to get 550 MB/sec
with 8 drives and 375 MB/sec with 32 partitions on 8 drives.  With the
patch, both 8 and 32 yield about 670 MB/sec which is within 5% of
theoretical bandwidth.

My "fix" for linear writes is probably way to "miopic" for general
kernel use, but it does show that properly fed, really big raid/456
arrays should be able to crank linear bandwidth far beyond the current
code base.

What is really needed is some general technique to give the raid
driver a "hint" that an IO stream is linear writes so that it will not
try to back-fill too eagerly.  Exactly how this can make it back up
the bio stack is the real trick.

I am happy to discuss this on-list or privately.

--
Doug Dumitru
EasyCo LLC

ps:  I am also working on patches to propagate "discard" requests
through the raid stack, but don't have any operational code yet.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
