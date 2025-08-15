Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013015.outbound.protection.outlook.com [40.107.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE342BEC41;
	Fri, 15 Aug 2025 01:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755222898; cv=fail; b=s0hLAkftKCSdH0gptYEcoksBurceu14p5ZUaQOrTIxKmzJH10hUp/4jccdkD6WcSufMcOAik0/mvBdLdinH/VaLwEPao2uYAOm8BMgGuUf1ifYoz3KCO56nptjJPqZP6WmfybcMi2bMr2UZBrfngqu0oDTrJE2FtINRgh6QDBn4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755222898; c=relaxed/simple;
	bh=2+dcjVWRZQwXsHTRxYajmj0J+dKa/dp92ZkvSfA+/ak=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Zd1hpkloFhKNqdHIGt2MIlfkCFsYpr5DYtRPM9RbIPP99kCqiE82QVtIUdHZodVkABzS20rRr6rJDPifcUnvaMwYNfB/lLAa+GVlfcdzSOHxV2k+c4TjAuLnEaBkZG9+krGcyMpYaMlJPvdqkT9idaOSKC09zJN6ZU8l8jH3Nak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=LomhmXLd; arc=fail smtp.client-ip=40.107.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="LomhmXLd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qcBJBD4YCwm1sTMt/nkvx2yOQYrykPWeYN2sO/rOjWqYhRw7EVb5jnJM6xV31QJTAfZrqnxacIX5Yw9HuwQSTXdZCGiT4QKGwkrF2dSKpLLJyc+rWTFeGlgNZigoE+vH5n2VRLBTCGdZml5DvN7O/r49iPOhumD9wn9K2kBcKiXIzWfRbGBh5el+isyiMoek+8sF4P4g23SGT1ZAKFhfG8oCHIPcZWXYJPJD7aRVXgga0SYoQS5WZ+JWq3ANq3GVlSGUbNMbTxSX3Rmz2NAPdVMfcafAID7s8to1onZezi0XDuxQRH3MenKk//ghLt5E1Arz3NXUUlgOjUOtv6XfBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NPb7QLkSXfT972i0sKH941i08O5owcKy+dQeZ2U5iE4=;
 b=hbLU1CSSw2c2cKEt83JvzOKgHlTd7pDqTJJ5PWJZFBZGVGpEvO8L7EbNNX/VLG4q7lzhnXDwN828+DYaLdBL+WCZq+if5TybuONsPejVe6ni0F8INBZwQoEtC6znFZXwSy/StteJ6nsycb+j0Q7T8zRSdzsuPClzn1uiJKoj7bV0SP5nVthmEJcuYJDYF5pMbjsYUVnMicwXOc8D7vM37FpiDmDXMGY19NYW/tr4vAs5zMeAoXlua7dsqmbINOzkxFqChIxmPws4drLyf9TxyHFxTPmI9lbvvrJy7pd+ws3iJqB/fF/K+oSQ3BY8tfkRzn+R0XPQu1QtIURnJDazfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPb7QLkSXfT972i0sKH941i08O5owcKy+dQeZ2U5iE4=;
 b=LomhmXLdT2qicBlVHsLPxf1pxYAFeE/fqaELqG/2CIYT9JZB4Xr4fxjsrysZ/N8/Wkko0yFOBw0WfdmjR8PL7MYbVPIi3/+TwNXhf9XP68JzLvpI8xiRxmRhPBVitXfKyBeXU7F898APoMJ67lld01qX15N6ZmEeXTMexCWeCIM8v7AIlo0vqKy2bNybkD23nHgKAm4g5H/FeIC68WxAYNNwien2W1XSBd2NyVrOALnW7TQzCO6gIQAJFCZY6kL7Q59hdsLviANGf/xFXqzAElPiPL0DEUn4escBOywHNP6ieIakfhAwbw7t9UdAMulUzedycK34tlwQy5f6jpmQjw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by OSQPR06MB7974.apcprd06.prod.outlook.com (2603:1096:604:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 01:54:45 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 01:54:45 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH v1 13/13] lib/raid6: Clean up code style in avx2.c
Date: Fri, 15 Aug 2025 09:54:02 +0800
Message-Id: <20250815015404.468511-14-zhao.xichao@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: e2afee78-2d4c-474e-7958-08dddb9eb52e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XRUTKLW9FPNJuEywWTJ6qPpEwOmIqQA/gs50MzFu7YuFHeQmJZgiu7C1vDB3?=
 =?us-ascii?Q?KDlDLCHYJbZN9cCYiqUu8ZO06hZ7Q8SM/RTJM6bJSrZk3XNEXZQqJBiAL2Ra?=
 =?us-ascii?Q?zJBkBkkJ0xcZVxhpuR1fuu+jptAMLtLT/MyspXqqFLDRrQW3xHX0uHPa5/mj?=
 =?us-ascii?Q?bUT7sngSquWPUtm8rKf/hzWgeXx3lYoY7mRRPcxY3TgV3qzdzwspJrrhb36a?=
 =?us-ascii?Q?83AC4aEujQiz37bzX2EW/eGbUVEX+UWRjphEN3XMURF2BPrTXREF6fqRAbW8?=
 =?us-ascii?Q?zhuJFOORnajSe/Q4D5z6cPB+/UL9sMjt5n7u+3ejs9R2BExA6f+hs7ZLs/a2?=
 =?us-ascii?Q?R8AKYBEilcgZsynuWKnBFn19sTX4dtbDn/crcUZKjO+j5LZwUpowmOzSePNu?=
 =?us-ascii?Q?4EH+Y8hl7g6/3ny9fdqL8qDK58pxsctMHscV5f1zEfw1MWFaps2GjTXu5WqH?=
 =?us-ascii?Q?bUVMmqSnZTMEC7NTDrIO/hZC0v36z9Dxr0oWvqgBRQ1fz/6/vHkxSNTB+y7E?=
 =?us-ascii?Q?nBwzw4kkcWvbXmc/gVSBjmIbmkmWpJrQcSbptuZK8pKOsPZHgO5whxxIzJyM?=
 =?us-ascii?Q?ADmvqZM0ZFThy1WdxwO+uGw/AmN3DREU9ZntAB9KALsaptyKOHcCdC2ldb9Y?=
 =?us-ascii?Q?ZP78lANDvqdM8BqlODrauZ0XX8pO5dbQAnWeKt7dq2B8kDlhgnYGwPfEh94k?=
 =?us-ascii?Q?B0ivTQdgpukXoxkiJ1ftO8o0Zv5pcZH39KguHG3V8kgntux9Q6bi5REBo183?=
 =?us-ascii?Q?S3n/UuJww95Is2TraWSjzUWZJpjKqk9dsv8mHLTSb8ObmH5lkS/Eh8x89tDT?=
 =?us-ascii?Q?4RO2+gJgcTD5lXbkm6sDnUbpfrJFjMqkc5/oQEXNtn8pcdxWQkru7Pdj102g?=
 =?us-ascii?Q?cbJH0RitxOnoYhuMR43CI4loLG40z4YuwQ5Sk8vHKEUPvUc9yaa1bms7kdIe?=
 =?us-ascii?Q?BgQh3CRe9F+JOincMRs6Xnzh/keAjunZK5lF8CWUMtuxzjXuZnebP7+5cvF+?=
 =?us-ascii?Q?B8U1/zhE+IAB+QK/S0VbqrTgaRZJ0PH5Ws2Ry8wF07fC0gEBzOzUOWrWUwTo?=
 =?us-ascii?Q?NtX5h/BRef6sYBgse7uHmXdfTDwaysAMjw5hbdifLvWGcHtVUcXuEDvCFQq3?=
 =?us-ascii?Q?exTtgF5MqXWgj8HpkI1Qf/ywx50futdjGlA6AYtg9YdYHJPufzz0ITdiX7ya?=
 =?us-ascii?Q?2HE0YPhHovIB6b98t6YqITRAEIMgnbh9sqZyNx0bOoGsDdByYtMw10JPBdNP?=
 =?us-ascii?Q?iVJyXEpP8rCKpW6ZP41L49yrxZKPVwIY0yPcNnk5X498LV7wNjL8QnENLREz?=
 =?us-ascii?Q?UE4RQ9NcSBlCJWPWcz8O8pBPNJezCFAxXH7qqUFkVZ3JhJ68h4ajHepqUVvl?=
 =?us-ascii?Q?ZJ6bM+tkSIwfdlOyngvMhBR6c3tZ5U2LcBkKGYJRlufnUqnjQ5FX9sGkHpWs?=
 =?us-ascii?Q?PUnmM3MS/zjcPEj9lZVIRBFUDO2hp9D9Do4ssWy4U+mwGapPTvGKQg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jyYA+eXOVrV3EP1QdNjbUs1Awufz1nJu+JBuLVM98ue/auoSpoefMkbcWo2H?=
 =?us-ascii?Q?CNXad2+HLQYMZQepYqqVHiiZ7unGUJXu60ZN8emI4ezeLX9R4wiP8y4RUgrA?=
 =?us-ascii?Q?YX5ati4N8kbit/Bnqmsex0DKT7F1ud/UUM4I7BS1O67SLs450l9c1z82+aiA?=
 =?us-ascii?Q?lr8Lk4uXEKGuRi12bJtokxpQXLFirb+I3sCcE/cnRFT5PVrH812qfXmuwNVS?=
 =?us-ascii?Q?grnQHM6aJYLyXw3zVVBlX7C9NmibJBulocJl82wueDzHqls8/0eRstnAgDyi?=
 =?us-ascii?Q?SaM8IcX/rU4zRz4hifnejgS59p/BGcBU3cIqNrIX7u3lycOR/Plj3Lfgb//8?=
 =?us-ascii?Q?uZUDPPogl/nhWpw/kOzPq0wpScei1l9zOJG/8M2wHPoktiCN208oD/5as7F2?=
 =?us-ascii?Q?S3tF1gpLZgKtPr4NhicnX1giw38CvhHXhdkc3EQyk2t0mA8V/yh67PdCbvc6?=
 =?us-ascii?Q?SOtms/No+YzzI9LAZx9V2gH0yHJWnLSrL0JhWlY3lC5RI5sMRIYws4E4hmO+?=
 =?us-ascii?Q?1q3CTnK+5uvl3nd3jt0deqv7DM32j6vl68f9TEMFvoYMqRrF3eaT2ErqS2Oe?=
 =?us-ascii?Q?LryESM9pkTVEiSpCm3UX42mFbv8ueNVugabWc051RoV8HADjumoyValqdhpR?=
 =?us-ascii?Q?uT9nZS4F8yI6OQ5wZ06adqCFG1+a57gxjAmNwJWkWOdEzPe0BA7Vs67QaVXc?=
 =?us-ascii?Q?efHnj2vqE5vbfkkWyLmMmQtLkTbWcH1FC9DXbiA5rj5At7EvQdKgqDtHdO1I?=
 =?us-ascii?Q?AN0FGVVeg+esLB5hTOJu+qEXsXgnHtkt46+WdYl+Ogd2xUHvI4U3P8m5gh7Z?=
 =?us-ascii?Q?0drXUQPFkERq4tutBNCd+j3JRjbSJe1dVV9/a1B30EFimXJZyWqkU3+AJEDT?=
 =?us-ascii?Q?yBfWmBETZHVxVhpK92KEQ83QCeHl6VYx0PLVrkXVh15fQDov4DAX8qD8r0Hv?=
 =?us-ascii?Q?tr14yzL7GRQgscf3vVQ3XFs/QyCcJb2jiON9uSd6aW52NJD4EMVXjYXFloUS?=
 =?us-ascii?Q?ePkQLUCawQWxvGkb7crF6tkVFdYZp6r1yTGpPAMMKnG+CbRVDE1GvLpHnL5n?=
 =?us-ascii?Q?GwXLJtgGGShhtd9sGKKFDB531+mvQj8mrcT1pUttiNkk+aA0AYPImAyCXTJa?=
 =?us-ascii?Q?5G3/nFOmBIP3H1mPa1Mjs6OhKGO6n4vUyWJ29cMnkJYfD2mr+Pej72amb/os?=
 =?us-ascii?Q?Kzovju/ZrpQ/yZ+0Tvpd7M02DixjS/EDMH/h44NG9u0YFOOWZg8/c2cPWjYJ?=
 =?us-ascii?Q?ctikKpnBu9drlGCvOI/Oe0r+KBdd9FDHnPgownbwUgX2jHhKvyvgX6TCrpRp?=
 =?us-ascii?Q?faetAdf7ODN9nIU6PgId74g1/TOUA9owDblJzgJU9uKyCKd1OooSWHqCElyL?=
 =?us-ascii?Q?EGRNZC12CSEpFR8mdcQUQA4jRCv7hsJ4YAWHkw6pgs9HCBwvTx8xByr9aRwN?=
 =?us-ascii?Q?xW/hiKR2XUFksZuG29MjSFWCfhVEGcd+jp7ETPyACZkvQb4HrqqmqJBcGRIK?=
 =?us-ascii?Q?cZ+4onKn/qBCwq1cEhXQg0L9QQ9Jq7Sc7Lx5grceiyJLTzFTgTjM3DrAEBra?=
 =?us-ascii?Q?ING+ULdN/LuOUc5wcb7+v94/zuz0nIDIF3b32Hs3?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2afee78-2d4c-474e-7958-08dddb9eb52e
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 01:54:44.9480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ca16KcoQgGGcZspeRJaCLkfvXyKy/BwHA3iHUxedGsNAUbyxJVOrL9cWm8kqIaBCtVa8d2BydjUPCabVUNUF8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7974

Reduce or add spaces to clean up code style.
No functional changes here.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 lib/raid6/avx2.c | 122 +++++++++++++++++++++++------------------------
 1 file changed, 61 insertions(+), 61 deletions(-)

diff --git a/lib/raid6/avx2.c b/lib/raid6/avx2.c
index 059024234dce..949f6a71d810 100644
--- a/lib/raid6/avx2.c
+++ b/lib/raid6/avx2.c
@@ -87,19 +87,19 @@ static void raid6_avx21_xor_syndrome(int disks, int start, int stop,
 	int d, z, z0;
 
 	z0 = stop;		/* P/Q right side optimization */
-	p = dptr[disks-2];	/* XOR parity */
-	q = dptr[disks-1];	/* RS syndrome */
+	p = dptr[disks - 2];	/* XOR parity */
+	q = dptr[disks - 1];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
 	asm volatile("vmovdqa %0,%%ymm0" : : "m" (raid6_avx2_constants.x1d[0]));
 
-	for (d = 0 ; d < bytes ; d += 32) {
+	for (d = 0; d < bytes; d += 32) {
 		asm volatile("vmovdqa %0,%%ymm4" :: "m" (dptr[z0][d]));
 		asm volatile("vmovdqa %0,%%ymm2" : : "m" (p[d]));
 		asm volatile("vpxor %ymm4,%ymm2,%ymm2");
 		/* P/Q data pages */
-		for (z = z0-1 ; z >= start ; z--) {
+		for (z = z0 - 1; z >= start; z--) {
 			asm volatile("vpxor %ymm5,%ymm5,%ymm5");
 			asm volatile("vpcmpgtb %ymm4,%ymm5,%ymm5");
 			asm volatile("vpaddb %ymm4,%ymm4,%ymm4");
@@ -145,8 +145,8 @@ static void raid6_avx22_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	int d, z, z0;
 
 	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0+1];		/* XOR parity */
-	q = dptr[z0+2];		/* RS syndrome */
+	p = dptr[z0 + 1];	/* XOR parity */
+	q = dptr[z0 + 2];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
@@ -156,14 +156,14 @@ static void raid6_avx22_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	/* We uniformly assume a single prefetch covers at least 32 bytes */
 	for (d = 0; d < bytes; d += 64) {
 		asm volatile("prefetchnta %0" : : "m" (dptr[z0][d]));
-		asm volatile("prefetchnta %0" : : "m" (dptr[z0][d+32]));
-		asm volatile("vmovdqa %0,%%ymm2" : : "m" (dptr[z0][d]));/* P[0] */
-		asm volatile("vmovdqa %0,%%ymm3" : : "m" (dptr[z0][d+32]));/* P[1] */
+		asm volatile("prefetchnta %0" : : "m" (dptr[z0][d + 32]));
+		asm volatile("vmovdqa %0,%%ymm2" : : "m" (dptr[z0][d]));	 /* P[0] */
+		asm volatile("vmovdqa %0,%%ymm3" : : "m" (dptr[z0][d + 32]));/* P[1] */
 		asm volatile("vmovdqa %ymm2,%ymm4"); /* Q[0] */
 		asm volatile("vmovdqa %ymm3,%ymm6"); /* Q[1] */
-		for (z = z0-1; z >= 0; z--) {
+		for (z = z0 - 1; z >= 0; z--) {
 			asm volatile("prefetchnta %0" : : "m" (dptr[z][d]));
-			asm volatile("prefetchnta %0" : : "m" (dptr[z][d+32]));
+			asm volatile("prefetchnta %0" : : "m" (dptr[z][d + 32]));
 			asm volatile("vpcmpgtb %ymm4,%ymm1,%ymm5");
 			asm volatile("vpcmpgtb %ymm6,%ymm1,%ymm7");
 			asm volatile("vpaddb %ymm4,%ymm4,%ymm4");
@@ -173,7 +173,7 @@ static void raid6_avx22_gen_syndrome(int disks, size_t bytes, void **ptrs)
 			asm volatile("vpxor %ymm5,%ymm4,%ymm4");
 			asm volatile("vpxor %ymm7,%ymm6,%ymm6");
 			asm volatile("vmovdqa %0,%%ymm5" : : "m" (dptr[z][d]));
-			asm volatile("vmovdqa %0,%%ymm7" : : "m" (dptr[z][d+32]));
+			asm volatile("vmovdqa %0,%%ymm7" : : "m" (dptr[z][d + 32]));
 			asm volatile("vpxor %ymm5,%ymm2,%ymm2");
 			asm volatile("vpxor %ymm7,%ymm3,%ymm3");
 			asm volatile("vpxor %ymm5,%ymm4,%ymm4");
@@ -197,22 +197,22 @@ static void raid6_avx22_xor_syndrome(int disks, int start, int stop,
 	int d, z, z0;
 
 	z0 = stop;		/* P/Q right side optimization */
-	p = dptr[disks-2];	/* XOR parity */
-	q = dptr[disks-1];	/* RS syndrome */
+	p = dptr[disks - 2];	/* XOR parity */
+	q = dptr[disks - 1];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
 	asm volatile("vmovdqa %0,%%ymm0" : : "m" (raid6_avx2_constants.x1d[0]));
 
-	for (d = 0 ; d < bytes ; d += 64) {
+	for (d = 0; d < bytes; d += 64) {
 		asm volatile("vmovdqa %0,%%ymm4" :: "m" (dptr[z0][d]));
-		asm volatile("vmovdqa %0,%%ymm6" :: "m" (dptr[z0][d+32]));
+		asm volatile("vmovdqa %0,%%ymm6" :: "m" (dptr[z0][d + 32]));
 		asm volatile("vmovdqa %0,%%ymm2" : : "m" (p[d]));
-		asm volatile("vmovdqa %0,%%ymm3" : : "m" (p[d+32]));
+		asm volatile("vmovdqa %0,%%ymm3" : : "m" (p[d + 32]));
 		asm volatile("vpxor %ymm4,%ymm2,%ymm2");
 		asm volatile("vpxor %ymm6,%ymm3,%ymm3");
 		/* P/Q data pages */
-		for (z = z0-1 ; z >= start ; z--) {
+		for (z = z0 - 1; z >= start; z--) {
 			asm volatile("vpxor %ymm5,%ymm5,%ymm5");
 			asm volatile("vpxor %ymm7,%ymm7,%ymm7");
 			asm volatile("vpcmpgtb %ymm4,%ymm5,%ymm5");
@@ -225,14 +225,14 @@ static void raid6_avx22_xor_syndrome(int disks, int start, int stop,
 			asm volatile("vpxor %ymm7,%ymm6,%ymm6");
 			asm volatile("vmovdqa %0,%%ymm5" :: "m" (dptr[z][d]));
 			asm volatile("vmovdqa %0,%%ymm7"
-				     :: "m" (dptr[z][d+32]));
+				     :: "m" (dptr[z][d + 32]));
 			asm volatile("vpxor %ymm5,%ymm2,%ymm2");
 			asm volatile("vpxor %ymm7,%ymm3,%ymm3");
 			asm volatile("vpxor %ymm5,%ymm4,%ymm4");
 			asm volatile("vpxor %ymm7,%ymm6,%ymm6");
 		}
 		/* P/Q left side optimization */
-		for (z = start-1 ; z >= 0 ; z--) {
+		for (z = start - 1; z >= 0; z--) {
 			asm volatile("vpxor %ymm5,%ymm5,%ymm5");
 			asm volatile("vpxor %ymm7,%ymm7,%ymm7");
 			asm volatile("vpcmpgtb %ymm4,%ymm5,%ymm5");
@@ -245,12 +245,12 @@ static void raid6_avx22_xor_syndrome(int disks, int start, int stop,
 			asm volatile("vpxor %ymm7,%ymm6,%ymm6");
 		}
 		asm volatile("vpxor %0,%%ymm4,%%ymm4" : : "m" (q[d]));
-		asm volatile("vpxor %0,%%ymm6,%%ymm6" : : "m" (q[d+32]));
+		asm volatile("vpxor %0,%%ymm6,%%ymm6" : : "m" (q[d + 32]));
 		/* Don't use movntdq for r/w memory area < cache line */
 		asm volatile("vmovdqa %%ymm4,%0" : "=m" (q[d]));
-		asm volatile("vmovdqa %%ymm6,%0" : "=m" (q[d+32]));
+		asm volatile("vmovdqa %%ymm6,%0" : "=m" (q[d + 32]));
 		asm volatile("vmovdqa %%ymm2,%0" : "=m" (p[d]));
-		asm volatile("vmovdqa %%ymm3,%0" : "=m" (p[d+32]));
+		asm volatile("vmovdqa %%ymm3,%0" : "=m" (p[d + 32]));
 	}
 
 	asm volatile("sfence" : : : "memory");
@@ -277,8 +277,8 @@ static void raid6_avx24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	int d, z, z0;
 
 	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0+1];		/* XOR parity */
-	q = dptr[z0+2];		/* RS syndrome */
+	p = dptr[z0 + 1];	/* XOR parity */
+	q = dptr[z0 + 2];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
@@ -296,9 +296,9 @@ static void raid6_avx24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	for (d = 0; d < bytes; d += 128) {
 		for (z = z0; z >= 0; z--) {
 			asm volatile("prefetchnta %0" : : "m" (dptr[z][d]));
-			asm volatile("prefetchnta %0" : : "m" (dptr[z][d+32]));
-			asm volatile("prefetchnta %0" : : "m" (dptr[z][d+64]));
-			asm volatile("prefetchnta %0" : : "m" (dptr[z][d+96]));
+			asm volatile("prefetchnta %0" : : "m" (dptr[z][d + 32]));
+			asm volatile("prefetchnta %0" : : "m" (dptr[z][d + 64]));
+			asm volatile("prefetchnta %0" : : "m" (dptr[z][d + 96]));
 			asm volatile("vpcmpgtb %ymm4,%ymm1,%ymm5");
 			asm volatile("vpcmpgtb %ymm6,%ymm1,%ymm7");
 			asm volatile("vpcmpgtb %ymm12,%ymm1,%ymm13");
@@ -316,9 +316,9 @@ static void raid6_avx24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 			asm volatile("vpxor %ymm13,%ymm12,%ymm12");
 			asm volatile("vpxor %ymm15,%ymm14,%ymm14");
 			asm volatile("vmovdqa %0,%%ymm5" : : "m" (dptr[z][d]));
-			asm volatile("vmovdqa %0,%%ymm7" : : "m" (dptr[z][d+32]));
-			asm volatile("vmovdqa %0,%%ymm13" : : "m" (dptr[z][d+64]));
-			asm volatile("vmovdqa %0,%%ymm15" : : "m" (dptr[z][d+96]));
+			asm volatile("vmovdqa %0,%%ymm7" : : "m" (dptr[z][d + 32]));
+			asm volatile("vmovdqa %0,%%ymm13" : : "m" (dptr[z][d + 64]));
+			asm volatile("vmovdqa %0,%%ymm15" : : "m" (dptr[z][d + 96]));
 			asm volatile("vpxor %ymm5,%ymm2,%ymm2");
 			asm volatile("vpxor %ymm7,%ymm3,%ymm3");
 			asm volatile("vpxor %ymm13,%ymm10,%ymm10");
@@ -330,19 +330,19 @@ static void raid6_avx24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 		}
 		asm volatile("vmovntdq %%ymm2,%0" : "=m" (p[d]));
 		asm volatile("vpxor %ymm2,%ymm2,%ymm2");
-		asm volatile("vmovntdq %%ymm3,%0" : "=m" (p[d+32]));
+		asm volatile("vmovntdq %%ymm3,%0" : "=m" (p[d + 32]));
 		asm volatile("vpxor %ymm3,%ymm3,%ymm3");
-		asm volatile("vmovntdq %%ymm10,%0" : "=m" (p[d+64]));
+		asm volatile("vmovntdq %%ymm10,%0" : "=m" (p[d + 64]));
 		asm volatile("vpxor %ymm10,%ymm10,%ymm10");
-		asm volatile("vmovntdq %%ymm11,%0" : "=m" (p[d+96]));
+		asm volatile("vmovntdq %%ymm11,%0" : "=m" (p[d + 96]));
 		asm volatile("vpxor %ymm11,%ymm11,%ymm11");
 		asm volatile("vmovntdq %%ymm4,%0" : "=m" (q[d]));
 		asm volatile("vpxor %ymm4,%ymm4,%ymm4");
-		asm volatile("vmovntdq %%ymm6,%0" : "=m" (q[d+32]));
+		asm volatile("vmovntdq %%ymm6,%0" : "=m" (q[d + 32]));
 		asm volatile("vpxor %ymm6,%ymm6,%ymm6");
-		asm volatile("vmovntdq %%ymm12,%0" : "=m" (q[d+64]));
+		asm volatile("vmovntdq %%ymm12,%0" : "=m" (q[d + 64]));
 		asm volatile("vpxor %ymm12,%ymm12,%ymm12");
-		asm volatile("vmovntdq %%ymm14,%0" : "=m" (q[d+96]));
+		asm volatile("vmovntdq %%ymm14,%0" : "=m" (q[d + 96]));
 		asm volatile("vpxor %ymm14,%ymm14,%ymm14");
 	}
 
@@ -358,30 +358,30 @@ static void raid6_avx24_xor_syndrome(int disks, int start, int stop,
 	int d, z, z0;
 
 	z0 = stop;		/* P/Q right side optimization */
-	p = dptr[disks-2];	/* XOR parity */
-	q = dptr[disks-1];	/* RS syndrome */
+	p = dptr[disks - 2];	/* XOR parity */
+	q = dptr[disks - 1];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
 	asm volatile("vmovdqa %0,%%ymm0" :: "m" (raid6_avx2_constants.x1d[0]));
 
-	for (d = 0 ; d < bytes ; d += 128) {
+	for (d = 0; d < bytes; d += 128) {
 		asm volatile("vmovdqa %0,%%ymm4" :: "m" (dptr[z0][d]));
-		asm volatile("vmovdqa %0,%%ymm6" :: "m" (dptr[z0][d+32]));
-		asm volatile("vmovdqa %0,%%ymm12" :: "m" (dptr[z0][d+64]));
-		asm volatile("vmovdqa %0,%%ymm14" :: "m" (dptr[z0][d+96]));
+		asm volatile("vmovdqa %0,%%ymm6" :: "m" (dptr[z0][d + 32]));
+		asm volatile("vmovdqa %0,%%ymm12" :: "m" (dptr[z0][d + 64]));
+		asm volatile("vmovdqa %0,%%ymm14" :: "m" (dptr[z0][d + 96]));
 		asm volatile("vmovdqa %0,%%ymm2" : : "m" (p[d]));
-		asm volatile("vmovdqa %0,%%ymm3" : : "m" (p[d+32]));
-		asm volatile("vmovdqa %0,%%ymm10" : : "m" (p[d+64]));
-		asm volatile("vmovdqa %0,%%ymm11" : : "m" (p[d+96]));
+		asm volatile("vmovdqa %0,%%ymm3" : : "m" (p[d + 32]));
+		asm volatile("vmovdqa %0,%%ymm10" : : "m" (p[d + 64]));
+		asm volatile("vmovdqa %0,%%ymm11" : : "m" (p[d + 96]));
 		asm volatile("vpxor %ymm4,%ymm2,%ymm2");
 		asm volatile("vpxor %ymm6,%ymm3,%ymm3");
 		asm volatile("vpxor %ymm12,%ymm10,%ymm10");
 		asm volatile("vpxor %ymm14,%ymm11,%ymm11");
 		/* P/Q data pages */
-		for (z = z0-1 ; z >= start ; z--) {
+		for (z = z0 - 1; z >= start; z--) {
 			asm volatile("prefetchnta %0" :: "m" (dptr[z][d]));
-			asm volatile("prefetchnta %0" :: "m" (dptr[z][d+64]));
+			asm volatile("prefetchnta %0" :: "m" (dptr[z][d + 64]));
 			asm volatile("vpxor %ymm5,%ymm5,%ymm5");
 			asm volatile("vpxor %ymm7,%ymm7,%ymm7");
 			asm volatile("vpxor %ymm13,%ymm13,%ymm13");
@@ -404,11 +404,11 @@ static void raid6_avx24_xor_syndrome(int disks, int start, int stop,
 			asm volatile("vpxor %ymm15,%ymm14,%ymm14");
 			asm volatile("vmovdqa %0,%%ymm5" :: "m" (dptr[z][d]));
 			asm volatile("vmovdqa %0,%%ymm7"
-				     :: "m" (dptr[z][d+32]));
+				     :: "m" (dptr[z][d + 32]));
 			asm volatile("vmovdqa %0,%%ymm13"
-				     :: "m" (dptr[z][d+64]));
+				     :: "m" (dptr[z][d + 64]));
 			asm volatile("vmovdqa %0,%%ymm15"
-				     :: "m" (dptr[z][d+96]));
+				     :: "m" (dptr[z][d + 96]));
 			asm volatile("vpxor %ymm5,%ymm2,%ymm2");
 			asm volatile("vpxor %ymm7,%ymm3,%ymm3");
 			asm volatile("vpxor %ymm13,%ymm10,%ymm10");
@@ -421,7 +421,7 @@ static void raid6_avx24_xor_syndrome(int disks, int start, int stop,
 		asm volatile("prefetchnta %0" :: "m" (q[d]));
 		asm volatile("prefetchnta %0" :: "m" (q[d+64]));
 		/* P/Q left side optimization */
-		for (z = start-1 ; z >= 0 ; z--) {
+		for (z = start - 1; z >= 0; z--) {
 			asm volatile("vpxor %ymm5,%ymm5,%ymm5");
 			asm volatile("vpxor %ymm7,%ymm7,%ymm7");
 			asm volatile("vpxor %ymm13,%ymm13,%ymm13");
@@ -444,17 +444,17 @@ static void raid6_avx24_xor_syndrome(int disks, int start, int stop,
 			asm volatile("vpxor %ymm15,%ymm14,%ymm14");
 		}
 		asm volatile("vmovntdq %%ymm2,%0" : "=m" (p[d]));
-		asm volatile("vmovntdq %%ymm3,%0" : "=m" (p[d+32]));
-		asm volatile("vmovntdq %%ymm10,%0" : "=m" (p[d+64]));
-		asm volatile("vmovntdq %%ymm11,%0" : "=m" (p[d+96]));
+		asm volatile("vmovntdq %%ymm3,%0" : "=m" (p[d + 32]));
+		asm volatile("vmovntdq %%ymm10,%0" : "=m" (p[d + 64]));
+		asm volatile("vmovntdq %%ymm11,%0" : "=m" (p[d + 96]));
 		asm volatile("vpxor %0,%%ymm4,%%ymm4" : : "m" (q[d]));
-		asm volatile("vpxor %0,%%ymm6,%%ymm6" : : "m" (q[d+32]));
-		asm volatile("vpxor %0,%%ymm12,%%ymm12" : : "m" (q[d+64]));
-		asm volatile("vpxor %0,%%ymm14,%%ymm14" : : "m" (q[d+96]));
+		asm volatile("vpxor %0,%%ymm6,%%ymm6" : : "m" (q[d + 32]));
+		asm volatile("vpxor %0,%%ymm12,%%ymm12" : : "m" (q[d + 64]));
+		asm volatile("vpxor %0,%%ymm14,%%ymm14" : : "m" (q[d + 96]));
 		asm volatile("vmovntdq %%ymm4,%0" : "=m" (q[d]));
-		asm volatile("vmovntdq %%ymm6,%0" : "=m" (q[d+32]));
-		asm volatile("vmovntdq %%ymm12,%0" : "=m" (q[d+64]));
-		asm volatile("vmovntdq %%ymm14,%0" : "=m" (q[d+96]));
+		asm volatile("vmovntdq %%ymm6,%0" : "=m" (q[d + 32]));
+		asm volatile("vmovntdq %%ymm12,%0" : "=m" (q[d + 64]));
+		asm volatile("vmovntdq %%ymm14,%0" : "=m" (q[d + 96]));
 	}
 	asm volatile("sfence" : : : "memory");
 	kernel_fpu_end();
-- 
2.34.1

