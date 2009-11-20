From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/8] ioat: silence "dca disabled" messages
Date: Fri, 20 Nov 2009 00:06:19 -0700
Message-ID: <20091120070619.13478.14991.stgit@dwillia2-linux.ch.intel.com>
References: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755877AbZKTHG2@vger.kernel.org>
In-Reply-To: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

Turning off dca is not an "error", and the dca-enabled state can be
viewed from sysfs.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dca.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ioat/dca.c b/drivers/dma/ioat/dca.c
index 69d0261..14f0a78 100644
--- a/drivers/dma/ioat/dca.c
+++ b/drivers/dma/ioat/dca.c
@@ -98,7 +98,7 @@ static int dca_enabled_in_bios(struct pci_dev *pdev)
 	cpuid_level_9 = cpuid_eax(9);
 	res = test_bit(0, &cpuid_level_9);
 	if (!res)
-		dev_err(&pdev->dev, "DCA is disabled in BIOS\n");
+		dev_dbg(&pdev->dev, "DCA is disabled in BIOS\n");
 
 	return res;
 }
@@ -108,7 +108,7 @@ static int system_has_dca_enabled(struct pci_dev *pdev)
 	if (boot_cpu_has(X86_FEATURE_DCA))
 		return dca_enabled_in_bios(pdev);
 
-	dev_err(&pdev->dev, "boot cpu doesn't have X86_FEATURE_DCA\n");
+	dev_dbg(&pdev->dev, "boot cpu doesn't have X86_FEATURE_DCA\n");
 	return 0;
 }
 
