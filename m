Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013015.outbound.protection.outlook.com [40.107.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1098F2BE03F;
	Fri, 15 Aug 2025 01:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755222895; cv=fail; b=D21DqUCJM8XAsq/D5uM4TzP9OD0C7A3fp2QvgzJYUlTfeMgv9Mqo6lECHODiD796yappHf1aT/cuKeNufSnNc6tAQLoimt+NoVgyFcTM8dj5s2AANkjDQNbiVF6kfu+kZmubSdw0KRvwxq84o5+PMTIvjh7YqaAi768tF6Z4mMM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755222895; c=relaxed/simple;
	bh=fhpvyrm3G+mb93okTJuk9WM2YBlb013LSnSBQRD/YV8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hzjuiz9etturBvBZQS6A6PagD03IrSozM9VitsGNkxuV/xs3WOwZ3+hNXmIdllYo2iWfPFMejjJH+MKwCdcNGi2v6LY/ezHq0wB0LCIsY9xe/9q4n+1c18LHacO8mzbi/2Jxzv/rNtdvcnVWqRF3nMGTvCsgtTmle9U1ki6wgc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=g589VL0J; arc=fail smtp.client-ip=40.107.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="g589VL0J"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ouSWXCYDoGbu1iGKFtODJ7AG1yaW+sBgdps/WrJWpcBGuiXgPpItLnVEhgWhMuK9i0726xw+hd7jSGKzYlxCN3urm2TvMxWtvv1HvRnJ8yLAO5hLY1BI/mpBMq/evissyYO4r6px1c8+tfK3MK868+HJB5bQEJKzE68ikp/xDwyKjJBGlpmTUo7qNN4PxWLFh0u/m/ftvVHmO/KpBrIP914hURRpKg3cAF4uJnypeTbPEvLU/MUdXo3pWhIC3dZjSuXx5ENOoHdvZeFXXuPyMYTRKAfC9/oNUd80m4rW7UYRu74MJQt/5nq4wEKZyqfQ4/3kQ6wHOzg5fhdB1BTKrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5xAzsmbS1NB1R7U2iShMELEOuIomL8fpfIX/VnGP+GI=;
 b=B0QVk7qykML1lotnqBO66mQq32wp1qQn216Wig6g/ZvYrOf1J5nNLYNILly4NulKJ2V7KSmGDTFzceDf1id4hPe12yLQU0DIfsRLFljkWe/zMjMDGK9wzO5GGCyeZ/GxNdioL5N5y3Y1NbpWFxmiGZLeZR1T/T+2aRGh38pj7MrEzJIfpnfxNFmfQpYvHnk2EAieUTgYEwHi0O2GoNX6hGXa1wKZGw7N9DKRv/KCX/EKM66KxRl5v3oQPo2sTgdgont0ZpFvy9h5dKzER/HcvKS+MdFdyH/UH20nTgruOaWDP8ElbA76ruhQOY45kkXCKRn8I0n+BQKsW+omozUsxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5xAzsmbS1NB1R7U2iShMELEOuIomL8fpfIX/VnGP+GI=;
 b=g589VL0JWlDuPxcUU9T+VcbV9xAnoTFjsmVE/6o5Q+IgUH5NYEsGsW8fqfbdy6AMcqsQRgD4rOrmOqk3aH8gMZ0FiW0VVD2/AKRn81Fz5RFbq/4S8i0mCWjL1Qooc/Fck7GZxMsvqpT05g/mDWr9w6EBbMXI9kTLPq2yfpnE6FRoCV+6aExI2HXQRHwoG3RA7oiiwHKCFHP6SffEw+H7ICzRQSpnjypZIBb20D/B+xMB+UrdjfC1l4yOj8h+zkE5py+j9k6j83JAfB22TYBLLwZRLPcaOfI5vtqYEMWKoBrY0n8WVeGrreaBqMJQA507rcCnwxleaLqN9shYvdezLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by OSQPR06MB7974.apcprd06.prod.outlook.com (2603:1096:604:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 01:54:42 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 01:54:42 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH v1 11/13] lib/raid6: Clean up code style in avx512.c
Date: Fri, 15 Aug 2025 09:54:00 +0800
Message-Id: <20250815015404.468511-12-zhao.xichao@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5ddcdf6d-d361-4f3a-ff58-08dddb9eb3b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?md0cv+C/s/cgspakM5d8xBPL2Uu6CWUMGW1w9pcdJjC3wDMzh/BbD9vz67V5?=
 =?us-ascii?Q?F/b4nVcbjMeUi8pln4KSrGtNJRO2HoxSyc/R7jodc9p08+IZFzpIahN4pdgu?=
 =?us-ascii?Q?/VJAJRtBGjfFCDuaL83Cpm95vaBW5hoXOliSvi3jIk6P1uZV/DjcMlfhVZ9h?=
 =?us-ascii?Q?pY/paDe2zOF8GLUUuUmdCkBhMGfIbK4kttZ4tTZqmb/VdFxM6hpKyDlf3Sv/?=
 =?us-ascii?Q?ZszENUJxWr+/nd4WGcww7Dg/3aYnwge2lSX1jKMCT9V5X8oWSHVlf5aGQ+3S?=
 =?us-ascii?Q?myF/xbrK42+6TlqiRb9xTcWOkAuxwhyu93IpjMXpzk+2WWU9+Dwg/NOpLVcB?=
 =?us-ascii?Q?Zfqia7hX3PmHNihihF97p8TgLDQ1gHFWhpqpx+WY/a0xpqvbZI8MF3H/8+Hb?=
 =?us-ascii?Q?G1Vs80LxXZLmP9lGbIPnHCBbvGWyY7ueQ5u6bfR9mWAQR/ugrFqIQ8zLZ2X0?=
 =?us-ascii?Q?yj5TIBqH/lHA6GQoa3uFGL/GjvhAJNgflLTHKpcHpp4w5UFe2x3STRYoX22P?=
 =?us-ascii?Q?siDzQO5xXdLXZM5uNbr8+Yzy4jP1sgjB6Wepcw4SVU8igVf+Wv1jznAsOqd/?=
 =?us-ascii?Q?mxkjfyYRQv1oQ51YAS28hhcVz5iYwDqGuI0BUTTdVaCRbvgyHZ3eK83D2Rar?=
 =?us-ascii?Q?bvVdp/V4/uadUg6Z5nKzL6QoPpSjQ+u6tEGE5gL77OFG15l0da01RM4z/cu1?=
 =?us-ascii?Q?cLVmu/L/To6bcSFJMlTAV/Pj1l1GDDTXUiRFvXezTxBwv2ojGQNYx20QRZ1z?=
 =?us-ascii?Q?ioHYq2qM9lFlaT8cHL1Rmy/wgiM0uuGCRcn4jclpy9wffr41pYVt1sfWkZfa?=
 =?us-ascii?Q?yhHnTEyYdmRNWlBjbbnPHfxA+mR+YO5M1YboDppAUVBZ4HP9hGJjyv86Tq8X?=
 =?us-ascii?Q?l12ykJKoKCW91eIIIvaqxX12rR4m7gdV2jSNHAWWF32WjkCMIOh/R/SuVOwn?=
 =?us-ascii?Q?UuDFUw1YBvDQ10tb3QdfLEfY+e6kSMy7VnJGaeRzDHhSAe6xJJzAUivBHBGY?=
 =?us-ascii?Q?5cb/QEXfUBUtL4z91/Bz4nnsSh9++7Rd1KdS3WAIxvui+a4CnlLIH7IVISUq?=
 =?us-ascii?Q?A7BjAoQOX1J+FHn4xsBteI124Ee4C5UEN6mKuN8KXXeNXJlf73HLuD6gFOrD?=
 =?us-ascii?Q?dno2Qrxhs6isIc00XdoFxDWLgVm/plowBy0U6MsWD1wX7MxmsP7g5DUAcVm5?=
 =?us-ascii?Q?/Tjn4/e0rksAlyBf5glGKZveTqAy8VbrgJhf8BJtkEHMIK7iEn89LOeRpt70?=
 =?us-ascii?Q?6OLFP72hgARpNk6ZzIe2eif4tqhlmpAuo3ekRVEDFnsF1yF0TsFXyEsEwjJD?=
 =?us-ascii?Q?enPSKUUq1bO3OKrq/HekpDsdU4ZFJhtgKQzT2zJq7eB4Il/MB37fd+eifNGe?=
 =?us-ascii?Q?zo9bT24HbyZaVbNjKZM0htNnIhIL80/8PT5RGxbkzDZIxlUbB3D1CiQR4VeE?=
 =?us-ascii?Q?qxHRx+ejD3DJUK0zumvavlr8o9FnItCemP7wY/z1VB8H8nqmnlUBfg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ax8r425Xfmi2Bg7TO2H1GwcrqyxICVFKnK0quGPQAJfyiqUDFuokU51w/QrK?=
 =?us-ascii?Q?G4D/J6UrvblhlhTu+asKLV5dsAdJqv44Fjhs9GSfi0u0LTgZd+fWqUb1LiAF?=
 =?us-ascii?Q?8HaPVBZ2MNugPoHpzfID8mXPsQO1SI+ax4DViC+6OxDETHMtsBHAXA9oyim5?=
 =?us-ascii?Q?CSOz6kRgHdEKmVjmXPhHIbJkNfUF0K2/vOru21lWDwfbTtDHaUF6YbUQxf8h?=
 =?us-ascii?Q?Z7cVLvGlFuf5JD3p3PVSsgUTOFHobFEeQe2qxEr8tzslVEhjbLeK2rfaaHum?=
 =?us-ascii?Q?AuI8j7XTAj3XWIlNL00Tz2gLN8WVXDDTeaNY4yPzCMOAZpXEr/MQrXlVAtme?=
 =?us-ascii?Q?GEMInDTTJ0wDbIx5merV7s0tlOnUvgXUGoMVjNZz6sAqEBrGFd0Q/sCQv4gq?=
 =?us-ascii?Q?egi/9fRLiynz3t0z+1M5Yu1I17gkObnd7crEcqvmr8APtxrSar2fY1vclL56?=
 =?us-ascii?Q?qk6t2CQTYVKiycHTGsu5hgT8JCZGo+xMdb+As1dwoZzzMHQFC8ofntZNNdFK?=
 =?us-ascii?Q?+/cTCM2eDao4fWSee2uaDdTbaxN4BeMxwuSvuzFaD/T3m1LGYoQTQUu0ku7s?=
 =?us-ascii?Q?/y9Zz0qccAqCdz0ILJ4TbQxI0h5nO/DDGQWENEP6MFloCfHpWdB/gVOcJAbN?=
 =?us-ascii?Q?dcvJBiF59SWgi+P8Wvo1mPrUhJfZNpX9BWFY8nmm5NkZFUpNIO8wxZI3I1PB?=
 =?us-ascii?Q?baLhTWGYB0Qk0gz7nZjw8OFBB+TnhNuf3Jpkakm6c0MwkaH8fGyk4ux1DCGM?=
 =?us-ascii?Q?5dRvzc9aDfuJJccEj1zuOye93EWMqKyLfobqQL8NijXZ5WH6DkAGEMHIpp/k?=
 =?us-ascii?Q?gaawoIPbVohXqERVk7KEyENytZP9A4VnE0P1aMz8WE+oVxF59rbYQUFrC/Yl?=
 =?us-ascii?Q?EIaYlbkSE498WQhzdZg2CPe7rb+cGRNpOzfW0GkLEKfmw6Vr0oH5408QL0EK?=
 =?us-ascii?Q?JzDaQa9gFw/bwZZ+ewDwLzXOaXvmWnK5x5rTlKrMT1+Sn10UNz/tE+Uob07K?=
 =?us-ascii?Q?pMjsOjwKNtrlIbJTAriPypGON9VqG4NJPiOWCQCXDoHdb/JEey+4Q9vrLMV4?=
 =?us-ascii?Q?ZOFuLXMHvwvU9QXgzDsJf1OrLPYEROmxUGe6JTuhT/qnAigA5MO+h90Aghgf?=
 =?us-ascii?Q?XyVUHzU1UnQC0gdQH/tsJKfh7+mmmFW3aXaF6+DV265bZeAxgh2jEF1ln6Q9?=
 =?us-ascii?Q?21zCv4p0DFGPbrh3AFUGQvc0bRdl2769AKPiF5Uh2WXory3hbFy7CCnAUJ2F?=
 =?us-ascii?Q?c9JIyFk9gRWfzbx9Kl6+Q0qD7FyxgF1esBty9nH+EGue/GXxZU07LKXXa2DD?=
 =?us-ascii?Q?+BcleRMHczPWDVYcjAqiYy4QUbNhO4sypul4WrULiW/mnffzKqSE+abyKIqJ?=
 =?us-ascii?Q?ksqkdELWiVoP6Drr2inBh+oO92EfBWYJ8wrcujKu49SOyI5JC2x5yYZNXoeX?=
 =?us-ascii?Q?cGXGKoazyCiw9tVDgX6sUbGr3tshZ2M0DRYr5sf0MOhKwXqYHnKMzdSwlFwo?=
 =?us-ascii?Q?yfEcTfznr7APm5L1L12wcsNm4AOVrkeTcTktA+6vx7CZaOCpr0lFuHZAVk3I?=
 =?us-ascii?Q?OoZAJcUE9kaLOl7uQaI9VQJMwQmFpR2gi5OVkOeI?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ddcdf6d-d361-4f3a-ff58-08dddb9eb3b8
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 01:54:42.4761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YRHElTUJoMSSj1Ja1/Q7JQ6aZf+JpKMIOs2VzfS302bZw7HCkiEKgsqbSgZ2T6EJI/djBvrwObI7dHYJFDd/EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7974

Reduce or add spaces to clean up code style.
No functional changes here.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 lib/raid6/avx512.c | 94 +++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff --git a/lib/raid6/avx512.c b/lib/raid6/avx512.c
index 009bd0adeebf..18707cbb2bf1 100644
--- a/lib/raid6/avx512.c
+++ b/lib/raid6/avx512.c
@@ -46,8 +46,8 @@ static void raid6_avx5121_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	int d, z, z0;
 
 	z0 = disks - 3;         /* Highest data disk */
-	p = dptr[z0+1];         /* XOR parity */
-	q = dptr[z0+2];         /* RS syndrome */
+	p = dptr[z0 + 1];       /* XOR parity */
+	q = dptr[z0 + 2];       /* RS syndrome */
 
 	kernel_fpu_begin();
 
@@ -64,7 +64,7 @@ static void raid6_avx5121_gen_syndrome(int disks, size_t bytes, void **ptrs)
 			     "vmovdqa64 %1,%%zmm6"
 			     :
 			     : "m" (dptr[z0][d]), "m" (dptr[z0-1][d]));
