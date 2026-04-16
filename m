Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012009.outbound.protection.outlook.com [52.101.53.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC47D38AC8A
	for <linux-raid@vger.kernel.org>; Thu, 16 Apr 2026 21:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776374841; cv=fail; b=o/ymzEGTx2/93xEECtBbr29KHJ+OCHS2OYRKFRyyBx7+/wJTbN1vAxKp5DgJjuERgjfj87T8wo4weJ+J1Et1r0IGemgALHw5QEZH/2gGR9griZauLm3PFsQ1KPicn2lUM4XGSY1ENQGsbZca0gM1lFq5aNOw2x9RRqAV9y0U7cI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776374841; c=relaxed/simple;
	bh=IUO3GeXdaDldh04uIHf2+X0KfXL974Bby2sBfLAQbwo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nZCB/VzQcGSUw/vvrf+3kgPBVZ5evlwFP3EHaYiUNAXQnbPNHwl6u7FW2zXimdbnzajBBeoLg5N0u/G3bF48A6HhIgT1fk0qe6omoHaPi0bHrCEfYqeTyIjvLCq9uqSbCE2dVT5FfR71oswt3wfstDaSXpoSIQI/Fp5Zg1MCEM8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=scuYhl6t; arc=fail smtp.client-ip=52.101.53.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="scuYhl6t"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z1fW56f/BtJJhfF5HJkDaMh6MAKk+dd5GVA5PrxZK/W+6D1CVCRB0t9lyauEmsATnax6OvJUu3o+tgVX5ZA8aGO1F9zKwoiBA7z3e6mxRxKMKrE6eIN0wvy9pDpGrvRUhH63iNo6Y8qnneBvJGLGM1ACZuMsRX3vYw9CasQ4nNO9YdrrsAQe1f5/dU+SmYexUkiXKXnV+Dku7n2JvKh0GCOq62FBYwqbWsD5X0vifj8OVOB76YToGA8ihEQ3lLSGDhuLP71ypYxDNiLmg21jPNVPKUZkbgHBz/t7+x97Sx2rvoxqYbEVdx8bJ1Vw8rs9T0W6ctuv9sngm2G68ARNKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TbvlcS8Tz6nTzQ+WC7Xfb/gCr1kqdVhasoH7iOz6rUE=;
 b=D4Ss/lh1B4kaUOsGAFyM0TDxqeiGqLPsSELe2mafs5CkL2NNN838rVYZ3zIaok6EAPIDi0bHfPkgyD4Uijb71gsyWTVwQsTqL7ZawyUvp9ypZrElo8wRHl+T9tTAWn9Ex1yeoYf1VdrMcmx8l/gGmSz26SlKhDkv/SbK60yEI3b0IBAWQfTnKHHUSSaNgJr79ObzdtH0mubT1FRKZBwb0F9RLgQipFlbd7v0Q+fBF0szGov7tON0Ist663egWxSDOJymFw9D3LAzvllcU5g/zjXXJ1o7lUqLxAShBpGVeA8MOCYdpbrDiMy/AfOP92PY0qWMskNeEcqXGAJ/i9baOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TbvlcS8Tz6nTzQ+WC7Xfb/gCr1kqdVhasoH7iOz6rUE=;
 b=scuYhl6tK/+0Qu+WGiPL978N3qtfTcKmFxPjNaFOIZaiVY9lDNa3F1ScDtVz9zYn/dMx8DLkd/3MEeHt6/cbfomGuleEhB5xYNi7vo/islEwcLZ41FTmu46porZfkRzsZYJoDmIu2Ssw1stQxKPMh61P+v40BA5R3L18WM6WUL9gGU8N7gQmo4HV/uy92F7kPZWMW9cvtvdK/D8AsSGFCjVWSuz4lmyFJA7HR7z4QckV70A/whz4BiTyEJ1c4RugFrGolUi2LBbDn3poBFuMr2rh58mfG2m7q9OcYfI29Apn2TedwEyHFbrhJzxovGfW3C2tiyvGq30+AZnRaa6aUQ==
Received: from BN9PR03CA0803.namprd03.prod.outlook.com (2603:10b6:408:13f::28)
 by MW4PR12MB6949.namprd12.prod.outlook.com (2603:10b6:303:208::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 16 Apr
 2026 21:27:05 +0000
Received: from BN2PEPF00004FC1.namprd04.prod.outlook.com
 (2603:10b6:408:13f:cafe::e1) by BN9PR03CA0803.outlook.office365.com
 (2603:10b6:408:13f::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.52 via Frontend Transport; Thu,
 16 Apr 2026 21:27:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF00004FC1.mail.protection.outlook.com (10.167.243.187) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Thu, 16 Apr 2026 21:27:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 16 Apr
 2026 14:26:47 -0700
Received: from dev.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 16 Apr
 2026 14:26:46 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <song@kernel.org>, <yukuai@fnnas.com>, <linan122@huawei.com>,
	<kbusch@kernel.org>, <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>
CC: <linux-raid@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
	<kmodukuri@nvidia.com>, Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH V3 0/2] md/nvme: Enable PCI P2PDMA support for RAID0 and NVMe Multipath
Date: Thu, 16 Apr 2026 14:26:30 -0700
Message-ID: <20260416212633.72650-1-kch@nvidia.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FC1:EE_|MW4PR12MB6949:EE_
X-MS-Office365-Filtering-Correlation-Id: 94b9bfa2-d34b-430b-777f-08de9bfee779
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|82310400026|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	W5kneV6r6iE9yMcw09NnIE5H0rb1JcvYS6T5YR8MRjlfnYHGWHWO/aoG20OQCWPO+9Bs8DzkUMsQJUUy33MQ8MtAyiDn6njdPBhLKpecu5vjTDojJ/MKLAPrmX0apMF+moM5bc735yZ3VbR/HwCpmjXJfj/eoOqq+H4iAB3J1lVL5bBJ/ZZkDDQbwP/GLFT8nrP4kPgPkcCDKtVKBmGs3fEbN23is4kCarHOwoMrrxZDj4cmkBaK61LxBW6YXrtuCR/1oslGMMvQp3mxLBOjfSN6r/1bISyGGeZcYtPl4xsdNOASe5BGaj/swbRmFlgmtdxg/MKn3ad9F924yT4drDLLw24RpGgCVu43g6Gm9jOPEKpgmFUEksDcMculQU+42ponOlYlaN3lAYZYMe5/C9bF8WaXTV8LJqS9eMUY0haf9bvijeM4aJvdXCWf7QhEKPOCYAflFNNXVTXRNGG9amc4iDAFBl3mCMu8z7k/qnh12McVInkNFsLvqezASWgV/Smr5xQcR/RranQv0VqJlko0cW+H9VSgVLjqCqdBRwtbPdM+ZNoXvkHgE1hiSTt9T0Slpkx06AR2+3p8Wb4vsXxdACXmnamW56r3weZ6dWNbtcBaeHa5/vnJUsEhRA/Tf+IBKiMBqcYuak3hZSH0DFHhBX85dUuKnckbxc9YeQjxRfCkw5pGwSyt+tBJzCSQVbvVwMTpIu5G+sLIMpMybJc/w6bcMwE4fo3TR0e+csmbKw5DGwYE5JlIrDktxf5EPBtBSqTJsF+r73ihLwtGvw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(82310400026)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dLXxTp0NmEOl36XsDTnELadfISXP3Uu6xxp8qHHAu1B//RwISBK1mKUXY1DppycqxWRBtPGYvIEd3GvljQ1X6E+4kIzFeqedKIAGufO/mTHzHc0VA1bhgyIe/DIgd0AHeUjLsvMsFFdWvKWsTBI29LIFzmuQLJN7VSY/fcR2SWr8NtwT+yJsm1fTYNAmp1wwr4FUR6yRWUswvmjqg8yPwqeSrfCNVo2coL7V443sKXO7DmrlSgV0PHZDd6OHcIwIrPEhAoF9zVjcDSmcjbXk6Rlpi2PVFVg2UOlYPPICdudu7iVyJiKsM08RM1WynNLvx9rVvUa4wDhsb34nWzJuxL0HJVAGZcOYOJYzQnPjvJCQQmBohXGSqgXac3ALpe8pfHtcFO6rOoSU6djR8tjm7CJnIQhrypvle8+EH0SnsBNQIJEtGAaM0q3QCrAV7+M5
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 21:27:03.8845
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94b9bfa2-d34b-430b-777f-08de9bfee779
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FC1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6949

Hi,

This patch series extends PCI peer-to-peer DMA (P2PDMA) support to enable
direct data transfers between PCIe devices through RAID and NVMe multipath
block layers.

Current Linux kernel P2PDMA infrastructure supports direct peer-to-peer
transfers, but this support is not propagated through certain storage
stacks like MD RAID and NVMe multipath. This adds two patches for
MD RAID 0/1/10 and NVMe to propogate P2PDMA support through the
storage stack.

All four test scenarios demonstrate that P2PDMA capabilities are correctly
propagated through both the MD RAID layer (patch 1/2) and NVMe multipath
layer (patch 2/2). Direct peer-to-peer transfers complete successfully with
full data integrity verification, confirming that:

1. RAID devices properly inherit P2PDMA capability from member devices
2. NVMe multipath devices correctly expose P2PDMA support
3. P2P memory buffers can be used for transfers involving both types
4. Data integrity is maintained across all transfer combinations

I've added the patch specific tests and blktest log as well at the end.

Repo:-

git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git

Branch HEAD:-

commit 88a57e15861997dd6fa98154ad087f7831bbead1 (origin/for-next)
Merge: 81a0a2e4e535 36446de0c30c
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Apr 10 07:02:42 2026 -0600

    Merge branch 'for-7.1/block' into for-next

    * for-7.1/block:
      ublk: fix tautological comparison warning in ublk_ctrl_reg_buf
-ck

Changes from V2:-

1. Unconditionally set the BLK_FEAT_PCI_P2PDMA for md and nvme multipath.
   (Christoph)
2. Add a prep patch to diable BLK_FEAT_PCI_P2PDMA in the blk_stack_limit().
   (christoph)

Changes from V1:-
- Update patch 1 to explicitly support MD RAID 0/1/10.
- Fix signoff chain order for patch 2.
- Clear BLK_FEAT_PCI_P2PDMA in nvme_mpath_add_disk() when a newly
  added path does not support it, to handle multipath across different
  transports.
- Add nvme multipath test log for mixed transport TCP and PCIe.

Chaitanya Kulkarni (1):
  block: clear BLK_FEAT_PCI_P2PDMA in blk_stack_limits() for
    non-supporting devices

Kiran Kumar Modukuri (2):
  md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device
  nvme-multipath: enable PCI P2PDMA for multipath devices

 block/blk-settings.c          | 2 ++
 drivers/md/raid0.c            | 1 +
 drivers/md/raid1.c            | 1 +
 drivers/md/raid10.c           | 1 +
 drivers/nvme/host/multipath.c | 2 +-
 5 files changed, 6 insertions(+), 1 deletion(-)

========================================================
* MD RAID Personalities and NVMe testing :-
========================================================
================================================================================
P2PDMA Comprehensive Test Report
================================================================================
Date:   Thu Apr 16, 2026 19:00:32 UTC

Patch Series Under Test:
  1/3  blk: clear BLK_FEAT_PCI_P2PDMA in blk_stack_limits
  2/3  nvme-multipath: expose BLK_FEAT_PCI_P2PDMA on head disk
  3/3  md: raid0/1/10: expose BLK_FEAT_PCI_P2PDMA on array disk

================================================================================
1. System Information
================================================================================

Kernel:
  Linux vm70 7.0.0-rc2-p2pdma-v2+ #19 SMP PREEMPT Thu Apr 16 18:01:55 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux

Kernel patches (git log above baseline):
  5bf19d9 md: raid0/1/10: expose BLK_FEAT_PCI_P2PDMA on array disk
  02dc9a6 nvme-multipath: expose BLK_FEAT_PCI_P2PDMA on head disk
  ba22b62 blk: clear BLK_FEAT_PCI_P2PDMA in blk_stack_limits

NVMe Modules:
  nvme_fabrics           24576  0

MD Modules loaded:
    (none yet -- will be loaded on demand)

--------------------------------------------------------------------------------
1.1  NVMe Device Inventory (nvme list -v)
--------------------------------------------------------------------------------

Subsystem        Subsystem-NQN                                                                                    Controllers
---------------- ------------------------------------------------------------------------------------------------ ----------------
nvme-subsys1     nqn.2019-08.org.qemu:nqn.2019-08.org.qemu:shared-ns                                              nvme0, nvme1
nvme-subsys2     nqn.2019-08.org.qemu:nvme3                                                                       nvme2
nvme-subsys3     nqn.2019-08.org.qemu:nvme4                                                                       nvme3
nvme-subsys4     nqn.2019-08.org.qemu:nvme5                                                                       nvme4
nvme-subsys5     nqn.2019-08.org.qemu:nvme6                                                                       nvme5

Device   SN                   MN                                       FR       TxPort Address        Slot   Subsystem    Namespaces      
-------- -------------------- ---------------------------------------- -------- ------ -------------- ------ ------------ ----------------
nvme0    shared2              QEMU NVMe Ctrl                           1.0      pcie   0000:0a:00.0          nvme-subsys1 nvme1n1
nvme1    shared2              QEMU NVMe Ctrl                           1.0      pcie   0000:0b:00.0          nvme-subsys1 nvme1n1
nvme2    nvme3                QEMU NVMe Ctrl                           1.0      pcie   0000:0c:00.0          nvme-subsys2 nvme2n1
nvme3    nvme4                QEMU NVMe Ctrl                           1.0      pcie   0000:0d:00.0          nvme-subsys3 nvme3n1
nvme4    nvme5                QEMU NVMe Ctrl                           1.0      pcie   0000:0e:00.0          nvme-subsys4 nvme4n1
nvme5    nvme6                QEMU NVMe Ctrl                           1.0      pcie   0000:10:00.0          nvme-subsys5 nvme5n1

Device       Generic      NSID       Usage                      Format           Controllers     
------------ ------------ ---------- -------------------------- ---------------- ----------------
/dev/nvme1n1 /dev/ng1n1   0x1         10.74  GB /  10.74  GB    512   B +  0 B   nvme0, nvme1
/dev/nvme2n1 /dev/ng2n1   0x1         10.74  GB /  10.74  GB    512   B +  0 B   nvme2
/dev/nvme3n1 /dev/ng3n1   0x1         10.74  GB /  10.74  GB    512   B +  0 B   nvme3
/dev/nvme4n1 /dev/ng4n1   0x1         10.74  GB /  10.74  GB    512   B +  0 B   nvme4
/dev/nvme5n1 /dev/ng5n1   0x1         10.74  GB /  10.74  GB    512   B +  0 B   nvme5

--------------------------------------------------------------------------------
1.2  Shared Namespace Configuration (nvme-subsys1)
--------------------------------------------------------------------------------

nvme-subsys1 - NQN=nqn.2019-08.org.qemu:nqn.2019-08.org.qemu:shared-ns
               hostnqn=nqn.2014-08.org.nvmexpress:uuid:148a9e69-3f22-420f-afea-bfd5d4b77f36
               iopolicy=numa
\
 +- nvme0 pcie 0000:0a:00.0 live optimized
 +- nvme1 pcie 0000:0b:00.0 live optimized

--------------------------------------------------------------------------------
1.3  PCI P2PDMA / CMB Configuration
--------------------------------------------------------------------------------

CMB-enabled NVMe controllers:
  0000:0a:00.0 (nvme0) - CMB 64 MB
  0000:0b:00.0 (nvme1) - CMB 64 MB
  0000:0c:00.0 (nvme2) - CMB 64 MB

dmesg (P2P):
  [    7.283954] nvme 0000:0a:00.0: added peer-to-peer DMA memory 0x1808000000-0x180bffffff
  [    7.288711] nvme 0000:0c:00.0: added peer-to-peer DMA memory 0x1800000000-0x1803ffffff
  [    7.293117] nvme 0000:0b:00.0: added peer-to-peer DMA memory 0x1804000000-0x1807ffffff

--------------------------------------------------------------------------------
1.4  Standalone NVMe Devices (for RAID tests)
--------------------------------------------------------------------------------

  /dev/nvme2n1  ( 10G)
  /dev/nvme3n1  ( 10G)
  /dev/nvme4n1  ( 10G)
  /dev/nvme5n1  ( 10G)

P2PMEM for multipath tests: /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate
P2PMEM for RAID tests:      /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate

================================================================================
2. Test 1: NVMe Multipath P2PDMA (Patch 2/3)
================================================================================

Objective:
  Verify BLK_FEAT_PCI_P2PDMA is set on the multipath head when all paths
  support P2PDMA (PCIe-only), and cleared when a non-P2P path (TCP) is added.
  Clearing is handled by blk_stack_limits() in the block core (Patch 1/3).

Test tool:     /home/lab/p2pmem-test/p2pmem-test
P2PMEM buffer: /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate
Target device: /dev/nvme1n1 (multipath head, nvme-subsys1)

--------------------------------------------------------------------------------
2.1  Test 1a: P2PDMA with PCIe-only Multipath Paths (Expect PASS)
--------------------------------------------------------------------------------

Paths before test:
  \
   +- nvme0 pcie 0000:0a:00.0 live optimized
   +- nvme1 pcie 0000:0b:00.0 live optimized

All paths are PCIe with CMB -> P2PDMA supported.
Patch 2/3 sets BLK_FEAT_PCI_P2PDMA unconditionally in nvme_mpath_alloc_disk().

Command:
  /home/lab/p2pmem-test/p2pmem-test /dev/nvme1n1 /dev/nvme1n1 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate -c 1 -s 4k --check

Output:
  Running p2pmem-test: reading /dev/nvme1n1 (10.74GB): writing /dev/nvme1n1 (10.74GB): p2pmem buffer /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate.
  	chunk size = 4096 : number of chunks =  1: total = 4.096kB : thread(s) = 1 : overlap = OFF.
  	skip-read = OFF : skip-write =  OFF : duration = INF sec.
  	buffer = 0x7f30b32dc000 (p2pmem): mmap = 4.096kB
  	PAGE_SIZE = 4096B
  	checking data with seed = 1776366032
  MATCH on data check, 0x23039cdb = 0x23039cdb.
  Transfer:
    4.10kB in 860.0 us     4.76MB/s

Exit code: 0

Result: PASS
  P2PDMA transfer succeeded with data verification.

--------------------------------------------------------------------------------
2.2  Test 1b: Add NVMe-oF TCP Path, Then Test P2PDMA (Expect FAIL)
--------------------------------------------------------------------------------

Setting up NVMe-oF TCP target (nvmet) on loopback...
  Subsystem NQN: nqn.2019-08.org.qemu:nqn.2019-08.org.qemu:shared-ns
  Namespace 1:   backed by /dev/nvme1n1
  Device UUID:   00000000-0000-0000-0000-000000000000 (matches QEMU quirk)
  Transport:     TCP, 127.0.0.1:4420
  CNTLID min:    10

Paths after TCP connection:
  \
   +- nvme0 pcie 0000:0a:00.0 live optimized
   +- nvme1 pcie 0000:0b:00.0 live optimized
   +- nvme6 tcp traddr=127.0.0.1,trsvcid=4420,src_addr=127.0.0.1 live optimized

NVMe device inventory (nvme list -v) confirming TCP path in shared namespace:

Subsystem        Subsystem-NQN                                                                                    Controllers
---------------- ------------------------------------------------------------------------------------------------ ----------------
nvme-subsys1     nqn.2019-08.org.qemu:nqn.2019-08.org.qemu:shared-ns                                              nvme0, nvme1, nvme6
nvme-subsys2     nqn.2019-08.org.qemu:nvme3                                                                       nvme2
nvme-subsys3     nqn.2019-08.org.qemu:nvme4                                                                       nvme3
nvme-subsys4     nqn.2019-08.org.qemu:nvme5                                                                       nvme4
nvme-subsys5     nqn.2019-08.org.qemu:nvme6                                                                       nvme5

Device   SN                   MN                                       FR       TxPort Address        Slot   Subsystem    Namespaces      
-------- -------------------- ---------------------------------------- -------- ------ -------------- ------ ------------ ----------------
nvme0    shared2              QEMU NVMe Ctrl                           7.0.0-rc pcie   0000:0a:00.0          nvme-subsys1 nvme1n1
nvme1    shared2              QEMU NVMe Ctrl                           7.0.0-rc pcie   0000:0b:00.0          nvme-subsys1 nvme1n1
nvme2    nvme3                QEMU NVMe Ctrl                           1.0      pcie   0000:0c:00.0          nvme-subsys2 nvme2n1
nvme3    nvme4                QEMU NVMe Ctrl                           1.0      pcie   0000:0d:00.0          nvme-subsys3 nvme3n1
nvme4    nvme5                QEMU NVMe Ctrl                           1.0      pcie   0000:0e:00.0          nvme-subsys4 nvme4n1
nvme5    nvme6                QEMU NVMe Ctrl                           1.0      pcie   0000:10:00.0          nvme-subsys5 nvme5n1
nvme6    shared2              QEMU NVMe Ctrl                           7.0.0-rc tcp    traddr=127.0.0.1,trsvcid=4420,src_addr=127.0.0.1        nvme-subsys1 nvme1n1

Device       Generic      NSID       Usage                      Format           Controllers     
------------ ------------ ---------- -------------------------- ---------------- ----------------
/dev/nvme1n1 /dev/ng1n1   0x1         10.74  GB /  10.74  GB    512   B +  0 B   nvme0, nvme1, nvme6
/dev/nvme2n1 /dev/ng2n1   0x1         10.74  GB /  10.74  GB    512   B +  0 B   nvme2
/dev/nvme3n1 /dev/ng3n1   0x1         10.74  GB /  10.74  GB    512   B +  0 B   nvme3
/dev/nvme4n1 /dev/ng4n1   0x1         10.74  GB /  10.74  GB    512   B +  0 B   nvme4
/dev/nvme5n1 /dev/ng5n1   0x1         10.74  GB /  10.74  GB    512   B +  0 B   nvme5

TCP path lacks PCI P2PDMA. Patch 1/3 causes blk_stack_limits() to clear
BLK_FEAT_PCI_P2PDMA when the TCP path's limits are stacked onto the head.

Command:
  /home/lab/p2pmem-test/p2pmem-test /dev/nvme1n1 /dev/nvme1n1 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate -c 1 -s 4k --check

Output:
  pread: Remote I/O error
  Running p2pmem-test: reading /dev/nvme1n1 (10.74GB): writing /dev/nvme1n1 (10.74GB): p2pmem buffer /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate.
  	chunk size = 4096 : number of chunks =  1: total = 4.096kB : thread(s) = 1 : overlap = OFF.
  	skip-read = OFF : skip-write =  OFF : duration = INF sec.
  	buffer = 0x7f9851d3d000 (p2pmem): mmap = 4.096kB
  	PAGE_SIZE = 4096B
  	checking data with seed = 1776366033

Exit code: 1

Result: PASS (expected failure)
  P2PDMA transfer correctly rejected -- BLK_FEAT_PCI_P2PDMA was
  cleared because a non-P2P-capable component is present.

Cleaning up TCP path...
  TCP path removed.

================================================================================
3. Test 2: MD RAID0 P2PDMA (Patch 3/3)
================================================================================

Objective:
  Verify BLK_FEAT_PCI_P2PDMA propagates through RAID0. Patch 3/3 sets
  the flag in raid0_set_limits(); blk_stack_limits() preserves it when
  all member devices support P2PDMA.

Members: /dev/nvme2n1 /dev/nvme3n1

--------------------------------------------------------------------------------
3.1  Test 2a: P2PDMA on RAID0 Array (Expect PASS)
--------------------------------------------------------------------------------

mdadm create output:
  mdadm: Defaulting to version 1.2 metadata
  mdadm: array /dev/md/p2p-test started.
RAID0 device: /dev/md127

Array detail (mdadm --detail):
  /dev/md127:
             Version : 1.2
       Creation Time : Thu Apr 16 19:00:35 2026
          Raid Level : raid0
          Array Size : 20953088 (19.98 GiB 21.46 GB)
        Raid Devices : 2
       Total Devices : 2
         Persistence : Superblock is persistent
  
         Update Time : Thu Apr 16 19:00:35 2026
               State : clean 
      Active Devices : 2
     Working Devices : 2
      Failed Devices : 0
       Spare Devices : 0
  
              Layout : original
          Chunk Size : 512K
  
  Consistency Policy : none
  
                Name : vm70:p2p-test  (local to host vm70)
                UUID : 84f669e0:6b24971e:680cdf64:ca4087e0
              Events : 0
  
      Number   Major   Minor   RaidDevice State
         0     259        4        0      active sync   /dev/nvme2n1
         1     259        5        1      active sync   /dev/nvme3n1

/proc/mdstat:
  Personalities : [raid0] [raid1] [raid4] [raid5] [raid6] [raid10] 
  md127 : active raid0 nvme3n1[1] nvme2n1[0]
        20953088 blocks super 1.2 512k chunks
        
  unused devices: <none>

P2PMEM buffer: /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate


Command:
  /home/lab/p2pmem-test/p2pmem-test /dev/md127 /dev/md127 /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate -c 1 -s 4k --check

Output:
  Running p2pmem-test: reading /dev/md127 (21.46GB): writing /dev/md127 (21.46GB): p2pmem buffer /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate.
  	chunk size = 4096 : number of chunks =  1: total = 4.096kB : thread(s) = 1 : overlap = OFF.
  	skip-read = OFF : skip-write =  OFF : duration = INF sec.
  	buffer = 0x7f87e5cd4000 (p2pmem): mmap = 4.096kB
  	PAGE_SIZE = 4096B
  	checking data with seed = 1776366036
  MATCH on data check, 0x3db0cfbb = 0x3db0cfbb.
  Transfer:
    4.10kB in 747.0 us     5.48MB/s

Exit code: 0

Result: PASS
  P2PDMA transfer succeeded with data verification.

RAID0 array stopped.

================================================================================
4. Test 3: MD RAID1 P2PDMA (Patch 3/3)
================================================================================

Objective:
  Verify BLK_FEAT_PCI_P2PDMA propagates through RAID1. Patch 3/3 sets
  the flag in raid1_set_limits(); blk_stack_limits() preserves it when
  all member devices support P2PDMA.

Members: /dev/nvme2n1 /dev/nvme3n1

--------------------------------------------------------------------------------
4.1  Test 3a: P2PDMA on RAID1 Array (Expect PASS)
--------------------------------------------------------------------------------

mdadm create output:
  mdadm: Note: this array has metadata at the start and
      may not be suitable as a boot device.  If you plan to
      store '/boot' on this device please ensure that
      your boot-loader understands md/v1.x metadata, or use
      --metadata=0.90
  mdadm: Defaulting to version 1.2 metadata
  mdadm: array /dev/md/p2p-test started.
RAID1 device: /dev/md127

Array detail (mdadm --detail):
  /dev/md127:
             Version : 1.2
       Creation Time : Thu Apr 16 19:00:38 2026
          Raid Level : raid1
          Array Size : 10476544 (9.99 GiB 10.73 GB)
       Used Dev Size : 10476544 (9.99 GiB 10.73 GB)
        Raid Devices : 2
       Total Devices : 2
         Persistence : Superblock is persistent
  
         Update Time : Thu Apr 16 19:00:38 2026
               State : clean, resyncing 
      Active Devices : 2
     Working Devices : 2
      Failed Devices : 0
       Spare Devices : 0
  
  Consistency Policy : resync
  
       Resync Status : 2% complete
  
                Name : vm70:p2p-test  (local to host vm70)
                UUID : 7917cc10:d47660cb:46454ecd:ccc8f946
              Events : 0
  
      Number   Major   Minor   RaidDevice State
         0     259        4        0      active sync   /dev/nvme2n1
         1     259        5        1      active sync   /dev/nvme3n1

/proc/mdstat:
  Personalities : [raid0] [raid1] [raid4] [raid5] [raid6] [raid10] 
  md127 : active raid1 nvme3n1[1] nvme2n1[0]
        10476544 blocks super 1.2 [2/2] [UU]
        [>....................]  resync =  2.0% (215936/10476544) finish=0.7min speed=215936K/sec
        
  unused devices: <none>

P2PMEM buffer: /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate


Command:
  /home/lab/p2pmem-test/p2pmem-test /dev/md127 /dev/md127 /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate -c 1 -s 4k --check

Output:
  Running p2pmem-test: reading /dev/md127 (10.73GB): writing /dev/md127 (10.73GB): p2pmem buffer /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate.
  	chunk size = 4096 : number of chunks =  1: total = 4.096kB : thread(s) = 1 : overlap = OFF.
  	skip-read = OFF : skip-write =  OFF : duration = INF sec.
  	buffer = 0x7f0947c68000 (p2pmem): mmap = 4.096kB
  	PAGE_SIZE = 4096B
  	checking data with seed = 1776366040
  MATCH on data check, 0x1b7cad6e = 0x1b7cad6e.
  Transfer:
    4.10kB in 2.8   ms     1.44MB/s

Exit code: 0

Result: PASS
  P2PDMA transfer succeeded with data verification.

RAID1 array stopped.

================================================================================
5. Test 4: MD RAID10 P2PDMA (Patch 3/3)
================================================================================

Objective:
  Verify BLK_FEAT_PCI_P2PDMA propagates through RAID10. Patch 3/3 sets
  the flag in raid10_set_limits(); blk_stack_limits() preserves it when
  all member devices support P2PDMA.

Members: /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1

--------------------------------------------------------------------------------
5.1  Test 4a: P2PDMA on RAID10 Array (Expect PASS)
--------------------------------------------------------------------------------

mdadm create output:
  mdadm: Defaulting to version 1.2 metadata
  mdadm: array /dev/md/p2p-test started.
RAID10 device: /dev/md127

Array detail (mdadm --detail):
  /dev/md127:
             Version : 1.2
       Creation Time : Thu Apr 16 19:00:43 2026
          Raid Level : raid10
          Array Size : 20953088 (19.98 GiB 21.46 GB)
       Used Dev Size : 10476544 (9.99 GiB 10.73 GB)
        Raid Devices : 4
       Total Devices : 4
         Persistence : Superblock is persistent
  
         Update Time : Thu Apr 16 19:00:43 2026
               State : clean, resyncing 
      Active Devices : 4
     Working Devices : 4
      Failed Devices : 0
       Spare Devices : 0
  
              Layout : near=2
          Chunk Size : 512K
  
  Consistency Policy : resync
  
       Resync Status : 1% complete
  
                Name : vm70:p2p-test  (local to host vm70)
                UUID : 0a6b9ded:3f38328a:61352e9c:6f5f7853
              Events : 0
  
      Number   Major   Minor   RaidDevice State
         0     259        4        0      active sync set-A   /dev/nvme2n1
         1     259        5        1      active sync set-B   /dev/nvme3n1
         2     259        3        2      active sync set-A   /dev/nvme4n1
         3     259        6        3      active sync set-B   /dev/nvme5n1

/proc/mdstat:
  Personalities : [raid0] [raid1] [raid4] [raid5] [raid6] [raid10] 
  md127 : active raid10 nvme5n1[3] nvme4n1[2] nvme3n1[1] nvme2n1[0]
        20953088 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
        [>....................]  resync =  1.8% (387200/20953088) finish=0.8min speed=387200K/sec
        
  unused devices: <none>

P2PMEM buffer: /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate


Command:
  /home/lab/p2pmem-test/p2pmem-test /dev/md127 /dev/md127 /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate -c 1 -s 4k --check

Output:
  Running p2pmem-test: reading /dev/md127 (21.46GB): writing /dev/md127 (21.46GB): p2pmem buffer /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate.
  	chunk size = 4096 : number of chunks =  1: total = 4.096kB : thread(s) = 1 : overlap = OFF.
  	skip-read = OFF : skip-write =  OFF : duration = INF sec.
  	buffer = 0x7f2061b9a000 (p2pmem): mmap = 4.096kB
  	PAGE_SIZE = 4096B
  	checking data with seed = 1776366044
  MATCH on data check, 0x744f0811 = 0x744f0811.
  Transfer:
    4.10kB in 484.9 us     8.45MB/s

Exit code: 0

Result: PASS
  P2PDMA transfer succeeded with data verification.

RAID10 array stopped.

================================================================================
6. Test 5: MD RAID4 P2PDMA -- Negative Test
================================================================================

Objective:
  Verify that P2PDMA does NOT work on RAID4. Parity RAID levels (4/5/6)
  require CPU access to data pages for XOR/parity computation, which is
  incompatible with P2P mappings. Patch 3/3 intentionally does NOT add
  BLK_FEAT_PCI_P2PDMA to raid456 personalities.

Members: /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1

--------------------------------------------------------------------------------
6.1  Test 5a: P2PDMA on RAID4 Array (Expect FAIL)
--------------------------------------------------------------------------------

mdadm create output:
  mdadm: Defaulting to version 1.2 metadata
  mdadm: array /dev/md/p2p-test started.
RAID4 device: /dev/md127

Array detail (mdadm --detail):
  /dev/md127:
             Version : 1.2
       Creation Time : Thu Apr 16 19:00:47 2026
          Raid Level : raid4
          Array Size : 20953088 (19.98 GiB 21.46 GB)
       Used Dev Size : 10476544 (9.99 GiB 10.73 GB)
        Raid Devices : 3
       Total Devices : 3
         Persistence : Superblock is persistent
  
         Update Time : Thu Apr 16 19:00:47 2026
               State : clean, resyncing 
      Active Devices : 3
     Working Devices : 3
      Failed Devices : 0
       Spare Devices : 0
  
          Chunk Size : 512K
  
  Consistency Policy : resync
  
       Resync Status : 1% complete
  
                Name : vm70:p2p-test  (local to host vm70)
                UUID : b9fb0c5f:d6471fd5:4704f465:88bd6425
              Events : 0
  
      Number   Major   Minor   RaidDevice State
         0     259        4        0      active sync   /dev/nvme2n1
         1     259        5        1      active sync   /dev/nvme3n1
         2     259        3        2      active sync   /dev/nvme4n1

/proc/mdstat:
  Personalities : [raid0] [raid1] [raid4] [raid5] [raid6] [raid10] 
  md127 : active raid4 nvme4n1[2] nvme3n1[1] nvme2n1[0]
        20953088 blocks super 1.2 level 4, 512k chunk, algorithm 0 [3/3] [UUU]
        [>....................]  resync =  1.6% (172572/10476544) finish=0.9min speed=172572K/sec
        
  unused devices: <none>

P2PMEM buffer: /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate


Command:
  /home/lab/p2pmem-test/p2pmem-test /dev/md127 /dev/md127 /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate -c 1 -s 4k --check

Output:
  pread: Remote I/O error
  Running p2pmem-test: reading /dev/md127 (21.46GB): writing /dev/md127 (21.46GB): p2pmem buffer /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate.
  	chunk size = 4096 : number of chunks =  1: total = 4.096kB : thread(s) = 1 : overlap = OFF.
  	skip-read = OFF : skip-write =  OFF : duration = INF sec.
  	buffer = 0x7f4f647b8000 (p2pmem): mmap = 4.096kB
  	PAGE_SIZE = 4096B
  	checking data with seed = 1776366048

Exit code: 1

Result: PASS (expected failure)
  P2PDMA transfer correctly rejected -- BLK_FEAT_PCI_P2PDMA was
  cleared because a non-P2P-capable component is present.

RAID4 array stopped.

================================================================================
7. Test Summary
================================================================================

  Test   Description                                     Expected  Actual  Result
  ------ ----------------------------------------------- --------- ------- ------
  1a     NVMe multipath P2PDMA (PCIe-only paths)         PASS      PASS    OK
  1b     NVMe multipath P2PDMA (PCIe + TCP paths)        FAIL      FAIL    OK
  2a     MD RAID0 P2PDMA                                 PASS      PASS    OK
  3a     MD RAID1 P2PDMA                                 PASS      PASS    OK
  4a     MD RAID10 P2PDMA                                PASS      PASS    OK
  5a     MD RAID4 P2PDMA (negative test)                 FAIL      FAIL    OK

Totals: 6 tests, 6 passed, 0 failed

All tests PASSED.

================================================================================

========================================================
* BLKTEST Testing :- nvme, block, and md category
========================================================
blktests (master) # ./test-nvme.sh 
++ for t in loop tcp
++ echo '################NVMET_TRTYPES=loop############'
################NVMET_TRTYPES=loop############
++ NVME_IMG_SIZE=1G
++ NVME_NUM_ITER=1
++ NVMET_TRTYPES=loop
++ ./check nvme
nvme/002 (tr=loop) (create many subsystems and test discovery) [passed]
    runtime  36.834s  ...  35.055s
nvme/003 (tr=loop) (test if we're sending keep-alives to a discovery controller) [passed]
    runtime  10.240s  ...  10.233s
nvme/004 (tr=loop) (test nvme and nvmet UUID NS descriptors) [passed]
    runtime  0.684s  ...  0.656s
nvme/005 (tr=loop) (reset local loopback target)             [passed]
    runtime  0.981s  ...  0.970s
nvme/006 (tr=loop bd=device) (create an NVMeOF target)       [passed]
    runtime  0.091s  ...  0.097s
nvme/006 (tr=loop bd=file) (create an NVMeOF target)         [passed]
    runtime  0.086s  ...  0.083s
nvme/008 (tr=loop bd=device) (create an NVMeOF host)         [passed]
    runtime  0.645s  ...  0.631s
nvme/008 (tr=loop bd=file) (create an NVMeOF host)           [passed]
    runtime  0.655s  ...  0.632s
nvme/010 (tr=loop bd=device) (run data verification fio job) [passed]
    runtime  9.238s  ...  9.716s
nvme/010 (tr=loop bd=file) (run data verification fio job)   [passed]
    runtime  47.943s  ...  39.701s
nvme/012 (tr=loop bd=device) (run mkfs and data verification fio) [passed]
    runtime  52.603s  ...  47.570s
nvme/012 (tr=loop bd=file) (run mkfs and data verification fio) [passed]
    runtime  41.337s  ...  38.148s
nvme/014 (tr=loop bd=device) (flush a command from host)     [passed]
    runtime  9.359s  ...  9.667s
nvme/014 (tr=loop bd=file) (flush a command from host)       [passed]
    runtime  9.076s  ...  8.428s
nvme/016 (tr=loop) (create/delete many NVMeOF block device-backed ns and test discovery) [passed]
    runtime  0.141s  ...  0.123s
nvme/017 (tr=loop) (create/delete many file-ns and test discovery) [passed]
    runtime  0.146s  ...  0.140s
nvme/018 (tr=loop) (unit test NVMe-oF out of range access on a file backend) [passed]
    runtime  0.632s  ...  0.623s
nvme/019 (tr=loop bd=device) (test NVMe DSM Discard command) [passed]
    runtime  0.643s  ...  0.626s
nvme/019 (tr=loop bd=file) (test NVMe DSM Discard command)   [passed]
    runtime  0.636s  ...  0.623s
nvme/021 (tr=loop bd=device) (test NVMe list command)        [passed]
    runtime  0.662s  ...  0.635s
nvme/021 (tr=loop bd=file) (test NVMe list command)          [passed]
    runtime  0.645s  ...  0.635s
nvme/022 (tr=loop bd=device) (test NVMe reset command)       [passed]
    runtime  0.991s  ...  0.993s
nvme/022 (tr=loop bd=file) (test NVMe reset command)         [passed]
    runtime  1.009s  ...  0.997s
nvme/023 (tr=loop bd=device) (test NVMe smart-log command)   [passed]
    runtime  0.647s  ...  0.620s
nvme/023 (tr=loop bd=file) (test NVMe smart-log command)     [passed]
    runtime  0.653s  ...  0.618s
nvme/025 (tr=loop bd=device) (test NVMe effects-log)         [passed]
    runtime  0.649s  ...  0.626s
nvme/025 (tr=loop bd=file) (test NVMe effects-log)           [passed]
    runtime  0.665s  ...  0.627s
nvme/026 (tr=loop bd=device) (test NVMe ns-descs)            [passed]
    runtime  0.649s  ...  0.639s
nvme/026 (tr=loop bd=file) (test NVMe ns-descs)              [passed]
    runtime  0.641s  ...  0.620s
nvme/027 (tr=loop bd=device) (test NVMe ns-rescan command)   [passed]
    runtime  0.675s  ...  0.641s
nvme/027 (tr=loop bd=file) (test NVMe ns-rescan command)     [passed]
    runtime  0.673s  ...  0.637s
nvme/028 (tr=loop bd=device) (test NVMe list-subsys)         [passed]
    runtime  0.648s  ...  0.626s
nvme/028 (tr=loop bd=file) (test NVMe list-subsys)           [passed]
    runtime  0.640s  ...  0.614s
nvme/029 (tr=loop) (test userspace IO via nvme-cli read/write interface) [passed]
    runtime  1.002s  ...  0.925s
nvme/030 (tr=loop) (ensure the discovery generation counter is updated appropriately) [passed]
    runtime  0.438s  ...  0.420s
nvme/031 (tr=loop) (test deletion of NVMeOF controllers immediately after setup) [passed]
    runtime  5.997s  ...  5.825s
nvme/038 (tr=loop) (test deletion of NVMeOF subsystem without enabling) [passed]
    runtime  0.034s  ...  0.034s
nvme/040 (tr=loop) (test nvme fabrics controller reset/disconnect operation during I/O) [passed]
    runtime  7.032s  ...  7.002s
nvme/041 (tr=loop) (Create authenticated connections)        [passed]
    runtime  0.701s  ...  0.681s
nvme/042 (tr=loop) (Test dhchap key types for authenticated connections) [passed]
    runtime  3.906s  ...  3.772s
nvme/043 (tr=loop) (Test hash and DH group variations for authenticated connections) [passed]
    runtime  4.987s  ...  4.815s
nvme/044 (tr=loop) (Test bi-directional authentication)      [passed]
    runtime  1.482s  ...  1.259s
nvme/045 (tr=loop) (Test re-authentication)                  [passed]
    runtime  1.643s  ...  1.566s
nvme/047 (tr=loop) (test different queue types for fabric transports) [not run]
    nvme_trtype=loop is not supported in this test
nvme/048 (tr=loop) (Test queue count changes on reconnect)   [not run]
    nvme_trtype=loop is not supported in this test
nvme/051 (tr=loop) (test nvmet concurrent ns enable/disable) [passed]
    runtime  1.390s  ...  1.330s
nvme/052 (tr=loop) (Test file-ns creation/deletion under one subsystem) [passed]
    runtime  6.363s  ...  6.276s
nvme/054 (tr=loop) (Test the NVMe reservation feature)       [passed]
    runtime  0.775s  ...  0.742s
nvme/055 (tr=loop) (Test nvme write to a loop target ns just after ns is disabled) [not run]
    kernel option DEBUG_ATOMIC_SLEEP has not been enabled
nvme/056 (tr=loop) (enable zero copy offload and run rw traffic) [not run]
    Remote target required but NVME_TARGET_CONTROL is not set
    nvme_trtype=loop is not supported in this test
    kernel option ULP_DDP has not been enabled
    module nvme_tcp does not have parameter ddp_offload
    KERNELSRC not set
    Kernel sources do not have tools/net/ynl/cli.py
    NVME_IFACE not set
nvme/057 (tr=loop) (test nvme fabrics controller ANA failover during I/O) [passed]
    runtime  27.176s  ...  27.143s
nvme/058 (tr=loop) (test rapid namespace remapping)          [passed]
    runtime  4.517s  ...  4.414s
nvme/060 (tr=loop) (test nvme fabrics target reset)          [not run]
    nvme_trtype=loop is not supported in this test
nvme/061 (tr=loop) (test fabric target teardown and setup during I/O) [not run]
    nvme_trtype=loop is not supported in this test
nvme/062 (tr=loop) (Create TLS-encrypted connections)        [not run]
    nvme_trtype=loop is not supported in this test
nvme/063 (tr=loop) (Create authenticated TCP connections with secure concatenation) [not run]
    nvme_trtype=loop is not supported in this test
nvme/065 (tr=loop) (test unmap write zeroes sysfs interface with nvmet devices) [passed]
    runtime  2.356s  ...  2.340s
++ for t in loop tcp
++ echo '################NVMET_TRTYPES=tcp############'
################NVMET_TRTYPES=tcp############
++ NVME_IMG_SIZE=1G
++ NVME_NUM_ITER=1
++ NVMET_TRTYPES=tcp
++ ./check nvme
nvme/002 (tr=tcp) (create many subsystems and test discovery) [not run]
    nvme_trtype=tcp is not supported in this test
nvme/003 (tr=tcp) (test if we're sending keep-alives to a discovery controller) [passed]
    runtime  10.245s  ...  10.241s
nvme/004 (tr=tcp) (test nvme and nvmet UUID NS descriptors)  [passed]
    runtime  0.380s  ...  0.362s
nvme/005 (tr=tcp) (reset local loopback target)              [passed]
    runtime  0.450s  ...  0.431s
nvme/006 (tr=tcp bd=device) (create an NVMeOF target)        [passed]
    runtime  0.104s  ...  0.098s
nvme/006 (tr=tcp bd=file) (create an NVMeOF target)          [passed]
    runtime  0.096s  ...  0.093s
nvme/008 (tr=tcp bd=device) (create an NVMeOF host)          [passed]
    runtime  0.385s  ...  0.361s
nvme/008 (tr=tcp bd=file) (create an NVMeOF host)            [passed]
    runtime  0.389s  ...  0.353s
nvmenvme/010 (tr=tcp bd=device) (run data verification fio job)  [passed]
    runtime  75.462s  ...  76.437s
nvme/010 (tr=tcp bd=file) (run data verification fio job)    [passed]
    runtime  126.440s  ...  117.933s
nvme/012 (tr=tcp bd=device) (run mkfs and data verification fio) [passed]
    runtime  88.197s  ...  81.428s
nvme/012 (tr=tcp bd=file) (run mkfs and data verification fio) [passed]
    runtime  120.398s  ...  117.412s
nvme/014 (tr=tcp bd=device) (flush a command from host)      [passed]
    runtime  9.931s  ...  10.182s
nvme/014 (tr=tcp bd=file) (flush a command from host)        [passed]
    runtime  9.745s  ...  9.867s
nvme/016 (tr=tcp) (create/delete many NVMeOF block device-backed ns and test discovery) [not run]
    nvme_trtype=tcp is not supported in this test
nvme/017 (tr=tcp) (create/delete many file-ns and test discovery) [not run]
    nvme_trtype=tcp is not supported in this test
nvme/018 (tr=tcp) (unit test NVMe-oF out of range access on a file backend) [passed]
    runtime  0.380s  ...  0.351s
nvme/019 (tr=tcp bd=device) (test NVMe DSM Discard command)  [passed]
    runtime  0.385s  ...  0.344s
nvme/019 (tr=tcp bd=file) (test NVMe DSM Discard command)    [passed]
    runtime  0.382s  ...  0.339s
nvme/021 (tr=tcp bd=device) (test NVMe list command)         [passed]
    runtime  0.371s  ...  0.368s
nvme/021 (tr=tcp bd=file) (test NVMe list command)           [passed]
    runtime  0.396s  ...  0.359s
nvme/022 (tr=tcp bd=device) (test NVMe reset command)        [passed]
    runtime  0.482s  ...  0.451s
nvme/022 (tr=tcp bd=file) (test NVMe reset command)          [passed]
    runtime  0.453s  ...  0.443s
nvme/023 (tr=tcp bd=device) (test NVMe smart-log command)    [passed]
    runtime  0.379s  ...  0.349s
nvme/023 (tr=tcp bd=file) (test NVMe smart-log command)      [passed]
    runtime  0.361s  ...  0.339s
nvme/025 (tr=tcp bd=device) (test NVMe effects-log)          [passed]
    runtime  0.391s  ...  0.371s
nvme/025 (tr=tcp bd=file) (test NVMe effects-log)            [passed]
    runtime  0.380s  ...  0.380s
nvme/026 (tr=tcp bd=device) (test NVMe ns-descs)             [passed]
    runtime  0.373s  ...  0.352s
nvme/026 (tr=tcp bd=file) (test NVMe ns-descs)               [passed]
    runtime  0.356s  ...  0.351s
nvme/027 (tr=tcp bd=device) (test NVMe ns-rescan command)    [passed]
    runtime  0.417s  ...  0.380s
nvme/027 (tr=tcp bd=file) (test NVMe ns-rescan command)      [passed]
    runtime  0.396s  ...  0.383s
nvme/028 (tr=tcp bd=device) (test NVMe list-subsys)          [passed]
    runtime  0.353s  ...  0.348s
nvme/028 (tr=tcp bd=file) (test NVMe list-subsys)            [passed]
    runtime  0.351s  ...  0.341s
nvme/029 (tr=tcp) (test userspace IO via nvme-cli read/write interface) [passed]
    runtime  0.762s  ...  0.722s
nvme/030 (tr=tcp) (ensure the discovery generation counter is updated appropriately) [passed]
    runtime  0.410s  ...  0.377s
nvme/031 (tr=tcp) (test deletion of NVMeOF controllers immediately after setup) [passed]
    runtime  3.055s  ...  3.008s
nvme/038 (tr=tcp) (test deletion of NVMeOF subsystem without enabling) [passed]
    runtime  0.044s  ...  0.042s
nvme/040 (tr=tcp) (test nvme fabrics controller reset/disconnect operation during I/O) [passed]
    runtime  6.492s  ...  6.454s
nvme/041 (tr=tcp) (Create authenticated connections)         [passed]
    runtime  0.418s  ...  0.388s
nvme/042 (tr=tcp) (Test dhchap key types for authenticated connections) [passed]
    runtime  1.827s  ...  1.780s
nvme/043 (tr=tcp) (Test hash and DH group variations for authenticated connections) [passed]
    runtime  2.504s  ...  2.343s
nvme/044 (tr=tcp) (Test bi-directional authentication)       [passed]
    runtime  0.776s  ...  0.709s
nvme/045 (tr=tcp) (Test re-authentication)                   [passed]
    runtime  1.338s  ...  1.311s
nvme/047 (tr=tcp) (test different queue types for fabric transports) [passed]
    runtime  1.887s  ...  1.792s
nvme/048 (tr=tcp) (Test queue count changes on reconnect)    [passed]
    runtime  5.531s  ...  4.498s
nvme/051 (tr=tcp) (test nvmet concurrent ns enable/disable)  [passed]
    runtime  1.344s  ...  1.375s
nvme/052 (tr=tcp) (Test file-ns creation/deletion under one subsystem) [not run]
    nvme_trtype=tcp is not supported in this test
nvme/054 (tr=tcp) (Test the NVMe reservation feature)        [passed]
    runtime  0.506s  ...  0.459s
nvme/055 (tr=tcp) (Test nvme write to a loop target ns just after ns is disabled) [not run]
    nvme_trtype=tcp is not supported in this test
    kernel option DEBUG_ATOMIC_SLEEP has not been enabled
nvme/056 (tr=tcp) (enable zero copy offload and run rw traffic) [not run]
    Remote target required but NVME_TARGET_CONTROL is not set
    kernel option ULP_DDP has not been enabled
    module nvme_tcp does not have parameter ddp_offload
    KERNELSRC not set
    Kernel sources do not have tools/net/ynl/cli.py
    NVME_IFACE not set
nvme/057 (tr=tcp) (test nvme fabrics controller ANA failover during I/O) [passed]
    runtime  25.972s  ...  25.924s
nvme/058 (tr=tcp) (test rapid namespace remapping)           [passed]
    runtime  3.612s  ...  2.850s
nvme/060 (tr=tcp) (test nvme fabrics target reset)           [passed]
    runtime  19.437s  ...  19.330s
nvme/061 (tr=tcp) (test fabric target teardown and setup during I/O) [passed]
    runtime  8.645s  ...  8.580s
nvme/062 (tr=tcp) (Create TLS-encrypted connections)         [failed]
    runtime  5.242s  ...  5.176s
    --- tests/nvme/062.out	2026-01-28 12:04:48.888356244 -0800
    +++ /mnt/sda/blktests/results/nodev_tr_tcp/nvme/062.out.bad	2026-04-16 10:33:14.946941197 -0700
    @@ -2,9 +2,13 @@
     Test unencrypted connection w/ tls not required
     disconnected 1 controller(s)
     Test encrypted connection w/ tls not required
    -disconnected 1 controller(s)
    +FAIL: nvme connect return error code
    +WARNING: connection is not encrypted
    +disconnected 0 controller(s)
    ...
    (Run 'diff -u tests/nvme/062.out /mnt/sda/blktests/results/nodev_tr_tcp/nvme/062.out.bad' to see the entire diff)
nvme/063 (tr=tcp) (Create authenticated TCP connections with secure concatenation) [passed]
    runtime  2.026s  ...  1.919s
nvme/065 (tr=tcp) (test unmap write zeroes sysfs interface with nvmet devices) [passed]
    runtime  1.767s  ...  1.726s
++ ./manage-rdma-nvme.sh --cleanup
====== RDMA NVMe Cleanup ======

[INFO] Disconnecting NVMe RDMA controllers...
[INFO] No NVMe RDMA controllers to disconnect
[INFO] Removing RDMA links...
[INFO] No RDMA links to remove
[INFO] Unloading NVMe RDMA modules...
[INFO] Unloading module: nvmet
[ERROR] Failed to unload module nvmet after 10 attempts
[WARN] Failed to unload 1 NVMe module(s)
[WARN] Some NVMe modules could not be unloaded
[INFO] Unloading soft-RDMA modules...
[INFO] Soft-RDMA modules unloaded successfully

[INFO] Verifying cleanup...
[INFO] Verification passed
[INFO] RDMA cleanup completed successfully


====== RDMA Network Configuration Status ======

Loaded Modules:
  nvmet                    258048

RDMA Links:
  None

Network Interfaces (RDMA-capable):
  None

blktests Configuration:
  Not configured (run --setup first)

NVMe RDMA Controllers:
  None

=================================================
++ ./manage-rdma-nvme.sh --setup
====== RDMA NVMe Setup ======
RDMA Type: siw
Interface: auto-detect

[INFO] Checking prerequisites...
[INFO] Prerequisites check passed
[INFO] Loading RDMA module: siw
[INFO] Module siw loaded successfully
[INFO] Creating RDMA links...
[INFO] Creating RDMA link: ens5_siw
[INFO] Created RDMA link: ens5_siw -> ens5
++ ./manage-rdma-nvme.sh --status
====== RDMA Configuration Status ======

====== RDMA Network Configuration Status ======

Loaded Modules:
  siw                      217088
  nvmet                    258048

RDMA Links:
  link ens5_siw/1 state ACTIVE physical_state LINK_UP netdev ens5 

Network Interfaces (RDMA-capable):
  Interface: ens5
    IPv4: 192.168.0.46
    IPv6: fe80::5054:98ff:fe76:5440%ens5

blktests Configuration:
  Transport Address: 192.168.0.46:4420
  Transport Type: rdma
  Command: NVMET_TRTYPES=rdma ./check nvme/

NVMe RDMA Controllers:
  None

=================================================
++ echo '################NVMET_TRTYPES=rdma############'
################NVMET_TRTYPES=rdma############
++ NVME_IMG_SIZE=1G
++ NVME_NUM_ITER=1
++ nvme_trtype=rdma
++ ./check nvme
nvme/002 (tr=rdma) (create many subsystems and test discovery) [not run]
    nvme_trtype=rdma is not supported in this test
nvme/003 (tr=rdma) (test if we're sending keep-alives to a discovery controller) [passed]
    runtime  10.343s  ...  10.315s
nvme/004 (tr=rdma) (test nvme and nvmet UUID NS descriptors) [passed]
    runtime  0.691s  ...  0.695s
nvme/005 (tr=rdma) (reset local loopback target)             [passed]
    runtime  1.021s  ...  0.974s
nvme/006 (tr=rdma bd=device) (create an NVMeOF target)       [passed]
    runtime  0.147s  ...  0.136s
nvme/006 (tr=rdma bd=file) (create an NVMeOF target)         [passed]
    runtime  0.148s  ...  0.127s
nvme/008 (tr=rdma bd=device) (create an NVMeOF host)         [passed]
    runtime  0.706s  ...  0.684s
nvme/008 (tr=rdma bd=file) (create an NVMeOF host)           [passed]
    runtime  0.704s  ...  0.672s
nvme/010 (tr=rdma bd=device) (run data verification fio job) [passed]
    runtime  35.986s  ...  35.255s
nvme/010 (tr=rdma bd=file) (run data verification fio job)   [passed]
    runtime  61.777s  ...  68.570s
nvme/012 (tr=rdma bd=device) (run mkfs and data verification fio) [passed]
    runtime  42.996s  ...  47.482s
nvme/012 (tr=rdma bd=file) (run mkfs and data verification fio) [passed]
    runtime  65.456s  ...  61.407s
nvme/014 (tr=rdma bd=device) (flush a command from host)     [passed]
    runtime  9.546s  ...  9.855s
nvme/014 (tr=rdma bd=file) (flush a command from host)       [passed]
    runtime  9.791s  ...  9.919s
nvme/016 (tr=rdma) (create/delete many NVMeOF block device-backed ns and test discovery) [not run]
    nvme_trtype=rdma is not supported in this test
nvme/017 (tr=rdma) (create/delete many file-ns and test discovery) [not run]
    nvme_trtype=rdma is not supported in this test
nvme/018 (tr=rdma) (unit test NVMe-oF out of range access on a file backend) [passed]
    runtime  0.710s  ...  0.654s
nvme/019 (tr=rdma bd=device) (test NVMe DSM Discard command) [passed]
    runtime  0.699s  ...  0.664s
nvme/019 (tr=rdma bd=file) (test NVMe DSM Discard command)   [passed]
    runtime  0.686s  ...  0.649s
nvme/021 (tr=rdma bd=device) (test NVMe list command)        [passed]
    runtime  0.725s  ...  0.676s
nvme/021 (tr=rdma bd=file) (test NVMe list command)          [passed]
    runtime  0.703s  ...  0.673s
nvme/022 (tr=rdma bd=device) (test NVMe reset command)       [passed]
    runtime  1.048s  ...  1.021s
nvme/022 (tr=rdma bd=file) (test NVMe reset command)         [passed]
    runtime  1.032s  ...  1.015s
nvme/023 (tr=rdma bd=device) (test NVMe smart-log command)   [passed]
    runtime  0.699s  ...  0.633s
nvme/023 (tr=rdma bd=file) (test NVMe smart-log command)     [passed]
    runtime  0.687s  ...  0.656s
nvme/025 (tr=rdma bd=device) (test NVMe effects-log)         [passed]
    runtime  0.701s  ...  0.706s
nvme/025 (tr=rdma bd=file) (test NVMe effects-log)           [passed]
    runtime  0.696s  ...  0.688s
nvme/026 (tr=rdma bd=device) (test NVMe ns-descs)            [passed]
    runtime  0.703s  ...  0.686s
nvme/026 (tr=rdma bd=file) (test NVMe ns-descs)              [passed]
    runtime  0.684s  ...  0.669s
nvme/027 (tr=rdma bd=device) (test NVMe ns-rescan command)   [passed]
    runtime  0.727s  ...  0.703s
nvme/027 (tr=rdma bd=file) (test NVMe ns-rescan command)     [passed]
    runtime  0.715s  ...  0.707s
nvme/028 (tr=rdma bd=device) (test NVMe list-subsys)         [passed]
    runtime  0.688s  ...  0.680s
nvme/028 (tr=rdma bd=file) (test NVMe list-subsys)           [passed]
    runtime  0.672s  ...  0.670s
nvme/029 (tr=rdma) (test userspace IO via nvme-cli read/write interface) [passed]
    runtime  1.067s  ...  1.077s
nvme/030 (tr=rdma) (ensure the discovery generation counter is updated appropriately) [passed]
    runtime  0.541s  ...  0.511s
nvme/031 (tr=rdma) (test deletion of NVMeOF controllers immediately after setup) [passed]
    runtime  5.793s  ...  5.869s
nvme/038 (tr=rdma) (test deletion of NVMeOF subsystem without enabling) [passed]
    runtime  0.086s  ...  0.084s
nvme/040 (tr=rdma) (test nvme fabrics controller reset/disconnect operation during I/O) [passed]
    runtime  7.059s  ...  7.024s
nvme/041 (tr=rdma) (Create authenticated connections)        [passed]
    runtime  0.742s  ...  0.718s
nvme/042 (tr=rdma) (Test dhchap key types for authenticated connections) [passed]
    runtime  3.781s  ...  3.759s
nvme/043 (tr=rdma) (Test hash and DH group variations for authenticated connections) [passed]
    runtime  4.797s  ...  4.487s
nvme/044 (tr=rdma) (Test bi-directional authentication)      [passed]
    runtime  1.346s  ...  1.279s
nvme/045 (tr=rdma) (Test re-authentication)                  [passed]
    runtime  1.806s  ...  1.837s
nvme/047 (tr=rdma) (test different queue types for fabric transports) [passed]
    runtime  2.688s  ...  2.642s
nvme/048 (tr=rdma) (Test queue count changes on reconnect)   [passed]
    runtime  6.846s  ...  5.810s
nvme/051 (tr=rdma) (test nvmet concurrent ns enable/disable) [passed]
    runtime  1.399s  ...  1.479s
nvme/052 (tr=rdma) (Test file-ns creation/deletion under one subsystem) [not run]
    nvme_trtype=rdma is not supported in this test
nvme/054 (tr=rdma) (Test the NVMe reservation feature)       [passed]
    runtime  0.831s  ...  0.799s
nvme/055 (tr=rdma) (Test nvme write to a loop target ns just after ns is disabled) [not run]
    nvme_trtype=rdma is not supported in this test
    kernel option DEBUG_ATOMIC_SLEEP has not been enabled
nvme/056 (tr=rdma) (enable zero copy offload and run rw traffic) [not run]
    Remote target required but NVME_TARGET_CONTROL is not set
    nvme_trtype=rdma is not supported in this test
    kernel option ULP_DDP has not been enabled
    module nvme_tcp does not have parameter ddp_offload
    KERNELSRC not set
    Kernel sources do not have tools/net/ynl/cli.py
    NVME_IFACE not set
nvme/057 (tr=rdma) (test nvme fabrics controller ANA failover during I/O) [passed]
    runtime  27.023s  ...  26.984s
nvme/058 (tr=rdma) (test rapid namespace remapping)          [passed]
    runtime  4.478s  ...  4.444s
nvme/060 (tr=rdma) (test nvme fabrics target reset)          [passed]
    runtime  20.821s  ...  20.696s
nvme/061 (tr=rdma) (test fabric target teardown and setup during I/O) [passed]
    runtime  15.509s  ...  15.375s
nvme/062 (tr=rdma) (Create TLS-encrypted connections)        [not run]
    nvme_trtype=rdma is not supported in this test
nvme/063 (tr=rdma) (Create authenticated TCP connections with secure concatenation) [not run]
    nvme_trtype=rdma is not supported in this test
nvme/065 (tr=rdma) (test unmap write zeroes sysfs interface with nvmet devices) [passed]
    runtime  2.331s  ...  2.369s
++ ./manage-rdma-nvme.sh --cleanup
====== RDMA NVMe Cleanup ======

[INFO] Disconnecting NVMe RDMA controllers...
[INFO] No NVMe RDMA controllers to disconnect
[INFO] Removing RDMA links...
[INFO] No RDMA links to remove
[INFO] Unloading NVMe RDMA modules...
[INFO] Unloading module: nvme_rdma
[INFO] Module nvme_rdma unloaded
[INFO] Unloading module: nvmet_rdma
[INFO] Module nvmet_rdma unloaded
[INFO] Unloading module: nvmet
[ERROR] Failed to unload module nvmet after 10 attempts
[WARN] Failed to unload 1 NVMe module(s)
[WARN] Some NVMe modules could not be unloaded
[INFO] Unloading soft-RDMA modules...
[INFO] Unloading module: siw
[INFO] Module siw unloaded
[INFO] Soft-RDMA modules unloaded successfully

[INFO] Verifying cleanup...
[INFO] Verification passed
[INFO] RDMA cleanup completed successfully


====== RDMA Network Configuration Status ======

Loaded Modules:
  nvmet                    258048

RDMA Links:
  None

Network Interfaces (RDMA-capable):
  None

blktests Configuration:
  Not configured (run --setup first)

NVMe RDMA Controllers:
  None

=================================================
blktests (master) # 



-- 
2.39.5

