Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013010.outbound.protection.outlook.com [40.93.196.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18887382382
	for <linux-raid@vger.kernel.org>; Wed,  8 Apr 2026 07:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775633187; cv=fail; b=VBdjDPwKCDYgLJbMC0YMdS3PxCwA23QjCygiNcxwmLTUHqYBvYDhMUQlYWx7aUhqVboYdfcmfHbwjuL8Jis/jabCoQNK2fpEVK170+NnDj2SkLRM8bDI6nMloTJ4U2Un2tXPePTS8usfJkf2YWT8cYfe+d+pVq4TSNKfqdtDoAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775633187; c=relaxed/simple;
	bh=cSwAOhOnG3yI2EQnHjRpBDoIVGFp/0gTPQON8LuilCo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LiV5XzYr5jbrIkOvzwVwfswQIdTu8aWXFFTTQZKuH/0FutPrf07aOkutHFkpnOD3AOdXSHm+Uy3bUakMIYfmV2kszZcAEMDa8lGNkNWmWdRDD9K3oihEEW9OIKKce8v9ZbHD/PLlwhfNNL5XqJ6O8ElYyOiWiWfaiFfGPtkvmHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aqcPqlyF; arc=fail smtp.client-ip=40.93.196.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aqcPqlyF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MZHOO1+SdrRc9Ho0SJcSFBDr81ghrfnh5utW8IsEaLC1Iw8ltV1ULYwVqjkhx2kqSU5UloQTgyUJ/NXELRGCSip2abkMdpqeHwibWDaxiJJklUU0w3/JCGKaNN83fFgLyKT6NyvCNIemT8XUraLYuFNTa0Iu2P9RC1CCaY23BuCob7h1Rmx+lLtsYDuWxJDefwvg/l1f87FllKaYyO3Uy9kMAV7Fh6Uk1HCNljhhp4VynZSI64hTYOOB10+04HQHrW0dxPQOZxHK8X3CDyCjI7rGSr4H4uqSamcSediZ/eBS7V0bCe8A1OdN6Tz/uRrpP5dobCYIWhL3iJqRrTxKfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d9C3jmuubqBJ2pj4xRp8Hekcrdqwcu/db+Szokth9vM=;
 b=OG384ir1tr3aHmDzps4MZ5hZ2WMVWa4PU0dxgXJrqAWT/zJWYe2KBjRAm1cbRw2Y7/2O2gbjfTYTiuNUxfP/Nggo/r/NS84gJuIaCsu98H+cSKUP+4j0KKdOpwNmP3tLfE3U9q2pDcvppj6BnZCL2/d/m1eAomEhzAKAFwMdRMIhrswVuL/n0PIXkhfupwsttAK23SGG0gUIkW5JX53LxCxAGB+5FFV8lAC3aswUC4gY1IEVaVea0rKbEm690VW1giB1xWKdIKJtD0HGTD9ym5XoS4UuUebRE6vbfr53pVL1Ywtn4qVzXQ0czKCSUlGwki85G1FpXRduITfAQnc94A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9C3jmuubqBJ2pj4xRp8Hekcrdqwcu/db+Szokth9vM=;
 b=aqcPqlyFCGmSA0Qxu4QYFHgaUnn7GKvmNKnIJlyZt61g4zxTg+ly01xJAruC9XdoKaY3ZVHNsKLAkGi6iDOBcU4bSehuuyJ8mHZooi23sSVgXI8f7+Yr3LRG572VwSK0FRW/W+GYFYMT1360ezwLAprsXCiFSs7fcpVPaEOC53VBn9sTXTnPrKdEH7UA/GmRpecT+izWBW122C5L1IjES1gJ7j+HYXIqeuTSHIO8kD2PWpSFlBX8kS9qgmNnaOCQOr6AeelXZmkJoWTewFS+f5S0EkOcKWQyJZxgiLtWgWwRENLxGvUyFhiPN+r26F1hUqCJVUxC3Am5uEO6HqaliA==
Received: from MN2PR15CA0038.namprd15.prod.outlook.com (2603:10b6:208:237::7)
 by IA0PR12MB8085.namprd12.prod.outlook.com (2603:10b6:208:400::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Wed, 8 Apr
 2026 07:26:22 +0000
Received: from BN1PEPF00006003.namprd05.prod.outlook.com
 (2603:10b6:208:237:cafe::63) by MN2PR15CA0038.outlook.office365.com
 (2603:10b6:208:237::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.37 via Frontend Transport; Wed,
 8 Apr 2026 07:26:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF00006003.mail.protection.outlook.com (10.167.243.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Wed, 8 Apr 2026 07:26:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 8 Apr
 2026 00:26:08 -0700
Received: from dev.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 8 Apr
 2026 00:26:07 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <song@kernel.org>, <yukuai@fnnas.com>, <linan122@huawei.com>,
	<kbusch@kernel.org>, <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>
CC: <linux-raid@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
	<kmodukuri@nvidia.com>, Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH V2 2/2] nvme-multipath: enable PCI P2PDMA for multipath devices
Date: Wed, 8 Apr 2026 00:25:37 -0700
Message-ID: <20260408072537.46540-3-kch@nvidia.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260408072537.46540-1-kch@nvidia.com>
References: <20260408072537.46540-1-kch@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006003:EE_|IA0PR12MB8085:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a3ff41a-3a97-47c7-e42b-08de95402281
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|82310400026|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	kG6VM8DNdxNKXvebYiXw2t1IlvcvKRjCKXxmI0K39TrOOheXT1ek53SIYleLIWhDFf5hG2H3uJP4yeBNGnDIxDYCEfeVpz/yKxZhYnPwwM0u1LqXcwDBY2yb4C6XscRFSpZMcopWj1nGe4pLjA5hLYJ2Ye4vljNENXAZWWy/EThP95AA2Gy95iCaT0B8BZ6LwvcWIdZxUsYHjkb83kwX+C3bpstAqYWukoPdIvk/Yoa8sTDKmAYuHiaWlw2LfFgJB0iruhIC0k565XK7LQqsZkfNd0s6nYx3qRME4MhKbCswK3U5rpN/eNqYZXf2mbKO6UQsfCx2P3twETECBtGAU0IJ6DWC4MzMJ+FfCo/AtOZq+xYmyOXjQ6aKfsCNelMdoo76O1XusaZq/Nz3l22Lnk7kzLHh70CUFLXVg+2h4nCTqIT3QhXSbp8Gb9+KeP1BRz3M1caqtFIAZsQXEYmRxlPUhQyqADYm6FdDqTbfWfMw1sdJ642F7t27gGyv1dAKyEPtXXLA8QPYhskYHXQjj9JJLWxZ9sCuY07IfX9nfZY6xTbOI6tY8M+Zy4ZxOhpEBzTvhPwZKxMcM92aBHrWxQOTt5ISDYmptlOMQdsb5S2X9HU4k1nglH16mAeIWegIf4gK0lpTzSTdao5wNX7SInb6a4d69FOwxLoFSAdFsbW4iJf/ohAPjOxYJIfPGDaLhOmpYJD/ySyMuSA6xPfVDKyhBE8DeBRd2/uUx8StHAnDct9n10MHq/gKfT9QI/aS1+IJLjcxR/6EDT3tnq73fA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(82310400026)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Dt7sQXaVjS1g00D9i7gDInW1UxBjWA99NthMEo/OADwbr3wbfsJhvaMxiU9TXwftid4ExeCgqG0QZUMmYrna4YivVeBCWgpZha+tm/YeG/tJlKA+iXcVMIuoeWMQsRB0FwVikStJoltNV6VeuSuvFb6OUrq1tQT6ZZeeT+TI36FdP1zT51ENJ9eZfR2DtYJ7nAS7S6AcI6+O+X/v7UCiELFnl5YE9vJRIxG7a0hZZ3lJDLgrRrEASMR9EZbda8CJGr3nkVKY46dHJ9i4UY9HUhHaeTEGtJYuYt/WhltD9uPA3B5ujWNQXYkK6Gh3s7fCC/hwiWugdRllrncgLbsyDhI9Jji5BTnNQYBtuErJXwn9tAzd7wj8YrjMNRr4EnYa0Z5Ouo58WzwE9SZ4XEi6VinV3Lk9FGMHbZoBbHzLasgHiXKeBnkoWxTeh3Bk0kJM
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 07:26:22.0736
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a3ff41a-3a97-47c7-e42b-08de95402281
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006003.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8085

From: Kiran Kumar Modukuri <kmodukuri@nvidia.com>

NVMe multipath does not expose BLK_FEAT_PCI_P2PDMA on the head disk
even when the underlying controller supports it.

Set BLK_FEAT_PCI_P2PDMA in nvme_mpath_alloc_disk() when the controller
advertises P2PDMA support via ctrl->ops->supports_pci_p2pdma.

Since multipath can match paths across different transports (e.g. PCIe
and FC), not all paths are guaranteed to support P2PDMA. Clear
BLK_FEAT_PCI_P2PDMA from the head disk in nvme_mpath_add_disk() if the
newly added path does not support it, ensuring the feature is only
advertised when every member supports it.

Signed-off-by: Kiran Kumar Modukuri <kmodukuri@nvidia.com>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/multipath.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index ba00f0b72b85..48d920ce803f 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -737,6 +737,9 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
 		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
 	if (head->ids.csi == NVME_CSI_ZNS)
 		lim.features |= BLK_FEAT_ZONED;
+	if (ctrl->ops && ctrl->ops->supports_pci_p2pdma &&
+	    ctrl->ops->supports_pci_p2pdma(ctrl))
+		lim.features |= BLK_FEAT_PCI_P2PDMA;
 
 	head->disk = blk_alloc_disk(&lim, ctrl->numa_node);
 	if (IS_ERR(head->disk))
@@ -1248,6 +1251,21 @@ void nvme_mpath_remove_sysfs_link(struct nvme_ns *ns)
 
 void nvme_mpath_add_disk(struct nvme_ns *ns, __le32 anagrpid)
 {
+	struct nvme_ns_head *head = ns->head;
+
+	/*
+	 * Clear BLK_FEAT_PCI_P2PDMA on the head disk if this path does not
+	 * support it. Multipath may span different transports (e.g. PCIe and
+	 * FC), so every member must support P2PDMA for it to be safe on the
+	 * head disk.
+	 */
+	if (head->disk && !blk_queue_pci_p2pdma(ns->queue)) {
+		struct queue_limits lim =
+			queue_limits_start_update(head->disk->queue);
+		lim.features &= ~BLK_FEAT_PCI_P2PDMA;
+		queue_limits_commit_update(head->disk->queue, &lim);
+	}
+
 	if (nvme_ctrl_use_ana(ns->ctrl)) {
 		struct nvme_ana_group_desc desc = {
 			.grpid = anagrpid,
-- 
2.39.5

