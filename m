From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 12/18] ioat3: pq support
Date: Thu, 03 Sep 2009 23:45:36 -0700
Message-ID: <20090904064536.7141.4263.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932905AbZIDGqG@vger.kernel.org>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

ioat3.2 adds support for raid6 syndrome generation (xor sum of galois
field multiplication products) using up to 8 sources.  It can also
perform an pq-zero-sum operation to validate whether the syndrome for a
given set of sources matches a previously computed syndrome.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma_v3.c |  265 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 264 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 927c08b..ca2af0f 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -69,10 +69,12 @@
 #define src_cnt_to_hw(x) ((x) - 2)
 
 /* provide a lookup table for setting the source address in the base or
- * extended descriptor of an xor descriptor
+ * extended descriptor of an xor or pq descriptor
  */
 static const u8 xor_idx_to_desc __read_mostly = 0xd0;
 static const u8 xor_idx_to_field[] __read_mostly = { 1, 4, 5, 6, 7, 0, 1, 2 };
+static const u8 pq_idx_to_desc __read_mostly = 0xf8;
+static const u8 pq_idx_to_field[] __read_mostly = { 1, 4, 5, 0, 1, 2, 4, 5 };
 
 static dma_addr_t xor_get_src(struct ioat_raw_descriptor *descs[2], int idx)
 {
@@ -89,6 +91,23 @@ static void xor_set_src(struct ioat_raw_descriptor *descs[2],
 	raw->field[xor_idx_to_field[idx]] = addr + offset;
 }
 
+static dma_addr_t pq_get_src(struct ioat_raw_descriptor *descs[2], int idx)
+{
+	struct ioat_raw_descriptor *raw = descs[pq_idx_to_desc >> idx & 1];
+
+	return raw->field[pq_idx_to_field[idx]];
+}
+
+static void pq_set_src(struct ioat_raw_descriptor *descs[2],
+		       dma_addr_t addr, u32 offset, u8 coef, int idx)
+{
+	struct ioat_pq_descriptor *pq = (struct ioat_pq_descriptor *) descs[0];
+	struct ioat_raw_descriptor *raw = descs[pq_idx_to_desc >> idx & 1];
+
+	raw->field[pq_idx_to_field[idx]] = addr + offset;
+	pq->coef[idx] = coef;
+}
+
 static void ioat3_dma_unmap(struct ioat2_dma_chan *ioat,
 			    struct ioat_ring_ent *desc, int idx)
 {
@@ -148,6 +167,58 @@ static void ioat3_dma_unmap(struct ioat2_dma_chan *ioat,
 				   PCI_DMA_FROMDEVICE, flags, 1);
 		break;
 	}
+	case IOAT_OP_PQ_VAL:
+	case IOAT_OP_PQ: {
+		struct ioat_pq_descriptor *pq = desc->pq;
+		struct ioat_ring_ent *ext;
+		struct ioat_pq_ext_descriptor *pq_ex = NULL;
+		int src_cnt = src_cnt_to_sw(pq->ctl_f.src_cnt);
+		struct ioat_raw_descriptor *descs[2];
+		int i;
+
+		if (src_cnt > 3) {
+			ext = ioat2_get_ring_ent(ioat, idx + 1);
+			pq_ex = ext->pq_ex;
+		}
+
+		/* in the 'continue' case don't unmap the dests as sources */
+		if (dmaf_p_disabled_continue(flags))
+			src_cnt--;
+		else if (dmaf_continue(flags))
+			src_cnt -= 3;
+
+		if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
+			descs[0] = (struct ioat_raw_descriptor *) pq;
+			descs[1] = (struct ioat_raw_descriptor *) pq_ex;
+			for (i = 0; i < src_cnt; i++) {
+				dma_addr_t src = pq_get_src(descs, i);
+
+				ioat_unmap(pdev, src - offset, len,
+					   PCI_DMA_TODEVICE, flags, 0);
+			}
+
+			/* the dests are sources in pq validate operations */
+			if (pq->ctl_f.op == IOAT_OP_XOR_VAL) {
+				if (!(flags & DMA_PREP_PQ_DISABLE_P))
+					ioat_unmap(pdev, pq->p_addr - offset,
+						   len, PCI_DMA_TODEVICE, flags, 0);
+				if (!(flags & DMA_PREP_PQ_DISABLE_Q))
+					ioat_unmap(pdev, pq->q_addr - offset,
+						   len, PCI_DMA_TODEVICE, flags, 0);
+				break;
+			}
+		}
+
+		if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
+			if (!(flags & DMA_PREP_PQ_DISABLE_P))
+				ioat_unmap(pdev, pq->p_addr - offset, len,
+					   PCI_DMA_BIDIRECTIONAL, flags, 1);
+			if (!(flags & DMA_PREP_PQ_DISABLE_Q))
+				ioat_unmap(pdev, pq->q_addr - offset, len,
+					   PCI_DMA_BIDIRECTIONAL, flags, 1);
+		}
+		break;
+	}
 	default:
 		dev_err(&pdev->dev, "%s: unknown op type: %#x\n",
 			__func__, desc->hw->ctl_f.op);
