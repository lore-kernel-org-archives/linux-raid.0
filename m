Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012033.outbound.protection.outlook.com [52.101.126.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8ADC29D299;
	Fri, 15 Aug 2025 01:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755222884; cv=fail; b=jQun46PqQyG1AhZfi3xszVsXTaTcw6tNZdLFEp93X+EXs44TdOUWqARnEgiOfHFWMGpb1HUJJVeGNFeamngSA/vs+R4xOtqXPVKj0aFVfBlOs55FuJadAzXnH5FrkVrRajJIxu3+eBDXPmrwh3ymOSMvBBtw/mgp4sSD0xeOqWQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755222884; c=relaxed/simple;
	bh=9crli4w5lEv7Xz2+3WY4HTlmAl7FHGOAanJaE/CwOdA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YeeuSGvZXiJ+XfVWi5hIjiy4zR4NVXvs9NpLy4Huv/gJCFm6yBjTpH7fQTy6JRC/UyUVPnRLAGQoZ+EsmCW7g3DNNSOnFIgEWYyYf17mctS8nVsvM6Ulf1C/UL/lMgrm8MpKYz/xMzyxhIL29ULdl1SsR/1pzbsoNk8SeCAzepY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=IZdqBkI/; arc=fail smtp.client-ip=52.101.126.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="IZdqBkI/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J3doJunwRufwD/YEeGhEUOeKSGUIx+SoQBRgnCh0qh6Z2rKrZR9Mg0lVMcoJYqNrXFQI/j99CUbQ74vfNjtyNKf/Tg5WVqluBuC6emlxTzEgOVClcpMqo6McdIrnE6RJk9EMg8Awlv9tdN72FqOS8IWIbQdqjfCSXetmPG9Kq8pWdKPlbGZKp11iI8DK/3oQ16P8OAbHH53IkCEXjvlHUdNI6Amo7R707EDVPqqc75e61D3qO3wheNmjqbtX6xl8xWq2vtj9LBX8Gz0dQO6H7XTi+U2bkCXgMNSIq7KRYcftNuYqIekcIblUi7qMeShgv6j9GgcUl86loZwUmLwZXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mynbEaym58iecpckqwnyosAfB3l54unADz06PO6TPoQ=;
 b=ujhjBIygh7jCOY8sDXs7CfRlCQPyRP3RfriGjJ+3TMwMGO4Uy++j4Hq4rIBHEdJbZUQ92GHZeDbOZqx/0atn+hTWLzx5rV7rCpUttYgzUa+BAIRK5z1J9vTO5CiqLEjV6akx7PH316KOA4IvfXQQYmOj+7NzqXsX4uAhv6LiFk1iRptD4hy1TitCXB8hXiFkWinm79luzldGvxNxRQjhrJfGy5/gbsXY1z2+/1Udr1xuvp9P+2A5eBt0Bm/W8saDjkn9glHvW9eLBX8vMgm01+3Dk6gWAHYbUv9+fADOCOMoRnXvkv2nveMpObSbAaCuDsHTurGv9kwIOX3cWngnsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mynbEaym58iecpckqwnyosAfB3l54unADz06PO6TPoQ=;
 b=IZdqBkI/F0Ca8B2LHmaXxWSBybrkV5xxcj5kUJDTW6IECPQboDkSKztqUrHKgqgetVVFIazdm37wNylQcmEHwa+2jyY1yjX5jAtukVz/I78sHaxMclpNUKI/RpJS9t4I2WwJIolILiLMOw4AbpNO7FbE2KRXewClRUhzBqDkTjg0UBuiCILbSxvReRDBN+2K6pcQ/o7PShC1dHHcy3iYcPU1+ol+dpnlUchfKvAbvnbvaqhZc0Wpd7o/UP2iZ6cm+RMei1PJIxr0mtSuZT1CRSYomLcntsJj1a1SavF9mv7CqBauJenNJ0kyYHpadeQTKIEMBISXU0njmQnoh2Fvww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by OSQPR06MB7974.apcprd06.prod.outlook.com (2603:1096:604:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 01:54:33 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 01:54:33 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH v1 03/13] lib/raid6: Clean up code style in rvv.c
Date: Fri, 15 Aug 2025 09:53:52 +0800
Message-Id: <20250815015404.468511-4-zhao.xichao@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 01ac5c82-53e1-436e-4e95-08dddb9eae42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t6JiZTkB/p7VHckbWBB/dCsUn6ORFD9i14l74q1fjCYNt/Sj5X3jtEukak/2?=
 =?us-ascii?Q?LQS1634/46nJME6cmCEziujCbDNLhALrXgqL5kJBMREj52P5XeD0JbvNTae1?=
 =?us-ascii?Q?O+9y2k9MK1SoGIX3ZxFy4uoHVrpnODYrXlNIaUz4J33HrIhS3pOvZPHzC91a?=
 =?us-ascii?Q?WFY2qvLYcxdprwlLxwQiMcBJLlmclCyvDcltM47JXqxJJrJsjsI7MDUrsqlx?=
 =?us-ascii?Q?eew4SpUWg+vqztQF/DISqH0OZgfoZLHgIvcbsrGWLdtsVNxBYYMJx6OPm3It?=
 =?us-ascii?Q?RL377dPPVUnkmTsjBNaUzNXOxP7PYHAHlNMRng/WURoFWlk6At04IQL/Pz6J?=
 =?us-ascii?Q?1UTVy7/9aFXwg1955kwQ9LvzSbYRlbofJrHcZeMkttu/VHVRyoEiz7+l5BEb?=
 =?us-ascii?Q?cE7QfoYjVohv/QZWcW5i/sMoo0qJmMyqCsbll9TF1qrLRSnG/UCSihQpGbey?=
 =?us-ascii?Q?pIYKUzi0rJps8LwDbsZlIUJZP4dgJ8T0xjeXLe334BbEaF2yzUqOokAk9QE0?=
 =?us-ascii?Q?ytnCkFumW4LLHzp9mN0/z6zcWgRDPssmCOOmaCVJxy7anZwS4MoNMe7bkx0P?=
 =?us-ascii?Q?teAeX4NhgdIGiSUdo9rjU/T384/nVBIwmVz+sVm5Gyq+E2rgjAtHtYjD2HDJ?=
 =?us-ascii?Q?Zdsxzvd82vf2qnKanreGOXdtr+pIcj1E28OvRDWvQjXVN/VOZ8kVsM/LWzGq?=
 =?us-ascii?Q?Um6lpjhas4RH39Cu2UH6MKq6oG4db3hXXHYc8cQz0hi9NJP+65HZJrnxU7/h?=
 =?us-ascii?Q?d6pmG4rshYenRhgl/nvpKLs3PlFp3XIkBVPYUPO3QRLJjiLoko4f3RO9OT3+?=
 =?us-ascii?Q?E25JghBmtGQhALC3PTbEevvcTljk5fk+xVHXkC+XyVEUs4vOC94tDbLL9QXa?=
 =?us-ascii?Q?fx0HbKhL2efk9ai9k14Q3TLITwvi8zMXz5bWuLe5YiEsF5lW8IQGdxqIhuhZ?=
 =?us-ascii?Q?P8OGhKTNyRektV2sO8LFmyByQmUd+x/t4kDwdvyOxE5/LPF0FUNR4IEpNI0c?=
 =?us-ascii?Q?9aDw+UuOuOWdjYFo3hC/vFovtrZcZJfgZ2IZPz7jHVFG19XHlwxUAucYx2+b?=
 =?us-ascii?Q?dMtShHloJ7u6IwviS3Yh5lwE9+5DCQcijKellDVQ5yPtbiTI3T6pEz5UFeL/?=
 =?us-ascii?Q?eLHR+NVVTzMpxP9YHJWw1s/zS3Fip/sLQgtmT+pwIx3F5aJoRxXn/gHXWPas?=
 =?us-ascii?Q?TNoI+EPLIHtAy5pwGAtslgrVJ9fqIftVlog6adAqVMfIQsLOgow2vZ2/wlwK?=
 =?us-ascii?Q?PL/mzQXNOMyZa4ZLyuyE4awFgV87LIj+qU5f1JwRTTvY57ALodIGVV210bLP?=
 =?us-ascii?Q?7U63p8ouLK5rywPdB4LE8Y9eLJuM4D7ih3mgQaw2J6roAASjbJ+2i0L0lsNz?=
 =?us-ascii?Q?NghIwrK45yUTTTAKPfs5FK6krDEXOn8me4lyZ3mxtAGZG1wR+pBpYQa07mWi?=
 =?us-ascii?Q?5YgDKixWqRA2G0Gs+925s7Eqx00P59R+1lGQKbFhV2lsMGnWGNZYKH4xjh9p?=
 =?us-ascii?Q?cozXRZrPQVN3TXQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NSWoBXPvOFqWwxTRRnAgpe/ycFaZ9Iypkvw52EOOqpnOu8IpSqdntD08Z7nb?=
 =?us-ascii?Q?rVRzAAht05RmWlN7dkp+4YgduEDyOz6X+7yxaHIRvAnpfz193FxPsQBr1n8Q?=
 =?us-ascii?Q?IhIKoAPVUyN/jYjcDbZs7RB9MCCfMPvyrVLuY429a3FE5xU42TEBEj2TwU+j?=
 =?us-ascii?Q?Gzsmkn/n8l1XVcDhBGV69aQR8ZM/IVyjhwGABHTAezNKWMeN8lQ6xleEjOSK?=
 =?us-ascii?Q?kuGwE8z8ksRcOupSJpHejLLOkMtEqgDA2kpery+DBSQr4RBck83olNb9/WCV?=
 =?us-ascii?Q?YfhFBy0xagjXmgxQgnzD/ARI4cYRDN3QII98n7+bZI3iA0yykKlYmoiBXRXV?=
 =?us-ascii?Q?63CQ9ckCmYOBsqE37j7coIwWZ2MLvmP70G4fpmeb9bz1tklOgbJ4pEqOguJH?=
 =?us-ascii?Q?hvt9v/Z1RPByOhT8UinbOIwiXrc1Y21XFAIUS516QExkwZTYQyK/4Y5fH3hM?=
 =?us-ascii?Q?WEbUf/gqJaQW31T6VmiAY6nfd/R3MMuun7KwjhUqkZhMPn905D8WwC9yaxLZ?=
 =?us-ascii?Q?9SHOtAn/eT7mawi7p0gly4CYe3+4imvROVtUPEqMUaLAaDHiwWGxcMjBEQC8?=
 =?us-ascii?Q?aCTO93E16d9kJ7KKZNNmnFQG9jMGSP4ycInJDxBSupXTNEUvUtI+JJZtkbcE?=
 =?us-ascii?Q?toBf/Jbk/IS2cGqznaA96Xb1fDJ52P+24a/fksJ2HtVYbkJUpNatlYVe5NKF?=
 =?us-ascii?Q?9ci7837PqylsU00J+qOMPYCmEDsT0GLoYsFbjr0QoUl8yPdywD7SvuU320dQ?=
 =?us-ascii?Q?GLW6JSQI3A4qOdwZChncwfyqVfq0wzMKgbzhuvxEqfM3PcekdzuCDLxZnIy4?=
 =?us-ascii?Q?EOSN6ZEccmDrxtSy54qn+VsUXXXbANaft663JsOQ8yOkVF0pUSo3sOWrYRWg?=
 =?us-ascii?Q?dtjUzb9SIWAgOk6nSxXxkWyQ/kXYTg0+2L17wyEG55S3LuoTkPdvdgGX72Oq?=
 =?us-ascii?Q?dEhfKQ3FIKwr6ibdna2LsQOd2V+Pc1YGTwX1qJljNA8XKxlLg8eB4g372ySn?=
 =?us-ascii?Q?d56oXa91VDKeOhNJl+pZGPwMVS96EgKrJk0tjlMJJf9kSZ8dqAjd61wL3gEK?=
 =?us-ascii?Q?QOU1BTaXw07DSBYCYfkBjmDoCUSAAYJeGTQC48Ar308ab0I1NW7vfpwxnMRo?=
 =?us-ascii?Q?dZmjZFfecbH8qZZ2lMG9xdoDOjrhK5z3C39FwT897grdODVLdPrnUFDWwIVG?=
 =?us-ascii?Q?kR2TgirgPRokAzPPvvG+8H3zrpKKbJ5b4QWMZNt5ji0EWizrzY3yXFuR/nw5?=
 =?us-ascii?Q?00zi1kV7aGL41SsGKk/yY525uKTHXlAv16MXdhi0dVxXEZIDUQ0IxneoTuLu?=
 =?us-ascii?Q?+WJB0q7NFazeX7SSErxKYC1gVIkorg9EvyXmAJ2xRsS7E77Dl3zHFkczkgXv?=
 =?us-ascii?Q?Rv4FkljDKfK2xzqMKz5zTyoKpP7XeZEe1w2Gl9iM0Y3M1M8dm0GXRwS3B6Ei?=
 =?us-ascii?Q?bIvTRnKhEp/76nF0nJwmcuPRWf2MAl02pTJ6bsoXP3tOqlwgc8AnVT/vr+AJ?=
 =?us-ascii?Q?z9oCom7fAUaIxhyqeGV4IdZI/KyKw6EDv/op9y5WsJRNU7j5FnoGNelEYSep?=
 =?us-ascii?Q?Ocdyr0EBI/Fl5sGP5XAKn69PGVpEcXtIYvL97NMG?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01ac5c82-53e1-436e-4e95-08dddb9eae42
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 01:54:33.2803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qmp3abG50Yut+SNMF90dePKs/kNNeWx0Ao1p0QGhPx2Ya03uEoF2lvB4U0fvBXKR3EixTJV+BVns6oC92oXYlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7974

Reduce or add spaces to clean up code style.
No functional changes here.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 lib/raid6/rvv.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
index 7d82efa5b14f..0446872e9390 100644
--- a/lib/raid6/rvv.c
+++ b/lib/raid6/rvv.c
@@ -31,8 +31,8 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
 	int z, z0;
 
 	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0 + 1];		/* XOR parity */
