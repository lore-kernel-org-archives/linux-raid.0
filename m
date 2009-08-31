From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 3/4] iop-adma: P+Q support for iop13xx adma engines
Date: Mon, 31 Aug 2009 08:40:52 -0700
Message-ID: <20090831154052.1068.28214.stgit@dwillia2-linux.ch.intel.com>
References: <20090831153946.1068.86702.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090831153946.1068.86702.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
List-Id: linux-raid.ids

iop33x support is not included because that engine is a bit more awkward
to handle in that it can either be in xor mode or pq mode.  The
dmaengine/async_tx layers currently only comprehend static capabilities.

Note iop13xx does not support hardware PQ continuation so the driver
must handle the DMA_PREP_CONTINUE flag for operations across > 16
sources. From the comment for dma_maxpq:

/* When an engine does not support native continuation we need 3 extra
 * source slots to reuse P and Q with the following coefficients:
 * 1/ {00} * P : remove P from Q', but use it as a source for P'
 * 2/ {01} * Q : use Q to continue Q' calculation
 * 3/ {00} * Q : subtract Q from P' to cancel (2)
 */

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/arm/include/asm/hardware/iop3xx-adma.h |   76 +++++++++
 arch/arm/include/asm/hardware/iop_adma.h    |    1 
 arch/arm/mach-iop13xx/include/mach/adma.h   |  107 +++++++++++++
 drivers/dma/iop-adma.c                      |  231 +++++++++++++++++++++++----
 4 files changed, 381 insertions(+), 34 deletions(-)

diff --git a/arch/arm/include/asm/hardware/iop3xx-adma.h b/arch/arm/include/asm/hardware/iop3xx-adma.h
index 26eefea..1a8c727 100644
--- a/arch/arm/include/asm/hardware/iop3xx-adma.h
+++ b/arch/arm/include/asm/hardware/iop3xx-adma.h
@@ -187,11 +187,74 @@ union iop3xx_desc {
 	void *ptr;
 };
 
+/* No support for p+q operations */
+static inline int
+iop_chan_pq_slot_count(size_t len, int src_cnt, int *slots_per_op)
+{
+	BUG();
+	return 0;
+}
+
+static inline void
+iop_desc_init_pq(struct iop_adma_desc_slot *desc, int src_cnt,
+		  unsigned long flags)
+{
+	BUG();
+}
+
+static inline void
+iop_desc_set_pq_addr(struct iop_adma_desc_slot *desc, dma_addr_t *addr)
+{
+	BUG();
+}
+
+static inline void
+iop_desc_set_pq_src_addr(struct iop_adma_desc_slot *desc, int src_idx,
+			 dma_addr_t addr, unsigned char coef)
+{
+	BUG();
+}
+
+static inline int
+iop_chan_pq_zero_sum_slot_count(size_t len, int src_cnt, int *slots_per_op)
+{
+	BUG();
+	return 0;
+}
+
+static inline void
+iop_desc_init_pq_zero_sum(struct iop_adma_desc_slot *desc, int src_cnt,
+			  unsigned long flags)
+{
+	BUG();
+}
+
+static inline void
+iop_desc_set_pq_zero_sum_byte_count(struct iop_adma_desc_slot *desc, u32 len)
+{
+	BUG();
+}
+
+#define iop_desc_set_pq_zero_sum_src_addr iop_desc_set_pq_src_addr
+
+static inline void
+iop_desc_set_pq_zero_sum_addr(struct iop_adma_desc_slot *desc, int pq_idx,
+			      dma_addr_t *src)
+{
+	BUG();
+}
+
 static inline int iop_adma_get_max_xor(void)
 {
 	return 32;
 }
 
