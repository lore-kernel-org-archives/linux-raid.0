From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] lib/raid6: Add AVX2 optimized recovery functions
Date: Thu, 29 Nov 2012 12:09:37 -0800
Message-ID: <m2obigf9xa.fsf@firstfloor.org>
References: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com>
	(Jim Kukunas's message of "Thu, 8 Nov 2012 13:47:44 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-raid.ids

Jim Kukunas <james.t.kukunas@linux.intel.com> writes:
> +
> +	/* ymm0 = x0f[16] */
> +	asm volatile("vpbroadcastb %0, %%ymm7" : : "m" (x0f));
> +
> +	while (bytes) {
> +#ifdef CONFIG_X86_64
> +		asm volatile("vmovdqa %0, %%ymm1" : : "m" (q[0]));
> +		asm volatile("vmovdqa %0, %%ymm9" : : "m" (q[32]));
> +		asm volatile("vmovdqa %0, %%ymm0" : : "m" (p[0]));
> +		asm volatile("vmovdqa %0, %%ymm8" : : "m" (p[32]));

This is somewhat dangerous to assume registers do not get changed
between assembler statements or assembler statements do not get
reordered. Better always put such values into explicit variables or
merge them into a single asm statement.

asm volatile is also not enough to prevent reordering. If anything
you would need a memory clobber.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
