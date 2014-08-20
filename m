From: David Brown <david.brown@hesbynett.no>
Subject: Re: Correct RAID options
Date: Wed, 20 Aug 2014 02:22:49 +0200
Message-ID: <53F3EA59.6030808@hesbynett.no>
References: <027801cfbbdc$d33970f0$79ac52d0$@savage.za.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <027801cfbbdc$d33970f0$79ac52d0$@savage.za.org>
Sender: linux-raid-owner@vger.kernel.org
To: savage@savage.za.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

This mailing list is for raid on Linux.  While it is dominated by md 
raid, it covers hardware raid too.

In general, a 15 disk raid5 array is asking for trouble.  At least make 
it raid6.

However, when I hear of multiple parallel access to lots of small files, 
I think of XFS over a linear concat.  If Stan Hoeppner is following at 
the moment, I'm sure he can help here - he is an expert on this sort of 
thing.

But the general idea is to have a set of raid1 mirrors (or possible 
Linux md raid10,far2 pairs if the traffic is read-heavy), and then tie 
them all together using a linear concatenation rather than raid0 
stripes.  When you have XFS on this, it divides up the disk space into 
blocks that can be accessed independently.  Thus it can access both the 
data and metadata relating to a file within a single raid1 pair - and 
simultaneously access other files on other pairs.  The block 
partitioning is done by directory, so it only works well if the parallel 
accesses are spread across a range of different directories.

I am assuming your files are fairly small - if your reads or writes are 
often smaller than a full stripe of raid10 or raid5, performance will 
suffer greatly compared to XFS on a linear concat.

mvh.,

David


On 19/08/14 20:38, Chris Knipe wrote:
> Hi All,
>
> I'm sitting with a bit of a catch 22 and need some feedback / inputs please.
> This isn't strictly md related as all servers has MegaRAID SAS controllers
> with BBUs and I am running hardware raid.  So my apologies about the off
> topic posting, but the theory remains the same I presume.   All the servers
> store millions of small (< 2mb) files, in a structured directory structure
> to keep the amount of files per directory in check.
>
> Firstly, I have a bunch (3) of front end servers, all configured in RAID10
> and consisting of 8 x 4TB SATAIII drives.  Up to now they have performed
> very well, with roughly 30% reads and 70% writes.  This is absolutely fine
> as RAID10 does give much better write performance and we expect this.  I
> can't recall what the benches said when I tested this many, many months ago,
> but it was good and IO wait even under heavy heavy usage is very little...
>
> The problem now is coming in that the servers are reaching their capacity
> and the arrays are starting to fill up.  Deleting files, isn't really an
> option for me as I want to keep them as long as possible.  So, let's get a
> server to archive data on.
>
> So, a new server, 15 x 4TB SATAIII drives again, on a MegaRAID controller.
> With the understanding that the "archives" will be read more than written to
> (we only write here once we move data from the RAID10 arrays), I opted for
> RAID5 rather.  The higher spindle count surely should count for something.
> Well.  The server was configured, array initialised, and tests shows more
> than 1gb/s in write speeds - faster than the RAID10 arrays.  I am pleased!
>
> What's the problem?  Well the front end servers does an enormous amount of
> random read/writes (30/70 split), 24x7.  Some 3 million files are added
> (written) per day, of which roughly 30% are read again.  So, the majority of
> the IO activity is writing to disk.  With all the writing going on, there is
> effectively zero IO left for reading data.  I can't read (or should we say
> "move") data off the server faster than what it is being written.  The
> moment I start to do any amount of significant read requests, the IO wait
> jumps through the roof and the write speeds obviously also crawl to a halt.
> I suspect due to the seek time on the spindles, which does make sense and
> all of that.  So there still isn't really any problem here that we don't
> know about already.
>
> Now, I realise that this is a really, really open question in terms of
> interpretation, but what raid levels with high spindle counts (say 8, 12 or
> 15 or so) will provide for the best "overall" and balanced read/write
> performance in terms of random IO?  I do not necessarily need blistering
> performance in terms of speeds due to the small file sizes, but I do need
> blistering fast performance in terms of IOPS and random read/writes...  All
> file systems currently EXT4 and all raid disks running with a 64K block
> size.
>
> Many thanks, and once again my apologise for my theoretical question rather
> than md specific question.
>

