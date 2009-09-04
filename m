From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 10/18] ioat3: xor support
Date: Thu, 03 Sep 2009 23:45:25 -0700
Message-ID: <20090904064525.7141.34029.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

ioat3.2 adds xor offload support for up to 8 sources.  It can also
perform an xor-zero-sum operation to validate whether all given sources
sum to zero, without writing to a destination.  Xor descriptors differ
from memcpy in that one operation may require multiple descriptors
depending on the number of sources.  When the number of sources exceeds
5 an extended descriptor is needed.  These descriptors need to be
accounted for when updating the DMA_COUNT register.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma_v2.c    |    2 
 drivers/dma/ioat/dma_v2.h    |    3 +
 drivers/dma/ioat/dma_v3.c    |  218 ++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/ioat/registers.h |    2 
 4 files changed, 222 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 7408bef..56fa6d6 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -48,7 +48,7 @@ module_param(ioat_ring_max_alloc_order, int, 0644);
 MODULE_PARM_DESC(ioat_ring_max_alloc_order,
 		 "ioat2+: upper limit for dynamic ring resizing (default: n=16)");
 
-static void __ioat2_issue_pending(struct ioat2_dma_chan *ioat)
+void __ioat2_issue_pending(struct ioat2_dma_chan *ioat)
 {
 	void * __iomem reg_base = ioat->base.reg_base;
 
diff --git a/drivers/dma/ioat/dma_v2.h b/drivers/dma/ioat/dma_v2.h
index a216b3f..47afcfd 100644
--- a/drivers/dma/ioat/dma_v2.h
+++ b/drivers/dma/ioat/dma_v2.h
@@ -127,6 +127,7 @@ static inline u16 ioat2_xferlen_to_descs(struct ioat2_dma_chan *ioat, size_t len
  * @raw: hardware raw (un-typed) descriptor
  * @txd: the generic software descriptor for all engines
  * @len: total transaction length for unmap
+ * @result: asynchronous result of validate operations
  * @id: identifier for debug
  */
 
@@ -143,6 +144,7 @@ struct ioat_ring_ent {
 	};
 	size_t len;
 	struct dma_async_tx_descriptor txd;
+	enum sum_check_flags *result;
 	#ifdef DEBUG
 	int id;
 	#endif
@@ -182,5 +184,6 @@ enum dma_status ioat2_is_complete(struct dma_chan *c, dma_cookie_t cookie,
 void __ioat2_restart_chan(struct ioat2_dma_chan *ioat);
 dma_cookie_t ioat2_inject_fence(struct ioat2_dma_chan *ioat);
 bool reshape_ring(struct ioat2_dma_chan *ioat, int order);
+void __ioat2_issue_pending(struct ioat2_dma_chan *ioat);
 extern struct kobj_type ioat2_ktype;
 #endif /* IOATDMA_V2_H */
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 0913d11..957c205 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -64,8 +64,33 @@
 #include "dma.h"
 #include "dma_v2.h"
 
+/* ioat hardware assumes at least two sources for raid operations */
+#define src_cnt_to_sw(x) ((x) + 2)
+#define src_cnt_to_hw(x) ((x) - 2)
+
+/* provide a lookup table for setting the source address in the base or
+ * extended descriptor of an xor descriptor
+ */
+static const u8 xor_idx_to_desc __read_mostly = 0xd0;
+static const u8 xor_idx_to_field[] __read_mostly = { 1, 4, 5, 6, 7, 0, 1, 2 };
+
+static dma_addr_t xor_get_src(struct ioat_raw_descriptor *descs[2], int idx)
+{
+	struct ioat_raw_descriptor *raw = descs[xor_idx_to_desc >> idx & 1];
+
+	return raw->field[xor_idx_to_field[idx]];
+}
+
+static void xor_set_src(struct ioat_raw_descriptor *descs[2],
+			dma_addr_t addr, u32 offset, int idx)
+{
+	struct ioat_raw_descriptor *raw = descs[xor_idx_to_desc >> idx & 1];
+
+	raw->field[xor_idx_to_field[idx]] = addr + offset;
+}
+
 static void ioat3_dma_unmap(struct ioat2_dma_chan *ioat,
-			    struct ioat_ring_ent *desc)
+			    struct ioat_ring_ent *desc, int idx)
 {
 	struct ioat_chan_common *chan = &ioat->base;
 	struct pci_dev *pdev = chan->device->pdev;
@@ -86,13 +111,71 @@ static void ioat3_dma_unmap(struct ioat2_dma_chan *ioat,
 				   PCI_DMA_FROMDEVICE, flags, 1);
 		break;
 	}
+	case IOAT_OP_XOR_VAL:
+	case IOAT_OP_XOR: {
+		struct ioat_xor_descriptor *xor = desc->xor;
+		struct ioat_ring_ent *ext;
+		struct ioat_xor_ext_descriptor *xor_ex = NULL;
+		int src_cnt = src_cnt_to_sw(xor->ctl_f.src_cnt);
+		struct ioat_raw_descriptor *descs[2];
+		int i;
+
+		if (src_cnt > 5) {
+			ext = ioat2_get_ring_ent(ioat, idx + 1);
+			xor_ex = ext->xor_ex;
+		}
+
+		if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
+			descs[0] = (struct ioat_raw_descriptor *) xor;
+			descs[1] = (struct ioat_raw_descriptor *) xor_ex;
+			for (i = 0; i < src_cnt; i++) {
+				dma_addr_t src = xor_get_src(descs, i);
+
+				ioat_unmap(pdev, src - offset, len,
+					   PCI_DMA_TODEVICE, flags, 0);
+			}
+
+			/* dest is a source in xor validate operations */
+			if (xor->ctl_f.op == IOAT_OP_XOR_VAL) {
+				ioat_unmap(pdev, xor->dst_addr - offset, len,
+					   PCI_DMA_TODEVICE, flags, 1);
+				break;
+			}
+		}
+
+		if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP))
+			ioat_unmap(pdev, xor->dst_addr - offset, len,
+				   PCI_DMA_FROMDEVICE, flags, 1);
+		break;
+	}
 	default:
 		dev_err(&pdev->dev, "%s: unknown op type: %#x\n",
 			__func__, desc->hw->ctl_f.op);
 	}
 }
 