@@ -164,6 +235,12 @@ static bool desc_has_ext(struct ioat_ring_ent *desc)
 
 		if (src_cnt_to_sw(xor->ctl_f.src_cnt) > 5)
 			return true;
+	} else if (hw->ctl_f.op == IOAT_OP_PQ ||
+		   hw->ctl_f.op == IOAT_OP_PQ_VAL) {
+		struct ioat_pq_descriptor *pq = desc->pq;
+
+		if (src_cnt_to_sw(pq->ctl_f.src_cnt) > 3)
+			return true;
 	}
 
 	return false;
@@ -513,6 +590,182 @@ ioat3_prep_xor_val(struct dma_chan *chan, dma_addr_t *src,
 				     src_cnt - 1, len, flags);
 }
 
+static void
+dump_pq_desc_dbg(struct ioat2_dma_chan *ioat, struct ioat_ring_ent *desc, struct ioat_ring_ent *ext)
+{
+	struct device *dev = to_dev(&ioat->base);
+	struct ioat_pq_descriptor *pq = desc->pq;
+	struct ioat_pq_ext_descriptor *pq_ex = ext ? ext->pq_ex : NULL;
+	struct ioat_raw_descriptor *descs[] = { (void *) pq, (void *) pq_ex };
+	int src_cnt = src_cnt_to_sw(pq->ctl_f.src_cnt);
+	int i;
+
+	dev_dbg(dev, "desc[%d]: (%#llx->%#llx) flags: %#x"
+		" sz: %#x ctl: %#x (op: %d int: %d compl: %d pq: '%s%s' src_cnt: %d)\n",
+		desc_id(desc), (unsigned long long) desc->txd.phys,
+		(unsigned long long) (pq_ex ? pq_ex->next : pq->next),
+		desc->txd.flags, pq->size, pq->ctl, pq->ctl_f.op, pq->ctl_f.int_en,
+		pq->ctl_f.compl_write,
+		pq->ctl_f.p_disable ? "" : "p", pq->ctl_f.q_disable ? "" : "q",
+		pq->ctl_f.src_cnt);
+	for (i = 0; i < src_cnt; i++)
+		dev_dbg(dev, "\tsrc[%d]: %#llx coef: %#x\n", i,
+			(unsigned long long) pq_get_src(descs, i), pq->coef[i]);
+	dev_dbg(dev, "\tP: %#llx\n", pq->p_addr);
+	dev_dbg(dev, "\tQ: %#llx\n", pq->q_addr);
+}
+
+static struct dma_async_tx_descriptor *
+__ioat3_prep_pq_lock(struct dma_chan *c, enum sum_check_flags *result,
+		     const dma_addr_t *dst, const dma_addr_t *src,
+		     unsigned int src_cnt, const unsigned char *scf,
+		     size_t len, unsigned long flags)
+{
+	struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
+	struct ioat_chan_common *chan = &ioat->base;
+	struct ioat_ring_ent *compl_desc;
+	struct ioat_ring_ent *desc;
+	struct ioat_ring_ent *ext;
+	size_t total_len = len;
+	struct ioat_pq_descriptor *pq;
+	struct ioat_pq_ext_descriptor *pq_ex = NULL;
+	struct ioat_dma_descriptor *hw;
+	u32 offset = 0;
+	int num_descs;
+	int with_ext;
+	int i, s;
+	u16 idx;
+	u8 op = result ? IOAT_OP_PQ_VAL : IOAT_OP_PQ;
+
+	dev_dbg(to_dev(chan), "%s\n", __func__);
+	/* the engine requires at least two sources (we provide
+	 * at least 1 implied source in the DMA_PREP_CONTINUE case)
+	 */
+	BUG_ON(src_cnt + dmaf_continue(flags) < 2);
+
+	num_descs = ioat2_xferlen_to_descs(ioat, len);
+	/* we need 2x the number of descriptors to cover greater than 3
+	 * sources
+	 */
+	if (src_cnt > 3 || flags & DMA_PREP_CONTINUE) {
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
+
+		desc = ioat2_get_ring_ent(ioat, idx + i);
+		pq = desc->pq;
+
+		/* save a branch by unconditionally retrieving the
+		 * extended descriptor pq_set_src() knows to not write
+		 * to it in the single descriptor case
+		 */
+		ext = ioat2_get_ring_ent(ioat, idx + i + with_ext);
+		pq_ex = ext->pq_ex;
+
+		descs[0] = (struct ioat_raw_descriptor *) pq;
+		descs[1] = (struct ioat_raw_descriptor *) pq_ex;
+
+		for (s = 0; s < src_cnt; s++)
+			pq_set_src(descs, src[s], offset, scf[s], s);
+
+		/* see the comment for dma_maxpq in include/linux/dmaengine.h */
+		if (dmaf_p_disabled_continue(flags))
+			pq_set_src(descs, dst[1], offset, 1, s++);
+		else if (dmaf_continue(flags)) {
+			pq_set_src(descs, dst[0], offset, 0, s++);
+			pq_set_src(descs, dst[1], offset, 1, s++);
+			pq_set_src(descs, dst[1], offset, 0, s++);
+		}
+		pq->size = xfer_size;
+		pq->p_addr = dst[0] + offset;
+		pq->q_addr = dst[1] + offset;
+		pq->ctl = 0;
+		pq->ctl_f.op = op;
+		pq->ctl_f.src_cnt = src_cnt_to_hw(s);
+		pq->ctl_f.p_disable = !!(flags & DMA_PREP_PQ_DISABLE_P);
+		pq->ctl_f.q_disable = !!(flags & DMA_PREP_PQ_DISABLE_Q);
+
+		len -= xfer_size;
+		offset += xfer_size;
+	}
+
+	/* last pq descriptor carries the unmap parameters and fence bit */
+	desc->txd.flags = flags;
+	desc->len = total_len;
+	if (result)
+		desc->result = result;
+	pq->ctl_f.fence = !!(flags & DMA_PREP_FENCE);
+	dump_pq_desc_dbg(ioat, desc, ext);
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
+ioat3_prep_pq(struct dma_chan *chan, dma_addr_t *dst, dma_addr_t *src,
+	      unsigned int src_cnt, const unsigned char *scf, size_t len,
+	      unsigned long flags)
+{
+	/* handle the single source multiply case from the raid6
+	 * recovery path
+	 */
+	if (unlikely((flags & DMA_PREP_PQ_DISABLE_P) && src_cnt == 1)) {
+		dma_addr_t single_source[2];
+		unsigned char single_source_coef[2];
+
+		BUG_ON(flags & DMA_PREP_PQ_DISABLE_Q);
+		single_source[0] = src[0];
+		single_source[1] = src[0];
+		single_source_coef[0] = scf[0];
+		single_source_coef[1] = 0;
+
+		return __ioat3_prep_pq_lock(chan, NULL, dst, single_source, 2,
+					    single_source_coef, len, flags);
+	} else
+		return __ioat3_prep_pq_lock(chan, NULL, dst, src, src_cnt, scf,
+					    len, flags);
+}
+
+struct dma_async_tx_descriptor *
+ioat3_prep_pq_val(struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
+		  unsigned int src_cnt, const unsigned char *scf, size_t len,
+		  enum sum_check_flags *pqres, unsigned long flags)
+{
+	/* the cleanup routine only sets bits on validate failure, it
+	 * does not clear bits on validate success... so clear it here
+	 */
+	*pqres = 0;
+
+	return __ioat3_prep_pq_lock(chan, pqres, pq, src, src_cnt, scf, len,
+				    flags);
+}
+
 static void __devinit ioat3_dma_test_callback(void *dma_async_param)
 {
 	struct completion *cmp = dma_async_param;
@@ -822,6 +1075,16 @@ int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 		dma_cap_set(DMA_XOR_VAL, dma->cap_mask);
 		dma->device_prep_dma_xor_val = ioat3_prep_xor_val;
 	}
+	if (cap & IOAT_CAP_PQ) {
+		dma_set_maxpq(dma, 8, 0);
+		dma->pq_align = 2;
+
+		dma_cap_set(DMA_PQ, dma->cap_mask);
+		dma->device_prep_dma_pq = ioat3_prep_pq;
+
+		dma_cap_set(DMA_PQ_VAL, dma->cap_mask);
+		dma->device_prep_dma_pq_val = ioat3_prep_pq_val;
+	}
 
 	/* -= IOAT ver.3 workarounds =- */
 	/* Write CHANERRMSK_INT with 3E07h to mask out the errors
