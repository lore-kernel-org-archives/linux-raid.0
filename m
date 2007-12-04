From: Yuri Tikhonov <yur@emcraft.com>
Subject: [md-raid6-accel PATCH 00/12] md raid-6 acceleration
Date: Tue, 4 Dec 2007 14:24:49 +0300
Message-ID: <200712041424.50131.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 Hello, all.

 The following patch-set includes enhancements to the async_tx api and
modifications to md-raid6 to issue memory copies and parity calculations
asynchronously. Thus we may process copy operations and RAID-6 calculations
on the dedicated DMA engines accessible with ASYNC_TX API, and, as a result
off-load CPU, and improve the performance.

 The most impressive performance improvement results are being achieved
with big size of strips (i.e. PAGE_SIZE). Here are the comparative results
of the RAID-6 full-stripe write throuputs with different strip size values
(4KB/16KB/64KB):

(a) old s/w Linux RAID-6:
04K: 36 MBps;
16K: 39 MBps;
64K: 40 MBps;

(b) asynchronous s/w RAID-6:
04K: 32 MBps;
16K: 48 MBps;
64K: 48 MBps;

(c) asynchronous h/w accelerated RAID-6:
04K: 48 MBps;
16K: 94 MBps;
64K: 114 MBps.

 The example of the test commands used, say, in the 4KB case:
# mdadm -C /dev/md0 -l6 -c 16 -n 6 -z 1024000 /dev/sd[a-f]
# xdd -op write -kbytes 64000 -reqsize 64 -dio -syncwrite -target /dev/md0

 Admittedly, the 4K case for items (a) and (b) above looks not good, at least in
the RAID-5 case we do not have even such a small degradation. So, perhaps
there are some ways of further improvements in the RAID-6 code. Any suggestions
would be greatly appreciate.

 As far as the patch-set itself is concerned, its division (as well as the
most of the code) was based on the RAID-5 patch-set posted to ML by Dan
Williams on 07.06.27. The patches were generated against the
28b752d44a3696cde1d6b9790d7ae3b324d11571 commit-id ["raid5: use stripe_queues
to prioritize the "most deserving" requests (rev8)"] of
git://lost.foo-projects.org/~dwillia2/git/iop "md-for-linus" branch.

 To reduce the code duplication in the raid driver this patch-set modifies
some raid-5 functions to make them possible to use in the raid-6 case.

- raid-6 shares the following functions with raid-5 (no specific division):
 ops_run_io();
 async_copy_data();
 ops_complete_biofill();
 ops_run_biofill();
 ops_complete_postxor();

- the following functions require sub-division inside:
 ops_complete_compute() [based on ops_complete_compute5()];
 ops_run_biodrain();
 ops_complete_write();
 ops_run_postxor();
 ops_complete_check();
 raid_run_ops() [based on raid5_run_ops()]


- the following functions are raid-5/6 specific only:
 ops_run_compute6_1();
 ops_run_compute6_2();
 ops_run_check5() [renamed from ops_run_check()];
 ops_run_check6();

 The patch-set can be broken down into thee following main categories: 

1) Additions to ASYNC_TX API (patches 1-2)
2) RAID-6 implementation (patches 3-11)
3) ppc440spe ADMA driver (patch 12)

 Here are the ingredients:

[md-raid6-accel PATCH 01/12] async_tx: PQXOR implementation 
[md-raid6-accel PATCH 02/12] async_tx: RAID-6 recovery implementation
[md-raid6-accel PATCH 03/12] md: run stripe operations outside the lock
[md-raid6-accel PATCH 04/12] md: common handle_stripe6() infrastructure
[md-raid6-accel PATCH 05/12] md: req/comp logic for async write operations
[md-raid6-accel PATCH 06/12] md: req/comp logic for async compute operations
[md-raid6-accel PATCH 07/12] md: req/comp logic for async check operations
[md-raid6-accel PATCH 08/12] md: req/comp logic for async read operations
[md-raid6-accel PATCH 09/12] md: req/comp logic for async expand operations
[md-raid6-accel PATCH 10/12] md: req/comp logic for async I/O operations
[md-raid6-accel PATCH 11/12] md: remove unused functions
[md-raid6-accel PATCH 12/12] adma: ppc440spe DMA engines driver

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
