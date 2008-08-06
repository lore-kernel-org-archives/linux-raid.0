From: Dan Williams <dan.j.williams@intel.com>
Subject: [git pull] async_xor_zero_sum fix
Date: Wed, 06 Aug 2008 11:07:18 -0700
Message-ID: <1218046038.27840.5.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yuri Tikhonov <"<yur"@emcraft.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Linus, please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git fixes

...to receive:

commit e34a8ae79056e6cea4a1ac21119ee3c91f378f99
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Aug 5 10:22:05 2008 -0700

    async_tx: fix missing braces in async_xor_zero_sum
    
    Found-by: Yuri Tikhonov <yur@emcraft.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 65974c6..c029d3e 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -263,11 +263,12 @@ async_xor_zero_sum(struct page *dest, struct page **src_list,
 		if (unlikely(!tx)) {
 			async_tx_quiesce(&depend_tx);
 
-			while (!tx)
+			while (!tx) {
 				dma_async_issue_pending(chan);
 				tx = device->device_prep_dma_zero_sum(chan,
 					dma_src, src_cnt, len, result,
 					dma_prep_flags);
+			}
 		}
 
 		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);