-	q = dptr[z0 + 2];		/* RS syndrome */
+	p = dptr[z0 + 1];	/* XOR parity */
+	q = dptr[z0 + 2];	/* RS syndrome */
 
 	asm volatile (".option	push\n"
 		      ".option	arch,+v\n"
@@ -53,7 +53,7 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
 			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE])
 		);
 
-		for (z = z0 - 1 ; z >= 0 ; z--) {
+		for (z = z0 - 1; z >= 0; z--) {
 			/*
 			 * w2$$ = MASK(wq$$);
 			 * w1$$ = SHLBYTE(wq$$);
@@ -115,7 +115,7 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
 	);
 
 	/* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
-	for (d = 0 ; d < bytes ; d += NSIZE * 1) {
+	for (d = 0; d < bytes; d += NSIZE * 1) {
 		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
 		asm volatile (".option	push\n"
 			      ".option	arch,+v\n"
@@ -202,8 +202,8 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
 	int z, z0;
 
 	z0 = disks - 3;		/* Highest data disk */
-	p = dptr[z0 + 1];		/* XOR parity */
-	q = dptr[z0 + 2];		/* RS syndrome */
+	p = dptr[z0 + 1];	/* XOR parity */
+	q = dptr[z0 + 2];	/* RS syndrome */
 
 	asm volatile (".option	push\n"
 		      ".option	arch,+v\n"
@@ -421,7 +421,7 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
 	unsigned long vl, d;
 	int z, z0;
 
-	z0 = disks - 3;	/* Highest data disk */
+	z0 = disks - 3;		/* Highest data disk */
 	p = dptr[z0 + 1];	/* XOR parity */
 	q = dptr[z0 + 2];	/* RS syndrome */
 
@@ -731,7 +731,7 @@ static void raid6_rvv8_gen_syndrome_real(int disks, unsigned long bytes, void **
 	unsigned long vl, d;
 	int z, z0;
 
-	z0 = disks - 3;	/* Highest data disk */
+	z0 = disks - 3;		/* Highest data disk */
 	p = dptr[z0 + 1];	/* XOR parity */
 	q = dptr[z0 + 2];	/* RS syndrome */
 
-- 
2.34.1

