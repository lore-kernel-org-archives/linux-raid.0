Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFCE92EAB6F;
	Thu, 16 Apr 2026 16:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776356777; cv=none; b=uRLTxM2B0XKkILRyH1BFNQ5Y1xuw1QmVhwDcYZ8nQZZ0/d3WPPJqeGiPF/e8hZRBvvoeFx6hdtweF/9DxOmUsQa2VfO+A+G+79WeOQz+EwGvVMf8TtXncznwdwPNlZue7+jIZcrbEVjN/IQo+TQNzeKhwOduKm/UqT0K9luCvg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776356777; c=relaxed/simple;
	bh=IpHmhIKcFtFTL5blw5DxAjGhE4roEnncKzqyQVORCNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BLQ4tuOYv9N8DLEVWmccMC+OphoXNmv8uq6UR/XgkjyQ1EwJYJHs2LVwikgaE70YTP7b7IGn9Pw5FpQmdzjaw9V3hcdLo+fOb0YtAkXKZmvXBsCdgHTb2zueUWzqDapt3CFomoElao5y3cb42MYoSc1mPBN6cvh80Iyk0E1+UHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p8VSsgzi; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p8VSsgzi"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DD721D6F;
	Thu, 16 Apr 2026 09:26:09 -0700 (PDT)
Received: from [10.1.196.85] (e121345-lin.cambridge.arm.com [10.1.196.85])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D30E93F7D8;
	Thu, 16 Apr 2026 09:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776356775; bh=IpHmhIKcFtFTL5blw5DxAjGhE4roEnncKzqyQVORCNo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p8VSsgziWdjQDkWgARFcGwknEpZUnjzYks5NJOljDIVgZLwVaaKigTKXlj+B23RZ7
	 FE+MuLfmW9WOfLa4l0Kva8vEl+FCeqq5RUJmleJhDN5MaXJ2KSYdMsk860w4MubTAG
	 ITtKPDoKrQjJOn72RfBsYcJQJf1D5NTRH5Ot3zbg=
Message-ID: <8db4defe-8b5e-4cc3-880b-72d46510b034@arm.com>
Date: Thu, 16 Apr 2026 17:26:08 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] raid6: arm64: add SVE optimized implementation for
 syndrome generation
To: Demian Shulhan <demyansh@gmail.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Mark Rutland <mark.rutland@arm.com>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Li Nan <linan122@huawei.com>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260318150245.3080719-1-demyansh@gmail.com>
 <f9bc0534-4b7a-4b14-974b-4d7811ccd899@app.fastmail.com>
 <acJhCCPfVxjFUZ5R@J2N7QTR9R3>
 <CAOLeWCsxhzdxQviizJ4X4VOp_28LCtO-RjWoCcZG29rQw86NVg@mail.gmail.com>
 <9a12e043-8200-4650-bfe2-cbece57a4f87@app.fastmail.com>
 <20260331063659.GA2061@lst.de>
 <CAOLeWCtnZz=kHGk4C2f9Mbfi3tEBE100iCkMBhcG47dmR9eDWw@mail.gmail.com>
 <CAOLeWCtxPk7q_bVvrcKaipSKr+_=57Auobcj0cFRvXxXMdH58g@mail.gmail.com>
 <5158e4e0-3275-4c29-a8fc-2dfabc13a69d@app.fastmail.com>
 <CAOLeWCtf2rZyPeJH-LuZ2A+c7mC9M2r-Ya0VjyOJFpun3TFMnw@mail.gmail.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <CAOLeWCtf2rZyPeJH-LuZ2A+c7mC9M2r-Ya0VjyOJFpun3TFMnw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16/04/2026 3:59 pm, Demian Shulhan wrote:
