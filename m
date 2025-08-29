Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013021.outbound.protection.outlook.com [52.101.127.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDB21553A3;
	Fri, 29 Aug 2025 06:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756450731; cv=fail; b=jfXHLdOqHKLkeKx6Gj0VzjFLx1ZeySlZH1eb9NkMyAPVc2wYMKsL3a8dSJ1bLY1OVC5YwW69/rp5inU/h5oZHBYDCqOkMtG5wSNi/2Yofdv+6pxIRBtVssrmKKnqPy2cxtIzbMbxMCjzS1TgXAPD757/7m4RLGvfGGcIB6Yf1Is=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756450731; c=relaxed/simple;
	bh=S2X8XOnkbfcTllb32GaW6CKnItRnxrX5aJDLZtO3rEo=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=fgvzbE1l+oXhRWk539PT82LHabjkkmcHLP/hC84JRrKFjtIRbNcTqsRLWD7H3/lOcR1AbRuzaGDpWe/caidc2T7v7w2/JDPptrPSaesH4uY/TLtEQpDJKoZep0nPkZ4ROCL1wzqhDrFuG155yuLNcvCfTBqAgOBWKieKGcbCQLM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=hiMBnvkx; arc=fail smtp.client-ip=52.101.127.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="hiMBnvkx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wOHtg7lT5GisFSQpYRA1q0APj8ArzrXfYVqVqdSH47T0nVO2OkHD6kUn/iuOYk/nP5yLf1kjgp9seNn4iQGsU91IZQd7lXEfK2L8kkpE/FrGeBDwk8wJxNlgL2wD5BFls6YJpBPYcfZdHeXWTFaS4zusn3J22cZ3/egWI2OIHepY3Vx1gxrb2lkqeGLY9MMEWl/nJCTJHR1WJz9hw87VaIIRfnbfYj9Jq6UOJrmdtirzSPE/AQlFuE03rS/VehS5AZFyeJyooXN4ZWpMjZSrlbzQ2nczJlGS3k5ulzyuBCtq3ajQhgzeq9Q5dqF2idG9mKyTVlF+hjkw7RQo1HlYwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RwkrjQTLQqSmrKqLxB9fBI0rYuphVH1Yvb5iyXotimc=;
 b=lOPQbTOWvMtx/00s9kN5WxPdT8tHSWXwEIZkGa3bcZ/uVb6Z/jBHcK/v0WHYPYyZM6WtxfMG+T2pJDMt6hP2uF1oEZtUL2zWjQZstVimEJdRaBTnzftF45/KxeStDFRML5Nx04KgohpL98sGb7b8HUSE6nzheMfsTFr1v4jYc/79bKKvK7jmSywR/XAlYvq71mtvuqmz0RhUisZd73rdINC7gbr7aHPOre8LzNnItiNMeX4Te/hEamsqjiQ7N/Cv7mJrkpQEZ7nlnKDqNd9Y+cKWzVMB4qxXoK+BQMhMpH+jn8u8qefaXvQ1S2/p5qqIAaKUjZAgK92J4+EL6o5cVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwkrjQTLQqSmrKqLxB9fBI0rYuphVH1Yvb5iyXotimc=;
 b=hiMBnvkxAHYJD2rtP7Vspt1MZbZnTjiKhZe4S3Emi3XD17U/n6tEdCLEdslSPg8hQtkbrnlp9c6XuEqhQ1Y3JTa13fNZQ+Z7Q36dnaEEajbaxipfwMMPfzn8DwdY3N2h4pRSNeEQ3epQ7Im/7Mu7MLD83Z9bRnq426Gatd4IDGGx2ygoPFyhreec58flyHVRu+ENxkvGGH7q7HAV94CztjjIw2AYfg/DFw9VG3J2VzqVKrlJGobuNrZ5YVFAPNmhMNr1ulHFPbkZgaGF28tEY7x//crJFckvUIXrddp5dB3He8Z8QuIxC7JOJARqlfcbAqrAaTKpG1koUnP8Q+04ZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB7335.apcprd06.prod.outlook.com (2603:1096:405:a2::13)
 by TYSPR06MB7206.apcprd06.prod.outlook.com (2603:1096:405:81::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Fri, 29 Aug
 2025 06:58:45 +0000
Received: from TYZPR06MB7335.apcprd06.prod.outlook.com
 ([fe80::7b7a:484f:5ac8:29a3]) by TYZPR06MB7335.apcprd06.prod.outlook.com
 ([fe80::7b7a:484f:5ac8:29a3%4]) with mapi id 15.20.9073.017; Fri, 29 Aug 2025
 06:58:45 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH v2] md/raid0: Use str_plural() to simplify the code
Date: Fri, 29 Aug 2025 14:58:35 +0800
Message-Id: <20250829065835.531330-1-zhao.xichao@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0012.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::8) To TYZPR06MB7335.apcprd06.prod.outlook.com
 (2603:1096:405:a2::13)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB7335:EE_|TYSPR06MB7206:EE_
