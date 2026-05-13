Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010018.outbound.protection.outlook.com [52.101.56.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5383B3ACA43;
	Wed, 13 May 2026 18:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778698394; cv=fail; b=X4liIrHfhgsBXL0MG6Dxm/TblqhTT9LskAL/RlYpL/Fp9PQZt4d9XS8V+41GBPFseFfNPS1yHy76B8VdkHWC04e+cpoeiLFo3GjGJE+K/dk/Ol4cKxhs/lXy0k3Di4r0R61IckZ3j0JdOvUTh8oj4REhR9f5ROD1tYFJwCBa9sU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778698394; c=relaxed/simple;
	bh=7unnGLu7QLJy0soDkKbuoySEqqtHN1piSvnDK9rIKE8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BdmR+coSY+/qqFn+H+8oAHPBU+bH7OU3msIjykGjXtC3bGiu0tw2H8qBcrKivqOcl1k3UzExlnFr9taFFZZqNxJT6sgIl6SvEYOM6y+ChyuglC3Y7+sQ4/VSihYZulB7oHfqMo0Qi+qJHfl6mA0ph6Bt1V8LKf5aexlHko3DFdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m9J0AUoy; arc=fail smtp.client-ip=52.101.56.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m9J0AUoy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AI9TbO1VPkq7MLZHlR5nLQWnPxS7w0xpFhYQXWIevV/tYcOWYFuxs1WO1+p4c4H4OP1rshoDwgjDZwshA9qqI/FU5v5y2JIIH6BWI1O4s7RfRRFSAv8VrxyQ+umwq5K5RQU0UlsKCz1uSZvTwH+hELI0y6A++wcu+FgQMSjA7mdbaUSkRw7mFrcqMAFVG2JHooi9Gp7eAZnsOFrO2XlT5KWm2zfgcJrX75F2W+W2eKvUtAkrEPs8QynfkDeXNZt+jUOAUQhxIW9UlTh7IVaKp1Ig2FCV23f230pwHHOaGytxhvYUKSwY3vB86MFyR9aRSjrwN+mcc4xxEMKBUcoHyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dYgCR/5b2FOVPce6O8qa62w9vYWdLEAn9EpeeDE13y0=;
 b=kzCHo65QpqGCsq/qFGgti4zxx34e4GMHcxQzOWU/vgzay1B9MF7w781+mRvgblTdYrEWXbB1FYiVmS9ltoBuZzjh7dCXCbfjMSHq7ZPRsM0A9nFqa0puxuY326p5lNgBLC9NILld9HJbmwrPTKqhSxFWkXDHnaXAi8jy7tG0B0qOedG+LMtK17JgyPGb9HYN9E7wAMC+OrPQdtWvPIeRJi8Clio+CIWzjF1vl+7yg3IUcsG6dQ7ostoKVPgNLO18QI/RGm3dsgxyKUPZq1LBsAYKTudJYdhsDg25YGb4wffNQ4IKr805M5wD1aINMK88IE87TsrLDIDRAHiJHzxejA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYgCR/5b2FOVPce6O8qa62w9vYWdLEAn9EpeeDE13y0=;
 b=m9J0AUoycuA2O4EcrlHpvmBDnSpl95542vkJGS9pJYIIm5u3ZbPGPguxDsW/cJFKDtF5HZQHkwAtci/P18HiCzaaJSIqohJXaEQ2FZoXRacftZSgj9mrhlgmLXS7hELHCylJgNL0zjNnwLnZhSWE0hZCLa2TWslQOnV0OoCNffgYkzXViOU3zV/KsQvpNYuS1hvk2xCzu1+LUKXaxF6MB6hx5wJ/bDxJnmkZ4i5ZSlnxRX5peiDHQVqP8fssCD1mmG8pgNHmtF734pK6BX2JAnr37SU41bW17cs+hWmxYh2l6ucPX0OuoFHad7Xkv0xBMoqyXSwDIn/h+l+dckDBVA==
Received: from BN0PR03CA0024.namprd03.prod.outlook.com (2603:10b6:408:e6::29)
 by LV3PR12MB9258.namprd12.prod.outlook.com (2603:10b6:408:1bb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 18:53:07 +0000
Received: from BN2PEPF000044A4.namprd02.prod.outlook.com
 (2603:10b6:408:e6:cafe::cf) by BN0PR03CA0024.outlook.office365.com
 (2603:10b6:408:e6::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9913.11 via Frontend Transport; Wed,
 13 May 2026 18:53:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000044A4.mail.protection.outlook.com (10.167.243.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Wed, 13 May 2026 18:53:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 13 May
 2026 11:52:37 -0700
Received: from dev.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 13 May
 2026 11:52:35 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <song@kernel.org>, <yukuai@fnnas.com>, <linan122@huawei.com>,
	<kbusch@kernel.org>, <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>
CC: <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>,
	<linux-nvme@lists.infradead.org>, <kmodukuri@nvidia.com>, Pranjal Shrivastava
	<praan@google.com>, Xiao Ni <xni@redhat.com>, Chaitanya Kulkarni
	<kch@nvidia.com>
Subject: [PATCH V4 2/3] md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device
Date: Wed, 13 May 2026 11:51:52 -0700
Message-ID: <20260513185153.95552-3-kch@nvidia.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260513185153.95552-1-kch@nvidia.com>
References: <20260513185153.95552-1-kch@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A4:EE_|LV3PR12MB9258:EE_
X-MS-Office365-Filtering-Correlation-Id: 74f6b971-47db-406e-66d6-08deb120df27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|7416014|82310400026|22082099003|56012099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	cHTdFj3VGad+kevyH4Fdlq/X7LRDChpHmvSfeNiUEElvx3f2IIzMrJUaRdGofmma5Lhp62lYSDQEwY3b2pCK8T8sipub6CDSBYQ4yNFbWlgMoBHz1QZlV9+WfdJY8oZhYwo5516nAbvrhciD6d0kolAbnGuCuXQ6bGHfhXny4zX3wWiwyFbp9x3PZi6f+JQyuJ3iAyk3lrIWRAZwZqIapeOJruPmqHbV7sX8YPxnH12zAmRWk6ZKE/LUWg56satIGAaEzoa7elm5Chl+HEZk2ziog05uJwTqxEOj+rw+2wsL8y2tpT17vuVGvIytHibvPhLMMADDxrqMt/1P8Hq8kHTSlMHwOSDWlkkS81NBQ7V5qsp5chsLVhn//9i1+/G44krXyJEcL4g0c8OeJZN3gNGkVRsUZ6PFx+9ODvFGJlznJPYZ7MxhSHcv8UdlouM3AQP3Bs+me2uLzM8DUJ0siFVAO5Y5+fpAjlHVZ56GaXT9/1f9n5xTquCCn18Q2zAdwmVg5KHjs1BFVs+Q4aklO/KiKtF3x6y66VPr6OfUvWXRlAXSo8zV3XDUWM6fh91/oBusl2iNHHSn5py8po8+NpysbR0SF1gK2QFmXVls6G7KX4PjL+dSvaYd0k1R1PNETxLAhpjZwWi9m+8pQP9b7r07659cjYKX67D+fbMTSL0dCNep2ocC6wX9ft3omGV3w/0YUZxA1j9QgRSmsu1Z7izKz2Rm2NxWnijjtDlTcoM=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(7416014)(82310400026)(22082099003)(56012099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	M+jJyJlDBGsXNlmHfm0iJvr3UFLdk62HMerzAll0JqUtQjrwwmCKb0V0jSUg6oZp/L/5FvygaN9gSTHGpYeunGCXYtAoCEWG+E/LjVPVG0K4aHWsimwI0oqfrArxIJEcAYFcEVXCtmZfnem5oNnz5wQrrPEk/SfNdeuEaP8q3gZmfO1ySirvc6FzFoAXG9q9BRtwLpR67USVLQyqenuvZHhe+VInKPvws4iVHZBohk0hCPKbqFnzyPasWqKnYJvt8zxmNr5NXPp+tOtKrppIce5L/gqZoVHabAm7ai8qs+S1hpTtGQyeAlXSbgB0DXeyOnfIF6K31mfbL9ayv+EVgYsPYmfRPxbtAzqZVpe0OVE8yyQ8ueU68nWX8C4yYOE3vWrIP+I9X+EjrQd/o5b3g/ZCupMWpTEPXVIZMMiaca7zOi6sQf+Fg7gvkyAglqBg
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 18:53:07.2290
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74f6b971-47db-406e-66d6-08deb120df27
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9258

From: Kiran Kumar Modukuri <kmodukuri@nvidia.com>

MD RAID does not propagate BLK_FEAT_PCI_P2PDMA from member devices to
the RAID device, preventing peer-to-peer DMA through the RAID layer even
when all underlying devices support it.

Enable BLK_FEAT_PCI_P2PDMA unconditionally in raid0, raid1 and raid10
personalities during queue limits setup.  blk_stack_limits() clears it
automatically if any member device lacks support, consistent with how
BLK_FEAT_NOWAIT and BLK_FEAT_POLL are handled in the block core.

Parity RAID personalities (raid4/5/6) are excluded because they require
CPU access to data pages for parity computation, which is incompatible
with P2P mappings.

Tested with RAID0/1/10 arrays containing multiple NVMe devices with
P2PDMA support, confirming that peer-to-peer transfers work correctly
through the RAID layer.

Tested-by: Pranjal Shrivastava<praan@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Kiran Kumar Modukuri <kmodukuri@nvidia.com>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/md/raid0.c  | 1 +
 drivers/md/raid1.c  | 1 +
 drivers/md/raid10.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 5e38a51e349a..2cdaf7495d92 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -392,6 +392,7 @@ static int raid0_set_limits(struct mddev *mddev)
 	lim.io_opt = lim.io_min * mddev->raid_disks;
 	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
+	lim.features |= BLK_FEAT_PCI_P2PDMA;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
 		return err;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 64d970e2ef50..cc628a1be52c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3208,6 +3208,7 @@ static int raid1_set_limits(struct mddev *mddev)
 	lim.max_hw_wzeroes_unmap_sectors = 0;
 	lim.logical_block_size = mddev->logical_block_size;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
+	lim.features |= BLK_FEAT_PCI_P2PDMA;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
 		return err;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 39085e7dd6d2..f905dc391b74 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3941,6 +3941,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
+	lim.features |= BLK_FEAT_PCI_P2PDMA;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
 		return err;
-- 
2.39.5

