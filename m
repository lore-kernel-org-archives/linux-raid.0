From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH 05/12] raid5-ppl: Partial Parity Log implementation
Date: Fri, 25 Nov 2016 09:52:14 +0100
Message-ID: <9ea16e3a-d08d-ffd0-d9cf-e38d80164f9a@intel.com>
References: <201611251045.EItygkLe%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201611251045.EItygkLe%fengguang.wu@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, shli@kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/25/2016 03:26 AM, kbuild test robot wrote:
> Hi Artur,
> 
> [auto build test ERROR on next-20161124]
> [cannot apply to md/for-next v4.9-rc6 v4.9-rc5 v4.9-rc4 v4.9-rc6]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Artur-Paszkiewicz/Partial-Parity-Log-for-MD-RAID-5/20161125-100404
> config: m68k-sun3_defconfig (attached as .config)
> compiler: m68k-linux-gcc (GCC) 4.9.0
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=m68k 
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/md/raid5-ppl.c: In function 'ppl_init_log_child':
>>> drivers/md/raid5-ppl.c:429:2: error: too few arguments to function 'bio_init'
>      bio_init(&log->flush_bio);
>      ^
>    In file included from include/linux/blkdev.h:19:0,
>                     from drivers/md/raid5-ppl.c:16:
>    include/linux/bio.h:423:13: note: declared here
>     extern void bio_init(struct bio *bio, struct bio_vec *table,
>                 ^

This whole patchset applies cleanly on Shaohua's md for-next tree. It
does not contain the patches that change bio_init().

Artur
