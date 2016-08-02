From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 0/4] Add AVX512 optimized gen_syndrome and recovery
 functions
Date: Tue, 2 Aug 2016 15:03:14 -0700
Message-ID: <20160802220314.GA98613@kernel.org>
References: <1468005353-26194-1-git-send-email-gayatri.kammela@intel.com>
 <2824B99DC70CE746926327C52CA42F7613649559@ORSMSX111.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2824B99DC70CE746926327C52CA42F7613649559@ORSMSX111.amr.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kammela, Gayatri" <gayatri.kammela@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Aug 02, 2016 at 09:08:39PM +0000, Kammela, Gayatri wrote:
> Hi shaohua,
> I am wondering if there are any comments on this patch series ?

I didn't see the patches in my mailbox. please resend.

> Thanks,
> Gayatri Kammela
> 
> -----Original Message-----
> From: Kammela, Gayatri 
> Sent: Friday, July 8, 2016 12:16 PM
> To: linux-raid@vger.kernel.org
> Cc: shli@kernel.org; linux-kernel@vger.kernel.org; Kammela, Gayatri <gayatri.kammela@intel.com>
> Subject: [PATCH 0/4] Add AVX512 optimized gen_syndrome and recovery functions
> 
> This is the patch set for adding AVX512 optimized gen_syndrome and recovery functions.
> 
> Optimization of RAID6 using AVX512 instructions should improve the
> RAID6 performance.These patches are tested and observed the improvement in performance.
> 
> Gayatri Kammela (4):
>   lib/raid6: Add AVX512 optimized gen_syndrome functions
>   lib/raid6: Add AVX512 optimized recovery functions
>   lib/raid6/test/Makefile: Add avx512 gen_syndrome and recovery
>     functions
>   lib/raid6: Add unroll by 8 to AVX512 optimized gen_syndrome functions
> 
>  arch/x86/Makefile        |   5 +-
>  include/linux/raid/pq.h  |   5 +
>  lib/raid6/Makefile       |   2 +-
>  lib/raid6/algos.c        |  13 ++
>  lib/raid6/avx512.c       | 466 +++++++++++++++++++++++++++++++++++++++++++++++
>  lib/raid6/recov_avx512.c | 335 ++++++++++++++++++++++++++++++++++
>  lib/raid6/test/Makefile  |   5 +-
>  lib/raid6/x86.h          |  10 +
>  8 files changed, 837 insertions(+), 4 deletions(-)  create mode 100644 lib/raid6/avx512.c  create mode 100644 lib/raid6/recov_avx512.c
> 
> --
> 1.9.1
> 
