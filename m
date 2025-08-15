Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012033.outbound.protection.outlook.com [52.101.126.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB5F29C35F;
	Fri, 15 Aug 2025 01:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755222877; cv=fail; b=YMVlb9njhqhnrE1T6H+K+HqHZMLQuDptVGlOntDJhfNAbD4/KhNjx3UcH4ET5y6mkzY7XusuPvY91opGScZYfMSKbhHmyuGErFCJiU1RlLSWJEhrBHLfF+VfwI44H2CI2HJWzeJrE8sRCOJfFg913Qa1ugrWOfjdBAHP+V5L4xU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755222877; c=relaxed/simple;
	bh=F4BVcy8NaIU9nT7PaB9Q+6WBK5aPi4KOxuMOu4kPFD8=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=HcHgRMUy3/g0t/oQ5kU8MW1EA486wxyBKLaS9vfV0WUmtCyItx1ZfJ7DRJVaLXwNOe9TQkkgRMTmKK9g1A/a+ppi3IUhE1ToTsh+fsacmugafSJJS7oQyKPt8+UENhELw/Hu2PzTy0bILyb7jITFEhNDyr3TGRYFILwECWjTU1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=TDLDiydN; arc=fail smtp.client-ip=52.101.126.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="TDLDiydN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yyGUM47BR9TgPERBMx6DdK+1VTWfKHU0zvGOwQp2+mVSkoznpyU6E3X4WBIlLWYBoKTSAY5bxjLmjbvUgkKvWaiM7E6lbtOL9cxA9WlCu1FS59kxVyyMsFLoiSMl80+3tSN0vZT5peLHXBUekeo9KHB2J+2A9OkRs7gKrQTKTekOVqRxKbDfBhSKHmlPM9FdpefdMpbXpzWRP/7cv+Iotm4+MyQrhlTxJUgry3dh5kq9artnokTlLC2sohIUwWAOSADbKp0kjdcdDyy5TJXdVOhCK0Z6IE10Meh9NfCDN0srUrlJhCb8MO5ZIMsOe0qLuQ7HARZsXNR3WA3DOnW7Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VRksRBSpC6nf3hl5SPp6OJrc2kENor80XiVq9I6klqo=;
 b=QpUT/OlNNh3/Sl2ULdHvYFjf/t6C04UCbGtLNtDLImLAAH875tsfa8CGrFlzsswwEN8dL+XyXExjVvslPbLR/qxznUpKI/QWL7TDc41J78aH+ONL87mkCax2J0Q4UbrWMfwkm7NVKBJlcKQCJfg2wPcHnh+rMypzC6bPH5WIIRiA4DFUPcq8fE1BfiroRyEC1VOBn4mMT0eQQzAOCNStmz0wAAzYzpfD5ZlxbfR07EzVbjVv5SwiZAjFgJEv/P3YOth+b6JCHOlVNnMrjYFJowCCil//UYVqP9/1DNLbDZQXOqcUIYits019JVfzfSemUMBPVrSxpP4IqYgbzk19pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRksRBSpC6nf3hl5SPp6OJrc2kENor80XiVq9I6klqo=;
 b=TDLDiydNdKhFSjset0lsBzlGTPXSgIOGTnqoaNgq1O5AIHXhE6v1+NPvgaD39sFAxiWhp/Twu5AFlytEeiKgBUzgeQDKO8rHbx8E7UAeBlos0XLD7DBADTJYRnJWrW5eNQVVv6oszYoWJ5UJK5Wa7NVtoO2kSJvSL0PUd8mnH+w4wNz1B9Nn1uVy0IprZnKHWFf4j5onqDHh44J2uVQlXO/DSHa35EUmavXj2dD+HmKwfb5EQ6M8RaxsM6jv1HmBzBI1Mn45ZxqcE7bEF99BxgJra5WTdFM8lVD/hvC2ZHxXQ0gTBprmNVzUmyyRVqBAegBZ3oSSA5zSSTFIwn/p7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by OSQPR06MB7974.apcprd06.prod.outlook.com (2603:1096:604:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 01:54:30 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 01:54:29 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH v1 00/13] Clean up code style
Date: Fri, 15 Aug 2025 09:53:49 +0800
Message-Id: <20250815015404.468511-1-zhao.xichao@vivo.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-Office365-Filtering-Correlation-Id: b7eb2fff-407d-4ed3-a4d9-08dddb9eac17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MdUHTO9bkuNHE/kX9GAxCALihnD1eagRHL9yQrYl5Rm2AZDXHc8U7eJ/uUni?=
 =?us-ascii?Q?3fmP+xH72spmTEp0DEu82dvScSVLoqsDBnratWQuehyIOE5w6/JGhv1qQitP?=
 =?us-ascii?Q?1AMRsvl1Y7mdSosPedrFYEF8PVLzouTo+/umaDZzeOuaXHA/b5tJSi2izhVo?=
 =?us-ascii?Q?Ja0MF1FDhwmlSsEYyxdtjv9q1BmgZ/x0UIjL1frv9XlL9WgPb7BqvODBxGky?=
 =?us-ascii?Q?Z2TF2VU7Vmb3ssmlN0XA4BYKCg9lznzrg1tH+ZhMus6/JUkcvT/uspo9klSB?=
 =?us-ascii?Q?FIphWZnwvfFhR9kEHN01ZD4VCrlp7qqRToP84ekNIdGY4PagF7B4E9AgFyu4?=
 =?us-ascii?Q?vFEtAFptExBSPcWqU9bnJCXL8Bsw0mrfLAApbDkoC0GXauEz+hgTT6OcdwDF?=
 =?us-ascii?Q?Jb6gGDuebu9Jh6pOXXpEW2Kz6GL+h+heIHfglrn0bsrcZ31lDJoiwLPNyZ8i?=
 =?us-ascii?Q?itFwIQguyR+9x4Uu2+LJoOd36N2Ir+num6rPfwL05v9pkhK0EJoAsgTuTe2n?=
 =?us-ascii?Q?ts4+3uBj5a2BRib9cURbYFZukLRhMowMWOCXjxxKCqa90tqfvI0Dn227y2U3?=
 =?us-ascii?Q?i20r6eZhv3xKmrEUch6dw8nsPF9QfeBuf+LJZZbDlmWwJ7feg58ldHArv+W2?=
 =?us-ascii?Q?SreEZyIrtBXy6ouYMmkrk+BhrKPzzflIEsgRFKdH/762gn6Wv4dsSbofXFTJ?=
 =?us-ascii?Q?F/eSWSySdRRQK2DYee8PHgyA8OAo3306vmlUNrBUDlzpMqgcqCPrImUSJK19?=
 =?us-ascii?Q?lacFNXwbaQQ+8jcClbtSYKV9aofQ+kGBJ7ICFnrXdSy0Uc/sGaWVrrGosYz8?=
 =?us-ascii?Q?AmTUZo5hK+xyj2HXtb3hEvTG6DxoDryDYhz3QtJDFUCspn6kNINy0cD/ZqbE?=
 =?us-ascii?Q?6PkJqI5xesAA8s+s5rftgfH1o6F5ksgl7G0tROZmGL1EpTbZ8GKcbRXxUPRD?=
 =?us-ascii?Q?PwmNAEYRjMEBPxgOQa/2io72kBheYvzGvLIdFHJAa39dv6T+6FlnPfindvBI?=
 =?us-ascii?Q?v9MVVcqc2iiCF+FOhRdx/WTtCW1euJjOLk9q/merp5xpBQBSIeuYrtc9A2f+?=
 =?us-ascii?Q?cCEwwxNvwTGRTR2aO/MHABIg9VPYCeBosWqBRxUc1gEIHfFNKKxVDQbHt+IL?=
 =?us-ascii?Q?izDzIZteObmrrphslfq5/9MXVt0s1dTzbVxa8WDpSAvT8TGlY61VFoqW2L7Y?=
 =?us-ascii?Q?zqkTKKxu0hUW1gZ4Qa48cq5/QxA4rNyjh78/acUK+bRg/drxmjGkLOWlmKkz?=
 =?us-ascii?Q?LZ9DxRZe0mFqbKjJ/y4F5ELP1ukicdF8fH71HN8Zj+f6sYZEeXAdNbLJQYUQ?=
 =?us-ascii?Q?qNKvl4nH3AoFqaFxUWtqk9aMnlO1v90GvvV4npkdEB+uvhu/S0uzHXwpiqGq?=
 =?us-ascii?Q?JORV/iMI+nEVAf1q2maUUYn28TG9VimAseNg2hsWrBv0IIOhKXdKSrHvXEo2?=
 =?us-ascii?Q?Y78tEHx0RTcKS7MprYR7NBGFKJuWUjrp7xzCs1icJ8zivh4q4Iyguw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qTha9h6gD+2zPFd/wDzng/iWhPTpwMpXIb3Jjr8yOdR2a5kC8hSDaIw5szn5?=
 =?us-ascii?Q?bpOhZx8Opth3SIcVO0EHpE/y3z0mGjC33ROmwEs3Jl0ktORbPlhg6KD0GdVb?=
 =?us-ascii?Q?FHirTS1jCFKQ4LQRDEM47r+JAjHyry+bvhjOtAMa9hg4T/BgAVh2ft00/hn3?=
 =?us-ascii?Q?P+TdG+hbnxbJecjUcY7L4z4jkFb6jWDUdbkxE37QnNsejCXY0/OBO8vc2J/p?=
 =?us-ascii?Q?vvTeRm4qnDxOejTb0rH+UDExN8F5COCI2nHVLrDQlpNoGYzKoDkJX8aIvy1C?=
 =?us-ascii?Q?jfjjH6gpMo5GlUJB07AlAMuh02+EWBWgL3l0W8bZGBW3396wVRWB2DVSHtw2?=
 =?us-ascii?Q?QRXQt4lCCMl0cHe4e/ZsJ8gdMrqhOpvCTlAVDCOvLGiSF50d1kYJS12a5lX0?=
 =?us-ascii?Q?+r2xygTdWwyti/uH1SuuWAfg7Rs82sWddqBCB2cyTn5EsPZ9KK1d+z7FWf8X?=
 =?us-ascii?Q?AMs2RHE21XiiT/h/ZmhKV/vL/DSW9tWtr4HT9ZOtZqOZPQBaB7n5P2kmraRm?=
 =?us-ascii?Q?nO5qbbBsNt2LTmw24qt2T7j2oHEmhcQZnQdBt3RUtWPhreTx7Aux5HsEsSBW?=
 =?us-ascii?Q?qAfPbBFGYK+V28O7nVJx4QKMIh4QSGZf7DEFeDgBjEuF7udYC1PdpNp/dbGT?=
 =?us-ascii?Q?/gdgW78jrUO8l3Rung9zyBGwkcjNn3BPDi8O8lFEBEycsG1WikTmS55rhrB1?=
 =?us-ascii?Q?ykGec6za2wetrNYnoNFRaq5f6AmjT57NgFvjWbH8k6GSZc2fGAIGcL7XgF5C?=
 =?us-ascii?Q?7F07YWXezR/AqeSs0VhOU5LmctYNZoTNTf8sQjR1vWlaingRkb+thTS42DhQ?=
 =?us-ascii?Q?oYkP1NsM/i1Pz00sDEgRDKALxmLBMAWFhwhhpCctCozc203FZ3ArsOPUfs4M?=
 =?us-ascii?Q?lQaJEsmUnDa37MjHXg4Mps5qwVVJ52yRioX35/PR5FW9Zxzqkz3JcUVzSlRG?=
 =?us-ascii?Q?RL9cvvI3YCK+CWa/Q9ABMD+50fh64GY4MWAHsqKenSL4jWyjxbGJoSXqBpEw?=
 =?us-ascii?Q?FTymOc7DKNNLzPNWpIaoQACCsOalEoKVlj+SfxZzbFwyXXGqD6SFnn7H3wTz?=
 =?us-ascii?Q?bhNtrNygd6yXOkJmpIL41+2mYBt8J4QYqTDjqcKpvwQ8puSR84qhKQqDZwDS?=
 =?us-ascii?Q?xBnhbiCk2lh0B7jEegk986jpFf53dF1BBKI+UXfw1hkPSfUdty77KwwDYwYL?=
 =?us-ascii?Q?VBDKSWzIYLkYZYihi2I6pSCg87aB3tTuO/ahr+f138okvNjIVB9lDr8RX2H0?=
 =?us-ascii?Q?j/Y/5+3U3RG8fagSERDipKOYKYncW6K4AeVQOrjUe6uxEB18+Vqrv1JGQtws?=
 =?us-ascii?Q?lydtqxGudIvdslUufKP3rGZAr62Ln5BBk6oRdFHfjZPZBqkkp4uyOe9Oy4u3?=
 =?us-ascii?Q?H3NjX93Rk2KrsAMnorakBc9B/blyxgVzChebM+Lstuz/b6aDLHAaui6KOiqy?=
 =?us-ascii?Q?F2XSbmJd3ZXSbT6xPzH8E8cjl2alq628M2ArEuGJbOqPJIKfz97MuX58uM01?=
 =?us-ascii?Q?WOXb7tFRGxzu8k+//xxCD47s/3UmxkqP20WgQnYHxT8OBnseKAmtbNeAgJaq?=
 =?us-ascii?Q?HeiuKLyuyAgAg6YbDmHjjuWUnOGxbZvdGxEV79mL?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7eb2fff-407d-4ed3-a4d9-08dddb9eac17
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 01:54:29.7094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lORcChweh5QB5NfX5hg/hYQnhwJpkjalIjTqWBexJXlvBqa1A8VYnBsaz7zG5TJUDF/d073BBi8k+oGAspojfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7974

Reduce or add spaces to clean up code style.
Clean up comment style.
No functional changes here.

Xichao Zhao (13):
  lib/raid6: Clean up code style in sse2.c
  lib/raid6: Clean up code style in sse1.c
  lib/raid6: Clean up code style in rvv.c
  lib/raid6: Clean up code style in recov_ssse3.c
  ib/raid6: Clean up code style in recov_s390xc.c
  lib/raid6: Clean up code style in recov_avx512.c
  lib/raid6: Clean up code style in recov_avx2.c
  lib/raid6: Clean up code style in recov.c
  lib/raid6: Clean up code style in mmx.c
  lib/raid6: Clean up code style in loongarch_simd.c
  lib/raid6: Clean up code style in avx512.c
  lib/raid6: Clean up code style in algos.c
  lib/raid6: Clean up code style in avx2.c

 lib/raid6/algos.c          |   2 +-
 lib/raid6/avx2.c           | 122 +++++++++++++++++------------------
 lib/raid6/avx512.c         |  94 +++++++++++++--------------
 lib/raid6/loongarch_simd.c | 116 +++++++++++++++++-----------------
 lib/raid6/mmx.c            |  24 +++----
 lib/raid6/recov.c          |  44 +++++++------
 lib/raid6/recov_avx2.c     |  28 +++++----
 lib/raid6/recov_avx512.c   |  20 +++---
 lib/raid6/recov_s390xc.c   |  36 ++++++-----
 lib/raid6/recov_ssse3.c    |  36 ++++++-----
 lib/raid6/rvv.c            |  16 ++---
 lib/raid6/sse1.c           |  30 ++++-----
 lib/raid6/sse2.c           | 126 ++++++++++++++++++-------------------
 13 files changed, 356 insertions(+), 338 deletions(-)

-- 
2.34.1

