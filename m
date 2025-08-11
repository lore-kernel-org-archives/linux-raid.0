Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013038.outbound.protection.outlook.com [52.101.127.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614E62D3EDF;
	Mon, 11 Aug 2025 12:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754915823; cv=fail; b=smDZw4mQh3tw5ryLeH9GOu//LZDcf2w/Mvmz9v78WcpATcta0ViBsln0+49qxBdCKYJJVe0dtqnA0nhw/U0qVjLNxwZv/MB5Ovxl1s84sFGBNxuc7lf7eQG+r5VU0kJ1j7y8+OXAfGaDrGaXuRK2ibzViy4FpIv6cJwJv90z0gI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754915823; c=relaxed/simple;
	bh=AEPuq3+yRuUA1Fm8FsX4EM8o9gLuw906FPPMKmROiYM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GwApktCo7J9kLVa2SKgiLbxzjP9G0tqdp+RYyvRnSsErE3kR5MRwBVIb+YTPjiboZFtkpyZtQan8Ul5YUi+jDxkaO+U+OzOwcD+QHtaQXL7O17H/9pGK9zeuxkLJUvvAo5dWekVTE6hr//QVjmVuMVncDFNqW+7Hsxm1xw9+Og8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=D4iqIkn4; arc=fail smtp.client-ip=52.101.127.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="D4iqIkn4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JOD+3g8KTxsfQslWAl4yHByGFB/SsYy5tRGyxP87DK5o9m2XpjgTMZIJ/I75igM6z2J4coUS2iEYRrPtYvvwh2YyS/QHdrM4j51GI4rRE28dQiU0C6aCr/kYwKqMwNKKLdG5EtoA4yx5wkkvmeXIkj3jdqmigtgW0+Ehs5N8tL+biIbTyEYURi3EDaN7QC6GqHvZJVfndovhzlziTFKD5qBnaE/Z90XPC2w74d4j6tbPZ08hhOp8d8hxkmBlB2FeO89nRZL5WeyWe7IkY3Z/B39TU1ISqKvhl5kwD0tOfiLp0bPw1+ln/pweWQdutmnujYF3uDYMcvE+V0PdPb/MBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QFJwzLkkNIeU4nDTVmBoYBM5jZCuSVgyMtUyfOPIMmc=;
 b=Z4q3K4+K3cWVyTwONCgfDjk0qHo1May7qYKOkZj/sxeLhruczxQM3s9vJrHGnRY2FpCU5sjVJ9pFm3R9U7/rsyomnP/FzfRA+bySa8k/D4qMtvh5CB0xjY09fyL432+0lfGLEW6UJHMb8D6mzxKJ6oe2+xNGpUh/hzlE6V69Ur/ArVFnwr8U1W/A61AxqvvwtZe0dgK3eoBan51NXOJqpXT83Q4RHZlvMhA43uAhVK/c5Sw5De/6fmoACxmcctQEGg80Wv1ocyvd3n7I5oWRDU+ZqNKkuRE0UuiWUuWq4RmJ5dgiFiVB52fzpbgjTyOxCfKxsI8iFq476AGxmWRhvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFJwzLkkNIeU4nDTVmBoYBM5jZCuSVgyMtUyfOPIMmc=;
 b=D4iqIkn4puklnx1YRwoGAhCroBThNHUKAxIUw/nEz3xbCutc6EDvdg1m3kl0w+GADIdmNJEMMliLRlEfwAFfEVYVE/c8zv4FeEhd9SIGvhIDJCNsUvz7Bb4aUvjG/ecwLQeJGM8asExNdXuXWA/1CWlN2eDGxzOSN4oaUjKgG3MepJWPFHe7PwNlHe/uw1nG/LBkvkfIk7M/m8FxEZLJ0KRw0tu/DzhzI3h6tH3DpsdmP6or/j9s7Be7wpSpJVFOE8zrvkKL5ln2muI9oAwr82W4JSJ+eXliIquCDuOkHCIwZuBChBmBgFZSqvX+QWoVzh52xO8p7LcP/hBTC2lrKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 PS1PPFA1B399C66.apcprd06.prod.outlook.com (2603:1096:308::25f) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.21; Mon, 11 Aug 2025 12:36:57 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 12:36:57 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH 3/3] md/raid5: remove redundant __GFP_NOWARN
