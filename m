Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010009.outbound.protection.outlook.com [52.101.201.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2309C38AC8A
	for <linux-raid@vger.kernel.org>; Thu, 16 Apr 2026 21:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776374851; cv=fail; b=erM+jjqUpo54owryN+U5+CU6AgPBIjVo6QyLq8QX3V19p8nI/rN5FrnvoH5tx9FWW1Cs2tJ+L1mWbtNA+yvVgXGFnJJgwP2ia9vw4DeD7DsaCpzZ23k8a6ZCwOiBOOCNmse+v4WSrJR9Su8cKyJiWSDhUPQqdmd81/7zF0k8cyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776374851; c=relaxed/simple;
	bh=Qih3Y98p1e+CAirzjnWLfj3TNppqAxqCYfC4j8eQouU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KWYa1oFbP5FZNUR6gjOUIQujyYIJRHMbxL+iWDp9cAtPtUxB4yaKb30kCZaOR9zRDDLLjVxkUOKi3WZbrR/t+hNw/S3N9leUKnJ9DRMrl1V4AuOaUKH4QWlUrJXX27A2sBRYD+WhCUlvIJLZ14yhJBb+GIo82LTGz46MArQaq0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CQcj8goy; arc=fail smtp.client-ip=52.101.201.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CQcj8goy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i5cEVxF+8yGEM3QhYVXObFniDOGM4hCnvr+Nu6+3UQpbWa6Gc5cis0jKu+85hG5krOcKrgqnNi02KGq6dt0sn6+4jkymChPfO59+kylvG+eiRprdpD62rqvTmjVZ2IM1RbHjlluMm+kImaroCBjx3g/kcDG9oH38QKUouFlGlbyrcuFpCvLh5cLEZDinlBGGMq5BrTC9uhMojg4Nu6pqQhJ70fH0EbhRKNYCDMLxvBvS6Q99WvsZ7JZ2qM9MmlJNr92z24VK68nMjLzRFQMhlQhpWNrqV1x+5d0Ws//utHxCteoz99Av43WHsqJFpakhdmKYWI74paBHnUU+v8650g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lTTupWONhld9iSlcHBkNgvI7dWto0KuO8DMf6t8Zuzg=;
 b=uZqJ8vHYtIkErnwNDOsj0e6QKDHzLG6fh3qbJnucfxYgV9gSOMedJfZ+qVvGr09X+aAlOREU4jjl+0thZwmHe1EwXTuJiXH+leiyb/ol2954FRAEmKWKCND5tmviHl9zggryDgPDkqAk9w4BJvg34DU6unpJ+p9MdROgTfVCfEd9Aj5zW8FCz+2sE6H3bJUpdW43ZJUxJLcFIeNRd8AQSPPu8k1hKxP7CjjuKFMFpjOMdkbvYG5TOEHU/t5mL92XmakPJ6UnNH2PbpudwpYhJPO30FRfFEoG7rPeMA4O2KB3lIdrvCQlHsJPi7ZxlPoTkMOsomzm9jIeg0M/ZZJXNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTTupWONhld9iSlcHBkNgvI7dWto0KuO8DMf6t8Zuzg=;
 b=CQcj8goyoX7wh5dzb7aZYVz1KAcrgXgSSF7miSrGsAP6BlSBhCw+vWbMFxyb/tVVMmaAKAgNZmgr3zZBvX0OdPNN6DzBR0aiVoZOwsNNtMqWQ6t2AY3yArsTM2bHf+XV1OC9zbW559Lx5WOn6lpYWDeZLoYVSpIj075eU3g2X0aIOCPHaxjoX9StWB6SJZ1/yRxJzEYUqdsV8GklDYtJz2M5X3X0BHjaK5qnOQr4JsV53LJx2ryw773e4/q1RPjOVmJXLn0cTbF6yuKORKSmVI4SYJwIiALhXfl6UFq3ZP2R0Ip9whPibXUfpVUr1Am4CjTAPnRt9Gg0B2CSTBBzRg==
Received: from SN7PR04CA0111.namprd04.prod.outlook.com (2603:10b6:806:122::26)
 by MW6PR12MB7088.namprd12.prod.outlook.com (2603:10b6:303:238::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 16 Apr
 2026 21:27:26 +0000
Received: from SA2PEPF00003F66.namprd04.prod.outlook.com
 (2603:10b6:806:122:cafe::59) by SN7PR04CA0111.outlook.office365.com
 (2603:10b6:806:122::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.52 via Frontend Transport; Thu,
 16 Apr 2026 21:27:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00003F66.mail.protection.outlook.com (10.167.248.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Thu, 16 Apr 2026 21:27:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 16 Apr
 2026 14:27:10 -0700
Received: from dev.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 16 Apr
 2026 14:27:09 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <song@kernel.org>, <yukuai@fnnas.com>, <linan122@huawei.com>,
	<kbusch@kernel.org>, <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>
CC: <linux-raid@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
	<kmodukuri@nvidia.com>, Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH V3 2/3] md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device
Date: Thu, 16 Apr 2026 14:26:32 -0700
Message-ID: <20260416212633.72650-3-kch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F66:EE_|MW6PR12MB7088:EE_
X-MS-Office365-Filtering-Correlation-Id: b9ab3924-0f74-47cb-6341-08de9bfef462
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|82310400026|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ljLcYu20fOiMuWIofXj18qRE/Em0c57cMrVJoXucc/J65o1pwThLkfJq2AvhZOzRhwSjJIte8K7aDC067REJ58QCiu+ljcws/FNv4XR0VAl+zLAcCMZ8OxOKgevo0L/Ki9NzW2Hrrbu0RQFPy+y3JJb7tsHMz+MTiIXr8Y8qdTXnjXX80AmcTGc4Z5TUq/QoDko2KWtD/1BMsz/ulzsZSp7wYKNk2psVZxHfgdQQ4lEfpbsxqWmB3WO/iDoHuN/C4h+8vsDgF/IRN3lZz0ZTwkWknURLVc+SXRWuRk8FXm+W0maHQfn8LscY/AwXhuhwkdSeSf27MgPw30W62cDu07mpkY4UMJIpg+4vCqakE+mcpJ59uFcyDGFYcsyFcFmOJgOWvy+vlpi6V+Se5DR5iPWzWYH63NI6TCzEbmqmUCvHNZRrfKFt1pPIhCOHjyn6UW9M3xCJY8X+w4DDF108o7h6A5RSAxRmJ093f0gTkLeDk+hmuSWVhFJqanKqpCM8/BL0R6Fk8Trjlr2yFs1vF+GP4jkNN0v3bN8AlCDRRbIDXXRpH/DIlgAsni22pM344vKtv9RLXh8y+tcu58IENA6M4AN3PHujeqOWP0eY6ZsN3AzyW1bZyEX2Wq/xLL7ggywxS3xJtAi+Kut2HGjHkpI9v/lrzYzP0EwoqmI0Gy6QKHK9CMPiIombVM2Et9wwmZU1IY7myu/qsKxzBrdeMhO87jlfQ0C8kua9Fq1FuNYzgatVZ8QELCm/3r3bbwpjJ2Pc91y63Cd+BdoQQqqyxw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(82310400026)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2TI8zW0jFhQZwVBRiyAsj0NpIx6qKYUuUb0AF8kqy8nr0ljT6+03YlHJU3vz1jgwa72v7bck3RZinrBdsiacRuKiL1iwGrGkOc78+D22YKWjotNNxfwowyhKDNI1OfrvEDUkYRTtN3Z7aNpubKwiFcx1EAZvbsbufNvELn/mnDhz/4Z7UDkN5GDjrrjuvy39SkD6CswnegMf0wkxXENF/FT9K2iUXr2bh7gZn+Ctv1jFvAfzm8OWKNaWAiMTjSajRzN+Jd81+iH/ssdqijTXFRQ0WfXThPc+LqM6YX831Q/Me/cWCNKeDW+FXgs0YNoxNDgSXU3Hzh6/Wg+NIjHC0aVcU4se6OxMcsgmRhEBGoY+lWSVkX1rp/lh5GZl0y0SodAC5Ahfcy/M5cXeuIFOftTT6eODI2v6uBbxwL8Eso4YcPBFUg+btnUkIXnzfUs/
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 21:27:25.5971
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ab3924-0f74-47cb-6341-08de9bfef462
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F66.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7088

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
index ba91f7e61920..422ad4786569 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3215,6 +3215,7 @@ static int raid1_set_limits(struct mddev *mddev)
 	lim.max_hw_wzeroes_unmap_sectors = 0;
 	lim.logical_block_size = mddev->logical_block_size;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
+	lim.features |= BLK_FEAT_PCI_P2PDMA;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
 		return err;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 4901ebe45c87..07a5b734c8f3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3939,6 +3939,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
+	lim.features |= BLK_FEAT_PCI_P2PDMA;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
 		return err;
-- 
2.39.5

