From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 08/18] ioat: add 'ioat' sysfs attributes
Date: Thu, 03 Sep 2009 23:45:15 -0700
Message-ID: <20090904064515.7141.3535.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932831AbZIDGsi@vger.kernel.org>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

Export driver attributes for diagnostic purposes:
'ring_size': total number of descriptors available to the engine
'ring_active': number of descriptors in-flight
'capabilities': supported operation types for this channel
'version': Intel(R) QuickData specfication revision

This also allows some chattiness to be removed from the driver startup
as this information is now available via sysfs.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma.c    |  120 +++++++++++++++++++++++++++++++++++++++++++--
 drivers/dma/ioat/dma.h    |   12 +++++
 drivers/dma/ioat/dma_v2.c |   33 ++++++++++++
 drivers/dma/ioat/dma_v2.h |    1 
 drivers/dma/ioat/dma_v3.c |    3 +
 drivers/dma/ioat/pci.c    |    3 +
 6 files changed, 166 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 92c2778..2eb1fac 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -263,6 +263,7 @@ static dma_cookie_t ioat1_tx_submit(struct dma_async_tx_descriptor *tx)
 	if (!test_and_set_bit(IOAT_COMPLETION_PENDING, &chan->state))
 		mod_timer(&chan->timer, jiffies + COMPLETION_TIMEOUT);
 
+	ioat->active += desc->hw->tx_cnt;
 	ioat->pending += desc->hw->tx_cnt;
 	if (ioat->pending >= ioat_pending_level)
 		__ioat1_dma_memcpy_issue_pending(ioat);
@@ -612,6 +613,7 @@ static void __cleanup(struct ioat_dma_chan *ioat, unsigned long phys_complete)
 			chan->completed_cookie = tx->cookie;
 			tx->cookie = 0;
 			ioat_dma_unmap(chan, tx->flags, desc->len, desc->hw);
+			ioat->active -= desc->hw->tx_cnt;
 			if (tx->callback) {
 				tx->callback(tx->callback_param);
 				tx->callback = NULL;
@@ -1029,13 +1031,8 @@ int __devinit ioat_probe(struct ioatdma_device *device)
 	dma_cap_set(DMA_MEMCPY, dma->cap_mask);
 	dma->dev = &pdev->dev;
 
-	dev_err(dev, "Intel(R) I/OAT DMA Engine found,"
-		" %d channels, device version 0x%02x, driver version %s\n",
-		dma->chancnt, device->version, IOAT_DMA_VERSION);
-
 	if (!dma->chancnt) {
-		dev_err(dev, "Intel(R) I/OAT DMA Engine problem found: "
-			"zero channels detected\n");
+		dev_err(dev, "zero channels detected\n");
 		goto err_setup_interrupts;
 	}
 
@@ -1086,6 +1083,113 @@ static void ioat1_intr_quirk(struct ioatdma_device *device)
 	pci_write_config_dword(pdev, IOAT_PCI_DMACTRL_OFFSET, dmactrl);
 }
 