+static inline int iop_adma_get_max_pq(void)
+{
+	BUG();
+	return 0;
+}
+
 static inline u32 iop_chan_get_current_descriptor(struct iop_adma_chan *chan)
 {
 	int id = chan->device->id;
@@ -332,6 +395,11 @@ static inline int iop_chan_zero_sum_slot_count(size_t len, int src_cnt,
 	return slot_cnt;
 }
 
+static inline int iop_desc_is_pq(struct iop_adma_desc_slot *desc)
+{
+	return 0;
+}
+
 static inline u32 iop_desc_get_dest_addr(struct iop_adma_desc_slot *desc,
 					struct iop_adma_chan *chan)
 {
@@ -349,6 +417,14 @@ static inline u32 iop_desc_get_dest_addr(struct iop_adma_desc_slot *desc,
 	return 0;
 }
 
+
+static inline u32 iop_desc_get_qdest_addr(struct iop_adma_desc_slot *desc,
+					  struct iop_adma_chan *chan)
+{
+	BUG();
+	return 0;
+}
+
 static inline u32 iop_desc_get_byte_count(struct iop_adma_desc_slot *desc,
 					struct iop_adma_chan *chan)
 {
diff --git a/arch/arm/include/asm/hardware/iop_adma.h b/arch/arm/include/asm/hardware/iop_adma.h
index 385c6e8..bbe8a04 100644
--- a/arch/arm/include/asm/hardware/iop_adma.h
+++ b/arch/arm/include/asm/hardware/iop_adma.h
@@ -106,6 +106,7 @@ struct iop_adma_desc_slot {
 	union {
 		u32 *xor_check_result;
 		u32 *crc32_result;
+		u32 *pq_check_result;
 	};
 };
 
diff --git a/arch/arm/mach-iop13xx/include/mach/adma.h b/arch/arm/mach-iop13xx/include/mach/adma.h
index 1cd31df..6d3782d 100644
--- a/arch/arm/mach-iop13xx/include/mach/adma.h
+++ b/arch/arm/mach-iop13xx/include/mach/adma.h
@@ -150,6 +150,8 @@ static inline int iop_adma_get_max_xor(void)
 	return 16;
 }
 
+#define iop_adma_get_max_pq iop_adma_get_max_xor
+
 static inline u32 iop_chan_get_current_descriptor(struct iop_adma_chan *chan)
 {
 	return __raw_readl(ADMA_ADAR(chan));
@@ -211,7 +213,10 @@ iop_chan_xor_slot_count(size_t len, int src_cnt, int *slots_per_op)
 #define IOP_ADMA_MAX_BYTE_COUNT ADMA_MAX_BYTE_COUNT
 #define IOP_ADMA_ZERO_SUM_MAX_BYTE_COUNT ADMA_MAX_BYTE_COUNT
 #define IOP_ADMA_XOR_MAX_BYTE_COUNT ADMA_MAX_BYTE_COUNT
+#define IOP_ADMA_PQ_MAX_BYTE_COUNT ADMA_MAX_BYTE_COUNT
 #define iop_chan_zero_sum_slot_count(l, s, o) iop_chan_xor_slot_count(l, s, o)
+#define iop_chan_pq_slot_count iop_chan_xor_slot_count
+#define iop_chan_pq_zero_sum_slot_count iop_chan_xor_slot_count
 
 static inline u32 iop_desc_get_dest_addr(struct iop_adma_desc_slot *desc,
 					struct iop_adma_chan *chan)
@@ -220,6 +225,13 @@ static inline u32 iop_desc_get_dest_addr(struct iop_adma_desc_slot *desc,
 	return hw_desc->dest_addr;
 }
 
+static inline u32 iop_desc_get_qdest_addr(struct iop_adma_desc_slot *desc,
+					  struct iop_adma_chan *chan)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	return hw_desc->q_dest_addr;
+}
+
 static inline u32 iop_desc_get_byte_count(struct iop_adma_desc_slot *desc,
 					struct iop_adma_chan *chan)
 {
@@ -319,6 +331,58 @@ iop_desc_init_zero_sum(struct iop_adma_desc_slot *desc, int src_cnt,
 	return 1;
 }
 
+static inline void
+iop_desc_init_pq(struct iop_adma_desc_slot *desc, int src_cnt,
+		  unsigned long flags)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	union {
+		u32 value;
+		struct iop13xx_adma_desc_ctrl field;
+	} u_desc_ctrl;
+
+	u_desc_ctrl.value = 0;
+	u_desc_ctrl.field.src_select = src_cnt - 1;
+	u_desc_ctrl.field.xfer_dir = 3; /* local to internal bus */
+	u_desc_ctrl.field.pq_xfer_en = 1;
+	u_desc_ctrl.field.p_xfer_dis = !!(flags & DMA_PREP_PQ_DISABLE_P);
+	u_desc_ctrl.field.int_en = flags & DMA_PREP_INTERRUPT;
+	hw_desc->desc_ctrl = u_desc_ctrl.value;
+}
+
+static inline int iop_desc_is_pq(struct iop_adma_desc_slot *desc)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	union {
+		u32 value;
+		struct iop13xx_adma_desc_ctrl field;
+	} u_desc_ctrl;
+
+	u_desc_ctrl.value = hw_desc->desc_ctrl;
+	return u_desc_ctrl.field.pq_xfer_en;
+}
+
+static inline void
+iop_desc_init_pq_zero_sum(struct iop_adma_desc_slot *desc, int src_cnt,
+			  unsigned long flags)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	union {
+		u32 value;
+		struct iop13xx_adma_desc_ctrl field;
+	} u_desc_ctrl;
+
+	u_desc_ctrl.value = 0;
+	u_desc_ctrl.field.src_select = src_cnt - 1;
+	u_desc_ctrl.field.xfer_dir = 3; /* local to internal bus */
+	u_desc_ctrl.field.zero_result = 1;
+	u_desc_ctrl.field.status_write_back_en = 1;
+	u_desc_ctrl.field.pq_xfer_en = 1;
+	u_desc_ctrl.field.p_xfer_dis = !!(flags & DMA_PREP_PQ_DISABLE_P);
+	u_desc_ctrl.field.int_en = flags & DMA_PREP_INTERRUPT;
+	hw_desc->desc_ctrl = u_desc_ctrl.value;
+}
+
 static inline void iop_desc_set_byte_count(struct iop_adma_desc_slot *desc,
 					struct iop_adma_chan *chan,
 					u32 byte_count)
