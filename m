From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 16/18] ioat3: segregate raid engines
Date: Thu, 03 Sep 2009 23:45:56 -0700
Message-ID: <20090904064556.7141.76580.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932945AbZIDGru@vger.kernel.org>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

The cleanup routine for the raid cases imposes extra checks for handling
raid descriptors and extended descriptors.  If the channel does not
support raid it can avoid this extra overhead by using the ioat2 cleanup
path.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma_v2.c |    4 ++--
 drivers/dma/ioat/dma_v2.h |    2 ++
 drivers/dma/ioat/dma_v3.c |   25 ++++++++++++++++++-------
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index e0600f4..a0d0971 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -206,7 +206,7 @@ static void ioat2_cleanup(struct ioat2_dma_chan *ioat)
 	spin_unlock_bh(&chan->cleanup_lock);
 }
 
-static void ioat2_cleanup_tasklet(unsigned long data)
+void ioat2_cleanup_tasklet(unsigned long data)
 {
 	struct ioat2_dma_chan *ioat = (void *) data;
 
@@ -258,7 +258,7 @@ static void ioat2_restart_channel(struct ioat2_dma_chan *ioat)
 	__ioat2_restart_chan(ioat);
 }
 
-static void ioat2_timer_event(unsigned long data)
+void ioat2_timer_event(unsigned long data)
 {
 	struct ioat2_dma_chan *ioat = (void *) data;
 	struct ioat_chan_common *chan = &ioat->base;
diff --git a/drivers/dma/ioat/dma_v2.h b/drivers/dma/ioat/dma_v2.h
index 47afcfd..e99bea5 100644
--- a/drivers/dma/ioat/dma_v2.h
+++ b/drivers/dma/ioat/dma_v2.h
@@ -185,5 +185,7 @@ void __ioat2_restart_chan(struct ioat2_dma_chan *ioat);
 dma_cookie_t ioat2_inject_fence(struct ioat2_dma_chan *ioat);
 bool reshape_ring(struct ioat2_dma_chan *ioat, int order);
 void __ioat2_issue_pending(struct ioat2_dma_chan *ioat);
+void ioat2_cleanup_tasklet(unsigned long data);
+void ioat2_timer_event(unsigned long data);
 extern struct kobj_type ioat2_ktype;
 #endif /* IOATDMA_V2_H */
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index ff4afdc..3686ddd 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1117,30 +1117,25 @@ int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 	struct dma_device *dma;
 	struct dma_chan *c;
 	struct ioat_chan_common *chan;
+	bool is_raid_device = false;
 	int err;
 	u16 dev_id;
 	u32 cap;
 
 	device->enumerate_channels = ioat2_enumerate_channels;
-	device->cleanup_tasklet = ioat3_cleanup_tasklet;
-	device->timer_fn = ioat3_timer_event;
 	device->self_test = ioat3_dma_self_test;
 	dma = &device->common;
 	dma->device_prep_dma_memcpy = ioat2_dma_prep_memcpy_lock;
 	dma->device_issue_pending = ioat2_issue_pending;
 	dma->device_alloc_chan_resources = ioat2_alloc_chan_resources;
 	dma->device_free_chan_resources = ioat2_free_chan_resources;
-	dma->device_is_tx_complete = ioat3_is_complete;
 
 	dma_cap_set(DMA_INTERRUPT, dma->cap_mask);
 	dma->device_prep_dma_interrupt = ioat3_prep_interrupt_lock;
 
 	cap = readl(device->reg_base + IOAT_DMA_CAP_OFFSET);
-	if (cap & IOAT_CAP_FILL_BLOCK) {
-		dma_cap_set(DMA_MEMSET, dma->cap_mask);
-		dma->device_prep_dma_memset = ioat3_prep_memset_lock;
-	}
 	if (cap & IOAT_CAP_XOR) {
+		is_raid_device = true;
 		dma->max_xor = 8;
 		dma->xor_align = 2;
 
@@ -1151,6 +1146,7 @@ int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 		dma->device_prep_dma_xor_val = ioat3_prep_xor_val;
 	}
 	if (cap & IOAT_CAP_PQ) {
+		is_raid_device = true;
 		dma_set_maxpq(dma, 8, 0);
 		dma->pq_align = 2;
 
@@ -1171,6 +1167,21 @@ int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 			dma->device_prep_dma_xor_val = ioat3_prep_pqxor_val;
 		}
 	}
+	if (is_raid_device && (cap & IOAT_CAP_FILL_BLOCK)) {
+		dma_cap_set(DMA_MEMSET, dma->cap_mask);
+		dma->device_prep_dma_memset = ioat3_prep_memset_lock;
+	}
+
+
+	if (is_raid_device) {
+		dma->device_is_tx_complete = ioat3_is_complete;
+		device->cleanup_tasklet = ioat3_cleanup_tasklet;
+		device->timer_fn = ioat3_timer_event;
+	} else {
+		dma->device_is_tx_complete = ioat2_is_complete;
+		device->cleanup_tasklet = ioat2_cleanup_tasklet;
+		device->timer_fn = ioat2_timer_event;
+	}
 
 	/* -= IOAT ver.3 workarounds =- */
 	/* Write CHANERRMSK_INT with 3E07h to mask out the errors
