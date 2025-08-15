Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013015.outbound.protection.outlook.com [40.107.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85932BD5AD;
	Fri, 15 Aug 2025 01:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755222892; cv=fail; b=DmXObrP1bh8V8vqwD1mPXrC31HrlWeLWpTTFa94m92NUXUqkL0ef0H3lh+RLr/Bw2U3065C2IWfy/FmU5GHIvjjYXDz+Ysw7I20MfG+w/qMnxBQxxa7sZn68wSu5n00flF6IOW+tZg/kVaLjsg8OfiOieMgV7zA5LVCtUjuVGo4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755222892; c=relaxed/simple;
	bh=EzOPGHs6uyPCkKs4Dk44RGhSjIUcHzEEQfPnmot3xbk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kSMB02xZ77J4R1hN2VBUrfpYUdjgsCTcj3jbpjiq9BRzVes7KoPCVAJbJDgCP0GT9oMd6wlz44TRnriQQ9+Z4FaMt7dO/tOLZ2QSywxZO3Tj8kdQAPA/RjnhNwDAX3WMb3724OqYpFqMIqoxW+QUnpd36gXa6vPleYra+z7Kn6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=G6ri1xIg; arc=fail smtp.client-ip=40.107.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="G6ri1xIg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fL8ibr/AFdjimCGSn8vouVv8XhdK3lmOB/rdlZQ3CVEI99hSAY7QNf5IGq8TsgEPgWUJuoManbmWugKKkfuAhfXqG/pkyeM9kuXQinZr9Eo/L3XRpd1g7mZU9cPHxup941iOXSXTKfHmWYMLAKKGbBBmh/yMR1+D5IhO4wckmwsGB6M1yxHl/iLsCboB7N4g2AO9Mvcz6CXvgbfBwFck3uGYVsxC2hMc+bjsQxH4x5+gKtwC9a6MgmRnQJE9DD32iB9rJVrWn62XXoikvPcr22iKDsr4FgO7ZNXkuOj5AkZqMOzRlDOcc87Ntet8vdZ7lKuw8gtB+BEJBUMZV4sBEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S8yhrTvgUssdsmDlR6tuMDml79xmGZ9ydSbYY5GgI4Q=;
 b=h8soz3j1cSJsmnRVyBW+UQuicrs4wipEF7aId1X7sKK6N/fvDAqDyQrQ/aN/D9MXKhL5OrHZZ/HYSiiCnJKGSWHX2XMa3P3ns63gRYz87B7GbKxpQsCERrjJ7NKAjHFrTp3rEJAx4k6xFM805T7ZO0UJzBroaZ0Ogyr+gsTOvcUGdYc47ID9SRcPqoFz4CpgXO1m6MyopU/CoxjZJENvUpPHkrwdS1ThIavY1I+9q9/hJIyXa8vsWwb3utN8XNRc1rgG+g8GAo5+hlkHbnxRJYcWU3oTGDIETRJ2AJq5nIJLaA/Wcx9GZPk3j8EisiN2fJrU0FYV0nLv6S6fbdNsdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8yhrTvgUssdsmDlR6tuMDml79xmGZ9ydSbYY5GgI4Q=;
 b=G6ri1xIgejr5LSWKn1iqRc/iB3PbBwo6uxa57ySuNtFm6loS6+LzDHakfPk2AfkEINN0/qV+6rwVicbju3wnN/0UiqDeFTGlH/4ZOz1lIuVQjA/1z8KrIbQn9fQdB+CCxMfG2H+a+yfZlquT0yl8dT6cWXmpurZUP/+T3c2Y92kPTAURI42LFVRiCgRQYeSuKUxn1dVsIR4GgBQq80+VQzO5bLyX4/oqgVifDW5Cn8mJ90yxeFLvNxYux9b09EX1cWX4SkyXkMM4KzML415Vdum436Zy+yu4kbnYL4OKamwsfA79banQYmpMV7UoEZzIHza7NE4x8kVad50n2bAWUQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by OSQPR06MB7974.apcprd06.prod.outlook.com (2603:1096:604:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 01:54:40 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 01:54:40 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH v1 09/13] lib/raid6: Clean up code style in mmx.c
Date: Fri, 15 Aug 2025 09:53:58 +0800
Message-Id: <20250815015404.468511-10-zhao.xichao@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: ced6e114-b3e2-49d0-546e-08dddb9eb246
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v3aZF1HpPOZ05P9CFeJG5ACZGL6J7r4Buh0c//2zB66wu44skwTq+IiEtznA?=
 =?us-ascii?Q?arkIUqn4skiPSmMlR0zNrqdBVDA00F6l5VQLoD+vA3YJMKXlPJHb+2qVpFye?=
 =?us-ascii?Q?r66LVU4pJR5DSyEMlHiXScC2RDqMt7s1d6HS6m9+AiD6cfg2x+A+XcaTaYur?=
 =?us-ascii?Q?YWcAFMRsf6pFGRV8tJkDEdx6q6pfiXM7P2VgnNzq1AZ71KNF2CrSzBAd1wK/?=
 =?us-ascii?Q?O598d4sKYywyIejO3vE30oxjWWqwgrjXktAL3fUc1ayV7CJUTDokHSSvxRco?=
 =?us-ascii?Q?vwlBeajlGcxhF6OCXNQWZJkVzqUySFmgyRUoaij6ea4aQCBoPB9qbbKMnJW1?=
 =?us-ascii?Q?6HkbCM7jf1IQkyW2cjdZTyouqJ4JhNZ8OXzzjJCgkwX81TSJT1iu8LuTOIOk?=
 =?us-ascii?Q?BBaA4tbjpdY05aN+MAHIGW5LkwWvqOdjhsRvIXamdw4Ebum+E2WC3qQEZEHw?=
 =?us-ascii?Q?cdpg7nppgoZoNxfbHtro5FdiLBTk3yfGiHXYQnGhBHLjOqowEZLffIbvS1Sl?=
 =?us-ascii?Q?AVB9RXWvRKUZrKsQ7MvI2asqxLAxfN0fCsf7H2qzmBbeKSQBaD9jvycZRItH?=
 =?us-ascii?Q?Q61QfCyZSeqoggmcINDnaUkp91mGr/R8Xoq8LM5BLTimHfkJCeEmbwWTuT3G?=
 =?us-ascii?Q?OwSAEg2pC1u5pRZ/OSuX0D6Gw34wdZ6yukOem7azWnpXMrqjbqkD8FCdcrNn?=
 =?us-ascii?Q?xOGcm3KcayWfJaEh2D+y6o5bEzhXbM3KFj7sTCfxzB3O3lAkESebX+jgL/jB?=
 =?us-ascii?Q?ocWLclM55KvKLqxi/Vrq/dX2TUlbER6nFpruZfqhiBLwA7T9iyOa+2PlnerE?=
 =?us-ascii?Q?1pP0sjs4PEmgh+7UCj97DrdfwkS7y+LWMI18dViEsP9yZw1WMzA/E0Sb3SZE?=
 =?us-ascii?Q?eDgYqAHtyDRP7b3OuMYylrGDv1IY30iBhxAB4XcWzYjHCtgpbV7yZaN1msaQ?=
 =?us-ascii?Q?p4qncQOfxDYe2psJjz9OC9MlmkOnKyuqhbH05Q6azm8cqoxw0AcvXTCoRO6B?=
 =?us-ascii?Q?lZSqDeFTSfsV6s+30s+Qr0jbowcF1/2uWgTz43wcr2lycypG0q9HwRh4xXez?=
 =?us-ascii?Q?SYO2a9riVIMzldrmM4PiTxOGVlG3fgiItTsy5kZpmMiJfItTDOImuw2zY4wv?=
 =?us-ascii?Q?JP1ouJMdtqNGtEs/5R0a2GahD4LW4lw+n+iHbkcQNPg13p1yiVwknVnILc0x?=
 =?us-ascii?Q?4fXSMrbhsavAKHUfjKrs08h6db7LD4NSJ8zg5pXn8rtuYPCZkxXpyyBh4g8Z?=
 =?us-ascii?Q?01s/tNnYz8dJTk7CATXUGNwC+B5KV6hkCX/HrKOzFba1GhVED9J8GfnUlsGT?=
 =?us-ascii?Q?FKYOZj948QtrlM0QVeGWHx8JbnM5JbqHvakpLlTPKIVIV9I/2/wq2xOsmDMp?=
 =?us-ascii?Q?ZHciu5ZnCH5bWu/+JqM7F4Zoq/frspcocow488plB3Gkf5GGQQeNymLxqlHW?=
 =?us-ascii?Q?pcbcpwRQy6V/E2aoSznzKXlRkK1FbvGXKki9RoJgyR5/JZfBO+tFXg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MBq9EUSRPHGGkoyvS36if4LG42RGwZujZhXgr2SkmYEMUhU4DbRM3sUowjGl?=
 =?us-ascii?Q?hVZOvABSw1MbRflQLdHilx0IOZ4CnH1VylZXaZLjtwssmq3fzE3S1G1ISPly?=
 =?us-ascii?Q?dBsWhxBDd/QYxn3ydne2w+h/H7Ss9cgzjgnKs5Mue7RV7kFs1LyUbBfjOUBD?=
 =?us-ascii?Q?8s4AyRVawlFQrqbhOUcOm0CJkEnuZbUTP9azKRT+ZRoIl3gj+/L+QE+s+G2V?=
 =?us-ascii?Q?GiyPM2P9mAR8fvMtVcv6kUU2XmNxA3w9VjR0OvlbsCSjgmaQJJUFopONycNp?=
 =?us-ascii?Q?X7a644TmCUVhPq1zIk/QCC59JBYsmse/DFClAAM5s4CZfpZWjbefC4raPVTr?=
 =?us-ascii?Q?+QBnLRwFYGe386TL9R5YN2RSQKeUSQRgZ38o58mX9C3ZR/V8P1uzr2FcTVEj?=
 =?us-ascii?Q?ZE5kpmmNqN65tnvvLtUwxq22oFkEiOg3lRLhaKXSOKW7reliowS6wIn5qZrD?=
 =?us-ascii?Q?qUY9WpLj8klVLs6odJC8gv0heRzBjcz4X1X3M1P0MNTsFKkEJWkQjCuDBdYM?=
 =?us-ascii?Q?xpwT6zM+4uxT43oBdyS+/qzpJhnlsvZSSxbwEU2ZW3R2gPfZqTwXwfwz3eAJ?=
 =?us-ascii?Q?pwg+6EG6kHWSvWVYCCYCQf4GWVzp7NTg+HRDeD/qUiHwpjZFRyypfmEkpUgR?=
 =?us-ascii?Q?TjKQ8j+QRsrrYmLlPBel9U6ZBF9gOFUKWrcFtXlmDlXw4eagi7xwxSnXoF/m?=
 =?us-ascii?Q?5kgy+OPJQEvHiBly/Zkp6GjQKqwRK2ndcghTkgeVFrUbxpDnFmG8W0qbcUsQ?=
 =?us-ascii?Q?bw6cl2crpBHUv5S+ZbiSaD4QJD9gTDMbxYurhrKb4F3INIwi3pqKycN0AhMK?=
 =?us-ascii?Q?e0qhGGv1KyIQj8XI5ZzrOSeBXw1zv4uP/tfn9KoWeUvxqg19wucgiwyhbZF/?=
 =?us-ascii?Q?cesfjP6Cf+Ddev3TC4ErgZHQs2Pq57YZ2BQ/ePDAg3yrt6637sIknz3Fws6p?=
 =?us-ascii?Q?pJLuevdIxueb1F+HYtp9c0EPojUX5mrvAoVvpJC+rRsXGZJoQAwJRHZaSzbt?=
 =?us-ascii?Q?SPUK1cXhqgMij3Nx8JsN0u0v5x0poR//llY3OnoKf4nj8PzXuej5ezpsWPjt?=
 =?us-ascii?Q?6or1RpBCqBgJ3bMOLnKL4e1pBspxWPCxIzNFKLcihcV2k9EO4CzXMacH2RRV?=
 =?us-ascii?Q?7Qf0rOdzsHCA/f0T+YK2D3ooHF+N/cbP0fMkhFHlyfy0SqvGDdMB/bXYtlXQ?=
 =?us-ascii?Q?a1eY4AHFI9kk74Vq68sacxeUh5IoCiValg1Z1cfU332+Zb81totT83iK9txG?=
 =?us-ascii?Q?s1nlS3diN9PhD681o1nmT+L7cNefK3+PP5QFsQwG4xxoZDIl79QxkMWiK5cR?=
 =?us-ascii?Q?bxe3mZW5wEW9wkXjgtU6xYqSRqh9MtvpyrfeySc+F0/xRgNsAxZO8k9y13ty?=
 =?us-ascii?Q?aHeYLRwfjpLBdatnFiYaKlt6KuyGeLWsyn0BBGhxtQZHaeew2PEXqwe/bQil?=
 =?us-ascii?Q?81OpBQbmgpg9uUQLJN0mYNCSddntQsw8aoj9/9UL1BV5y1lf6ZbJNAbeH6c4?=
 =?us-ascii?Q?3RYf1e0C0YoPvNbXtyNn0+w47appeeBHQsePHHsxo+Q8lSMoZjOo2IXraKLN?=
 =?us-ascii?Q?vaOMGiB70CrkSMfLB95TZUlrekrk8M15oldEZx3G?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ced6e114-b3e2-49d0-546e-08dddb9eb246
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 01:54:40.0346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pu76lDaNP/wm1OZtrY2BsCz9/t8Lt9BUDAKuX8G5YOfZ9YIKk3wf/b/1GLbwps94egjRlxTgHV/D2kEqzuQGfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7974

Reduce or add spaces to clean up code style.
No functional changes here.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 lib/raid6/mmx.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/lib/raid6/mmx.c b/lib/raid6/mmx.c
index 3a5bf53a297b..91e5ae78759e 100644
--- a/lib/raid6/mmx.c
+++ b/lib/raid6/mmx.c
@@ -39,18 +39,18 @@ static void raid6_mmx1_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	int d, z, z0;
 
 	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0+1];		/* XOR parity */