> Hi Ard!
> 
>> So what exactly did you fix in your test case?
> 
> I just added the missing memset. You're right, "aliasing" was the
> wrong term for PIP.
> 
>> This is the result where all data buffer pointers point to the same
>> memory, right? I.e., the zero page? So this is an unrealistic use
>> case that we can disregard.
> 
> Yes, that's right. It was a flaw in my previous test setup.
> 
>> Sorry but your result that SVE is 2x faster does not remain fully intact,
>> right? Given that the speedup is now 5.5%?
>> Should we just disregard the above results (and explanations) and focus
>> on the stuff below?
> 
> Yes, it's better to focus on the data from SnapRAID. It was made on
> larger blocks and a wider range of disks, providing more realistic
> metrics.
> 
>> OK, so the takeaway here is that SVE is only worth the hassle if the vector
>> length is at least 256 bits. This is not entirely surprising, but given that
>> Graviton4 went back to 128 bit vectors from 256, I wonder what the future
>> expectation is here.
> 
> I agree. The results from the SnapRAID tests are not as impressive as
> I hoped, and the fact that Neoverse-V2 went back to 128-bit is a red
> flag. It suggests that wide SVE registers might not be a priority in
> future architecture versions.

If you look at the Neoverse V1 software optimisation guide[1], the SVE 
instructions generally have half the throughput of their ASIMD 
equivalents (i.e. presumably the vector pipes are still only 128 bits 
wide and SVE is just using them in pairs), so indeed the total 
instruction count is largely meaningless - IPC might be somewhat more 
relevant, but I'd say the only performance number that's really 
meaningful is the end-to-end MB/s measure of how fast the function 
implementation as a whole can process data.

Unless you've got a CPU with truly big wide vector units that _can't_ be 
fully utilised by ASMID ops, then SVE is only really offering whatever 
incidental benefits fall out of smaller code size. However, if you do 
have those wider vectors, then the cost of correctly saving/restoring 
the SVE state - of which a userspace benchmark isn't likely to be very 
representative - is also going to scale up significantly.

>> These results seem very relevant - perhaps Christoph can give some guidance
>> on how we might use these to improve the built-in benchmarks to be more
>> accurate.
> 
> This is the most important part of this report, I think. SVE looks
> good only like my first idea on paper but in the real scenario it
> brings more problems than benefits.
> 
> I’m happy to drop the SVE implementation for now and instead focus on
> modernizing the built-in benchmarks to ensure the kernel chooses the
> best available NEON path for actual storage workloads.

It's probably also worth checking whether the current NEON routines 
themselves are actually optimal for modern big CPUs - things have moved 
on quite a bit since Cortex-A57 (whose ASIMD performance could also be 
described as "esoteric" at the best of times...)

Thanks,
Robin.

[1] https://developer.arm.com/documentation/110659/