Date: Mon, 11 Aug 2025 20:36:37 +0800
Message-Id: <20250811123638.550822-4-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811123638.550822-1-rongqianfeng@vivo.com>
References: <20250811123638.550822-1-rongqianfeng@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0033.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::21) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|PS1PPFA1B399C66:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e759f82-b504-4cb2-b393-08ddd8d3c2ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ihdNWhMPJidTYH8iy3X94ec4EhV1JQeDWSZAzs7bALdxXA95IpfqQlc3zqZV?=
 =?us-ascii?Q?s4ZohE1t4aBbYvr0VbMZpuvMBdVqMtG5IBwTsyGWHRYg3f+1+nWORmdq7XgB?=
 =?us-ascii?Q?wWDAcOWTxzDCVDR9FcRoovzMrw4za4RQvSFD0JNThaHZI1AMdNapFBrGJbMW?=
 =?us-ascii?Q?TbC891KW2GLHBO1F+FlXkqyzxbU0wx6tG9wxBFXy5WBAJtB9+6mF1EoE6xXe?=
 =?us-ascii?Q?uieMTFHaslfrWJ6sAS2BnjZLEZyGQrUkcfhSfBpJtOPa9xsuPIro1xSWRfI2?=
 =?us-ascii?Q?/TExQC4VUNyN3cLecq/INtma0UUcIp/FjMuYQtQM31F6HyatVC4T445UUTWM?=
 =?us-ascii?Q?4mQoSBcKsIscvgYIaYx9DYTDlesSe0cBX7P9vn7OSYZBXaRB3qAR3QVoBq+L?=
 =?us-ascii?Q?TDWe6AlSeWRiyfQnMjsVbwSBgthRH4Bxf/yuDM8UBHmZXVp0NATq6yM2q0JG?=
 =?us-ascii?Q?F/F6gYDfTKCqeN19Lpl/Hteiy5S6wmsAJHFMK3XtlyxEsQg3dOZHGUnku41p?=
 =?us-ascii?Q?AHX9Vps9zsIPRJ0bM8+o8yCHfuJ0BaI7Te43x6zMNR+eVx9k6HJJLtRTxqns?=
 =?us-ascii?Q?nFWSUUGQ1K+jY0Tx+b5bGbS3CAXWsX95aVcQ10113wX0MUygg2aLMATTLyJM?=
 =?us-ascii?Q?6p6Ri77Zhp/WlKMlSM3rMM7rANHJQFB+xj85ml8PdZB8FOSvPNYHGXAZHqZi?=
 =?us-ascii?Q?tO0sLVAhCNa0eszLVt+kcOvPZlZi1e+WPvAsF6JrvAKQCo+lDonn06Xvic9v?=
 =?us-ascii?Q?qLDKTGiHtLdsbGfjLUAuTXjNAjGWAmfBGGMU9Rr06JMxfBzOSHBKW4VoJA9g?=
 =?us-ascii?Q?d2BVAqOlDY6AHnCCpdUe6LjSQyU4wWR3WCcpy9gSFDmUkUpq88xO9KS9F0gJ?=
 =?us-ascii?Q?g/qdXAzStbXfyLsM3VvBVvpHXe5VpzXSvf7sbOqDwSn2bqaNXUFRGU2gkp1i?=
 =?us-ascii?Q?BEIi8Lb5+tXXrqayL47tREBeNXqA924I5CxGV6AWHCbIdNeR5NBiCjCfu+ZR?=
 =?us-ascii?Q?CeFkmnZgyaPGEXkH7j75J8mz15gNoT56NxJDZcJCXC5GtI/LpL3HXXG81Nhv?=
 =?us-ascii?Q?/OGE/6OBM2sG4E2gIaaITnioz5I+ma2sc6NgnX6NhsmdGTI3j2Vc+t/6qifB?=
 =?us-ascii?Q?FRLCX1k3JaecwP5maVVcXGKF1NdPVZi5wah6G7DDWMN8gUkX7wi2kF/OMtsu?=
 =?us-ascii?Q?UkotM/7XLVmm594Mjnuq7nEg+22A0UPeyjJuV1KEzWlA/6TrYQD52tyUjogQ?=
 =?us-ascii?Q?HI/KquCH580Be7aCErnb5EGKRPpTJFqcjF+RwByUH3UNHKbkQ3/ePGvIniNP?=
 =?us-ascii?Q?CW7Jp4nlAlXJd2jBdIAkg2MGjrA+Wdd0qPs+/gxQokYfB//pPdQNo3XI7ZCb?=
 =?us-ascii?Q?FTWzFabMU4fFK0H3bkLSfZ72hV4SllOSouJOl1j7QaSiSVR7jK1LmW0r7440?=
 =?us-ascii?Q?NZ7WM9/kWjdDB9IkDRtJdoKuZjL149+8W+ZdGz9Pmk1cY2PHl3Q81Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LhgqWTtD09RCDkzZTjcdPLr0U2fJTNVd5jsUhuvAeIDh/KCdwUBMC6B+rJ36?=
 =?us-ascii?Q?wr7K1pLMpRuRTd78Y2nPFwqJ6wfwmTKycFeoOpRo74/j6mirGhDsBsgDBHRh?=
 =?us-ascii?Q?H5ts/j++Ehe05jvXdix8+/nZetniCjEq03np4M1G2IM/T5zVVUIML/rRNEqE?=
 =?us-ascii?Q?I9R+ow/9WVXw5jogZGjtNeD2hMnVK+lDWfM2GNlZyJ/n0hXMB5c6OsAgqmka?=
 =?us-ascii?Q?tA5WhDmjUZxv7xJO02Jq/f+HS8g3gZqcmyoQQYp1LdDn41HER0YrbJXNI/Nn?=
 =?us-ascii?Q?rF+i9jjCViDBtdfcnUUtc5J25VJwjyEJIhiK84T6XaqgaC66wtDZKry7VYv9?=
 =?us-ascii?Q?+QGYXK9Ve4LG5Wk462uC9W8mGjh3LU8mSm3rovQw0e7EeUzVt5yOP5yg+bCH?=
 =?us-ascii?Q?X+894fOALUy6jSrq+hzH0BUAc2F/l7c+O2MNwr8CSlpgBnwKlIlC5Vx3zrIA?=
 =?us-ascii?Q?HEhNFNA1+OIXQlnvVAij+kDwEMM76gb2KB1hWnWvafzstHaMZHTTEnZ5LmR5?=
 =?us-ascii?Q?rPAUyOrzT9poJoM9WPezb2mLkQ6anSwUi3IIDiQZkH3CzXistu91gZQHuuaN?=
 =?us-ascii?Q?geWrcS7y2fXaU4RNZzEVhq3GR55IS0H1lHG2F7UhfcNF52wg4o9B/tkixE4Y?=
 =?us-ascii?Q?HNz5e1x46VH8FORmZrvFLjohpvExqdhpfx0MkoeWnJ9MYLlhf32QqUDQDlCI?=
 =?us-ascii?Q?biB1l68ihX1gHj82ROTuQ3bM3tle4QrvxRXYScTq7gLlKSpHRRqZ5Za19YvH?=
 =?us-ascii?Q?Z1R1kxnWqYv9db6mjrvhpdsH5NjNX2HIlrpiBthhuBBn/a/fKlkr8hL9OCza?=
 =?us-ascii?Q?Ux0sBd/ccheFkatMYhck8iXsP0A/EtmUW0eNwCdqtXVF/4pdWwFdXi59cIJI?=
 =?us-ascii?Q?irbA3cnXZtcZWd7hMOi8BtNGOINKznCOghsRTxxOtcPmutj6CrepYZVMgoo3?=
 =?us-ascii?Q?6d1Ki8HLEAPZdbfH3yXptSjrKThhpwTxFjwWe8qhZHDRUUz6rPB9Duzog5Cn?=
 =?us-ascii?Q?lDg52iTTgvl60KOzXIBjsfg64OaB1eccgdbeschTtVcUcv1LSqZaFTKAL7iN?=
 =?us-ascii?Q?pc8zq4Wke/JSPccobNizrOmzC7WJNKIoelzs4zR/GDY9TlOR3zdRqzLNnLfi?=
 =?us-ascii?Q?eIi/B1E25RuQJgS9vxKY9WbiSma/UlG1pB7+v59qq2SxMIE4MRc9WiQxUWYw?=
 =?us-ascii?Q?zzTORM26iQtejaTFKi+NBgkg63IqvPa3uI8G641f2MY6as6YeVg+05ewltbJ?=
 =?us-ascii?Q?L1g71C3E5L5cNnVOFCAYdJccIt8AUb0ZfWZszAylL05nAjxibdyPqwdKSVJM?=
 =?us-ascii?Q?inseG/u3v18fI3SMrtGXHtfHZP+MNQvddNIaddhnZIi/PG4oJEzfdY+9XILg?=
 =?us-ascii?Q?bnpNyc02jm98ebad4IDH5X5+f65+7DGvvqO8pcZNI1U6QFgYJ737OUygnH4H?=
 =?us-ascii?Q?yJ3EwgIGuFMa1O3qq+O5tQfwotLpCIIO0JidYVhD5cTX9o0qn+B2lRnaEI//?=
 =?us-ascii?Q?SZehEqhVlgH3HhX5SO35IGomE03TgwXrBQboiu3z+8BPdq9wdp4CH4Krq0ra?=
 =?us-ascii?Q?7/m8BoT+y2U2um4pgVjy+IA5HkQGsDHkWoSrWhvw?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e759f82-b504-4cb2-b393-08ddd8d3c2ab
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 12:36:57.4553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oBKU9cWlFqy9t/EbW8JuATczgJarqC2FqVQQsjVRHU1YIoTQfmOPYIksLiIbElkMJTi5Mas54c1g9C2KLoeFpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PPFA1B399C66

GFP_NOWAIT already includes __GFP_NOWARN, so let's remove the redundant
__GFP_NOWARN.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/md/raid5-cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index ba768ca7f422..e29e69335c69 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -3104,7 +3104,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 		goto out_mempool;
 
 	spin_lock_init(&log->tree_lock);
-	INIT_RADIX_TREE(&log->big_stripe_tree, GFP_NOWAIT | __GFP_NOWARN);
+	INIT_RADIX_TREE(&log->big_stripe_tree, GFP_NOWAIT);
 
 	thread = md_register_thread(r5l_reclaim_thread, log->rdev->mddev,
 				    "reclaim");
-- 
2.34.1