-	q = dptr[z0+2];		/* RS syndrome */
+	p = dptr[z0 + 1];	/* XOR parity */
+	q = dptr[z0 + 2];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
 	asm volatile("movq %0,%%mm0" : : "m" (raid6_mmx_constants.x1d));
 	asm volatile("pxor %mm5,%mm5");	/* Zero temp */
 
-	for ( d = 0 ; d < bytes ; d += 8 ) {
+	for (d = 0; d < bytes; d += 8) {
 		asm volatile("movq %0,%%mm2" : : "m" (dptr[z0][d])); /* P[0] */
 		asm volatile("movq %mm2,%mm4");	/* Q[0] */
-		for ( z = z0-1 ; z >= 0 ; z-- ) {
+		for (z = z0 - 1; z >= 0; z--) {
 			asm volatile("movq %0,%%mm6" : : "m" (dptr[z][d]));
 			asm volatile("pcmpgtb %mm4,%mm5");
 			asm volatile("paddb %mm4,%mm4");
@@ -87,8 +87,8 @@ static void raid6_mmx2_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	int d, z, z0;
 
 	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0+1];		/* XOR parity */
-	q = dptr[z0+2];		/* RS syndrome */
+	p = dptr[z0 + 1];	/* XOR parity */
+	q = dptr[z0 + 2];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
@@ -96,12 +96,12 @@ static void raid6_mmx2_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	asm volatile("pxor %mm5,%mm5");	/* Zero temp */
 	asm volatile("pxor %mm7,%mm7"); /* Zero temp */
 
-	for ( d = 0 ; d < bytes ; d += 16 ) {
+	for (d = 0; d < bytes; d += 16) {
 		asm volatile("movq %0,%%mm2" : : "m" (dptr[z0][d])); /* P[0] */
-		asm volatile("movq %0,%%mm3" : : "m" (dptr[z0][d+8]));
+		asm volatile("movq %0,%%mm3" : : "m" (dptr[z0][d + 8]));
 		asm volatile("movq %mm2,%mm4"); /* Q[0] */
 		asm volatile("movq %mm3,%mm6"); /* Q[1] */
-		for ( z = z0-1 ; z >= 0 ; z-- ) {
+		for (z = z0 - 1; z >= 0; z--) {
 			asm volatile("pcmpgtb %mm4,%mm5");
 			asm volatile("pcmpgtb %mm6,%mm7");
 			asm volatile("paddb %mm4,%mm4");
@@ -111,7 +111,7 @@ static void raid6_mmx2_gen_syndrome(int disks, size_t bytes, void **ptrs)
 			asm volatile("pxor %mm5,%mm4");
 			asm volatile("pxor %mm7,%mm6");
 			asm volatile("movq %0,%%mm5" : : "m" (dptr[z][d]));
-			asm volatile("movq %0,%%mm7" : : "m" (dptr[z][d+8]));
+			asm volatile("movq %0,%%mm7" : : "m" (dptr[z][d + 8]));
 			asm volatile("pxor %mm5,%mm2");
 			asm volatile("pxor %mm7,%mm3");
 			asm volatile("pxor %mm5,%mm4");
@@ -120,9 +120,9 @@ static void raid6_mmx2_gen_syndrome(int disks, size_t bytes, void **ptrs)
 			asm volatile("pxor %mm7,%mm7");
 		}
 		asm volatile("movq %%mm2,%0" : "=m" (p[d]));
-		asm volatile("movq %%mm3,%0" : "=m" (p[d+8]));
+		asm volatile("movq %%mm3,%0" : "=m" (p[d + 8]));
 		asm volatile("movq %%mm4,%0" : "=m" (q[d]));
-		asm volatile("movq %%mm6,%0" : "=m" (q[d+8]));
+		asm volatile("movq %%mm6,%0" : "=m" (q[d + 8]));
 	}
 
 	kernel_fpu_end();
-- 
2.34.1

