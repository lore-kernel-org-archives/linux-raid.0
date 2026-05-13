Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012023.outbound.protection.outlook.com [40.93.195.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87CF34E766;
	Wed, 13 May 2026 18:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778698399; cv=fail; b=gxfHFwmCz48CVPMpbtwA5Kbhbxznv8bqXnJLZMBXTKA2OQk6ykPGv7G75k6GslG1x1rHlAapHDxQAp/UozoCaUpIkRojcJtSGkkhZd4jFtoARPUp3Tr1Jb3cBlDXFaj2CxaDfxf1sV22cVn8AVlolJllfmEHeHfLeBeOQJYA2Vc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778698399; c=relaxed/simple;
	bh=KNbfCIQ5x72m9fBa2xh07ew1E+P7V85TM5xmOtyb8sg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d2xflKQJdHle3DcXAoLoVhGM8fvaLvU67WBRQsSmBZqTaui1Bn2/kW6aErS+4jxcPPKloiSMTkAzyYVlmsz8N4DBNfjnZznB9hNJfPHi7I/DnA5kKpmcdMDKzm8QE+gxfvhiQx1Pt/kDRaE6c0RpnNxgJSisWBIgpEdECowfK94=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P6mMbQgy; arc=fail smtp.client-ip=40.93.195.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P6mMbQgy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KvPGRWXokbmueN8I7IVveQfAP4Ccq7+SYKPl9DPYnpZ1oGnrZhYRsyoleyCDIkTkY+LpyE3vmZbg+qZ8DQSytSZ+p5LWsJ/08AwDX6Sf86F6b48a6ksIqUOpDX0f/xvuIc4BJFYWJlIFmXwvqywI2pIvBC5ssIcfUMwWgQAWTXNzsZIVGEe2JEeoBPHoBes4F1qW8fvzrvmSGAYHSEIuzSvzO7xinzJ0qd75XWHq5IGW6if+yEORqVK7KOGMsVTmleZmjjH/wNPvDZXPBEkZqEoyp7KNTIgCjcdXTXZ3ku7lqgtDG14Hk9bLfXS6unsN/RrvDZ/vhi4/MZyvmdIiaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=it5pgiQP2AQNEq6tIMXiESTFgQK9HFXFMZmKNofoTSo=;
 b=dFyJqDpsYOfKy9mUpsksFwh8GtT5BbbWFtN5hiEatCKZ8AGfSd9GqNpgUqrBfatr6TrUDYgJPwweRpR64GsH+qQxCnejKFOtFjL4fDn5pK0bcGK7oHlVg/q9LGFWkV/kzEpkdyny1kyVYfWOZ4P4iQpHQpYOa4J4F1SLkCwZ0L4gH+OcwvJ6DOvWwQ6trvgYH9sRgpoiOm5GWFQ0ntGZo0oKDeYxFflhfCt89hyaCnpsSbpDSXCeZIL1585Cuc09kRtAFhna0DQ+yNN+WcxPUtum4nGJv74rlXQzIYk+OPQYViaiiz02DTLaQlT1lIPS0dYS/6tF/3d1W4jCmv8qrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=it5pgiQP2AQNEq6tIMXiESTFgQK9HFXFMZmKNofoTSo=;
 b=P6mMbQgy0k8PGJEuH+SM5FLNosdvm5+sl238t8pTR2tcmQ0wwoDU+qLyAVfpxIm6FjYDawhoHzvlZefqjHtPq027J0vWg+ySvHcDcmj1bpo15G0yOncvd0ZxFwzkNklD6Sk5RSrYXgJMzPl3GOrKYEG8hHkQtcgVSKCH9IhG6TK/GpgirG2SGWYh7XQFca0hgS3OT6SLvz15QQlRMEOxMqBOGrg9g7VpkibBE0mAkoV+nEd+qIUpp0OHZXChwx4qTFqYQk6NdKsHwVL4y1FqCYfPFD9tQxLcvKJ94VTSBSUBQdw1PB2rJK9cmqnzArCm49XG8C2vxJtbTLj1VReSPg==
Received: from CH2PR20CA0008.namprd20.prod.outlook.com (2603:10b6:610:58::18)
 by PH7PR12MB6667.namprd12.prod.outlook.com (2603:10b6:510:1a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Wed, 13 May
 2026 18:53:13 +0000
Received: from CH2PEPF0000013F.namprd02.prod.outlook.com
 (2603:10b6:610:58:cafe::21) by CH2PR20CA0008.outlook.office365.com
 (2603:10b6:610:58::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9913.12 via Frontend Transport; Wed,
 13 May 2026 18:53:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000013F.mail.protection.outlook.com (10.167.244.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Wed, 13 May 2026 18:53:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 13 May
 2026 11:52:48 -0700
Received: from dev.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 13 May
 2026 11:52:47 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <song@kernel.org>, <yukuai@fnnas.com>, <linan122@huawei.com>,
	<kbusch@kernel.org>, <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>
CC: <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>,
	<linux-nvme@lists.infradead.org>, <kmodukuri@nvidia.com>, Pranjal Shrivastava
	<praan@google.com>, Nitesh Shetty <nj.shetty@samsung.com>, Chaitanya Kulkarni
	<kch@nvidia.com>
Subject: [PATCH V4 3/3] nvme-multipath: enable PCI P2PDMA for multipath devices
Date: Wed, 13 May 2026 11:51:53 -0700
Message-ID: <20260513185153.95552-4-kch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013F:EE_|PH7PR12MB6667:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a0e1a8b-a058-4c30-df36-08deb120e2aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700016|11063799003|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	JHuRlVEr0XxWsLyVu5CRlwUNfkjtNOIFNlJAasYm0KaUhPbHAMrr1BYtzJAtSLUbdBsDKolBTpQ9uWhXsteiDUqFB6EiURk1BYJ0JJbdMVbQS1bQAJWam0XbvSYdsIfTKNcrAVDoIYOsvQZscR3psB+7SWa4hb9dMd/SPYY9E4pHkz94D/Cvls2QzJ/bXeYEIT+yCkg/M01QzfuZBtPHWLJGaVml+wyef2bN1bL3AQ/MU6a1+eT9Pa1r2p4/wZ8QMFeRWKQQH/RsOBrGkLkh4Z5vOmQx7ve42LTHF4wThytIqc30a6LSX79XrfBkAvvuqnDOFilTen8goiUgioLeT+6r97mBWv60A8be5Y/lxB/1Fh3tUlHne84Vz/4ZaF2LHyLCHnVtdMo6lEi51lYkI0Xs2ZOeXX82STXqs0LXDvtDJ6BEV6+7jhnNHyusj2iwNg2O/wBhK9wynR/si5lJQzuujXK0d1Y7o1NFp5wCF7W+yyoKKA0bvNlKaHyYFOqaJgLOjqBAFWxCrKhNDwd0fKWqVnxYojfGqoei4ous0gJ/vBdPvBZH15NoiNTgLpUtNaq+lHHxPevaC03b95vXfBrv8pnZOl7gcHMQZDfWp6iA5XeC4P5xBSTawrMj7PYYAntdtmiVvrJXndkrR8kPHXLDGMkEbYR6VnFiIvpDNYRgfrmuoSBcbifAVVgpTAVi8TtHS4qxoH2HxZNLoQpa9Jo9sbL4WGIFPWZ0jrTadsc=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700016)(11063799003)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	y3uMcUwrKTj8/Uq5E0ElshR1Q1yg+WF03x3SaGFXv1vyrR3+3YPgKgp5BcSpJZ5CQ2gAnnlFA9kTfZyzByPEejI2Om94ABJUcdC4ePraP3AkrW5lLc+iAmxxhpZwfO9s3Xsavso0IPjIU2E/bceraweE1MfoCZjaDWviAVxG0X8NvOMbXSu4Sl0egWESwZJaaFqzXPAPhIC5KZ/f3VpFL4tNbqPsj8i+yf+c3Rkwx+Pqvj79LOShTYEd9CcImK22pzCOWY3w0YO+DaF14wz/smugGUfYDVY+tJsJBAsdLjxtxPHusslsF93m3weo3mFZ0GFCJ+DBXhy9VO3REH/KllGiX56HuPBnLc/BZ3Bb/0UoGFYNiPCHRL0FnbNCKYGw5kEbJtprPvS0b4UBSG1aAgNpzUA601FYG7fPETWGVFb0WwTgbUyEIxwTfLZuBIuN
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 18:53:13.1461
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a0e1a8b-a058-4c30-df36-08deb120e2aa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6667

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

Tested-by: Pranjal Shrivastava<praan@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Kiran Kumar Modukuri <kmodukuri@nvidia.com>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/multipath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 263161cb8ac0..ff442bbf2937 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -730,7 +730,7 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
 	blk_set_stacking_limits(&lim);
 	lim.dma_alignment = 3;
 	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
-		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
+		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES | BLK_FEAT_PCI_P2PDMA;
 	if (head->ids.csi == NVME_CSI_ZNS)
 		lim.features |= BLK_FEAT_ZONED;
 
-- 
2.39.5

