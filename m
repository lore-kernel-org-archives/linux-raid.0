Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012033.outbound.protection.outlook.com [52.101.126.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05EF2BCF4B;
	Fri, 15 Aug 2025 01:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755222890; cv=fail; b=EZCtrcSB8n9Si+QhR+Oy8OIyI6pyS6mnDAIkqx8IX5ZWM6pulp/ebwhKvp+9Y+d3CHkr1wT1IB9mpSlxiUU1PXBliRXd9b0naYZj2TB4XAACXqibRyn3JLUPsQMgHvQDwHDPN4RhIi93Rt4lWDj1viJvGX9MtGLMsRWir7c6lYU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755222890; c=relaxed/simple;
	bh=EBTl8UMMiIhigi5L1TWUeuI/MQPnWlxn2cUXVbfx1hs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M94uW73KMPuUk4Zp9sbZ7XnOZyPg8SuVHZyWygqIKP8wSdooseQkoyovUGHQmDea61VEoBSGZ+hITC8Of+UvMPYQmCUlMboDyJhgMLEUjq7COlQEVu3C2ALVeuciSsHrfYFQrrs+48pmGDBH7C0fP+B541TvNzKUCWt5L9OpqC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=Yu1g4+TN; arc=fail smtp.client-ip=52.101.126.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="Yu1g4+TN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JQS3pG0VIE/I8SeikISCNZn2WnQSpCaDBehwtxVXdE2ghFsdH9T+44XmVJZuSbVXs88dETos/BnbN7UjQz/cK5Evmi8z/dSLyci5sZSdgqBqAaxmQknn98yFM/l5uPstHlOZTuGJPQMnFiLriM8OD8dCBpO32WykFcKnzYvJ6hbjvezmotKlwZcF1lu1/Ig65UGqZFQtZE5DmkVFBQDPfb91pNdi+h2+pXm2kVcUjFWidyKySXoRlXhJuAZV7aN8IrM3uJoLpkWJPPK1pbaLQgfnsq3wt/uweF5JeOgT+WJcxUcydWVAhvcaqS1aeZ/4AZD8zYFoTeYBckQVyRYRag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KK8nA4r4rSXAuPXkCK6RtG3/CM7ynfRMnTqlnR3uA8o=;
 b=yUhQu7nn3eXKNr6C/rpU1qDE++DiT9ll0pts/3qU+i/UrvPzQA04xpO78XXa6Gn8W5ZhtbxjR8xya943pH/imFtXG911oPiJM3qDgTsoDMIUYmyVrGzhlZHAkWaHERtYmOsAAnWUVO30T+Pcku4AqMlCBSSwmEGbUVqegYU6HOfRtcGxHVkbVhDbVFo/bs/2X8QjF5QDBuHzQk2m8PqhBa6UIxSIxjUz2ve2CwRLjIghMkzi22tmLNUmcUaWH/CnFf1Yr4w4wCDRpMlduPU+6aJcaI9Xy1lMuX5viEIfe1eQrOTcE5HSYrPPe7HUMTeSjbeCiUpDuCd/rP+gI8x9Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KK8nA4r4rSXAuPXkCK6RtG3/CM7ynfRMnTqlnR3uA8o=;
 b=Yu1g4+TNYzsawiWiIMmv6mdscs0ItBgfL1ZS4dBgO6saqnLgNY/ttQXMNS5QjOUNUun7bqdcmmaNe1BFJIUDUDVnaES3JcvltC84wxh4wEdfpMKfI/HeUZr07zzefq0ZrEljcmPi+JnMUMWM6ws8EtSw5W8+gyabBAurBLbanL3Zyg7wr/oZKsdwvnSWy/tC3vVsoQqCqZYL75VSFJI4BmJhXsZRCYOD2GeYSUJK+QRwHVNNfervNRIRvFRtgk4/HBGikpZwPC4gGLmV8O+OdAmNYQJ5+1eYJ26Eea5biqcLFShOFkYrk4PTYHuSgZQGcSGk42k4yfuMOSBl1PI+cQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by OSQPR06MB7974.apcprd06.prod.outlook.com (2603:1096:604:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 01:54:36 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 01:54:36 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH v1 06/13] lib/raid6: Clean up code style in recov_avx512.c
Date: Fri, 15 Aug 2025 09:53:55 +0800
Message-Id: <20250815015404.468511-7-zhao.xichao@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 188b8afa-e6a1-48cc-da3a-08dddb9eb03e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fmkMopV1r1mapfLioBEcGewYppV0UTR5SQQafDUDLtt0FoSJDi3NQfaS58Pm?=
 =?us-ascii?Q?DMVIUzoyUu4NqkX6/OAIoRCDsQluLYbjHOcdoJrnUDwTLcLq/gdjroF3E7F9?=
 =?us-ascii?Q?YOUfB7o9e5iur1ID3ToSJ2zWvWGulDOZlt+BqLy4stiId/dfvt/PPIpcZf7I?=
 =?us-ascii?Q?qYzc6rh+iJO4sTWnpv1UTvqU/AhBZ11cB+PSFVNyvghVXH6YfmEaOz7DWfXO?=
 =?us-ascii?Q?Ixn87kQ9Oz7DkIHkbcmT97mhwTrnVoxxAPXPHQHXqgRvJEWGY/cSZRSbDaZG?=
 =?us-ascii?Q?7DGENBzqEPApNbMqKzE0iJuqNPFgO6btmYDsFqAQpAEqUNBJzWt6GVCV2chx?=
 =?us-ascii?Q?M/hG2Mq7MTJ0ltJGvdqhqTUZuLHOehGe/l2lbPu72Stm98R3huUKoVjuDwZU?=
 =?us-ascii?Q?LGtRMfwLAH6KJ88KjQL7UbwzLug9yGgu7RTSIhMhUOskID2lqRIOHeh3ndtH?=
 =?us-ascii?Q?R8cO4YqLNaI6l30cgk0w8oN/l6oqNoEHKgGyft3lGjhTS3gmQ6gPmSCjnX8M?=
 =?us-ascii?Q?T1kD7YsaDwFsBHt4PEfd2SKnv6g9QLzf1REYAcwYZWvzOYlN0jwl9KotYtFH?=
 =?us-ascii?Q?mSkXEKI1zHStyPN2TTB7o/PlZ6dKPOOMo1tYqAnM7SX4bcTwhHyuOT6BS1Sx?=
 =?us-ascii?Q?Qn8c+2ZiRubGlZ3u0shGlvVRK9RCTz6jOx+Phu0wvFVzkMhx8Z6GjCAKWkXZ?=
 =?us-ascii?Q?1nKEjcAB5IjeL3W9kQnuNQQhXtPbJGPbDCwKaJMTERyHBeXiegV31xE5Uf4P?=
 =?us-ascii?Q?5XrnOHXAsz4Q8iz1iryNcpEgV7O0lvSaKzObh6Ak0cKaKsCq4YeZIOZBmMGr?=
 =?us-ascii?Q?d7jowR7YCrBtUisH45lvXTGs/Hfwy/AbvDrQe/yhtKtw3ifxF+/Ark0wpCpp?=
 =?us-ascii?Q?5/X62L/GE7iJcfRubnSJu64OZsvDjEfjVOoRWNzioAWzWvq0Do6o6iq8Uhtl?=
 =?us-ascii?Q?dSafi+5pIaq8kR7qVm2Y4vrMsgbNhO5luUATTZRdzrFa6IFwAsb1y8zL1iAf?=
 =?us-ascii?Q?T+KCxskSaWAE2Az8u+s2jW4i1jaXVKQN3/WZE90WCLS0MVsuwonORTOUkqRF?=
 =?us-ascii?Q?bITTzPgoKUfbFtJ22pBiggVMTRQqD4SVe5kizVMLW7rVRUZ0/RzV5AFfU52D?=
 =?us-ascii?Q?n8WwKD5Ttb1BMyzGv0NL8brbncli4SxNJAZiZFrqmciu+bhTWdt2Ph67dnyS?=
 =?us-ascii?Q?vXkYnkhauya+GpIvAr0LqPbUef3nCb0BeoCCiebrz3zRF8Sy+OSWHvHuwtq+?=
 =?us-ascii?Q?Lqmpagn4XCUSVeHuDi9DXsU7GGpY1gGf8KXnofPErR58+4RLG1pIudiThoJj?=
 =?us-ascii?Q?NcxMCHWzYhFpzjmdqLOXAhWUaLTWRSpZaKW1c+/8dUOFmgFu7EIEixcTbrqd?=
 =?us-ascii?Q?j7MiocSW8pCdhrlR0Ycks/TznJuEOOnjLMV2OpotFr1ySqqlyhQsA/di+ge1?=
 =?us-ascii?Q?S3YwumOHRW0Sl9vGWRfmKqxXSHHwwrjgFtO83Co7IYh6NVkxjapMZA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mw8Hnb80w+30zf7i4KP+vzRVppyN0TqMuyzYjf2ldRVzA9q2EIJtcABjujXQ?=
 =?us-ascii?Q?Mof2JPaSxliW5nysvlp4c/eMJZMkoIDOVLgYbqtNdGBVOS+MW/f0eI+CtFqs?=
 =?us-ascii?Q?m6Nrk7Z0L75nKVNxGckZ0zaZ9I2UYBHKmYJJl4fQiU1x3Z2hshxQxYsPQLTU?=
 =?us-ascii?Q?t1c4tNYhNaccjg7jqahUqnitntNdU4asr+jP9Ms9ftqs3gHXLS3PzBzETybv?=
 =?us-ascii?Q?BCa03xzB48OCop5UbAYIb/2XipJLGLsnm5wiMSANNXU2VNPJXIBTZda3kfob?=
 =?us-ascii?Q?EjwbiNDKtoS1dDhWa2vjixqy8otW5ZHtzKjHEpYoxpqp5ZgdyW59moCFbeN+?=
 =?us-ascii?Q?7weTLQszDJ0Jg8TTJFdlUdQOTqFKxuLk1qPrwMhMyfsJTOF7FlOwK2RHIPzX?=
 =?us-ascii?Q?q3UERu2n6n2ZhH91z2MAJxbJhu7SUZLDjPnAixemRlWqCm3DrOZo66GXzEtd?=
 =?us-ascii?Q?EahqCrFtPhe8FllnB2x+apA97ZNxLrnz/kZn92mipbpRgkQELO5fx5Ebod1p?=
 =?us-ascii?Q?fLmEXpcGrce5SI15qpqYEdPXE1S9SHP98d+sYoAn6rjsbda2oZ1LfquGFrtR?=
 =?us-ascii?Q?3OICLW5L3++OuELxybAoq8BzMPxNEOvyB0wTmS13itRw0GI/mV56EVdXSeVl?=
 =?us-ascii?Q?BxUbZMgASZJsO/8NR7lgEpsZ8BklwUoVhGbmcuhgozoMfZyJHaxps4IGMBPI?=
 =?us-ascii?Q?C5pQEY9nXIF4WFHTtL1dgqtCSwSPEOuNaIid/Jds1shiTJI8xO4tQc9SnHKE?=
 =?us-ascii?Q?YOadCcC8BJwFqHyeyc7NMbIxuOZeU55Rn83umoieyeHLFe6NS+RZ7mrxxfEp?=
 =?us-ascii?Q?opKobqoqMIfhbzQDMrXVcZeqR8FA6Ry7s7fWvxka6FTkWCPG+X4wjqhp9p8N?=
 =?us-ascii?Q?QT9xbNxSvGhdX54CNG+W6hL8uTcPQdExkCqa5MMackRKbmYY1mv/CUvOF0Pa?=
 =?us-ascii?Q?FObOx3OeUufU/JHdKH2g6f1Khp8hLcwaeGI686ikGylFBT/85hK5VvVAFMLh?=
 =?us-ascii?Q?ROw0bSGMqAjLmrhFGaVeIeT/MNmKrnWnEBO7UlrNmAV8WCKTTp9CIIJlaM51?=
 =?us-ascii?Q?5P14b8ImXfm7t+NEzlUmb4sfAYzw4eNreyEYGORcUtsdF3wbP5pmIGHTvH75?=
 =?us-ascii?Q?cdxPDN2iJYfbkm6ACbqCty9zvUU7eYa3yvLTmk60x03AjLU7bZxUZdd6dgSq?=
 =?us-ascii?Q?O7V01AO/e16Cw1GdGnwB6maJ+qjl0bVm/LgcDAPWR5CHRgKKk+DKuPlmCX/Z?=
 =?us-ascii?Q?GV7sboBW5Ftlz/Wq209hfRDaucQPHyBEBDHknJuKe3zd1DSw14S7nMvJJSk/?=
 =?us-ascii?Q?ruij+qRBMFKl2Fuzy/xelRz5ySUgXOZF+FUeXGgAw0cHMh3W2rnflSPcQpno?=
 =?us-ascii?Q?uZltnwIT51OsdBPOMrV7dnGrMOCKGJgf4ZIFspOu0dIzHD4WhKUlwdBgr7OX?=
 =?us-ascii?Q?H4OHj2/X7JuR756IBmA5mLUCTQR//iqfVvSC+AHt7+X5BggkX1DvHE0UR86B?=
 =?us-ascii?Q?NUrcWWgWX8HlbvaQE0CAdwRYNJ+U61Slgg0jNLFuRP9YWW1XVMHmweprXVhH?=
 =?us-ascii?Q?HV6k0c0YisbHK9rSFrv/4nX00ic8z/63eUozsFbk?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 188b8afa-e6a1-48cc-da3a-08dddb9eb03e
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 01:54:36.6241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e1mTRf3PnTL+1cH2lJHB3Y3elxuw6ZnfAPfFdmaApxxHP2UKaV/nR6u7TpAoeRvMTVWShgBtXwSab93xtqn9JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7974

Reduce or add spaces to clean up code style.
No functional changes here.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 lib/raid6/recov_avx512.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/lib/raid6/recov_avx512.c b/lib/raid6/recov_avx512.c
index 7986120ca444..00ad10a930c3 100644
--- a/lib/raid6/recov_avx512.c
+++ b/lib/raid6/recov_avx512.c
@@ -27,8 +27,8 @@ static void raid6_2data_recov_avx512(int disks, size_t bytes, int faila,
 	const u8 *qmul;		/* Q multiplier table (for both) */
 	const u8 x0f = 0x0f;
 
-	p = (u8 *)ptrs[disks-2];
-	q = (u8 *)ptrs[disks-1];
+	p = (u8 *)ptrs[disks - 2];
+	q = (u8 *)ptrs[disks - 1];
 
 	/*
 	 * Compute syndrome with zero for the missing data pages
@@ -38,18 +38,18 @@ static void raid6_2data_recov_avx512(int disks, size_t bytes, int faila,
 
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
@@ -229,8 +229,8 @@ static void raid6_datap_recov_avx512(int disks, size_t bytes, int faila,
 	const u8 *qmul;		/* Q multiplier table */
 	const u8 x0f = 0x0f;
 
-	p = (u8 *)ptrs[disks-2];
-	q = (u8 *)ptrs[disks-1];
+	p = (u8 *)ptrs[disks - 2];
+	q = (u8 *)ptrs[disks - 1];
 
 	/*
 	 * Compute syndrome with zero for the missing data page
@@ -239,13 +239,13 @@ static void raid6_datap_recov_avx512(int disks, size_t bytes, int faila,
 
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

