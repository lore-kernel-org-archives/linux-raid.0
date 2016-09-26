From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2] raid6/test/test.c: bug fix: Specify
 aligned(alignment) attributes to the char arrays
Date: Mon, 26 Sep 2016 10:47:45 -0700
Message-ID: <20160926174745.GA16209@kernel.org>
References: <1474589275-12045-1-git-send-email-gayatri.kammela@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1474589275-12045-1-git-send-email-gayatri.kammela@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gayatri Kammela <gayatri.kammela@intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, h.peter.anvin@intel.com, ravi.v.shankar@intel.com, fenghua.yu@intel.com, "H . Peter Anvin" <hpa@zytor.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-raid.ids

On Thu, Sep 22, 2016 at 05:07:55PM -0700, Gayatri Kammela wrote:
> Specifying the aligned attributes to the char recovi[PAGE_SIZE]
> and char recovi[PAGE_SIZE] arrays, so that all malloc memory is page
> boundary aligned.
> 
> Without these alignment attributes, the test causes a segfault in
> userspace when the NDISKS are changed to 4 from 16.
> 
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
> Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
> ---
>  lib/raid6/test/test.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/raid6/test/test.c b/lib/raid6/test/test.c
> index 3bebbabdb510..32a00f11ac50 100644
> --- a/lib/raid6/test/test.c
> +++ b/lib/raid6/test/test.c
> @@ -21,12 +21,13 @@
>  
>  #define NDISKS		16	/* Including P and Q */
>  
> -const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(256)));
> +const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
>  struct raid6_calls raid6_call;
>  
>  char *dataptrs[NDISKS];
>  char data[NDISKS][PAGE_SIZE];

shouldn't this one be page aligned too?

> -char recovi[PAGE_SIZE], recovj[PAGE_SIZE];
> +char recovi[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
> +char recovj[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
>  
>  static void makedata(int start, int stop)
>  {
> -- 
> 2.7.4
> 
