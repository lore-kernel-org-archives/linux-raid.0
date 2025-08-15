Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012033.outbound.protection.outlook.com [52.101.126.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5EF2BCF53;
	Fri, 15 Aug 2025 01:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755222892; cv=fail; b=eXl7vCGPTCV9dNBFS7iOxXEqQx3+ev7vWMkuRrm2LaSBxBmtuDi3FsmyFfajf+bF2+X8dKiqhkgGamuJsT+jUqd3vqliug89DwvyCojugpRvunBw9NcUsugEeqnzGBbmwe1eJMEVHAECC1ccumKczAhCC1RomZ+ltABZoaXRsgU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755222892; c=relaxed/simple;
	bh=LIcbvOyzm74ZIoZkqoZ2e1mfRQFN85scs21vlpvbQfE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BtFEZSjRqGsuQ5zCHyf6a0XmUL6TDpgAfZVQWwng8Kd1hgPoE14nTbcL5k2WO7yWlMg3x98KcEWakXffCeWGCZDg0OP7mOnsJic45p0PaUHK6r8b5N0YR6A9AO/E2DUJDJ8K+KHyQpkEq6+NkCNVXp7WO0dOS03QMhUN1GDDGwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=ph9vvu2J; arc=fail smtp.client-ip=52.101.126.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="ph9vvu2J"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MNqZz5Xsa02nvUAArUwNEHYr9gBn0slqR2GVoGCnt9b0DRcTGOV8AX3QnlcpyLYLkl+ynJ3tpx0+tmU1IogFF6d3dqVfRmtOE8NYl1IzYH2HYzm7oYnOhoQgKZ73FxMIkRrWsJ+9UbwgulfhRiMSHDMaIfgfyRiW5tekIliwJsuVKFtQE/DKE+Fcw9JHrIjJHZgYtFBgVff7+f5vh8Ov1LAT5vMGzRCHMLZ5EgVy5QIU4WbEUDAZpHqhf2katmXeZ+5/d9/LD9itKpBDNqGk/l1IE2P/DQEtEmO9YCS/cZyC9dbKuuaOTXqTlHwFuzqgA9ZmYk1Siwd/hQpd3cCdpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bd+JwDbMhFMy9WCh1cam2IuAhwzeXZB1GzGwpYFgBRs=;
 b=xid+loFgVY9Sp+DaucqoT2G4J/wiMxWpKuUz51pzAikdUv22GGaRHA/0CEVgG9IIgd9jujAMbize/pj0WtmXdElUW+bFGdhaAzQEAgj6NGT1B/xrcewsh/Prp5F2SV2D8f06U3FoHQKhoh/DSnPlQRaR0TchFQ8klQjl/enVbqpNoFAx1BJ/BeKgedIIyVgvojFVP2IDjGtILILhGgm3IHf6ejq2H/YXLKqAvo2J0R3p/rQLocYNC5eDE9SMrwugAxZWSCGOWGYiTmQdCZxaPMvlXGHuP9Fz381/6D5EHUfcMQO6I4jpSJhB2utRjxhLVNtUNgYMA/ubhF+/kav7Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bd+JwDbMhFMy9WCh1cam2IuAhwzeXZB1GzGwpYFgBRs=;
 b=ph9vvu2Jy4w+WHtmRNqOybRQbn5CQNlEGkPSq+spm1ca6RPb/5TWiTGNReGLIS3wqlJwmN4nJhe7xr+heLqaWbe9dluF9SlckXFFhpavUylkT3XwKZ1EZIXH7+pElXwKW5z2srjEBRNDq7bAQy3B/4hk37hG5T1nn1p+s8A0KQYNtJ67tNWz//05bmNAryHjtR4MP0jwys+vmpX0vuNmaP2smEUK3oAmgjAgJgJ9VpjqV9BdTe3JtburhQKBsoJQCAJ6vzYWdYg7DX0An544RGBMtkW1NfaELjWhJuCSKRHM7+f1db0n/coN2lxYJm6WRFVzrDf2x7Cou4ESdhkocg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by OSQPR06MB7974.apcprd06.prod.outlook.com (2603:1096:604:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 01:54:39 +0000
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
Subject: [PATCH v1 08/13] lib/raid6: Clean up code style in recov.c
Date: Fri, 15 Aug 2025 09:53:57 +0800
Message-Id: <20250815015404.468511-9-zhao.xichao@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 54063a0f-c35d-40d6-6264-08dddb9eb194
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p9DGnbxVSlrp3qhnvs913MBVCZJgdRzTkXDNgx4Fu/o9Me5h3GXSPyoFT8Co?=
 =?us-ascii?Q?SQeFN4KVPYZIvJYpQ5oGhnJijpP9Q2LFV/I1ZMBYc7fpARm7Xs+ktxbT/fK4?=
 =?us-ascii?Q?Qvt5zCCxyQbGY07AmF8aFXsV0VjrunYSuiOCvWmkwbwTFWaKQp5XLrL4Q22e?=
 =?us-ascii?Q?Q5+Httsyv/eK+PV1me+nNggumU8iYX4OHqLrri27P8BQ4FqB7nLTAwzSjzV9?=
 =?us-ascii?Q?WDGSzCTFpwX0LVCToSmYLFjdL9kEEdIBZB7u7hDkTNn9R+g5faj/ZRc+QmIZ?=
 =?us-ascii?Q?bWy8RzD7z0EwDmAAjls/kzUwoefDOc2j5h+vcrScVrAO4MDN8HAKvJY+wj6r?=
 =?us-ascii?Q?yqVNFh2UTTvtt5rq5m30zqP2Zbw6wxa9ZWyi5woDgYHNpnxjTh9GzXzZyktN?=
 =?us-ascii?Q?yC2FUncvOWQcm0dnMhKg6OpIVM2uITWtsMYBrLcNfchZet5gnnC5Zhk4ThgR?=
 =?us-ascii?Q?uuz1wNW4FQ1wKvlSZtTticD7G+ZBr+N9jPPtkQBrDi7aFLP4fcM/755BaP5C?=
 =?us-ascii?Q?Lk/W15qFH+PP4ZxtiyePBlqHfcrlI389BbcvQzlkdHBznxgQY6prHK49diX6?=
 =?us-ascii?Q?kRAmPWXRn0NzoK6H544IxKsLcig+1JhaAc7m7A33CvSdJVnSfEJgUtoHAtLT?=
 =?us-ascii?Q?27LOu+yym8bosrczw/0p3uThgSJdkX9n8J/4yYvrfNbuQKLofkbvi6pIfRzF?=
 =?us-ascii?Q?v6b+V14hcpyXQ1fnLyxf6Ns+Jc/nmoR6S30NbJkOEuEV6GNR8W7eughfPyLU?=
 =?us-ascii?Q?2KUe1adzSYToqZmenii238Ld8djy0bvo0ZgRdtshIyaA1aazPwgIOs2lYPLo?=
 =?us-ascii?Q?WMDeTJnGuT+ZqUo/fHWlYNsGY30oSc6gjOIUNRe6nkaxTG3gyk4MDXm76prD?=
 =?us-ascii?Q?0SGDincPo9ikQKaPvJkurSCPehw+3TxfVhJ8H64Ajfzw5sqlqNo4MpZ+Z+Li?=
 =?us-ascii?Q?OvkZoGz8mIeJ7Khzd6uyU4ddhvI66YbnwbiMoU87lFD8S9qEwFLht+Q3ZCA9?=
 =?us-ascii?Q?I7auflyOJGrNF+9Qt2UmFZfIaNoEE/XCpic7Iyoi4T/9y0Js85EDEdbPaZas?=
 =?us-ascii?Q?uO2xLlH0DXDYblSHM8WCoonqDuDpHEGSrhlqy9EFxScyZuoFGFYkUOBQB+su?=
 =?us-ascii?Q?wA3mz2+6eOplXkuCQ7dgWrNMDUNBuMssbbs6DKHncp521ANucku/g1tDg/oD?=
 =?us-ascii?Q?3rNbjRH9hQyyQr1jtcvjRWH2Hzk5WM2zpPOJqVhW3cBx0feVAz3WuAfdufBv?=
 =?us-ascii?Q?JHrHacNkSh6xvwpa8S0KvGoCASAXAnskNYV1SlBjvME+u/4RQegdOehrwILe?=
 =?us-ascii?Q?3WAfoV3XnvcgFYhkifs+kqMn2i3ll8owUNtNTs46JnMi6+WxgZ4zATydzYNQ?=
 =?us-ascii?Q?w/Y7FtwYmbFihVpcRYvIyiIyyWz+HPVI6B2aT7wXcuMxzvuU8MMgS6jGgqaf?=
 =?us-ascii?Q?DxE3IwLPAYyfqAQkOi9/caQtpqcZ2LmqhdoAl4ZePTAzodYEx3ZUqg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VKRGdqcxk372XqC4QFEDTDi70XcGCvS5DGhRIN8jpDkGlOd3jSqfPobEe4Oq?=
 =?us-ascii?Q?6TiNWFsnCTlkggsoK0h153DdyMJO9vPln7IGktIX8iWpNc+F63OZcZQex/G3?=
 =?us-ascii?Q?O4L7SZ9cbh+Vq3Fx0a+ydgO2oN+YIcUVXuWPSerdYoZXFwPmeCafGCr4Spuy?=
 =?us-ascii?Q?Xhpart6YXdJo4uicvbUUUcwLq5tU/EYgWT56NnXun7s2tWUAwr+PaNla44x+?=
 =?us-ascii?Q?z43jhmrpVZCz8WrYolRZh8AqZtpj4ccmARs/A0U5ST4XknU32PZTHgbje+iQ?=
 =?us-ascii?Q?Pp44Rh1t4/UzcKOYN+GtMlQ/b4xjPN9LgDfV24472GNZSq00i9wL2ZX1z05D?=
 =?us-ascii?Q?4gx5quk3oAGBoGXiQ6s0RUS5Ba0JhsXUolYZbTy1l4ILVEjtd5A7EeG/KPdK?=
 =?us-ascii?Q?pfN0XXD6UWD7K8d94ZkWD2Id/fW33IG1tM38gu9bnViz8p4KTNhrFxxoDeeT?=
 =?us-ascii?Q?M+0scVxGkbbHCOQ6V6D2JFhq9SAtTEh8EYcEKa/4acbyRnHLc9oPw6vJpVg5?=
 =?us-ascii?Q?m5Y8sfAILaTOhL1dhDHQu3ZEqGNm42bDLKjdGbSBWMquOwoLxhAZOmLqfRiN?=
 =?us-ascii?Q?COhbLWckPFBlnH3Bj0eyFiO5SQTC1Az6FRtlyxpzLBkZMTHpK70NSS6emlKz?=
 =?us-ascii?Q?dAJnrdeWh1y4vcnFv7MgLE/MIgS1fOsTvTzm/M820Arcn2j0WPaSuH8WZWQe?=
 =?us-ascii?Q?+tsmV85vfhJ4x/Rpq5tsbqgroXK1H8fMoXr9xJyIGPYY4VnKF2rSlJ/RkQbA?=
 =?us-ascii?Q?mW4n/2k/1Z4i24ionkoz//WZX0+gXR9LzJMjObIlGSiIRwDCqAiCifYqczHb?=
 =?us-ascii?Q?Rr+c2hujNYXcjMizDRu94zjjAeBzz+1sIpDdZBgrmG0oeFqU6sM37Zbb8vOt?=
 =?us-ascii?Q?87mcG9mYUV9o7wzNNCJ5DzxLByajaQv4njpqoUCjlM8YIswJ89RpHoaA1gm/?=
 =?us-ascii?Q?zdBHj2hLyCekgJttE2Cb/TVgRz3sTnywjYqH4zxddbUESYcHFbsrRD95bjqH?=
 =?us-ascii?Q?SYWaUJ7eH1/qIRfrNTkXZKLJoSvbHYSWHKpKX4o1hJ9B680+xHMQ6zAjXWps?=
 =?us-ascii?Q?Ly1YieeQUprZSlY5Y6Iz4cir2gTAVAir0Chmllqlgp1Byu952P6TFnUPyJAG?=
 =?us-ascii?Q?pBqY1cjQgNHxBqhz/oirn0VkReigw1uPMH2cz9W7Bq2k7q27iMX0hbv7eg8J?=
 =?us-ascii?Q?wlbsiaR97dmzbJbQzADJ07Vq5hTnFW8VsU6w0aYcujKUbN9egBxSPHmR9NRo?=
 =?us-ascii?Q?SAYpDadbv/kR7tU54rnymPgJtR7rMGuAP1MgCn/VlWhRQc6cTcS4n4EUR67S?=
 =?us-ascii?Q?/npUuU8Xqrz9fBynSOXCXYzPrwqnJQNL0ZqTHJAchBcCIQCc7cD5/Yx1ohKp?=
 =?us-ascii?Q?YUgHeHnPhaHElkNMmCED0IxU3PKfpwUJ4tMsDjWctyjl6qPzqK3kG77QmIDD?=
 =?us-ascii?Q?/7uO7wVxtq1XrcuCkayaIer/rynBncdCQRIW/SWnw2Osj6m6K9ir/0+sFj+3?=
 =?us-ascii?Q?n4upnBlu0cL4fe4JhlkFCVlBxDR+9T94W5RIoaGqtliSEFS5ufycnR4sgFjA?=
 =?us-ascii?Q?sfz/B608AIX8pK7dC5GbBAhv7jwdnBA5L4VhHZEw?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54063a0f-c35d-40d6-6264-08dddb9eb194
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 01:54:38.8777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OXvBaFDWHtv+rBwBDtTgAkEYpryZvZYMuvudd/CXXpLmaKEPAfbf6BrRxXGk+zpM24p2eJNKF+3o4TRorEhdmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7974

Reduce or add spaces to clean up code style.
Clean up comment style.
No functional changes here.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 lib/raid6/recov.c | 44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/lib/raid6/recov.c b/lib/raid6/recov.c
index b5e47c008b41..bccf459c3914 100644
--- a/lib/raid6/recov.c
+++ b/lib/raid6/recov.c
@@ -24,26 +24,28 @@ static void raid6_2data_recov_intx1(int disks, size_t bytes, int faila,
 	const u8 *pbmul;	/* P multiplier table for B data */
 	const u8 *qmul;		/* Q multiplier table (for both) */
 
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
@@ -66,20 +68,22 @@ static void raid6_datap_recov_intx1(int disks, size_t bytes, int faila,
 	u8 *p, *q, *dq;
 	const u8 *qmul;		/* Q multiplier table */
 
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
@@ -117,9 +121,11 @@ void raid6_dual_recov(int disks, size_t bytes, int faila, int failb, void **ptrs
 			/* P+Q failure.  Just rebuild the syndrome. */
 			raid6_call.gen_syndrome(disks, bytes, ptrs);
 		} else {
-			/* data+Q failure.  Reconstruct data from P,
-			   then rebuild syndrome. */
-			/* NOT IMPLEMENTED - equivalent to RAID-5 */
+			/*
+			 * data+Q failure.  Reconstruct data from P,
+			 * then rebuild syndrome.
+			 * NOT IMPLEMENTED - equivalent to RAID-5
+			 */
 		}
 	} else {
 		if ( failb == disks-2 ) {
-- 
2.34.1

