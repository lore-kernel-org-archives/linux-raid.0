From: colyli@suse.de
Subject: [PATCH v2 3/4] raid5: update code comment of scribble_alloc()
Date: Thu,  9 Apr 2020 19:52:57 +0800
Message-ID: <20200409115258.19330-4-colyli@suse.de>
References: <20200409115258.19330-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200409115258.19330-1-colyli@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: songliubraving@fb.com, linux-raid@vger.kernel.org
Cc: mhocko@suse.com, kent.overstreet@gmail.com, guoqing.jiang@cloud.ionos.com, Coly Li <colyli@suse.de>
List-Id: linux-raid.ids

From: Coly Li <colyli@suse.de>

Code comments of scribble_alloc() is outdated for a while. This patch
update the comments in function header for the new parameter list.

Suggested-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/raid5.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 190dd70db514..ab8067f9ce8c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2215,10 +2215,13 @@ static int grow_stripes(struct r5conf *conf, int num)
 }
 
 /**
- * scribble_len - return the required size of the scribble region
+ * scribble_alloc - allocate percpu scribble buffer for required size
+ *		    of the scribble region
+ * @percpu - from for_each_present_cpu() of the caller
  * @num - total number of disks in the array
+ * @cnt - scribble objs count for required size of the scribble region
  *
- * The size must be enough to contain:
+ * The scribble buffer size must be enough to contain:
  * 1/ a struct page pointer for each device in the array +2
  * 2/ room to convert each entry in (1) to its corresponding dma
  *    (dma_map_page()) or page (page_address()) address.
-- 
2.25.0
