From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: raid resync speed
Date: Thu, 27 Mar 2014 17:08:38 +0100
Message-ID: <53344D06.4090401@fastmail.fm>
References: <CAPrpM6wLpRhMqqsXQ8Baqz4axxj6cvoB2Z1HAOiNm7gPv1FT=w@mail.gmail.com> <532AFCC8.6080902@hardwarefreak.com> <532B0ABC.5040604@fastmail.fm> <532B372A.7090802@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <532B372A.7090802@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, Jeff Allison <jeff.allison@allygray.2y.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry for the late reply, I'm busy with work...

On 03/20/2014 07:44 PM, Stan Hoeppner wrote:
> On 3/20/2014 10:35 AM, Bernd Schubert wrote:
>> On 3/20/2014 9:35 AM, Stan Hoeppner wrote:
>>> Yes.  The article gives 16384 and 32768 as examples for
>>> stripe_cache_size.  Such high values tend to reduce throughput instead
>>> of increasing it.  Never use a value above 2048 with rust, and 1024 is
>>> usually optimal for 7.2K drives.  Only go 4096 or higher with SSDs.  In
>>> addition, high values eat huge amounts of memory.  The formula is:
>
>> Why should the stripe-cache size differ between SSDs and rotating disks?
>
> I won't discuss "should" as that makes this a subjective discussion.
> I'll discuss this objectively, discuss what md does, not what it
> "should" do or could do.
>
> I'll answer your question with a question:  Why does the total stripe
> cache memory differ, doubling between 4 drives and 8 drives, or 8 drives
> and 16 drives, to maintain the same per drive throughput?
>
> The answer to both this question and your question is the same answer.
> As the total write bandwidth of the array increases, so must the total
> stripe cache buffer space.  stripe_cache_size of 1024 is usually optimal
> for SATA drives with measured 100MB/s throughput, and 4096 is usually
> optimal for SSDs with 400MB/s measured write throughput.  The bandwidth
> numbers include parity block writes.

Did you also consider that you simply need more stripe-heads (struct 
stripe_head) to get complete stripes with more drives?

>
> array(s)		bandwidth MB/s	stripe_cache_size	cache MB
>
> 12x 100MB/s Rust	1200		1024			 48
> 16x 100MB/s Rust	1600		1024			 64
> 32x 100MB/s Rust	3200		1024			128
>
> 3x  400MB/s SSD		1200		4096			 48
> 4x  400MB/s SSD		1600		4096			 64
> 8x  400MB/s SSD		3200		4096			128
>
> As is clearly demonstrated, there is a direct relationship between cache
> size and total write bandwidth.  The number of drives and drive type is
> irrelevant.  It's the aggregate write bandwidth that matters.

What is the meaning of "cache MB"? It does not seem to come from this 
calculation:

> 	memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
> 		 max_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;

...

> 		printk(KERN_INFO "md/raid:%s: allocated %dkB\n",
> 		       mdname(mddev), memory);


>
> Whether this "should" be this way is something for developers to debate.
>   I'm simply demonstrating how it "is" currently.

Well, somehow I only see two different stripe-cache size values in your 
numbers. Then the given bandwidth seems to be theoretical value, based 
on num-drives * performance-per-drive. Redundancy drives are also 
missing in that calculation.  And then the value of "cache MB" is also 
unclear. So I'm sorry, but don't see any "simply demonstrating".


>
>> Did you ever try to figure out yourself why it got slower with higher
>> values? I profiled that in the past and it was a CPU/memory limitation -
>> the md thread went to 100%, searching for stripe-heads.
>
> This may be true at the limits, but going from 512 to 1024 to 2048 to
> 4096 with a 3 disk rust array isn't going to peak the CPU.  And
> somewhere with this setup, usually between 1024 and 2048, throughput
> will begin to tail off, even with plenty of CPU and memory B/W remaining.

Sorry, not in my experience. So it would be interesting to see real 
measused values. But then I definitely never tested raid6 with 3 drives, 
as this only provides a single data drive.

>
>> So I really wonder how you got the impression that the stripe cache size
>> should have different values for differnt kinds of drives.
>
> Because higher aggregate throughputs require higher stripe_cache_size
> values, and some drive types (SSDs) have significantly higher throughput
> than others (rust), usually [3|4] to 1 for discrete SSDs, much greater
> for PCIe SSDs.

As I said, it would be interesting to see real numbers and profiling data.


Cheers,
Bernd
