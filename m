From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 17/18] Add MODULE_DEVICE_TABLE() so ioatdma module is
	autoloaded
Date: Thu, 03 Sep 2009 23:46:01 -0700
Message-ID: <20090904064601.7141.18599.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, Roland Dreier <rolandd@cisco.com>, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

From: Roland Dreier <rdreier@cisco.com>

The ioatdma module is missing aliases for the PCI devices it supports,
so it is not autoloaded on boot.  Add a MODULE_DEVICE_TABLE() to get
these aliases.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
index aad2fde..8d96533 100644
--- a/drivers/dma/ioat/pci.c
+++ b/drivers/dma/ioat/pci.c
@@ -73,6 +73,7 @@ static struct pci_device_id ioat_pci_tbl[] = {
 
 	{ 0, }
 };
+MODULE_DEVICE_TABLE(pci, ioat_pci_tbl);
 
 static int __devinit ioat_pci_probe(struct pci_dev *pdev,
 				    const struct pci_device_id *id);

