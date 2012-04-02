From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID5 XOR speed vs RAID6 Q speed (was Re: AVX RAID5 xor checksumming)
Date: Sun, 01 Apr 2012 17:01:05 -0700
Message-ID: <4F78EC41.6040108@zytor.com>
References: <1333057458-2986-1-git-send-email-james.t.kukunas@linux.intel.com> <4F76ECD0.1060608@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F76ECD0.1060608@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/31/2012 04:38 AM, John Robinson wrote:
> On 29/03/2012 22:44, Jim Kukunas wrote:
>> Based on xor_speed, the AVX implementation appears to be ~32% faster
>> than the
>> SSE implementation on my i7 2600:
>>
>>     generic_sse: 15088.000 MB/sec
>>     avx: 19936.000 MB/sec
> 
> I just noticed in my logs the other day (recent el5 kernel on a Core 2):
> 
> raid5: automatically using best checksumming function: generic_sse
>    generic_sse:  7805.000 MB/sec
> raid5: using function: generic_sse (7805.000 MB/sec)
> raid6: int64x1   2635 MB/s
> raid6: int64x2   3208 MB/s
> raid6: int64x4   3020 MB/s
> raid6: int64x8   2519 MB/s
> raid6: sse2x1    5099 MB/s
> raid6: sse2x2    5742 MB/s
> raid6: sse2x4    8237 MB/s
> raid6: using algorithm sse2x4 (8237 MB/s)
> 
> I was just wondering how it's possible to do the RAID6 Q calculation
> faster than the RAID5 XOR calculation - or am I reading this log excerpt
> wrongly?
> 
> It's probably academic, since the machine this is running on only has a
> maximum of about 4500 MB/s of memory throughput, and a lot of that would
> be consumed sending data to disc in amongst the calculations being done.
> 

It *might* be a result of how these different algorithms are
benchmarked, but yes, that really looks a bit odd, especially since the
RAID6 code *also* computes the XOR checksum (it does P and Q in parallel
since it has to read the data anyway).

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

