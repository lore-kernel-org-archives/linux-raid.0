From: Dan Williams <dan.j.williams@intel.com>
Subject: [md-accel PATCH 16/19] dmaengine: driver for the iop32x, iop33x,
	and iop13xx raid engines
Date: Tue, 26 Jun 2007 18:51:55 -0700
Message-ID: <20070627015155.18962.88413.stgit@dwillia2-linux.ch.intel.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, akpm@linux-foundation.org, davem@davemloft.net, christopher.leech@intel.com, shannon.nelson@intel.com, herbert@gondor.apana.org.au, jeff@garzik.org
List-Id: linux-raid.ids

The Intel(R) IOP series of i/o processors integrate an Xscale core with
raid acceleration engines.  The capabilities per platform are:

iop219:
 (2) copy engines
iop321:
 (2) copy engines
 (1) xor and block fill engine
iop33x:
 (2) copy and crc32c engines
 (1) xor, xor zero sum, pq, pq zero sum, and block fill engine
iop13xx:
 (2) copy, crc32c, xor, xor zero sum, and block fill engines
 (1) copy, crc32c, xor, xor zero sum, pq, pq zero sum, and block fill e=
ngine

The driver supports the features of the async_tx api:
* asynchronous notification of operation completion
* implicit (interupt triggered) handling of inter-channel transaction
  dependencies

The driver adapts to the platform it is running by two methods.
1/ #include <asm/arch/adma.h> which defines the hardware specific
   iop_chan_* and iop_desc_* routines as a series of static inline
   functions
2/ The private platform data attached to the platform_device defines th=
e
   capabilities of the channels

20070626: Callbacks are run in a tasklet.  Given the recent discussion =
on
LKML about killing tasklets in favor of workqueues I did a quick conver=
sion
of the driver.  Raid5 resync performance dropped from 50MB/s to 30MB/s,=
 so
the tasklet implementation remains until a generic softirq interface is
available.

Changelog:
* fixed a slot allocation bug in do_iop13xx_adma_xor that caused too fe=
w
slots to be requested eventually leading to data corruption
* enabled the slot allocation routine to attempt to free slots before
returning -ENOMEM
* switched the cleanup routine to solely use the software chain and the
status register to determine if a descriptor is complete.  This is
necessary to support other IOP engines that do not have status writebac=
k
capability
* make the driver iop generic
* modified the allocation routines to understand allocating a group of
slots for a single operation
* added a null xor initialization operation for the xor only channel on
iop3xx
* support xor operations on buffers larger than the hardware maximum
* split the do_* routines into separate prep, src/dest set, submit stag=
es
* added async_tx support (dependent operations initiation at cleanup ti=
me)
* simplified group handling
* added interrupt support (callbacks via tasklets)
* brought the pending depth inline with ioat (i.e. 4 descriptors)
* drop dma mapping methods, suggested by Chris Leech
* don't use inline in C files, Adrian Bunk
* remove static tasklet declarations
* make iop_adma_alloc_slots easier to read and remove chances for a
corrupted descriptor chain
* fix locking bug in iop_adma_alloc_chan_resources, Benjamin Herrenschm=
idt
* convert capabilities over to dma_cap_mask_t
* fixup sparse warnings
* add descriptor flush before iop_chan_enable
* checkpatch.pl fixes
* gpl v2 only correction
* move set_src, set_dest, submit to async_tx methods

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/dma/Kconfig                 |    8=20
 drivers/dma/Makefile                |    1=20
 drivers/dma/iop-adma.c              | 1465 +++++++++++++++++++++++++++=
++++++++
 include/asm-arm/hardware/iop_adma.h |  120 +++
 4 files changed, 1594 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 492aa08..f27f5c7 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -31,4 +31,12 @@ config INTEL_IOATDMA
 	default m
 	---help---
 	  Enable support for the Intel(R) I/OAT DMA engine.
+
+config INTEL_IOP_ADMA
+        tristate "Intel IOP ADMA support"
+        depends on DMA_ENGINE && (ARCH_IOP32X || ARCH_IOP33X || ARCH_I=
OP13XX)
+        default m
+        ---help---
+          Enable support for the Intel(R) IOP Series RAID engines.
+
 endmenu
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index bdcfdbd..b3839b6 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_DMA_ENGINE) +=3D dmaengine.o
 obj-$(CONFIG_NET_DMA) +=3D iovlock.o
 obj-$(CONFIG_INTEL_IOATDMA) +=3D ioatdma.o
