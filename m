Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013015.outbound.protection.outlook.com [40.107.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCBA29E0E5;
	Fri, 15 Aug 2025 01:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755222888; cv=fail; b=Zpx7wG4Hr9itXRyqygms+tMkzYXAL9pVRsAYAXyJiEYzDoIXCebmLkAHjpcPsc9vnBHGxKMEJoN5uxnjjJxxMMBlNVnwmX6dP9hYSXOiU9qrHTLwMLeOoeHwrZDzqdJftAsooE05Bi3d7BiJJJ/SE/oOgFhlIY4MOypUBKL2E7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755222888; c=relaxed/simple;
	bh=450X77CrC8niC/wdOTcLqFAmCXB97HBFiFlzaM4d+7Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I1wF+YHxFuRNqLt8D+74nD5DOSo+WrDiu2+twGudcgCo8+S8szUvo1TqsrdfNxzwRhD18HXgQCoyWUC8rafs8ehIXsxVSGJuu8nVe4Q+Au/vQm7cKJmLM0Ags0Z3sjL+BM/r2W/ViLI8XtmUU/Km4Yx9jGu/RctCEOAUPFlPNTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=Z12DfRib; arc=fail smtp.client-ip=40.107.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="Z12DfRib"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CwlquBpUfayuOjHozdUGSPGrOxOwywSEh+MWD90oCq0UUVtdqIGXe1TT71HgMrpih5guwAnu7JFroeRfHwHKimqJXHrlhrMaD3zLCztnCXaVFfJlppIJD7C6738WrTSH5LII8RiXD9sq/cHuV2jnN+k/X7QlzHyfqzKbqnXZ8jDt1L6Pv0ZkQUxM/6123x2CfXUmLATYlgvQAPSKQWYXAZstsEQd2hKl93XPg6gGajpG8eo8M6QfXT5ki96cyUHlWxaq0VGYcrfEt67JRCMAcXZFgZEYjgdpZIKNlDNfYwQtvn71UlHZfIHEzDlH5Cqxq8tjhieXCxXmycv2Dz7OHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FTpho3Tb+6a69yJPazoPIqJQ4UD2kl4DHXXZ3XoRW7w=;
 b=sq/AxIZUTawHse7LfwN7ep80d+r/x/dNeceD/g/yosgFly2kvIeBNDlIYV2wZc9F99cKDXSURng8H2mKG8YaREI8p8WXCEcbP//jL7OgjeJCcsAP5ZiUAqFpxOWH+awmOMSPU6WKIQP+nCwipspt7L+zQIxdTz/U37vsg38UIhyR7hbj2jb86YySVdfb3OlmGVUPYFVhRER9/xlAFa8Ta5BvilVHhzSFCxzVeEJEi30xjrMIPJNe2bFywF+VyHyp4wX7lWcHbpt1OXwQZ5jNMcSsIhqvlM7mNWnERt0kxlqEALUrM6GNR2fjdURLCbaG7myZFag6gyd8/fwkcOh1Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTpho3Tb+6a69yJPazoPIqJQ4UD2kl4DHXXZ3XoRW7w=;
 b=Z12DfRibS6XbPNdLE+NAbiJ+aPYtTCiZJeRwmSi9h7L9q+mnfZcARguT8WlCtzxokIXSq65FZ8mRETVw3MemCGUoNeCFMwCKJm3Zox+2Eejz0Z5s76+D/FBq8ydXI3wzX/IGYgggOqEtzrCmBQfN+9gg7f01OFERqBrhg1fC6P2m3Hnowjt4Oy9CXkDhIa69YgIiCCrSLZtUgcjkYYgbUDXBhDX3RghU9WPacXdv8BmcgbRDoX/m1PAMeihOW18EtEdas4lhDKNVXZ9EDrTzBTv9hpv0s0GzC078LPsls+tfrUfAmtLxa55yK+H1Ylzb5UzzOUZB+/zCDjJm16+9Cw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by OSQPR06MB7974.apcprd06.prod.outlook.com (2603:1096:604:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 01:54:34 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 01:54:34 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH v1 04/13] lib/raid6: Clean up code style in recov_ssse3.c
Date: Fri, 15 Aug 2025 09:53:53 +0800
Message-Id: <20250815015404.468511-5-zhao.xichao@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: fed34a51-8da6-494a-78fa-08dddb9eaee9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zhH7v55aVirh6RIpfW2ZmqRzkpfx0mjKvcfZI+WVuVltZBQYY4IR3V8ds7cp?=
 =?us-ascii?Q?DM1J/93eg9AT4wGfsgAigpbISjM/FhptFTy2c3mrwWrOvUm+3JObiQ32O9TP?=
 =?us-ascii?Q?EI3yPRSaHTTpy9mYiCUnQDzmKxnK9HacnwFSh8rm7Scdi8tc0ZbCUk/ccIaq?=
 =?us-ascii?Q?/frqkdY6rakOCyfblvV7UgQgxiqxRXR0bkJ4L6Cmji74QJPOykUvPZbz43cg?=
 =?us-ascii?Q?YYnu1zXYxVSgIxhhERxacswzdC6VbdO/x9lV6E+OvsEQGwbQYu2DorbhIVPD?=
 =?us-ascii?Q?63dBIN85hhZXkGqkEgqg2zukXZ+sSPlLXjdJTS4iaAMgV5GZI+3rhzWhNrhz?=
 =?us-ascii?Q?fCxcq4y+Hfsp7Y+Q2X2kdb1XGWoNRd3yYda86k/JZ7FVyNPpnz+CviM7qJpQ?=
 =?us-ascii?Q?gHSHNiwGs8JR9lL/BKdD1rkWfqfqGMAkdTPJZX7ki+T3AsD3kGXWcjrzaEBH?=
 =?us-ascii?Q?eaav0WlOVSR5P/nEapkxgSY/X4tTCuWN5Nt/BB8ZDIvSfQgoCtQgwOmbfKHB?=
 =?us-ascii?Q?PRTwkMLdVT5+AYdE10evoXnB8i5LhtMD8kFICkV6EhNG1MR8aXoc21ZbtzML?=
 =?us-ascii?Q?C6wSbgAX+pbyYjnHJjE7CdNS+sUspJMFBIx4ajOVmMGSdD8jQyrcEnnGn2h5?=
 =?us-ascii?Q?hkmdH95ep0qDAkVSfw7ILO8p17yCDx+xkdW05txGgV8pt9P5xgea+a66sjQf?=
 =?us-ascii?Q?dixgM1bRSphzS1pTj9Fcinu0quCG5m3rc9FJtLm+P9jQWZo5Pv9a5Dk+IV8y?=
 =?us-ascii?Q?OK+R01YzSVmi2MqoGisOf+Ird0zmoTgwJNiXcDXGS2vvcGeEMgyEhm3CdZc0?=
 =?us-ascii?Q?a6brAfU0oLD4DJ119Hr0OQuDNRPspBXlt1SN0lFOsSJ9LNSie6jXF/27LaEf?=
 =?us-ascii?Q?nJN98jON4SnuRdR96m6uN7GY7Be30G0EWmngedj0mC56d65jRxflG14uthX0?=
 =?us-ascii?Q?7z4f8KtbVEp7w3YWhK+VwAfzxq78iuYaQg8l83TQpERVLtcpBJV27tj3mBvU?=
 =?us-ascii?Q?UyJx+xpmLgyALGK1l5ewYPYjuNsrWx/OHvcoh8xNbAoD9zP5/my2gdZYWXjz?=
 =?us-ascii?Q?OnUVJ/outuW9Y48fTLWqayo+Bg/aA/Iwfxd2JD7u+6zNWfFUVMllbUgmVfuC?=
 =?us-ascii?Q?d5U49o0ilv9OPuraIJEkb18iL0MWrEaAijLUcyvoLoFO4Lq5JUWNnzNgHxYc?=
 =?us-ascii?Q?L8uqIdTHolC0dAlzkvxeNiBzrs7oN/NnDtzrDHia6YpdFlEV6PzIQ1AMNb7V?=
 =?us-ascii?Q?HULke+5LvVTUlIhJ1+ldW8N/iqs76P0ZVg3hhtRl0KUZQza7rAnHielKwY2+?=
 =?us-ascii?Q?XLk9BeUL/5rwGtzPjq1gZ51sOpNF8sClNbCpQ9A82NwKXXLepUjN85bZZX4V?=
 =?us-ascii?Q?MT6ZyAD0pVxJc+Ni4eIXEyZwnQRJKsZvv/+F7vkjNd7UmnrIb8iDm5qoeLTP?=
 =?us-ascii?Q?sRdgeqgod7GHFtqv906Zok0nNorcj71/FbHh2URvnfqmhQq0AZYNmg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l7QTrn4d/K7EQZWmMs983sv0X/ccVn9445CJPzQiaAWZW+mBWgAhe6tkTpd4?=
 =?us-ascii?Q?oQcFQgZQhD0Jnie8yQXhT810lI3np9EiJVsrhgdccqFxODJaS+NoeuGGe5j+?=
 =?us-ascii?Q?pt/40udMEBIbIntDtBkMmLbMRTZuVNwdFTbQrOTdjNY++Qwnk41bfClykmEo?=
 =?us-ascii?Q?B3sA0itfFAfxAzmsCLG6b/sUXG0Z6MY/fOOFvnvRd2TjSFdEgQmgnY9k+OiS?=
 =?us-ascii?Q?PHWcycz3Bjv+p7+6kRcLrwCBfP5C/OusBvCrnGwRo0iMKO1Z0mmUtLM+b0q/?=
 =?us-ascii?Q?Er4u2DQeDj167zmEa+OcNbu/bYWOu+MeTDqifox0C0ptf1BxIrmIpOp1ZiNF?=
 =?us-ascii?Q?RaBvKpkSIDWYUG6QPalIURCeuMUglr2fCIOoHrq1cByNSiUfMRR0C18PXMno?=
 =?us-ascii?Q?jL5VNP9JjEYDgslJPFlu5uuK/LLCN1u4+i1qY6ii2ocDcdikQM0A4NgXJR7N?=
 =?us-ascii?Q?4l/kxtkXcwPaJYzUzbgOAOuZPGx92k9qEuT2z/La1o7KAYGJ1JcFavw9HsfL?=
 =?us-ascii?Q?TkrRshQv2zOLkkLUdpO0JYxaz5qb+gOAGSnqLRrP6c6cgc0CKnl3eQYFzT1x?=
 =?us-ascii?Q?rwKiA7k//jWLcPyVhIHOx2OlIXaH+xi34T0YoiwZHe4hU9+wWtkgq6SmxQCo?=
 =?us-ascii?Q?XkuBY35NuqRlrl2j7FUUUkdw59sEfFDXS+GBh0i5LWN0C3D6LGXp2tPFJmgI?=
 =?us-ascii?Q?pSE5nyfTLBTXaCcjHe2KyP9AbJ4rcdEn3xozK5/gt+nfpy+WqysRU/TZSl45?=
 =?us-ascii?Q?0MzeMENJRxOmwAi5YJv3zBPq0tPj/QVjQe0BSS9EH4OCFekuVziURgohqjcY?=
 =?us-ascii?Q?tZS71xtolfRQ+/9Nv24pEuqqSs/IvjPk71W5Ldy7+bLLWoBWu7hjh+YXe6pk?=
 =?us-ascii?Q?+VeUZ4mXfrJCMLSfRz/8wJ0XzwNh9hH3cEYCEOBAUc3pvYKUuhk4bNAZ40PC?=
 =?us-ascii?Q?t3nfLqUsHqiNIWmJdWnNdlxktuN6H7eaeoIb3tul4vg8efPWTH4WwZTaC1wv?=
 =?us-ascii?Q?zG2KcVg3BtiQhwi0IG+hesNP/ilGiz9YtLntLM42uVg0kqN9A2wJyeCJHq1+?=
 =?us-ascii?Q?enwxdfF2T6xbLkhQckQhVs0LD9aSrsYlDccZhcnrp0MXqTcBQ9dHthVKElzO?=
 =?us-ascii?Q?xhYgayJTiOw2HzvG0gdDCVibcGsOLW+b70rvc20xzXVMCUA+lxVWZBsA2Q/l?=
 =?us-ascii?Q?/aT1CMtILTk17lVhTH3+OAEvJdvFnz1YNAccC2RvJsdMUWtD0aUvVH5PNJ84?=
 =?us-ascii?Q?qnDTG560Gm84gZbmlMbOr66vaBnm56j/RH8Wg9+XMVZlY367FfVToHoLwFSV?=
 =?us-ascii?Q?6Af8OMCAwyzH5kz1Qu+EsZf2cSnNdGUDDmoL20vsXE4bcJkrkOsODXSt4pnD?=
 =?us-ascii?Q?UKA6ELU+CuemyLS8y1p6iO1HE0QhLSdY9hkOVq4/SSBkyL+mIZRg259NrV13?=
 =?us-ascii?Q?bMJ0LaQUEc3av1ktW76goF8YTAQ2liT1z6J5GpqqzVxOmC1ZhDBe4R4ozQHu?=
 =?us-ascii?Q?JGm1pMWXlE5lR1t9jWEAqgpYGB1KDL1gA+a01ngWsHQwpRBRIAH5rithlSec?=
 =?us-ascii?Q?SsFSH3bNi6ijectuXST8c8/I1g4NnHBCZKOifv7C?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fed34a51-8da6-494a-78fa-08dddb9eaee9
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 01:54:34.4018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AmDIhcstPHbMwiD0NCgzQEEFvtvHFxcseghAKHVx7V1IyhCwIgvYQ1nUxG4rotq5ggO+CBuuVCmOWlbwH1Qheg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7974

Reduce or add spaces to clean up code style.
Clean up comment style.
No functional changes here.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 lib/raid6/recov_ssse3.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/lib/raid6/recov_ssse3.c b/lib/raid6/recov_ssse3.c
index 2e849185c32b..2e9f372f8b43 100644
--- a/lib/raid6/recov_ssse3.c
+++ b/lib/raid6/recov_ssse3.c
@@ -23,26 +23,28 @@ static void raid6_2data_recov_ssse3(int disks, size_t bytes, int faila,
 		 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f,
 		 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f};
 
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
 	pbmul = raid6_vgfmul[raid6_gfexi[failb-faila]];
@@ -197,20 +199,22 @@ static void raid6_datap_recov_ssse3(int disks, size_t bytes, int faila,
 		 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f,
 		 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f};
 
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

