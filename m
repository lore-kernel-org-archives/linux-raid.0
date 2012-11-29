From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] lib/raid6: Add AVX2 optimized recovery functions
Date: Thu, 29 Nov 2012 13:13:28 -0800
Message-ID: <50B7CFF8.7010401@zytor.com>
References: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com> <m2obigf9xa.fsf@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <m2obigf9xa.fsf@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>, Linux Raid <linux-raid@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 11/29/2012 12:09 PM, Andi Kleen wrote:
> Jim Kukunas <james.t.kukunas@linux.intel.com> writes:
>> +
>> +	/* ymm0 = x0f[16] */
>> +	asm volatile("vpbroadcastb %0, %%ymm7" : : "m" (x0f));
>> +
>> +	while (bytes) {
>> +#ifdef CONFIG_X86_64
>> +		asm volatile("vmovdqa %0, %%ymm1" : : "m" (q[0]));
>> +		asm volatile("vmovdqa %0, %%ymm9" : : "m" (q[32]));
>> +		asm volatile("vmovdqa %0, %%ymm0" : : "m" (p[0]));
>> +		asm volatile("vmovdqa %0, %%ymm8" : : "m" (p[32]));
> 
> This is somewhat dangerous to assume registers do not get changed
> between assembler statements or assembler statements do not get
> reordered. Better always put such values into explicit variables or
> merge them into a single asm statement.
> 
> asm volatile is also not enough to prevent reordering. If anything
> you would need a memory clobber.
> 

The code is compiled so that the xmm/ymm registers are not available to
the compiler.  Do you have any known examples of asm volatiles being
reordered *with respect to each other*?  My understandings of gcc is
that volatile operations are ordered with respect to each other (not
necessarily with respect to non-volatile operations, though.)

Either way, this implementatin technique was used for the MMX/SSE
implementations without any problems for 9 years now.

	-h[a