-		for (z = z0-2; z >= 0; z--) {
+		for (z = z0 - 2; z >= 0; z--) {
 			asm volatile("prefetchnta %0\n\t"
 				     "vpcmpgtb %%zmm4,%%zmm1,%%k1\n\t"
 				     "vpmovm2b %%k1,%%zmm5\n\t"
@@ -104,22 +104,22 @@ static void raid6_avx5121_xor_syndrome(int disks, int start, int stop,
 	int d, z, z0;
 
 	z0 = stop;		/* P/Q right side optimization */
-	p = dptr[disks-2];	/* XOR parity */
-	q = dptr[disks-1];	/* RS syndrome */
+	p = dptr[disks - 2];	/* XOR parity */
+	q = dptr[disks - 1];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
 	asm volatile("vmovdqa64 %0,%%zmm0"
 		     : : "m" (raid6_avx512_constants.x1d[0]));
 
-	for (d = 0 ; d < bytes ; d += 64) {
+	for (d = 0; d < bytes; d += 64) {
 		asm volatile("vmovdqa64 %0,%%zmm4\n\t"
 			     "vmovdqa64 %1,%%zmm2\n\t"
 			     "vpxorq %%zmm4,%%zmm2,%%zmm2"
 			     :
 			     : "m" (dptr[z0][d]),  "m" (p[d]));
 		/* P/Q data pages */
-		for (z = z0-1 ; z >= start ; z--) {
+		for (z = z0 - 1; z >= start; z--) {
 			asm volatile("vpxorq %%zmm5,%%zmm5,%%zmm5\n\t"
 				     "vpcmpgtb %%zmm4,%%zmm5,%%k1\n\t"
 				     "vpmovm2b %%k1,%%zmm5\n\t"
@@ -133,7 +133,7 @@ static void raid6_avx5121_xor_syndrome(int disks, int start, int stop,
 				     : "m" (dptr[z][d]));
 		}
 		/* P/Q left side optimization */
-		for (z = start-1 ; z >= 0 ; z--) {
+		for (z = start - 1; z >= 0; z--) {
 			asm volatile("vpxorq %%zmm5,%%zmm5,%%zmm5\n\t"
 				     "vpcmpgtb %%zmm4,%%zmm5,%%k1\n\t"
 				     "vpmovm2b %%k1,%%zmm5\n\t"
@@ -173,8 +173,8 @@ static void raid6_avx5122_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	int d, z, z0;
 
 	z0 = disks - 3;         /* Highest data disk */
-	p = dptr[z0+1];         /* XOR parity */
-	q = dptr[z0+2];         /* RS syndrome */
+	p = dptr[z0 + 1];       /* XOR parity */
+	q = dptr[z0 + 2];       /* RS syndrome */
 
 	kernel_fpu_begin();
 
@@ -192,8 +192,8 @@ static void raid6_avx5122_gen_syndrome(int disks, size_t bytes, void **ptrs)
 			     "vmovdqa64 %%zmm2,%%zmm4\n\t"  /* Q[0] */
 			     "vmovdqa64 %%zmm3,%%zmm6"      /* Q[1] */
 			     :
-			     : "m" (dptr[z0][d]), "m" (dptr[z0][d+64]));
-		for (z = z0-1; z >= 0; z--) {
+			     : "m" (dptr[z0][d]), "m" (dptr[z0][d + 64]));
+		for (z = z0 - 1; z >= 0; z--) {
 			asm volatile("prefetchnta %0\n\t"
 				     "prefetchnta %1\n\t"
 				     "vpcmpgtb %%zmm4,%%zmm1,%%k1\n\t"
@@ -213,7 +213,7 @@ static void raid6_avx5122_gen_syndrome(int disks, size_t bytes, void **ptrs)
 				     "vpxorq %%zmm5,%%zmm4,%%zmm4\n\t"
 				     "vpxorq %%zmm7,%%zmm6,%%zmm6"
 				     :
-				     : "m" (dptr[z][d]), "m" (dptr[z][d+64]));
+				     : "m" (dptr[z][d]), "m" (dptr[z][d + 64]));
 		}
 		asm volatile("vmovntdq %%zmm2,%0\n\t"
 			     "vmovntdq %%zmm3,%1\n\t"
@@ -221,7 +221,7 @@ static void raid6_avx5122_gen_syndrome(int disks, size_t bytes, void **ptrs)
 			     "vmovntdq %%zmm6,%3"
 			     :
 			     : "m" (p[d]), "m" (p[d+64]), "m" (q[d]),
-			       "m" (q[d+64]));
+			       "m" (q[d + 64]));
 	}
 
 	asm volatile("sfence" : : : "memory");
@@ -236,15 +236,15 @@ static void raid6_avx5122_xor_syndrome(int disks, int start, int stop,
 	int d, z, z0;
 
 	z0 = stop;		/* P/Q right side optimization */
-	p = dptr[disks-2];	/* XOR parity */
-	q = dptr[disks-1];	/* RS syndrome */
+	p = dptr[disks - 2];	/* XOR parity */
+	q = dptr[disks - 1];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
 	asm volatile("vmovdqa64 %0,%%zmm0"
 		     : : "m" (raid6_avx512_constants.x1d[0]));
 
-	for (d = 0 ; d < bytes ; d += 128) {
+	for (d = 0; d < bytes; d += 128) {
 		asm volatile("vmovdqa64 %0,%%zmm4\n\t"
 			     "vmovdqa64 %1,%%zmm6\n\t"
 			     "vmovdqa64 %2,%%zmm2\n\t"
@@ -252,10 +252,10 @@ static void raid6_avx5122_xor_syndrome(int disks, int start, int stop,
 			     "vpxorq %%zmm4,%%zmm2,%%zmm2\n\t"
 			     "vpxorq %%zmm6,%%zmm3,%%zmm3"
 			     :
-			     : "m" (dptr[z0][d]), "m" (dptr[z0][d+64]),
-			       "m" (p[d]), "m" (p[d+64]));
+			     : "m" (dptr[z0][d]), "m" (dptr[z0][d + 64]),
+			       "m" (p[d]), "m" (p[d + 64]));
 		/* P/Q data pages */
-		for (z = z0-1 ; z >= start ; z--) {
+		for (z = z0 - 1; z >= start; z--) {
 			asm volatile("vpxorq %%zmm5,%%zmm5,%%zmm5\n\t"
 				     "vpxorq %%zmm7,%%zmm7,%%zmm7\n\t"
 				     "vpcmpgtb %%zmm4,%%zmm5,%%k1\n\t"
@@ -275,10 +275,10 @@ static void raid6_avx5122_xor_syndrome(int disks, int start, int stop,
 				     "vpxorq %%zmm5,%%zmm4,%%zmm4\n\t"
 				     "vpxorq %%zmm7,%%zmm6,%%zmm6"
 				     :
-				     : "m" (dptr[z][d]),  "m" (dptr[z][d+64]));
+				     : "m" (dptr[z][d]),  "m" (dptr[z][d + 64]));
 		}
 		/* P/Q left side optimization */
-		for (z = start-1 ; z >= 0 ; z--) {
+		for (z = start - 1; z >= 0; z--) {
 			asm volatile("vpxorq %%zmm5,%%zmm5,%%zmm5\n\t"
 				     "vpxorq %%zmm7,%%zmm7,%%zmm7\n\t"
 				     "vpcmpgtb %%zmm4,%%zmm5,%%k1\n\t"
@@ -304,8 +304,8 @@ static void raid6_avx5122_xor_syndrome(int disks, int start, int stop,
 			     "vmovdqa64 %%zmm2,%2\n\t"
 			     "vmovdqa64 %%zmm3,%3"
 			     :
-			     : "m" (q[d]), "m" (q[d+64]), "m" (p[d]),
-			       "m" (p[d+64]));
+			     : "m" (q[d]), "m" (q[d + 64]), "m" (p[d]),
+			       "m" (p[d + 64]));
 	}
 
 	asm volatile("sfence" : : : "memory");
@@ -332,8 +332,8 @@ static void raid6_avx5124_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	int d, z, z0;
 
 	z0 = disks - 3;         /* Highest data disk */
-	p = dptr[z0+1];         /* XOR parity */
-	q = dptr[z0+2];         /* RS syndrome */
+	p = dptr[z0 + 1];       /* XOR parity */
+	q = dptr[z0 + 2];       /* RS syndrome */
 
 	kernel_fpu_begin();
 
@@ -389,8 +389,8 @@ static void raid6_avx5124_gen_syndrome(int disks, size_t bytes, void **ptrs)
 			     "vpxorq %%zmm13,%%zmm12,%%zmm12\n\t"
 			     "vpxorq %%zmm15,%%zmm14,%%zmm14"
 			     :
-			     : "m" (dptr[z][d]), "m" (dptr[z][d+64]),
-			       "m" (dptr[z][d+128]), "m" (dptr[z][d+192]));
+			     : "m" (dptr[z][d]), "m" (dptr[z][d + 64]),
+			       "m" (dptr[z][d + 128]), "m" (dptr[z][d + 192]));
 		}
 		asm volatile("vmovntdq %%zmm2,%0\n\t"
 			     "vpxorq %%zmm2,%%zmm2,%%zmm2\n\t"
@@ -409,9 +409,9 @@ static void raid6_avx5124_gen_syndrome(int disks, size_t bytes, void **ptrs)
 			     "vmovntdq %%zmm14,%7\n\t"
 			     "vpxorq %%zmm14,%%zmm14,%%zmm14"
 			     :
-			     : "m" (p[d]), "m" (p[d+64]), "m" (p[d+128]),
-			       "m" (p[d+192]), "m" (q[d]), "m" (q[d+64]),
-			       "m" (q[d+128]), "m" (q[d+192]));
+			     : "m" (p[d]), "m" (p[d + 64]), "m" (p[d + 128]),
+			       "m" (p[d + 192]), "m" (q[d]), "m" (q[d + 64]),
+			       "m" (q[d + 128]), "m" (q[d + 192]));
 	}
 
 	asm volatile("sfence" : : : "memory");
@@ -426,15 +426,15 @@ static void raid6_avx5124_xor_syndrome(int disks, int start, int stop,
 	int d, z, z0;
 
 	z0 = stop;		/* P/Q right side optimization */
-	p = dptr[disks-2];	/* XOR parity */
-	q = dptr[disks-1];	/* RS syndrome */
+	p = dptr[disks - 2];	/* XOR parity */
+	q = dptr[disks - 1];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
 	asm volatile("vmovdqa64 %0,%%zmm0"
 		     :: "m" (raid6_avx512_constants.x1d[0]));
 
-	for (d = 0 ; d < bytes ; d += 256) {
+	for (d = 0; d < bytes; d += 256) {
 		asm volatile("vmovdqa64 %0,%%zmm4\n\t"
 			     "vmovdqa64 %1,%%zmm6\n\t"
 			     "vmovdqa64 %2,%%zmm12\n\t"
@@ -448,12 +448,12 @@ static void raid6_avx5124_xor_syndrome(int disks, int start, int stop,
 			     "vpxorq %%zmm12,%%zmm10,%%zmm10\n\t"
 			     "vpxorq %%zmm14,%%zmm11,%%zmm11"
 			     :
-			     : "m" (dptr[z0][d]), "m" (dptr[z0][d+64]),
-			       "m" (dptr[z0][d+128]), "m" (dptr[z0][d+192]),
-			       "m" (p[d]), "m" (p[d+64]), "m" (p[d+128]),
-			       "m" (p[d+192]));
+			     : "m" (dptr[z0][d]), "m" (dptr[z0][d + 64]),
+			       "m" (dptr[z0][d + 128]), "m" (dptr[z0][d + 192]),
+			       "m" (p[d]), "m" (p[d + 64]), "m" (p[d + 128]),
+			       "m" (p[d + 192]));
 		/* P/Q data pages */
-		for (z = z0-1 ; z >= start ; z--) {
+		for (z = z0 - 1; z >= start; z--) {
 			asm volatile("vpxorq %%zmm5,%%zmm5,%%zmm5\n\t"
 				     "vpxorq %%zmm7,%%zmm7,%%zmm7\n\t"
 				     "vpxorq %%zmm13,%%zmm13,%%zmm13\n\t"
@@ -493,16 +493,16 @@ static void raid6_avx5124_xor_syndrome(int disks, int start, int stop,
 				     "vpxorq %%zmm13,%%zmm12,%%zmm12\n\t"
 				     "vpxorq %%zmm15,%%zmm14,%%zmm14"
 				     :
-				     : "m" (dptr[z][d]), "m" (dptr[z][d+64]),
-				       "m" (dptr[z][d+128]),
-				       "m" (dptr[z][d+192]));
+				     : "m" (dptr[z][d]), "m" (dptr[z][d + 64]),
+				       "m" (dptr[z][d + 128]),
+				       "m" (dptr[z][d + 192]));
 		}
 		asm volatile("prefetchnta %0\n\t"
 			     "prefetchnta %1\n\t"
 			     :
-			     : "m" (q[d]), "m" (q[d+128]));
+			     : "m" (q[d]), "m" (q[d + 128]));
 		/* P/Q left side optimization */
-		for (z = start-1 ; z >= 0 ; z--) {
+		for (z = start - 1; z >= 0; z--) {
 			asm volatile("vpxorq %%zmm5,%%zmm5,%%zmm5\n\t"
 				     "vpxorq %%zmm7,%%zmm7,%%zmm7\n\t"
 				     "vpxorq %%zmm13,%%zmm13,%%zmm13\n\t"
@@ -543,9 +543,9 @@ static void raid6_avx5124_xor_syndrome(int disks, int start, int stop,
 			     "vmovntdq %%zmm12,%6\n\t"
 			     "vmovntdq %%zmm14,%7"
 			     :
-			     : "m" (p[d]),  "m" (p[d+64]), "m" (p[d+128]),
-			       "m" (p[d+192]), "m" (q[d]),  "m" (q[d+64]),
-			       "m" (q[d+128]), "m" (q[d+192]));
+			     : "m" (p[d]),  "m" (p[d + 64]), "m" (p[d + 128]),
+			       "m" (p[d + 192]), "m" (q[d]),  "m" (q[d + 64]),
+			       "m" (q[d + 128]), "m" (q[d + 192]));
 	}
 	asm volatile("sfence" : : : "memory");
 	kernel_fpu_end();
-- 
2.34.1