@@ -351,6 +415,7 @@ iop_desc_set_zero_sum_byte_count(struct iop_adma_desc_slot *desc, u32 len)
 	}
 }
 
+#define iop_desc_set_pq_zero_sum_byte_count iop_desc_set_zero_sum_byte_count
 
 static inline void iop_desc_set_dest_addr(struct iop_adma_desc_slot *desc,
 					struct iop_adma_chan *chan,
@@ -361,6 +426,16 @@ static inline void iop_desc_set_dest_addr(struct iop_adma_desc_slot *desc,
 	hw_desc->upper_dest_addr = 0;
 }
 
+static inline void
+iop_desc_set_pq_addr(struct iop_adma_desc_slot *desc, dma_addr_t *addr)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+
+	hw_desc->dest_addr = addr[0];
+	hw_desc->q_dest_addr = addr[1];
+	hw_desc->upper_dest_addr = 0;
+}
+
 static inline void iop_desc_set_memcpy_src_addr(struct iop_adma_desc_slot *desc,
 					dma_addr_t addr)
 {
@@ -389,6 +464,29 @@ static inline void iop_desc_set_xor_src_addr(struct iop_adma_desc_slot *desc,
 }
 
 static inline void
+iop_desc_set_pq_src_addr(struct iop_adma_desc_slot *desc, int src_idx,
+			 dma_addr_t addr, unsigned char coef)
+{
+	int slot_cnt = desc->slot_cnt, slots_per_op = desc->slots_per_op;
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc, *iter;
+	struct iop13xx_adma_src *src;
+	int i = 0;
+
+	do {
+		iter = iop_hw_desc_slot_idx(hw_desc, i);
+		src = &iter->src[src_idx];
+		src->src_addr = addr;
+		src->pq_upper_src_addr = 0;
+		src->pq_dmlt = coef;
+		slot_cnt -= slots_per_op;
+		if (slot_cnt) {
+			i += slots_per_op;
+			addr += IOP_ADMA_PQ_MAX_BYTE_COUNT;
+		}
+	} while (slot_cnt);
+}
+
+static inline void
 iop_desc_init_interrupt(struct iop_adma_desc_slot *desc,
 	struct iop_adma_chan *chan)
 {
@@ -399,6 +497,15 @@ iop_desc_init_interrupt(struct iop_adma_desc_slot *desc,
 }
 
 #define iop_desc_set_zero_sum_src_addr iop_desc_set_xor_src_addr
+#define iop_desc_set_pq_zero_sum_src_addr iop_desc_set_pq_src_addr
+
+static inline void
+iop_desc_set_pq_zero_sum_addr(struct iop_adma_desc_slot *desc, int pq_idx,
+			      dma_addr_t *src)
+{
+	iop_desc_set_xor_src_addr(desc, pq_idx, src[pq_idx]);
+	iop_desc_set_xor_src_addr(desc, pq_idx+1, src[pq_idx+1]);
+}
 
 static inline void iop_desc_set_next_desc(struct iop_adma_desc_slot *desc,
 					u32 next_desc_addr)
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 9c752bd..5a0f4fe 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -57,6 +57,80 @@ static void iop_adma_free_slots(struct iop_adma_desc_slot *slot)
 	}
 }
 
