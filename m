Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013015.outbound.protection.outlook.com [40.107.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E6429E0F8;
	Fri, 15 Aug 2025 01:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755222890; cv=fail; b=T99QUPKWiSpw1OWQR+RDxpKf0tDPt/kWvK4M/M8TCg0BrKeA059zvGziAmhKSdgs3BwO9cRzlotV36VP04pPyTwrMrRQvJqIpe/l26nRC1hLAljqAnlDBVef1CRVLmPVrrORrVSl1DmbadVCwaSKgJleTfwX9hjtk+QysH5Mtxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755222890; c=relaxed/simple;
	bh=M5HXUi2v6vvksWxCIpD/xlftKrzQpBvwrcMZb1EGYBI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iLwc0qLfAdUZbNbbEViXylQQ51EkTpYioLgS/Hhzt+YR14/RCjivqpnevP3g+JWAL0Z9k7G5qrHd4oWU0yOLwwLlHbmZu0TGyoTWZIOstmMUdXEM8Koi6a3WuUWUsF6vbnW1Z1ggmhPD7sy6O817DvOPymi1kqaD/XPRbVTQ1/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=miTYhAWW; arc=fail smtp.client-ip=40.107.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="miTYhAWW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VKsj4N7Phi9Mrd4BZS0bp9AawfRPRYC9pArYIulxq903BthRMFILqGyTpx0fivp0pqcEquI3MgmztMSiCPLcEZ3WsEOuWZD5zW0cz9Y94fXAQNKIIgFmhu7mYcSuRZY2ptzvydM8Ee7tuYSZLe7AhIFYHDxHMSF+rklRDpE2cb4C2/aTVn8EuYqR7TcTw3LIj8jSUR6s11EXYMT8Ps8SfqdX5dSeOfS8u07MySVrhQSQmox3gznj3STATxWk75YqvUjuCdn8v7Zas2LqU4o4TY/RI0uYaF31XTTdEvTUp6LsF+5KegECkqW8V1Q3tVt0eBW+hSCwLMjeJJT/nxZzBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f2MvWcqTKn0jSR8x5FBF8VkjDoYe0KjLwXXeiQSlGwQ=;
 b=RkFhM5s/AXyQYLL92+9APBx182Gl3TWqMO+HvaXZTiz5cwDmgsiwS3vbrgFceG14p2RgEL5qbJr2q3b6W+rCJP/aYXTSY2+GhmofCW1msO6sW0RGFm/iR7MoVOgseVFlM8+mL+z6ABnApv9OvR20r+mP6xqGdxs/0VAHAB6t0K1i0vMj4ePwnPK12RECAPYTWVDF7wpTAyXzuDohEAiJ22+CS147wSNQ3Bt5kdvAdEq/Wz27+XUkFOQi2IH+G/W7Sgws6v5l3f5Ojo7hOdltGBn7ZskKwx6AnXyINIBjKjbqS3cxhDzSctvJLTq7/SEKAt7QgXsmWHNFA5PoMBvM7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2MvWcqTKn0jSR8x5FBF8VkjDoYe0KjLwXXeiQSlGwQ=;
 b=miTYhAWW17kcOeQgd4icG5c9OEijAy2NYBDbudcpvcEJ2ftWnt93xnSd9lJhvXJZ7aSCRAEXUPheQJrrbyleOyIF15cOwfaGR0syRMtqlwkKUjnkhgXA9YzG3b52wwzC4OEdZP6sstWV2X/eBiDN3OEkYCU9ppLelL9Qn8vLP3C/qAW1gfPGQ6dY7DzoYdCGI8ML+8LwvyDDMWirIEZEAzEnjtygV0z9FvE3G0NAWrntaZFKsDfiKYXn31rxVy9uif2uV28z3c1AhAjKeArRxYsAKwM+k2oYSnR5d0BR/bZ1A3N38lP6v6V4DZT0JxLbT2JwV8DMH4W7OWzEnbC5SA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by OSQPR06MB7974.apcprd06.prod.outlook.com (2603:1096:604:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 01:54:38 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 01:54:38 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH v1 07/13] lib/raid6: Clean up code style in recov_avx2.c
Date: Fri, 15 Aug 2025 09:53:56 +0800
Message-Id: <20250815015404.468511-8-zhao.xichao@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250815015404.468511-1-zhao.xichao@vivo.com>
References: <20250815015404.468511-1-zhao.xichao@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0202.apcprd06.prod.outlook.com (2603:1096:4:1::34)
 To KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6020:EE_|OSQPR06MB7974:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d86440f-9104-474a-7fc8-08dddb9eb0e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jRxz0AgxHBuB3uj9ylv84XzRyvkCyYEulnO/feEOOOK8tkziEIKDssoHwQYe?=
 =?us-ascii?Q?maCQL6BtL2YFpT2+ZIS5a61x6uggMrGZaHOJOCTEQ4feZc0ryqQRFAss0zYj?=
 =?us-ascii?Q?ziJSiCSVC6pBf7zIOAU41AiFITB8ZO571caFHDRFk4L+ItO/HgtuSUHBQ6tO?=
 =?us-ascii?Q?KfYyLIuid8BB4T7S+WdVyFZeycc+t2NxOXLOFAzgyjlqw30MYd2XN7NfuUSs?=
 =?us-ascii?Q?b6ciyoOegCxqZur/wwNgICJ1APRL+kBG3C5GfkLT7zlyOtgyi1OCvBiswFeQ?=
 =?us-ascii?Q?ZZOduTIuf52gbSc+Z3KSV6Z4QaTj6KIj4lQJBKIpwraIgHtCNyhsGZov4USt?=
 =?us-ascii?Q?cOY/T+XOGQ3uiHJKZXty5sbw2feUsvx/HiJ847/T11Q7WMIXsXgrslITb3VG?=
 =?us-ascii?Q?TlN/i0CcGS5qgM8Jzn4Z+B/9sPxsH+07z3duFm40Ku6cIczrgqpYbWmbXK2C?=
 =?us-ascii?Q?VmUceWzACtIaVtJ3TZFt+VpSTcRVbrndZeWBHq+JY/h0Pbcvg7K5lJ9FXMAB?=
 =?us-ascii?Q?HWtmX+7vEXTZxoV9xDPqXKaonh1CmNeUv1psuDpNZ0H6fzj1zizK8JIkpT9N?=
 =?us-ascii?Q?H8yZqyPsH9pKi+ELFMxAcn8cDb7ElyWHUaXZCPccllKkuzkxRnWZYPropHxv?=
 =?us-ascii?Q?b89TRBnMcbjoVzK+nhSCysojN95oYnZQfZlJmBFRmeBKaHh5qcNa0r1usBje?=
 =?us-ascii?Q?osz9smBD2AoRYEerYoPfv5XO2XczmwlYg1ghGKen+yQ6zJdtMewlJBRa4qeZ?=
 =?us-ascii?Q?YDmZhLMDOQPaTrR73Lp2jQCZH0HsyroyorMKx7/9awoEQDQo55e6h9n7gzAd?=
 =?us-ascii?Q?5NGGxA6ARor7/FjMOwG9LyNMOqtsE4dDTtpxsO+dlJ9GgzW+kAWbf45LGHXG?=
 =?us-ascii?Q?rqFi2Y0cGhj8NKf5JTwdibHe45bnsY6cHnEUZznvItgfkFWxFP/J4d30Y+Pd?=
 =?us-ascii?Q?t36KnDkx1z0/9GX7dGoz2HB6M1SKAZlBul4j+ya6BpaCaDcKD5Tr+6M30SdW?=
 =?us-ascii?Q?LF0+zEZuRucdGT4NciHLNEHm2cuV9pFBuc3JSLa6o0c+ImFUW3f1RBsyuN3B?=
 =?us-ascii?Q?6i4Nc7AEMw0JPrXfxcFAB7vSscIy6fgPRCk0Xnfgh9Vra48HJSxjYBhlu41a?=
 =?us-ascii?Q?S9jloio3RGhjGNaSVcsayEGe69uK4Gp/jWAuJceoO3co3GMUOydblCE9L6GF?=
 =?us-ascii?Q?dThkwzqXQsH377EJYkq+AJitTaGHn9o9L0ZMCPV22UhHZZOOTnn2V4V50iOw?=
 =?us-ascii?Q?ZFpmLnk0eTK4gEkQwQent117cbt4IbKACXSQR8ViPRYMAzDoqlPGbpXN6n+5?=
 =?us-ascii?Q?/0zGXxEkx5PyHJRKBlannjgnIZMsVct2CfUHjARns79ozdojzxFG2EOfrBrb?=
 =?us-ascii?Q?EDKJ16q12g7EGaHgWzKQN7qGTQA7yTqPutm7hrgN6S731lPWw4QpdE5m6DyT?=
 =?us-ascii?Q?ChJHngxvdn5fsJvHLCyYr0BhYg8g0V4Z76y+4RoSp0rAkUbjBHDl8w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2tjCvCqj2qCMO9C5WcjTDaJ2GqpUHmfM8xRrUzfE4qOg53ZxYbJx2H/8qh1A?=
 =?us-ascii?Q?zCYTPZIuARYgWW82GKbB/RwM9AkC8tD94RDieow0MauiFmqgZGnd2kyAbosL?=
 =?us-ascii?Q?7elTdG/47nJg/bnB7f2pBqD0mAv8tWbRskpjnxqaL5rYqe8/xUR9XJ7DARgt?=
 =?us-ascii?Q?4DxU/bHLyeZ+un1uQBnt5mdLyabLh25cUHhBYgmonoL9u1I17Sr7wOFQeBFv?=
 =?us-ascii?Q?+riHzrbKbRj/91ou/DOxAt2PkB7wmr03dkXcHF53Wl6JQ+wr6NNlVausYOxP?=
 =?us-ascii?Q?loxe+T6fOmqTbL42dKzGTubwK2qdej1yxCNUFFqd77D8P7TeaCdxf2FDhI9C?=
 =?us-ascii?Q?Gx7b8L7pSM1NGgAe35rXj1qDLZoZxzrzuddIWnQDMBW2a0M38Ne9fBADFzCp?=
 =?us-ascii?Q?4lu+/FzP0cIVxWX/WvVmZ4BhFgAz8fEGPo75JVgpxetABn7xSzXJd2eO4G3I?=
 =?us-ascii?Q?LYGiOTUvdGfiu3aBNKkpLwNiRcfbNgANRDFpmnSGAZcvVbb2wlC0La0CDB+j?=
 =?us-ascii?Q?8QeV6mY0GoFgTtXGlzS/OD0+NxOTK7oB9sNX12gr+MkEWMlm3rflKlLbxBwv?=
 =?us-ascii?Q?TnCV6r57r7JV9fZ47kuIasarKrUYyw1uW6K+uxA1rwj4Ve6UVLxijVJlC3AN?=
 =?us-ascii?Q?uzHSQcZpPsGfEo0LtOqzssX2fUVPV0jz7sbSUvFljCooSZYr7cFoRF8IErSw?=
 =?us-ascii?Q?FYJs1yUgLVJRkr1lAy2G79MIX66wt00t51OEtGdjXOW5e/C6+pUjHGP48XL3?=
 =?us-ascii?Q?RL7AJ2h7EdsVYlMZjteQlxxQ7H17knjfv1Dyn5pWYbFhS4LQvxk/+tFFlT5j?=
 =?us-ascii?Q?CIZwcO1OhSFOE1dKh15XolM/TufbT7Fl2+NrbFbjseYIcBTj92t1ZllMYhO+?=
 =?us-ascii?Q?sdyeRu8nScVvNWhh07yiE3bUh1cHtVzz44h+JI98nOaiBsmwSqbNA4QJbNJY?=
 =?us-ascii?Q?pkd9X6uxFFfeKzDw+TWBC5d7N3I5Xnx5pthHfFoMBSAcrBqqrcpzjpwMKEka?=
 =?us-ascii?Q?Ey67HeM6Mt5dEV7P2JYWvx1ADYjEEQM4M9dlF9QUfPl6bFKape9iTQoSJ5GF?=
 =?us-ascii?Q?uGqcZ9niFr2iLWs6Wn68l3utHX430QgEUiEvSsLvwVXD8iOV7yShEiFVSePc?=
 =?us-ascii?Q?1+2YfqUCRRldtAleCuHpThG/3VGNDg5NOtu1Y2HBAjKHzq7cCHgKcbFoMTvP?=
 =?us-ascii?Q?p/R8OPSWot4o/3HMZFnwEOZH+fINmvD3p+DBcjhiqMPJBjGloaQxy2VJZFow?=
 =?us-ascii?Q?VKfKWzfuV3Nq/MviEGqwm6z96xyiX5aUrA/74Z1zTGvFO+kU/1xb4nRntdSD?=
 =?us-ascii?Q?4cdBbukXUoD27a0c41+f9VURPgysCtfGyp0fk/Y7543Hq3uKJBHpEVr2CFt7?=
 =?us-ascii?Q?i6ePHOiagZ1KIr9bISkdc2Q7eipFmyvXqNr828KVFOYt1wNECpTAopmgpeQd?=
 =?us-ascii?Q?iPVVAkoBAhSamWbWC+4oF9RbYJCzHQtVguuOTOY/ng6tpzWffCl4f6nic4B3?=
 =?us-ascii?Q?Cs2D7NuF2hlZpL6BPZoShlk4zjBWvsbGQx9ZMMXi+TL6+UY2RfrGRRuuBSmd?=
 =?us-ascii?Q?LJLrJ/Fba7Fgr/XuQP6MRXbIEqVdjTJhx8kNDnuO?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d86440f-9104-474a-7fc8-08dddb9eb0e9
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 01:54:37.7400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nc8l/7XKLPQgsjx4cR8udkZ4fMFnndEgxwPxEY0oOQHFK9Im74bcXjlIVM2+2tBjCwu2GQuk60ZvKQz4+cVL6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7974

Reduce or add spaces to clean up code style.
Clean up comment style.
No functional changes here.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 lib/raid6/recov_avx2.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/lib/raid6/recov_avx2.c b/lib/raid6/recov_avx2.c
index 97d598d2535c..9cfd0aff11e3 100644
--- a/lib/raid6/recov_avx2.c
+++ b/lib/raid6/recov_avx2.c
@@ -21,12 +21,14 @@ static void raid6_2data_recov_avx2(int disks, size_t bytes, int faila,
 	const u8 *qmul;		/* Q multiplier table (for both) */
 	const u8 x0f = 0x0f;
 
-	p = (u8 *)ptrs[disks-2];
-	q = (u8 *)ptrs[disks-1];
-
-	/* Compute syndrome with zero for the missing data pages
-	   Use the dead data pages as temporary storage for
-	   delta p and delta q */
+	p = (u8 *)ptrs[disks - 2];
+	q = (u8 *)ptrs[disks - 1];
+
+	/*
+	 * Compute syndrome with zero for the missing data pages
+	 * Use the dead data pages as temporary storage for
+	 * delta p and delta q
+	 */
 	dp = (u8 *)ptrs[faila];
 	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-2] = dp;
@@ -190,20 +192,22 @@ static void raid6_datap_recov_avx2(int disks, size_t bytes, int faila,
 	const u8 *qmul;		/* Q multiplier table */
 	const u8 x0f = 0x0f;
 
-	p = (u8 *)ptrs[disks-2];
-	q = (u8 *)ptrs[disks-1];
+	p = (u8 *)ptrs[disks - 2];
+	q = (u8 *)ptrs[disks - 1];
 
-	/* Compute syndrome with zero for the missing data page
-	   Use the dead data page as temporary storage for delta q */
+	/*
+	 * Compute syndrome with zero for the missing data page
+	 * Use the dead data page as temporary storage for delta q
+	 */
 	dq = (u8 *)ptrs[faila];
 	ptrs[faila] = raid6_get_zero_page();
-	ptrs[disks-1] = dq;
+	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dq;
-	ptrs[disks-1] = q;
+	ptrs[disks - 1] = q;
 
 	/* Now, pick the proper data tables */
 	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila]]];
-- 
2.34.1

