Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010039.outbound.protection.outlook.com [52.101.201.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E44D38B15D
	for <linux-raid@vger.kernel.org>; Thu, 16 Apr 2026 21:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776374860; cv=fail; b=nSkqDMyDsVBmG7oH7xdF282GXmMEgDT0+NI24G55bIFu24QSCo+veXmxWWFRUPPKm+dpU7a4sbn5dBrgtERt9BLPcfOzroQSBKt2KEUBB15dlSF87/yPjzgfp7IciVZi+AzSYse3f81D7x/o33QX87MVYhme0TOqtc+aD6jNb/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776374860; c=relaxed/simple;
	bh=BKDNjp2yxo2sTecdZNhHeNwLUysIv1hkP7IRy4Hf+ns=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gyfC0hNIpy1ajIbcZynoOnOzvXv5k1aqZ+39FheZOLup6YbhrozaBXI1hg6O2NJMClFIOgvbYhkvLcyTVFAr24Goo/rYn2rW8cXC+EXS6S72LNK95OMHjux3TZGpMm+zvyOpCjRhp5L76GDRnOslOe/pfdW0kEchQRnfUX0Ky80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iccC4Vhm; arc=fail smtp.client-ip=52.101.201.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iccC4Vhm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NODh0PGj7SeqgDb1uGRgXxnIa4qxA6oxtQ6WsaFAc8MXaCVPhhVOWkm2z587TvjY6aq5x1Fc7DEcrN9dtnr3+Z7+N8dcW90kZN3ieuY3G0sHdePo34GdWa1ZRFdCkQsMcJrFk86yKS1/oeRK4rMGZ9YfaklWLoabkGCV5zMmIImQUb0kV7W6m5apqfEi1N6nQPYDpXOMi6JPN25SvjpyBHvzCfe/slD4dwpfJN5WNkBNNV+aRtCgtp4+X66ergO5R5kDsOc+v3GniCX6bAihS/wThNT/KLkSLZnAhWwGrEvJ7d4SIgRVOvE8Wu2AIxa6bfguyN9Z1KmZ60BwQ0n2Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=piyJ9qXO8f3jQRVpFqDRLg61VwJUCReg20Z2ugU4fBo=;
 b=xpgsdrrqrqpBCUCjucKQcr2tQ//JPpt/Jl6nurXCCvpgRuOdlivDImSWHWa3/MGRlFsjkD7HL93/nF4UG1FgAJbWwRvDsJPyYMB6zR3r6/0YeOAawk+69JjrM3FUbyZVO5G8eXvyyEvYfHAd5BiVQJDAt3ndKw0iHM5KL8xAAPazbNg0CoY5tMbQXVYEqhkRh3VA+1Mvnw7IDZrJyY857d1VQMIOK5i0zJN/e8hXuCxMZoXHeonR5Tm4lFR9yZCdMuMRMe2qhu/vwqeE4Q50sOvw0Vjuhm0cAdc2O+xNvRp474nxBBXWHDVx2Hgkhnixp2FKqAtH/WKWf7WzBFvpuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=piyJ9qXO8f3jQRVpFqDRLg61VwJUCReg20Z2ugU4fBo=;
 b=iccC4Vhm0gky8Sg08veaGXOaOoN+joFR3x2LzI+emS6BXkLcPUJopLdy1t+9GbZ3DILAhuzTVEhExlAWe9mrQWtSJGFVhN8GaiTcqKHuf/YGyVscSVdfUbe92xx7NEMJZeJTb+9H5jn1pt9QUG03mZAehfzXODikGvlM4gXKJsOSJWJaF39TnJ6iZSoy5ToZJkOzn6gqycZsPvALuqGPbvY6J+WPZNExG5r1VGXhIqZn/CKm0iL2Gf99R5OVPObHZTbuPBq2KkLY0/NB7seanzrhUcKwOnCxdcCHlWMaj/d4g4QLGc/fEnzxMGuidA1GNLZc6n6VWoYRvd0bHqIk4A==
Received: from SN1PR12CA0084.namprd12.prod.outlook.com (2603:10b6:802:21::19)
 by DS2PR12MB9800.namprd12.prod.outlook.com (2603:10b6:8:2b5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 16 Apr
 2026 21:27:34 +0000
Received: from SA2PEPF00003F67.namprd04.prod.outlook.com
 (2603:10b6:802:21:cafe::29) by SN1PR12CA0084.outlook.office365.com
 (2603:10b6:802:21::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.52 via Frontend Transport; Thu,
 16 Apr 2026 21:27:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00003F67.mail.protection.outlook.com (10.167.248.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Thu, 16 Apr 2026 21:27:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 16 Apr
 2026 14:27:22 -0700
Received: from dev.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 16 Apr
 2026 14:27:21 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <song@kernel.org>, <yukuai@fnnas.com>, <linan122@huawei.com>,
	<kbusch@kernel.org>, <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>
CC: <linux-raid@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
	<kmodukuri@nvidia.com>, Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH V3 3/3] nvme-multipath: enable PCI P2PDMA for multipath devices
Date: Thu, 16 Apr 2026 14:26:33 -0700
Message-ID: <20260416212633.72650-4-kch@nvidia.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260416212633.72650-1-kch@nvidia.com>
References: <20260416212633.72650-1-kch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F67:EE_|DS2PR12MB9800:EE_
X-MS-Office365-Filtering-Correlation-Id: a7f6cadf-b263-407f-5e53-08de9bfef968
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	nPHIVRjY1H0q1SzhOdgL1ZPGs5DcwX7C7jMGtRnNucq501rEbocL+IELjCFK1uMlHGUNKnoy4vUKKKiHeRvtvYDE2iNtJ4Ke71RVDE7aalqx2/QYz869NBJwPViyN2de57BOFMOpyO4qHi0LH7RGuV3tIZj6+8rgQioV+mDmCM4L97cB6vJ+NpdPZITYqoBSNUWvPun1BpiNxxjb50iqy+Bzk7qeXAWUsoOQFyYSCm1O2UmMsiXyKdrRBAzcm7gtUnhSonVJ75vTOmx3m6yXZO9Tzz3iKnHAvB/gxDCRSoCWonX5DxaHmt24Al4LUMFufno6BNNkLW2s4QzMf39GorDziSAFD/R3pejGkbXuFJessvpWHj+h3OIZH7CqOueJavdKPbZkZMKISOeZ7BgsQ1L0zjxHVCDK7EZQd2bnlbIQfpJ++X68BqyUNe5j3nxyWXD+TeGSmd9M+AabcrBaI+dunScAViBF2WR6eZtes/kHdq0CHDcN/6oYhPHHOkK4MRjFw3CLRO+HY5HbdOZJnRdrqqn30UxgFVIqqiueguRRmjQNszL8H5X4LTDbkufoFbXQEyTg0n0qj4tcDUCPSHAoO9FajNz9xNn8CJrLNa/9+7+CSPKP/zht8aufwj4vKCGJUOgexT+auJIkuBWe/UvjmdWUR5cUOBneRje3QmFrbpmZL55HA7Gf/s3G/Yvqh0n05Seic9yAyzFgl2JwTTBweSWsN7pckQFkIDRYDi+vxegkgIiVGx4nQXbDhjRLE5GT71qSVQNK4jyg3lCrOA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	y0rhCTqaa2uekZGEQGeLFiveBrzYkokgCvKbCGdGO2TiumCoLIvzuVm4F2N5dVpb+sBAhUZEQCOOUHV6FO8+ZC+dHL4HjRGfCQtQFsHQCcIYg9v1lOiu3tcX2T/v9Q717SXaaCywXqBPAbiD7ZtJA+tgDvPyk+IDwMjDvNDe7q1s4ftW5bXDUoYnGa6OD4RVs24EvhFxLZXaxf/b2pG4zPM/0iq2OFEbFsV1V/DYEbKq6Cst60jObE/i5NnvtI77R+uvZ4hBeqZvjXZlfpYzT0QHGy9xlYmwmqWv7EBkucuAfI3HTgO8W0CmkJMg0Qhd5ltJJ3qkYoSJLryUUml5CtIdJUZewyjTqTrqu7pKzwin0OU4+9/1EuNN3fVyClDHGZz6P6C2OvZ9Ij0fn0bd2+y10KXA9LwJreHZgItvDg7FWXUrMoCc2BkYfadEdBQD
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 21:27:34.0094
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7f6cadf-b263-407f-5e53-08de9bfef968
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F67.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9800

From: Kiran Kumar Modukuri <kmodukuri@nvidia.com>

NVMe multipath does not expose BLK_FEAT_PCI_P2PDMA on the head disk
even when all underlying controllers support it.

Set BLK_FEAT_PCI_P2PDMA unconditionally in nvme_mpath_alloc_disk()
alongside the other features.  nvme_update_ns_info_block() already
calls queue_limits_stack_bdev() to stack each path's limits onto the
head disk, which routes through blk_stack_limits().  The core now
clears BLK_FEAT_PCI_P2PDMA automatically if any path (e.g., FC) does
not support it, consistent with how BLK_FEAT_NOWAIT and BLK_FEAT_POLL
are handled.

Signed-off-by: Kiran Kumar Modukuri <kmodukuri@nvidia.com>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/multipath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index ba00f0b72b85..957e39c4795d 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -734,7 +734,7 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
 	blk_set_stacking_limits(&lim);
 	lim.dma_alignment = 3;
 	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
-		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
+		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES | BLK_FEAT_PCI_P2PDMA;
 	if (head->ids.csi == NVME_CSI_ZNS)
 		lim.features |= BLK_FEAT_ZONED;
 
-- 
2.39.5

