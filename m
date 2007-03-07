From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Help with chunksize on raid10 -p o3 array
Date: Tue, 06 Mar 2007 19:31:39 -0500
Message-ID: <45EE07EB.8050604@tmr.com>
References: <45ED4FE1.5020105@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45ED4FE1.5020105@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> Hi,
> I have been trying to figure out the best chunk size for raid10 before 
> migrating my server to it (currently raid1). I am looking at 3 offset 
> stripes, as I want to have two drive failure redundancy, and offset 
> striping is said to have the best write performance, with read 
> performance equal to far. Information on the internet is scarce so I 
> decided to test chunking myself. I used the script 
> http://rabbit.us/pool/misc/raid_test.txt to iterate through different 
> chunk sizes, and try to dd the resulting array to /dev/null. I 
> deliberately did not make a filesystem on top of the array - I was 
> just looking for raw performance, and since the FS layer is not 
> involved no caching/optimization is taking place. I also monitored the 
> process with dstat in a separate window, and memory usage confirmed 
> that this method is valid.
> I got some pretty weird results: 
> http://rabbit.us/pool/misc/raid_test_results.txt
> From all my readings so far I thought that with chunk size increase 
> the large block access throughput decreases while small block reads 
> increase, and it is just a matter of finding a "sweet spot" balancing 
> them out. The results, however, clearly show something else. There are 
> some inconsistencies, which I attribute to my non-scientific approach, 
> but the trend is clearly showing.
>
> Here are the questions I have:
>
> * Why did the test show best consistent performance over a 16k chunk? 
> Is there a way to determine this number without running a lengthy 
> benchmark, just from knowing the drive performance?
>
By any chance did you remember to increase stripe_cache_size to match 
the chunk size? If not, there you go.
> * Why although I have 3 identical chunks of data at any time, dstat 
> never showed simultaneous reading from more than 2 drives. Every dd 
> run was accompanied by maxing out one of the drives at 58MB/s and 
> another one was trying to catch up to various degrees depending on the 
> chunk size. Then on the next dd run two other drives would be 
> (seemingly random) selected and the process would repeat.
>
> * What the test results don't show but dstat did is how the array 
> resync behaved after the array creation. Although my system can 
> sustain reads from all 4 drives at the max speed of 58MB/s, here is 
> what the resync at different chunk sizes looked like:
>
> 32k    -    simultaneous reads from all 4 drives at 47MB/s sustained
> 64k    -    simultaneous reads from all 4 drives at 56MB/s sustained
> 128k    -    simultaneous reads from all 4 drives at 54MB/s sustained
> 512k    -    simultaneous reads from all 4 drives at 30MB/s sustained
> 1024k    -    simultaneous reads from all 4 drives at 38MB/s sustained
> 4096k    -    simultaneous reads from all 4 drives at 44MB/s sustained
> 16384k    -    simultaneous reads from all 4 drives at 46MB/s sustained
> 32768k    -    simultaneous reads from 2 drives at 58MB/s sustained and
>          the other two at 26MB/s sustained alternating the speed
>         between the pairs of drives every 3 seconds or so
> 65536k    -    All 4 drives started at 58MB/s sustained gradually
>         reducing to 44MB/s sustained at the same time
>
> I repeated just the creation of arrays - the results are consistent. 
> Is there any explanation for this?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