> 
> If you give me the green flag for it, I can start working on improving
> these built-in tests.
> 
> Best regards,
> Demian
> 
> 
> чт, 16 квіт. 2026 р. о 16:40 Ard Biesheuvel <ardb@kernel.org> пише:
>>
>> Hi Demian,
>>
>> On Thu, 16 Apr 2026, at 14:40, Demian Shulhan wrote:
>>> Hi all,
>>>
>>> Sorry for the delay. The tests became more complex than I initially
>>> thought, so I needed to gather more data and properly validate the
>>> results across different hardware configurations.
>>>
>>> Firstly, I want to clarify the results from my March 29 tests. I found
>>> a flaw in my initial custom benchmark. The massive 2x throughput gap on
>>> 24 disks wasn't solely due to SVE's superiority, but rather a severe L1
>>> D-Cache thrashing issue that disproportionately penalized NEON.
>>>
>>> My custom test lacked memset() initialization, causing all data buffers
>>> to map to the Linux Zero Page (Virtually Indexed, Physically Tagged
>>> cache aliasing).
>>
>> D-caches always behave as PIPT on arm64. This is complex stuff, so please
>> don't present conjecture as fact.
>>
>>> Furthermore, even with memset(), allocating contiguous
>>> page-aligned buffers can causes severe Cache Address Sharing (a known
>>> issue that Andrea Mazzoleni solved in SnapRAID 13 years ago using
>>> RAID_MALLOC_DISPLACEMENT).
>>>
>>> Because SVE (svex4) uses 256-bit registers on Neoverse-V1, it performs
>>> exactly half the number of memory load instructions compared to 128-bit
>>> NEON. This dramatically reduced the L1 cache alias thrashing, allowing
>>> SVE to survive the memory bottleneck while NEON choked:
>>>
>>
>> You are drawing some conclusions here without disclosing the actual
>> information that you based this on. D-caches are non-aliasing on arm64.
>>
>> So what exactly did you fix in your test case?
>>
>>> Custom test without memset (4kb block):
>>>   | algo=neonx4 ndisks=24 iterations=1M time=11.014s MB/s=7802.57
>>>   | algo=svex4  ndisks=24 iterations=1M time=5.719s  MB/s=15026.92
>>>
>>
>> This is the result where all data buffer pointers point to the same
>> memory, right? I.e., the zero page? So this is an unrealistic use
>> case that we can disregard.
>>
>>> Custom test with memset (4kb block):
>>>   | algo=neonx4 ndisks=24 iterations=1M time=6.165s  MB/s=13939.08
>>>   | algo=svex4  ndisks=24 iterations=1M time=5.839s  MB/s=14718.23
>>>
>>> Even with the corrected memory setup, the throughput gap narrowed, but
>>> the fundamental CPU-efficiency result remained fully intact.
>>>
>>
>> Sorry but your result that SVE is 2x faster does not remain fully intact,
>> right? Given that the speedup is now 5.5%?
>>
>> Should we just disregard the above results (and explanations) and focus
>> on the stuff below?
>>
>>> To completely isolate these variables and provide accurate real-world
>>> data, the following test campaigns were done based on the SnapRAID
>>> project (https://github.com/amadvance/snapraid) using its
>>> perf_bench.c tool with proper memory displacement and a 256 KiB block
>>> size.
>>>
>>> Test configurations:
>>> - c7g.medium (AWS Graviton3, 1 vCPU): Neoverse-V1, 256-bit SVE
>>> - c7g.xlarge (AWS Graviton3, 4 vCPUs): Neoverse-V1, 256-bit SVE
>>> - c8g.xlarge (AWS Graviton4, 4 vCPUs): Neoverse-V2, 128-bit SVE
>>>
>>>
>>> =========================================================
>>> Section 1: SnapRAID Validation on Graviton3 / Neoverse-V1
>>> =========================================================
>>>
>> ...
>>>
>>> 1.3 Main Graviton3 Conclusions
>>>   - On 256-bit SVE hardware, svex4 consistently retires about ~34% fewer
>>>     instructions and ~10-15% fewer CPU cycles than neonx4.
>>>
>>> =========================================================
>>> Section 2: SnapRAID Validation on Graviton4 / Neoverse-V2
>>> =========================================================
>>>
>> ...
>>>
>>> 2.3 Main Graviton4 Conclusions
>>>   - On Neoverse-V2, SVE vector length is 128-bit (same as NEON).
>>>   - Without the 256-bit width, NEON outperforms SVE.
>>>   - svex4 retires ~32% MORE instructions here and is consistently slower.
>>>
>>> =========================================================
>>> Section 3: Validation on c7g.medium (1 vCPU)
>>> =========================================================
>>>
>> ...
>>> 3.3 Main c7g.medium Conclusions
>>>   - The instruction count reduction (~34%) perfectly matches the 4-vCPU
>>>     instance.
>>>   - The single vCPU is heavily memory-bandwidth constrained (cycle counts
>>>     are much higher waiting for RAM).
>>>
>>
>> OK, so the takeaway here is that SVE is only worth the hassle if the vector
>> length is at least 256 bits. This is not entirely surprising, but given that
>> Graviton4 went back to 128 bit vectors from 256, I wonder what the future
>> expectation is here.
>>
>> But having these numbers is definitely a good first step. Now we need to
>> quantify the overhead associated with having kernel mode SVE state that
>> needs to be preserved/restored.
>>
>> However, 10%-15% speedup that can only be achieved on SVE implementations
>> with 256 bit vectors or more may not be that enticing in the end. (The
>> fact that you are retiring 34% instructions less does not really matter
>> here unless there is some meaningful SMT-like sharing of functional units
>> going on in the meantime, which seems unlikely on a CPU that is maxed out
>> on the data side)
>>
>>
>>> =========================================================
>>> Section 4: The Pitfalls of the Current Kernel Benchmark
>>> =========================================================
>>>
>>
>> These results seem very relevant - perhaps Christoph can give some guidance
>> on how we might use these to improve the built-in benchmarks to be more
>> accurate.
>>
>>
>> Thanks,
>>

