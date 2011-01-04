From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID-10 initial sync is CPU-limited
Date: Tue, 04 Jan 2011 14:47:13 +0000
Message-ID: <4D2332F1.6090205@anonymous.org.uk>
References: <20110103163213.GC17455@fi.muni.cz> <20110104162437.31dae9c9@notabene.brown> <20110104082944.GK17455@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104082944.GK17455@fi.muni.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Kasprzak <kas@fi.muni.cz>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 04/01/2011 08:29, Jan Kasprzak wrote:
> NeilBrown wrote:
> : The md1_raid10 process is probably spending lots of time in memcmp and memcpy.
> : The way it works is to read all blocks that should be the same, see if they
> : are the same and if not, copy on to the orders and write those other (or in
> : your case "that other").
>
> 	According to dmesg(8) my hardware is able to do XOR
> at 9864 MB/s using generic_sse, and 2167 MB/s using int64x1. So I assume
> memcmp+memcpy would not be much slower. According to /proc/mdstat, the resync
> is running at 449 MB/s. So I expect just memcmp+memcpy cannot be a bottleneck
> here.

I think it can. Those XOR benchmarks only tell you what the CPU core can 
do internally, and don't reflect FSB/RAM bandwidth. My Core 2 Quad 
3.2GHz on 1.6GHz FSB with dual-channel memory at 800MHz each (P45 
chipset) has maximum memory bandwidth of about 4.5GB/s with two sticks 
of RAM, according to memtest86+. With 4 sticks of RAM it's 3.5GB/s. In 
real use it'll be rather less.

What you are doing with the resync is reading from two discs into RAM, 
reading both from RAM into the CPU, which does the memcmp+memcpy, then 
writing from the CPU into the RAM, and writing from RAM to one of the 
discs. That means you're using your RAM 6 times for each chunk of data, 
so the maximum resync throughput would be a sixth of your RAM's maximum 
throughput - in my case, ~575MB/s - and as I say in real use I'd expect 
it to be considerably less than this, and I imagine you would see this 
memory saturation as high CPU usage.

One core can easily saturate the memory bandwidth, so having multiple 
threads would not help at all.

I think the above may demonstrate why it may be worthwhile optimising 
the resync in some circumstances to read one disc and write the other:
(a) if you memcpy it, you go through RAM 4 times instead of 6;
(b) if you can just write what you read in the first place, without 
copying it so it never has to come to and from the CPU, you go through 
RAM only twice;
(c) if you could get the discs/controllers to DMA the data straight from 
one to the other, you'd never hit RAM at all.

In the mean time, wiping your discs before you create the array with `dd 
if=/dev/zero of=/dev/disk` would only go from RAM to disc twice (once 
for each disc), then create the array with --assume-clean.

Cheers,

John.

