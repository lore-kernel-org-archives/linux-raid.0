From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: A few questions before assembling Linux 7.5TB RAID 5 array
Date: Sat, 30 Dec 2006 17:31:08 -0500
Message-ID: <4596E8AC.3050407@tmr.com>
References: <slrneollp6.4ps.ylee@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <slrneollp6.4ps.ylee@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yeechang Lee <ylee@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yeechang Lee wrote:
> [Also posted to comp.sys.ibm.pc.hardware.storage,comp.arch.storage,alt.comp.hardware.pc-homebuilt,comp.os.linux.hardware.]
>
> I'm shortly going to be setting up a Linux software RAID 5 array using
> 16 500GB SATA drives with one HighPoint RocketRAID 2240 PCI-X
> controller (i.e., the controller will be used for its 16 SATA ports,
> not its "hardware" fakeraid). The array will be used to store and
> serve locally and via gigabit Ethernet large, mostly high-definition
> video recordings (up to six or eight files being written to and/or
> read from simultaneously, as I envision it). The smallest files will
> be 175MB-700MB, the largest will be 25GB+, and most files will be from
> 4GB to 12GB with a median of about 7.5GB. I plan on using JFS as the
> filesystem, without LVM.
>
> A few performance-related questions:
>
> * What chunk size should I use? In previous RAID 5 arrays I've built
>   for similar purposes I've used 512K. For the setup I'm describing,
>   should I go bigger? Smaller?
>   

I am doing some tests on this right now (this weekend), because I don't 
have an answer. If I get data I trust I'll share it. See the previous 
thread on poor RAID-5 performance, use a BIG stripe buffer and/or wait 
for a better answer on chunk size.
> * Should I stick with the default of 0.4% of the array as given over
>   to the JFS journal? If I can safely go smaller without a
>   rebuilding-performance penalty, I'd like to. Conversely, if a larger
>   journal is recommended, I can do that.
>   
I do know something about that, having run AIX for a long time. If you 
have a high rate of metadata events, like create or delete file, large 
journal is a must, and I had one on another array with small stripe size 
to spread the head motion, otherwise the log drive became a bottleneck. 
If you are going to write a lot of data to this array, mount it 
"noatime" to avoid beating the journal and slowing your access.

Be sure you tune your readahead on each drive after looking at the 
actual load data. Think "more is better" but "too much is worse," on that.
> * I'm wondering whether I should have ordered two RocketRAID 2220
>   (each with eight SATA ports) instead of the 2240. Would two cards,
>   each in a PCI-X slot, perform better? I'll be using the Supermicro
>   X7DVL-E
>   (<URL:http://www.supermicro.com/products/motherboard/Xeon1333/5000V/X7DVL-E.cfm>)
>   as the motherboard.
>
>   
My guess is that unless your m/b has dual PCI bus (it might), and you 
have 2 and 4 way memory interleave (my supermicro boards did the last 
time I used one), you are going to be able to swamp the bus and/or 
memory with a single controller.

Now, in terms of "perform better," I'm not sure you would be able to 
measure it, and unless you have some $tate of the art network, you will 
run out of bandwidth to the outside world long before you run out of 
disk performance.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

