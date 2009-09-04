From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 06/18] ioat3: hardware version 3.2 register / descriptor
	definitions
Date: Thu, 03 Sep 2009 23:45:05 -0700
Message-ID: <20090904064505.7141.84327.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com, Tom Picard <tom.s.picard@intel.com>
List-Id: linux-raid.ids

ioat3.2 adds raid5 and raid6 offload capabilities.

Signed-off-by: Tom Picard <tom.s.picard@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma.h       |    2 -
 drivers/dma/ioat/dma_v2.h    |   26 +++++++-
 drivers/dma/ioat/hw.h        |  142 ++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/ioat/registers.h |   17 +++++
 4 files changed, 185 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 8966fa5..08e391a 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -155,7 +155,7 @@ ioat_is_complete(struct dma_chan *c, dma_cookie_t cookie,
 
 /**
  * struct ioat_desc_sw - wrapper around hardware descriptor
- * @hw: hardware DMA descriptor
+ * @hw: hardware DMA descriptor (for memcpy)
  * @node: this descriptor will either be on the free list,
  *     or attached to a transaction list (tx_list)
  * @txd: the generic software descriptor for all engines
diff --git a/drivers/dma/ioat/dma_v2.h b/drivers/dma/ioat/dma_v2.h
index ac00adc..9011306 100644
--- a/drivers/dma/ioat/dma_v2.h
+++ b/drivers/dma/ioat/dma_v2.h
@@ -114,8 +114,32 @@ static inline u16 ioat2_xferlen_to_descs(struct ioat2_dma_chan *ioat, size_t len
 	return num_descs;
 }
 
+/**
+ * struct ioat_ring_ent - wrapper around hardware descriptor
+ * @hw: hardware DMA descriptor (for memcpy)
+ * @fill: hardware fill descriptor
+ * @xor: hardware xor descriptor
+ * @xor_ex: hardware xor extension descriptor
+ * @pq: hardware pq descriptor
+ * @pq_ex: hardware pq extension descriptor
+ * @pqu: hardware pq update descriptor
+ * @raw: hardware raw (un-typed) descriptor
+ * @txd: the generic software descriptor for all engines
+ * @len: total transaction length for unmap
+ * @id: identifier for debug
+ */
+
 struct ioat_ring_ent {
-	struct ioat_dma_descriptor *hw;
+	union {
+		struct ioat_dma_descriptor *hw;
+		struct ioat_fill_descriptor *fill;
+		struct ioat_xor_descriptor *xor;
+		struct ioat_xor_ext_descriptor *xor_ex;
+		struct ioat_pq_descriptor *pq;
+		struct ioat_pq_ext_descriptor *pq_ex;
+		struct ioat_pq_update_descriptor *pqu;
+		struct ioat_raw_descriptor *raw;
+	};
 	size_t len;
 	struct dma_async_tx_descriptor txd;
 	#ifdef DEBUG
diff --git a/drivers/dma/ioat/hw.h b/drivers/dma/ioat/hw.h
index 7481fb1..99afb12 100644
--- a/drivers/dma/ioat/hw.h
+++ b/drivers/dma/ioat/hw.h
@@ -37,6 +37,7 @@
 #define IOAT_VER_1_2            0x12    /* Version 1.2 */
 #define IOAT_VER_2_0            0x20    /* Version 2.0 */
 #define IOAT_VER_3_0            0x30    /* Version 3.0 */
+#define IOAT_VER_3_2            0x32    /* Version 3.2 */
 
 struct ioat_dma_descriptor {
 	uint32_t	size;
@@ -55,6 +56,7 @@ struct ioat_dma_descriptor {
 			unsigned int dest_dca:1;
 			unsigned int hint:1;
 			unsigned int rsvd2:13;
+			#define IOAT_OP_COPY 0x00
 			unsigned int op:8;
 		} ctl_f;
 	};
@@ -70,4 +72,144 @@ struct ioat_dma_descriptor {
 	};
 	uint64_t	user2;
 };
+
+struct ioat_fill_descriptor {
+	uint32_t	size;
+	union {
+		uint32_t ctl;
+		struct {
+			unsigned int int_en:1;
+			unsigned int rsvd:1;
+			unsigned int dest_snoop_dis:1;
+			unsigned int compl_write:1;
+			unsigned int fence:1;
+			unsigned int rsvd2:2;
+			unsigned int dest_brk:1;
+			unsigned int bundle:1;
+			unsigned int rsvd4:15;
+			#define IOAT_OP_FILL 0x01
+			unsigned int op:8;
+		} ctl_f;
+	};
+	uint64_t	src_data;
+	uint64_t	dst_addr;
+	uint64_t	next;
+	uint64_t	rsv1;
+	uint64_t	next_dst_addr;
+	uint64_t	user1;
+	uint64_t	user2;
+};
+
+struct ioat_xor_descriptor {
+	uint32_t	size;
+	union {
+		uint32_t ctl;
+		struct {
+			unsigned int int_en:1;
+			unsigned int src_snoop_dis:1;
+			unsigned int dest_snoop_dis:1;
+			unsigned int compl_write:1;
+			unsigned int fence:1;
+			unsigned int src_cnt:3;
+			unsigned int bundle:1;
+			unsigned int dest_dca:1;
+			unsigned int hint:1;
+			unsigned int rsvd:13;
+			#define IOAT_OP_XOR 0x87
+			#define IOAT_OP_XOR_VAL 0x88
+			unsigned int op:8;
+		} ctl_f;
+	};
+	uint64_t	src_addr;
+	uint64_t	dst_addr;
+	uint64_t	next;
+	uint64_t	src_addr2;
+	uint64_t	src_addr3;
+	uint64_t	src_addr4;
+	uint64_t	src_addr5;
+};
+
+struct ioat_xor_ext_descriptor {
+	uint64_t	src_addr6;
+	uint64_t	src_addr7;
+	uint64_t	src_addr8;
+	uint64_t	next;
+	uint64_t	rsvd[4];
+};
+
+struct ioat_pq_descriptor {
+	uint32_t	size;
+	union {
+		uint32_t ctl;
+		struct {
+			unsigned int int_en:1;
+			unsigned int src_snoop_dis:1;
+			unsigned int dest_snoop_dis:1;
+			unsigned int compl_write:1;
+			unsigned int fence:1;
+			unsigned int src_cnt:3;
+			unsigned int bundle:1;
+			unsigned int dest_dca:1;
+			unsigned int hint:1;
+			unsigned int p_disable:1;
+			unsigned int q_disable:1;
+			unsigned int rsvd:11;
+			#define IOAT_OP_PQ 0x89
+			#define IOAT_OP_PQ_VAL 0x8a
+			unsigned int op:8;
+		} ctl_f;
+	};
+	uint64_t	src_addr;
+	uint64_t	p_addr;
+	uint64_t	next;
+	uint64_t	src_addr2;
+	uint64_t	src_addr3;
+	uint8_t		coef[8];
+	uint64_t	q_addr;
+};
+
+struct ioat_pq_ext_descriptor {
+	uint64_t	src_addr4;
+	uint64_t	src_addr5;
+	uint64_t	src_addr6;
+	uint64_t	next;
+	uint64_t	src_addr7;
+	uint64_t	src_addr8;
+	uint64_t	rsvd[2];
+};
+
+struct ioat_pq_update_descriptor {
+	uint32_t	size;
+	union {
+		uint32_t ctl;
+		struct {
+			unsigned int int_en:1;
+			unsigned int src_snoop_dis:1;
+			unsigned int dest_snoop_dis:1;
+			unsigned int compl_write:1;
+			unsigned int fence:1;
+			unsigned int src_cnt:3;
+			unsigned int bundle:1;
+			unsigned int dest_dca:1;
+			unsigned int hint:1;
+			unsigned int p_disable:1;
+			unsigned int q_disable:1;
+			unsigned int rsvd:3;
+			unsigned int coef:8;
+			#define IOAT_OP_PQ_UP 0x8b
+			unsigned int op:8;
+		} ctl_f;
+	};
+	uint64_t	src_addr;
+	uint64_t	p_addr;
+	uint64_t	next;
+	uint64_t	src_addr2;
+	uint64_t	p_src;
+	uint64_t	q_src;
+	uint64_t	q_addr;
+};
+
+struct ioat_raw_descriptor {
+	uint64_t	field[8];
+};
 #endif
diff --git a/drivers/dma/ioat/registers.h b/drivers/dma/ioat/registers.h
index e4334a1..85d04b8 100644
--- a/drivers/dma/ioat/registers.h
+++ b/drivers/dma/ioat/registers.h
@@ -64,6 +64,20 @@
 
 #define IOAT_DEVICE_STATUS_OFFSET		0x0E	/* 16-bit */
 #define IOAT_DEVICE_STATUS_DEGRADED_MODE	0x0001
+#define IOAT_DEVICE_MMIO_RESTRICTED		0x0002
+#define IOAT_DEVICE_MEMORY_BYPASS		0x0004
+#define IOAT_DEVICE_ADDRESS_REMAPPING		0x0008
+
+#define IOAT_DMA_CAP_OFFSET			0x10	/* 32-bit */
+#define IOAT_CAP_PAGE_BREAK			0x00000001
+#define IOAT_CAP_CRC				0x00000002
+#define IOAT_CAP_SKIP_MARKER			0x00000004
+#define IOAT_CAP_DCA				0x00000010
+#define IOAT_CAP_CRC_MOVE			0x00000020
+#define IOAT_CAP_FILL_BLOCK			0x00000040
+#define IOAT_CAP_APIC				0x00000080
+#define IOAT_CAP_XOR				0x00000100
+#define IOAT_CAP_PQ				0x00000200
 
 #define IOAT_CHANNEL_MMIO_SIZE			0x80	/* Each Channel MMIO space is this size */
 
@@ -224,6 +238,9 @@
 #define IOAT_CHANERR_INT_CONFIGURATION_ERR	0x2000
 #define IOAT_CHANERR_SOFT_ERR			0x4000
 #define IOAT_CHANERR_UNAFFILIATED_ERR		0x8000
+#define IOAT_CHANERR_XOR_P_OR_CRC_ERR		0x10000
+#define IOAT_CHANERR_XOR_Q_ERR			0x20000
+#define IOAT_CHANERR_DESCRIPTOR_COUNT_ERR	0x40000
 
 #define IOAT_CHANERR_MASK_OFFSET		0x2C	/* 32-bit Channel Error Register */
 

