Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013035.outbound.protection.outlook.com [40.107.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D53729ACC6;
	Thu, 28 Aug 2025 11:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756380454; cv=fail; b=S1xqcgHnoSs6PI6zAgO0LPEiofs6LfhAnDfYRaK34ECgNgebOtLWWcXcuG9Yb3hhzkh9urVOoJUH+GLXE9N8A6IlmM1BYptYmsqNYTpDxwe2l3080cCm4csdkfYmbaA9w3w9PPISv1rMEjUdsOYLILAYXga80XoGxJawC4sEf9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756380454; c=relaxed/simple;
	bh=ZzrbHmSei+OE6NBcd87kcoIDWPnKspySSEWPZuXZoCc=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=oy+guMrbShx27z6HcfqiGrVgxmTCC/R5lIc3M7NWE2E0bZcjr1R7BvX1Xm836+LkO3gR8yBRv9fk1nE+i20rRorWD6pVVbqGSbg/eNcF6zVk6Cham8zpKb+62mi1Iq5F7zsWeyCsZ85S+gEhTOqNwPKoC9zcPEE2SSCQvlFzhvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=N0vB4Rua; arc=fail smtp.client-ip=40.107.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="N0vB4Rua"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vgptZQ9ngiWoF2THj7WKtqw/XEWjw42Kbx10XSXXr84SNcMTk9IbaDLZVHlv9zmEGFEjKQc9FuVMz2d25DMd1awxcTv6KHU4MziEdiiRu5rdlc36N6WCEi2u66wT0CRKg2pStRp0LP9LSb6QOC0pWX073FzOZKNvMf0DB+u9MaqGH4TspH0ycbAmDhmIoRVrW9e56HrxVvtNJXjnEo+FnMS9uqUUEOnE3/tA/fYSIOdP6CstgzX8HY/viyZoFDIJBg9fo0ceS9DGNwm/w6cLD9tJhX9lVOdEk02zmQPerux+OS87x2m4dJiDHo32GCdaUeVdWS4Vc2KdtPjhX4yjhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EIsMIvn8W2Cu5+rUZh/Q44xLQkMZ2O452l9zutuHFEU=;
 b=I1St++0AKFeoVeDf0Z6JvfebuPxpNrN+QOrPy3nuk6AztKa+RApnnyM7ryJfKXfoTz6Y0EfRaXzK+4/+rmjsUrzWbZY9psnVhGy2aFFH5wgiam5IMAJVfkV6G+MIKpG6sylQVl/2pKm+nLl4YZ4XYpbVpcWzFvILhqSYZ+RdYHYq7xxwErXBZXvUH52Z8zTpM/uyIAyCfM27O6Qf83VFNCgYwQ69E0ug0yuisEPAv6dLTVT3eVUIeD5Lvnpv6/0Bh3rMbxPDlJLsRM5kBnQVNRlxcSkKPGBBRNsPtnM39y1lIzU2EpS4iGjZb+n+PQc7zclu84uL0gv6Hz47gEagFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EIsMIvn8W2Cu5+rUZh/Q44xLQkMZ2O452l9zutuHFEU=;
 b=N0vB4RuabNHDoNyFlxmrzmv5JJAnZo2gt71maKubQdsu1Pn1vUgEZcdBJyK9pDzE9ZW44xmmhrbfxPKpOz+XiHqPQj//v9xQUUYybxcjtVgqeZ9fLkUQJ9Xl1QWAwMIE7koaNtGkovqBYzWOLkb/c2E3f5ZJy/K2i93az8QYHKc90OMH33L0LxOUnC01KzmGKu7VouTsyHzZWV/wiTweF2i7Jbqk7ITgr5UA/T7GfbIBjtbvLA81cVWpAKOMc+VRDuqAu6/ALuD/PHvV/hwAmUahJBCsEimxj+zjujQnR09CYWU3sPs/RgJvMOjUT2tBcCNaOJmKvt1xmC/jmFlrgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB7330.apcprd06.prod.outlook.com (2603:1096:820:146::7)
 by SEYPR06MB6663.apcprd06.prod.outlook.com (2603:1096:101:175::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 11:27:24 +0000
Received: from KL1PR06MB7330.apcprd06.prod.outlook.com
 ([fe80::d1d3:916:af43:55f5]) by KL1PR06MB7330.apcprd06.prod.outlook.com
 ([fe80::d1d3:916:af43:55f5%4]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 11:27:23 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH] dm vdo: Use str_plural() to simplify the code
Date: Thu, 28 Aug 2025 19:27:14 +0800
Message-Id: <20250828112714.633108-1-zhao.xichao@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0136.jpnprd01.prod.outlook.com
 (2603:1096:400:2b7::6) To KL1PR06MB7330.apcprd06.prod.outlook.com
 (2603:1096:820:146::7)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB7330:EE_|SEYPR06MB6663:EE_
X-MS-Office365-Filtering-Correlation-Id: ea088df5-bed1-47e6-1a6a-08dde625dc0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a3XGTofQX56tL3J2ikD5F1Vs73I7tF9RsDaVAbsTpRqAuY2S8oN/E5/xTFOn?=
 =?us-ascii?Q?tDKJZMRl0qLKZ+1OT4XZuwwpCqox+ZlDl3YuIhgp6cwIocawVKcQAeuQYaKH?=
 =?us-ascii?Q?gEKems4HftJB/mAz6A+6Hr4qS/gW86LxuEQ5bwCmRl5zmv4655l9cYdrQKgF?=
 =?us-ascii?Q?Gdwml0ZziIoEpPEhb4pIEkD6hmrrYwKjytPDKxuqVObtSIu5u7AftnIj67Wv?=
 =?us-ascii?Q?N3zUphbpziDl5//nTw7hIQZWhW2cq2RMzaZZz2wpY7x9EWVNHgXgQ7ye+f52?=
 =?us-ascii?Q?bGmMeRvhxaQaeyb8f8xns4WsCA60Bxl936/yru8bK07MBIqv13GwgQUwd7YD?=
 =?us-ascii?Q?Qv0Ek7wuuaBjukJVaWIoQR0kcxA+TuHJcDnde4KSdPtbp0GQECl5NOAW2ok/?=
 =?us-ascii?Q?Dnt/f26Uz30zBYxib/a5Aa6FFu2ujoYq0APtB+qeHkEEgTWeuuIHjVzemDKD?=
 =?us-ascii?Q?Zt2a+HbZSZHVvwWp4nkWl4N9RNjMsEI4cJI33r4Ib4otqukrRUsr6C2MJtOb?=
 =?us-ascii?Q?6QDl5ByCD/dtxlWxHr9FzhrHVZgxy0rkrMoNJt5YnxddBDHCLPDqlJ8ux1Ms?=
 =?us-ascii?Q?grtT4xvIVS134pT/f5ZRehOHxuy0rlOMlgaYqrh5wfTb1x2FLckppoATLP7C?=
 =?us-ascii?Q?sKcx2j8Io11CHdX/Csi/bpiy4o7yv74tkdl84xpoA2U0cJpPMKHOhRZaRDEa?=
 =?us-ascii?Q?LpaB0/r5aVi0fYFKzhdvyzAbTq2wOmeO0Lw74xrIYmzVL/9Bf8Llao+DTSrE?=
 =?us-ascii?Q?UieK8NRI8KSE+ih2rUR3r0PwfePYxuzG8f/71VzvuFrbCar1ZjXgp8hAgEjA?=
 =?us-ascii?Q?G5kEn5Lgb4QacrCPddqJy4AtmYfZulIMoZOc6fWwzx954lf3RlV/wUcJ5lzH?=
 =?us-ascii?Q?WeedXVgzQ9qAamG8zCSXv19xrLzD8M16xticGZGte4O21xnFind9zIRJ23X5?=
 =?us-ascii?Q?v52VxHM5oUYHmqZ9mr6DzyPcXbsb24g9UaYZZO473Mambg2xMpo1PISmo+Ac?=
 =?us-ascii?Q?7YhBxBHMb7Ga3Q7gMlKMisLYAPOVE4/OdGspScdksmfgEn30uuuiprQTK38y?=
 =?us-ascii?Q?8phtbdOUkP787Xxb206xJRJKAihH5fqZUodHOiJDfJS8+nZmPVIv8W7s5RHV?=
 =?us-ascii?Q?hTG61lVpG4IBm5vcIN9TJyOboqBNvOH/SiHFyQ6m7jB5gdAkss81AymdSEi/?=
 =?us-ascii?Q?R/8rSg/Hyq8DKw7Rtuqhr3XIdlg6a2DR4AIY0zfwCCizJcmDxslL8KDo0AQm?=
 =?us-ascii?Q?Qn4eJpTY+kf4oEZUt2xSHd4NZPxWnDupMnSaJdMzFvpLubqLa+mfNgDkpuTb?=
 =?us-ascii?Q?Xo35xk6lssEdfa+sJ2917o6y/qLZsZ6mQYa1S24qzlEck1oZOPODvYYp0o9x?=
 =?us-ascii?Q?BeoaeynmYeT0Z3Fa8xY4MoIKhYv640YCvwQBPCqSAYQ3eneC2G9IxCvSdew9?=
 =?us-ascii?Q?ahxdR8GyXHBuaFfozfNOO9l2zH+6Tfc1hkpl+OQ0xaPg7jsDC3l17A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB7330.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nPG6VtrfPHKqmNgOwMH49ICu39cf8SLQ9xqHOv9/Cme664IGJlrwAp8RNsbr?=
 =?us-ascii?Q?e5xNQPAp6mQzzK4qvUfpLhdFM2Ezfglj/zDgWgStOPdCG0imvuBfXCtXWOPZ?=
 =?us-ascii?Q?YzBNyATVzQHWvm+5xovyQvdxuUXGknTuaHfeaLnrX3fMbo1OGxSHgPtDzu8I?=
 =?us-ascii?Q?V6tfKWfs00iW4z+qErzl1cZmVdY23XGu94byohake6e0XXko7/Ra/2Czfd9Y?=
 =?us-ascii?Q?ZC02Kwwc0LoFNOuYH4Xowb8sQNwqk6gukmdduLVfea4NtTKzOJmBdmDdeuNk?=
 =?us-ascii?Q?bcG4NNePmZEShZWnAZgeuMYh7ZhkB98z7MXOU97UXm8zAujFivYCQqF1DV3a?=
 =?us-ascii?Q?GDGl81070nu1Ny9NPwho4bwEFrM/u3JZ9CN68rx160io9XrEE3H5po34taze?=
 =?us-ascii?Q?v3dQmP9GJjWmHe4BCWZ1E4pWX3uPFGsmF5kXgWWRyvgpBvU/BGJGdQRLjAtv?=
 =?us-ascii?Q?XQmAqjMpSmP9ggh/8XTksWaVTov3DNOtF8NsFQj8OF9C2b5uB/mBJsm4pigz?=
 =?us-ascii?Q?6Qtr9mmkiyoLSlMHu0sBD818IB6fKo6Fli3BJ+GfEUmwyYjXNTelFLbtoQ2f?=
 =?us-ascii?Q?J/EKrjpXvlyouopmimT1imyZkw9STztDZl6nx3DJsaioTecVsmmvQl4ADnvW?=
 =?us-ascii?Q?zvIOFvSWqEAAzF8a38gCDssWY2IirYCMu9NvVz34a5/PAzff3+APn5Ktuf6h?=
 =?us-ascii?Q?r+UVXaHavVLcUl0oGYWVJ1YKv3n0RHWo8YLBlqteOAh1q8NhmI+pRpoa8DA/?=
 =?us-ascii?Q?e8PdcZfNoJS5Imi3G3geAhGSojoybZpWF2trATLVutCrpakRE0ImnhLLooDa?=
 =?us-ascii?Q?RBWkkn29Jupf9t8t4mUJeI2KocmnGl8gED4WEHfGXojegmetmZv+dCq0bTIW?=
 =?us-ascii?Q?tx0siYR0JypDeyFP9sK3wGcZfBH1PmWTv3AqV6EiHYx+b+CFCFyo26QgCTRU?=
 =?us-ascii?Q?8TS1tUiqORqMMs3W/Cp8nTGkZkNGCQm1Ilf//VbaVQN67J9Ue34C5CqvOq+G?=
 =?us-ascii?Q?3h9/BW7C2zMxoW7YvNw4U5P0s6vbgZijbNDss0R2c5T8VVmZyyXUR8cc78iR?=
 =?us-ascii?Q?13rg5756J83EC0UDPUmCw/kG7B03ad3GUEn55ogSaqK3T0yTRVL14Pa1q6f9?=
 =?us-ascii?Q?W+oUK4BBJLif8a/mhEsVfSyyPVJb993IDHArFYnq179I7AUMuFN9fOZlS4VQ?=
 =?us-ascii?Q?nPaxl2RutjKmqdgLH+ItlG4a56lrCS6/aVQO+vJQbDBVMKGkrxxtK7rYZx04?=
 =?us-ascii?Q?ooj3k0IOT9uyKL6teB+txcTWFc4Th1EeZT5o6DVtk39fcf/DzBfHiU6+bep4?=
 =?us-ascii?Q?UiatP7IXyNJ0K6jNEWqGnn183RVga7n4vkG7vaA3Rld3ubzN51ozIBO6VI8y?=
 =?us-ascii?Q?CBoNkvMCFJQi7Lf3S1gInjebtJY6FE8sqe9hsXEUYzfxmnZyg4W9ka7C5lhE?=
 =?us-ascii?Q?ysHCkug+E9gypPPaUF0TizWxhiZ9bdwgIb9+DbHj/yhHmQ+uVDImtaEq9jRi?=
 =?us-ascii?Q?/jYjLHUkvE+3ToyrmCe35fmyzGrx/6Kcj8T5LVVEhKGRTaKEmvaNi2xWcG1n?=
 =?us-ascii?Q?ElNA6tWPO0jF++ifW7xYZA1eUovyrfgZjKRx6Xjn?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea088df5-bed1-47e6-1a6a-08dde625dc0d
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB7330.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:27:23.8963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nm3a1nu4sli8QC5SHZb9XdW5SP1GLuVUUOzWmizps2lmKKECmlU/vzT2Zo21fFFUVMxlnTM0vfPth7M4x6JMhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6663

Use the string choice helper function str_plural() to simplify the code.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 drivers/md/raid0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index cbe2a9054cb9..a2e59a8d441f 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -41,7 +41,7 @@ static void dump_zones(struct mddev *mddev)
 	int raid_disks = conf->strip_zone[0].nb_dev;
 	pr_debug("md: RAID0 configuration for %s - %d zone%s\n",
 		 mdname(mddev),
-		 conf->nr_strip_zones, conf->nr_strip_zones==1?"":"s");
+		 conf->nr_strip_zones, str_plural(conf->nr_strip_zones));
 	for (j = 0; j < conf->nr_strip_zones; j++) {
 		char line[200];
 		int len = 0;
-- 
2.34.1

