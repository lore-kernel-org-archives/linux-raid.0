From: Alex Izvorski <aizvorski@gmail.com>
Subject: Re: raid5 that used parity for reads only when degraded
Date: Thu, 23 Mar 2006 20:38:27 -0800
Message-ID: <1143175107.7404.88.camel@starfire>
References: <loom.20060323T003324-767@post.gmane.org>
	 <17441.59458.918847.175664@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17441.59458.918847.175664@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil - Thank you very much for the response.  

In my tests with identically configured raid0 and raid5 arrays, raid5
initially had much lower throughput during reads.  I had assumed that
was because raid5 did parity-checking all the time.  It turns out that
raid5 throughput can get fairly close to raid0 throughput
if /sys/block/md0/md/stripe_cache_size is set to a very high value,
8192-16384.  However the cpu load is still very much higher during raid5
reads.  I'm not sure why?

My test setup consists of 8x WD4000RE 400GB SATA disks, a 2.4GHz
Athlon64X2 cpu and 2GB RAM, kernel 2.6.15 and mdadm 2.3.  I am using my
own simple test application which uses POSIX aio to do randomly
positioned block reads.  When doing 8mb block reads, 14 outstanding io
requests, from a 7-disk raid0 with 1mb chunk size I get 200MB/s
throughput and ~5% cpu load.  When running the same on an 8-disk raid5
with the same chunk size (which I'd expect to have identical
performance, as per what you describe as the behaviour of a non-degraded
raid5) with default stripe_cache_size of 256 I get a mere 60MB/s and a
cpu load of ~12%.  Increasing the stripe_cache_size to 8192 brings the
throughput to approximately 200MB/s or the same as for the raid0, but
the cpu load jumps to 45%.  Some other combinations of parameters, e.g.
32MB chunk size and 4MB reads with stripe_cache_size of 16384 result in
even more pathological cpu loads, over 80% (that is: 80% of both cpus!)
with throughput still at approx 200MB/s.  As a point of comparison the
same application reading directly from the raw disk devices with the
same settings achieves a total throughput of 300MB/s and a cpu load of
3%, so I am pretty sure the SATA controllers or drivers etc are not a
factor.  Also the cpu load is measured with Andrew Morton's cyclesoak
tool which I believe to be quite accurate.

Any thoughts on what could be causing the high cpu load?  I am very
interested in helping debug this since I really need a high-throughput
raid5 with reasonably low cpu requirements.  Please let me know if you
have any ideas or anything you'd like me to try (valgrind, perhaps?).
I'd be happy to give you more details on the test setup as well.

Sincerely,

--Alex

On Thu, 2006-03-23 at 11:13 +1100, Neil Brown wrote:
> On Wednesday March 22, aizvorski@gmail.com wrote:
> > Hello,
> > 
> > I have a question: I'd like to have a raid5 array which writes parity data but
> > does not check it during reads while the array is ok.  I would trust each disk
> > to detect errors itself and cause the array to be degraded if necessary, in
> > which case that disk would drop out and the parity data would start being used
> > just as in a normal raid5.  In other words until there is an I/O error that
> > causes a disk to drop out, such an array would behave almost like a raid0 with
> > N-1 disks as far as reads are concerned.  Ideally this behavior would be
> > something that one could turn on/off on the fly with a ioctl or via a echo "0" >
> > /sys/block/md0/check_parity_on_reads type of mechanism.  
> > 
> > How hard is this to do?   Is anyone interested in helping to do this?  I think
> > it would really help applications which have a lot more reads than writes. 
> > Where exactly does parity checking during reads happen?  I've looked over the
> > code briefly but the right part of it didn't appear obvious ;)
> 
> Parity checking does not happen during read.  You already have what
> you want.
> 
> NeilBrown





