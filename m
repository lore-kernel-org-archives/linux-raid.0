Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012016.outbound.protection.outlook.com [40.93.195.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCF927456;
	Wed, 11 Feb 2026 20:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770842743; cv=fail; b=F2fVoywW5sIodn8Qs72U8Oyqh+Faf7w1552Kb8ZmrlX6xXigHop7RluI40HePvHZKezlMkPNixC/Dw6V0ZZWQDqsJuOYtTTVCvOOfNwsQAWhAykD++Y6+rHdG6Gx8u3nTvZo3q5ApM4K75Wt8fieDmXcni9xx+cS+7mm9R+cpos=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770842743; c=relaxed/simple;
	bh=AZfviAAFLhaWadEiz8sFYyJlepgQvOcSoyiorAdeDMg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jTboPKZf1g2uSOttYFopROMup6Z4pOVcrf5cBPvGZPESBjcbfMlTrxb9PCRQCW8N8qGAOxT8BjcfkIP+kJw+fD+Abk8He/ys4Gl2zP6Fq9jh65NO9lm/DVfHiHHyutsWP+8UYgg/bASuY6ineql0MOD8WK7hXsNSMkmfOrc5bsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ADbTrD5d; arc=fail smtp.client-ip=40.93.195.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ADbTrD5d"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U/i5oP247o7CTKESIZOGAWKL2663gcz+GkYVdRZVrKV/ewrvr7T8XkXdX22mA0DsOtVrQdpLr3PMGgISFpKjgLeWlfokjbmU8I+gNC3gWK6MgXIe9y9y/QchwppJm0IAx2ZGL7HrlHxS4Pk7DibWvy/mqc9j1Xw46neIAn0yLhKQGIxFvCACR8dgBPop6bJmJ+Qq55AGP7rMouGCfwv//3cqtdFqorah2wU062/+pz/xhDSYad+ViMlR1BmzgNV+OMUQ6SfttpVs8hj5P3xON9gCsOl6GA5CahI1bweOQ2XmlV6afZjrJO6XL6S+oO6KqYlpll+n6sKrRy9qIA3VcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fxCeaOeB1rvdf0N0qNTYXrDAL1DF/E3FjEgnArqk8RY=;
 b=Qy2tty0jA9o2j6Lfm+DrIsX+QhKcf3xNKCJfH7FwAr+JsMYm0+PlnUsRAfqmLH7/A5YGZ0Ov0+hc0UN44n26Bj46LeA28zO7cB8az5Xb2vT40v+tEArCoHOX6yqtSWMwvk6G2e0Tou7kcfXX4xDxL2SR95ZUvrNm8rnpZ6ZTeAkkqoR/DafVeSpaGYlfDvvm7/du/pCADuVyZ+Wbkat20AG0eKZnmEaCiXmADrQ34fwxoSOumU16dMVbc1SMDbeCYLsX4pu71BbBSeSZISWbeln/Fzlb+UTOR3uq5aqrNE8WZl5dsm2OKuIQzLRvXFx6/pMNu4AuPl2H/mTySsslWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxCeaOeB1rvdf0N0qNTYXrDAL1DF/E3FjEgnArqk8RY=;
 b=ADbTrD5dkb5XhyJ+i8in++2HLX4bHd7JH0GTKQjC9t6jOZtLernTyGePq/YqTgKkEXJbw/iFyxW7YZxuyAAAn6pVeQaUiS64+syUBSYajhm9O8FnW04KbN42Lxq80p9LgsOnXieBGjubaJAnt2yWyEtew8M0xi8QYROhxiBSQ65h9t4e/eZaV/iTKQvsof/l9giauZZtBoX2eiR9avYIjJU5WBQmdC2BqgeE7fu67OlvQkrLjNldKHQXyzL5GOlieuKnwhWSD57iQUyaKBIVxdUZ8tmDgiqpTX6MX8eNkRN4wZ8DHA7b9t4sX2FJO4yqNo9lVxqW6rFxGI4qAHlZcQ==
Received: from SN7PR04CA0207.namprd04.prod.outlook.com (2603:10b6:806:126::32)
 by MN0PR12MB5905.namprd12.prod.outlook.com (2603:10b6:208:379::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Wed, 11 Feb
 2026 20:45:31 +0000
Received: from SN1PEPF00026367.namprd02.prod.outlook.com
 (2603:10b6:806:126:cafe::12) by SN7PR04CA0207.outlook.office365.com
 (2603:10b6:806:126::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.8 via Frontend Transport; Wed,
 11 Feb 2026 20:45:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF00026367.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Wed, 11 Feb 2026 20:45:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 11 Feb
 2026 12:45:09 -0800
Received: from dev.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 11 Feb
 2026 12:45:08 -0800
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <linan122@huawei.com>, <song@kernel.org>, <yukuai@fnnas.com>,
	<hch@lst.de>, <sagi@grimberg.me>, <axboe@kernel.dk>
CC: <linux-raid@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
	<linux-block@vger.kernel.org>, Chaitanya Kulkarni <kch@nvidia.com>, "Martin K
 . Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn
	<johannes.thumshirn@wdc.com>
Subject: [PATCH V4 2/3] nvmet: ignore discard return value
Date: Wed, 11 Feb 2026 12:44:37 -0800
Message-ID: <20260211204438.22568-3-kch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00026367:EE_|MN0PR12MB5905:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f763e8a-f87e-42aa-be8d-08de69ae7e66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U0RKOdUY6ql9uB0wWSFLc6Roiq/eYanV4qLOzmhBeAOP6+E9K6eLW2Ekgvm3?=
 =?us-ascii?Q?NVjj3SNqPcQ++/xhVU38AE9a7vLCpOTey9Erx6Gg+FFklskdZy7Yz5OvY+29?=
 =?us-ascii?Q?CszfEXQH+/wZ+2sbfoHXxvJ5lEE6nKxBI3hRbeKVzscIfXD3GW77rBZ+1Jdz?=
 =?us-ascii?Q?k2XAuw+0K1RSCusaf27nsPeNwaLtNta/eRqqcXwt1Z/PqfdYVdnOexb4D/YZ?=
 =?us-ascii?Q?hq+g35KzmkRpmn3zBZ0jq5pkJ3d1DP8daUlJLy8k4ksY5hrhsU159LAzYf9P?=
 =?us-ascii?Q?hx0ksbS8DOLm2XmYGJ9qi2yjJ+5S8htU+3QNeH6qCJ4E6K8vKpK8BTxMS4wd?=
 =?us-ascii?Q?zobYFoGdfDI6UqqXQvulgsEUl0xNTwVppgsduc4/A2zv/jN6hhf6b0B6QXrS?=
 =?us-ascii?Q?BQBtlAIgXyQy724i9+poQbArIxuWv60ECGGOxxRFc+xfx7/xDerHWOphRFvc?=
 =?us-ascii?Q?iqaWQzQc9OoMJeQ5pVVJkDVcTfsVQARpn6e5AsiqETwF7jWjQSWrQkWAx7Fa?=
 =?us-ascii?Q?wL2lND/dQhBXjSmO6aqU5cou7zbdJ5180pplhpV/oI/sRgpxQxTYilPvSKRz?=
 =?us-ascii?Q?sEV7TwYAW87eHE7/8asNVTSlmDPwNUAuE4b367oLW/a+5v/WiXUjR++jdJ2/?=
 =?us-ascii?Q?Q5vIdWJIrtDvt0YL2mnmzLvAKdn3B9jGoN8qu28KxT+CxDB8ITdk/Pt/HESX?=
 =?us-ascii?Q?qLOGpnOxeRdhEcUDVdEH94EtFWb+LosP1Ge94kgvg2FhOfYmd7AHzVfhe23N?=
 =?us-ascii?Q?kHcxM4xI9unaU91pN2tNf6YdCfMwUu1x0899fiR9ibgCeHBc7hnYMP1GOFzA?=
 =?us-ascii?Q?imaNcQCdCYEo/Eo+lnuNsEkwa3C0Wh8kYbiON6zx94MiyslfK5EyPIiZWEYE?=
 =?us-ascii?Q?x7YZicmBkprOJvDvoEsCTLiq9qB3pswpsU2DQ5YsYznuVbFYQfHvn9gIbGNc?=
 =?us-ascii?Q?L1xkNa84vpkdqHD6F/9+x7yLg513B2orp9dJ7ubvJuf16F8h4GbdMtmJYv3u?=
 =?us-ascii?Q?5PZ8kfeEEYZCukyLjG/Hkufw4rHP5V0CjSkcrejqFmZa2V3XfqN/pWSFpvy0?=
 =?us-ascii?Q?BFgfdmgLUVjFYflVNmsGBXOTCe1b13DQL2dfgF4PLvi53T/9lLbX1jxnqTEk?=
 =?us-ascii?Q?0FP8Kbk49wxr9EiZc/AaG12Up1Jmr6p9MSnVy7+XzN+OpfKOWywUWOLtuTmm?=
 =?us-ascii?Q?/EdVQzBUJVwAm/hVIxzuf++MCcwFDv940FZ06t+bfzpqtuEsta89KYJ6nSmV?=
 =?us-ascii?Q?MD8NV0Vid7in/rh21qdJY3Mm/w8x47sxhHl93mYt+Vhl2Uot03Ip6eZGNKGE?=
 =?us-ascii?Q?na0+Db8sLQs8y0w7sRob3jFWwzeMQRWa1WcNaC6uJLrY8hut0edtq65kx7mL?=
 =?us-ascii?Q?AfZCwCqA/QFTIbXK4/4FH+W5rOrKu5Kl2YUWxJe29oo0ThlTpuepd95RZo8K?=
 =?us-ascii?Q?BFNCLXq9cXSEij/X3UhloHkEUPETL8qcfcAQ0amzzQkLjNrGHQlqwH/edl2h?=
 =?us-ascii?Q?3RDcxW4PyXKfgatd4JlotiZaRUFWix4BqdnFuOAGILeuEj1EgVpO22F8Dtr+?=
 =?us-ascii?Q?8lq15DR+wzyt9cFEo2FlLBSuZeNRAugNF98xRnia4guFCPuRbyS79wmW89AE?=
 =?us-ascii?Q?1Qo3RRUIdGkG0ekeRVrSsM94VVvXFNgKjlGGkgg9f747QYkIdgn2QgNVx8Ae?=
 =?us-ascii?Q?Nfl0LA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tT8nclQgYpYWD08iiPEWw1KCD+CRRhkCKSlyPBwmksmUTlxfD9qCBq9Yr2tusCgfg0be7HzMqxGRqkooNZXNykv4cUt/c3aJCRjAan6de+tMH/6K4EmbOjejt1UE49SJBER+G/dTHtFocxTLRmftFJyO9s50rcNRgYBVRK3JeM7rsofFKQ+LOELOtAecrHbd3yE9vv0bf765crgCIL5bxXyTLQFvMWCEVe2ZtHci7FgVkD0oFW3sYiGiYhNqJUYrKs2/3stqI17+N/x5CGbdJSZRpCF7QebaSkWp31ptDUG8QOnmmvlWyz5Gow0Zl4xwJwJFqnFAQTIvWa6L2w3xjnemmTOPhuFOgjdK9xx4ZSyJ38Bf8kaOJJA3uOEbiZ4xZaeqcUruZgNdCx2K2Pmm052NkduUaksu/ixpvBROh3d7GX4JSJxXi/3mCtFT58nE
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 20:45:29.7642
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f763e8a-f87e-42aa-be8d-08de69ae7e66
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026367.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5905

__blkdev_issue_discard() always returns 0, making the error checking
in nvmet_bdev_discard_range() dead code.

Kill the function nvmet_bdev_discard_range() and call
__blkdev_issue_discard() directly from nvmet_bdev_execute_discard(),
since no error handling is needed anymore for __blkdev_issue_discard()
call.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/target/io-cmd-bdev.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 0103815542d4..f15d1c213bc6 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -363,29 +363,14 @@ u16 nvmet_bdev_flush(struct nvmet_req *req)
 	return 0;
 }
 
-static u16 nvmet_bdev_discard_range(struct nvmet_req *req,
-		struct nvme_dsm_range *range, struct bio **bio)
-{
-	struct nvmet_ns *ns = req->ns;
-	int ret;
-
-	ret = __blkdev_issue_discard(ns->bdev,
-			nvmet_lba_to_sect(ns, range->slba),
-			le32_to_cpu(range->nlb) << (ns->blksize_shift - 9),
-			GFP_KERNEL, bio);
-	if (ret && ret != -EOPNOTSUPP) {
-		req->error_slba = le64_to_cpu(range->slba);
-		return errno_to_nvme_status(req, ret);
-	}
-	return NVME_SC_SUCCESS;
-}
-
 static void nvmet_bdev_execute_discard(struct nvmet_req *req)
 {
+	struct nvmet_ns *ns = req->ns;
 	struct nvme_dsm_range range;
 	struct bio *bio = NULL;
+	sector_t nr_sects;
 	int i;
-	u16 status;
+	u16 status = NVME_SC_SUCCESS;
 
 	for (i = 0; i <= le32_to_cpu(req->cmd->dsm.nr); i++) {
 		status = nvmet_copy_from_sgl(req, i * sizeof(range), &range,
@@ -393,9 +378,10 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
 		if (status)
 			break;
 
-		status = nvmet_bdev_discard_range(req, &range, &bio);
-		if (status)
-			break;
+		nr_sects = le32_to_cpu(range.nlb) << (ns->blksize_shift - 9);
+		__blkdev_issue_discard(ns->bdev,
+				nvmet_lba_to_sect(ns, range.slba), nr_sects,
+				GFP_KERNEL, &bio);
 	}
 
 	if (bio) {
-- 
2.39.5

