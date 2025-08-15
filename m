Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012033.outbound.protection.outlook.com [52.101.126.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591B829CB42;
	Fri, 15 Aug 2025 01:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755222880; cv=fail; b=hn8n8NrzR/p65cUoTanQV/fzQyb1XV8l+voG4dhnheyPDoIlovElzqQZITmvlJHATENZbUBAg5XIwQRh27Rve8sbyTg7H2XatWwkgVzX3pDQLjMkhbUBbk8lQox0Tw9+ercJRoEuR015c2Q3y6pCvBCEAKIaRnMRDQJ7pR0e1YE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755222880; c=relaxed/simple;
	bh=rZumKlrlnelepw2wcux/gVdwIYQeQyj1DNjhUm7CDGQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eNHQy1V4oVeak3k3fIIwYusxm3MG+aDo1Z5BUSzXfcbqTgz/3rPqcwhCYQCWb50aZv5kxZt78VI6GGKU7vkV+48X44SpwA6JVdK1bJHpMUDeFuChdmkM6WvsnI9BLN9Bmfs8CdRNN2Rqg93Ipe+og8LFO1huSAmpTZX867RBNWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=PCCnqIYy; arc=fail smtp.client-ip=52.101.126.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="PCCnqIYy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XD3PRielJBUVbFv62JR5cUlCC+3Hj6ShyXTpqNuafCCIZUW/HE4+3O9d9itXdlTLreylarkmiB0d4O6xsiSnXxcjs3JWPgRrA8oSJU28qxjxrCMfiaj0sISZvCwZBWlfKF251m6fNZvUqFsLtRoj1vwxQFj8f3njoO9LcqMZpruAC2mGf4wY+PkY90LJnl7R6W2BoXqSC8SrW2Pf1jlDtSB2ls2+hdD+uWJQZYLtZCxkjY3V84JGkzpfGlvBrOOA6HIXY3fwxa195VfMsuLZChk81AAsYebsPAsL9mxXJpJ7f4SzRClYHsT1mIXq4++TW7R/v9tmFYfRHXCs15wr3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GKIVgFncnvWJ6XVKXuiUOipIB+CH1Z1sUbkhmtLUrYE=;
 b=LrLEZTEVSlc2I9ITPRk2cAVmj3WQbwD2f/VTY14vXlx+GoPqYbJ4gei0JFlvtRnpBs6bOZiiCNLn8y4EkN5hPdTE8xUojKD1ghBNNHipVImGIIgjsTE2oBv87Da9JGHZWP9K+plqqiNLmkv/Wy2PzJjbC5B41u/JORAibQacmV6KQpgxDzL5l/EGI9IZn1PpYXnuwWNBP59giJYr4fcMS5E3WuEbD7NEDWiGLVM1ufWE733RtrEbEbi7XIw9A1kmgUmADSUA8wOWEm69McKiIxdVmuC+nI3rtEY3lEJo1AJvcLkBKdnoUZM4HTyGdm2fDqm9ibJd8U8U15wcY91ATg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKIVgFncnvWJ6XVKXuiUOipIB+CH1Z1sUbkhmtLUrYE=;
 b=PCCnqIYyQcWUwC3a1Uj94e+iayty1nW2y/u5RWligSWg4/bwKIaTTIozXBHnnZUJzyIfPXWg2Wvs8NU6h74dDxVugQiclu5Ku/tDmqQoa79v1TRvR/NdhbV9O8MaM2evwrcOVNf89KV3e96Vc08ILoAdGcCsApJUmxgUCjiOk6Ze4EsqVOSJw1LkhyeBaCCm52DqiUk9Wf3HGElu+8/q3c9e4S4oH2W85TWHV8ZVkC9BJnh5iJCyAlE8LFjJv8RDzx0yRokJvixxYBbTVl+XPAmBF+LJmDLc/VB6mABBvnJiIKrICSjejNYvU2yTlOtXxjb5Fl6YvN4kqfyNTukDcA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by OSQPR06MB7974.apcprd06.prod.outlook.com (2603:1096:604:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 01:54:31 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 01:54:31 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH v1 01/13] lib/raid6: Clean up code style in sse2.c
Date: Fri, 15 Aug 2025 09:53:50 +0800
Message-Id: <20250815015404.468511-2-zhao.xichao@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3c6f9696-9ac4-4eba-9957-08dddb9eace1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ul7TS0xnzMwyBSRVClGnJDEwAJlo2yLTKEmgCfpoXuDVq760d31IXwHVTDl/?=
 =?us-ascii?Q?NN4YZP0OHUt1hYgUjYXx0M5REOypMaS84QrQ61EsteM8OITzK5TQwfeGUPps?=
 =?us-ascii?Q?nMTM2R4nnRjg25npB1I+/5E5iJoX86Of36t8JQtk+oVhfxHkfUCZbXqIoGWx?=
 =?us-ascii?Q?MyiY1A2dDfWrjohc974pOj5cZHHo5n1glaQMo4aN+ROrrsTOa5cnPgS88/cU?=
 =?us-ascii?Q?nRWL8l0Yc6XwRuj1NQc/m/kLO+1/VAj5PF24O9r/VzeiQL5AGUCBKvgDTubX?=
 =?us-ascii?Q?eQP9QlT5vXKIGhG9LDb7mrbEgYjEKDUlhz5F+pKWgOcSpc11vAKVx/YJ0siD?=
 =?us-ascii?Q?LlyWghm7h0lyYU5Po+W6wdwojIn6XjhY7wIpeWgb4rU/OSY7q+EoV8xwZt4H?=
 =?us-ascii?Q?JCDQN5YcXZuS1GxB2ooixmX3QIj69F3jBJFcNA97HqI7EscoAyqCjpcy7smJ?=
 =?us-ascii?Q?8IjmaiMDZ91foaKjCdaM2X/9GB15yP9tC0a5TtmywuC1GcxqAHBc43eCrHri?=
 =?us-ascii?Q?3ZIK8rYsCqIqfsqdC/qA0+5MT39K9gzgAI8HVdw/1tKPY+VmXeQoH64ulNpf?=
 =?us-ascii?Q?XoJgawI4MK/j/GXuuxw2+/BluD0Lu8VlunvdBVPXJ+nC9R8e5pvF7792wkTN?=
 =?us-ascii?Q?v9efBCrrSBsYH6u7KiQyp0ru2fuC4Almu8nv4ENxsoln+OLlnF4qYUdOsgt9?=
 =?us-ascii?Q?hrk2yEcOcQqjiquAKCDAXphaV6pYO+asuCAf7kq1YQ78908o8Mpd3CyIcz9Z?=
 =?us-ascii?Q?dAoK+CL6KTYWSTIE584APqwSv/ZzKPxulNOYr8iUVJzvDGMbcY8V+/Jh6bVD?=
 =?us-ascii?Q?EDBsUhdptX9eAIyEqTZHM1Rfv2xcxn3EZWWItZ4YHpuKLy7KJ2bFQnwO1/uO?=
 =?us-ascii?Q?aUDjg1DTSUvTtuVn6PdZlD1AnCujBuyVVkA+QihjCBbfRXnku4s69M79Siay?=
 =?us-ascii?Q?30rJe6XP8pquUwO/w/g7Q1jQqGvVB6iNWkZVbzBmeTDjcS4bqgb/4iI7bDWf?=
 =?us-ascii?Q?MF4Oj+yDw7nOK4B5PF3U4brEoxr8Iu8pH4Zy2hvMALQZULCqvJSU2/cPHBlZ?=
 =?us-ascii?Q?VHRxvJ66cZ4vu8IQDQqR97ugIHLPfQIYQLUqF17nht87RizNgAmI90G36UdK?=
 =?us-ascii?Q?IQe5bm/UtAG0Fh8Zbd6jYzWROSooIhaDsFwsa6Hby/BTJkiElxFNQqC0Tekg?=
 =?us-ascii?Q?aqs/nWI6RtcYlfp0F6mSLzDiTnpLkuDMEC7RcXxC9tY19ST2kg6FBb+VjSFm?=
 =?us-ascii?Q?7yNtgVqTwrtwhj3Q748L70v/kLs80wL+o68hs1vq2aobCLqh/01OlRGLTLQE?=
 =?us-ascii?Q?T2u4TSLWqMYbc8Zl1IudpqaY53NJcEAyTmXJrWlqJ3FsrzOPtPN/F9oYdMxV?=
 =?us-ascii?Q?bceJdIvTJndSQn8yYr6hy4JVf5ADYbjIQx+wlaHNloWzmumEosSx2naPq+vo?=
 =?us-ascii?Q?DALkTXLT6af/vEMZsOfSfaDWjNK+i/ZDYPpOG6gZteRjlPaMGlOnRg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3xUIJoLpAEPj2JZ8war+QH86H4YTkpLxx05PfpdytfTkZjFHhOzFWwj91a1J?=
 =?us-ascii?Q?1f7r5jlImj2BMBIEWorncRXX29FiVu0VcHgBZ7uzhlRzZjRhpv61EseApjhQ?=
 =?us-ascii?Q?fuGFDWlCTGBXTrLRr5L2N6QD4b2dnqM2nOyd4cpz7ScDq0Y767mvVqNilR7c?=
 =?us-ascii?Q?hAhfXqNwN7fMqcfA+7ndKQVP5GUWws7QHJ+qt+2SGare9KqyD45JNklpCVn9?=
 =?us-ascii?Q?FMlp0ZgWgjoqJdkwON4zhZ0GJVYcfkZMOPT4KkbT8xx8MsEOKLD2+xT9srqe?=
 =?us-ascii?Q?opy5K/XaLAMx6Z67gTsAFuFjgD+fHhe+fyZeSHTFO3blx0bI+kWPd2YC5mUL?=
 =?us-ascii?Q?IeqCA4W1RB55Z6H0Bqyo5a3nvyXCRvzr0tIhZt31oeloPLfj6b3EQW5tY6on?=
 =?us-ascii?Q?rOokFMmJQtL2CMTNY7EfnPa/PPh2SWcoLusBStMQoSt8GtLivgFzCMrQXUXS?=
 =?us-ascii?Q?QT3M5DvBItc6AXJtKJek9t+ans5VspWmO+rIBgYF1w9sq5197kb/LUlkh/Cf?=
 =?us-ascii?Q?YjZiz9bHuz5BijqCDJNcFXMyRPsmJa6kyGO4c8tJkYt7v7LU7XmiTnQhu7+O?=
 =?us-ascii?Q?e4ii472pNTImt/++U8R+IyrXa7VUgBL21OOGF5mlQIUa7pRN5eH5Ip4mbiH1?=
 =?us-ascii?Q?ybB84PgpbKTA/gXI3QGxdZGI6atHuzoBxt8+aCDKqCtt6QF28BSwz62LXFrO?=
 =?us-ascii?Q?46GTXufvYWP3JXyYEPWo1C8IBtCXPaMH3DQozciWHYZl1fJb3Id+zga9+JWh?=
 =?us-ascii?Q?8+z39f8fgJxqR5qDFXxTw9T5AENxDakmM0R8Ab/hexdKYrZeewwZYBvqBRgZ?=
 =?us-ascii?Q?IcLWYno/aIccx34jmhoYK0ZIPL0MxgYlESjDb+nBFvg05gghf4RbXjzr5cJ9?=
 =?us-ascii?Q?6g1aO5yzi6Xr1TbXeToyVoLCYccP23iwCIh3MumwSNcHMFNZk8JjO+9A3ocN?=
 =?us-ascii?Q?gHstIkOTUu3/4wAIvUTEAchghgzA0i3sC8NfT8uzJZft3gNPo4JPPypAcB1Q?=
 =?us-ascii?Q?DDLWQ6KDrDonMDNNHHQ8LKkvyYPV/KGUrC1+2TAn93v8N2U2beLBkN6VAzWR?=
 =?us-ascii?Q?/dOffOU2DA0Qgax7kLgUG12eBs4rWxTVtmu8wRVzzJJo9LEDiIgL1rPBh7LT?=
 =?us-ascii?Q?Hy/1KyuR3TrD2XKBo0IWujx4QpUBGxHODNpWJwY5F9p5BI48Ha04B3xK6TiO?=
 =?us-ascii?Q?zOreg0NPi+YKMYo3jZHPl+9yNAFDrMPOimnpQh6KgQozhvYKGBTw8dFigx2k?=
 =?us-ascii?Q?gjpQFFAtnbhSlXiGtOT/oNLaY90Xg8LzE0nAiUIpkIZZ7GMo8pzwNSjasIVm?=
 =?us-ascii?Q?mAa54jTvTbkjSa6wgqWW38TatF0AMWzjvjlJp4vAbiLQCdViyEZeUxGU6v9X?=
 =?us-ascii?Q?EODEZilQgohXnHjXB9sis7f+flTOHwbC6wqldelvsgwl8WWUJN/9wY2KDsqL?=
 =?us-ascii?Q?+pXQtId99Y+RU4wYMW9c4COKiWNQitpZ4dvCgZiGtflaeJx5xCFEJR12xRYf?=
 =?us-ascii?Q?vofRpsvNLXe4ZeMagTX+V0dVAL0jQv+d250m2FIPfbUo3xfikZIZ1Z8tTrUp?=
 =?us-ascii?Q?8cIULGdUvf/KbgJVT1tLdkLV92p1FCOU7sq+CmJp?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c6f9696-9ac4-4eba-9957-08dddb9eace1
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 01:54:30.9995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hlZQCdmJ5WuD8qwq7ktOGKoOLz+TJdvLjeZxitH5BxaIZO0pc/lK05JIQwGgtjfGnI1gdxrEXNi+Qd6LAVKENQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7974

Reduce or add spaces to clean up code style.
No functional changes here.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 lib/raid6/sse2.c | 126 +++++++++++++++++++++++------------------------
 1 file changed, 63 insertions(+), 63 deletions(-)

diff --git a/lib/raid6/sse2.c b/lib/raid6/sse2.c
index 2930220249c9..662e0c50fc57 100644
--- a/lib/raid6/sse2.c
+++ b/lib/raid6/sse2.c
@@ -40,21 +40,21 @@ static void raid6_sse21_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	int d, z, z0;
 
 	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0+1];		/* XOR parity */
