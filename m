From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 11/11] async_tx: raid6 recovery self test
Date: Mon, 18 May 2009 18:00:22 -0700
Message-ID: <20090519010022.4104.8698.stgit@dwillia2-linux.ch.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: maan@systemlinux.org, linux-kernel@vger.kernel.org, yur@emcraft.com, hpa@zytor.com
List-Id: linux-raid.ids

Port drivers/md/raid6test/test.c to use the async raid6 recovery
routines.  This is meant as a unit test for raid6 acceleration drivers.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 crypto/async_tx/Makefile    |    1 
 crypto/async_tx/raid6test.c |  212 +++++++++++++++++++++++++++++++++++++++++++
 drivers/md/Kconfig          |   13 +++
 3 files changed, 226 insertions(+), 0 deletions(-)
 create mode 100644 crypto/async_tx/raid6test.c

diff --git a/crypto/async_tx/Makefile b/crypto/async_tx/Makefile
index 9a1a768..d1e0e6f 100644
--- a/crypto/async_tx/Makefile
+++ b/crypto/async_tx/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_ASYNC_MEMSET) += async_memset.o
 obj-$(CONFIG_ASYNC_XOR) += async_xor.o
 obj-$(CONFIG_ASYNC_PQ) += async_pq.o
 obj-$(CONFIG_ASYNC_RAID6_RECOV) += async_raid6_recov.o
