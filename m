Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012033.outbound.protection.outlook.com [52.101.126.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BF12BEC3C;
	Fri, 15 Aug 2025 01:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755222898; cv=fail; b=mf77pJq8umk/nmhpI9LHnk8ItjqQahJWRMDOYYEdM/u7kUrsI4qOZHf+VoUnIlh9HJNb3Lr4NOxJLIy1N0K7iXXyo35Ln1g9mSRtm/6CGTKe+tVqWIaIIneMIt2zaUFDglxsGG64Le8L7MW5GXvaFdUc7+DIKB0VEbYpHA8qe9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755222898; c=relaxed/simple;
	bh=6FloEXX7Pu+A2hIaBfzX5dKLZijPzrRP+hMXKp3DOyo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IPjIhpG6qWWF+1evLKhyjFkLgl+/8ewHKbI5xNeFv8mg7Zke0Gyn1nTa4wpgWhcve0AyTYqEN2/CH6UvaZh5yfmcbsfjV0RL2TrxyfQrg9CQIC1+PcgSBdQfXx3h7Dw+EEgib15nKJ4YnBWY8s0OjATGASPXN5/Zfx0YKt20vaE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=fail (0-bit key) header.d=vivo.com header.i=@vivo.com header.b=YcfFG1cE reason="key not found in DNS"; arc=fail smtp.client-ip=52.101.126.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=vivo.com header.i=@vivo.com header.b="YcfFG1cE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DgFx0mbz0QEjbfsw9vp/w/OeNybQ8gBld/KwW+8Pxs0vG7yOOahvm2TIwtsJ+FOOBJxlEPXDVCL5ym9AiWs5SDRXOmPcv7laMke8Ek50uO7gereU0Av6q0X3BvgYI6rCQlv9U3KbM9kS6funKD6heU8t+w02gze7wb388JqeeegtMNwPnslu6Y9Dyo1xbHu5kcWf3HavKXgyK7IuncN3MgoAubBJFTL2AMPHVPJwXNTA91GslFMA2pOAtv+L+nkiU1mfsTq5lLL0s2n7Hrfb2Iu0yzT/Q8W+SwlCqjosgF1sE4vByOmLVMWVZRjlhZwNojQJo4Z3hcAT309zX5AIWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q+u1uNVYYtMeUNiE+ntr69133FG9mwlkM1Mw80yFQ8A=;
 b=VSGU3ynyAVRhU5ug5yxynfeeuA4dEgSdqZ71zUPPozvOasmKhsoi5xJSj5u8jSKfUR+j4ovGoNWx/HmmolIRfuzKBfcCi6M5v0lDWXQMRh3Gr1uV8ZVHQ9A74yo28G+VFosYt880Ococwb2qKRkFF6tvWp0G0thCvYOYasrhjSJ15sArp74GWMD2QJsQ/wOr1P4ZxGRc5B8Hntv1Ega+XRp9sIpjPCFQ0gDf6k0DLRyntJPqby67XkMasXj7+kRrsCM5G0yYmbpGfzey1c/TICb1kCZ4oOGNKXGyV7URXOUMzTIWs9fLK/TyMXDHVXiL3OiV6ujqGvzuS7+nN20vEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+u1uNVYYtMeUNiE+ntr69133FG9mwlkM1Mw80yFQ8A=;
 b=YcfFG1cE0Zd0xqnc2jzzE3sac2XN1aKVN5FtuFrcraUP8DBEngfGsjYmI0Woj+MMW2Z5cHhTA9dvWd0jnPyN4zM4FqrJ7//KeUI3/c7qhMbxFbiT14k4Y74RVCRkbRULosqjKZsG1gKUvHj2p7UK32RBvWyLEt0R4WsZy1RCSQmOsmIsVSjZ10xRPzpozDU4eKGmUMS7PBvs+gNs3/r1Ko4pUbTEAj0UAt2IqZjYjkT4vlgPjPs88Gi1pxnPMRr8PBZ+QXZ+itFGEWYZb4C/bj420vNsVxDjEgJws+CjPW8t3lS1Lb8ZennOKsa4g0iJI4CNXYq8SmIbke+Aq46dkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by OSQPR06MB7974.apcprd06.prod.outlook.com (2603:1096:604:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 01:54:43 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 01:54:43 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH v1 12/13] lib/raid6: Clean up code style in algos.c
Date: Fri, 15 Aug 2025 09:54:01 +0800
Message-Id: <20250815015404.468511-13-zhao.xichao@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4852cb9a-5b06-43f2-54c2-08dddb9eb462
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iSkV5BvucTCyUDI0VORlQqBIMP52IGtsFYwkYX8nkAfKFc81XYPyTgiuKGGo?=
 =?us-ascii?Q?oaP9SPmdjEJbM7Qjmg6zp3ts5CVh2QWYvBV7vmRpInMkMpFbK5EfynJDNT3s?=
 =?us-ascii?Q?P/pH+6b986GDseGZFLQ0TYWiZcF89n3JWOAFKpzNFgKgz0dRNsl79OTbUuTD?=
 =?us-ascii?Q?ZflOaZ7ThZnuuZF04fIzK4AScE3tZiXMf49LXHRsRg7zs0kpZIIC6r02LYuT?=
 =?us-ascii?Q?2r6Qs7RiM6JxWi0a1BOeDs82ydST3BdBMbC4N/Eg8d2gJdSDw08w77GXBkix?=
 =?us-ascii?Q?fhTLAnuJT3QNIzciKb7S+/niKNjoBy28bYbMJDBbERyEwUtY8WkzHLXZoyE5?=
 =?us-ascii?Q?sbZiU0beJneAc2eipPGA9loe7Tns9vI7ytLLa4EDkTlL2RfEq4efwJlVi6Eo?=
 =?us-ascii?Q?3fMJ3V3HOYhU6q9MM4439XGYebMN4ggG0i7mvIwhqYyow91cBxFNWXxlGZp+?=
 =?us-ascii?Q?nfbPqqCluX2eiCIHRq/EKpJVGgLc+mGReiFBREoX8adW2Epx/kCewn9H9qfT?=
 =?us-ascii?Q?Ka8WmWNNJXHaKAeJbeDA6jo/YR6va7fBPLvKLsazSR58dqSH8l6FNXtSA/Tp?=
 =?us-ascii?Q?7comhBGZYM+umPZX7+pMma2Y4WszZtatA3B5vDMpzdK+Bjh307OlJ0QbOmXT?=
 =?us-ascii?Q?lI5ytX/kEg5J6Qg5hej+hER1k5Rt9TCu2iqpDPEwxiTVwm3lac7KGTNc6+cF?=
 =?us-ascii?Q?f2naYfXXd2AmcdAEeP45I+JaLwhoLAnvLx429Dmr6yFI7vocEBoFfLXwW59l?=
 =?us-ascii?Q?1jdfYS33Lu4YpnThquiZDZk0BwTMymSNMIsI8U1lavd6gN+Tqy3xZIzvHbV/?=
 =?us-ascii?Q?pn/UTt8WuxQoGZCRO90Bbzb+OhAYAU1HcTpGRMe6mwXdmwW8Mxn1ZzfdFYbi?=
 =?us-ascii?Q?vh00/FkW8nkpjf5b7YqgKg7OmCkjor6ezJWYYVvoGw8aFfv5d/gm4vXTUGef?=
 =?us-ascii?Q?hbYSHRrT7Jxno5vGw8/8aH20EJOR1ENJpMms7eOyr2O5m4XxPMx30AZNDSOW?=
 =?us-ascii?Q?PsBSo+1RPWbckwTtteaYWjCGNnjUex1EDk49FFfa3HP20/tZtvfoo51lB/Pa?=
 =?us-ascii?Q?BM9ddcOw1DX2dslug5E82dbDUfaYe1NGjBJLoXjrMG9daC2gROCirfSmXOte?=
 =?us-ascii?Q?PmfEs6YA/dfUev24r04fg2u8O8GL88asWx2oDhvGUSKqSxEubnKWsQXNRqCM?=
 =?us-ascii?Q?4uDIeNdOQBQVL6IHCqss3jRKhJ3KMHrh+Ivf+DTf1MMoY81wKAyo7O/J9AyZ?=
 =?us-ascii?Q?BCTTiQ2rLkgS1ITaKy25q2CbQYBGh32/38YKyAYkP0UX44GEahPEIH2EpIfE?=
 =?us-ascii?Q?KuArb+N7k9+NmqvJtv315QwBsmsB9LWVw4uya/nt2QPEiST43prxe7Ndlavl?=
 =?us-ascii?Q?p/JlwxFc0fSfEliekMNr8ZhMBUe/4wAqUMucvPKcs+wnr+HKyWvOF2SGaOus?=
 =?us-ascii?Q?3AU37wT9PazgX5sWKfkhTj+d8eHHObM//E2/s04mTJpPES6F9zOeDg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lPGaHnOP4mm1QNoOcrGLag6xyA/WVRClKc5yDghJUneib0JKhLd2+UyzyCj0?=
 =?us-ascii?Q?tCYq+HG9xEEBbWAWhSberDGtYje6Z2FS2FmYeSGPWeKKEHBsW+VrV2t42PYz?=
 =?us-ascii?Q?CqDYDtsTIRGCij2vMhuC/ITBKL3LYE2hFOj7BWMUUih+LRKxPjLAuF8Ilk8d?=
 =?us-ascii?Q?AfHEfycM9jAqxR1GrtAZ9Vh64kiHO1/l8/kVKSEgssgHLY4Ccc7YDfV8wrgv?=
 =?us-ascii?Q?yvd3VLiv+hGPRphHd7hDCnxW0iHbxxpvIQIEmK83TmKaZ+Rxk2sqbvIMgrsL?=
 =?us-ascii?Q?ZdoA5kjLS8HcSVWH9KbLeIK2rF3QipUJWiZPgRydUTgvt3p6Y9HSqGOX3sTI?=
 =?us-ascii?Q?uDcdaxH0VHCEqtwMSCw/E4D8M35uyYEZUZ0ceB8+8vgvnL70MjSyv/rrocBB?=
 =?us-ascii?Q?y3G56eOijcM9fgEp8eB/Sv2iTD4lCCN+cP9bF3vhoxtPicJQIoBNPkluCpJk?=
 =?us-ascii?Q?BwIv56lJA5bAZbx62lCGxjT33ZHpoFYQSkkwFVs6oiN7ZLqiiVPsjBQ7Rg1r?=
 =?us-ascii?Q?V2DPOmrz4gJEwHGjL0YV6PFWdWvMSZl30G8ikycuWDc9YpthalsOf9cfj4ne?=
 =?us-ascii?Q?HWNsV8W2RR0/sDKP4WMG63t2XqTEjMVGHEUAvHJ3TUibxVqfBfj6pnPXoyLv?=
 =?us-ascii?Q?nrdOJkdx29qvSp51juC5k6XlkuPHq1iNUWIA3MNnpFuhVu3lts4XtzZGzxqh?=
 =?us-ascii?Q?B5wF3cXx1Tzfr+htCcDhzy2Wh7dieX6Zi0u6M8mqPgBqP/1zx8JnjH1skRGU?=
 =?us-ascii?Q?zDG6sOQbLFHG8TK6xscjYPbom9qp8NAExgvCyK7GMRpBBqxCoCYVMPdaDgot?=
 =?us-ascii?Q?Dcfkca1DkcBXdeUznvkn6Mz9CN4lluhuvoyAyEeJ7dRIHsNHidEgiz4UPlo3?=
 =?us-ascii?Q?SwkUSi4cZ3D0RxX9XQoOt1GF9MbJirX59QKp/LqrFgj2QT32mhtdoS6H1Z/U?=
 =?us-ascii?Q?2xvPivQOW1sTMIV27JcrAADv51ad4F/TC6ads9mrqJjcFyveD078FqZZUSqj?=
 =?us-ascii?Q?xbZu9QGTFgEHaIIyo2LDPq8tjKtIKEGUYJ0GQraHiPee43zv4lTD4cC+9PWc?=
 =?us-ascii?Q?x3ip60o6UwIMtwrpIttvzQrLKEcytW6JmXy7kttwIq4yWa9i/lIbcO4LDQpR?=
 =?us-ascii?Q?MY7mm33s1G5pnq2lr42yTedQ+WCtalk6O00Q8hlWiS72uELSZZqluArJKp0l?=
 =?us-ascii?Q?SOSeac9Baamnficw4bGp46hL6QfuQe/nopaM8S9pVIdJG65/A+gtBbcwYxpN?=
 =?us-ascii?Q?67lC1o+Iq8qa1GOXgTWWZkFCi/MfG3NMLfFY6AUtVV0kCz1ZR48oi3jWAGEu?=
 =?us-ascii?Q?kVP1eY3LYGv4td7m+XrdJ6ZyYDR9IYircAhCBDJ5OqfETObtppf/lm/1s4n6?=
 =?us-ascii?Q?tmIENJGFLTEFT+NTxFMNX+/fi2ZHcOgdmuFJb4xBGWo3Aa15snYG7dA/l2Js?=
 =?us-ascii?Q?DDVxO6GeCT6iJeAx4X1l0RvrFQpZ4LJdpwLcsZo4tLxtO/IP/AFTvTe8wtjm?=
 =?us-ascii?Q?YkWDy8Mko+B/h5/yoWWa3aGrKjSgctnWjv81db6pw3HkYFoRCuMNa79uisS2?=
 =?us-ascii?Q?SljUw0UNM4tNthQzxY6uYiPUGH8yxcyXkA9OLSv+?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4852cb9a-5b06-43f2-54c2-08dddb9eb462
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 01:54:43.6529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xPYP9uq3e/1RcKtBioHuBxDrQLPhdxflULaopx6tAcLA8iV25uAr7HXkazeAnzf6ac+lxWA6sXF6cFGWA20ASg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7974

Reduce or add spaces to clean up code style.
No functional changes here.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 lib/raid6/algos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 799e0e5eac26..92f908c9e44b 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -188,7 +188,7 @@ static inline const struct raid6_calls *raid6_choose_gen(
 				best = *algo;
 			}
 			pr_info("raid6: %-8s gen() %5ld MB/s\n", (*algo)->name,
-				(perf * HZ * (disks-2)) >>
+				(perf * HZ * (disks - 2)) >>
 				(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2));
 		}
 	}
-- 
2.34.1

