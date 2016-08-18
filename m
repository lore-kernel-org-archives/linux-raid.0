From: Zhengyuan Liu <liuzhengyuang521@gmail.com>
Subject: raid6 algorithm issues with 64K page_size
Date: Thu, 18 Aug 2016 16:06:49 +0800
Message-ID: <CAOOPZo6WJgMu-UoVrMfOfZWOABLNzDoYj-eEdiuSRk06Yxfeqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, ravi.v.shankar@intel.com, Gayatri Kammela <gayatri.kammela@intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Jim Kukunas <james.t.kukunas@linux.intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Megha Dey <megha.dey@linux.intel.com>, =?UTF-8?B?5YiY5LqR?= <liuyun01@kylinos.cn>, =?UTF-8?B?6IOh5rW3?= <huhai@kylinos.cn>
List-Id: linux-raid.ids

G' day all,

The kernel would try to pick the best algorithm for raid6 to compute two
syndromes, generally referred to P and Q  at boot time. Part of the algorithm
code was showed bellow from lib/raid6/algos.c:

   int __init raid6_select_algo(void)
   {
        const int disks = (65536/PAGE_SIZE)+2;

        const struct raid6_calls *gen_best;
        const struct raid6_recov_calls *rec_best;
        char *syndromes;
        void *dptrs[(65536/PAGE_SIZE)+2];
        int i;

        for (i = 0; i < disks-2; i++)
                dptrs[i] = ((char *)raid6_gfmul) + PAGE_SIZE*i;

        /* Normal code - use a 2-page allocation to avoid D$ conflict */
        syndromes = (void *) __get_free_pages(GFP_KERNEL, 1);

        if (!syndromes) {
                pr_err("raid6: Yikes!  No memory available.\n");
                return -ENOMEM;
        }

        dptrs[disks-2] = syndromes;
        dptrs[disks-1] = syndromes + PAGE_SIZE;

        /* select raid gen_syndrome function */
        gen_best = raid6_choose_gen(&dptrs, disks);

        /* select raid recover functions */
        rec_best = raid6_choose_recov()

The data set to use for computing syndromes  is gfmul table, it was defined as
"u8 raid6_gfmul[256][256]" and size to be 65536 Bytes or 64KB . From
the code we can see it use gfmul table size and PAGE_SIZE to determine
the disk number.  If the PAGE_SIZE is 4K, then the number of disks got
to be 18 and 10 for 8K, 3 for 64K. As we all know, raid6 needs at
least 4 disks.

Could we just define a constantly macro for disks as the test program does in
lib/raid6/test/test.c, not depend on page size  and not use gfmul
table as the data source of disks?

Move further, bigger page size like 128K would encounter the same problem.
