Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012033.outbound.protection.outlook.com [52.101.126.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCD32989A4;
	Fri, 15 Aug 2025 01:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755222882; cv=fail; b=VP9uokpTHkle9ykEi/624KJSdOnk7fVfi9JQg/Pcd/rjqFgTPhM6/QTt3tR+G+BiiSuns83sz5X5eqhQfMqz2TbNFJb315SUcaSdCPE5ecdpVupOvce1eJ755dmrJ1x5QUwZxHKOys/0EozQ6jErhmWq52tyYz0fKWHp9kIYEEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755222882; c=relaxed/simple;
	bh=do/MwT9OQq5mXig/cTWJLAHQMwNHbGGjpxMFX3V2E04=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CrdIglSqtXuPXeL7GBH/ZRBcY3t3eGs9VOHnppmprp5rjBtdRL/FZSXnGKCTTkpVyLF8ZDn4BwDHbbU3Jm86zd5UyS0TjlBuHn7MB3ig8SghpDMPY6kaAzum7RPKJXf9Etsm/xKqh4faFB6YJyk2jQVe8Z/Gva+craYBYlciDw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=a5Hsh9dz; arc=fail smtp.client-ip=52.101.126.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="a5Hsh9dz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UlNOSj2tv4ocMwKUV4NVDpvkEhN6SV/Vai76gaKqTqr9lbHgZ13of4kA9yGiBx30YwrQcK7N7Iu3VT/tWPjwF/5NvKLe4iyp5ZSLcP1oxAlk87d2Triy5+7dQM3AwnRz4LyIOjaRPmOTjJZe+j//u4YIYyiOM/kzgz+kUauPRh/f4RCrBEs3Ah4C9ALVNLFhgjgAAGauailvQwkwQVOgb+VVc5uEU/IzClxlmDAIlmASmaD4ziAe38jqHUQ2tx6QZOT1HjADE+t0d0vpHA5fOondPJv6IkFcwp3yVy/lzXl/sGhQlgMShRKLT6FVejosiYkgeNZHb6YIWvoT1CK9Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ql4NZ5aswAcJi3sWNVF6U6AANxo6AZoxexVOGURel0=;
 b=O/Vi57xY/6QVN6ZQNLVnmK2odAKT/dRDs2+jAN7CklRKx/yu7kCZWaN/HTgFhlSt35vAOGlgzKu65UzV3Av9T44iZbG5RngJDqFwCTHBwxQUSke6cAaR79+8/0PDOZbvePu0ELWNIes5+671m3csUe4p0zFHPc+8qCgOOT2iPhieo+Y6oEjPKWJkVRUIj9RWb4EWr/clHHlWXOShrnCuq/UBPzelkuIMUaodXIHugLPhMClLc72rIMXoeS2XDBpmZPV0LRAgq+iHuCiqKdIkp44eBOklicDwgInmWZNW8CCV6NZLUACs7fdkxJ/ZEgs1IOnPnSGo+kYNiyE/FlkFRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ql4NZ5aswAcJi3sWNVF6U6AANxo6AZoxexVOGURel0=;
 b=a5Hsh9dzJNlEiz4a3URlLWEGaxNSF+gVOQYRbM8tKvWiZSb1IHXRNpkmqH6F0nOMM68TbstCGxuLb2V7XoXCU9Bwmb79brgP1JYQ9oDa9Cl73hJItiSJePrYcPicIFdD+YI55cq/AUmiGrySt1uBdj3MyenaXqLtR+yy7ngjMutBwrdTIrQH2nEsCZbjZSNL1nqXLZYu7AuMwVVDXKMfJlVRnrimx87SwOwyvi3lVeOjiWXIrLABQlmnuXEc3LdOqTzIpvBSxocThUhzTgYGs2dYPhNKioPLaZEhSdTMSZfS3tTEZq06wifU4aWKkfc9H8N01D4GZFqmkxOO/DQuWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by OSQPR06MB7974.apcprd06.prod.outlook.com (2603:1096:604:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 01:54:32 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 01:54:32 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH v1 02/13] lib/raid6: Clean up code style in sse1.c
Date: Fri, 15 Aug 2025 09:53:51 +0800
Message-Id: <20250815015404.468511-3-zhao.xichao@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2b87c6a6-a1f4-4842-f36f-08dddb9ead96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h4Ur7zn+6gX+x82w+Y9H1Mzf4Pl4wGUnIbzWN/LnBOTHikB4JptXCzgShMVv?=
 =?us-ascii?Q?J8Eahe4K6etxM5N/6IGGNmZopRlBAK1Qf7bsSYaQtMD9gBSpCOz2LLLt3GY+?=
 =?us-ascii?Q?uOPEuzjG3CdnR1WCZKkYxTSeBn15BMv9j+n/Kvw/b6EHXktHigDKtJFkmy56?=
 =?us-ascii?Q?jzUsZ3MWfSPiqPHKHLvDKfAzZW9R94ReQG1jesGC/lFGZEWKsxzEy0IBMfvw?=
 =?us-ascii?Q?JtRWwqRKCWieJe0rZqfv0SCVPT74U9ojAzdCk5ZtFzstmlyLGB8O8W5ImN7g?=
 =?us-ascii?Q?YIhqyZniLzctHpb1gEWPfOjXTtRoHqJ/6zbxLoj5ShUoz3jqZxOBqVpZLjH7?=
 =?us-ascii?Q?VopJ44uQXVn4H/rAV9q5UNh/L0H9Q7pU3wkpxKxQEswf5vqO2guN0zN3eTdh?=
 =?us-ascii?Q?iRWcJ+6m77iuidbgnSGIpVOdPX9F+GytocHCNAPhSNldAByG1lJYHhgiFT3J?=
 =?us-ascii?Q?rH6hmtVGuxybe2gkSnxymP+Z+7kxmLswl3TwBplk6WgG559g+t6Fz7cMKpzo?=
 =?us-ascii?Q?kTR6fSe+FurZdpmUj/rhFISCAsm4KjWK/8KVW3FQ1lWEX2WrGarmw+dUkWz4?=
 =?us-ascii?Q?lAU3HMCvcr6zLXmS4900RZfONc/qCHwH7YD121C6MiJEVS1YzF9qlU5Fnxo3?=
 =?us-ascii?Q?GMvIcyBHwJOzbODCH/gXziH1ZK+7kqpdb87ZoeP8wh5LzF+37LR1ejwoRs0G?=
 =?us-ascii?Q?pM2tvY84m7c5TbU0+gNAFVd+6SHs5zXjSC7EIVsFHHxCKCyquhamXIqL1YDn?=
 =?us-ascii?Q?V/8D9y7EoVvnPT/eCirHgfjwJ6vNGxP60skDYZ8kwb6n9K3SuS4ew4RD4XRh?=
 =?us-ascii?Q?9cQ05INVYz8kMsC8Po4lDOrwDzCC+/ooUeX+RGWl8UM0v055WbIQcwS8+eD/?=
 =?us-ascii?Q?kpmCyIltEoXHlDJrwyMF80k4fbLcUpXa0dYZmatjsLvdkPWY04hjFjsmenet?=
 =?us-ascii?Q?t6eB6KfT38ZOT4KWyel46Tidk7PEeZueAbQGaN2jgQGNFUwPv3U+/BLwujRv?=
 =?us-ascii?Q?iwys7+o38F4HOBb26bRMpFmv5hcY51uj9fKuP6lhz7eUXsDf5ekGW6dc2U3E?=
 =?us-ascii?Q?ZCQ+K23wgbI1xyCPfPIRaj0BgdjdlrrDqh2bx8PsK4ul45CXVMRxnuWTj3EC?=
 =?us-ascii?Q?jMF/VXU8D/s0kLutM9xWPPlp4pcueR43obtIr2tIlhw/AuxzLj+a8c/5qRwT?=
 =?us-ascii?Q?sDfdxSXVJJySybnRAnxsSIhmuXGmq207YwVnbrqJgxKkivmeKVxk523yPx7M?=
 =?us-ascii?Q?D7cRbFRmdEyH1M6qu2LV4t3aqsKHrWUd+gMwavQqJDiIAB76vaB/KSMDSToc?=
 =?us-ascii?Q?lqqGJ5CE3HyGQ0HUGLfaSrlhMYtrXMwdIQvgh67vBEfgROEpDa7fqTlIjLUZ?=
 =?us-ascii?Q?AXfPqKR93AofW3OIuZYyNPvWzRyr7Ina3X6cmRJ2X8pQaLY1HzQDlJzn43Gb?=
 =?us-ascii?Q?zgR/f6rC4rCG3zDXTRc8nxmNgipJ7dojfMw0y4m6MAeOeTSqHWqdDQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TZpjmbl0a2ynsigtLd1bARbxIfWAxRA6e/3YObt86OMQRr+MxXl4Me+xGKf4?=
 =?us-ascii?Q?zjgqezrw/ICamFGi4qPx/olrbNOMfOYymiLjpsg4guQHR7Ee+evLCz5Bh4nd?=
 =?us-ascii?Q?GZWvG5Qf+yuZAKeWFmBXHJ2o6ffUE6sSNKCdV+dZ3/xI+2WFC52nUMmRvzts?=
 =?us-ascii?Q?5AAc3S6/sCEownCNrG8YWAFwX9cka5CIznkXtesqg0buSmQOjgwehLsXk377?=
 =?us-ascii?Q?2l8kCw6Sr09Rv+OqYnOA1m4+/HlMHLielWHUHxn2LpzahfPzslILnreO3kuL?=
 =?us-ascii?Q?kWDIQ887a7wSy92MEX4fZBDFAze1hFW6rU6AHSwgUAKluPCKbCDs/VONdsAX?=
 =?us-ascii?Q?nrNF7566HywAacW5rutOhQk88/kvkFVt8k7Qzz8Oy/fZrYUWH4I7Et/xKNWb?=
 =?us-ascii?Q?B8XYWksW7PCjg7vy7C9vjARZ2mu81KXHpKWZZ5HLvEyvCRnXFbt85rAabgjs?=
 =?us-ascii?Q?SrwjWkj4EPaEpI5j5k8yXCjCu+RTN9q3P6ofsaCWYm5A/M4SXJ8KrrnQtlT3?=
 =?us-ascii?Q?fquDWf1YPyy4jkUgYv9ZhYOKy0UxtAanAz6yTMmO20clQymAddAcZRXrMlu/?=
 =?us-ascii?Q?++uxxSDjma1S1nyMfTqpw49KvgSwCiCfIUTHi3J/pez77JhH+VLaX4O+yZG1?=
 =?us-ascii?Q?0hc5TJMzxzfcGvTb7UfCtM9nqvRRF7SCtR3OTuot3tIAYGpPbq3JWZhiU+hX?=
 =?us-ascii?Q?Nhpj9Goq5/tvOAQzhRFtI7EkoQZfQA2q/Z3UyfXB2HGC9+y97o76YEOW6Bir?=
 =?us-ascii?Q?vL8iVANmfQv+kBdsWmBCQAz5RTOvoRHidTDeeDlgUD/dhm9h6v6RrKwUKU+u?=
 =?us-ascii?Q?kkPIIFjAXnwyzQptL4lkb2ZahPE5FFRVTOPqE6Nd3pZ54vGqCsWo9WIfCJWw?=
 =?us-ascii?Q?PlrqqRDxHnwZI1R/6mBUnbTR7jm6noPaQbtlTKTjruLER3Sp85yuq0C1Vmlc?=
 =?us-ascii?Q?7b4ME5MEVztfBOliW3aLsJDgr0OAq6kGibSrowSR9dE5sPLKnW/EeiY5g2Lu?=
 =?us-ascii?Q?dj3EwRTsZmYiaCmxusVypv7oMIELpt/7Ufk3ipToxeYPkA4DoP+xkWMO2BaI?=
 =?us-ascii?Q?23tw84j6NYzc4Gwxn1KLZ9vEucdAiFD8AVihAKtBppugC5VRlqWRG1q1ZUX4?=
 =?us-ascii?Q?H41W+sdUUAtChfTcSc2nFxks//pVPUpi52PIYszSKw5vHtW6cLRoLhQbXJkX?=
 =?us-ascii?Q?Pzu91VHGZohgA6BgWQmYG2xgisV1V68l1G1WsoaB13lbHxuK2ozEaAppZ0uB?=
 =?us-ascii?Q?+SKToD3oZBJheH2RFEXOMOyfj80rqyHLURr1VExrUwomJmtw7+QqyZe2fQvX?=
 =?us-ascii?Q?fOEPJmuek86CPP5fYZ6BDNBcsQ+uHOnycLkX2l7ftLm8RgWxtRXU6MBgmM0x?=
 =?us-ascii?Q?xChoLjF+eIE2Fvu/Gg5CbFGuxJ607Sjxgt89osx2R1w7e/nOTseHVVkLTg9X?=
 =?us-ascii?Q?s0I1U77W+2TVHel5TAbqWkJ5LCw97UbWBZxU0I11cCddtZSF6xet0/rMllsw?=
 =?us-ascii?Q?xHCG6vHEvp00OeT0Ikm2dMLRQrAZILgtkIbLs82nJt5Pkx9u1sXC9UU1QhVu?=
 =?us-ascii?Q?Gt8UyINzR9pJlAM6VgUydXtvM2sK4p38rgLzNVj6?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b87c6a6-a1f4-4842-f36f-08dddb9ead96
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 01:54:32.1744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lbI00kstOfnSLMaRd0dr+XiCWz4AxdBaa5PaBuk6Qs8UlBDmEUdlDkRRSwH5t/BzIdPnOu9OQ7hmt/LH4ffqBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7974

Reduce or add spaces to clean up code style.
No functional changes here.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 lib/raid6/sse1.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/lib/raid6/sse1.c b/lib/raid6/sse1.c
index 692fa3a93bf0..42fc33b0f364 100644
--- a/lib/raid6/sse1.c
+++ b/lib/raid6/sse1.c
@@ -44,21 +44,21 @@ static void raid6_sse11_gen_syndrome(int disks, size_t bytes, void **ptrs)
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
 		asm volatile("prefetchnta %0" : : "m" (dptr[z0][d]));
 		asm volatile("movq %0,%%mm2" : : "m" (dptr[z0][d])); /* P[0] */
-		asm volatile("prefetchnta %0" : : "m" (dptr[z0-1][d]));
+		asm volatile("prefetchnta %0" : : "m" (dptr[z0 - 1][d]));
 		asm volatile("movq %mm2,%mm4");	/* Q[0] */
-		asm volatile("movq %0,%%mm6" : : "m" (dptr[z0-1][d]));
-		for ( z = z0-2 ; z >= 0 ; z-- ) {
+		asm volatile("movq %0,%%mm6" : : "m" (dptr[z0 - 1][d]));
+		for (z = z0 - 2; z >= 0; z--) {
 			asm volatile("prefetchnta %0" : : "m" (dptr[z][d]));
 			asm volatile("pcmpgtb %mm4,%mm5");
 			asm volatile("paddb %mm4,%mm4");
@@ -103,8 +103,8 @@ static void raid6_sse12_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	int d, z, z0;
 
 	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0+1];		/* XOR parity */
-	q = dptr[z0+2];		/* RS syndrome */
+	p = dptr[z0 + 1];	/* XOR parity */
+	q = dptr[z0 + 2];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
@@ -113,13 +113,13 @@ static void raid6_sse12_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	asm volatile("pxor %mm7,%mm7"); /* Zero temp */
 
 	/* We uniformly assume a single prefetch covers at least 16 bytes */
-	for ( d = 0 ; d < bytes ; d += 16 ) {
+	for (d = 0; d < bytes; d += 16) {
 		asm volatile("prefetchnta %0" : : "m" (dptr[z0][d]));
-		asm volatile("movq %0,%%mm2" : : "m" (dptr[z0][d])); /* P[0] */
-		asm volatile("movq %0,%%mm3" : : "m" (dptr[z0][d+8])); /* P[1] */
+		asm volatile("movq %0,%%mm2" : : "m" (dptr[z0][d]));	 /* P[0] */
+		asm volatile("movq %0,%%mm3" : : "m" (dptr[z0][d + 8])); /* P[1] */
 		asm volatile("movq %mm2,%mm4");	/* Q[0] */
 		asm volatile("movq %mm3,%mm6"); /* Q[1] */
-		for ( z = z0-1 ; z >= 0 ; z-- ) {
+		for (z = z0 - 1; z >= 0; z--) {
 			asm volatile("prefetchnta %0" : : "m" (dptr[z][d]));
 			asm volatile("pcmpgtb %mm4,%mm5");
 			asm volatile("pcmpgtb %mm6,%mm7");
@@ -130,7 +130,7 @@ static void raid6_sse12_gen_syndrome(int disks, size_t bytes, void **ptrs)
 			asm volatile("pxor %mm5,%mm4");
 			asm volatile("pxor %mm7,%mm6");
 			asm volatile("movq %0,%%mm5" : : "m" (dptr[z][d]));
-			asm volatile("movq %0,%%mm7" : : "m" (dptr[z][d+8]));
+			asm volatile("movq %0,%%mm7" : : "m" (dptr[z][d + 8]));
 			asm volatile("pxor %mm5,%mm2");
 			asm volatile("pxor %mm7,%mm3");
 			asm volatile("pxor %mm5,%mm4");
@@ -139,9 +139,9 @@ static void raid6_sse12_gen_syndrome(int disks, size_t bytes, void **ptrs)
 			asm volatile("pxor %mm7,%mm7");
 		}
 		asm volatile("movntq %%mm2,%0" : "=m" (p[d]));
-		asm volatile("movntq %%mm3,%0" : "=m" (p[d+8]));
+		asm volatile("movntq %%mm3,%0" : "=m" (p[d + 8]));
 		asm volatile("movntq %%mm4,%0" : "=m" (q[d]));
-		asm volatile("movntq %%mm6,%0" : "=m" (q[d+8]));
+		asm volatile("movntq %%mm6,%0" : "=m" (q[d + 8]));
 	}
 
 	asm volatile("sfence" : :: "memory");
-- 
2.34.1

