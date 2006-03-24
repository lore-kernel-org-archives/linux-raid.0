From: Alex Izvorski <aizvorski@gmail.com>
Subject: Re: raid5 high cpu usage during reads
Date: Fri, 24 Mar 2006 01:02:29 -0800
Message-ID: <1143190949.9100.145.camel@starfire>
References: <loom.20060323T003324-767@post.gmane.org>
	 <17441.59458.918847.175664@cse.unsw.edu.au>
	 <1143175107.7404.88.camel@starfire>
	 <17443.30677.822868.981690@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17443.30677.822868.981690@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2006-03-24 at 15:38 +1100, Neil Brown wrote:
> On Thursday March 23, aizvorski@gmail.com wrote:
> > Neil - Thank you very much for the response.  
> > 
> > In my tests with identically configured raid0 and raid5 arrays, raid5
> > initially had much lower throughput during reads.  I had assumed that
> > was because raid5 did parity-checking all the time.  It turns out that
> > raid5 throughput can get fairly close to raid0 throughput
> > if /sys/block/md0/md/stripe_cache_size is set to a very high value,
> > 8192-16384.  However the cpu load is still very much higher during raid5
> > reads.  I'm not sure why?
> 
> Probably all the memcpys.
> For a raid5 read, the data is DMAed from the device into the
> stripe_cache, and then memcpy is used to move it to the filesystem (or
> other client) buffer.  Worse: this memcpy happens on only one CPU so a
> multiprocessor won't make it go any after.
> 
> I would be possible to bypass the stripe_cache for reads from a
> non-degraded array (I did it for 2.4) but it is somewhat more complex
> in 2.6 and I haven't attempted it yet (there have always been other
> more interesting things to do).
> 
> To test is this is the problem you could probably just comment-out the
> memcpy (the copy_data in handle_stripe) and see if the reads go
> faster.  Obviously you will be getting garbage back, but it should
> give you a reasonably realistic measure of the cost.
> 
> NeilBrown

Neil - Thank you again for the suggestion.  I did as you said and
commented out copy_data() and ran a number of tests with the modified
kernel.  The results are in a spreadsheet-importable format at the end
of this email (let me know if I should send them in some other way).  In
short, this gives a fairly consistent 20% reduction in CPU usage under
max throughput conditions, i.e. typically that accounts for just over
half the difference in CPU usage between raid0 and raid5, everything
else being equal.  By the way, on the same machine memcpy() benchmarks
at ~1GB/s, so if the data being is read at 200MB/s and copied once that
would be about 10% CPU load - perhaps the data actually gets copied
twice?  That would be consistent.

Anyway, it seems copy_data() is definitely part of the answer, but not
the whole answer.  In the case of 32MB stripes, something else uses up
to 60% of the CPU time.  Perhaps some kind of O(n^2) scalability issue
in the stripe cache data structures?  I'm not positive, but it seems the
hit outside copy_data() is particularly large in situations in which
stripe_cache_active returns large numbers.

How hard is it to bypass the stripe cache for reads?  I would certainly
lobby for you to work on that ;) since without it raid5 is only really
suitable for database-type workloads, not multimedia-type workloads
(again bearing in mind that a full-speed read by itself uses up an
entire high-end CPU or more - you can understand why I thought it was
calculating parity ;)  I'll do what I can to help, of course.

Let me know what other tests I can run.

Regards,
--Alex




"raid level"|"num disks"|"chunk size, kB"|"copy_data disabled"|"stripe
cache size"|"block read size, MB"|"num concurrent reads"|"throughput,
MB/s"|"cpu load, %"
raid5|8|64|N|8192|8|14|186|35
raid0|7|64|-|-|8|14|243|7
raid5|8|64|N|8192|256|1|215|38
raid0|7|64|-|-|256|1|272|7
raid5|8|256|Y|8192|8|14|201|17
raid5|8|256|N|8192|8|14|200|40
raid0|7|256|-|-|8|14|241|4
raid5|8|256|Y|8192|256|1|221|17
raid5|8|256|N|8192|256|1|218|40
raid0|7|256|-|-|256|1|260|6
raid5|8|1024|Y|8192|8|14|207|20
raid5|8|1024|N|8192|8|14|206|40
raid0|7|1024|-|-|8|14|243|5
raid5|8|32768|Y|16384|8|14|227|60
raid5|8|32768|N|16384|8|14|208|80
raid0|7|32768|-|-|8|14|244|15
raid5|8|32768|Y|16384|256|1|212|25
raid5|8|32768|N|16384|256|1|207|45
raid0|7|32768|-|-|256|1|217|10