+static ssize_t ring_size_show(struct dma_chan *c, char *page)
+{
+	struct ioat_dma_chan *ioat = to_ioat_chan(c);
+
+	return sprintf(page, "%d\n", ioat->desccount);
+}
+static struct ioat_sysfs_entry ring_size_attr = __ATTR_RO(ring_size);
+
+static ssize_t ring_active_show(struct dma_chan *c, char *page)
+{
+	struct ioat_dma_chan *ioat = to_ioat_chan(c);
+
+	return sprintf(page, "%d\n", ioat->active);
+}
+static struct ioat_sysfs_entry ring_active_attr = __ATTR_RO(ring_active);
+
+static ssize_t cap_show(struct dma_chan *c, char *page)
+{
+	struct dma_device *dma = c->device;
+
+	return sprintf(page, "copy%s%s%s%s%s%s\n",
+		       dma_has_cap(DMA_PQ, dma->cap_mask) ? " pq" : "",
+		       dma_has_cap(DMA_PQ_VAL, dma->cap_mask) ? " pq_val" : "",
+		       dma_has_cap(DMA_XOR, dma->cap_mask) ? " xor" : "",
+		       dma_has_cap(DMA_XOR_VAL, dma->cap_mask) ? " xor_val" : "",
+		       dma_has_cap(DMA_MEMSET, dma->cap_mask)  ? " fill" : "",
+		       dma_has_cap(DMA_INTERRUPT, dma->cap_mask) ? " intr" : "");
+
+}
+struct ioat_sysfs_entry ioat_cap_attr = __ATTR_RO(cap);
+
+static ssize_t version_show(struct dma_chan *c, char *page)
+{
+	struct dma_device *dma = c->device;
+	struct ioatdma_device *device = to_ioatdma_device(dma);
+
+	return sprintf(page, "%d.%d\n",
+		       device->version >> 4, device->version & 0xf);
+}
+struct ioat_sysfs_entry ioat_version_attr = __ATTR_RO(version);
+
+static struct attribute *ioat1_attrs[] = {
+	&ring_size_attr.attr,
+	&ring_active_attr.attr,
+	&ioat_cap_attr.attr,
+	&ioat_version_attr.attr,
+	NULL,
+};
+
+static ssize_t
+ioat_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
+{
+	struct ioat_sysfs_entry *entry;
+	struct ioat_chan_common *chan;
+
+	entry = container_of(attr, struct ioat_sysfs_entry, attr);
+	chan = container_of(kobj, struct ioat_chan_common, kobj);
+
+	if (!entry->show)
+		return -EIO;
+	return entry->show(&chan->common, page);
+}
+
+struct sysfs_ops ioat_sysfs_ops = {
+	.show	= ioat_attr_show,
+};
+
+static struct kobj_type ioat1_ktype = {
+	.sysfs_ops = &ioat_sysfs_ops,
+	.default_attrs = ioat1_attrs,
+};
+
+void ioat_kobject_add(struct ioatdma_device *device, struct kobj_type *type)
+{
+	struct dma_device *dma = &device->common;
+	struct dma_chan *c;
+
+	list_for_each_entry(c, &dma->channels, device_node) {
+		struct ioat_chan_common *chan = to_chan_common(c);
+		struct kobject *parent = &c->dev->device.kobj;
+		int err;
+
+		err = kobject_init_and_add(&chan->kobj, type, parent, "quickdata");
+		if (err) {
+			dev_warn(to_dev(chan),
+				 "sysfs init error (%d), continuing...\n", err);
+			kobject_put(&chan->kobj);
+			set_bit(IOAT_KOBJ_INIT_FAIL, &chan->state);
+		}
+	}
+}
+
+void ioat_kobject_del(struct ioatdma_device *device)
+{
+	struct dma_device *dma = &device->common;
+	struct dma_chan *c;
+
+	list_for_each_entry(c, &dma->channels, device_node) {
+		struct ioat_chan_common *chan = to_chan_common(c);
+
+		if (!test_bit(IOAT_KOBJ_INIT_FAIL, &chan->state)) {
+			kobject_del(&chan->kobj);
+			kobject_put(&chan->kobj);
+		}
+	}
+}
+
 int __devinit ioat1_dma_probe(struct ioatdma_device *device, int dca)
 {
 	struct pci_dev *pdev = device->pdev;
@@ -1108,6 +1212,8 @@ int __devinit ioat1_dma_probe(struct ioatdma_device *device, int dca)
 	err = ioat_register(device);
 	if (err)
 		return err;
+	ioat_kobject_add(device, &ioat1_ktype);
+
 	if (dca)
 		device->dca = ioat_dca_init(pdev, device->reg_base);
 
@@ -1120,6 +1226,8 @@ void __devexit ioat_dma_remove(struct ioatdma_device *device)
 
 	ioat_disable_interrupts(device);
 
+	ioat_kobject_del(device);
+
 	dma_async_device_unregister(dma);
 
 	pci_pool_destroy(device->dma_pool);
diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 5999c12..6c798f3 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -92,6 +92,7 @@ struct ioat_chan_common {
 	#define IOAT_COMPLETION_PENDING 0
 	#define IOAT_COMPLETION_ACK 1
 	#define IOAT_RESET_PENDING 2
+	#define IOAT_KOBJ_INIT_FAIL 3
 	struct timer_list timer;
 	#define COMPLETION_TIMEOUT msecs_to_jiffies(100)
 	#define IDLE_TIMEOUT msecs_to_jiffies(2000)
@@ -100,8 +101,13 @@ struct ioat_chan_common {
 	dma_addr_t completion_dma;
 	u64 *completion;
 	struct tasklet_struct cleanup_task;
+	struct kobject kobj;
 };
 
+struct ioat_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(struct dma_chan *, char *);
+};
 
 /**
  * struct ioat_dma_chan - internal representation of a DMA channel
@@ -117,6 +123,7 @@ struct ioat_dma_chan {
 
 	int pending;
 	u16 desccount;
+	u16 active;
 };
 
 static inline struct ioat_chan_common *to_chan_common(struct dma_chan *c)
@@ -320,4 +327,9 @@ void ioat_dma_unmap(struct ioat_chan_common *chan, enum dma_ctrl_flags flags,
 		    size_t len, struct ioat_dma_descriptor *hw);
 bool ioat_cleanup_preamble(struct ioat_chan_common *chan,
 			   unsigned long *phys_complete);
+void ioat_kobject_add(struct ioatdma_device *device, struct kobj_type *type);
+void ioat_kobject_del(struct ioatdma_device *device);
+extern struct sysfs_ops ioat_sysfs_ops;
+extern struct ioat_sysfs_entry ioat_version_attr;
+extern struct ioat_sysfs_entry ioat_cap_attr;
 #endif /* IOATDMA_H */
diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 5a736a3..7408bef 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -796,6 +796,36 @@ ioat2_is_complete(struct dma_chan *c, dma_cookie_t cookie,
 	return ioat_is_complete(c, cookie, done, used);
 }
 
+static ssize_t ring_size_show(struct dma_chan *c, char *page)
+{
+	struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
+
+	return sprintf(page, "%d\n", (1 << ioat->alloc_order) & ~1);
+}
+static struct ioat_sysfs_entry ring_size_attr = __ATTR_RO(ring_size);
+
+static ssize_t ring_active_show(struct dma_chan *c, char *page)
+{
+	struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
+
+	/* ...taken outside the lock, no need to be precise */
+	return sprintf(page, "%d\n", ioat2_ring_active(ioat));
+}
+static struct ioat_sysfs_entry ring_active_attr = __ATTR_RO(ring_active);
+
+static struct attribute *ioat2_attrs[] = {
+	&ring_size_attr.attr,
+	&ring_active_attr.attr,
+	&ioat_cap_attr.attr,
+	&ioat_version_attr.attr,
+	NULL,
+};
+
+struct kobj_type ioat2_ktype = {
+	.sysfs_ops = &ioat_sysfs_ops,
+	.default_attrs = ioat2_attrs,
+};
+
 int __devinit ioat2_dma_probe(struct ioatdma_device *device, int dca)
 {
 	struct pci_dev *pdev = device->pdev;
@@ -828,6 +858,9 @@ int __devinit ioat2_dma_probe(struct ioatdma_device *device, int dca)
 	err = ioat_register(device);
 	if (err)
 		return err;
+
+	ioat_kobject_add(device, &ioat2_ktype);
+
 	if (dca)
 		device->dca = ioat2_dca_init(pdev, device->reg_base);
 
diff --git a/drivers/dma/ioat/dma_v2.h b/drivers/dma/ioat/dma_v2.h
index af69dd1..a216b3f 100644
--- a/drivers/dma/ioat/dma_v2.h
+++ b/drivers/dma/ioat/dma_v2.h
@@ -182,4 +182,5 @@ enum dma_status ioat2_is_complete(struct dma_chan *c, dma_cookie_t cookie,
 void __ioat2_restart_chan(struct ioat2_dma_chan *ioat);
 dma_cookie_t ioat2_inject_fence(struct ioat2_dma_chan *ioat);
 bool reshape_ring(struct ioat2_dma_chan *ioat, int order);
+extern struct kobj_type ioat2_ktype;
 #endif /* IOATDMA_V2_H */
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index b223d66..22af78e 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -360,6 +360,9 @@ int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 	err = ioat_register(device);
 	if (err)
 		return err;
+
+	ioat_kobject_add(device, &ioat2_ktype);
+
 	if (dca)
 		device->dca = ioat3_dca_init(pdev, device->reg_base);
 
diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
index 064bc95..b3d5e89 100644
--- a/drivers/dma/ioat/pci.c
+++ b/drivers/dma/ioat/pci.c
@@ -172,6 +172,9 @@ static int __init ioat_init_module(void)
 {
 	int err;
 
+	pr_info("%s: Intel(R) QuickData Technology Driver %s\n",
+		DRV_NAME, IOAT_DMA_VERSION);
+
 	ioat2_cache = kmem_cache_create("ioat2", sizeof(struct ioat_ring_ent),
 					0, SLAB_HWCACHE_ALIGN, NULL);
 	if (!ioat2_cache)