-	q = dptr[z0+2];		/* RS syndrome */
+	p = dptr[z0 + 1];	/* XOR parity */
+	q = dptr[z0 + 2];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
 	asm volatile("movdqa %0,%%xmm0" : : "m" (raid6_sse_constants.x1d[0]));
 	asm volatile("pxor %xmm5,%xmm5");	/* Zero temp */
 
-	for ( d = 0 ; d < bytes ; d += 16 ) {
+	for (d = 0; d < bytes; d += 16) {
 		asm volatile("prefetchnta %0" : : "m" (dptr[z0][d]));
 		asm volatile("movdqa %0,%%xmm2" : : "m" (dptr[z0][d])); /* P[0] */
-		asm volatile("prefetchnta %0" : : "m" (dptr[z0-1][d]));
+		asm volatile("prefetchnta %0" : : "m" (dptr[z0 - 1][d]));
 		asm volatile("movdqa %xmm2,%xmm4"); /* Q[0] */
-		asm volatile("movdqa %0,%%xmm6" : : "m" (dptr[z0-1][d]));
-		for ( z = z0-2 ; z >= 0 ; z-- ) {
+		asm volatile("movdqa %0,%%xmm6" : : "m" (dptr[z0 - 1][d]));
+		for (z = z0 - 2; z >= 0; z--) {
 			asm volatile("prefetchnta %0" : : "m" (dptr[z][d]));
 			asm volatile("pcmpgtb %xmm4,%xmm5");
 			asm volatile("paddb %xmm4,%xmm4");
@@ -92,19 +92,19 @@ static void raid6_sse21_xor_syndrome(int disks, int start, int stop,
 	int d, z, z0;
 
 	z0 = stop;		/* P/Q right side optimization */
-	p = dptr[disks-2];	/* XOR parity */
-	q = dptr[disks-1];	/* RS syndrome */
+	p = dptr[disks - 2];	/* XOR parity */
+	q = dptr[disks - 1];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
 	asm volatile("movdqa %0,%%xmm0" : : "m" (raid6_sse_constants.x1d[0]));
 
-	for ( d = 0 ; d < bytes ; d += 16 ) {
+	for (d = 0; d < bytes; d += 16) {
 		asm volatile("movdqa %0,%%xmm4" :: "m" (dptr[z0][d]));
 		asm volatile("movdqa %0,%%xmm2" : : "m" (p[d]));
 		asm volatile("pxor %xmm4,%xmm2");
 		/* P/Q data pages */
-		for ( z = z0-1 ; z >= start ; z-- ) {
+		for (z = z0 - 1; z >= start; z--) {
 			asm volatile("pxor %xmm5,%xmm5");
 			asm volatile("pcmpgtb %xmm4,%xmm5");
 			asm volatile("paddb %xmm4,%xmm4");
@@ -115,7 +115,7 @@ static void raid6_sse21_xor_syndrome(int disks, int start, int stop,
 			asm volatile("pxor %xmm5,%xmm4");
 		}
 		/* P/Q left side optimization */
-		for ( z = start-1 ; z >= 0 ; z-- ) {
+		for (z = start - 1; z >= 0; z--) {
 			asm volatile("pxor %xmm5,%xmm5");
 			asm volatile("pcmpgtb %xmm4,%xmm5");
 			asm volatile("paddb %xmm4,%xmm4");
@@ -150,8 +150,8 @@ static void raid6_sse22_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	int d, z, z0;
 
 	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0+1];		/* XOR parity */
-	q = dptr[z0+2];		/* RS syndrome */
+	p = dptr[z0 + 1];	/* XOR parity */
+	q = dptr[z0 + 2];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
@@ -160,13 +160,13 @@ static void raid6_sse22_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	asm volatile("pxor %xmm7,%xmm7"); /* Zero temp */
 
 	/* We uniformly assume a single prefetch covers at least 32 bytes */
-	for ( d = 0 ; d < bytes ; d += 32 ) {
+	for (d = 0; d < bytes; d += 32) {
 		asm volatile("prefetchnta %0" : : "m" (dptr[z0][d]));
-		asm volatile("movdqa %0,%%xmm2" : : "m" (dptr[z0][d]));    /* P[0] */
-		asm volatile("movdqa %0,%%xmm3" : : "m" (dptr[z0][d+16])); /* P[1] */
+		asm volatile("movdqa %0,%%xmm2" : : "m" (dptr[z0][d]));      /* P[0] */
+		asm volatile("movdqa %0,%%xmm3" : : "m" (dptr[z0][d + 16])); /* P[1] */
 		asm volatile("movdqa %xmm2,%xmm4"); /* Q[0] */
 		asm volatile("movdqa %xmm3,%xmm6"); /* Q[1] */
-		for ( z = z0-1 ; z >= 0 ; z-- ) {
+		for (z = z0 - 1; z >= 0; z--) {
 			asm volatile("prefetchnta %0" : : "m" (dptr[z][d]));
 			asm volatile("pcmpgtb %xmm4,%xmm5");
 			asm volatile("pcmpgtb %xmm6,%xmm7");
@@ -177,7 +177,7 @@ static void raid6_sse22_gen_syndrome(int disks, size_t bytes, void **ptrs)
 			asm volatile("pxor %xmm5,%xmm4");
 			asm volatile("pxor %xmm7,%xmm6");
 			asm volatile("movdqa %0,%%xmm5" : : "m" (dptr[z][d]));
-			asm volatile("movdqa %0,%%xmm7" : : "m" (dptr[z][d+16]));
+			asm volatile("movdqa %0,%%xmm7" : : "m" (dptr[z][d + 16]));
 			asm volatile("pxor %xmm5,%xmm2");
 			asm volatile("pxor %xmm7,%xmm3");
 			asm volatile("pxor %xmm5,%xmm4");
@@ -203,22 +203,22 @@ static void raid6_sse22_xor_syndrome(int disks, int start, int stop,
 	int d, z, z0;
 
 	z0 = stop;		/* P/Q right side optimization */
-	p = dptr[disks-2];	/* XOR parity */
-	q = dptr[disks-1];	/* RS syndrome */
+	p = dptr[disks - 2];	/* XOR parity */
+	q = dptr[disks - 1];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
 	asm volatile("movdqa %0,%%xmm0" : : "m" (raid6_sse_constants.x1d[0]));
 
-	for ( d = 0 ; d < bytes ; d += 32 ) {
+	for (d = 0; d < bytes; d += 32) {
 		asm volatile("movdqa %0,%%xmm4" :: "m" (dptr[z0][d]));
-		asm volatile("movdqa %0,%%xmm6" :: "m" (dptr[z0][d+16]));
+		asm volatile("movdqa %0,%%xmm6" :: "m" (dptr[z0][d + 16]));
 		asm volatile("movdqa %0,%%xmm2" : : "m" (p[d]));
-		asm volatile("movdqa %0,%%xmm3" : : "m" (p[d+16]));
+		asm volatile("movdqa %0,%%xmm3" : : "m" (p[d + 16]));
 		asm volatile("pxor %xmm4,%xmm2");
 		asm volatile("pxor %xmm6,%xmm3");
 		/* P/Q data pages */
-		for ( z = z0-1 ; z >= start ; z-- ) {
+		for (z = z0 - 1; z >= start; z--) {
 			asm volatile("pxor %xmm5,%xmm5");
 			asm volatile("pxor %xmm7,%xmm7");
 			asm volatile("pcmpgtb %xmm4,%xmm5");
@@ -230,14 +230,14 @@ static void raid6_sse22_xor_syndrome(int disks, int start, int stop,
 			asm volatile("pxor %xmm5,%xmm4");
 			asm volatile("pxor %xmm7,%xmm6");
 			asm volatile("movdqa %0,%%xmm5" :: "m" (dptr[z][d]));
-			asm volatile("movdqa %0,%%xmm7" :: "m" (dptr[z][d+16]));
+			asm volatile("movdqa %0,%%xmm7" :: "m" (dptr[z][d + 16]));
 			asm volatile("pxor %xmm5,%xmm2");
 			asm volatile("pxor %xmm7,%xmm3");
 			asm volatile("pxor %xmm5,%xmm4");
 			asm volatile("pxor %xmm7,%xmm6");
 		}
 		/* P/Q left side optimization */
-		for ( z = start-1 ; z >= 0 ; z-- ) {
+		for (z = start - 1; z >= 0; z--) {
 			asm volatile("pxor %xmm5,%xmm5");
 			asm volatile("pxor %xmm7,%xmm7");
 			asm volatile("pcmpgtb %xmm4,%xmm5");
@@ -250,12 +250,12 @@ static void raid6_sse22_xor_syndrome(int disks, int start, int stop,
 			asm volatile("pxor %xmm7,%xmm6");
 		}
 		asm volatile("pxor %0,%%xmm4" : : "m" (q[d]));
-		asm volatile("pxor %0,%%xmm6" : : "m" (q[d+16]));
+		asm volatile("pxor %0,%%xmm6" : : "m" (q[d + 16]));
 		/* Don't use movntdq for r/w memory area < cache line */
 		asm volatile("movdqa %%xmm4,%0" : "=m" (q[d]));
-		asm volatile("movdqa %%xmm6,%0" : "=m" (q[d+16]));
+		asm volatile("movdqa %%xmm6,%0" : "=m" (q[d + 16]));
 		asm volatile("movdqa %%xmm2,%0" : "=m" (p[d]));
-		asm volatile("movdqa %%xmm3,%0" : "=m" (p[d+16]));
+		asm volatile("movdqa %%xmm3,%0" : "=m" (p[d + 16]));
 	}
 
 	asm volatile("sfence" : : : "memory");
@@ -282,8 +282,8 @@ static void raid6_sse24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	int d, z, z0;
 
 	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0+1];		/* XOR parity */
-	q = dptr[z0+2];		/* RS syndrome */
+	p = dptr[z0 + 1];	/* XOR parity */
+	q = dptr[z0 + 2];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
@@ -301,11 +301,11 @@ static void raid6_sse24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	asm volatile("pxor %xmm14,%xmm14"); 	/* Q[3] */
 	asm volatile("pxor %xmm15,%xmm15"); 	/* Zero temp */
 
-	for ( d = 0 ; d < bytes ; d += 64 ) {
-		for ( z = z0 ; z >= 0 ; z-- ) {
+	for (d = 0; d < bytes; d += 64) {
+		for (z = z0; z >= 0; z--) {
 			/* The second prefetch seems to improve performance... */
 			asm volatile("prefetchnta %0" :: "m" (dptr[z][d]));
-			asm volatile("prefetchnta %0" :: "m" (dptr[z][d+32]));
+			asm volatile("prefetchnta %0" :: "m" (dptr[z][d + 32]));
 			asm volatile("pcmpgtb %xmm4,%xmm5");
 			asm volatile("pcmpgtb %xmm6,%xmm7");
 			asm volatile("pcmpgtb %xmm12,%xmm13");
@@ -323,9 +323,9 @@ static void raid6_sse24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 			asm volatile("pxor %xmm13,%xmm12");
 			asm volatile("pxor %xmm15,%xmm14");
 			asm volatile("movdqa %0,%%xmm5" :: "m" (dptr[z][d]));
-			asm volatile("movdqa %0,%%xmm7" :: "m" (dptr[z][d+16]));
-			asm volatile("movdqa %0,%%xmm13" :: "m" (dptr[z][d+32]));
-			asm volatile("movdqa %0,%%xmm15" :: "m" (dptr[z][d+48]));
+			asm volatile("movdqa %0,%%xmm7" :: "m" (dptr[z][d + 16]));
+			asm volatile("movdqa %0,%%xmm13" :: "m" (dptr[z][d + 32]));
+			asm volatile("movdqa %0,%%xmm15" :: "m" (dptr[z][d + 48]));
 			asm volatile("pxor %xmm5,%xmm2");
 			asm volatile("pxor %xmm7,%xmm3");
 			asm volatile("pxor %xmm13,%xmm10");
@@ -341,11 +341,11 @@ static void raid6_sse24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 		}
 		asm volatile("movntdq %%xmm2,%0" : "=m" (p[d]));
 		asm volatile("pxor %xmm2,%xmm2");
-		asm volatile("movntdq %%xmm3,%0" : "=m" (p[d+16]));
+		asm volatile("movntdq %%xmm3,%0" : "=m" (p[d + 16]));
 		asm volatile("pxor %xmm3,%xmm3");
-		asm volatile("movntdq %%xmm10,%0" : "=m" (p[d+32]));
+		asm volatile("movntdq %%xmm10,%0" : "=m" (p[d + 32]));
 		asm volatile("pxor %xmm10,%xmm10");
-		asm volatile("movntdq %%xmm11,%0" : "=m" (p[d+48]));
+		asm volatile("movntdq %%xmm11,%0" : "=m" (p[d + 48]));
 		asm volatile("pxor %xmm11,%xmm11");
 		asm volatile("movntdq %%xmm4,%0" : "=m" (q[d]));
 		asm volatile("pxor %xmm4,%xmm4");
@@ -369,8 +369,8 @@ static void raid6_sse24_xor_syndrome(int disks, int start, int stop,
 	int d, z, z0;
 
 	z0 = stop;		/* P/Q right side optimization */
-	p = dptr[disks-2];	/* XOR parity */
-	q = dptr[disks-1];	/* RS syndrome */
+	p = dptr[disks - 2];	/* XOR parity */
+	q = dptr[disks - 1];	/* RS syndrome */
 
 	kernel_fpu_begin();
 
@@ -378,21 +378,21 @@ static void raid6_sse24_xor_syndrome(int disks, int start, int stop,
 
 	for ( d = 0 ; d < bytes ; d += 64 ) {
 		asm volatile("movdqa %0,%%xmm4" :: "m" (dptr[z0][d]));
-		asm volatile("movdqa %0,%%xmm6" :: "m" (dptr[z0][d+16]));
-		asm volatile("movdqa %0,%%xmm12" :: "m" (dptr[z0][d+32]));
-		asm volatile("movdqa %0,%%xmm14" :: "m" (dptr[z0][d+48]));
+		asm volatile("movdqa %0,%%xmm6" :: "m" (dptr[z0][d + 16]));
+		asm volatile("movdqa %0,%%xmm12" :: "m" (dptr[z0][d + 32]));
+		asm volatile("movdqa %0,%%xmm14" :: "m" (dptr[z0][d + 48]));
 		asm volatile("movdqa %0,%%xmm2" : : "m" (p[d]));
-		asm volatile("movdqa %0,%%xmm3" : : "m" (p[d+16]));
-		asm volatile("movdqa %0,%%xmm10" : : "m" (p[d+32]));
-		asm volatile("movdqa %0,%%xmm11" : : "m" (p[d+48]));
+		asm volatile("movdqa %0,%%xmm3" : : "m" (p[d + 16]));
+		asm volatile("movdqa %0,%%xmm10" : : "m" (p[d + 32]));
+		asm volatile("movdqa %0,%%xmm11" : : "m" (p[d + 48]));
 		asm volatile("pxor %xmm4,%xmm2");
 		asm volatile("pxor %xmm6,%xmm3");
 		asm volatile("pxor %xmm12,%xmm10");
 		asm volatile("pxor %xmm14,%xmm11");
 		/* P/Q data pages */
-		for ( z = z0-1 ; z >= start ; z-- ) {
+		for (z = z0 - 1; z >= start; z--) {
 			asm volatile("prefetchnta %0" :: "m" (dptr[z][d]));
-			asm volatile("prefetchnta %0" :: "m" (dptr[z][d+32]));
+			asm volatile("prefetchnta %0" :: "m" (dptr[z][d + 32]));
 			asm volatile("pxor %xmm5,%xmm5");
 			asm volatile("pxor %xmm7,%xmm7");
 			asm volatile("pxor %xmm13,%xmm13");
@@ -414,9 +414,9 @@ static void raid6_sse24_xor_syndrome(int disks, int start, int stop,
 			asm volatile("pxor %xmm13,%xmm12");
 			asm volatile("pxor %xmm15,%xmm14");
 			asm volatile("movdqa %0,%%xmm5" :: "m" (dptr[z][d]));
-			asm volatile("movdqa %0,%%xmm7" :: "m" (dptr[z][d+16]));
-			asm volatile("movdqa %0,%%xmm13" :: "m" (dptr[z][d+32]));
-			asm volatile("movdqa %0,%%xmm15" :: "m" (dptr[z][d+48]));
+			asm volatile("movdqa %0,%%xmm7" :: "m" (dptr[z][d + 16]));
+			asm volatile("movdqa %0,%%xmm13" :: "m" (dptr[z][d + 32]));
+			asm volatile("movdqa %0,%%xmm15" :: "m" (dptr[z][d + 48]));
 			asm volatile("pxor %xmm5,%xmm2");
 			asm volatile("pxor %xmm7,%xmm3");
 			asm volatile("pxor %xmm13,%xmm10");
@@ -427,7 +427,7 @@ static void raid6_sse24_xor_syndrome(int disks, int start, int stop,
 			asm volatile("pxor %xmm15,%xmm14");
 		}
 		asm volatile("prefetchnta %0" :: "m" (q[d]));
-		asm volatile("prefetchnta %0" :: "m" (q[d+32]));
+		asm volatile("prefetchnta %0" :: "m" (q[d + 32]));
 		/* P/Q left side optimization */
 		for ( z = start-1 ; z >= 0 ; z-- ) {
 			asm volatile("pxor %xmm5,%xmm5");
@@ -452,17 +452,17 @@ static void raid6_sse24_xor_syndrome(int disks, int start, int stop,
 			asm volatile("pxor %xmm15,%xmm14");
 		}
 		asm volatile("movntdq %%xmm2,%0" : "=m" (p[d]));
-		asm volatile("movntdq %%xmm3,%0" : "=m" (p[d+16]));
-		asm volatile("movntdq %%xmm10,%0" : "=m" (p[d+32]));
-		asm volatile("movntdq %%xmm11,%0" : "=m" (p[d+48]));
+		asm volatile("movntdq %%xmm3,%0" : "=m" (p[d + 16]));
+		asm volatile("movntdq %%xmm10,%0" : "=m" (p[d + 32]));
+		asm volatile("movntdq %%xmm11,%0" : "=m" (p[d + 48]));
 		asm volatile("pxor %0,%%xmm4" : : "m" (q[d]));
-		asm volatile("pxor %0,%%xmm6" : : "m" (q[d+16]));
-		asm volatile("pxor %0,%%xmm12" : : "m" (q[d+32]));
-		asm volatile("pxor %0,%%xmm14" : : "m" (q[d+48]));
+		asm volatile("pxor %0,%%xmm6" : : "m" (q[d + 16]));
+		asm volatile("pxor %0,%%xmm12" : : "m" (q[d + 32]));
+		asm volatile("pxor %0,%%xmm14" : : "m" (q[d + 48]));
 		asm volatile("movntdq %%xmm4,%0" : "=m" (q[d]));
-		asm volatile("movntdq %%xmm6,%0" : "=m" (q[d+16]));
-		asm volatile("movntdq %%xmm12,%0" : "=m" (q[d+32]));
-		asm volatile("movntdq %%xmm14,%0" : "=m" (q[d+48]));
+		asm volatile("movntdq %%xmm6,%0" : "=m" (q[d + 16]));
+		asm volatile("movntdq %%xmm12,%0" : "=m" (q[d + 32]));
+		asm volatile("movntdq %%xmm14,%0" : "=m" (q[d + 48]));
 	}
 	asm volatile("sfence" : : : "memory");
 	kernel_fpu_end();
-- 
2.34.1

