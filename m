From: Chris Knipe <savage@savage.za.org>
Subject: Correct RAID options
Date: Tue, 19 Aug 2014 20:38:52 +0200
Message-ID: <027801cfbbdc$d33970f0$79ac52d0$@savage.za.org>
Reply-To: <savage@savage.za.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-za
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

I'm sitting with a bit of a catch 22 and need some feedback / inputs please.
This isn't strictly md related as all servers has MegaRAID SAS controllers
with BBUs and I am running hardware raid.  So my apologies about the off
topic posting, but the theory remains the same I presume.   All the servers
store millions of small (< 2mb) files, in a structured directory structure
to keep the amount of files per directory in check.

Firstly, I have a bunch (3) of front end servers, all configured in RAID10
and consisting of 8 x 4TB SATAIII drives.  Up to now they have performed
very well, with roughly 30% reads and 70% writes.  This is absolutely fine
as RAID10 does give much better write performance and we expect this.  I
can't recall what the benches said when I tested this many, many months ago,
but it was good and IO wait even under heavy heavy usage is very little...

The problem now is coming in that the servers are reaching their capacity
and the arrays are starting to fill up.  Deleting files, isn't really an
option for me as I want to keep them as long as possible.  So, let's get a
server to archive data on.

So, a new server, 15 x 4TB SATAIII drives again, on a MegaRAID controller.
With the understanding that the "archives" will be read more than written to
(we only write here once we move data from the RAID10 arrays), I opted for
RAID5 rather.  The higher spindle count surely should count for something.
Well.  The server was configured, array initialised, and tests shows more
than 1gb/s in write speeds - faster than the RAID10 arrays.  I am pleased!

What's the problem?  Well the front end servers does an enormous amount of
random read/writes (30/70 split), 24x7.  Some 3 million files are added
(written) per day, of which roughly 30% are read again.  So, the majority of
the IO activity is writing to disk.  With all the writing going on, there is
effectively zero IO left for reading data.  I can't read (or should we say
"move") data off the server faster than what it is being written.  The
moment I start to do any amount of significant read requests, the IO wait
jumps through the roof and the write speeds obviously also crawl to a halt.
I suspect due to the seek time on the spindles, which does make sense and
all of that.  So there still isn't really any problem here that we don't
know about already.

Now, I realise that this is a really, really open question in terms of
interpretation, but what raid levels with high spindle counts (say 8, 12 or
15 or so) will provide for the best "overall" and balanced read/write
performance in terms of random IO?  I do not necessarily need blistering
performance in terms of speeds due to the small file sizes, but I do need
blistering fast performance in terms of IOPS and random read/writes...  All
file systems currently EXT4 and all raid disks running with a 64K block
size.

Many thanks, and once again my apologise for my theoretical question rather
than md specific question.

--
Chris.






