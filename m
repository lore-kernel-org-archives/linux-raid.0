From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid resync speed
Date: Fri, 28 Mar 2014 03:03:28 -0500
Message-ID: <53352CD0.5010109@hardwarefreak.com>
References: <CAPrpM6wLpRhMqqsXQ8Baqz4axxj6cvoB2Z1HAOiNm7gPv1FT=w@mail.gmail.com> <532AFCC8.6080902@hardwarefreak.com> <532B0ABC.5040604@fastmail.fm> <532B372A.7090802@hardwarefreak.com> <53344D06.4090401@fastmail.fm>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53344D06.4090401@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>, Jeff Allison <jeff.allison@allygray.2y.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/27/2014 11:08 AM, Bernd Schubert wrote:
> Sorry for the late reply, I'm busy with work...
> 
> On 03/20/2014 07:44 PM, Stan Hoeppner wrote:
>> On 3/20/2014 10:35 AM, Bernd Schubert wrote:
>>> On 3/20/2014 9:35 AM, Stan Hoeppner wrote:
>>>> Yes.  The article gives 16384 and 32768 as examples for
>>>> stripe_cache_size.  Such high values tend to reduce throughput instead
>>>> of increasing it.  Never use a value above 2048 with rust, and 1024 is
>>>> usually optimal for 7.2K drives.  Only go 4096 or higher with SSDs.  In
>>>> addition, high values eat huge amounts of memory.  The formula is:
>>
>>> Why should the stripe-cache size differ between SSDs and rotating disks?
>>
>> I won't discuss "should" as that makes this a subjective discussion.
>> I'll discuss this objectively, discuss what md does, not what it
>> "should" do or could do.
>>
>> I'll answer your question with a question:  Why does the total stripe
>> cache memory differ, doubling between 4 drives and 8 drives, or 8 drives
>> and 16 drives, to maintain the same per drive throughput?
>>
>> The answer to both this question and your question is the same answer.
>> As the total write bandwidth of the array increases, so must the total
>> stripe cache buffer space.  stripe_cache_size of 1024 is usually optimal
>> for SATA drives with measured 100MB/s throughput, and 4096 is usually
>> optimal for SSDs with 400MB/s measured write throughput.  The bandwidth
>> numbers include parity block writes.
> 
> Did you also consider that you simply need more stripe-heads (struct stripe_head) to get complete stripes with more drives?

It has nothing to do with what we're discussing.  You get complete stripes with the default value which is IIRC 256, though md.txt still says 128 as of 3.13.6, and that it only applies to RAID5.  Maybe md.txt should be updated.

  stripe_cache_size  (currently raid5 only)
      number of entries in the stripe cache.  This is writable, but
      there are upper and lower limits (32768, 16).  Default is 128.

>> array(s)        	bandwidth MB/s    stripe_cache_size    cache MB
>>
>> 12x 100MB/s Rust     1200        	  1024                  48
>> 16x 100MB/s Rust     1600        	  1024                  64
>> 32x 100MB/s Rust     3200        	  1024                 128
>>
>> 3x  400MB/s SSD      1200        	  4096                  48
>> 4x  400MB/s SSD      1600        	  4096                  64
>> 8x  400MB/s SSD      3200        	  4096                 128
>>
>> As is clearly demonstrated, there is a direct relationship between cache
>> size and total write bandwidth.  The number of drives and drive type is
>> irrelevant.  It's the aggregate write bandwidth that matters.
> 
> What is the meaning of "cache MB"? It does not seem to come from this calculation:
> 
>>     memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
>>          max_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
...
> 
>>         printk(KERN_INFO "md/raid:%s: allocated %dkB\n",
>>                mdname(mddev), memory);

No, it is not derieved from the source code, but from the formula I stated previously in this thread:

stripe_cache_size * 4096 bytes * drive_count = RAM usage

>> Whether this "should" be this way is something for developers to debate.
>>   I'm simply demonstrating how it "is" currently.
> 
> Well, somehow I only see two different stripe-cache size values in your numbers. 

Only two are required to demonstrate the md RAID5/6 behavior in question.

> Then the given bandwidth seems to be theoretical value, based on num-drives * performance-per-drive. 

The values in the table are not theoretical, but are derived from test data, and are very close to what one will see with such a real world configuration.

> Redundancy drives are also missing in that calculation.  

No, this is included.  Read the sentence directly preceding the table.

> And then the value of "cache MB" is also unclear. 

It is unambiguous.

> So I'm sorry, but don't see any "simply demonstrating".

...

>>> Did you ever try to figure out yourself why it got slower with higher
>>> values? I profiled that in the past and it was a CPU/memory limitation -
>>> the md thread went to 100%, searching for stripe-heads.
>>
>> This may be true at the limits, but going from 512 to 1024 to 2048 to
>> 4096 with a 3 disk rust array isn't going to peak the CPU.  And
>> somewhere with this setup, usually between 1024 and 2048, throughput
>> will begin to tail off, even with plenty of CPU and memory B/W remaining.
> 
> Sorry, not in my experience. 

This is the behavior everyone sees, because this is how md behaves.  If your experience is different then you should demonstrate it.  

> So it would be interesting to see real measused values.  But then I definitely never tested raid6 with 3 drives, as this only provides a single data drive.