+static void
+iop_desc_unmap(struct iop_adma_chan *iop_chan, struct iop_adma_desc_slot *desc)
+{
+	struct dma_async_tx_descriptor *tx = &desc->async_tx;
+	struct iop_adma_desc_slot *unmap = desc->group_head;
+	struct device *dev = &iop_chan->device->pdev->dev;
+	u32 len = unmap->unmap_len;
+	enum dma_ctrl_flags flags = tx->flags;
+	u32 src_cnt;
+	dma_addr_t addr;
+	dma_addr_t dest;
+
+	src_cnt = unmap->unmap_src_cnt;
+	dest = iop_desc_get_dest_addr(unmap, iop_chan);
+	if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
+		enum dma_data_direction dir;
+
+		if (src_cnt > 1) /* is xor? */
+			dir = DMA_BIDIRECTIONAL;
+		else
+			dir = DMA_FROM_DEVICE;
+
+		dma_unmap_page(dev, dest, len, dir);
+	}
+
+	if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
+		while (src_cnt--) {
+			addr = iop_desc_get_src_addr(unmap, iop_chan, src_cnt);
+			if (addr == dest)
+				continue;
+			dma_unmap_page(dev, addr, len, DMA_TO_DEVICE);
+		}
+	}
+	desc->group_head = NULL;
+}
+
+static void
+iop_desc_unmap_pq(struct iop_adma_chan *iop_chan, struct iop_adma_desc_slot *desc)
+{
+	struct dma_async_tx_descriptor *tx = &desc->async_tx;
+	struct iop_adma_desc_slot *unmap = desc->group_head;
+	struct device *dev = &iop_chan->device->pdev->dev;
+	u32 len = unmap->unmap_len;
+	enum dma_ctrl_flags flags = tx->flags;
+	u32 src_cnt = unmap->unmap_src_cnt;
+	dma_addr_t pdest = iop_desc_get_dest_addr(unmap, iop_chan);
+	dma_addr_t qdest = iop_desc_get_qdest_addr(unmap, iop_chan);
+	int i;
+
+	if (tx->flags & DMA_PREP_CONTINUE)
+		src_cnt -= 3;
+
+	if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP) && !desc->pq_check_result) {
+		dma_unmap_page(dev, pdest, len, DMA_BIDIRECTIONAL);
+		dma_unmap_page(dev, qdest, len, DMA_BIDIRECTIONAL);
+	}
+
+	if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
+		dma_addr_t addr;
+
+		for (i = 0; i < src_cnt; i++) {
+			addr = iop_desc_get_src_addr(unmap, iop_chan, i);
+			dma_unmap_page(dev, addr, len, DMA_TO_DEVICE);
+		}
+		if (desc->pq_check_result) {
+			dma_unmap_page(dev, pdest, len, DMA_TO_DEVICE);
+			dma_unmap_page(dev, qdest, len, DMA_TO_DEVICE);
+		}
+	}
+
+	desc->group_head = NULL;
+}
+
+
 static dma_cookie_t
 iop_adma_run_tx_complete_actions(struct iop_adma_desc_slot *desc,
 	struct iop_adma_chan *iop_chan, dma_cookie_t cookie)
