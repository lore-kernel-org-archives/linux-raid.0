From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 50/78] shmem: Convert shmem_partial_swap_usage
 to XArray
Date: Fri, 15 Dec 2017 14:04:22 -0800
Message-ID: <20171215220450.7899-51-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-raid@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-usb@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Rehas Sachdeva <aquannie@gmail.com>, Shaohua Li <shli@kernel.org>, linux-btrfs@vger.kernel.org
List-Id: linux-raid.ids

From: Matthew Wilcox <mawilcox@microsoft.com>

Simpler code because the xarray takes care of things like the limit and
dereferencing the slot.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index dd663341e01e..ecf05645509b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -658,29 +658,17 @@ static int shmem_free_swap(struct address_space *mapping,
 unsigned long shmem_partial_swap_usage(struct address_space *mapping,
 						pgoff_t start, pgoff_t end)
 {
-	struct radix_tree_iter iter;
-	void **slot;
+	XA_STATE(xas, &mapping->pages, start);
 	struct page *page;
 	unsigned long swapped = 0;
 
 	rcu_read_lock();
-
-	radix_tree_for_each_slot(slot, &mapping->pages, &iter, start) {
-		if (iter.index >= end)
-			break;
-
-		page = radix_tree_deref_slot(slot);
-
-		if (radix_tree_deref_retry(page)) {
-			slot = radix_tree_iter_retry(&iter);
-			continue;
-		}
-
+	xas_for_each(&xas, page, end - 1) {
 		if (xa_is_value(page))
 			swapped++;
 
 		if (need_resched()) {
-			slot = radix_tree_iter_resume(slot, &iter);
+			xas_pause(&xas);
 			cond_resched_rcu();
 		}
 	}
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