+obj-$(CONFIG_INTEL_IOP_ADMA) +=3D iop-adma.o
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
new file mode 100644
index 0000000..3db12d6
--- /dev/null
+++ b/drivers/dma/iop-adma.c
@@ -0,0 +1,1465 @@
+/*
+ * offload engine driver for the Intel Xscale series of i/o processors
+ * Copyright =C2=A9 2006, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITH=
OUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY =
or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licen=
se for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License a=
long with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+/*
+ * This driver supports the asynchrounous DMA copy and RAID engines av=
ailable
+ * on the Intel Xscale(R) family of I/O Processors (IOP 32x, 33x, 134x=
)
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/async_tx.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/memory.h>
+#include <linux/ioport.h>
+
+#include <asm/arch/adma.h>
+
+#define to_iop_adma_chan(chan) container_of(chan, struct iop_adma_chan=
, common)
+#define to_iop_adma_device(dev) \
+	container_of(dev, struct iop_adma_device, common)
+#define tx_to_iop_adma_slot(tx) \
+	container_of(tx, struct iop_adma_desc_slot, async_tx)
+
+/**
+ * iop_adma_free_slots - flags descriptor slots for reuse
+ * @slot: Slot to free
+ * Caller must hold &iop_chan->lock while calling this function
+ */
+static void iop_adma_free_slots(struct iop_adma_desc_slot *slot)
+{
+	int stride =3D slot->slots_per_op;
+
+	while (stride--) {
+		slot->slots_per_op =3D 0;
+		slot =3D list_entry(slot->slot_node.next,
+				struct iop_adma_desc_slot,
+				slot_node);
+	}
+}
+
+static dma_cookie_t
+iop_adma_run_tx_complete_actions(struct iop_adma_desc_slot *desc,
+	struct iop_adma_chan *iop_chan, dma_cookie_t cookie)
+{
+	BUG_ON(desc->async_tx.cookie < 0);
+	spin_lock_bh(&desc->async_tx.lock);
+	if (desc->async_tx.cookie > 0) {
+		cookie =3D desc->async_tx.cookie;
+		desc->async_tx.cookie =3D 0;
+
+		/* call the callback (must not sleep or submit new
+		 * operations to this channel)
+		 */
+		if (desc->async_tx.callback)
+			desc->async_tx.callback(
+				desc->async_tx.callback_param);
+
+		/* unmap dma addresses
+		 * (unmap_single vs unmap_page?)
+		 */
+		if (desc->group_head && desc->unmap_len) {
+			struct iop_adma_desc_slot *unmap =3D desc->group_head;
+			struct device *dev =3D
+				&iop_chan->device->pdev->dev;
+			u32 len =3D unmap->unmap_len;
+			u32 src_cnt =3D unmap->unmap_src_cnt;
+			dma_addr_t addr =3D iop_desc_get_dest_addr(unmap,
+				iop_chan);
+
+			dma_unmap_page(dev, addr, len, DMA_FROM_DEVICE);
+			while (src_cnt--) {
+				addr =3D iop_desc_get_src_addr(unmap,
+							iop_chan,
+							src_cnt);
+				dma_unmap_page(dev, addr, len,
+					DMA_TO_DEVICE);
+			}
+			desc->group_head =3D NULL;
+		}
+	}
+
+	/* run dependent operations */
+	async_tx_run_dependencies(&desc->async_tx);
+	spin_unlock_bh(&desc->async_tx.lock);
+
+	return cookie;
+}
+
+static int
+iop_adma_clean_slot(struct iop_adma_desc_slot *desc,
+	struct iop_adma_chan *iop_chan)
+{
+	/* the client is allowed to attach dependent operations
+	 * until 'ack' is set
+	 */
+	if (!desc->async_tx.ack)
+		return 0;
+
+	/* leave the last descriptor in the chain
+	 * so we can append to it
+	 */
+	if (desc->chain_node.next =3D=3D &iop_chan->chain)
+		return 1;
+
+	dev_dbg(iop_chan->device->common.dev,
+		"\tfree slot: %d slots_per_op: %d\n",
+		desc->idx, desc->slots_per_op);
+
+	list_del(&desc->chain_node);
+	iop_adma_free_slots(desc);
+
+	return 0;
+}
+
+static void __iop_adma_slot_cleanup(struct iop_adma_chan *iop_chan)
+{
+	struct iop_adma_desc_slot *iter, *_iter, *grp_start =3D NULL;
+	dma_cookie_t cookie =3D 0;
+	u32 current_desc =3D iop_chan_get_current_descriptor(iop_chan);
+	int busy =3D iop_chan_is_busy(iop_chan);
+	int seen_current =3D 0, slot_cnt =3D 0, slots_per_op =3D 0;
+
+	dev_dbg(iop_chan->device->common.dev, "%s\n", __FUNCTION__);
+	/* free completed slots from the chain starting with
+	 * the oldest descriptor
+	 */
+	list_for_each_entry_safe(iter, _iter, &iop_chan->chain,
+					chain_node) {
+		pr_debug("\tcookie: %d slot: %d busy: %d "
+			"this_desc: %#x next_desc: %#x ack: %d\n",
+			iter->async_tx.cookie, iter->idx, busy, iter->phys,
+			iop_desc_get_next_desc(iter),
+			iter->async_tx.ack);
+		prefetch(_iter);
+		prefetch(&_iter->async_tx);
+
+		/* do not advance past the current descriptor loaded into the
+		 * hardware channel, subsequent descriptors are either in
+		 * process or have not been submitted
+		 */
+		if (seen_current)
+			break;
+
+		/* stop the search if we reach the current descriptor and the
+		 * channel is busy, or if it appears that the current descriptor
+		 * needs to be re-read (i.e. has been appended to)
+		 */
+		if (iter->phys =3D=3D current_desc) {
+			BUG_ON(seen_current++);
+			if (busy || iop_desc_get_next_desc(iter))
+				break;
+		}
+
+		/* detect the start of a group transaction */
+		if (!slot_cnt && !slots_per_op) {
+			slot_cnt =3D iter->slot_cnt;
+			slots_per_op =3D iter->slots_per_op;
+			if (slot_cnt <=3D slots_per_op) {
+				slot_cnt =3D 0;
+				slots_per_op =3D 0;
+			}
+		}
+
+		if (slot_cnt) {
+			pr_debug("\tgroup++\n");
+			if (!grp_start)
+				grp_start =3D iter;
+			slot_cnt -=3D slots_per_op;
+		}
+
+		/* all the members of a group are complete */
+		if (slots_per_op !=3D 0 && slot_cnt =3D=3D 0) {
+			struct iop_adma_desc_slot *grp_iter, *_grp_iter;
+			int end_of_chain =3D 0;
+			pr_debug("\tgroup end\n");
+
+			/* collect the total results */
+			if (grp_start->xor_check_result) {
+				u32 zero_sum_result =3D 0;
+				slot_cnt =3D grp_start->slot_cnt;
+				grp_iter =3D grp_start;
+
+				list_for_each_entry_from(grp_iter,
+					&iop_chan->chain, chain_node) {
+					zero_sum_result |=3D
+					    iop_desc_get_zero_result(grp_iter);
+					    pr_debug("\titer%d result: %d\n",
+					    grp_iter->idx, zero_sum_result);
+					slot_cnt -=3D slots_per_op;
+					if (slot_cnt =3D=3D 0)
+						break;
+				}
+				pr_debug("\tgrp_start->xor_check_result: %p\n",
+					grp_start->xor_check_result);
+				*grp_start->xor_check_result =3D zero_sum_result;
+			}
+
+			/* clean up the group */
+			slot_cnt =3D grp_start->slot_cnt;
+			grp_iter =3D grp_start;
+			list_for_each_entry_safe_from(grp_iter, _grp_iter,
+				&iop_chan->chain, chain_node) {
+				cookie =3D iop_adma_run_tx_complete_actions(
+					grp_iter, iop_chan, cookie);
+
+				slot_cnt -=3D slots_per_op;
+				end_of_chain =3D iop_adma_clean_slot(grp_iter,
+					iop_chan);
+
+				if (slot_cnt =3D=3D 0 || end_of_chain)
+					break;
+			}
+
+			/* the group should be complete at this point */
+			BUG_ON(slot_cnt);
+
+			slots_per_op =3D 0;
+			grp_start =3D NULL;
+			if (end_of_chain)
+				break;
+			else
+				continue;
+		} else if (slots_per_op) /* wait for group completion */
+			continue;
+
+		/* write back zero sum results (single descriptor case) */
+		if (iter->xor_check_result && iter->async_tx.cookie)
+			*iter->xor_check_result =3D
+				iop_desc_get_zero_result(iter);
+
+		cookie =3D iop_adma_run_tx_complete_actions(
+					iter, iop_chan, cookie);
+
+		if (iop_adma_clean_slot(iter, iop_chan))
+			break;
+	}
+
+	BUG_ON(!seen_current);
+
+	iop_chan_idle(busy, iop_chan);
+
+	if (cookie > 0) {
+		iop_chan->completed_cookie =3D cookie;
+		pr_debug("\tcompleted cookie %d\n", cookie);
+	}
+}
+
+static void
+iop_adma_slot_cleanup(struct iop_adma_chan *iop_chan)
+{
+	spin_lock_bh(&iop_chan->lock);
+	__iop_adma_slot_cleanup(iop_chan);
+	spin_unlock_bh(&iop_chan->lock);
+}
+
+static void iop_adma_tasklet(unsigned long data)
+{
+	struct iop_adma_chan *chan =3D (struct iop_adma_chan *) data;
+	__iop_adma_slot_cleanup(chan);
+}
+
+static struct iop_adma_desc_slot *
+iop_adma_alloc_slots(struct iop_adma_chan *iop_chan, int num_slots,
+			int slots_per_op)
+{
+	struct iop_adma_desc_slot *iter, *_iter, *alloc_start =3D NULL;
+	struct list_head chain =3D LIST_HEAD_INIT(chain);
+	int slots_found, retry =3D 0;
+
+	/* start search from the last allocated descrtiptor
+	 * if a contiguous allocation can not be found start searching
+	 * from the beginning of the list
+	 */
+retry:
+	slots_found =3D 0;
+	if (retry =3D=3D 0)
+		iter =3D iop_chan->last_used;
+	else
+		iter =3D list_entry(&iop_chan->all_slots,
+			struct iop_adma_desc_slot,
+			slot_node);
+
+	list_for_each_entry_safe_continue(
+		iter, _iter, &iop_chan->all_slots, slot_node) {
+		prefetch(_iter);
+		prefetch(&_iter->async_tx);
+		if (iter->slots_per_op) {
+			/* give up after finding the first busy slot
+			 * on the second pass through the list
+			 */
+			if (retry)
+				break;
+
+			slots_found =3D 0;
+			continue;
+		}
+
+		/* start the allocation if the slot is correctly aligned */
+		if (!slots_found++) {
+			if (iop_desc_is_aligned(iter, slots_per_op))
+				alloc_start =3D iter;
+			else {
+				slots_found =3D 0;
+				continue;
+			}
+		}
+
+		if (slots_found =3D=3D num_slots) {
+			struct iop_adma_desc_slot *alloc_tail =3D NULL;
+			struct iop_adma_desc_slot *last_used =3D NULL;
+			iter =3D alloc_start;
+			while (num_slots) {
+				int i;
+				dev_dbg(iop_chan->device->common.dev,
+					"allocated slot: %d "
+					"(desc %p phys: %#x) slots_per_op %d\n",
+					iter->idx, iter->hw_desc, iter->phys,
+					slots_per_op);
+
+				/* pre-ack all but the last descriptor */
+				if (num_slots !=3D slots_per_op)
+					iter->async_tx.ack =3D 1;
+				else
+					iter->async_tx.ack =3D 0;
+
+				list_add_tail(&iter->chain_node, &chain);
+				alloc_tail =3D iter;
+				iter->async_tx.cookie =3D 0;
+				iter->slot_cnt =3D num_slots;
+				iter->xor_check_result =3D NULL;
+				for (i =3D 0; i < slots_per_op; i++) {
+					iter->slots_per_op =3D slots_per_op - i;
+					last_used =3D iter;
+					iter =3D list_entry(iter->slot_node.next,
+						struct iop_adma_desc_slot,
+						slot_node);
+				}
+				num_slots -=3D slots_per_op;
+			}
+			alloc_tail->group_head =3D alloc_start;
+			alloc_tail->async_tx.cookie =3D -EBUSY;
+			list_splice(&chain, &alloc_tail->group_list);
+			iop_chan->last_used =3D last_used;
+			iop_desc_clear_next_desc(alloc_start);
+			iop_desc_clear_next_desc(alloc_tail);
+			return alloc_tail;
+		}
+	}
+	if (!retry++)
+		goto retry;
+
+	/* try to free some slots if the allocation fails */
+	tasklet_schedule(&iop_chan->irq_tasklet);
+
+	return NULL;
+}
+
+static dma_cookie_t
+iop_desc_assign_cookie(struct iop_adma_chan *iop_chan,
+	struct iop_adma_desc_slot *desc)
+{
+	dma_cookie_t cookie =3D iop_chan->common.cookie;
+	cookie++;
+	if (cookie < 0)
+		cookie =3D 1;
+	iop_chan->common.cookie =3D desc->async_tx.cookie =3D cookie;
+	return cookie;
+}
+
+static void iop_adma_check_threshold(struct iop_adma_chan *iop_chan)
+{
+	dev_dbg(iop_chan->device->common.dev, "pending: %d\n",
+		iop_chan->pending);
+
+	if (iop_chan->pending >=3D IOP_ADMA_THRESHOLD) {
+		iop_chan->pending =3D 0;
+		iop_chan_append(iop_chan);
+	}
+}
+
+static dma_cookie_t
+iop_adma_tx_submit(struct dma_async_tx_descriptor *tx)
+{
+	struct iop_adma_desc_slot *sw_desc =3D tx_to_iop_adma_slot(tx);
+	struct iop_adma_chan *iop_chan =3D to_iop_adma_chan(tx->chan);
+	struct iop_adma_desc_slot *grp_start, *old_chain_tail;
+	int slot_cnt;
+	int slots_per_op;
+	dma_cookie_t cookie;
+
+	grp_start =3D sw_desc->group_head;
+	slot_cnt =3D grp_start->slot_cnt;
+	slots_per_op =3D grp_start->slots_per_op;
+
+	spin_lock_bh(&iop_chan->lock);
+	cookie =3D iop_desc_assign_cookie(iop_chan, sw_desc);
+
+	old_chain_tail =3D list_entry(iop_chan->chain.prev,
+		struct iop_adma_desc_slot, chain_node);
+	list_splice_init(&sw_desc->group_list, &old_chain_tail->chain_node);
+
+	/* fix up the hardware chain */
+	iop_desc_set_next_desc(old_chain_tail, grp_start->phys);
+
+	/* 1/ don't add pre-chained descriptors
+	 * 2/ dummy read to flush next_desc write
+	 */
+	BUG_ON(iop_desc_get_next_desc(sw_desc));
+
+	/* increment the pending count by the number of slots
+	 * memcpy operations have a 1:1 (slot:operation) relation
+	 * other operations are heavier and will pop the threshold
+	 * more often.
+	 */
+	iop_chan->pending +=3D slot_cnt;
+	iop_adma_check_threshold(iop_chan);
+	spin_unlock_bh(&iop_chan->lock);
+
+	dev_dbg(iop_chan->device->common.dev, "%s cookie: %d slot: %d\n",
+		__FUNCTION__, sw_desc->async_tx.cookie, sw_desc->idx);
+
+	return cookie;
+}
+
+static void
+iop_adma_set_dest(dma_addr_t addr, struct dma_async_tx_descriptor *tx,
+	int index)
+{
+	struct iop_adma_desc_slot *sw_desc =3D tx_to_iop_adma_slot(tx);
+	struct iop_adma_chan *iop_chan =3D to_iop_adma_chan(tx->chan);
+
+	/* to do: support transfers lengths > IOP_ADMA_MAX_BYTE_COUNT */
+	iop_desc_set_dest_addr(sw_desc->group_head, iop_chan, addr);
+}
+
+static void iop_chan_start_null_memcpy(struct iop_adma_chan *iop_chan)=
;
+static void iop_chan_start_null_xor(struct iop_adma_chan *iop_chan);
+
+/* returns the number of allocated descriptors */
+static int iop_adma_alloc_chan_resources(struct dma_chan *chan)
+{
+	char *hw_desc;
+	int idx;
+	struct iop_adma_chan *iop_chan =3D to_iop_adma_chan(chan);
+	struct iop_adma_desc_slot *slot =3D NULL;
+	int init =3D iop_chan->slots_allocated ? 0 : 1;
+	struct iop_adma_platform_data *plat_data =3D
+		iop_chan->device->pdev->dev.platform_data;
+	int num_descs_in_pool =3D plat_data->pool_size/IOP_ADMA_SLOT_SIZE;
+
+	/* Allocate descriptor slots */
+	do {
+		idx =3D iop_chan->slots_allocated;
+		if (idx =3D=3D num_descs_in_pool)
+			break;
+
+		slot =3D kzalloc(sizeof(*slot), GFP_KERNEL);
+		if (!slot) {
+			printk(KERN_INFO "IOP ADMA Channel only initialized"
+				" %d descriptor slots", idx);
+			break;
+		}
+		hw_desc =3D (char *) iop_chan->device->dma_desc_pool_virt;
+		slot->hw_desc =3D (void *) &hw_desc[idx * IOP_ADMA_SLOT_SIZE];
+
+		dma_async_tx_descriptor_init(&slot->async_tx, chan);
+		slot->async_tx.tx_submit =3D iop_adma_tx_submit;
+		slot->async_tx.tx_set_dest =3D iop_adma_set_dest;
+		INIT_LIST_HEAD(&slot->chain_node);
+		INIT_LIST_HEAD(&slot->slot_node);
+		INIT_LIST_HEAD(&slot->group_list);
+		hw_desc =3D (char *) iop_chan->device->dma_desc_pool;
+		slot->phys =3D (dma_addr_t) &hw_desc[idx * IOP_ADMA_SLOT_SIZE];
+		slot->idx =3D idx;
+
+		spin_lock_bh(&iop_chan->lock);
+		iop_chan->slots_allocated++;
+		list_add_tail(&slot->slot_node, &iop_chan->all_slots);
+		spin_unlock_bh(&iop_chan->lock);
+	} while (iop_chan->slots_allocated < num_descs_in_pool);
+
+	if (idx && !iop_chan->last_used)
+		iop_chan->last_used =3D list_entry(iop_chan->all_slots.next,
+					struct iop_adma_desc_slot,
+					slot_node);
+
+	dev_dbg(iop_chan->device->common.dev,
+		"allocated %d descriptor slots last_used: %p\n",
+		iop_chan->slots_allocated, iop_chan->last_used);
+
+	/* initialize the channel and the chain with a null operation */
+	if (init) {
+		if (dma_has_cap(DMA_MEMCPY,
+			iop_chan->device->common.cap_mask))
+			iop_chan_start_null_memcpy(iop_chan);
+		else if (dma_has_cap(DMA_XOR,
+			iop_chan->device->common.cap_mask))
+			iop_chan_start_null_xor(iop_chan);
+		else
+			BUG();
+	}
+
+	return (idx > 0) ? idx : -ENOMEM;
+}
+
+static struct dma_async_tx_descriptor *
+iop_adma_prep_dma_interrupt(struct dma_chan *chan)
+{
+	struct iop_adma_chan *iop_chan =3D to_iop_adma_chan(chan);
+	struct iop_adma_desc_slot *sw_desc, *grp_start;
+	int slot_cnt, slots_per_op;
+
+	dev_dbg(iop_chan->device->common.dev, "%s\n", __FUNCTION__);
+
+	spin_lock_bh(&iop_chan->lock);
+	slot_cnt =3D iop_chan_interrupt_slot_count(&slots_per_op, iop_chan);
+	sw_desc =3D iop_adma_alloc_slots(iop_chan, slot_cnt, slots_per_op);
+	if (sw_desc) {
+		grp_start =3D sw_desc->group_head;
+		iop_desc_init_interrupt(grp_start, iop_chan);
+		grp_start->unmap_len =3D 0;
+	}
+	spin_unlock_bh(&iop_chan->lock);
+
+	return sw_desc ? &sw_desc->async_tx : NULL;
+}
+
+static void
+iop_adma_memcpy_set_src(dma_addr_t addr, struct dma_async_tx_descripto=
r *tx,
+	int index)
+{
+	struct iop_adma_desc_slot *sw_desc =3D tx_to_iop_adma_slot(tx);
+	struct iop_adma_desc_slot *grp_start =3D sw_desc->group_head;
+
+	iop_desc_set_memcpy_src_addr(grp_start, addr);
+}
+
+static struct dma_async_tx_descriptor *
+iop_adma_prep_dma_memcpy(struct dma_chan *chan, size_t len, int int_en=
)
+{
+	struct iop_adma_chan *iop_chan =3D to_iop_adma_chan(chan);
+	struct iop_adma_desc_slot *sw_desc, *grp_start;
+	int slot_cnt, slots_per_op;
+
+	if (unlikely(!len))
+		return NULL;
+	BUG_ON(unlikely(len > IOP_ADMA_MAX_BYTE_COUNT));
+
+	dev_dbg(iop_chan->device->common.dev, "%s len: %u\n",
+		__FUNCTION__, len);
+
+	spin_lock_bh(&iop_chan->lock);
+	slot_cnt =3D iop_chan_memcpy_slot_count(len, &slots_per_op);
+	sw_desc =3D iop_adma_alloc_slots(iop_chan, slot_cnt, slots_per_op);
+	if (sw_desc) {
+		grp_start =3D sw_desc->group_head;
+		iop_desc_init_memcpy(grp_start, int_en);
+		iop_desc_set_byte_count(grp_start, iop_chan, len);
+		sw_desc->unmap_src_cnt =3D 1;
+		sw_desc->unmap_len =3D len;
+		sw_desc->async_tx.tx_set_src =3D iop_adma_memcpy_set_src;
+	}
+	spin_unlock_bh(&iop_chan->lock);
+
+	return sw_desc ? &sw_desc->async_tx : NULL;
+}
+
+static struct dma_async_tx_descriptor *
+iop_adma_prep_dma_memset(struct dma_chan *chan, int value, size_t len,
+	int int_en)
+{
+	struct iop_adma_chan *iop_chan =3D to_iop_adma_chan(chan);
+	struct iop_adma_desc_slot *sw_desc, *grp_start;
+	int slot_cnt, slots_per_op;
+
+	if (unlikely(!len))
+		return NULL;
+	BUG_ON(unlikely(len > IOP_ADMA_MAX_BYTE_COUNT));
+
+	dev_dbg(iop_chan->device->common.dev, "%s len: %u\n",
+		__FUNCTION__, len);
+
+	spin_lock_bh(&iop_chan->lock);
+	slot_cnt =3D iop_chan_memset_slot_count(len, &slots_per_op);
+	sw_desc =3D iop_adma_alloc_slots(iop_chan, slot_cnt, slots_per_op);
+	if (sw_desc) {
+		grp_start =3D sw_desc->group_head;
+		iop_desc_init_memset(grp_start, int_en);
+		iop_desc_set_byte_count(grp_start, iop_chan, len);
+		iop_desc_set_block_fill_val(grp_start, value);
+		sw_desc->unmap_src_cnt =3D 1;
+		sw_desc->unmap_len =3D len;
+	}
+	spin_unlock_bh(&iop_chan->lock);
+
+	return sw_desc ? &sw_desc->async_tx : NULL;
+}
+
+static void
+iop_adma_xor_set_src(dma_addr_t addr, struct dma_async_tx_descriptor *=
tx,
+	int index)
+{
+	struct iop_adma_desc_slot *sw_desc =3D tx_to_iop_adma_slot(tx);
+	struct iop_adma_desc_slot *grp_start =3D sw_desc->group_head;
+
+	iop_desc_set_xor_src_addr(grp_start, index, addr);
+}
+
+static struct dma_async_tx_descriptor *
+iop_adma_prep_dma_xor(struct dma_chan *chan, unsigned int src_cnt, siz=
e_t len,
+	int int_en)
+{
+	struct iop_adma_chan *iop_chan =3D to_iop_adma_chan(chan);
+	struct iop_adma_desc_slot *sw_desc, *grp_start;
+	int slot_cnt, slots_per_op;
+
+	if (unlikely(!len))
+		return NULL;
+	BUG_ON(unlikely(len > IOP_ADMA_XOR_MAX_BYTE_COUNT));
+
+	dev_dbg(iop_chan->device->common.dev,
+		"%s src_cnt: %d len: %u int_en: %d\n",
+		__FUNCTION__, src_cnt, len, int_en);
+
+	spin_lock_bh(&iop_chan->lock);
+	slot_cnt =3D iop_chan_xor_slot_count(len, src_cnt, &slots_per_op);
+	sw_desc =3D iop_adma_alloc_slots(iop_chan, slot_cnt, slots_per_op);
+	if (sw_desc) {
+		grp_start =3D sw_desc->group_head;
+		iop_desc_init_xor(grp_start, src_cnt, int_en);
+		iop_desc_set_byte_count(grp_start, iop_chan, len);
+		sw_desc->unmap_src_cnt =3D src_cnt;
+		sw_desc->unmap_len =3D len;
+		sw_desc->async_tx.tx_set_src =3D iop_adma_xor_set_src;
+	}
+	spin_unlock_bh(&iop_chan->lock);
+
+	return sw_desc ? &sw_desc->async_tx : NULL;
+}
+
+static void
+iop_adma_xor_zero_sum_set_src(dma_addr_t addr,
+				struct dma_async_tx_descriptor *tx,
+				int index)
+{
+	struct iop_adma_desc_slot *sw_desc =3D tx_to_iop_adma_slot(tx);
+	struct iop_adma_desc_slot *grp_start =3D sw_desc->group_head;
+
+	iop_desc_set_zero_sum_src_addr(grp_start, index, addr);
+}
+
+static struct dma_async_tx_descriptor *
+iop_adma_prep_dma_zero_sum(struct dma_chan *chan, unsigned int src_cnt=
,
+	size_t len, u32 *result, int int_en)
+{
+	struct iop_adma_chan *iop_chan =3D to_iop_adma_chan(chan);
+	struct iop_adma_desc_slot *sw_desc, *grp_start;
+	int slot_cnt, slots_per_op;
+
+	if (unlikely(!len))
+		return NULL;
+
+	dev_dbg(iop_chan->device->common.dev, "%s src_cnt: %d len: %u\n",
+		__FUNCTION__, src_cnt, len);
+
+	spin_lock_bh(&iop_chan->lock);
+	slot_cnt =3D iop_chan_zero_sum_slot_count(len, src_cnt, &slots_per_op=
);
+	sw_desc =3D iop_adma_alloc_slots(iop_chan, slot_cnt, slots_per_op);
+	if (sw_desc) {
+		grp_start =3D sw_desc->group_head;
+		iop_desc_init_zero_sum(grp_start, src_cnt, int_en);
+		iop_desc_set_zero_sum_byte_count(grp_start, len);
+		grp_start->xor_check_result =3D result;
+		pr_debug("\t%s: grp_start->xor_check_result: %p\n",
+			__FUNCTION__, grp_start->xor_check_result);
+		sw_desc->unmap_src_cnt =3D src_cnt;
+		sw_desc->unmap_len =3D len;
+		sw_desc->async_tx.tx_set_src =3D iop_adma_xor_zero_sum_set_src;
+	}
+	spin_unlock_bh(&iop_chan->lock);
+
+	return sw_desc ? &sw_desc->async_tx : NULL;
+}
+
+static void iop_adma_dependency_added(struct dma_chan *chan)
+{
+	struct iop_adma_chan *iop_chan =3D to_iop_adma_chan(chan);
+	tasklet_schedule(&iop_chan->irq_tasklet);
+}
+
+static void iop_adma_free_chan_resources(struct dma_chan *chan)
+{
+	struct iop_adma_chan *iop_chan =3D to_iop_adma_chan(chan);
+	struct iop_adma_desc_slot *iter, *_iter;
+	int in_use_descs =3D 0;
+
+	iop_adma_slot_cleanup(iop_chan);
+
+	spin_lock_bh(&iop_chan->lock);
+	list_for_each_entry_safe(iter, _iter, &iop_chan->chain,
+					chain_node) {
+		in_use_descs++;
+		list_del(&iter->chain_node);
+	}
+	list_for_each_entry_safe_reverse(
+		iter, _iter, &iop_chan->all_slots, slot_node) {
+		list_del(&iter->slot_node);
+		kfree(iter);
+		iop_chan->slots_allocated--;
+	}
+	iop_chan->last_used =3D NULL;
+
+	dev_dbg(iop_chan->device->common.dev, "%s slots_allocated %d\n",
+		__FUNCTION__, iop_chan->slots_allocated);
+	spin_unlock_bh(&iop_chan->lock);
+
+	/* one is ok since we left it on there on purpose */
+	if (in_use_descs > 1)
+		printk(KERN_ERR "IOP: Freeing %d in use descriptors!\n",
+			in_use_descs - 1);
+}
+
+/**
+ * iop_adma_is_complete - poll the status of an ADMA transaction
+ * @chan: ADMA channel handle
+ * @cookie: ADMA transaction identifier
+ */
+static enum dma_status iop_adma_is_complete(struct dma_chan *chan,
+					dma_cookie_t cookie,
+					dma_cookie_t *done,
+					dma_cookie_t *used)
+{
+	struct iop_adma_chan *iop_chan =3D to_iop_adma_chan(chan);
+	dma_cookie_t last_used;
+	dma_cookie_t last_complete;
+	enum dma_status ret;
+
+	last_used =3D chan->cookie;
+	last_complete =3D iop_chan->completed_cookie;
+
+	if (done)
+		*done =3D last_complete;
+	if (used)
+		*used =3D last_used;
+
+	ret =3D dma_async_is_complete(cookie, last_complete, last_used);
+	if (ret =3D=3D DMA_SUCCESS)
+		return ret;
+
+	iop_adma_slot_cleanup(iop_chan);
+
+	last_used =3D chan->cookie;
+	last_complete =3D iop_chan->completed_cookie;
+
+	if (done)
+		*done =3D last_complete;
+	if (used)
+		*used =3D last_used;
+
+	return dma_async_is_complete(cookie, last_complete, last_used);
+}
+
+static irqreturn_t iop_adma_eot_handler(int irq, void *data)
+{
+	struct iop_adma_chan *chan =3D data;
+
+	dev_dbg(chan->device->common.dev, "%s\n", __FUNCTION__);
+
+	tasklet_schedule(&chan->irq_tasklet);
+
+	iop_adma_device_clear_eot_status(chan);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t iop_adma_eoc_handler(int irq, void *data)
+{
+	struct iop_adma_chan *chan =3D data;
+
+	dev_dbg(chan->device->common.dev, "%s\n", __FUNCTION__);
+
+	tasklet_schedule(&chan->irq_tasklet);
+
+	iop_adma_device_clear_eoc_status(chan);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t iop_adma_err_handler(int irq, void *data)
+{
+	struct iop_adma_chan *chan =3D data;
+	unsigned long status =3D iop_chan_get_status(chan);
+
+	dev_printk(KERN_ERR, chan->device->common.dev,
+		"error ( %s%s%s%s%s%s%s)\n",
+		iop_is_err_int_parity(status, chan) ? "int_parity " : "",
+		iop_is_err_mcu_abort(status, chan) ? "mcu_abort " : "",
+		iop_is_err_int_tabort(status, chan) ? "int_tabort " : "",
+		iop_is_err_int_mabort(status, chan) ? "int_mabort " : "",
+		iop_is_err_pci_tabort(status, chan) ? "pci_tabort " : "",
+		iop_is_err_pci_mabort(status, chan) ? "pci_mabort " : "",
+		iop_is_err_split_tx(status, chan) ? "split_tx " : "");
+
+	iop_adma_device_clear_err_status(chan);
+
+	BUG();
+
+	return IRQ_HANDLED;
+}
+
+static void iop_adma_issue_pending(struct dma_chan *chan)
+{
+	struct iop_adma_chan *iop_chan =3D to_iop_adma_chan(chan);
+
+	if (iop_chan->pending) {
+		iop_chan->pending =3D 0;
+		iop_chan_append(iop_chan);
+	}
+}
+
+/*
+ * Perform a transaction to verify the HW works.
+ */
+#define IOP_ADMA_TEST_SIZE 2000
+
+static int __devinit iop_adma_memcpy_self_test(struct iop_adma_device =
*device)
+{
+	int i;
+	void *src, *dest;
+	dma_addr_t src_dma, dest_dma;
+	struct dma_chan *dma_chan;
+	dma_cookie_t cookie;
+	struct dma_async_tx_descriptor *tx;
+	int err =3D 0;
+	struct iop_adma_chan *iop_chan;
+
+	dev_dbg(device->common.dev, "%s\n", __FUNCTION__);
+
+	src =3D kzalloc(sizeof(u8) * IOP_ADMA_TEST_SIZE, GFP_KERNEL);
+	if (!src)
+		return -ENOMEM;
+	dest =3D kzalloc(sizeof(u8) * IOP_ADMA_TEST_SIZE, GFP_KERNEL);
+	if (!dest) {
+		kfree(src);
+		return -ENOMEM;
+	}
+
+	/* Fill in src buffer */
+	for (i =3D 0; i < IOP_ADMA_TEST_SIZE; i++)
+		((u8 *) src)[i] =3D (u8)i;
+
+	memset(dest, 0, IOP_ADMA_TEST_SIZE);
+
+	/* Start copy, using first DMA channel */
+	dma_chan =3D container_of(device->common.channels.next,
+				struct dma_chan,
+				device_node);
+	if (iop_adma_alloc_chan_resources(dma_chan) < 1) {
+		err =3D -ENODEV;
+		goto out;
+	}
+
+	tx =3D iop_adma_prep_dma_memcpy(dma_chan, IOP_ADMA_TEST_SIZE, 1);
+	dest_dma =3D dma_map_single(dma_chan->device->dev, dest,
+				IOP_ADMA_TEST_SIZE, DMA_FROM_DEVICE);
+	iop_adma_set_dest(dest_dma, tx, 0);
+	src_dma =3D dma_map_single(dma_chan->device->dev, src,
+				IOP_ADMA_TEST_SIZE, DMA_TO_DEVICE);
+	iop_adma_memcpy_set_src(src_dma, tx, 0);
+
+	cookie =3D iop_adma_tx_submit(tx);
+	iop_adma_issue_pending(dma_chan);
+	async_tx_ack(tx);
+	msleep(1);
+
+	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) !=3D
+			DMA_SUCCESS) {
+		dev_printk(KERN_ERR, dma_chan->device->dev,
+			"Self-test copy timed out, disabling\n");
+		err =3D -ENODEV;
+		goto free_resources;
+	}
+
+	iop_chan =3D to_iop_adma_chan(dma_chan);
+	dma_sync_single_for_cpu(&iop_chan->device->pdev->dev, dest_dma,
+		IOP_ADMA_TEST_SIZE, DMA_FROM_DEVICE);
+	if (memcmp(src, dest, IOP_ADMA_TEST_SIZE)) {
+		dev_printk(KERN_ERR, dma_chan->device->dev,
+			"Self-test copy failed compare, disabling\n");
+		err =3D -ENODEV;
+		goto free_resources;
+	}
+
+free_resources:
+	iop_adma_free_chan_resources(dma_chan);
+out:
+	kfree(src);
+	kfree(dest);
+	return err;
+}
+
+#define IOP_ADMA_NUM_SRC_TEST 4 /* must be <=3D 15 */
+static int __devinit
+iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
+{
+	int i, src_idx;
+	struct page *dest;
+	struct page *xor_srcs[IOP_ADMA_NUM_SRC_TEST];
+	struct page *zero_sum_srcs[IOP_ADMA_NUM_SRC_TEST + 1];
+	dma_addr_t dma_addr, dest_dma;
+	struct dma_async_tx_descriptor *tx;
+	struct dma_chan *dma_chan;
+	dma_cookie_t cookie;
+	u8 cmp_byte =3D 0;
+	u32 cmp_word;
+	u32 zero_sum_result;
+	int err =3D 0;
+	struct iop_adma_chan *iop_chan;
+
+	dev_dbg(device->common.dev, "%s\n", __FUNCTION__);
+
+	for (src_idx =3D 0; src_idx < IOP_ADMA_NUM_SRC_TEST; src_idx++) {
+		xor_srcs[src_idx] =3D alloc_page(GFP_KERNEL);
+		if (!xor_srcs[src_idx])
+			while (src_idx--) {
+				__free_page(xor_srcs[src_idx]);
+				return -ENOMEM;
+			}
+	}
+
+	dest =3D alloc_page(GFP_KERNEL);
+	if (!dest)
+		while (src_idx--) {
+			__free_page(xor_srcs[src_idx]);
+			return -ENOMEM;
+		}
+
+	/* Fill in src buffers */
+	for (src_idx =3D 0; src_idx < IOP_ADMA_NUM_SRC_TEST; src_idx++) {
+		u8 *ptr =3D page_address(xor_srcs[src_idx]);
+		for (i =3D 0; i < PAGE_SIZE; i++)
+			ptr[i] =3D (1 << src_idx);
+	}
+
+	for (src_idx =3D 0; src_idx < IOP_ADMA_NUM_SRC_TEST; src_idx++)
+		cmp_byte ^=3D (u8) (1 << src_idx);
+
+	cmp_word =3D (cmp_byte << 24) | (cmp_byte << 16) |
+			(cmp_byte << 8) | cmp_byte;
+
+	memset(page_address(dest), 0, PAGE_SIZE);
+
+	dma_chan =3D container_of(device->common.channels.next,
+				struct dma_chan,
+				device_node);
+	if (iop_adma_alloc_chan_resources(dma_chan) < 1) {
+		err =3D -ENODEV;
+		goto out;
+	}
+
+	/* test xor */
+	tx =3D iop_adma_prep_dma_xor(dma_chan, IOP_ADMA_NUM_SRC_TEST,
+				PAGE_SIZE, 1);
+	dest_dma =3D dma_map_page(dma_chan->device->dev, dest, 0,
+				PAGE_SIZE, DMA_FROM_DEVICE);
+	iop_adma_set_dest(dest_dma, tx, 0);
+
+	for (i =3D 0; i < IOP_ADMA_NUM_SRC_TEST; i++) {
+		dma_addr =3D dma_map_page(dma_chan->device->dev, xor_srcs[i], 0,
+			PAGE_SIZE, DMA_TO_DEVICE);
+		iop_adma_xor_set_src(dma_addr, tx, i);
+	}
+
+	cookie =3D iop_adma_tx_submit(tx);
+	iop_adma_issue_pending(dma_chan);
+	async_tx_ack(tx);
+	msleep(8);
+
+	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) !=3D
+		DMA_SUCCESS) {
+		dev_printk(KERN_ERR, dma_chan->device->dev,
+			"Self-test xor timed out, disabling\n");
+		err =3D -ENODEV;
+		goto free_resources;
+	}
+
+	iop_chan =3D to_iop_adma_chan(dma_chan);
+	dma_sync_single_for_cpu(&iop_chan->device->pdev->dev, dest_dma,
+		PAGE_SIZE, DMA_FROM_DEVICE);
+	for (i =3D 0; i < (PAGE_SIZE / sizeof(u32)); i++) {
+		u32 *ptr =3D page_address(dest);
+		if (ptr[i] !=3D cmp_word) {
+			dev_printk(KERN_ERR, dma_chan->device->dev,
+				"Self-test xor failed compare, disabling\n");
+			err =3D -ENODEV;
+			goto free_resources;
+		}
+	}
+	dma_sync_single_for_device(&iop_chan->device->pdev->dev, dest_dma,
+		PAGE_SIZE, DMA_TO_DEVICE);
+
+	/* skip zero sum if the capability is not present */
+	if (!dma_has_cap(DMA_ZERO_SUM, dma_chan->device->cap_mask))
+		goto free_resources;
+
+	/* zero sum the sources with the destintation page */
+	for (i =3D 0; i < IOP_ADMA_NUM_SRC_TEST; i++)
+		zero_sum_srcs[i] =3D xor_srcs[i];
+	zero_sum_srcs[i] =3D dest;
+
+	zero_sum_result =3D 1;
+
+	tx =3D iop_adma_prep_dma_zero_sum(dma_chan, IOP_ADMA_NUM_SRC_TEST + 1=
,
+		PAGE_SIZE, &zero_sum_result, 1);
+	for (i =3D 0; i < IOP_ADMA_NUM_SRC_TEST + 1; i++) {
+		dma_addr =3D dma_map_page(dma_chan->device->dev, zero_sum_srcs[i],
+			0, PAGE_SIZE, DMA_TO_DEVICE);
+		iop_adma_xor_zero_sum_set_src(dma_addr, tx, i);
+	}
+
+	cookie =3D iop_adma_tx_submit(tx);
+	iop_adma_issue_pending(dma_chan);
+	async_tx_ack(tx);
+	msleep(8);
+
+	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) !=3D DMA_SUCCE=
SS) {
+		dev_printk(KERN_ERR, dma_chan->device->dev,
+			"Self-test zero sum timed out, disabling\n");
+		err =3D -ENODEV;
+		goto free_resources;
+	}
+
+	if (zero_sum_result !=3D 0) {
+		dev_printk(KERN_ERR, dma_chan->device->dev,
+			"Self-test zero sum failed compare, disabling\n");
+		err =3D -ENODEV;
+		goto free_resources;
+	}
+
+	/* test memset */
+	tx =3D iop_adma_prep_dma_memset(dma_chan, 0, PAGE_SIZE, 1);
+	dma_addr =3D dma_map_page(dma_chan->device->dev, dest, 0,
+			PAGE_SIZE, DMA_FROM_DEVICE);
+	iop_adma_set_dest(dma_addr, tx, 0);
+
+	cookie =3D iop_adma_tx_submit(tx);
+	iop_adma_issue_pending(dma_chan);
+	async_tx_ack(tx);
+	msleep(8);
+
+	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) !=3D DMA_SUCCE=
SS) {
+		dev_printk(KERN_ERR, dma_chan->device->dev,
+			"Self-test memset timed out, disabling\n");
+		err =3D -ENODEV;
+		goto free_resources;
+	}
+
+	for (i =3D 0; i < PAGE_SIZE/sizeof(u32); i++) {
+		u32 *ptr =3D page_address(dest);
+		if (ptr[i]) {
+			dev_printk(KERN_ERR, dma_chan->device->dev,
+				"Self-test memset failed compare, disabling\n");
+			err =3D -ENODEV;
+			goto free_resources;
+		}
+	}
+
+	/* test for non-zero parity sum */
+	zero_sum_result =3D 0;
+	tx =3D iop_adma_prep_dma_zero_sum(dma_chan, IOP_ADMA_NUM_SRC_TEST + 1=
,
+		PAGE_SIZE, &zero_sum_result, 1);
+	for (i =3D 0; i < IOP_ADMA_NUM_SRC_TEST + 1; i++) {
+		dma_addr =3D dma_map_page(dma_chan->device->dev, zero_sum_srcs[i],
+			0, PAGE_SIZE, DMA_TO_DEVICE);
+		iop_adma_xor_zero_sum_set_src(dma_addr, tx, i);
+	}
+
+	cookie =3D iop_adma_tx_submit(tx);
+	iop_adma_issue_pending(dma_chan);
+	async_tx_ack(tx);
+	msleep(8);
+
+	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) !=3D DMA_SUCCE=
SS) {
+		dev_printk(KERN_ERR, dma_chan->device->dev,
+			"Self-test non-zero sum timed out, disabling\n");
+		err =3D -ENODEV;
+		goto free_resources;
+	}
+
+	if (zero_sum_result !=3D 1) {
+		dev_printk(KERN_ERR, dma_chan->device->dev,
+			"Self-test non-zero sum failed compare, disabling\n");
+		err =3D -ENODEV;
+		goto free_resources;
+	}
+
+free_resources:
+	iop_adma_free_chan_resources(dma_chan);
+out:
+	src_idx =3D IOP_ADMA_NUM_SRC_TEST;
+	while (src_idx--)
+		__free_page(xor_srcs[src_idx]);
+	__free_page(dest);
+	return err;
+}
+
+static int __devexit iop_adma_remove(struct platform_device *dev)
+{
+	struct iop_adma_device *device =3D platform_get_drvdata(dev);
+	struct dma_chan *chan, *_chan;
+	struct iop_adma_chan *iop_chan;
+	int i;
+	struct iop_adma_platform_data *plat_data =3D dev->dev.platform_data;
+
+	dma_async_device_unregister(&device->common);
+
+	for (i =3D 0; i < 3; i++) {
+		unsigned int irq;
+		irq =3D platform_get_irq(dev, i);
+		free_irq(irq, device);
+	}
+
+	dma_free_coherent(&dev->dev, plat_data->pool_size,
+			device->dma_desc_pool_virt, device->dma_desc_pool);
+
+	do {
+		struct resource *res;
+		res =3D platform_get_resource(dev, IORESOURCE_MEM, 0);
+		release_mem_region(res->start, res->end - res->start);
+	} while (0);
+
+	list_for_each_entry_safe(chan, _chan, &device->common.channels,
+				device_node) {
+		iop_chan =3D to_iop_adma_chan(chan);
+		list_del(&chan->device_node);
+		kfree(iop_chan);
+	}
+	kfree(device);
+
+	return 0;
+}
+
+static int __devinit iop_adma_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	int ret =3D 0, i;
+	struct iop_adma_device *adev;
+	struct iop_adma_chan *iop_chan;
+	struct dma_device *dma_dev;
+	struct iop_adma_platform_data *plat_data =3D pdev->dev.platform_data;
+
+	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	if (!devm_request_mem_region(&pdev->dev, res->start,
+				res->end - res->start, pdev->name))
+		return -EBUSY;
+
+	adev =3D kzalloc(sizeof(*adev), GFP_KERNEL);
+	if (!adev)
+		return -ENOMEM;
+	dma_dev =3D &adev->common;
+
+	/* allocate coherent memory for hardware descriptors
+	 * note: writecombine gives slightly better performance, but
+	 * requires that we explicitly flush the writes
+	 */
+	if ((adev->dma_desc_pool_virt =3D dma_alloc_writecombine(&pdev->dev,
+					plat_data->pool_size,
+					&adev->dma_desc_pool,
+					GFP_KERNEL)) =3D=3D NULL) {
+		ret =3D -ENOMEM;
+		goto err_free_adev;
+	}
+
+	dev_dbg(&pdev->dev, "%s: allocted descriptor pool virt %p phys %p\n",
+		__FUNCTION__, adev->dma_desc_pool_virt,
+		(void *) adev->dma_desc_pool);
+
+	adev->id =3D plat_data->hw_id;
+
+	/* discover transaction capabilites from the platform data */
+	dma_dev->cap_mask =3D plat_data->cap_mask;
+
+	adev->pdev =3D pdev;
+	platform_set_drvdata(pdev, adev);
+
+	INIT_LIST_HEAD(&dma_dev->channels);
+
+	/* set base routines */
+	dma_dev->device_alloc_chan_resources =3D iop_adma_alloc_chan_resource=
s;
+	dma_dev->device_free_chan_resources =3D iop_adma_free_chan_resources;
+	dma_dev->device_is_tx_complete =3D iop_adma_is_complete;
+	dma_dev->device_issue_pending =3D iop_adma_issue_pending;
+	dma_dev->device_dependency_added =3D iop_adma_dependency_added;
+	dma_dev->dev =3D &pdev->dev;
+
+	/* set prep routines based on capability */
+	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask))
+		dma_dev->device_prep_dma_memcpy =3D iop_adma_prep_dma_memcpy;
+	if (dma_has_cap(DMA_MEMSET, dma_dev->cap_mask))
+		dma_dev->device_prep_dma_memset =3D iop_adma_prep_dma_memset;
+	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)) {
+		dma_dev->max_xor =3D iop_adma_get_max_xor();
+		dma_dev->device_prep_dma_xor =3D iop_adma_prep_dma_xor;
+	}
+	if (dma_has_cap(DMA_ZERO_SUM, dma_dev->cap_mask))
+		dma_dev->device_prep_dma_zero_sum =3D
+			iop_adma_prep_dma_zero_sum;
+	if (dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask))
+		dma_dev->device_prep_dma_interrupt =3D
+			iop_adma_prep_dma_interrupt;
+
+	iop_chan =3D kzalloc(sizeof(*iop_chan), GFP_KERNEL);
+	if (!iop_chan) {
+		ret =3D -ENOMEM;
+		goto err_free_dma;
+	}
+	iop_chan->device =3D adev;
+
+	iop_chan->mmr_base =3D devm_ioremap(&pdev->dev, res->start,
+					res->end - res->start);
+	if (!iop_chan->mmr_base) {
+		ret =3D -ENOMEM;
+		goto err_free_iop_chan;
+	}
+	tasklet_init(&iop_chan->irq_tasklet, iop_adma_tasklet, (unsigned long=
)
+		iop_chan);
+
+	/* clear errors before enabling interrupts */
+	iop_adma_device_clear_err_status(iop_chan);
+
+	for (i =3D 0; i < 3; i++) {
+		irq_handler_t handler[] =3D { iop_adma_eot_handler,
+					iop_adma_eoc_handler,
+					iop_adma_err_handler };
+		int irq =3D platform_get_irq(pdev, i);
+		if (irq < 0) {
+			ret =3D -ENXIO;
+			goto err_free_iop_chan;
+		} else {
+			ret =3D devm_request_irq(&pdev->dev, irq,
+					handler[i], 0, pdev->name, iop_chan);
+			if (ret)
+				goto err_free_iop_chan;
+		}
+	}
+
+	spin_lock_init(&iop_chan->lock);
+	init_timer(&iop_chan->cleanup_watchdog);
+	iop_chan->cleanup_watchdog.data =3D (unsigned long) iop_chan;
+	iop_chan->cleanup_watchdog.function =3D iop_adma_tasklet;
+	INIT_LIST_HEAD(&iop_chan->chain);
+	INIT_LIST_HEAD(&iop_chan->all_slots);
+	INIT_RCU_HEAD(&iop_chan->common.rcu);
+	iop_chan->common.device =3D dma_dev;
+	list_add_tail(&iop_chan->common.device_node, &dma_dev->channels);
+
+	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask)) {
+		ret =3D iop_adma_memcpy_self_test(adev);
+		dev_dbg(&pdev->dev, "memcpy self test returned %d\n", ret);
+		if (ret)
+			goto err_free_iop_chan;
+	}
+
+	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask) ||
+		dma_has_cap(DMA_MEMSET, dma_dev->cap_mask)) {
+		ret =3D iop_adma_xor_zero_sum_self_test(adev);
+		dev_dbg(&pdev->dev, "xor self test returned %d\n", ret);
+		if (ret)
+			goto err_free_iop_chan;
+	}
+
+	dev_printk(KERN_INFO, &pdev->dev, "Intel(R) IOP: "
+	  "( %s%s%s%s%s%s%s%s%s%s)\n",
+	  dma_has_cap(DMA_PQ_XOR, dma_dev->cap_mask) ? "pq_xor " : "",
+	  dma_has_cap(DMA_PQ_UPDATE, dma_dev->cap_mask) ? "pq_update " : "",
+	  dma_has_cap(DMA_PQ_ZERO_SUM, dma_dev->cap_mask) ? "pq_zero_sum " : =
"",
+	  dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
+	  dma_has_cap(DMA_DUAL_XOR, dma_dev->cap_mask) ? "dual_xor " : "",
+	  dma_has_cap(DMA_ZERO_SUM, dma_dev->cap_mask) ? "xor_zero_sum " : ""=
,
+	  dma_has_cap(DMA_MEMSET, dma_dev->cap_mask)  ? "fill " : "",
+	  dma_has_cap(DMA_MEMCPY_CRC32C, dma_dev->cap_mask) ? "cpy+crc " : ""=
,
+	  dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask) ? "cpy " : "",
+	  dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask) ? "intr " : "");
+
+	dma_async_device_register(dma_dev);
+	goto out;
+
+ err_free_iop_chan:
+	kfree(iop_chan);
+ err_free_dma:
+	dma_free_coherent(&adev->pdev->dev, plat_data->pool_size,
+			adev->dma_desc_pool_virt, adev->dma_desc_pool);
+ err_free_adev:
+	kfree(adev);
+ out:
+	return ret;
+}
+
+static void iop_chan_start_null_memcpy(struct iop_adma_chan *iop_chan)
+{
+	struct iop_adma_desc_slot *sw_desc, *grp_start;
+	dma_cookie_t cookie;
+	int slot_cnt, slots_per_op;
+
+	dev_dbg(iop_chan->device->common.dev, "%s\n", __FUNCTION__);
+
+	spin_lock_bh(&iop_chan->lock);
+	slot_cnt =3D iop_chan_memcpy_slot_count(0, &slots_per_op);
+	sw_desc =3D iop_adma_alloc_slots(iop_chan, slot_cnt, slots_per_op);
+	if (sw_desc) {
+		grp_start =3D sw_desc->group_head;
+
+		list_splice_init(&sw_desc->group_list, &iop_chan->chain);
+		sw_desc->async_tx.ack =3D 1;
+		iop_desc_init_memcpy(grp_start, 0);
+		iop_desc_set_byte_count(grp_start, iop_chan, 0);
+		iop_desc_set_dest_addr(grp_start, iop_chan, 0);
+		iop_desc_set_memcpy_src_addr(grp_start, 0);
+
+		cookie =3D iop_chan->common.cookie;
+		cookie++;
+		if (cookie <=3D 1)
+			cookie =3D 2;
+
+		/* initialize the completed cookie to be less than
+		 * the most recently used cookie
+		 */
+		iop_chan->completed_cookie =3D cookie - 1;
+		iop_chan->common.cookie =3D sw_desc->async_tx.cookie =3D cookie;
+
+		/* channel should not be busy */
+		BUG_ON(iop_chan_is_busy(iop_chan));
+
+		/* clear any prior error-status bits */
+		iop_adma_device_clear_err_status(iop_chan);
+
+		/* disable operation */
+		iop_chan_disable(iop_chan);
+
+		/* set the descriptor address */
+		iop_chan_set_next_descriptor(iop_chan, sw_desc->phys);
+
+		/* 1/ don't add pre-chained descriptors
+		 * 2/ dummy read to flush next_desc write
+		 */
+		BUG_ON(iop_desc_get_next_desc(sw_desc));
+
+		/* run the descriptor */
+		iop_chan_enable(iop_chan);
+	} else
+		dev_printk(KERN_ERR, iop_chan->device->common.dev,
+			 "failed to allocate null descriptor\n");
+	spin_unlock_bh(&iop_chan->lock);
+}
+
+static void iop_chan_start_null_xor(struct iop_adma_chan *iop_chan)
+{
+	struct iop_adma_desc_slot *sw_desc, *grp_start;
+	dma_cookie_t cookie;
+	int slot_cnt, slots_per_op;
+
+	dev_dbg(iop_chan->device->common.dev, "%s\n", __FUNCTION__);
+
+	spin_lock_bh(&iop_chan->lock);
+	slot_cnt =3D iop_chan_xor_slot_count(0, 2, &slots_per_op);
+	sw_desc =3D iop_adma_alloc_slots(iop_chan, slot_cnt, slots_per_op);
+	if (sw_desc) {
+		grp_start =3D sw_desc->group_head;
+		list_splice_init(&sw_desc->group_list, &iop_chan->chain);
+		sw_desc->async_tx.ack =3D 1;
+		iop_desc_init_null_xor(grp_start, 2, 0);
+		iop_desc_set_byte_count(grp_start, iop_chan, 0);
+		iop_desc_set_dest_addr(grp_start, iop_chan, 0);
+		iop_desc_set_xor_src_addr(grp_start, 0, 0);
+		iop_desc_set_xor_src_addr(grp_start, 1, 0);
+
+		cookie =3D iop_chan->common.cookie;
+		cookie++;
+		if (cookie <=3D 1)
+			cookie =3D 2;
+
+		/* initialize the completed cookie to be less than
+		 * the most recently used cookie
+		 */
+		iop_chan->completed_cookie =3D cookie - 1;
+		iop_chan->common.cookie =3D sw_desc->async_tx.cookie =3D cookie;
+
+		/* channel should not be busy */
+		BUG_ON(iop_chan_is_busy(iop_chan));
+
+		/* clear any prior error-status bits */
+		iop_adma_device_clear_err_status(iop_chan);
+
+		/* disable operation */
+		iop_chan_disable(iop_chan);
+
+		/* set the descriptor address */
+		iop_chan_set_next_descriptor(iop_chan, sw_desc->phys);
+
+		/* 1/ don't add pre-chained descriptors
+		 * 2/ dummy read to flush next_desc write
+		 */
+		BUG_ON(iop_desc_get_next_desc(sw_desc));
+
+		/* run the descriptor */
+		iop_chan_enable(iop_chan);
+	} else
+		dev_printk(KERN_ERR, iop_chan->device->common.dev,
+			"failed to allocate null descriptor\n");
+	spin_unlock_bh(&iop_chan->lock);
+}
+
+static struct platform_driver iop_adma_driver =3D {
+	.probe		=3D iop_adma_probe,
+	.remove		=3D iop_adma_remove,
+	.driver		=3D {
+		.owner	=3D THIS_MODULE,
+		.name	=3D "iop-adma",
+	},
+};
+
+static int __init iop_adma_init (void)
+{
+	/* it's currently unsafe to unload this module */
+	/* if forced, worst case is that rmmod hangs */
+	__unsafe(THIS_MODULE);
+
+	return platform_driver_register(&iop_adma_driver);
+}
+
+static void __exit iop_adma_exit (void)
+{
+	platform_driver_unregister(&iop_adma_driver);
+	return;
+}
+
+module_init(iop_adma_init);
+module_exit(iop_adma_exit);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("IOP ADMA Engine Driver");
+MODULE_LICENSE("GPL");
diff --git a/include/asm-arm/hardware/iop_adma.h b/include/asm-arm/hard=
ware/iop_adma.h
new file mode 100644
index 0000000..362d832
--- /dev/null
+++ b/include/asm-arm/hardware/iop_adma.h
@@ -0,0 +1,120 @@
+/*
+ * Copyright =C2=A9 2006, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITH=
OUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY =
or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licen=
se for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License a=
long with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+#ifndef IOP_ADMA_H
+#define IOP_ADMA_H
+#include <linux/types.h>
+#include <linux/dmaengine.h>
+#include <linux/interrupt.h>
+
+#define IOP_ADMA_SLOT_SIZE 32
+#define IOP_ADMA_THRESHOLD 4
+
+/**
+ * struct iop_adma_device - internal representation of an ADMA device
+ * @pdev: Platform device
+ * @id: HW ADMA Device selector
+ * @dma_desc_pool: base of DMA descriptor region (DMA address)
+ * @dma_desc_pool_virt: base of DMA descriptor region (CPU address)
+ * @common: embedded struct dma_device
+ */
+struct iop_adma_device {
+	struct platform_device *pdev;
+	int id;
+	dma_addr_t dma_desc_pool;
+	void *dma_desc_pool_virt;
+	struct dma_device common;
+};
+
+/**
+ * struct iop_adma_chan - internal representation of an ADMA device
+ * @pending: allows batching of hardware operations
+ * @completed_cookie: identifier for the most recently completed opera=
tion
+ * @lock: serializes enqueue/dequeue operations to the slot pool
+ * @mmr_base: memory mapped register base
+ * @chain: device chain view of the descriptors
+ * @device: parent device
+ * @common: common dmaengine channel object members
+ * @last_used: place holder for allocation to continue from where it l=
eft off
+ * @all_slots: complete domain of slots usable by the channel
+ * @cleanup_watchdog: workaround missed interrupts on iop3xx
+ * @slots_allocated: records the actual size of the descriptor slot po=
ol
+ * @irq_tasklet: bottom half where iop_adma_slot_cleanup runs
+ */
+struct iop_adma_chan {
+	int pending;
+	dma_cookie_t completed_cookie;
+	spinlock_t lock; /* protects the descriptor slot pool */
+	void __iomem *mmr_base;
+	struct list_head chain;
+	struct iop_adma_device *device;
+	struct dma_chan common;
+	struct iop_adma_desc_slot *last_used;
+	struct list_head all_slots;
+	struct timer_list cleanup_watchdog;
+	int slots_allocated;
+	struct tasklet_struct irq_tasklet;
+};
+
+/**
+ * struct iop_adma_desc_slot - IOP-ADMA software descriptor
+ * @slot_node: node on the iop_adma_chan.all_slots list
+ * @chain_node: node on the op_adma_chan.chain list
+ * @hw_desc: virtual address of the hardware descriptor chain
+ * @phys: hardware address of the hardware descriptor chain
+ * @group_head: first operation in a transaction
+ * @slot_cnt: total slots used in an transaction (group of operations)
+ * @slots_per_op: number of slots per operation
+ * @idx: pool index
+ * @unmap_src_cnt: number of xor sources
+ * @unmap_len: transaction bytecount
+ * @async_tx: support for the async_tx api
+ * @group_list: list of slots that make up a multi-descriptor transact=
ion
+ *	for example transfer lengths larger than the supported hw max
+ * @xor_check_result: result of zero sum
+ * @crc32_result: result crc calculation
+ */
+struct iop_adma_desc_slot {
+	struct list_head slot_node;
+	struct list_head chain_node;
+	void *hw_desc;
+	dma_addr_t phys;
+	struct iop_adma_desc_slot *group_head;
+	u16 slot_cnt;
+	u16 slots_per_op;
+	u16 idx;
+	u16 unmap_src_cnt;
+	size_t unmap_len;
+	struct dma_async_tx_descriptor async_tx;
+	struct list_head group_list;
+	union {
+		u32 *xor_check_result;
+		u32 *crc32_result;
+	};
+};
+
+struct iop_adma_platform_data {
+	int hw_id;
+	dma_cap_mask_t cap_mask;
+	size_t pool_size;
+};
+
+#define to_iop_sw_desc(addr_hw_desc) \
+	container_of(addr_hw_desc, struct iop_adma_desc_slot, hw_desc)
+#define iop_hw_desc_slot_idx(hw_desc, idx) \
+	( (void *) (((unsigned long) hw_desc) + ((idx) << 5)) )
+#endif
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