@@ -78,40 +152,10 @@ iop_adma_run_tx_complete_actions(struct iop_adma_desc_slot *desc,
 		 * (unmap_single vs unmap_page?)
 		 */
 		if (desc->group_head && desc->unmap_len) {
-			struct iop_adma_desc_slot *unmap = desc->group_head;
-			struct device *dev =
-				&iop_chan->device->pdev->dev;
-			u32 len = unmap->unmap_len;
-			enum dma_ctrl_flags flags = tx->flags;
-			u32 src_cnt;
-			dma_addr_t addr;
-			dma_addr_t dest;
-
-			src_cnt = unmap->unmap_src_cnt;
-			dest = iop_desc_get_dest_addr(unmap, iop_chan);
-			if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
-				enum dma_data_direction dir;
-
-				if (src_cnt > 1) /* is xor? */
-					dir = DMA_BIDIRECTIONAL;
-				else
-					dir = DMA_FROM_DEVICE;
-
-				dma_unmap_page(dev, dest, len, dir);
-			}
-
-			if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-				while (src_cnt--) {
-					addr = iop_desc_get_src_addr(unmap,
-								     iop_chan,
-								     src_cnt);
-					if (addr == dest)
-						continue;
-					dma_unmap_page(dev, addr, len,
-						       DMA_TO_DEVICE);
-				}
-			}
-			desc->group_head = NULL;
+			if (iop_desc_is_pq(desc))
+				iop_desc_unmap_pq(iop_chan, desc);
+			else
+				iop_desc_unmap(iop_chan, desc);
 		}
 	}
 
@@ -702,6 +746,118 @@ iop_adma_prep_dma_xor_val(struct dma_chan *chan, dma_addr_t *dma_src,
 	return sw_desc ? &sw_desc->async_tx : NULL;
 }
 
