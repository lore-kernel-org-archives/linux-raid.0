Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012033.outbound.protection.outlook.com [52.101.126.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA12D2BDC3E;
	Fri, 15 Aug 2025 01:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755222895; cv=fail; b=BkGnVW/lvjavS65ERE4JJH8JUrvTmINVTBShxP03FfeMZe5SChHbd9Og+2wjUWX0XYKFClGMGz8xa5WoZmPVwCTu8uvvQdzuzUrPVyFJy5VwDeoe7VO4dczTj3Uk0Z1+JZxahRLykce/VHYBWGNO1xKsY/FRMh+rShZ0Qom7W5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755222895; c=relaxed/simple;
	bh=RHSmf4Ah4TCMtSxJr+Jl6TrAYNY6EOejWvwn89gilcs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ADoF1WMxTVPU4CdUN2rOKVWX098e2jxteBDzw2CfJ5cT6cn658InuFuqqjIKQSV2bkv8it2267lhcJ4id4Z/N09tNjtioadARr2bfaLPo9/ADOB5vLqKbzVuUpqs/JiFJcqfsVfh+J9Fs2Qr17LsvQW2A7FvY8HmcAPRVp6fFtM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=qKEu19dx; arc=fail smtp.client-ip=52.101.126.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="qKEu19dx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r0ZSpKZ8H+6lArRUryh6VQLmckga2WmM4ryYpMw6o54vqgUS3PRNPAHiQOvZvgHHNxry6e+MCuAm3NItzMOqY62ppTrUoPrcI6F6K4NPcN+sN1pkmECJyj9X0QQ6YqtCx8ER4COvDpWT5NbJVyjNgj2u3VJsgDPK34f5P1zBfW7P5CKFyifQVzMrvIUtNJsi9KF5+3c0Huq6P+Ru8OL/pD61s9a7qJ3ZWtWx5dSRD3C9PROx2U5Kla+RLo5cK8hX+xNH9tHnynZuZnews6xEinKpc7IunrpDLMbzU0SeY7pGgpJKk9oZOQgmWEZ/Ujl1bG87i0esqoMBVntYlsdedA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0ZQVq/O/AEIlm2Q9/y2Rw/qdPXf8kk9anIDZFNzuL8=;
 b=CbS7v5/IJiMR8+yjrsL/9p8HQMuHjuYGHS0Zf9hZkvdYqsEQjOlVSiWS9GWHrnQTFhU5fDAqKnJQC/qmcgz5O60XJX9cAp2ijsxtC0o6proxPk90Nx3k3nle/Sva71yBwcxnTuhm+KterOYDC6wPOuJeLr1Jp5hvH8i0+yCkfoBU9gDH2V/nHopNGle5rbfHUmTeZ9iXwNgEeQ+ckHNo8djUjHZEGXxaZFaK84yiA32gqVwusK9rscpc6gpmghXMr8FzKfbeBkEO3pTKYz1QZDcJLOJ5mEb7GA9l6rfR4qpeJw7A5FjAqBgtjnsY7RjTHfI5EmNgh3X0AlNPTV9lIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0ZQVq/O/AEIlm2Q9/y2Rw/qdPXf8kk9anIDZFNzuL8=;
 b=qKEu19dxdeVnFRLZFnhC13SBFCtX7rMRvo6LZ02UaoY72cX1rP7jpIO6iMaKWYWvFGSytkSYh+SnNtjpqTDDQyZA/llKZG6afFp2F2hWzOO2Et/QnUmweglgDS7Er7pBxeuC8stv2Ed8JHaeU3RLSZqt1BhAF1YtnS3DgPnNT1pKhKaeLffOT6ytuFO5xBIFUMjHrzkUx2qVf7ERJpTUlpLWkT5XKSwe0BDbvl8219KklsYKuZDi4MWxiarYSlvj69rAXsi3NBalFHqEpzTwJkD+7y64VDUaV2Z2CxGe+nR70WyYEgQ0gi1sreWgMKPc61r182r3fKzGLNgcVbnbSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by OSQPR06MB7974.apcprd06.prod.outlook.com (2603:1096:604:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 01:54:41 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 01:54:41 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH v1 10/13] lib/raid6: Clean up code style in loongarch_simd.c
Date: Fri, 15 Aug 2025 09:53:59 +0800
Message-Id: <20250815015404.468511-11-zhao.xichao@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: b1fad7b5-a1b9-448e-258b-08dddb9eb2fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D7uyhekhGdeNDuaFynH0D2Br2zHbOwjMBgCUO0xHIWd95mns2j49p44+0Y5A?=
 =?us-ascii?Q?1NYUbUDH0rUSO2i61HL5N2ub6+JdrBcKIrGEyOn1btMLThcDh42vrNqEU8Y0?=
 =?us-ascii?Q?S8ftAw+yLLXqwgryTbPFjEqH++kGrMHbg/hTHUdKfjSEyaDi9AmR456rq2bc?=
 =?us-ascii?Q?Fb1PZ5zRUQc8NG+wrWhGFANF/fRjD6PbdCAEoTfPVqMMWgbrJ2yBvz3uUQSk?=
 =?us-ascii?Q?MT8PDdUGCSnsDHwNDzHY2f4bgQmmz1P6k92aeeq6F23oX/CvqI1lQLoem8yh?=
 =?us-ascii?Q?wsIT53kibQ8p9YIT1JA36r/c5ub68vseRtivugs/HXdOUprnilIQF6/vS1uu?=
 =?us-ascii?Q?hg8KTJYeRQz2Y/fhypqTrBgBc8iWw5pnQPLEBuAzyhNFt+56ucZDCY/ryiYU?=
 =?us-ascii?Q?1/UA9RRMNIeqZzO+fEPrzHWvfBzaQicaqHX4dYrfeu7LXl0RvHmNhaEzE2Aj?=
 =?us-ascii?Q?9I4gzLDovOIOqO4Kodpp7x56VmQ8rm13fKLxLDLwRvax5o4gS5/x6rdWMkcR?=
 =?us-ascii?Q?3JMR3DCf6JzNmt4Qt6KhnuC4RwFbv4EzvY0YK6G5uE1tLxs/Q2jET10erD8Q?=
 =?us-ascii?Q?c/KPbpsn+8VXXD+WKivrtJBw5Cw5In7ODFQLu1vc1S/Q+Vwwf40JNidnKT8l?=
 =?us-ascii?Q?YhuB0pn5hBnAkRSv2+WfMDfptTMcaFa74yB+qjvYuGsLNnu0Bm+sqG+124On?=
 =?us-ascii?Q?BjyDjWPBr2CQ1Ztd4Aihxubk4Tnr6dr3RWDVs7hsLG3UGg4ao2ExLVAUic6V?=
 =?us-ascii?Q?hJdSpR3kWR3USE0wyyhYBEQ+hWldVUiJXw7OvsmrM/YzSHNcNbyWdc7Sel/v?=
 =?us-ascii?Q?jkIpIzY3r9rR2B/UOVDyw1GKrt4eCyW8gFbXyIo7h74rXIXmTQk0TONTWke1?=
 =?us-ascii?Q?8+z/RXBACrKDIrp21OGH/iIGp7BoeZt9ukWhNMOh1NK0gMj8REEinPkRMt50?=
 =?us-ascii?Q?yxl33VNugYZ5yaLtsEwWlZEtlTAC8tlMJiEBj7tSLHGyssv3M4zdVz5SFe4A?=
 =?us-ascii?Q?BrN3bVAyCtqMuR4bdhdrLlMJjs6ylB4ehEEhsLUb9nN2gjABXsLxupqYiMvc?=
 =?us-ascii?Q?VOkY62HULFPZvFYM+aRW0VV2MncVjZjdXJWL2O5yvFEY5DFY0+Ikfjuk4Kjr?=
 =?us-ascii?Q?HqTknm5afIDiZYWyzPPFw3smjvlTq3t8UtoboH2K1h+gd7RjZXOq3+drPd8L?=
 =?us-ascii?Q?Q3pe3jrk+aeQ46cbhJGcnR/dL3UKkZTX+X7D022J4/ZLt6lzxknus2RO+Ntm?=
 =?us-ascii?Q?vLh6F8DkXHLVtQIDPyQQxDMQAg8s56WcAh7gLQeGtoMlrhvnEbPAmeQrrx2W?=
 =?us-ascii?Q?AOFTUqVlkhLvxngQK1bNI+uvBR+H3ZW98Mv/9mfAUbKlIQiXRoiaLvpgi7gT?=
 =?us-ascii?Q?syJQ0nCOGG8m3TteSVF1GveiDFc/PQDMafr88qdbcSsJ7B1sL6/MFZHWwEV/?=
 =?us-ascii?Q?vIhDTvi1v9LMZpAOgFRRgRwDrrqmMkvyAVIfXAH+vk/9n2EWG3Yo2A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MPWqtbVs8NCvwmuExc75OeINDZK+j7zfG8SQq1s3ssZLCIlRnwGMynYykaAf?=
 =?us-ascii?Q?jHvgMqpIaGH8iSpTrjJeYchYFCM9OUIsSbqfeu+mwcZexkLKX0aQdZG95P1J?=
 =?us-ascii?Q?RevgtFfJjltaoLAYph45za8rTjj9taORbw5eqNOjTCfu5L+P77N+hLqmmUOi?=
 =?us-ascii?Q?wDe4qJklKvdTGlJnCAgRUACiJ0nj4G9TegMb67fV+LjZ8LfrWgIRKbwYKruw?=
 =?us-ascii?Q?Qk47uQgUm5af1Deil/yzkRwwX44GJiojCaru23WaB3D3l0UyjvUkE4/HP4MP?=
 =?us-ascii?Q?mBc3z2+5A/8vE+29uNH2P/EjK9qV03kqY66ogBk9q+DO2tfAVxHKwDCODkm+?=
 =?us-ascii?Q?PaOSn+tGdXFnGsAkTVn+/Mn8DdFI52+H3vVw1PvHTiVJ7zkdK+GabVTUUjP8?=
 =?us-ascii?Q?9EKAQElQU35BfpmpuofYik4VAL23T3EMDhyBMgTZYc5HDtL/oiCPImHG+uTZ?=
 =?us-ascii?Q?ufnuz+LDQsAMP5cY7vNUoyXGDqzOSQXQw4bShcuuau//3vXNggaKRwb1I+WI?=
 =?us-ascii?Q?QOeZBqHwuc+1+T2s2aLmxMxlbcgfTeJl9ks9jPZvVrNU0L26HdWKsxvvKC3t?=
 =?us-ascii?Q?JG6bsIocKwyK516G2u6bd9+1+5epBhDWT9szCt0ISXk9eiPKao/4/2rWYoQd?=
 =?us-ascii?Q?NkIid3z592Ft6cAsntO4f9hRbbj9rYzwtdV4/H7cEzgGTQnMMjKooSKfayw5?=
 =?us-ascii?Q?FB/Dlfchl93SjO7eY3CxmEQkPgJyWxDUSo0oRY4TnCxnkC64VHdnd9R9kM1O?=
 =?us-ascii?Q?kpdt4gv+zeZzlkPVrSGb8PdFBw5zZNS5zcjHSvWcaHodDMiQpdtYG95sWp9+?=
 =?us-ascii?Q?d2HbNBKOwFLjXmTyrj+/pcVIPtvP8KanNMroWpVbJ6i4FRex8uoKju2Qse46?=
 =?us-ascii?Q?WY/uZakfI8QavkQFdWsBcv6ncCM7xm67/ofuQZEW3L3EH7HzBKbxi/NFynSr?=
 =?us-ascii?Q?PkruvV9qQlzJp4HKcwHv4vwjMjXy5rDjxJfO4eS62e47D89DhUuZnFYf4DGv?=
 =?us-ascii?Q?tcesMgN2++Mj39GJbqrajuud3Jm4olr75RjtwMzQ2vJJZrML6rvrkGVpPkSB?=
 =?us-ascii?Q?/JKX96ckwEWs2SgcQ+oDDoQi699yjMv3l/ZVFO9o6GK5bFjNtVnuJyBD+TNE?=
 =?us-ascii?Q?9tmFUpDVvISW4dUk011ngeQ8zKNveYAeWEms6covxS7T9BOmui1CMr4lvGYv?=
 =?us-ascii?Q?pQJljFyN5QcFx0EJ/JD8xEudTuiQ2FLMDBZEiWgTFLK4n+FS8sTlFw5jmiOG?=
 =?us-ascii?Q?inPI0M9xm/Wvz9vQi9ersLWA2SpCYdAb5xufhUQ8UzEeeNGzqsWnETjCTbcl?=
 =?us-ascii?Q?h3u2EAA4B5aUsg3m3ug7fT4Y2tsQDVR5XIGzh0ecigxvT8GAksjlGNL5XINr?=
 =?us-ascii?Q?F4R1xD2pxiVgQxPrWmQXHbSOtmbIfq7NdgczizAqVCN7gPnsi1/ylL5+i/2/?=
 =?us-ascii?Q?4JzZp52UXTZs0WGUTVGzOLxEu5/tMnW/4p4vw1qgejXxHbwN6hSJBQL+FeDF?=
 =?us-ascii?Q?lPG3hZtgFMUXTyb5rbN73RyGuyIYXETP5TIrCMgLB/YQTooPuk0zcRLBF3qv?=
 =?us-ascii?Q?Yn+AtJbAWJ6zj3v5UuDU1pBX/UKlt/w1h1ph3EVa?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1fad7b5-a1b9-448e-258b-08dddb9eb2fe
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 01:54:41.2376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /8ZzUM0TVlOsx/yxUsEVY4GrFlqyO3BobXfZVSw4BKvSBLTPxEIX3BRvjggprQwDRlblD1XRGGwSa1OQgzFMvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7974

Reduce or add spaces to clean up code style.
No functional changes here.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 lib/raid6/loongarch_simd.c | 116 ++++++++++++++++++-------------------
 1 file changed, 58 insertions(+), 58 deletions(-)

diff --git a/lib/raid6/loongarch_simd.c b/lib/raid6/loongarch_simd.c
index aa5d9f924ca3..03aab64ffc30 100644
--- a/lib/raid6/loongarch_simd.c
+++ b/lib/raid6/loongarch_simd.c
@@ -37,8 +37,8 @@ static void raid6_lsx_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	int d, z, z0;
 
 	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0+1];		/* XOR parity */
