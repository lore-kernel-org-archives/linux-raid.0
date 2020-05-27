From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v3 07/11] md/raid5: add offset array in scribble buffer
Date: Wed, 27 May 2020 21:19:29 +0800
Message-ID: <20200527131933.34400-8-yuyufen@huawei.com>
References: <20200527131933.34400-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200527131933.34400-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, colyli@suse.de, xni@redhat.com, houtao1@huawei.com, yuyufen@huawei.com
List-Id: linux-raid.ids

When enable shared buffers for stripe_head, it need an offset
array to record page offset to compute xor. To avoid repeatly allocate
an new array each time, we add a memory region into scribble buffer
to record offset.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4b7b5cc1ba1f..b97ebc7b5747 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1467,6 +1467,15 @@ static addr_conv_t *to_addr_conv(struct stripe_head *sh,
 	return (void *) (to_addr_page(percpu, i) + sh->disks + 2);
 }
 
+/*
+ * Return a pointer to record offset address.
+ */
+static unsigned int *
+to_addr_offs(struct stripe_head *sh, struct raid5_percpu *percpu)
+{
+	return (unsigned int *) (to_addr_conv(sh, percpu, 0) + sh->disks + 2);
+}
+
 static struct dma_async_tx_descriptor *
 ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
@@ -2315,8 +2324,9 @@ static int scribble_alloc(struct raid5_percpu *percpu,
 			  int num, int cnt, gfp_t flags)
 {
 	size_t obj_size =
-		sizeof(struct page *) * (num+2) +
-		sizeof(addr_conv_t) * (num+2);
+		sizeof(struct page *) * (num + 2) +
+		sizeof(addr_conv_t) * (num + 2) +
+		sizeof(unsigned int) * (num + 2);
 	void *scribble;
 
 	scribble = kvmalloc_array(cnt, obj_size, flags);
-- 
2.21.3