+static struct dma_async_tx_descriptor *
+iop_adma_prep_dma_pq(struct dma_chan *chan, dma_addr_t *dst, dma_addr_t *src,
+		     unsigned int src_cnt, const unsigned char *scf, size_t len,
+		     unsigned long flags)
+{
+	struct iop_adma_chan *iop_chan = to_iop_adma_chan(chan);
+	struct iop_adma_desc_slot *sw_desc, *g;
+	int slot_cnt, slots_per_op;
+	int continue_srcs;
+
+	if (unlikely(!len))
+		return NULL;
+	BUG_ON(len > IOP_ADMA_XOR_MAX_BYTE_COUNT);
+
+	dev_dbg(iop_chan->device->common.dev,
+		"%s src_cnt: %d len: %u flags: %lx\n",
+		__func__, src_cnt, len, flags);
+
+	if (dmaf_p_disabled_continue(flags))
+		continue_srcs = 1+src_cnt;
+	else if (dmaf_continue(flags))
+		continue_srcs = 3+src_cnt;
+	else
+		continue_srcs = 0+src_cnt;
+
+	spin_lock_bh(&iop_chan->lock);
+	slot_cnt = iop_chan_pq_slot_count(len, continue_srcs, &slots_per_op);
+	sw_desc = iop_adma_alloc_slots(iop_chan, slot_cnt, slots_per_op);
+	if (sw_desc) {
+		int i;
+
+		g = sw_desc->group_head;
+		iop_desc_set_byte_count(g, iop_chan, len);
+
+		/* even if P is disabled its destination address (bits
+		 * [3:0]) must match Q.  It is ok if P points to an
+		 * invalid address, it won't be written.
+		 */
+		if (flags & DMA_PREP_PQ_DISABLE_P)
+			dst[0] = dst[1] & 0x7;
+
+		iop_desc_set_pq_addr(g, dst);
+		sw_desc->unmap_src_cnt = src_cnt;
+		sw_desc->unmap_len = len;
+		sw_desc->async_tx.flags = flags;
+		for (i = 0; i < src_cnt; i++)
+			iop_desc_set_pq_src_addr(g, i, src[i], scf[i]);
+
+		/* if we are continuing a previous operation factor in
+		 * the old p and q values, see the comment for dma_maxpq
+		 * in include/linux/dmaengine.h
+		 */
+		if (dmaf_p_disabled_continue(flags))
+			iop_desc_set_pq_src_addr(g, i++, dst[1], 1);
+		else if (dmaf_continue(flags)) {
+			iop_desc_set_pq_src_addr(g, i++, dst[0], 0);
+			iop_desc_set_pq_src_addr(g, i++, dst[1], 1);
+			iop_desc_set_pq_src_addr(g, i++, dst[1], 0);
+		}
+		iop_desc_init_pq(g, i, flags);
+	}
+	spin_unlock_bh(&iop_chan->lock);
+
+	return sw_desc ? &sw_desc->async_tx : NULL;
+}
+
+static struct dma_async_tx_descriptor *
+iop_adma_prep_dma_pq_val(struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
+			 unsigned int src_cnt, const unsigned char *scf,
+			 size_t len, enum sum_check_flags *pqres,
+			 unsigned long flags)
+{
+	struct iop_adma_chan *iop_chan = to_iop_adma_chan(chan);
+	struct iop_adma_desc_slot *sw_desc, *g;
+	int slot_cnt, slots_per_op;
+
+	if (unlikely(!len))
+		return NULL;
+	BUG_ON(len > IOP_ADMA_XOR_MAX_BYTE_COUNT);
+
+	dev_dbg(iop_chan->device->common.dev, "%s src_cnt: %d len: %u\n",
+		__func__, src_cnt, len);
+
+	spin_lock_bh(&iop_chan->lock);
+	slot_cnt = iop_chan_pq_zero_sum_slot_count(len, src_cnt + 2, &slots_per_op);
+	sw_desc = iop_adma_alloc_slots(iop_chan, slot_cnt, slots_per_op);
+	if (sw_desc) {
+		/* for validate operations p and q are tagged onto the
+		 * end of the source list
+		 */
+		int pq_idx = src_cnt;
+
+		g = sw_desc->group_head;
+		iop_desc_init_pq_zero_sum(g, src_cnt+2, flags);
+		iop_desc_set_pq_zero_sum_byte_count(g, len);
+		g->pq_check_result = pqres;
+		pr_debug("\t%s: g->pq_check_result: %p\n",
+			__func__, g->pq_check_result);
+		sw_desc->unmap_src_cnt = src_cnt+2;
+		sw_desc->unmap_len = len;
+		sw_desc->async_tx.flags = flags;
+		while (src_cnt--)
+			iop_desc_set_pq_zero_sum_src_addr(g, src_cnt,
+							  src[src_cnt],
+							  scf[src_cnt]);
+		iop_desc_set_pq_zero_sum_addr(g, pq_idx, src);
+	}
+	spin_unlock_bh(&iop_chan->lock);
+
+	return sw_desc ? &sw_desc->async_tx : NULL;
+}
+
 static void iop_adma_free_chan_resources(struct dma_chan *chan)
 {
 	struct iop_adma_chan *iop_chan = to_iop_adma_chan(chan);
@@ -1201,6 +1357,13 @@ static int __devinit iop_adma_probe(struct platform_device *pdev)
 	if (dma_has_cap(DMA_XOR_VAL, dma_dev->cap_mask))
 		dma_dev->device_prep_dma_xor_val =
 			iop_adma_prep_dma_xor_val;
+	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask)) {
+		dma_set_maxpq(dma_dev, iop_adma_get_max_pq(), 0);
+		dma_dev->device_prep_dma_pq = iop_adma_prep_dma_pq;
+	}
+	if (dma_has_cap(DMA_PQ_VAL, dma_dev->cap_mask))
+		dma_dev->device_prep_dma_pq_val =
+			iop_adma_prep_dma_pq_val;
 	if (dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask))
 		dma_dev->device_prep_dma_interrupt =
 			iop_adma_prep_dma_interrupt;

