From: Doug Dumitru <doug@easyco.com>
Subject: Re: Absymal performance of O_DIRECT write on parity raid
Date: Thu, 30 Dec 2010 21:36:37 -0800
Message-ID: <AANLkTinm=1Nu2L3dLBqBsZ+QKu=XJN=SQL0wWAB2JvOA@mail.gmail.com>
References: <4D1D5D7A.6010804@shiftmail.org>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D1D5D7A.6010804@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Spelic <spelic@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

A couple of comments.

=46irst, your test stripe size is very large.  With 6 disks raid-5 and
1M chunks, you need 5MB of IO to fill a stripe.  With direct IO, the
IO must complete and "sync" before dd continues.  Thus each 1M write
will do reads from 4 drives and then 2 writes.  I am not sure about
iostat not seeing this.  I ran this here against 8 SSDs.

test file:  1G of random data copied from /dev/urandom into /dev/shm
(ssds can vary speed based on data content, hdds don't tend to act
this way).
array:  /dev/md0 - 8 Indilinx SSDs  1024K chunk size.  raid 5.
test:  dd if=3D/dev/shm/rand.1b of=3D/dev/md0 bs=3D1M oflag=3Ddirect
result:  56.6 MB/s

here a 2 second iostat snapshot during the dd looks like:

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await  svctm  %util
sdb            1382.00  2990.50  157.00  291.00     6.31    13.00
88.29     1.66    3.78   0.41  18.55
sdc            1265.00  2309.50  144.00  203.50     5.50     9.89
90.73     1.16    3.33   0.45  15.60
sdd            1473.50  2688.00  190.50  283.00     6.50    11.53
78.00     0.98    2.07   0.31  14.85
sde            1497.50  3128.50  166.50  327.50     6.50    13.50
82.91     2.46    4.98   0.48  23.65
sdf            1498.00  3133.00  166.00  323.00     6.50    13.50
83.76     1.74    3.56   0.42  20.30
sdg            1482.00  3127.50  182.00  328.50     6.50    13.50
80.24     1.04    2.03   0.31  15.95
sdh            1464.50  3033.00  163.00  322.00     6.11    13.00
80.69     0.94    1.92   0.32  15.60
sdi            1488.00  3002.00  176.00  326.00     6.50    13.00
79.55     1.48    2.94   0.35  17.55
md0               0.00     0.00    0.00  454.50     0.00    50.50
227.56     0.00    0.00   0.00   0.00

so there are lots of RMWs going on.

If I do the same test with chunk set to 64K and bs set to 458752
(chunk size * 7 or /sys/block/md0/queue/optimal_io_size) the dd
improves to 250 MB/sec.

This is still a lot slower than "perfect" IO.  For these drives on
raid-5 perfect is about 700MB/sec.  I have hit 670 with in-house
patches (see another thread) to raid5.c, but these patches don't
translate down to user-space and programs like dd.

In general, if you want to run linear IO, you want to do IO at a
multiple of optimal_io_size.  If the chunk size is too large, then
optimal_io_size is way to big to fit in a single bio.

The other issue with oflag=3Ddirect is that with direct, you only have =
a
single IO outstanding before the next IO starts.  Again, testing with
SSDs, the raid/5 logic tends to schedule about 35 IOPS for small
random writes.  This is the raid layer waiting for additional IOs to
arrive before scheduling the RMW reads to back-fill the stripe cache
buffers.  Again, the issue is single-threaded operations and how they
get scheduled.

In terms of how this impacts application performance, it can get
complicated.  For single-threaded apps that do direct IO, the number
you are seeing are real.  If the app does multi-threaded IO, then the
numbers are real, but for each thread independently.  Again, with SSDs
raid/5 can hit 18,000 write IOPS (with really good drives) if the
queue depth is really deep.  Mind you raid-10 can hit 80,000 IOPS and
front-end FTLs (Flash Translation Layers) in software over raid/5 (see
http://www.managedflash.com) can hit 250,000 IOPS with the same
drives.  It is all about scheduling and keeping the drives busy moving
meaningful data.

Bottom line is that the current raid-5 code is doing the best it can.
It's real issue is knowing when IO is random and when it is linear in
that all it "sees" is inbound un-associated block requests.  The
problem becomes when to "pull the trigger" and assume IO is random
when it might help to wait for some more linear blocks.  There is talk
"now and again" about adding a write cache to raid/456.
Unfortunately, without some non-volatile memory (think hardware raid
with batteries to backup RAM), a bad shutdown will kill data left and
right if the raid code re-orders writes and crashes.

Perhaps what is needed is a new bio status bit to let the layers know
that the request is complete and needs "pushed" immediately.
Unfortunately, such a change is a "big deal" and requires about every
app to become "aware" in order for it to help.

Doug


On Thu, Dec 30, 2010 at 8:35 PM, Spelic <spelic@shiftmail.org> wrote:
>
> Hi all linux raiders
>
> on kernel 2.6.36.2, but probably others, performances of O_DIRECT are=
 absymal on parity raid, compared to nonparity raid
>
> And this is NOT due to the RMW apparently! (see below)
>
> With dd bs=3D1M to the bare MD device, a 6-disk raid5 1024k chunk, I =
obtain 2.1MB/sec on raid5 while the same test onto a 4-disk raid10 goes=
 at 160MB/sec (80 times faster).
> even with stripe_cache_size to the max.
> Nondirect writes to the arrays are at about 250MB/sec for raid5, and =
about 180MB/sec for raid10.
> With bs=3D4k directio it's 205KB/sec on the raid5 vs 28MB/sec on the =
raid10 (136 times faster)
>
> This does NOT seem due to the RMW, because from the second time on MD=
 does *not* read from the disks anymore (checked with iostat -x 1)
> (BTW how do you clear that cache? echo 3 > /proc/sys/vm/drop_cache do=
es not appear to work)
>
> It's so bad it looks like a bug. Could you please have a look at this=
?
> There are many important stuff that use o_direct, in particular:
> - LVM, I think, especially pvmove and mirror creation, which are impo=
ssibly slow on parity raid
> - Databases (ok I understand we should use raid10 but the difference =
should not be SO great!)
> - Virtualization. E.g. KVM wants bare devices for high performance, w=
ants to do direct io. Go figure.
>
> With such a bad worst-case for o_direct we seriously risk to need to =
abandon MD parity raid completely
> Please have a look
>
> Thank you
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

--
Doug Dumitru
EasyCo LLC
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
