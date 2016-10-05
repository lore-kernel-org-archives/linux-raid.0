From: Shaohua Li <shli@kernel.org>
Subject: Re: Prefetch in /lib/raid6/avx2.c
Date: Wed, 5 Oct 2016 16:17:10 -0700
Message-ID: <20161005231710.GB2804@kernel.org>
References: <CAFx4rwS5-TCWKxRYpXHeRsfTiJ=mTV0gxoL-yUuqoEbpXst08A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFx4rwS5-TCWKxRYpXHeRsfTiJ=mTV0gxoL-yUuqoEbpXst08A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Dumitru <doug@easyco.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, gayatri.kammela@intel.com, ravi.v.shankar@intel.com, hpa@zytor.com, yu-cheng.yu@intel.com, yuanhan.liu@intel.com
List-Id: linux-raid.ids

On Sun, Oct 02, 2016 at 03:40:09PM -0700, Doug Dumitru wrote:
> I have been doing some high bandwidth testing of raid-6, and the
> pretetch in raid6_avx24_gen_syndrome appears to be less than optimal.
> 
> This is my patch (against 4.4.0-38 [Ubuntu 16.04LTS)
> 
> --- cut here ---
> --- lib/raid6/avx2.c0   2016-10-01 21:42:25.280347868 -0700
> +++ lib/raid6/avx2.c    2016-10-02 15:35:48.168480760 -0700
> @@ -189,10 +189,8 @@
> 
>                 for (z = z0; z >= 0; z--) {
> 
> -                       asm volatile("prefetchnta %0" : : "m" (dptr[z][d]));
> -                       asm volatile("prefetchnta %0" : : "m" (dptr[z][d+32]));
> -                       asm volatile("prefetchnta %0" : : "m" (dptr[z][d+64]));
> -                       asm volatile("prefetchnta %0" : : "m" (dptr[z][d+96]));
> +                       asm volatile("prefetchnta %0" : : "m" (dptr[z][d+128]));
> +                       asm volatile("prefetchnta %0" : : "m" (dptr[z][d+192]));
> 
>                         asm volatile("vpcmpgtb %ymm4,%ymm1,%ymm5");
>                         asm volatile("vpcmpgtb %ymm6,%ymm1,%ymm7");
> --- cut here ---
> 
> In perf, the cpu cycles goes from 5.3% to 3.0% for
> raid6_avx24_gen_syndrome in my test and throughput increases from
> about 8.2GB/sec to almost 10GB/sec.  It is a very "synthetic" test,
> but the avx2 code does seem to be a factor.
> 
> I suspect other SSE and AVX "unroll variants" have similar issues, but
> I have not tested those.
> 
> My test system is an E5-1650 v3 (single socket) with DDR4.  This might
> help dual sockets even more.

CC some intel folks to see if they have ideas