X-MS-Office365-Filtering-Correlation-Id: ee5d81e3-7164-4716-13cc-08dde6c97ed7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|366016|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mcBRZgeXek4R87pR2xMUJ10Nps6RvBw9loM8QzaIcQTuQf5OLyZNujR56bM+?=
 =?us-ascii?Q?VrjyAVMc9P0FVoEHGJvDUChRaYtGNV4B74qMVwJGOp0lYnrmXmNmzsofbBmI?=
 =?us-ascii?Q?GMkrRLdtkhZ15dSvxF+p+evKnhJ83jnL81LIyoNThe6W5F8NW0ajiRpqS478?=
 =?us-ascii?Q?Masi6wgUHaP339xOVdWYydTNHWZSRnlCFsWpokhhDR+rf5DX5/g/qxmfsYHZ?=
 =?us-ascii?Q?Jp00q7rm54bUpReamB7L99fdiBdgvJLfipQZOFjXh1l9UYeOsoO89jLuvLep?=
 =?us-ascii?Q?MeFrHbFmZmRWtVdcNVPl1ramUAQ7ZqJ+x9+GnYEz6QsaCfwUpa5C0UONfTxk?=
 =?us-ascii?Q?D1I6WRwQe8D+Ye5wBU9FSIzQhFe1kdN6MLC+VpiSRvSW3skDCzP08uxYPOO6?=
 =?us-ascii?Q?iVWAJGwuTW2FFxh1lRIrpY19ezUg74tcocAQPJwt3deE6jAAGDzbCYzjJjP/?=
 =?us-ascii?Q?vhlsnQhtcF7p9PhAJbRAZ6CX+ZgK9WWn+1OUbl4Ind4Tmp5iwlmImE6BdFF0?=
 =?us-ascii?Q?4aUQjmpEbzBmhDpxTiIp9yu0xpWl2b35KJQZNag3FArR3cOcU/2NAzqRHd0N?=
 =?us-ascii?Q?JCi2PFIPkdxZ7Vszt4/Mk24sXnsCfd40fR3B5KADfooSrL8z3NGjC+gPXUF6?=
 =?us-ascii?Q?YWUkmYow5ayvLJ94y5MAFkuhxv9ycXrB20exMCjAIuLmeGkD15r99Mu/Fa/F?=
 =?us-ascii?Q?TBdxgvkhJ1yd9+KY7RxwWBayW0s4c7cdwXQ2g4ZDM/PbweSnLYO8rs1VQuY1?=
 =?us-ascii?Q?HFpUvwLdBbmQULz7nG7NCewJF8y9zUkeeNE7fkFVrTvmX6Tts9g0aZ8ah5vp?=
 =?us-ascii?Q?vzh6GpqaSUIn+3SUn6f6vLZ3rMDl2yzOEs813JCrtK8geXQDAbmJgaN39IVa?=
 =?us-ascii?Q?r3dhs2hOrrobFaZ3akezFjlnOePwdbbHus2f61jCmvTW/nHdI4zVJfEWDhUI?=
 =?us-ascii?Q?n/VE4oOwGj5RU54IjG4tKd0uyFyGlYMOwIYETtS+3xw/hD4p+oCmOiDc6zpm?=
 =?us-ascii?Q?nlingvdwllmha7NEK28D4Hxl3XzNXhiYMtmPFdU4x1P/kB32yP2JaldCp63S?=
 =?us-ascii?Q?/o7ENv5o0+ZXVEvgq+KuDeycix9GrMCclVEQYEGRir8rJLibKGLvDRblMZUh?=
 =?us-ascii?Q?y+fa+Z6GFG6bovD8CXLdP6b+lzt5opAAAWU1LpAGBhscjnQz1+f5JdvZSpmI?=
 =?us-ascii?Q?2dkBVmVxTCpRwqJHBpAQkUAPFC8GW8SFWX7h4lIXGMMtjVS0iSDTSJMLwE42?=
 =?us-ascii?Q?CZjM7SZ39NFSldPq1K5rUour9IPN50EO2bRoSiaVjCcDu3hBVecWletImJxR?=
 =?us-ascii?Q?VQdvm9OZXcuJk6A9ODv5Yi86K/KwnIDg4QuEEjMwy1DksXpZjp+E92AdSG7x?=
 =?us-ascii?Q?I+ZHYPQsqEFkOsTjVfXlZ3+oV+YeKk56L4OIbE2ZiL3GDyjfy10OVV+XSjrH?=
 =?us-ascii?Q?WjLVAYNaEhP7fVo3kN7uMGO4oXvkZ9yUFLTvhUdJoZQ2X7aTMesfxyrYbo1x?=
 =?us-ascii?Q?8loV6/ONbaAkxdc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB7335.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(366016)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N+H34Er/CYGiU1Qb3Dtm4/VCeFekSJO1YEgCAp4D7dtxepk1BGdHyWM9gez9?=
 =?us-ascii?Q?67O816K+TzA7rKbRAflw3zJq5fx435b7C7AeqYrPZBvJ/Ao1EK9P1z5pak54?=
 =?us-ascii?Q?ilHyWFZ6WpijbeEofBg7cM4EzBUFCWD2dxDyX5s/3NFZySVwqTeRl8M/gO0a?=
 =?us-ascii?Q?xQ9MaPaxxVRku2hzq+dX968gNd3ZVNATU8l13HO3jt944PjJAkxViIRAZch3?=
 =?us-ascii?Q?B36qYtERcDbBUs1ID20zDtgA1XB1mZEsyAWlqBz1hBy7p2e86iwfxRgSajz/?=
 =?us-ascii?Q?3wsHhNKPSq/iRiU+/Rcalcd387HR/2DwPpUsuBB9zL+M2EoWRyKYScEaKRh9?=
 =?us-ascii?Q?g6ZH6sXCgF8xG15zEnQcNk5HL44B5H+MlBzrILB1Cf3CUN8fWnSCIHOK6DES?=
 =?us-ascii?Q?/+uKjNxyIxgJ862LzV5ZiK3S1AOBea413kp6Bz3cD8kAH9L2PFPI1A/ufqLJ?=
 =?us-ascii?Q?m4+ZzGdA3Tk5ddkKKkE3rp62cKWlgDduOpMmLcI/etCznGAn2yzn3toO3PWJ?=
 =?us-ascii?Q?n92UYfoYFJC2pUXQciqiHk8EaUwDtCUgPHYMFtuhrE2SnVq5OQxLCR9RyQcg?=
 =?us-ascii?Q?mxjhnJMITkee/rAz815072MGLDgbA6fA2TBsHRdK7Qm6UAn7EkjZ/dOeBsd5?=
 =?us-ascii?Q?MwWo6yOZari7At9wWn49klZiQkoW2Di/4yPwzc5uoDiqcLm9Zokvt1izmq+Y?=
 =?us-ascii?Q?cLEFV+garWAD02FE9MKUhgBtLbAg5PE/ua9l8Hj/mOJXnJgNKfqD+C2dGytG?=
 =?us-ascii?Q?wT/4m1ssv0wpx9GwvqxCi8fte89WrJa3xwPiRYiBn/KFOTKKmrGmZ+tus533?=
 =?us-ascii?Q?2oWpN2aPH5aMFZdz+zkfWf6E2T7AOOFrM6aepdvmLmpq+tO2kM3IXDs4kKhj?=
 =?us-ascii?Q?e94jT55lXYgWD/BhgC6mXzwEfU9edROkeuC34hM+ma3NMgxCPkYuusJQF7YF?=
 =?us-ascii?Q?lUplJkypK9kz4y1zdk8zgVO1m3Ldj+hvXE4Xu4yKt/SY0w+zY+JpBDp+129y?=
 =?us-ascii?Q?QB486gO/WDEuSDIMb7fr47RrQVyY0XCQpHOVRxCLWpzxAkP0+CVhicBdX2Ra?=
 =?us-ascii?Q?jyqWiQylLmGVA6k1aVsWZZrSfqvEflSOeVEw9mcg4ZBQKz7vfMvtzJFwzbCl?=
 =?us-ascii?Q?4u+azBeXKUqApjgL3ML4berFlfahM+ZfCi8bqEX7eYp/Y6o376WHK/tMdlGi?=
 =?us-ascii?Q?1kJAUKSEVaKkEY5caHFVD+nH/cHg6pP0hQYCL8FCTS8S9IeIHiEicO5lzUMv?=
 =?us-ascii?Q?8sdqgNdJfeOzmQ7T2hsPOF62E+xMP6K99KMNQKquQb/mJL3tI4UDsr3tqaeb?=
 =?us-ascii?Q?iKN1u1VvPufG02eKYTD9VO3vmlnX5dsYoZ3bB7AbG82Qc6sX9GwwMus/Vbxa?=
 =?us-ascii?Q?svBste4GawBV3NW5pU7iIqh+hO/2tmyldsmBQCCZFKBa7BE0vISypKUipd0r?=
 =?us-ascii?Q?Ppaa4q8g/sWfMRRJKzrC7UJwazFUdT3a3JrTyeb4yl7EnOrc4kd5U9by3g1T?=
 =?us-ascii?Q?+aAQqnH1nmxD/tQzTwDoeMRiwCC1Pi+Y/DCmUwsiAjXnGYK6tFg25TNev1br?=
 =?us-ascii?Q?mNnD5ki3uGi2QOmaQCZpecWhPRhTawRgBB9cW1Gy?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee5d81e3-7164-4716-13cc-08dde6c97ed7
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB7335.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 06:58:44.9708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g4SmQP46YImi3ZgHef5JufSzcDRWfYm0Cx4+7gs9AtqqLV99dwkQfrwoaXBkqMMol54dBkRsZw3a1JETBY23wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR06MB7206

Use the string choice helper function str_plural() to simplify the code.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
v2:
  - correct the subject of the v1 version patch.
v1: https://lore.kernel.org/all/20250828112714.633108-1-zhao.xichao@vivo.com/
---
 drivers/md/raid0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index cbe2a9054cb9..a2e59a8d441f 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -41,7 +41,7 @@ static void dump_zones(struct mddev *mddev)
 	int raid_disks = conf->strip_zone[0].nb_dev;
 	pr_debug("md: RAID0 configuration for %s - %d zone%s\n",
 		 mdname(mddev),
-		 conf->nr_strip_zones, conf->nr_strip_zones==1?"":"s");
+		 conf->nr_strip_zones, str_plural(conf->nr_strip_zones));
 	for (j = 0; j < conf->nr_strip_zones; j++) {
 		char line[200];
 		int len = 0;
-- 
2.34.1

