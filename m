From: Doug Dumitru <doug@easyco.com>
Subject: Re: RAID1 round robin read support in md?
Date: Sun, 4 Dec 2011 21:53:26 -0800
Message-ID: <CAFx4rwRKUvVaJtCv=+qurYp9C7V5iJKn0MhO-aJFsB3Fs5VjEw@mail.gmail.com>
References: <CAAs5ODuHAE=K-nbd=YuMq-FL33x-22TM2cnmBHud9mEhwuJFOw@mail.gmail.com>
	<CALFpzo48C2-HHgw=iOefdHaAUCwEJfjoiXjq=Ngv62a-0yEpcQ@mail.gmail.com>
	<CAAs5ODv01LE6HRZjteYYsaMF5stTNv-8pdK9JDP18u4QeNGUOQ@mail.gmail.com>
	<CALFpzo7WqkXNF9DcCNJn_D1ZP=Jgpb85u6H=5_KPONQMy7FpYQ@mail.gmail.com>
	<CAAs5ODtObyOaSebofD-Kf2HcYU_7zRv0+oUmWPnnzU=gYn24Ug@mail.gmail.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAs5ODtObyOaSebofD-Kf2HcYU_7zRv0+oUmWPnnzU=gYn24Ug@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Borg Onion <borg.onion@gmail.com>
Cc: Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

What you are seeing is very SSD specific.

With rotating media, it is very important to intentionally stay on one
disk even if it leaves other mirrors quiet.  Rotating disks do "in the
drive" read-ahead and take advantage of the heads being on the correct
track, so streaming straight-line reads are efficient.

With SSDs in an array, things are very different.  Drives don't really
read ahead at all (actually they do, but this is more of a side effect
of error correction than performance tuning, and the lengths are
short).  If your application is spitting out 4MB read requests, they
get cut into 512K (1024 sector) bio calls, and sent to a single drive
if they are linear.  Because the code is optimized for HDDs, future
linear calls should go to the same drive because an HDD is very likely
to have at least some of the read sectors in the read-ahead cache.

A different algorithm for SSDs would be better, but one concern is
that this might slow down short read requests in a multi-threaded
environment.  Actually managing a mix intelligently is probably best
started with a Google literature search for SSD scheduling papers.  I
suspect that UCSD's super-computing department might have done some
work in this area.

With the same data available from two drives, for low thread count
applications, it might be better to actually cut up the inbound
requests into even smaller chunks, and send them in parallel to the
drives.  A quick test on a Crucial C300 shows the following transfer
rates at different block sizes.

512K  319 MB/sec
256K  299 MB/sec
128K  298 MB/sec
64K  287 MB/sec
32K  275 MB/sec

This is with a single 'dd' process and 'iflag=direct' bypassing linux
read-ahead and buffer caching.  The test was only a second long or so,
so the noise could be quite high.  Also, C300s may behave very
differently with this workload than other drives, so you have to test
each type of disk.

What this implies is that if the md raid-1 layer "were to be" SSD
aware, it should consider cutting up long requests and keeping all
drives busy.  The logic would be something like:

* If any request is >= 32K, split it into 'n' parts', and issue them
in parallel.

This would be best implemented "down low" in the md stack.
Unfortunately, the queuing where requests are collated, happens below
md completely (I think), so there is no easy point to insert this.

The idea of round-robin scheduling the requests is probably a little
off-base.  The important part is, with SSDs, to cut up the requests
into smaller sizes, and push them in parallel.  A round-robin might
trick the scheduler into this sometimes, but is probably only an
edge-case solution.

This same logic applies to raid-0, raid-5/6, and raid-10 arrays.  With
HDDs is is often more efficient to keep the stripe size large so that
individual in-drive read-ahead is exploited.  With SSDs, smaller
stripes are often better (at least on reads) because it tends to keep
all of the drive busy.

Now it is important to note that this discussion is 100% about reads.
SSD writes are a much more complicated animal.

--
Doug Dumitru
EasyCo LLC
