Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012033.outbound.protection.outlook.com [52.101.126.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32B829DB9B;
	Fri, 15 Aug 2025 01:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755222887; cv=fail; b=r1qabj7r69KqyLIb1VlsXyvv4r5qQp2Cb/cyVVDNxYCU9Dn7U5CHj/LOIqRGUI6lDb8HavQ8fg2o5FgeWESZFWC7huV6Xf8flBNU7Wr9j4wuMDkRc2EonHMKEaM7cVDYBk/FmQgrfyxzmAeKXDR2KScHC1WKY95C0UkhNY7kzQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755222887; c=relaxed/simple;
	bh=wHqKXSs9Rk/MMh+JwSIN7TxkNXAwsQ4VssVHGfJeUqE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AYrhNrlmmRdzuizIpjVjiLhZFauLJopVV1GJHIJ9ITTwBOhNCmeM3r8qUq2hsv3byeynokYJ3LsrDWjOy/aXnG6++rCAyAz0YtxxH7ebTgJlCNNdmLiOxpfeTVxoG6dYHXBOyKRiKDDCmx+7mkYwYZedKQGi97QJk+RVv4Kv3Uo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=bTftXhuF; arc=fail smtp.client-ip=52.101.126.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="bTftXhuF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vmG8DTofhtQavc65zaxyb8Xtg7G3SbyBrdhkCKbfZ5zirAao1P/O/3kbbRA9jIc9JGXKdjzokuNsWWoozbhay7GLs07MQznkxkYzmxn0P00+SuOVg5EB8AvRdGkWBCbt33SIwaC4NYn/fPK/0ADjM2im23TBN78MEk9WNWkNjVOWbUdvB15ZbOmctKxN7ggOKOYdajgV8LrMWXd48e/hjb0aAr5yn6wj7XEo9Fm8tiMe6dzJUuo2GhYa9fLfzF+/4DeuZcgvXARDDUtN3qeq3FJjOW+YX7OXhe2MEOWjIgU5kEiWGBDcgf/2YAlaS6Zl7zuaupNc6ywH3AKDKlpHJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oJkqBXEF7mv0++XSUVWa4xezIj/ocNNaS0BJ8RZt+hc=;
 b=xOQMkf30m04h/F10qv1EVFKzTueDkYoeAUeY1O2PMHiEWYCAN3bzshx6PSHKLVkCcnFN30gwOG+FRNs2Hx6d8wyTW9Y5FGkf2WrgNnpY41qlDo3iMgjlG9HAT61PLOswea62B1fzSxR2uc8WTDpOdRuoDk5uQkdClTzb0EUAHaQMTj8IEP6rxh4A4Sfw8HRsV38xg629jMaUVjNfylFFi7E4Y0BIGt+RjSayhS3fZa8TWEDLm4LaxtYhTUdjTBsph8PK6tdZX1e0ip20KhDaji1pppXuHx0+TWnUq+tiHntd8cUdYM6OPZiD2FSZ3fiD5kfur9gLXURblwKgGeqosA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJkqBXEF7mv0++XSUVWa4xezIj/ocNNaS0BJ8RZt+hc=;
 b=bTftXhuFV4fw2LIAKxQ680BBWbGMJZO3YiBs48+yx6YzJ/8YHlNRadD5uLHvgteqRswvul2hjMy0H04zqoHyT6M6PrLlFdiYLNe3vP5COU7imHasDUjSfmRsk5d/VzBxd3V34jDWe/1Amz2tOcTvaT+5M/CfbKUaD8tcRvPec2FQOkEE8obvUb3gt3SoO8AARBshuRUvwhvAIZHooUg0+WrJHR5N5BVHuACZyoa6TMwAP/mChlXy2I6Cx1HofCeeU+HnvxC2jYaC9AG/D0mjCGef7baQX150JNUClFtNG8XhBeee0oe1FtiVeMaGW3KX5xuQlaHN4eYpH9RoIYZOXw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by OSQPR06MB7974.apcprd06.prod.outlook.com (2603:1096:604:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 01:54:35 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 01:54:35 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH v1 05/13] ib/raid6: Clean up code style in recov_s390xc.c
Date: Fri, 15 Aug 2025 09:53:54 +0800
Message-Id: <20250815015404.468511-6-zhao.xichao@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0cfe72df-d0d1-4a86-bbd2-08dddb9eaf97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2GDp6I6Hq2s4ukWofuVrReTnZ9YUKDCCmygxPoB89yOmVMHH6fQ8BpSU9Skf?=
 =?us-ascii?Q?Nzz+lUkYxUC+Ty66bs3knOnpw78+2SENgTfAFK4Qpw4LWDigXZV5Gju9s97G?=
 =?us-ascii?Q?fxR34M25j05sC7AhtXiFvYFLZsRNyGp2L47WoWSksPq9/ONYnyX7+0E95ZsX?=
 =?us-ascii?Q?I7QawMp0L54/3HUo6RSe0NBvcpC1HILnjdyWxC4ilAuOzR7QkaLTubNdSpxI?=
 =?us-ascii?Q?lWfQ0A2Bokfqr+3D5okdec/g2DjZUIGAQRhQMjBKf5dEoC2BqJyKKveAbpxQ?=
 =?us-ascii?Q?iAE0hpx3Y1NjFY2hHYrwiKrLOBSM8hlVN4NEAlTmzW71qasUyu+fFEAqLLKJ?=
 =?us-ascii?Q?5yQ6z8COzDHqoZKl6wnP1hXR8edBk8KVl1fNMBpPmdIfsFnxdYZqsolcFPVu?=
 =?us-ascii?Q?wYyt7EcMW2EOD3c5/s4tWU+LmTUrkXsfhdnNiCc8nBIezPbCNB5X1XrBiztb?=
 =?us-ascii?Q?59WvCM+PLo/Z6qoHhz+4/bIxGk6ZGLLvz5h/xMqRgpNQpANY3u7e4JT0/4oa?=
 =?us-ascii?Q?9F2ZNl1qjvnSGYNJnkWTmnFVzqW3i/73U02rn3gPL0kSGLsIJGU36M+0pJj2?=
 =?us-ascii?Q?0lq7sbVv3rIiJLKOkckesbmpjG64zK/v3ejE6pg3Zk0nbpEYiociCPMUZsjh?=
 =?us-ascii?Q?HVp128iKKF7/x3mQvcpo4HMBPUx+V5l9vI9L6pITZLZy4OSc7F5KGu2A+oSb?=
 =?us-ascii?Q?2dZ9bJgi6PmsQTo5KeSO92EeiJu1SceZSAJWbXUEg9wVRv6zo4nkwfwK4y0c?=
 =?us-ascii?Q?2euf36EkboAx3WOHWBLbrimwqI/zkCJoFBEF9FIekvmsMwHE3xv9egHgVTYa?=
 =?us-ascii?Q?GKf+mdnZCDelHfN4fW/h6sf0NltiwcvoR1LZsENGRfRjfrdPAdQD47+xyNzp?=
 =?us-ascii?Q?oX3NF0rW+RUnHmWPPrVKK+ZRQd/Uxb9XnBhsFnGtenAG+TSWPBnwXInLcKnf?=
 =?us-ascii?Q?wJRZ9vrsnzkkKLzVgx13TF0KS/coiSFCtalW2rNh4ky9Mk+DLRxyzHwOaAoH?=
 =?us-ascii?Q?SYN9x3zkwxY6M03Q3PvQIa+qFrKOO989llApUBBANCQJEjOBZXb2Yn+CYU0x?=
 =?us-ascii?Q?xc/wJSlERvVEf/eiOp1UgEraotA+mkKcuDEtJtJ9AChpnQ94WMAE2VOEe/Me?=
 =?us-ascii?Q?0XSF74Jaqddd2UhTD09nPT6SDjPNE9+5QkUEBtNhvGpQPqtKdnuA4aqpbmnv?=
 =?us-ascii?Q?4KvJ15FerF1WIa28KeiSocR1UxhhepAjURVKJITrfPB0uWur+RMVQ82bPppQ?=
 =?us-ascii?Q?1sMqQTfj7RoYnJwBPKMOPSYGwQLfMIk17s0OpXuIZENJPkDhvUWuuDKh0nQd?=
 =?us-ascii?Q?vYcYt8Vqj/t1mGTFZnRE1ZhlvHFdrroCYbJd+S81nc7IXNJFrsl7lswfId3f?=
 =?us-ascii?Q?trpj7M3ZhBFANdNkiinP3z9kpoCkVFEQXAb/VmSTnKBWejwE5v+XfqiaZQO2?=
 =?us-ascii?Q?BfLtqriqGbxxPat4mfU60iVH7U7oH7/7MzBDGULtw+XGuwIYmokI5g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Nu3XJEd/H7fXwqybJOetqbtc1vCtmpF8YHXPXisW9E8bOjbdNoFrFAyLClss?=
 =?us-ascii?Q?dt4ttKCH1lXLnUjyc3JP5tSflpG01jkEEksdK28JKnnOV5zE3rvJc0VUMFg7?=
 =?us-ascii?Q?rs8feKaJ4jmzbUABWstCbuJzGNXnLwOZfqttpzFV5yTKq6dgxW1e/xHJu4uF?=
 =?us-ascii?Q?qQR5qljQ79gKmLV7ZjLKmvLf2geJswkTqCUckqP/WkhGcfBKFlzyZRSrY8Sv?=
 =?us-ascii?Q?/CELOV79rnjTOGM5C1zURdv0QKmbryAddfSOlBcc8w+LwyvERi3R4e/C5zXk?=
 =?us-ascii?Q?ivVOjgfud5LnW/nU3FzDdUjnwELzQlyPDm8hcwXNe2doc6Piuukoc9jFO9+o?=
 =?us-ascii?Q?5xj2OIx499xbCEYxd+b83z5oPU0ex98BMGRdqRPmYbuClIKrCSK7Uykzv59v?=
 =?us-ascii?Q?aUnXEgihZWkyGtL0FgcRVAT8kD/aHBgxZgtPzkMZJ84VNOKCqOCDqT+LF+Uz?=
 =?us-ascii?Q?EVhw7dbA+kvENdJtK9jgsymeEWi2tikDiIMck7pNqN3Oa5CZ+QzOXY8Ab0S6?=
 =?us-ascii?Q?VzT4ma2zrgoTgTHnP7DqB69dJtCxQ6lxO10eexgWXb8BZ39Shmvzf5NIQPKd?=
 =?us-ascii?Q?szeVTyLEkRxtmmTYd8c1AXbUybF3jHUGoejs6Y37yBSdOmi/3yX2SugLnCRV?=
 =?us-ascii?Q?8HahK3eA0js/teVx2IyDsgECpBCugnFQGTy87iQ+EtOSw8x5KCFvtXKyT7ew?=
 =?us-ascii?Q?tnG/8ONYb2NmPWS0IqKnqFkPMZYsTQfyjXlhyxwPlI24R4jLe2qesEHzrWBF?=
 =?us-ascii?Q?v+eIvrasO96JlzrirdyNnGzprTeoFKo6K38vA3Fw7/NEcRmIH7cEQT8u+ekT?=
 =?us-ascii?Q?+1xD16VwBM476rj6YmTQNPbWgj5ckCT/hrW+08uHF4locJMboydOdzwe34Fx?=
 =?us-ascii?Q?2mcHm6mxWnzAeuVyYiesV8mwOjCpGAeXJdS96Kh4DqbCM4Dvnzq3Vt6ZWci4?=
 =?us-ascii?Q?cByFedTWsMAhigRVKaCP9VNDYdOVd/uiqor8+VHvsF/W4/X99qz/h1nH3eSR?=
 =?us-ascii?Q?3nsvmlgRw2lXOjK/ZdSI60LwQUTQnXDINOsxSK3yBLYxIy9sTQThAI7yklla?=
 =?us-ascii?Q?n+WpBPFMUYBBDhmaQMFpFBrK3+7D1CMkBJ1GreFZHWyBkm4yRk1YfP2SJCxz?=
 =?us-ascii?Q?Tsr//uJjZYtl/99H693gtHd/oeMhNyQ1PylZiSGAPg7+3hEDHmHKqh1X9ODO?=
 =?us-ascii?Q?Fnuqbv00VmXOKWqpOuXE1rjEmJ7AYYi0xg5RB6PfpUlq+lr2g169BCP3K8hC?=
 =?us-ascii?Q?Lp6d4dkqLXGuURwaIwNf9x6pXPh28vOo0OcppYvK8h1frnHFoaOf3hti3j4L?=
 =?us-ascii?Q?JApPiV8UjgUJBSuQ7Fm315CB6GuVb9UR2lD0w99MX7w9vvfkXqHKmFrloPTJ?=
 =?us-ascii?Q?qXMgYzzGezZBBitgK504aSqyRdnVNSx2YQ6nqwCvlO6OSBvRukoFy2k38N5w?=
 =?us-ascii?Q?0Tn0/Aje2DO7J0I0cKUk0t0kiit9u4fhIBqlXMkdzgWMquqlXQSCFNKJHMNV?=
 =?us-ascii?Q?+u2Wn/WghOMaxzPvo9ztgqrlA2/juNc96zcGsXQmuFaZ+N2xt5/N+cBimMZk?=
 =?us-ascii?Q?dGLvWZYfOvFJe2LZk+rH8Z8aw+NfUGGjNAlbGmx2?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cfe72df-d0d1-4a86-bbd2-08dddb9eaf97
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 01:54:35.5251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l29Q/RZgbPzhGL073HA/1j3/x/20mM94TFA9/L2ecZYqwPBTVp1shAzdINzm35TBAvF4JiAOomCuaxJuWS6rAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7974

Reduce or add spaces to clean up code style.
Clean up comment style.
No functional changes here.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 lib/raid6/recov_s390xc.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/lib/raid6/recov_s390xc.c b/lib/raid6/recov_s390xc.c
index 487018f81192..f1b329ab0229 100644
--- a/lib/raid6/recov_s390xc.c
+++ b/lib/raid6/recov_s390xc.c
@@ -27,26 +27,28 @@ static void raid6_2data_recov_s390xc(int disks, size_t bytes, int faila,
 	const u8 *qmul;		/* Q multiplier table (for both) */
 	int i;
 
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
-	ptrs[disks-2] = dp;
+	ptrs[disks - 2] = dp;
 	dq = (u8 *)ptrs[failb];
 	ptrs[failb] = raid6_get_zero_page();
-	ptrs[disks-1] = dq;
+	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
 
 	/* Restore pointer table */
 	ptrs[faila]   = dp;
 	ptrs[failb]   = dq;
-	ptrs[disks-2] = p;
-	ptrs[disks-1] = q;
+	ptrs[disks - 2] = p;
+	ptrs[disks - 1] = q;
 
 	/* Now, pick the proper data tables */
 	pbmul = raid6_gfmul[raid6_gfexi[failb-faila]];
@@ -75,20 +77,22 @@ static void raid6_datap_recov_s390xc(int disks, size_t bytes, int faila,
 	const u8 *qmul;		/* Q multiplier table */
 	int i;
 
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
 	qmul  = raid6_gfmul[raid6_gfinv[raid6_gfexp[faila]]];
-- 
2.34.1

