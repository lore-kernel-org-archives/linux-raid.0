Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013021.outbound.protection.outlook.com [40.107.201.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94F827456;
	Wed, 11 Feb 2026 20:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770842755; cv=fail; b=Urmy/m2/Xtv8XaJfp/kimExGq9HyDy9greInGk1ie0oue1/A5cvVW8cx2X8aj5aU7AhygWLQRX3z5aA8hrXLCpDC1MXeEinGUVnkFnEeXMzfrVNwKFX2C/lIRS7XXouOujZpGV0hcj8dg2AbkqW+W4ucBbsCeqMLDPfhIoW/m2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770842755; c=relaxed/simple;
	bh=MuHtsMv3Cc/0AZso+Hx/IXxNwiRZFAMvLEBpEXP58Ys=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=is9qy42BYKybC1aT1UoByEtAak+xWaEu2EtCc29wP8KZ18pvFSOEyFgJH9KWke03REa46Pw4H1wWaF04lECTwxn0BxLs2f6wyNz0TOM82FInRhUtN1J0C5fhOTuEcJ2P1uIieriHxlzgYgtaLcibYdXB7TbDgUuLFcvBa5zNhr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Lqs6Ia7R; arc=fail smtp.client-ip=40.107.201.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Lqs6Ia7R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NjoWPDGXN0wc7AB76ZZl85t+80tqUqMlH3WDFnl9BgOWI3malcRPZMBws5w7upFE9Lj/+33CDNWyQsdlvbJoOxEjmoMg/T7lHK+lAqMY4fYWXbFoPxIwMbbg0fL/OVyKFag0gK/+aT/yoRII/tmqUSYA5M36EZTfunrUoj0qQxu+uxWVNJzAsACMz+/8470TAnIpB3iyXD6LSLy6OHYmAjsAyiQWgE9sZhyJdkoQa5+/pDHx+UParm1ICLZNhK3OvFh/YE9svsPKPvhtSs5td3v0NI1NQE0KSzf53/xC62hUmoEzgCauwE1XfkynTYr9nGmUPsmppolgx3Rk39Ih0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gm+SHR6hjOdFjx29lbMiq52v8qh7vUylwDUy4v2y0gU=;
 b=CWNV+VwHYXudrYzJ4dps3Y+6pJPfgc4zvZDdViX55puxJQYIMBohmXqlg46g6VNHumNpXmzmjWRpH8BNzKqQopXwzPwgcXZrff0nhVWkkcLo39TyxjypUZYowIdTBgrePvc5qrUbTsziHKfl/juIBo6yLCGVxv8Cj6qFhoTKd70AXFD3s+tg8Dc+g6MbRPo3zXxjfQF1PBoLI9bpqofG4kTCF4fjPyvLdyauPNStu+PJYIZQ3Vdb8UmyOnsUg+5nMV3MrIRIzJjx5vkaOR61ElQgs3gB4wJWfGvK2A7Ecx6LORdin2IB1jbl6XQYu35DB504+SksB9lIHOuHIRMikQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gm+SHR6hjOdFjx29lbMiq52v8qh7vUylwDUy4v2y0gU=;
 b=Lqs6Ia7RQKhvFixjF+ySoi8puKK5a0w78nIqqwCbTJTYDL3zpKf/zT4xCxREhsFZK8d62Zk2ztotvALSVcLoG6cRKz+k2XjBVzv8yBNwTgn1WJ0SpJ/JP/JXCAO0efO7GjirKc25szik1QI6kp4kxyHUm4FxIVE3VZnjBq0rPicDTuu/DgvvCcZIl3FhdKRcbIZYgqNOWRvV6zLQZfhA/Fhu+1DSQoC1Bs6JUBUyQOUF3Aom7HLKkYZQjsxXrBKK8YK52lqoExeEvnsgW3RXbVSVIdooGH5e66ywVxVewKImQrtDuUAfqjRy4pZCYg88vBvQ9cnLxeB2C88+Kbj3Fw==
Received: from SA0PR13CA0008.namprd13.prod.outlook.com (2603:10b6:806:130::13)
 by SJ5PPF4D350AC80.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::993) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Wed, 11 Feb
 2026 20:45:49 +0000