+static bool desc_has_ext(struct ioat_ring_ent *desc)
+{
+	struct ioat_dma_descriptor *hw = desc->hw;
+
+	if (hw->ctl_f.op == IOAT_OP_XOR ||
+	    hw->ctl_f.op == IOAT_OP_XOR_VAL) {
+		struct ioat_xor_descriptor *xor = desc->xor;
 
+		if (src_cnt_to_sw(xor->ctl_f.src_cnt) > 5)
+			return true;
+	}
+
+	return false;
+}
+
+/**
+ * __cleanup - reclaim used descriptors
+ * @ioat: channel (ring) to clean
+ *
+ * The difference from the dma_v2.c __cleanup() is that this routine
+ * handles extended descriptors and dma-unmapping raid operations.
+ */
 static void __cleanup(struct ioat2_dma_chan *ioat, unsigned long phys_complete)
 {
 	struct ioat_chan_common *chan = &ioat->base;
@@ -114,7 +197,7 @@ static void __cleanup(struct ioat2_dma_chan *ioat, unsigned long phys_complete)
 		tx = &desc->txd;
 		if (tx->cookie) {
 			chan->completed_cookie = tx->cookie;
-			ioat3_dma_unmap(ioat, desc);
+			ioat3_dma_unmap(ioat, desc, ioat->tail + i);
 			tx->cookie = 0;
 			if (tx->callback) {
 				tx->callback(tx->callback_param);
@@ -124,6 +207,12 @@ static void __cleanup(struct ioat2_dma_chan *ioat, unsigned long phys_complete)
 
 		if (tx->phys == phys_complete)
 			seen_current = true;
+
+		/* skip extended descriptors */
+		if (desc_has_ext(desc)) {
+			BUG_ON(i + 1 >= active);
+			i++;
+		}
 	}
 	ioat->tail += i;
 	BUG_ON(!seen_current); /* no active descs have written a completion? */
@@ -309,6 +398,121 @@ ioat3_prep_memset_lock(struct dma_chan *c, dma_addr_t dest, int value,
 	return &desc->txd;
 }
 
+static struct dma_async_tx_descriptor *
+__ioat3_prep_xor_lock(struct dma_chan *c, enum sum_check_flags *result,
+		      dma_addr_t dest, dma_addr_t *src, unsigned int src_cnt,
+		      size_t len, unsigned long flags)
+{
+	struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
+	struct ioat_ring_ent *compl_desc;
+	struct ioat_ring_ent *desc;
+	struct ioat_ring_ent *ext;
+	size_t total_len = len;
+	struct ioat_xor_descriptor *xor;
+	struct ioat_xor_ext_descriptor *xor_ex = NULL;
+	struct ioat_dma_descriptor *hw;
+	u32 offset = 0;
+	int num_descs;
+	int with_ext;
+	int i;
+	u16 idx;
+	u8 op = result ? IOAT_OP_XOR_VAL : IOAT_OP_XOR;
+
+	BUG_ON(src_cnt < 2);
+
+	num_descs = ioat2_xferlen_to_descs(ioat, len);
+	/* we need 2x the number of descriptors to cover greater than 5
+	 * sources
+	 */
+	if (src_cnt > 5) {
+		with_ext = 1;
+		num_descs *= 2;
+	} else
+		with_ext = 0;
+
+	/* completion writes from the raid engine may pass completion
+	 * writes from the legacy engine, so we need one extra null
+	 * (legacy) descriptor to ensure all completion writes arrive in
+	 * order.
+	 */
+	if (likely(num_descs) &&
+	    ioat2_alloc_and_lock(&idx, ioat, num_descs+1) == 0)
+		/* pass */;
+	else
+		return NULL;
+	for (i = 0; i < num_descs; i += 1 + with_ext) {
+		struct ioat_raw_descriptor *descs[2];
+		size_t xfer_size = min_t(size_t, len, 1 << ioat->xfercap_log);
+		int s;
+
+		desc = ioat2_get_ring_ent(ioat, idx + i);
+		xor = desc->xor;
+
+		/* save a branch by unconditionally retrieving the
+		 * extended descriptor xor_set_src() knows to not write
+		 * to it in the single descriptor case
+		 */
+		ext = ioat2_get_ring_ent(ioat, idx + i + 1);
+		xor_ex = ext->xor_ex;
+
+		descs[0] = (struct ioat_raw_descriptor *) xor;
+		descs[1] = (struct ioat_raw_descriptor *) xor_ex;
+		for (s = 0; s < src_cnt; s++)
+			xor_set_src(descs, src[s], offset, s);
+		xor->size = xfer_size;
+		xor->dst_addr = dest + offset;
+		xor->ctl = 0;
+		xor->ctl_f.op = op;
+		xor->ctl_f.src_cnt = src_cnt_to_hw(src_cnt);
+
+		len -= xfer_size;
+		offset += xfer_size;
+		dump_desc_dbg(ioat, desc);
+	}
+
+	/* last xor descriptor carries the unmap parameters and fence bit */
+	desc->txd.flags = flags;
+	desc->len = total_len;
+	if (result)
+		desc->result = result;
+	xor->ctl_f.fence = !!(flags & DMA_PREP_FENCE);
+
+	/* completion descriptor carries interrupt bit */
+	compl_desc = ioat2_get_ring_ent(ioat, idx + i);
+	compl_desc->txd.flags = flags & DMA_PREP_INTERRUPT;
+	hw = compl_desc->hw;
+	hw->ctl = 0;
+	hw->ctl_f.null = 1;
+	hw->ctl_f.int_en = !!(flags & DMA_PREP_INTERRUPT);
+	hw->ctl_f.compl_write = 1;
+	hw->size = NULL_DESC_BUFFER_SIZE;
+	dump_desc_dbg(ioat, compl_desc);
+
+	/* we leave the channel locked to ensure in order submission */
+	return &desc->txd;
+}
+
+static struct dma_async_tx_descriptor *
+ioat3_prep_xor(struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
+	       unsigned int src_cnt, size_t len, unsigned long flags)
+{
+	return __ioat3_prep_xor_lock(chan, NULL, dest, src, src_cnt, len, flags);
+}
+
+struct dma_async_tx_descriptor *
+ioat3_prep_xor_val(struct dma_chan *chan, dma_addr_t *src,
+		    unsigned int src_cnt, size_t len,
+		    enum sum_check_flags *result, unsigned long flags)
+{
+	/* the cleanup routine only sets bits on validate failure, it
+	 * does not clear bits on validate success... so clear it here
+	 */
+	*result = 0;
+
+	return __ioat3_prep_xor_lock(chan, result, src[0], &src[1],
+				     src_cnt - 1, len, flags);
+}
+
 int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 {
 	struct pci_dev *pdev = device->pdev;
@@ -333,6 +537,16 @@ int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 		dma_cap_set(DMA_MEMSET, dma->cap_mask);
 		dma->device_prep_dma_memset = ioat3_prep_memset_lock;
 	}
+	if (cap & IOAT_CAP_XOR) {
+		dma->max_xor = 8;
+		dma->xor_align = 2;
+
+		dma_cap_set(DMA_XOR, dma->cap_mask);
+		dma->device_prep_dma_xor = ioat3_prep_xor;
+
+		dma_cap_set(DMA_XOR_VAL, dma->cap_mask);
+		dma->device_prep_dma_xor_val = ioat3_prep_xor_val;
+	}
 
 	/* -= IOAT ver.3 workarounds =- */
 	/* Write CHANERRMSK_INT with 3E07h to mask out the errors
diff --git a/drivers/dma/ioat/registers.h b/drivers/dma/ioat/registers.h
index 97d26ea..63038e1 100644
--- a/drivers/dma/ioat/registers.h
+++ b/drivers/dma/ioat/registers.h
@@ -243,6 +243,8 @@
 #define IOAT_CHANERR_XOR_Q_ERR			0x20000
 #define IOAT_CHANERR_DESCRIPTOR_COUNT_ERR	0x40000
 
+#define IOAT_CHANERR_HANDLE_MASK (IOAT_CHANERR_XOR_P_OR_CRC_ERR | IOAT_CHANERR_XOR_Q_ERR)
+
 #define IOAT_CHANERR_MASK_OFFSET		0x2C	/* 32-bit Channel Error Register */
 
 #endif /* _IOAT_REGISTERS_H_ */

