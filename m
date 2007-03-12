From: Neil Brown <neilb@suse.de>
Subject: Re: Help with chunksize on raid10 -p o3 array
Date: Mon, 12 Mar 2007 15:28:55 +1100
Message-ID: <17908.55047.408840.852816@notabene.brown>
References: <45ED4FE1.5020105@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter Rabbitson on Tuesday March 6
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 6, rabbit@rabbit.us wrote:
> Hi,
> I have been trying to figure out the best chunk size for raid10 before 
> migrating my server to it (currently raid1). I am looking at 3 offset 
> stripes, as I want to have two drive failure redundancy, and offset 
> striping is said to have the best write performance, with read 
> performance equal to far. Information on the internet is scarce so I 
> decided to test chunking myself. I used the script 
> http://rabbit.us/pool/misc/raid_test.txt to iterate through different 

The different block sizes in the reads will make very little
difference to the results as the kernel will be doing read-ahead for
you.  If you want to really test throughput at different block sizes
you need to insert random seeks.

> chunk sizes, and try to dd the resulting array to /dev/null. I 
> deliberately did not make a filesystem on top of the array - I was just 
> looking for raw performance, and since the FS layer is not involved no 
> caching/optimization is taking place. I also monitored the process with 
> dstat in a separate window, and memory usage confirmed that this method 
> is valid.
> I got some pretty weird results: 
> http://rabbit.us/pool/misc/raid_test_results.txt
>  From all my readings so far I thought that with chunk size increase the 
> large block access throughput decreases while small block reads 
> increase, and it is just a matter of finding a "sweet spot" balancing 
> them out. The results, however, clearly show something else. There are 
> some inconsistencies, which I attribute to my non-scientific approach, 
> but the trend is clearly showing.
> 
> Here are the questions I have:
> 
> * Why did the test show best consistent performance over a 16k chunk? Is 
> there a way to determine this number without running a lengthy 
> benchmark, just from knowing the drive performance?

When you are doing a large sequential read from a raid10-offset array,
it will (should) read from all drives for the first chunk, then skip
over the offset-copy(s) of that chunk and read again.  Thus you get a
read-seek-read-seek pattern.
The time that each read takes will be proportional to the chunk size.
The time that the seek take will be pretty stable (mostly head
settling time I believe).  So for small chunks, the seek time
dominates.  For large chunks, the read starts to dominate.

I think this is what you are seeing.  When you get to 16M chunks (16K
kilobytes) the seek time is a smaller fraction of the read time and so
you spend more time reading.

The fact that it drops off again at 32M is probably due to some limit
in the amount of read-ahead that the kernel will initiate.  If it
won't issue the request to the last drive before the request to the
first drive completes, you will obviously get slower throughput.


> 
> * Why although I have 3 identical chunks of data at any time, dstat 
> never showed simultaneous reading from more than 2 drives. Every dd run 
> was accompanied by maxing out one of the drives at 58MB/s and another 
> one was trying to catch up to various degrees depending on the chunk 
> size. Then on the next dd run two other drives would be (seemingly 
> random) selected and the process would repeat.

Poor read-balancing code.  It really needs more thought.
Possibly for raid10 we shouldn't try to balance at all.  Just read
from the 'first' copy in each case....


> 
> * What the test results don't show but dstat did is how the array resync 
> behaved after the array creation. Although my system can sustain reads 
> from all 4 drives at the max speed of 58MB/s, here is what the resync at 
> different chunk sizes looked like:
> 
> 32k	-	simultaneous reads from all 4 drives at 47MB/s sustained
> 64k	-	simultaneous reads from all 4 drives at 56MB/s sustained
> 128k	-	simultaneous reads from all 4 drives at 54MB/s sustained
> 512k	-	simultaneous reads from all 4 drives at 30MB/s sustained
> 1024k	-	simultaneous reads from all 4 drives at 38MB/s sustained
> 4096k	-	simultaneous reads from all 4 drives at 44MB/s sustained
> 16384k	-	simultaneous reads from all 4 drives at 46MB/s sustained
> 32768k	-	simultaneous reads from 2 drives at 58MB/s sustained and
>   		the other two at 26MB/s sustained alternating the speed
> 		between the pairs of drives every 3 seconds or so
> 65536k	-	All 4 drives started at 58MB/s sustained gradually
> 		reducing to 44MB/s sustained at the same time
> 
> I repeated just the creation of arrays - the results are consistent. Is 
> there any explanation for this?

A raid10 resync involves reading all copies of each block and doing
comparisons.  If we find a difference, we write out one copy over the
rest.

We issue the requests in sequential order for the blocks.  If you think
about how the blocks are laid out, you will see that this is not
always sequential order on each individual device.  In some cases we
will ask to read a later device block before an earlier device block.

For small chunk sizes, the amount of backward-seeking will be fairly
small and the elevator will probably absorb all of it.
For larger chunk sizes, you will get longer backward seeking that
doesn't get rearranged by the elevator and so you will get lower
throughout.

Exactly where the interesting 32M artifact comes from I don't know.
It could relate to the window size used by md - there is a limit to
how many outstanding resync requests there can be at one time.
It limits to 32 requests each 64K is size which multiplies out to
2Meg..... not obvious how that connects, is it?

NeilBrown