Received: from SN1PEPF00026369.namprd02.prod.outlook.com
 (2603:10b6:806:130:cafe::44) by SA0PR13CA0008.outlook.office365.com
 (2603:10b6:806:130::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.8 via Frontend Transport; Wed,
 11 Feb 2026 20:45:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF00026369.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Wed, 11 Feb 2026 20:45:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 11 Feb
 2026 12:45:21 -0800
Received: from dev.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 11 Feb
 2026 12:45:20 -0800
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <linan122@huawei.com>, <song@kernel.org>, <yukuai@fnnas.com>,
	<hch@lst.de>, <sagi@grimberg.me>, <axboe@kernel.dk>
CC: <linux-raid@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
	<linux-block@vger.kernel.org>, Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH V4 3/3] block: change return type to void
Date: Wed, 11 Feb 2026 12:44:38 -0800
Message-ID: <20260211204438.22568-4-kch@nvidia.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260211204438.22568-1-kch@nvidia.com>
References: <20260211204438.22568-1-kch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00026369:EE_|SJ5PPF4D350AC80:EE_
X-MS-Office365-Filtering-Correlation-Id: f9608228-5252-43a8-45be-08de69ae88c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/RMr/3J5UdAccGnj5o22UmKnVfq3G6Hqo/GeOIJlAm2gxqZaCbXWQw9Z2HY6?=
 =?us-ascii?Q?xutMAsm1FB4qEDcFYAKzjissS4SRYo0CymRy79G7Q3HTbWE3LvNCQ2kP+Zfa?=
 =?us-ascii?Q?iRo/U26XbU+f0t1FrrOLNVOyc3p3igP6WdJngejF+a5Q+oQLR+NnJvrTrU23?=
 =?us-ascii?Q?8RXo6BfG7b/PsiPnG5mBnwSDoz0FpfumhsmEfJ+1xgZm9TOlscO+c/HHbngy?=
 =?us-ascii?Q?B7m0dGB9bAXAleNuQu1C30q6glP/pkTQcX7QJFC7aiDYWHSA609VBk29DgQW?=
 =?us-ascii?Q?8pF5FcA4B6D1s5ybx0vtwGBwZud1Y07zpj1W0dOKiTlTsDm+Z9VMceJkwQyJ?=
 =?us-ascii?Q?O0ttGVm9iXNxrnHKRNWO64pOPRWTzkMvP8m19laIH9kM+aZUsrTzXxvIhrCx?=
 =?us-ascii?Q?y/dmLhXGRzzEOLuV8SybTvSvUqATqfPMyZjhcO+d73X14wXRJkI8jVnnvVPi?=
 =?us-ascii?Q?K784UbaUt70SaYfY5157DvAHhH7N8yx/Xcx8+t1W7v9OkPAr49fgAhcLYRSG?=
 =?us-ascii?Q?zYalaw32ghiFDo5yqo5NNg3MjlMwtOtCAZoFeEGj+KiTiE8+pT8UF6sIR0E1?=
 =?us-ascii?Q?31G/JK/AwjGPDLsCUbHaUDyxybmaNOjBTvDC48ONnZ7dlXlW/vumDl7YyhPf?=
 =?us-ascii?Q?fDw5lppUQKuhrJdD7dlbyKcL6Ntn8lpp9d+qIMxU9pksPpnErV2S6MKbTBF7?=
 =?us-ascii?Q?RWCMr9xB334WULMiVudMKQkiW0g9exNb1I02ismDnTDAGzASMDLY9cCME1jP?=
 =?us-ascii?Q?YHHKN/EzfRfvkoQQTVRK+vYeWh+go1p6eS4Zzrwe9hrciyGW91pT3Dkj81Bv?=
 =?us-ascii?Q?BeTcF9dwyF9vOrcBPPcrcdjTw7wZ7VxLeK0g586N3rHNW8j48r7PsZh9bY8c?=
 =?us-ascii?Q?V4rQrbwoXaVEt0g2V5DwVtZh1N4iHD6MUjF+2X6Wd0aQU/VTp/6b79uHpWfz?=
 =?us-ascii?Q?c74oWnEI9Wr20vwG7wAbsqRR0K9DraI8eT5qqRtAORDWipgwAQAeV8uT/j6Y?=
 =?us-ascii?Q?niTIYMhUOt8tkpSWGb2CC5p3jRYz+yaDE7+1EcwqQSdEtGW+P/HCa+aNTjXg?=
 =?us-ascii?Q?52B1XaXghbdJKwldF/GGhioalHAl6TBTO29zZs4+TLXgrw44sA2QTQypFZsM?=
 =?us-ascii?Q?tWC9uyhUsZMXGXA3n90tSASWtT1c9fxuYPmNtbDkAsEjhYhu+OGOSRzOHgSE?=
 =?us-ascii?Q?8ZFyyJW54f+zSoKA4gubkv1vZ95WRVzmwSDHQktGc+fIecdBl8nqsQ54f1Ik?=
 =?us-ascii?Q?cdnYR2wJmtxbWXzzE7ND3VLklGKP497z6M//JnYHx/cvWgJOVwKvftva6cFk?=
 =?us-ascii?Q?r/0F2xDj0/GIGvTA9LsJrsSzVHBE6U3Jq8mLGL25yD2XuiEk6kWdCTws8Xit?=
 =?us-ascii?Q?0DCPigmh1DBBOJFoiTel3Lmuwvqx4o4schSU9XssQHLVacK0g8uscuzoN0Rl?=
 =?us-ascii?Q?NV64yEjK30hod7n1RzLLKs7K/c1wn30e4CaySob0rhMaT0xH8qV9vG7SLBDU?=
 =?us-ascii?Q?I7Grf8EtRZLPYW9jBRL5+3isv7+Cx7+yVxOaQYPDJsOBvPsZfwB5mC802Fip?=
 =?us-ascii?Q?JcgOcGZNlrIhY2jMahgupXseMPA6hJe3XQJiC99NUtyicjUQBX0ew0kbuZsQ?=
 =?us-ascii?Q?00iZoHDpb+iCQ+3Red7OfdrhyXkRbaf9sV4UEwI2MUsIjfrq8qeuQBsDRJ9j?=
 =?us-ascii?Q?qJQQ7Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SHCHm7vHXgVxhEbYQZRYqUEfCChnnKNSsPAyr2bMNiAH6qkvqn7AQhlsD9tfT7R9wFb6mqKhymm9XBGGNP0e9zOYZ5YvridwCuMQvCFd8dNt5oPjgBp7L0X4rTi1pk6ydJhWnn1JwirIWOk4sV4+yvC/8pKF1K0f6reF5EOZOe5joz5nYBvWCuE5pUL0PmaKy1GLNJc9ugRmOMjCLMMfi2TKfuD58Cq5V2eLpzi/kMN/atUShi/LacfIxserGDg3HAQt2Te6PnD2OZ7KL+ovqzUM1e6A/R7mkS6hA3Mk/cbVkTskpzbhTU6laplvLqztFx5qkqyfg/CtOKtOpHf3gBFTBKL99CUm3gQVM/aMTPJHLn1PtCWXhC1OA8m9tYSbt5j9EuEdpC9Df0gqYS5vLTQVRG6qzdqbtVK5vWsCdZd7gK4aHh1do4LP57wXAnCP
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 20:45:47.1860
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9608228-5252-43a8-45be-08de69ae88c9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026369.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF4D350AC80

Now that all the callers of __blkdev_issue_discard() have been changed
to ignore its return value, change its return type from int to void.

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 block/blk-lib.c        | 3 +--
 include/linux/blkdev.h | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 0be3acdc3eb5..3213afc7f0d5 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -60,7 +60,7 @@ struct bio *blk_alloc_discard_bio(struct block_device *bdev,
 	return bio;
 }
 
-int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
+void __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop)
 {
 	struct bio *bio;
@@ -68,7 +68,6 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	while ((bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects,
 			gfp_mask)))
 		*biop = bio_chain_and_submit(*biop, bio);
-	return 0;
 }
 EXPORT_SYMBOL(__blkdev_issue_discard);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2ae4c45e4959..5ac4c7f2c2c0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1258,7 +1258,7 @@ extern void blk_io_schedule(void);
 
 int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask);
-int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
+void __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop);
 int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp);
-- 
2.39.5

