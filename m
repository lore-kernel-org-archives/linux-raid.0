Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011032.outbound.protection.outlook.com [40.107.208.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249433845B9
	for <linux-raid@vger.kernel.org>; Mon, 23 Mar 2026 23:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774309505; cv=fail; b=u/gRrnfzb4EexWHXmxd8WL25BySQaSeNw4+niedwJcsN3aJsqWdxzKv1X/1iAQa/n1NMjRlAFcb/k1jkjeNfSWtjRxud/RYrxEA3cAf4tUlSLL1BORp6UFRjtytbjmIkKKlszl1NuTYhdr7lMo/kTAJBKH1y3uSkmLBiFzTG+68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774309505; c=relaxed/simple;
	bh=lV078kXIfz33ieRCgs3IP3W17oJpStYULOv5eelStSQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f3sgn+B9B0JFfWnDx9JAM7DpShDbmjiOEl8d8W8NbEpCmUXAVp0Seu0g5E7yxlf2wnMQIi84Mh5W8ynHJIC+2KC2bx94TC/B0q8b//G1nqreWu42PbEYOfvTe+6u2nv4fYnyM01N0lcmkuA7XG0IQDY6mA79GM7iVIxiBrXlpq4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hQTU3nok; arc=fail smtp.client-ip=40.107.208.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hQTU3nok"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ba0cuDaAyh84jfURlTQs0WgCml7b1x//rtpi0bMHgZzQZboMyB9IrCeIRiT0FM+Xgz/rpWM4EgZNg2ilEKOQXRT9t9NeGWHkaMyyWlTBVzu9FvzpX2Yv2ZXkIokuImGMtUv1j4TS7DfuLxDTBhEdKkLSYl1Gv5b2C93sgxhlnToosish8vx0ZDFJNw1Y6S3SY3nMgTLcL+KcVAdvKhd70w23+I2PsfFsUTh3ejZS68TlA5bmz3i08as9Lk9gDF3yLtmAaxiN+8qhssIxDf87BwBzK1YXhokmgTwPER1b5Dc5LN88ojQcuRCIyswma20BycRwpQd3tfldJiZX+MCC+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O86pjd7YnslFwn5wSM/HMUMF/cDtc2bzA0TP6DAJxfQ=;
 b=PPHtPhdCihDM3+QIUchQNchzUWcZQtEbvb09UAINGyITbBlECRGynlexnkWVKAIqlRO/3nnUQgedCBw+wKW8lHy/+arPTCfOl2hRQ7Dtst7UB4+NFATgx5n1fkSg0/EonRpLhnKXXqxfbqGeMd45qbuCN10icvZp6nm96N7jDeeML3GGPoPP76X56uBYtMJikuXp1JSLZY5oxsp020pI5ZZYm7kHd2trB/shKYSslQmU2snAdzEsqQLjMLuOWia+gRBH2wvoBf8ChLCxwFurcKZtw/7wPuu8nc7WN79lVR5qyewQ/l9cGqZwfrLKDnGOiPPBJkza+j/Cu6DKCcqycA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O86pjd7YnslFwn5wSM/HMUMF/cDtc2bzA0TP6DAJxfQ=;
 b=hQTU3nok225/8za2J06dlD4Mfo2t/mTZwkH6OeOB2+KRlPi+mIZOrFljyjrCMhmMtFebD4cj2ZSEMHJ2hPCcUGVJk/SYfjdoPxJfYKZs4XkcBYp+NeHOBQy3ajvYXr23JgWMpDhdjQ12wBl/bH4yz7R7SpMnW/AodMzyqScpZex/ypCNOifIiPtY61YYdCKlb7/EuoLm0qrN6rWI+Rdj8JrWyXLfrORih/CklXhFiZKE6Ad0Y5vcwhT2e16wCqhyUxsjnX8QLdJXRo9rTzWYGXbB6lIKA72fL/SHC8eUWpu+bUMfVUVlM+0t2sZn4iyUduWRYFInC7T54s1RZqgL9Q==
Received: from PH0PR07CA0116.namprd07.prod.outlook.com (2603:10b6:510:4::31)
 by CY1PR12MB9560.namprd12.prod.outlook.com (2603:10b6:930:fd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.15; Mon, 23 Mar
 2026 23:45:00 +0000
Received: from CY4PEPF0000E9CF.namprd03.prod.outlook.com
 (2603:10b6:510:4:cafe::73) by PH0PR07CA0116.outlook.office365.com
 (2603:10b6:510:4::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Mon,
 23 Mar 2026 23:44:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9CF.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Mon, 23 Mar 2026 23:44:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Mar
 2026 16:44:47 -0700
Received: from dev.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Mar
 2026 16:44:46 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <song@kernel.org>, <yukuai@fnnas.com>, <linan122@huawei.com>,
	<kbusch@kernel.org>, <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>
CC: <linux-raid@vger.kernel.org>, <linux-nvme@lists.infradead.org>, "Chaitanya
 Kulkarni" <kch@nvidia.com>, Kiran Kumar Modukuri <kmodukuri@nvidia.com>
Subject: [PATCH 2/2] nvme-multipath: enable PCI P2PDMA for multipath devices
Date: Mon, 23 Mar 2026 16:44:16 -0700
Message-ID: <20260323234416.46944-3-kch@nvidia.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260323234416.46944-1-kch@nvidia.com>
References: <20260323234416.46944-1-kch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CF:EE_|CY1PR12MB9560:EE_
X-MS-Office365-Filtering-Correlation-Id: b9a10294-3d3f-4120-2149-08de89363268
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	EvuM0cPjlfIDMy8ANl2iEff3Ozurk9X6lVdcOSFZnpZsS5r7+7D66LQdnYOPtpb3jO7reoXKppaWDN4uqhIefYeuG9JJdZXvr1lLwYIK0q9+bLPVb3ad4JjcnxfycF9wgkvnRs8WMANVStlF6SNQFUtLzHtUpjxUOWK7WcTN4+K4jBEK0528LZvM3M1MUevBu6qaouJojENNt1pHh5Oknrp36kxxJDZ1b4/ijHLxkhSOXZRqu1IglQnBiVUVwaJHDSoA2C2CuzrLzNz4ZJfaoTuoeHec1/8ZEWJNJYKUZCHHqbJKqorHKyEWTc51LsrDs8KDnsSmkDi7aMxTi+Rn8RsucXmYBZtA54psYikjOSRg01ukRSe74V2CLkviveFc4V8cAhmuyRNUOccTK03a85F6cpUJpda7s0nzKnbRNdqhtQL0FVPHFyh+OYCd2nwSgNPwlrLUIsTyrAlOW0SGv1xAwv/RcSCl4jBzPrdWuNcsyo4nsM6uGqQN7SAx13sl4TMYlO0neCXLo5Y9kOO5CI6RIyDJrnxOKTZ5h0oL6TZMmOyLFSAwOzfPNHBKgBmKJMPcLF5wxHIs+sdYE0wR/ZWXMqmV3nRY1moTt6jA1fKOOYB6BQepelrz6AqUwsybsNwpNLo/5Z1KwS0h+6S7IfUiRkySgJnUFpQPip5HMR6iGql/FWlfshUumlNCKn0twOQhQGH4Bf/EmOSyaevklJe3w5BQsyqHBvXarHbcJIeHLM8NpRMoTiC2VF51Ky12oORzoezO35X0F862zUujGQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oPjYe71FiBfylFfrMyO8pbEEz05o4+zObk8Hpwt7l5IJJuFyoHvSh48shcNBL1E28yKkqbJ8OW+liS86Pb1P3o7MKcjmk28Qq4vKziLPGnbuWQHXgLcAvRw5tQbsWtTl4cu8LvoKLuEGmaE72ezLaSC1EAVA82av+3YHex25JqZadVI29kx8li0SRtADVbDpRgQ8SaJsHMhF+qtFzuoEUCF8oOhMocoO9Hqy3ZOtmIZzw6CZIYKPG6ui4PfB0Ze1f9a9equyvKDdCUPcYFeTo8fB6tL8b2Xz6N/3EzWwHbg14FRm9PCB+l5P8+fkLkkC+3V2RNgQUgen3kAazlc1pNnvQXn/Jn1jzBtdpEZSftAlnnFo8bfv8vBHrjOdlj7WuMerhg70PC0Iw2XpAvBt/pLU2xFMzLaP7EoeeOIJ+ur++oy4iDx2rGmXNof0oWPY
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 23:44:59.9056
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9a10294-3d3f-4120-2149-08de89363268
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9CF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9560

NVMe multipath does not expose BLK_FEAT_PCI_P2PDMA on the head disk
even when the underlying controller supports it.

Set BLK_FEAT_PCI_P2PDMA in nvme_mpath_alloc_disk() when the controller
advertises P2PDMA support via ctrl->ops->supports_pci_p2pdma.

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Kiran Kumar Modukuri <kmodukuri@nvidia.com>
---
 drivers/nvme/host/multipath.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index ba00f0b72b85..c49fca43ef19 100644
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
-- 
2.39.5

