From: John Robinson <john.robinson@anonymous.org.uk>
Subject: RAID5 XOR speed vs RAID6 Q speed (was Re: AVX RAID5 xor checksumming)
Date: Sat, 31 Mar 2012 12:38:56 +0100
Message-ID: <4F76ECD0.1060608@anonymous.org.uk>
References: <1333057458-2986-1-git-send-email-james.t.kukunas@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1333057458-2986-1-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/03/2012 22:44, Jim Kukunas wrote:
> Based on xor_speed, the AVX implementation appears to be ~32% faster than the
> SSE implementation on my i7 2600:
>
> 	generic_sse: 15088.000 MB/sec
> 	avx: 19936.000 MB/sec

I just noticed in my logs the other day (recent el5 kernel on a Core 2):

raid5: automatically using best checksumming function: generic_sse
    generic_sse:  7805.000 MB/sec
raid5: using function: generic_sse (7805.000 MB/sec)
raid6: int64x1   2635 MB/s
raid6: int64x2   3208 MB/s
raid6: int64x4   3020 MB/s
raid6: int64x8   2519 MB/s
raid6: sse2x1    5099 MB/s
raid6: sse2x2    5742 MB/s
raid6: sse2x4    8237 MB/s
raid6: using algorithm sse2x4 (8237 MB/s)

I was just wondering how it's possible to do the RAID6 Q calculation 
faster than the RAID5 XOR calculation - or am I reading this log excerpt 
wrongly?

It's probably academic, since the machine this is running on only has a 
maximum of about 4500 MB/s of memory throughput, and a lot of that would 
be consumed sending data to disc in amongst the calculations being done.

Cheers,

John.