-	q = dptr[z0+2];		/* RS syndrome */
+	p = dptr[z0 + 1];	/* XOR parity */
+	q = dptr[z0 + 2];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
@@ -49,22 +49,22 @@ static void raid6_lsx_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	 * $vr12, $vr13, $vr14, $vr15: w2
 	 * $vr16, $vr17, $vr18, $vr19: w1
 	 */
-	for (d = 0; d < bytes; d += NSIZE*4) {
+	for (d = 0; d < bytes; d += NSIZE * 4) {
 		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
-		asm volatile("vld $vr0, %0" : : "m"(dptr[z0][d+0*NSIZE]));
-		asm volatile("vld $vr1, %0" : : "m"(dptr[z0][d+1*NSIZE]));
-		asm volatile("vld $vr2, %0" : : "m"(dptr[z0][d+2*NSIZE]));
-		asm volatile("vld $vr3, %0" : : "m"(dptr[z0][d+3*NSIZE]));
+		asm volatile("vld $vr0, %0" : : "m"(dptr[z0][d + 0 * NSIZE]));
+		asm volatile("vld $vr1, %0" : : "m"(dptr[z0][d + 1 * NSIZE]));
+		asm volatile("vld $vr2, %0" : : "m"(dptr[z0][d + 2 * NSIZE]));
+		asm volatile("vld $vr3, %0" : : "m"(dptr[z0][d + 3 * NSIZE]));
 		asm volatile("vori.b $vr4, $vr0, 0");
 		asm volatile("vori.b $vr5, $vr1, 0");
 		asm volatile("vori.b $vr6, $vr2, 0");
 		asm volatile("vori.b $vr7, $vr3, 0");
-		for (z = z0-1; z >= 0; z--) {
+		for (z = z0 - 1; z >= 0; z--) {
 			/* wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE]; */
-			asm volatile("vld $vr8, %0" : : "m"(dptr[z][d+0*NSIZE]));
-			asm volatile("vld $vr9, %0" : : "m"(dptr[z][d+1*NSIZE]));
-			asm volatile("vld $vr10, %0" : : "m"(dptr[z][d+2*NSIZE]));
-			asm volatile("vld $vr11, %0" : : "m"(dptr[z][d+3*NSIZE]));
+			asm volatile("vld $vr8, %0" : : "m"(dptr[z][d + 0 * NSIZE]));
+			asm volatile("vld $vr9, %0" : : "m"(dptr[z][d + 1 * NSIZE]));
+			asm volatile("vld $vr10, %0" : : "m"(dptr[z][d + 2 * NSIZE]));
+			asm volatile("vld $vr11, %0" : : "m"(dptr[z][d + 3 * NSIZE]));
 			/* wp$$ ^= wd$$; */
 			asm volatile("vxor.v $vr0, $vr0, $vr8");
 			asm volatile("vxor.v $vr1, $vr1, $vr9");
@@ -97,15 +97,15 @@ static void raid6_lsx_gen_syndrome(int disks, size_t bytes, void **ptrs)
 			asm volatile("vxor.v $vr7, $vr19, $vr11");
 		}
 		/* *(unative_t *)&p[d+NSIZE*$$] = wp$$; */
-		asm volatile("vst $vr0, %0" : "=m"(p[d+NSIZE*0]));
-		asm volatile("vst $vr1, %0" : "=m"(p[d+NSIZE*1]));
-		asm volatile("vst $vr2, %0" : "=m"(p[d+NSIZE*2]));
-		asm volatile("vst $vr3, %0" : "=m"(p[d+NSIZE*3]));
+		asm volatile("vst $vr0, %0" : "=m"(p[d + NSIZE * 0]));
+		asm volatile("vst $vr1, %0" : "=m"(p[d + NSIZE * 1]));
+		asm volatile("vst $vr2, %0" : "=m"(p[d + NSIZE * 2]));
+		asm volatile("vst $vr3, %0" : "=m"(p[d + NSIZE * 3]));
 		/* *(unative_t *)&q[d+NSIZE*$$] = wq$$; */
-		asm volatile("vst $vr4, %0" : "=m"(q[d+NSIZE*0]));
-		asm volatile("vst $vr5, %0" : "=m"(q[d+NSIZE*1]));
-		asm volatile("vst $vr6, %0" : "=m"(q[d+NSIZE*2]));
-		asm volatile("vst $vr7, %0" : "=m"(q[d+NSIZE*3]));
+		asm volatile("vst $vr4, %0" : "=m"(q[d + NSIZE * 0]));
+		asm volatile("vst $vr5, %0" : "=m"(q[d + NSIZE * 1]));
+		asm volatile("vst $vr6, %0" : "=m"(q[d + NSIZE * 2]));
+		asm volatile("vst $vr7, %0" : "=m"(q[d + NSIZE * 3]));
 	}
 
 	kernel_fpu_end();
@@ -119,8 +119,8 @@ static void raid6_lsx_xor_syndrome(int disks, int start, int stop,
 	int d, z, z0;
 
 	z0 = stop;		/* P/Q right side optimization */
-	p = dptr[disks-2];	/* XOR parity */
-	q = dptr[disks-1];	/* RS syndrome */
+	p = dptr[disks - 2];	/* XOR parity */
+	q = dptr[disks - 1];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
@@ -131,23 +131,23 @@ static void raid6_lsx_xor_syndrome(int disks, int start, int stop,
 	 * $vr12, $vr13, $vr14, $vr15: w2
 	 * $vr16, $vr17, $vr18, $vr19: w1
 	 */
-	for (d = 0; d < bytes; d += NSIZE*4) {
+	for (d = 0; d < bytes; d += NSIZE * 4) {
 		/* P/Q data pages */
 		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
-		asm volatile("vld $vr0, %0" : : "m"(dptr[z0][d+0*NSIZE]));
-		asm volatile("vld $vr1, %0" : : "m"(dptr[z0][d+1*NSIZE]));
-		asm volatile("vld $vr2, %0" : : "m"(dptr[z0][d+2*NSIZE]));
-		asm volatile("vld $vr3, %0" : : "m"(dptr[z0][d+3*NSIZE]));
+		asm volatile("vld $vr0, %0" : : "m"(dptr[z0][d + 0 * NSIZE]));
+		asm volatile("vld $vr1, %0" : : "m"(dptr[z0][d + 1 * NSIZE]));
+		asm volatile("vld $vr2, %0" : : "m"(dptr[z0][d + 2 * NSIZE]));
+		asm volatile("vld $vr3, %0" : : "m"(dptr[z0][d + 3 * NSIZE]));
 		asm volatile("vori.b $vr4, $vr0, 0");
 		asm volatile("vori.b $vr5, $vr1, 0");
 		asm volatile("vori.b $vr6, $vr2, 0");
 		asm volatile("vori.b $vr7, $vr3, 0");
-		for (z = z0-1; z >= start; z--) {
+		for (z = z0 - 1; z >= start; z--) {
 			/* wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE]; */
-			asm volatile("vld $vr8, %0" : : "m"(dptr[z][d+0*NSIZE]));
-			asm volatile("vld $vr9, %0" : : "m"(dptr[z][d+1*NSIZE]));
-			asm volatile("vld $vr10, %0" : : "m"(dptr[z][d+2*NSIZE]));
-			asm volatile("vld $vr11, %0" : : "m"(dptr[z][d+3*NSIZE]));
+			asm volatile("vld $vr8, %0" : : "m"(dptr[z][d + 0 * NSIZE]));
+			asm volatile("vld $vr9, %0" : : "m"(dptr[z][d + 1 * NSIZE]));
+			asm volatile("vld $vr10, %0" : : "m"(dptr[z][d + 2 * NSIZE]));
+			asm volatile("vld $vr11, %0" : : "m"(dptr[z][d + 3 * NSIZE]));
 			/* wp$$ ^= wd$$; */
 			asm volatile("vxor.v $vr0, $vr0, $vr8");
 			asm volatile("vxor.v $vr1, $vr1, $vr9");
@@ -181,7 +181,7 @@ static void raid6_lsx_xor_syndrome(int disks, int start, int stop,
 		}
 
 		/* P/Q left side optimization */
-		for (z = start-1; z >= 0; z--) {
+		for (z = start - 1; z >= 0; z--) {
 			/* w2$$ = MASK(wq$$); */
 			asm volatile("vslti.b $vr12, $vr4, 0");
 			asm volatile("vslti.b $vr13, $vr5, 0");
@@ -232,10 +232,10 @@ static void raid6_lsx_xor_syndrome(int disks, int start, int stop,
 			"vst $vr25, %5\n\t"
 			"vst $vr26, %6\n\t"
 			"vst $vr27, %7\n\t"
-			: "+m"(p[d+NSIZE*0]), "+m"(p[d+NSIZE*1]),
-			  "+m"(p[d+NSIZE*2]), "+m"(p[d+NSIZE*3]),
-			  "+m"(q[d+NSIZE*0]), "+m"(q[d+NSIZE*1]),
-			  "+m"(q[d+NSIZE*2]), "+m"(q[d+NSIZE*3])
+			: "+m"(p[d + NSIZE * 0]), "+m"(p[d + NSIZE * 1]),
+			  "+m"(p[d + NSIZE * 2]), "+m"(p[d + NSIZE * 3]),
+			  "+m"(q[d + NSIZE * 0]), "+m"(q[d + NSIZE * 1]),
+			  "+m"(q[d + NSIZE * 2]), "+m"(q[d + NSIZE * 3])
 		);
 	}
 
@@ -268,8 +268,8 @@ static void raid6_lasx_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	int d, z, z0;
 
 	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0+1];		/* XOR parity */
-	q = dptr[z0+2];		/* RS syndrome */
+	p = dptr[z0 + 1];	/* XOR parity */
+	q = dptr[z0 + 2];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
@@ -282,14 +282,14 @@ static void raid6_lasx_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	 */
 	for (d = 0; d < bytes; d += NSIZE*2) {
 		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
-		asm volatile("xvld $xr0, %0" : : "m"(dptr[z0][d+0*NSIZE]));
-		asm volatile("xvld $xr1, %0" : : "m"(dptr[z0][d+1*NSIZE]));
+		asm volatile("xvld $xr0, %0" : : "m"(dptr[z0][d + 0 * NSIZE]));
+		asm volatile("xvld $xr1, %0" : : "m"(dptr[z0][d + 1 * NSIZE]));
 		asm volatile("xvori.b $xr2, $xr0, 0");
 		asm volatile("xvori.b $xr3, $xr1, 0");
-		for (z = z0-1; z >= 0; z--) {
+		for (z = z0 - 1; z >= 0; z--) {
 			/* wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE]; */
-			asm volatile("xvld $xr4, %0" : : "m"(dptr[z][d+0*NSIZE]));
-			asm volatile("xvld $xr5, %0" : : "m"(dptr[z][d+1*NSIZE]));
+			asm volatile("xvld $xr4, %0" : : "m"(dptr[z][d + 0 * NSIZE]));
+			asm volatile("xvld $xr5, %0" : : "m"(dptr[z][d + 1 * NSIZE]));
 			/* wp$$ ^= wd$$; */
 			asm volatile("xvxor.v $xr0, $xr0, $xr4");
 			asm volatile("xvxor.v $xr1, $xr1, $xr5");
@@ -310,11 +310,11 @@ static void raid6_lasx_gen_syndrome(int disks, size_t bytes, void **ptrs)
 			asm volatile("xvxor.v $xr3, $xr9, $xr5");
 		}
 		/* *(unative_t *)&p[d+NSIZE*$$] = wp$$; */
-		asm volatile("xvst $xr0, %0" : "=m"(p[d+NSIZE*0]));
-		asm volatile("xvst $xr1, %0" : "=m"(p[d+NSIZE*1]));
+		asm volatile("xvst $xr0, %0" : "=m"(p[d + NSIZE * 0]));
+		asm volatile("xvst $xr1, %0" : "=m"(p[d + NSIZE * 1]));
 		/* *(unative_t *)&q[d+NSIZE*$$] = wq$$; */
-		asm volatile("xvst $xr2, %0" : "=m"(q[d+NSIZE*0]));
-		asm volatile("xvst $xr3, %0" : "=m"(q[d+NSIZE*1]));
+		asm volatile("xvst $xr2, %0" : "=m"(q[d + NSIZE * 0]));
+		asm volatile("xvst $xr3, %0" : "=m"(q[d + NSIZE * 1]));
 	}
 
 	kernel_fpu_end();
@@ -328,8 +328,8 @@ static void raid6_lasx_xor_syndrome(int disks, int start, int stop,
 	int d, z, z0;
 
 	z0 = stop;		/* P/Q right side optimization */
-	p = dptr[disks-2];	/* XOR parity */
-	q = dptr[disks-1];	/* RS syndrome */
+	p = dptr[disks - 2];	/* XOR parity */
+	q = dptr[disks - 1];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
@@ -340,17 +340,17 @@ static void raid6_lasx_xor_syndrome(int disks, int start, int stop,
 	 * $xr6, $xr7: w2
 	 * $xr8, $xr9: w1
 	 */
-	for (d = 0; d < bytes; d += NSIZE*2) {
+	for (d = 0; d < bytes; d += NSIZE * 2) {
 		/* P/Q data pages */
 		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
-		asm volatile("xvld $xr0, %0" : : "m"(dptr[z0][d+0*NSIZE]));
-		asm volatile("xvld $xr1, %0" : : "m"(dptr[z0][d+1*NSIZE]));
+		asm volatile("xvld $xr0, %0" : : "m"(dptr[z0][d + 0 * NSIZE]));
+		asm volatile("xvld $xr1, %0" : : "m"(dptr[z0][d + 1 * NSIZE]));
 		asm volatile("xvori.b $xr2, $xr0, 0");
 		asm volatile("xvori.b $xr3, $xr1, 0");
 		for (z = z0-1; z >= start; z--) {
 			/* wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE]; */
-			asm volatile("xvld $xr4, %0" : : "m"(dptr[z][d+0*NSIZE]));
-			asm volatile("xvld $xr5, %0" : : "m"(dptr[z][d+1*NSIZE]));
+			asm volatile("xvld $xr4, %0" : : "m"(dptr[z][d + 0 * NSIZE]));
+			asm volatile("xvld $xr5, %0" : : "m"(dptr[z][d + 1 * NSIZE]));
 			/* wp$$ ^= wd$$; */
 			asm volatile("xvxor.v $xr0, $xr0, $xr4");
 			asm volatile("xvxor.v $xr1, $xr1, $xr5");
@@ -372,7 +372,7 @@ static void raid6_lasx_xor_syndrome(int disks, int start, int stop,
 		}
 
 		/* P/Q left side optimization */
-		for (z = start-1; z >= 0; z--) {
+		for (z = start - 1; z >= 0; z--) {
 			/* w2$$ = MASK(wq$$); */
 			asm volatile("xvslti.b $xr6, $xr2, 0");
 			asm volatile("xvslti.b $xr7, $xr3, 0");
@@ -403,8 +403,8 @@ static void raid6_lasx_xor_syndrome(int disks, int start, int stop,
 			"xvst $xr11, %1\n\t"
 			"xvst $xr12, %2\n\t"
 			"xvst $xr13, %3\n\t"
-			: "+m"(p[d+NSIZE*0]), "+m"(p[d+NSIZE*1]),
-			  "+m"(q[d+NSIZE*0]), "+m"(q[d+NSIZE*1])
+			: "+m"(p[d + NSIZE * 0]), "+m"(p[d + NSIZE * 1]),
+			  "+m"(q[d + NSIZE * 0]), "+m"(q[d + NSIZE * 1])
 		);
 	}
 
-- 
2.34.1