+obj-$(CONFIG_ASYNC_RAID6_TEST) += raid6test.o
diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
new file mode 100644
index 0000000..9c16aeb
--- /dev/null
+++ b/crypto/async_tx/raid6test.c
@@ -0,0 +1,212 @@
+/*
+ * asynchronous raid6 recovery self test
+ * Copyright (c) 2009, Intel Corporation.
+ *
+ * based on drivers/md/raid6test/test.c:
+ * 	Copyright 2002-2007 H. Peter Anvin
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+#include <linux/async_tx.h>
+#include <linux/random.h>
+
+#undef pr
+#define pr(fmt, args...) pr_info("%s: " fmt, THIS_MODULE->name, ##args)
+
+#define NDISKS 16 /* Including P and Q */
+
+static struct page *dataptrs[NDISKS];
+static struct page *data[NDISKS+2];
+static struct page *recovi;
+static struct page *recovj;
+
+static void callback(void *param)
+{
+	struct completion *cmp = param;
+
+	complete(cmp);
+}
+
+static void makedata(void)
+{
+	int i, j;
+
+	for (i = 0; i < NDISKS; i++) {
+		for (j = 0; j < PAGE_SIZE/sizeof(u32); j += sizeof(u32)) {
+			u32 *p = page_address(data[i]) + j;
+
+			*p = random32();
+		}
+
+		dataptrs[i] = data[i];
+	}
+}
+
+static char disk_type(int d)
+{
+	switch (d) {
+	case NDISKS-2:
+		return 'P';
+	case NDISKS-1:
+		return 'Q';
+	default:
+		return 'D';
+	}
+}
+
+/* Recover two failed blocks. */
+static void raid6_dual_recov(int disks, size_t bytes, int faila, int failb, struct page **ptrs)
+{
+	struct async_submit_ctl submit;
+	addr_conv_t addr_conv[NDISKS];
+	struct completion cmp;
+	struct dma_async_tx_descriptor *tx = NULL;
+	enum sum_check_flags result = ~0;
+	bool dataq = false;
+
+	if (faila > failb)
+		swap(faila, failb);
+
+	init_async_submit(&submit, 0, NULL, NULL, NULL, addr_conv);
+	if (failb == disks-1) {
+		if (faila == disks-2) {
+			/* P+Q failure.  Just rebuild the syndrome. */
+			tx = async_gen_syndrome(ptrs, 0, disks, bytes, &submit);
+		} else {
+			/* data+Q failure.  Reconstruct data from P,
+			   then rebuild syndrome. */
+			/* NOT IMPLEMENTED - equivalent to RAID-5 */
+			dataq = true;
+		}
+	} else {
+		if (failb == disks-2) {
+			/* data+P failure. */
+			tx = async_raid6_datap_recov(disks, bytes, faila, ptrs, &submit);
+		} else {
+			/* data+data failure. */
+			tx = async_raid6_2data_recov(disks, bytes, faila, failb, ptrs, &submit);
+		}
+	}
+	init_completion(&cmp);
+	init_async_submit(&submit, ASYNC_TX_ACK, tx, callback, &cmp, addr_conv);
+	async_syndrome_val(ptrs, 0, disks, bytes, &result, &submit);
+
+	if (wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000)) == 0)
+		pr("%s: timeout! (faila: %d failb: %d disks: %d)\n",
+		   __func__, faila, failb, disks);
+
+	if (!dataq && result != 0)
+		pr("%s: validation failure! faila: %d failb: %d sum_check_flags: %x\n",
+		   __func__, faila, failb, result);
+}
+
+static int test_disks(int i, int j)
+{
+	int erra, errb;
+
+	memset(page_address(recovi), 0xf0, PAGE_SIZE);
+	memset(page_address(recovj), 0xba, PAGE_SIZE);
+
+	dataptrs[i] = recovi;
+	dataptrs[j] = recovj;
+
+	raid6_dual_recov(NDISKS, PAGE_SIZE, i, j, dataptrs);
+
+	erra = memcmp(page_address(data[i]), page_address(recovi), PAGE_SIZE);
+	errb = memcmp(page_address(data[j]), page_address(recovj), PAGE_SIZE);
+
+	if (i < NDISKS-2 && j == NDISKS-1) {
+		/* We don't implement the DQ failure scenario, since it's
+		   equivalent to a RAID-5 failure (XOR, then recompute Q) */
+		erra = errb = 0;
+	} else {
+		pr("%s(%d, %d): faila=%3d(%c)  failb=%3d(%c)  %s\n",
+		   __func__, i, j,
+		   i, disk_type(i),
+		   j, disk_type(j),
+		   (!erra && !errb) ? "OK" :
+		   !erra ? "ERRB" :
+		   !errb ? "ERRA" : "ERRAB");
+	}
+
+	dataptrs[i] = data[i];
+	dataptrs[j] = data[j];
+
+	return erra || errb;
+}
+
+static int raid6_test(void)
+{
+	struct async_submit_ctl submit;
+	addr_conv_t addr_conv[NDISKS];
+	struct completion cmp;
+	int err = 0;
+	int tests = 0;
+	int i, j;
+
+	for (i = 0; i < NDISKS+2; i++) {
+		data[i] = alloc_page(GFP_KERNEL);
+		if (!data[i]) {
+			while (i--)
+				put_page(data[i]);
+			return -ENOMEM;
+		}
+	}
+	recovi = data[NDISKS];
+	recovj = data[NDISKS+1];
+
+	makedata();
+
+	/* Nuke syndromes */
+	memset(page_address(data[NDISKS-2]), 0xee, PAGE_SIZE);
+	memset(page_address(data[NDISKS-1]), 0xee, PAGE_SIZE);
+
+	/* Generate assumed good syndrome */
+	init_completion(&cmp);
+	init_async_submit(&submit, ASYNC_TX_ACK, NULL, callback, &cmp, addr_conv);
+	async_gen_syndrome(dataptrs, 0, NDISKS, PAGE_SIZE, &submit);
+
+	if (wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000)) == 0) {
+		pr("error: initial gen_syndrome timed out\n");
+		goto out;
+	}
+
+	for (i = 0; i < NDISKS-1; i++)
+		for (j = i+1; j < NDISKS; j++) {
+			tests++;
+			err += test_disks(i, j);
+		}
+
+ out:
+	pr("\n");
+	pr("complete (%d tests, %d failure%s)\n",
+	   tests, err, err == 1 ? "" : "s");
+
+	for (i = 0; i < NDISKS+2; i++)
+		put_page(data[i]);
+
+	return 0;
+}
+
+static void raid6_test_exit(void)
+{
+}
+
+/* when compiled-in wait for drivers to load first */
+late_initcall(raid6_test);
+module_exit(raid6_test_exit);
+MODULE_AUTHOR("Dan Williams <dan.j.williams@intel.com>");
+MODULE_DESCRIPTION("asynchronous RAID-6 recovery self tests");
+MODULE_LICENSE("GPL");
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 36e0675..41b3ae2 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -155,6 +155,19 @@ config MD_RAID456
 config MD_RAID6_PQ
 	tristate
 
+config ASYNC_RAID6_TEST
+	tristate "Self test for hardware accelerated raid6 recovery"
+	depends on MD_RAID6_PQ
+	select ASYNC_RAID6_RECOV
+	---help---
+	  This is a one-shot self test that permutes through the
+	  recovery of all the possible two disk failure scenarios for a
+	  N-disk array.  Recovery is performed with the asynchronous
+	  raid6 recovery routines, and will optionally use an offload
+	  engine if one is available.
+
+	  If unsure, say N.
+
 config MD_MULTIPATH
 	tristate "Multipath I/O support"
 	depends on BLK_DEV_MD

