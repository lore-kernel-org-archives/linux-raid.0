From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 12/17] md: raid1: avoid direct access to bvec table in
 process_checks()
Date: Fri, 17 Feb 2017 16:33:44 +0800
Message-ID: <201702171655.FrLZYMKp%fengguang.wu@intel.com>
References: <1487245547-24384-13-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="SUOF0GtieIMvvwua"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487245547-24384-13-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: kbuild-all@01.org, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>, Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Ming,

[auto build test WARNING on linus/master]
[also build test WARNING on v4.10-rc8]
[cannot apply to next-20170216]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Ming-Lei/md-cleanup-on-direct-access-to-bvec-table/20170216-210357
config: powerpc-cell_defconfig (attached as .config)
compiler: powerpc64-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=powerpc 

Note: it may well be a FALSE warning. FWIW you are at least aware of it now.
http://gcc.gnu.org/wiki/Better_Uninitialized_Warnings

All warnings (new ones prefixed by >>):

   In file included from arch/powerpc/include/asm/page.h:331:0,
                    from arch/powerpc/include/asm/thread_info.h:34,
                    from include/linux/thread_info.h:25,
                    from include/asm-generic/preempt.h:4,
                    from ./arch/powerpc/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:59,
                    from include/linux/spinlock.h:50,
                    from include/linux/mmzone.h:7,
                    from include/linux/gfp.h:5,
                    from include/linux/slab.h:14,
                    from drivers/md/raid1.c:34:
   drivers/md/raid1.c: In function 'raid1d':
>> include/asm-generic/memory_model.h:54:52: warning: 'sbio_pages$' may be used uninitialized in this function [-Wmaybe-uninitialized]
    #define __page_to_pfn(page) (unsigned long)((page) - vmemmap)
                                                       ^
   drivers/md/raid1.c:2008:42: note: 'sbio_pages$' was declared here
     struct page *pbio_pages[RESYNC_PAGES], *sbio_pages[RESYNC_PAGES];
                                             ^~~~~~~~~~
   drivers/md/raid1.c:2075:9: warning: 'page_len$' may be used uninitialized in this function [-Wmaybe-uninitialized]
        if (memcmp(page_address(p),
            ^~~~~~~~~~~~~~~~~~~~~~~
            page_address(s),
            ~~~~~~~~~~~~~~~~
            page_len[j]))
            ~~~~~~~~~~~~
   drivers/md/raid1.c:2007:6: note: 'page_len$' was declared here
     int page_len[RESYNC_PAGES];
         ^~~~~~~~
   In file included from arch/powerpc/include/asm/page.h:331:0,
                    from arch/powerpc/include/asm/thread_info.h:34,
                    from include/linux/thread_info.h:25,
                    from include/asm-generic/preempt.h:4,
                    from ./arch/powerpc/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:59,
                    from include/linux/spinlock.h:50,
                    from include/linux/mmzone.h:7,
                    from include/linux/gfp.h:5,
                    from include/linux/slab.h:14,
                    from drivers/md/raid1.c:34:
>> include/asm-generic/memory_model.h:54:52: warning: 'pbio_pages$' may be used uninitialized in this function [-Wmaybe-uninitialized]
    #define __page_to_pfn(page) (unsigned long)((page) - vmemmap)
                                                       ^
   drivers/md/raid1.c:2008:15: note: 'pbio_pages$' was declared here
     struct page *pbio_pages[RESYNC_PAGES], *sbio_pages[RESYNC_PAGES];
                  ^~~~~~~~~~
   drivers/md/raid1.c:1978:8: warning: 'pages$' may be used uninitialized in this function [-Wmaybe-uninitialized]
       if (r1_sync_page_io(rdev, sect, s,
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
             pages[idx],
             ~~~~~~~~~~~
             READ) != 0)
             ~~~~~
   drivers/md/raid1.c:1872:15: note: 'pages$' was declared here
     struct page *pages[RESYNC_PAGES];
                  ^~~~~

vim +54 include/asm-generic/memory_model.h

a117e66e KAMEZAWA Hiroyuki  2006-03-27  38  ({	unsigned long __pfn = (pfn);		\
c5d71243 Rafael J. Wysocki  2008-11-08  39  	unsigned long __nid = arch_pfn_to_nid(__pfn);  \
a117e66e KAMEZAWA Hiroyuki  2006-03-27  40  	NODE_DATA(__nid)->node_mem_map + arch_local_page_offset(__pfn, __nid);\
a117e66e KAMEZAWA Hiroyuki  2006-03-27  41  })
a117e66e KAMEZAWA Hiroyuki  2006-03-27  42  
67de6482 Andy Whitcroft     2006-06-23  43  #define __page_to_pfn(pg)						\
aa462abe Ian Campbell       2011-08-17  44  ({	const struct page *__pg = (pg);					\
a0140c1d KAMEZAWA Hiroyuki  2006-03-27  45  	struct pglist_data *__pgdat = NODE_DATA(page_to_nid(__pg));	\
a0140c1d KAMEZAWA Hiroyuki  2006-03-27  46  	(unsigned long)(__pg - __pgdat->node_mem_map) +			\
a0140c1d KAMEZAWA Hiroyuki  2006-03-27  47  	 __pgdat->node_start_pfn;					\
a117e66e KAMEZAWA Hiroyuki  2006-03-27  48  })
a117e66e KAMEZAWA Hiroyuki  2006-03-27  49  
8f6aac41 Christoph Lameter  2007-10-16  50  #elif defined(CONFIG_SPARSEMEM_VMEMMAP)
8f6aac41 Christoph Lameter  2007-10-16  51  
af901ca1 André Goddard Rosa 2009-11-14  52  /* memmap is virtually contiguous.  */
8f6aac41 Christoph Lameter  2007-10-16  53  #define __pfn_to_page(pfn)	(vmemmap + (pfn))
32272a26 Martin Schwidefsky 2008-12-25 @54  #define __page_to_pfn(page)	(unsigned long)((page) - vmemmap)
8f6aac41 Christoph Lameter  2007-10-16  55  
a117e66e KAMEZAWA Hiroyuki  2006-03-27  56  #elif defined(CONFIG_SPARSEMEM)
a117e66e KAMEZAWA Hiroyuki  2006-03-27  57  /*
1a49123b Zhang Yanfei       2013-10-03  58   * Note: section's mem_map is encoded to reflect its start_pfn.
a117e66e KAMEZAWA Hiroyuki  2006-03-27  59   * section[i].section_mem_map == mem_map's address - start_pfn;
a117e66e KAMEZAWA Hiroyuki  2006-03-27  60   */
67de6482 Andy Whitcroft     2006-06-23  61  #define __page_to_pfn(pg)					\
aa462abe Ian Campbell       2011-08-17  62  ({	const struct page *__pg = (pg);				\

:::::: The code at line 54 was first introduced by commit
:::::: 32272a26974d2027384fd4010cd1780fca425d94 [S390] __page_to_pfn warnings

:::::: TO: Martin Schwidefsky <schwidefsky@de.ibm.com>
:::::: CC: Martin Schwidefsky <schwidefsky@de.ibm.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--SUOF0GtieIMvvwua
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
upIEbTwRdJpAqKOPZxTGbQwArdwta6IyAQA=

--SUOF0GtieIMvvwua--
