From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 15/18] ioat3: ioat3.2 pci ids for Jasper Forest
Date: Thu, 03 Sep 2009 23:45:51 -0700
Message-ID: <20090904064551.7141.2216.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932917AbZIDGsO@vger.kernel.org>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com, Tom Picard <tom.s.picard@intel.com>
List-Id: linux-raid.ids

From: Tom Picard <tom.s.picard@intel.com>

Jasper Forest introduces raid offload support via ioat3.2 support.  When
raid offload is enabled two (out of 8 channels) will report raid5/raid6
offload capabilities.  The remaining channels will only report ioat3.0
capabilities (memcpy).

Signed-off-by: Tom Picard <tom.s.picard@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/pci.c  |   13 +++++++++++++
 include/linux/pci_ids.h |   10 ++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
index b3d5e89..aad2fde 100644
--- a/drivers/dma/ioat/pci.c
+++ b/drivers/dma/ioat/pci.c
@@ -58,6 +58,19 @@ static struct pci_device_id ioat_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG5) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG6) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG7) },
+
+	/* I/OAT v3.2 platforms */
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF1) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF2) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF3) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF5) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF6) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF7) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF8) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF9) },
+
 	{ 0, }
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 0f71812..2b4b8ce 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2529,6 +2529,16 @@
 #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
 #define PCI_DEVICE_ID_INTEL_IOAT_CNB	0x360b
 #define PCI_DEVICE_ID_INTEL_FBD_CNB	0x360c
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF0	0x3710
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF1	0x3711
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF2	0x3712
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF3	0x3713
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF4	0x3714
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF5	0x3715
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF6	0x3716
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF7	0x3717
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF8	0x3718
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF9	0x3719
 #define PCI_DEVICE_ID_INTEL_ICH10_0	0x3a14
 #define PCI_DEVICE_ID_INTEL_ICH10_1	0x3a16
 #define PCI_DEVICE_ID_INTEL_ICH10_2	0x3a18
