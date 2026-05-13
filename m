Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011066.outbound.protection.outlook.com [40.107.208.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6723A783D;
	Wed, 13 May 2026 18:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778698379; cv=fail; b=U5zSpLT8qBlsw7k2xlTttevjD+V5AI8wGz0eIDYzXVTIUdqRLxhevb0YaqKmcnWnfpIO9sCwkUUwdUHfkVdLNTbVjv32DLCvbTv2jLdgj1/pzdcu2IIWWjvZlMCvasP7fAhbhzppwuprGtil55ygf3fnyNFBx6MORC1ZNnPV69I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778698379; c=relaxed/simple;
	bh=R31ygIAGVoxVuwmEUmmUtpdL9Xp2jBKdec/Sc8YHkHE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qlPvg6XxjD0R4VPH43SULIdjQHXVggiHNWUsUypEQu1TkoB972gHJzkALZv1xf0rrr78Zf/BmZEQ9+hMHScYKynuyxEW7V7qumOFH7wiiONIcwR3WwwQ4CJS0vD6qBEJ92TwpXw1KaGgIpkaB+7YOFWDXflySJAsGBhUgGNOem4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RLu3osaG; arc=fail smtp.client-ip=40.107.208.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RLu3osaG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LXK6jTHARr2+Xj4n3bGCKzvS+JnxlY7H1xXdFqBPfj2iT5Q9xSb3UuckZJE2dbXTiwidJYZYA7ydrnrof4iwes3lgNZr9CKJhO88kOvfzbXhG38CIMryDtT2/+xdQ7G5eZqlGUnfv3eqR5JFQ1Nd+sgUyKGzthfmWeRwbHK45PBTEB/EdU8KOe3NArw4QsxhjEqyH6KXyrt0sVtnwrdfDFRb3xJ9l/XBv5BaL2ZfUOsTr3Sfl4/Q3YcnkKEfjsl9u8mKXtjlF3VN7eTidUSKjwY90p96GhlGBm/Aaf226GgqKmjgCmqkoflCqsu22Lu+zc8uQ6QcFCTuaHru6r83Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XNA0f0deCstTXc/2yDLZnVG2wNFG08feHED+e8lat1E=;
 b=IPt7HEuNj85/YIeOYRNt78lPIFO4U+IQo04jy9MJ+wh3oMCeMG9JRJdEMaHrM0NwsIh9GkNbgMJkXjXX3uc5w7AjPzVJ/cBLP9xbOGf2hcLDTFoUXrCjVifPj31j+V5Ij3XbV9m0w3QT1sjyXtXrFnTaW7ioZVu0JPUIzmvZJsh0u8GZ98GAzO487WceaxN03Ww0PYJMNb0ElxabCitQmJxvqFoRT/gRPynoMsAhnMMXG7LnVsVSvBbYBfc2SRtuKoWi8L0vjtIxg4derweTCNDdOV7zQQRMSj09zDG2ET/lzxFYI7kzFCgYq8aTe3SKMhvH7CofdI9I1UTWSACL1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNA0f0deCstTXc/2yDLZnVG2wNFG08feHED+e8lat1E=;
 b=RLu3osaGuU6aLZk0NS54XEb8dykzFuNL5Zw4z390CBLTeXxzDaOcOMcsIGUf7u+U8lo+t3PM4SYBPEphQzeTMEc2zMBkC4OufSesdN+Fh3JydQHwKf/whSw02PomSZ7r/Zil6Az5X03j9AdV4iDJ8KMrlOgh67RtKaMRqvOomoZmAAhX+3UxLntMYhvdNUAr3oLImlqG8fBiQMTHt56gampqd0Zyv0VIG9kezdYrlt+DGyfwD7ECr4BL+UnR6pH5ZZgr8R7qZByJfUAsMwmipJvVTNQf6B5D14C/w6WDv2WizF0wyGcvPoYrriaUbmUQozjOAD5Ha1YP0XZsP8cvvA==
Received: from CH2PR16CA0001.namprd16.prod.outlook.com (2603:10b6:610:50::11)
 by CH3PR12MB9250.namprd12.prod.outlook.com (2603:10b6:610:1ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Wed, 13 May
 2026 18:52:50 +0000
Received: from CH2PEPF0000013D.namprd02.prod.outlook.com
 (2603:10b6:610:50:cafe::1b) by CH2PR16CA0001.outlook.office365.com
 (2603:10b6:610:50::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.17 via Frontend Transport; Wed, 13
 May 2026 18:52:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000013D.mail.protection.outlook.com (10.167.244.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Wed, 13 May 2026 18:52:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 13 May
 2026 11:52:30 -0700
Received: from dev.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 13 May
 2026 11:52:24 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <song@kernel.org>, <yukuai@fnnas.com>, <linan122@huawei.com>,
	<kbusch@kernel.org>, <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>
CC: <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>,
	<linux-nvme@lists.infradead.org>, <kmodukuri@nvidia.com>, Chaitanya Kulkarni
	<kch@nvidia.com>, Pranjal Shrivastava <praan@google.com>, Nitesh Shetty
	<nj.shetty@samsung.com>
Subject: [PATCH V4 1/3] block: clear BLK_FEAT_PCI_P2PDMA in blk_stack_limits() for non-supporting devices
Date: Wed, 13 May 2026 11:51:51 -0700
Message-ID: <20260513185153.95552-2-kch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013D:EE_|CH3PR12MB9250:EE_
X-MS-Office365-Filtering-Correlation-Id: 569b0171-a628-4944-8e3c-08deb120d4e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700016|11063799003|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	sAa6DinFf8YclX9n7tSwNtUjZ7deGyDGKjDq0k4GouIrDZL/oViMut7fM1DdBiivTrw65rx/+QdP+2oF33AGbYIHlUYQt9IWzZJdjKkZjHrNqruIE3VwwSTK2qz9C01/eXiPinpVf0WMktBpAvP1AnecKpkMVIgUS1N6kFfA3Vb22vD9GdsFarxPAiYlRJizIARyXP8AdhMoOZrzsJKjfqRyHtL4aHhK5L0eYP669hEC+u2DEJkknL4JQbphl0pFBUIQzdKc5JQ3urXwtrxawRosxAniXyUOxZtxnE/U5Km4+z3e1AgAheqOqnxf8jbHHoo/79yd+vcheyZod3TpXP2FlZDIAGckEAKhObY/pp+xLZ0bjmcAAeCeWao3kZk1XXMCG47GCy+3o/Uq4I2IFprUHg7mwIqMZo5iNrUPlcgyUP/HcSDz9iRcpWcMtev6zZBWqMBEgi1SBzAE2+lz78784BFl9uoJJPK0Ig6gL6ElaTIyU4Aa7a7hiAXN27y7VRMDuyky5RU6HBbMfIgYGWcBZkqsooCndRjSBjcYwZ91Ip9jUi3Co3vjmqo5ZxdrzF/7BiHoe/hSxeLjkuX8Ia7iVW2O+tnhz9ezU0OttfZi/wCb9QNTPsYjVHlTgOQznq8gRP2MKvn8N8Pz8bXoxmFvcrFld+py+/Omy3jYWUcKQtCLdTCxxjzoo7nSUeFM5DHdG5Cyetr2+6tHYb6W+z1JXd2XyhP1NvSY8HAAbSU=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700016)(11063799003)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sUvc7gmMQ5yN2675uI2uIZN/cfZ/swv0BT/9XvLvodK9uaGMo3lnthjGbBDqn/npnrPjttyDAU4QyEq0hOE5lEQem8vP3VmolsG9tem1iDq54Of5a7HSCy1tKNLhYiSNnl5TznlBFhjIcAum+rbj7ZS4qSST9RAHv53TiJxBYFF2IDCvXTrrCJwWbDWRZgZcdNwIriDKtpPYeMFM7XFYELck0u+M/KQhJZ2azG+QNfgfEfvlRVGbBy/kLtRWgCIdEFWBDRoGlbzltYqMjh6DN5RwSP5CfqvtTZ1n4ZayPO25NMMsIfNIJOaLqU5XjIQomkoxKeuTf0YEGJScZzHNCtfS6fVk95pzwrCs0JamATEnE+uB6WX0/tAt/cUuM4PAKcmTlpNdEzeud6TnN1iAeJz3vGvzYS+G1ITj/j45LsC34FoNRnJDoEwjWgZmmq86
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 18:52:50.0399
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 569b0171-a628-4944-8e3c-08deb120d4e4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9250

BLK_FEAT_NOWAIT and BLK_FEAT_POLL are cleared in blk_stack_limits()
when an underlying device does not support them.  Apply the same
treatment to BLK_FEAT_PCI_P2PDMA: stacking drivers set it
unconditionally and rely on the core to clear it whenever a
non-supporting member device is stacked.

Tested-by: Pranjal Shrivastava<praan@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
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

