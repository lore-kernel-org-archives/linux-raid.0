Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010002.outbound.protection.outlook.com [52.101.201.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C4138B15D
	for <linux-raid@vger.kernel.org>; Thu, 16 Apr 2026 21:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776374841; cv=fail; b=syGifYM8iC6WFRx+qFiOo3EMWO5DdbwX+iywgJBBPu30oIR0SFuzrv9xAs+C5PdBqb9Yx6obQ2IFszgbHiQU20tKnuLA0rzs+MI4GKqf1MocRi5OPcbbSTrDoK/t2T3cnlw6FjxxLbcEwObMYC1KEEudYY64HtOBXfShfv866Yw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776374841; c=relaxed/simple;
	bh=I9+SNDrp6JZ8+dq21aHei1D7I6R2QhNEHDsqFHHV2ag=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TVQpZ9HX3pFAVhlqxdGdH40ZfyXEPRhNBLJNmgWUhRPgdM3qanU2gDub5N7w0FBiLmwpCa8smUMtQPmnjgn22zi2ywaW7cOIPh300bRcFnF4RDvFLzn3mTN9yQIWXpAo078PJHZmDXig8hHbjg7o5HLnrX1cUzYLHh0snbKcZJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q8mIRVvK; arc=fail smtp.client-ip=52.101.201.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q8mIRVvK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jZJKE7rhFtw9OoXEB6Zrb3/Oav9fEj7yMfUOm5XnF2IY9rpd5weCi5Fm3CbcJgNEBl4YwpbryLD1dvwBoLbTgBX02G2x2gZZ6uqSnGDhlutIRS5Trm0oEFnreMvXjYqsjv1mdEn63RC02Xcm1gICMM1zURDJLj3WXg/yluD8tCc5GY0FO++ix5Sj9KUP9dbDfq1l4eVYcLEIOQBxsWujBInmbcDtFClH7ysSfixlTBMMfU/bIRQWQA1ZVKkyXPJPh+Zl4s2oJV16vD8jF9p1+uO+dpPLblLe6APHPgMidCiHw3tEJe+EgSaMDuJMM/P3jBppiTWLyLjtKKkfo0rVpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+0H9xYnQVbRRlMJyvE2CMbDjhxY5aB5WnjKPlwEy1EE=;
 b=YpHviKUGqGv79PZPx8iX5B19dNuC5HsdQ9lmk1Z0+32kHWbWFfpIVLzECkwhPd03B0TXqdBO7XFiQB+5KV1eOK+2qsLseIBEX1luaJezhRLwbGBhj70qMBlUWO7bKEbc0clSrmBYTPjYA+e+U9F7z/sihCLmJDmW2dMulIYXxCmuJly8N7O0hWHk6W+JZ37MCYcZN9BOkeUUBwIq8qYRfnoxDK020ci62W+e+9Vxr7tDDexEQhzCPaj00DUWuCoOLTP0Wc4axuTfoDjP8e3jH2WJNwYuzB8FGPAVsHsvvbkXHsY9zD2R0EXJdX6qjdErChDAPS/dqIcyxptdEaZPIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0H9xYnQVbRRlMJyvE2CMbDjhxY5aB5WnjKPlwEy1EE=;
 b=q8mIRVvKVNS61kPrSzDoR5mYZ+GMTusrmNEvybAg0QlQI/bgYJ3YfOCfl7B8/X+Ex7Prr8C+b2C9nNwZhcKNMoS43Y6dhDxsBwUM4nd1EQEf3LTR7iP6LFm3HY3k8qPGhi+OoDeIrc0Bm3AtDkCccm/tw2V969VShSTdn/HPyd5KeurDg0CvA79vA0+/v15Q1CrjnE8UkWYiExkBL2ke/NXic1o/lVHP/7pwi0zLZEXBDVEU0O7Mg26U1892cOdJ2rJ4kQx1nT0H2HO2q85k2PRzVKl8lCLPpN/aeUXQGX0ujqp5Q31eyJDufDpv7Ed9aO57GkHeo4Efj/Z8gseglw==
Received: from SN6PR08CA0029.namprd08.prod.outlook.com (2603:10b6:805:66::42)
 by IA1PR12MB8286.namprd12.prod.outlook.com (2603:10b6:208:3f8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Thu, 16 Apr
 2026 21:27:15 +0000
Received: from SA2PEPF00003F67.namprd04.prod.outlook.com
 (2603:10b6:805:66:cafe::b7) by SN6PR08CA0029.outlook.office365.com
 (2603:10b6:805:66::42) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.49 via Frontend Transport; Thu,
 16 Apr 2026 21:27:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00003F67.mail.protection.outlook.com (10.167.248.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Thu, 16 Apr 2026 21:27:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 16 Apr
 2026 14:26:59 -0700
Received: from dev.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 16 Apr
 2026 14:26:57 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <song@kernel.org>, <yukuai@fnnas.com>, <linan122@huawei.com>,
	<kbusch@kernel.org>, <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>
CC: <linux-raid@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
	<kmodukuri@nvidia.com>, Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH V3 1/3] block: clear BLK_FEAT_PCI_P2PDMA in blk_stack_limits() for non-supporting devices
Date: Thu, 16 Apr 2026 14:26:31 -0700
Message-ID: <20260416212633.72650-2-kch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F67:EE_|IA1PR12MB8286:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f8fd9ae-d79f-4535-55ea-08de9bfeedc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	s07B7QsVNPyFTRUciQdqZTQr/eWzNIYb2+YdUy1WixgSoxTjKVgZSXgwT035qwpUtQP83wTqxRV5BieS2tHMyOJ+Nd+P+0Elx+929CYABD066jxuaCoRnLZvbscJW7mvoddj83PZEkmcTsE/EYqwVp8A/VPE6m+hziRghrKW/JHAG8Qn8hnob/lXM2pJYrWRxEDo4YF9es6FaGc3nOIaW41u2ZSsVp74jXtzkhuAw6kr1MhOmgN5jFWCOefSTgos1ZkPj8Lk8efTLXSUzT3fbVL0JM9AcoFefM+yGeCM03voRA5ugxYJ5gHwzWjuBfhYgY2mXPnjNJncG9HIdiPX3Jls1F1rdbu/1pUhtlJ6QfNtQiw4vFfdRdXxuA9LMV9B3Xk7lemycWuAw0O3QfqvI72b7MENyHJA4nF4QTwm5nXMllrJ9X6Bit1UjQ7tcpxkxxmt6JUgkI7CK98SUnHdr5zH4n+s9PO5ri13sNlmkRSWB9z7okdUo7HYMMk8kM6IGham3/wwfKmMH7ebk+OwkTntMhqnpdxVaPSfHmRMFt6a8Gs9L4uPOy+1rPGvS8kXQe6hH24pF2sn1DS5SV977Cy902hUy75qRoey4nOo3accf91gNmWgY07PUeLnJNjuFiMkdeT6fpTVdQxfIZh1dpt3MoMm4IepQoDHGlqR3vBmj9Rgc2enM3FoE1ps15gpVUrh+EO0Y21kxcRCC7W6nk1Pkmndo3vxf8jKLoIaAtdJuSbbL3r5/FoE2u6sBGkBBpsgnEin86as3MrySh5Jsw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9XlRuFOEx+QnVuNHdjApyoMiCRT1e0dHEcyRCXdOHkYHoUif7bIsExaEYF9oisuN3FUj+uHoqD2p68c+1O1pNS0/0aM2xaP5Bui5+8KpWlaGMN2IAfY1D4PjPLSokNsqiFOE4gVM7ZbczGlO/ihnMFqzFYqWXPoDwj3EqapdKWIsVSk7ofyrX6Y4ZYiICh955alUGvFWWMMhPSLWGoTUeRzy8kJ/lp0ccyUBwsgyuD4wa8ezgyjsCI/gJ3qQmS5hcxNOUHlpQczZmeKOoLU4RAUasG5gBMtDo73KHoIpYHSdJ/e7TeAv+cEM12QPWpd8i31zcoGe/6qH4nTKSwBzSpxKkA/4nsiKGDjw4iHcq699pnCJaq71kqYYXyX+Xf6aRZuQhknUsuE0E6t6h/vGxnmZeS9UrkAWL1RTQAjFshyubQ6Wh+dPV7S0CT+vtCSD
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 21:27:14.4731
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f8fd9ae-d79f-4535-55ea-08de9bfeedc4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F67.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8286

BLK_FEAT_NOWAIT and BLK_FEAT_POLL are cleared in blk_stack_limits()
when an underlying device does not support them.  Apply the same
treatment to BLK_FEAT_PCI_P2PDMA: stacking drivers set it
unconditionally and rely on the core to clear it whenever a
non-supporting member device is stacked.

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 block/blk-settings.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 78c83817b9d3..8274631290db 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -795,6 +795,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		t->features &= ~BLK_FEAT_NOWAIT;
 	if (!(b->features & BLK_FEAT_POLL))
 		t->features &= ~BLK_FEAT_POLL;
+	if (!(b->features & BLK_FEAT_PCI_P2PDMA))
+		t->features &= ~BLK_FEAT_PCI_P2PDMA;
 
 	t->flags |= (b->flags & BLK_FLAG_MISALIGNED);
 
-- 
2.39.5