The point above is that an md write thread won't saturate the processor, regardless of the size of the stripe cache, with a small count rust array.  I simply chose a very low number to make the point clear.  I didn't state a RAID level here.  Whether it's RAID5 or 6 is irrelevant to the point.

>>> So I really wonder how you got the impression that the stripe cache size
>>> should have different values for differnt kinds of drives.
>>
>> Because higher aggregate throughputs require higher stripe_cache_size
>> values, and some drive types (SSDs) have significantly higher throughput
>> than others (rust), usually [3|4] to 1 for discrete SSDs, much greater
>> for PCIe SSDs.
> 
> As I said, it would be interesting to see real numbers and profiling data.

Here are numbers for an md RAID5 SSD array, 64KB chunk.

5 x Intel 520s MLC 480G SATA3
Intel Xeon E3-1230V2 quad core, 1MB L2, 8MB L3, 3.3GHz/3.7GHz turbo
2x DDR3 = 21 GB/s memory bandwidth
Debian 6 kernel 3.2

Parallel FIO throughput
16 threads, 256KB block size, O_DIRECT, libaio, queue depth 16, 8 GB/thread, 128 GB total written:

stripe_cache_size = 256
    READ: io=131072MB, aggrb=2496MB/s, minb=2556MB/s, maxb=2556MB/s, mint=52508msec, maxt=52508msec
   WRITE: io=131072MB, aggrb=928148KB/s, minb=950424KB/s, maxb=950424KB/s, mint=144608msec, maxt=144608msec

stripe_cache_size = 512
    READ: io=131072MB, aggrb=2497MB/s, minb=2557MB/s, maxb=2557MB/s, mint=52484msec, maxt=52484msec
   WRITE: io=131072MB, aggrb=978170KB/s, minb=978MB/s, maxb=978MB/s, mint=137213msec, maxt=137213msec

stripe_cache_size = 2048
    READ: io=131072MB, aggrb=2502MB/s, minb=2562MB/s, maxb=2562MB/s, mint=52382msec, maxt=52382msec
   WRITE: io=131072MB, aggrb=996MB/s, minb=1020MB/s, maxb=1020MB/s, mint=131631msec, maxt=131631msec

stripe_cache_size = 4096
    READ: io=131072MB, aggrb=2498MB/s, minb=2558MB/s, maxb=2558MB/s, mint=52465msec, maxt=52465msec
   WRITE: io=131072MB, aggrb=1596MB/s, minb=1634MB/s, maxb=1634MB/s, mint=82126msec, maxt=82126msec

stripe_cache_size = 8192
    READ: io=131072MB, aggrb=2498MB/s, minb=2558MB/s, maxb=2558MB/s, mint=52469msec, maxt=52469msec
   WRITE: io=131072MB, aggrb=1514MB/s, minb=1550MB/s, maxb=1550MB/s, mint=86565msec, maxt=86565msec

stripe_cache_size = 16384
    READ: io=131072MB, aggrb=2482MB/s, minb=2542MB/s, maxb=2542MB/s, mint=52807msec, maxt=52807msec
   WRITE: io=131072MB, aggrb=1377MB/s, minb=1410MB/s, maxb=1410MB/s, mint=95191msec, maxt=95191msec

stripe_cache_size = 32768
    READ: io=131072MB, aggrb=2498MB/s, minb=2557MB/s, maxb=2557MB/s, mint=52481msec, maxt=52481msec
   WRITE: io=131072MB, aggrb=1139MB/s, minb=1166MB/s, maxb=1166MB/s, mint=115102msec, maxt=115102msec


The effect I described is clearly demonstrated here: increasing stripe_cache_size beyond the optimal value causes write throughput to decrease.  With this SSD array a value of 4096 achieves peak sequential application write throughput of 1.6 GB/s.  Throughput with parity is 2 GB/s, or 400 MB/s per drive.  Note what I said previously, above, when I described the table figures:  "...4096 is usually optimal for SSDs with 400MB/s measured write throughput."  Thus, those figures are not "theoretical" as you claimed, but are based on actual testing.  The same is true for rust, though I haven't performed such testing on rust.  Others on this list have submitted rust numbers, but not with testing quite as thorough as the above.  I invite you to perform FIO testing on your rust array and submit you
 r results.  They should confirm what I stated in the table above.


On 3/20/2014 10:35 AM, Bernd Schubert wrote:
> Why should the stripe-cache size differ between SSDs and rotating
> disks? Did you ever try to figure out yourself why it got slower with
> higher values? I profiled that in the past and it was a CPU/memory
> limitation - the md thread went to 100%, searching for stripe-heads.


The results above do not seem corroborate your claim.  The decrease in throughput from 1.63 GB/s to 1.16 GB/s, when increasing stripe_cache_size from 4096 to 32768, is a slope not a cliff.  If CPU/DRAM starvation were the problem, I would think this would be a cliff and not a slope.

As I stated previously, I am simply characterizing the behavior of stripe_cache_size values and their real world impact on throughput and memory consumption.  I have not speculated to this point as to the cause of the observed behavior.  I have not profiled execution.  I don't know the code.  I am not a kernel hacker.  I am not a programmer.  What I have observed in reports on this list and in testing is that there is a direct correlation between optimal stripe_cache_size and device write throughput.

Cheers,

Stan
