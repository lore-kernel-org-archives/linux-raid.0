Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF60C2BD58C;
	Wed,  3 Sep 2025 16:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756915883; cv=fail; b=cMYvABiXiaYkkAeReM7hpWMFxR0fPxOflagQ8nUKCOR+g2G4fLnPlm4T0D/SisGWIGthD4aEhd5vb2Phxk2/tObs+eOMDAagHzFi3j8UNh/6yoVC5OsfoLfayuX5AE/+UUkMLK6rszBf5IeHdWRoBQ7MtF6bZ4CT04LmSYvbFWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756915883; c=relaxed/simple;
	bh=F8/MdimcCpuGTJM4TGuN7EDI4xRnp28BhGRt369vvqE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=HQ5u/IrxJFyxhNKldmUVExqPpRfFkG7a2n1XV4Eg7tJwUNwm6eaxJvOq2mZ1LDWh88kxXKIZrzTCfwhtOlefBsR6CO3iT2r7uARbjNXHDQF/H/FgdwwVz/T5xKYZqT9LgmSOksDL5033IVcR1omxCYSlO8b7P/Q55VozXwh0Om8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rphSCyeH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SlQFVUNf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rphSCyeH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SlQFVUNf"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5839NBKO016675;
	Wed, 3 Sep 2025 16:11:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=WKzd1f7s26G8W06i
	hNtV31xf19B9z2k+0Kvzkh3I588=; b=rphSCyeHryvUx1bBLQjLpu1PftUA5a/I
	3Q+5ARoO+IqYF1ivEdWhOwCLZRRlPHy60UloRQa6SD9DZL53CO8Y4JSEvfg2lFAq
	Do4enKjkV+5qfp13p5nN/7LJ3bTJGgu3kCJkReXIdIlznAXb+2ps85M9XBbabNgT
	9VRlVnQE1qSkiGmPXgHkMuv6pOGaOC4Md4wnHKer4KQZ2H0vadUlo7ielPkvcq3o
	35/0UyN8/gBqmW/3sTcSMhK8f0vyN74pNpb0mnK5ar3Yr2I3ORvmQ+FPyTOP1CaR
	mgjKRkilNwk0YwHS+5IXA7BpvTqCgCrtHoAFHXyXYUPmhQ+DFyvzaw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usm9pv6q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 16:11:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 583FIS9R015810;
	Wed, 3 Sep 2025 16:11:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48v01pspch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 16:11:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bw1lYembrN3alyrPMPKodzKcn6tMHI6CMlZSHNLkk/6iutF1HS1/RqimBqvFVCC2WSQ3PDmR4nYFHD9eQI3hUc2Bxn3+uhsT3gfWFz0rfVhUnq2ujDpuA8cIZNn7+iWEB/cltMZOK2lnzIlyZYcz6RVcKsU73uRkRSa8LkeI/8F4AVhbYvRC63GqbQkWcg3aJkrTjqrmaS1acvGLQ06PvHmJFuwQIWh7nE3MojjmYEBWF6SiklE+RnrA5/PtTWtuZrVfYy0nWbzOUOM2e1IjO8IiMu7UaLPcAG73cxfuuTbW2dvTQHuI3clfNawv1QnpfBTru7ygJ78YSOUNnyvcag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WKzd1f7s26G8W06ihNtV31xf19B9z2k+0Kvzkh3I588=;
 b=vm1TR6rdzPbrxLJMUtFJdrOO5Dh4WLLZHoYBNhfl3Hcn/qTXPio7ziFvzfcQd0RrelhJ21V0mN68YaRnn0cLBHWh4GyRL4DMqQc0b4CQ2jXTjP7GK7tR4M8/y0EK2RYSPdxu9OGCR0TAkMn8sjo+Wglqy9m13guyhPYDarIqwndF3YDwGLUPjbkh7Xkitm06Gfs9mMCX0D3+yychuSEGbv7TLiaiOJsTzxeGoiAD/Pw74u8m710nHh7pFz+C2CvXHSQf9L5S2eox7Hs0zDQZakg2jc2ZyaHNCnXj5zVzZUlDGp9sl9bIG0Koh+TQldKmVgyWLrhC5FlSX0ivg0CkUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKzd1f7s26G8W06ihNtV31xf19B9z2k+0Kvzkh3I588=;
 b=SlQFVUNfyV0jx1QenWXFbD9BP5JVx75oBJZPZD1+Bu9AcHgAsJGwGkcS1c98CZWTQ4IslH0nWOtp2nFtS0g3d5jrhigK0sin177gP69I3jIfWXhsKrpP0tQeBZT2AOMaz9N9pMil+jViX9Frz0mTAOay/cagNiHZP1YdgMrvXiI=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DS0PR10MB8128.namprd10.prod.outlook.com (2603:10b6:8:204::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 16:11:08 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 16:11:07 +0000
From: John Garry <john.g.garry@oracle.com>
To: song@kernel.org, yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.petersen@oracle.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH] md/md-linear: Enable atomic writes
Date: Wed,  3 Sep 2025 16:10:52 +0000
Message-ID: <20250903161052.3326176-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0041.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::16) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DS0PR10MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: 3803430f-3127-4c28-368c-08ddeb047d2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hgOfAi4zt43PQdw0p04AWAkgTgLBPwYOERNzfthD3HpAY3K+biUoO7pNshsa?=
 =?us-ascii?Q?Wy5MhDhAJgFlm1uk//fmWf11uF+o1P9haWJpUMWTUAQWvOp73OK+u/rKsPNy?=
 =?us-ascii?Q?chiA2fvxMIMP1oNTNhKyyE5YBekGNztp9c+cFlDSp3kgP3YTEUCMcX8qYBHO?=
 =?us-ascii?Q?oPA6byhLeFSj4/aWoP94/lQ0jBzii+e6DQdJRopSSQJpxGeHw5YUVZtQ8VPP?=
 =?us-ascii?Q?Qj24NhxOo5g4RE/4UGqOno/WZyk+NTmy3e8cPG0xbXLUWs1PxBnDiQKjbvKS?=
 =?us-ascii?Q?FOOF309T7W25BHS57NxzD5l2o5uY6NLRqTL55eUBlZp2YgzRbAgTox2q3ADJ?=
 =?us-ascii?Q?Pw8cdgUAg8cq/8NQxsx035UKpeU10OwdTGkBKz1/YajHhfHKlJnAC9VwBzsy?=
 =?us-ascii?Q?F2HAVUYQ08m5XPzLj1tzGvB3eh6zun95g+1MWRiPgpJnPER8EWBSpcmU84rv?=
 =?us-ascii?Q?HJI1JYnMfpFLzlxDYQ2ZBks5H7ru9nvEsC0da8lhXko0u1fBdwlY8xSBIE4F?=
 =?us-ascii?Q?iNrrbiMyCGfl1sj8DBxEElFWHrJlvaqmvr5QH9yna0OKN2Fi8ORSM3cQjlXn?=
 =?us-ascii?Q?odQ7V1r1hZGH3i7w/XdccGOBqb34macWFelQGUqmHtGne6hkBVSnSdUA/GX+?=
 =?us-ascii?Q?u/05m6NwVsgvIWQhjdtjuB969BB+alu5FEO7ecyDeNPVfLsm3rabTuviGWmL?=
 =?us-ascii?Q?g/mvpOYi5gBYoZf7iK75d+5yp8gs/spkRwmNwAFyEtTltqrEu/XCf9oZCRwQ?=
 =?us-ascii?Q?KPaHfBpnX99HUpYnz1SUbIDLzbcXkbu1QDPOOU3bzudjja01QqusWtIM7y7C?=
 =?us-ascii?Q?b0kSC0FieUn/CiNPY9XLOBXKKhvGyZ45ov3Sh0veK8yVjEmH/mXBG6M0zD59?=
 =?us-ascii?Q?hY1X9je90DPcXLSTw4rBWQGBu5BQkpYrkf8C1XbwyWghIIksycsiHBF9QHr7?=
 =?us-ascii?Q?dIGIUVyhkkacmH0C/FsQA6mTocqaFHMXUloJpaL44umCH5jBaXZmmAqgoAQn?=
 =?us-ascii?Q?i02lyE31rtXiEOS3Zha2Fm8wsCIPvNSW1s7H1+v1Adcqdh3yrhXoOjf7CUQS?=
 =?us-ascii?Q?X88zHmvPNNvBq0XeQjCumk6H+GOEsoQkQaCi37oddqZGSSeZhRgIZ5j0Func?=
 =?us-ascii?Q?W2zjCNBeYya7YcTJeoMhLo7eClNcW6zAVtqd93Au6e6FE/mfuv6FDzUN/5dg?=
 =?us-ascii?Q?pJFOkEg9DwIEig9mK3wkv0JK3LSjctUdZwWJ6fY+7DTGu65kTGvD+RpZeWho?=
 =?us-ascii?Q?apbDNQy8Gma6DyrFe3lTG9rNIFiy5T+Rk40+AEWqRjmAUHBKf19QVp1cRjjT?=
 =?us-ascii?Q?b2jXGiu8buC93IIfI4XX6L5Bp2J4D3NjkV3Kncx+2Eujz0JEGOfIH13wWUvL?=
 =?us-ascii?Q?CPCl3pnGwbN0a1P9BlCZT0+ghSKtVyq/8RNq8b3jfVJ1Vude6V1JFieC5UD0?=
 =?us-ascii?Q?uMHCKLhcqOg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zGuEqZcrw7jSiKht+otuj2WLIPlJ2/n0MYa7QPVGGIgj7DopiTJG7EWxZJua?=
 =?us-ascii?Q?AoNxlH8TZ8ycoFa3nCwEmIYsu+ePGaaLj3m80EWjE61y8rr69U+VE+G8z99g?=
 =?us-ascii?Q?+xpRrpeXj5u9sAK23MBszaOXWzfNy34oVzgF48KZb9Xpd4Ha1YNAcqpWGZ/v?=
 =?us-ascii?Q?H8U+do/6fV4nmlY7w8xqQB9rvakOKDrMVDZVYqzaKLwFv1umio7sCFOc+O/v?=
 =?us-ascii?Q?PGAQYUAGjkosMFxbKCThQ8b2LZHll7X1umQPQdH0iUv6UNipPnxNZeEuGuZB?=
 =?us-ascii?Q?kMaXV7I7XYcieFnQzEbpOa1st4+0HgvWW3Wt26RuzuhYhatI7UsQ8t1M85xR?=
 =?us-ascii?Q?pcxIRy9y2PIBd+5q9DvogBm4zwmyh6Pn2187GCmOEKg8VWMzYXNYqqBPP1Oc?=
 =?us-ascii?Q?TW8Q+8w4id4oXRF1mTgaDKdnhRhmBDjzPhR99r3sqm3AqCTMa/M825qgri1z?=
 =?us-ascii?Q?LM9fB1KbeoFZBUQNpmK2GTu4pVy287qFW+ETGbLZaerL+qllq64OjN593nXm?=
 =?us-ascii?Q?ycglRoO/h7Xt3F3X8eP9wu/VOUDwF8X1NWm1kBWGZTh98gKlI3eTumGngcZ9?=
 =?us-ascii?Q?SLSTje/3nW2ym7Sv9gkeYKTpaG02fGnMfS3DlrYYgr8HxO49QeYvx3CgZuNr?=
 =?us-ascii?Q?7zs9p6k9ht1ZbzoF9w3TqcEcI8Udd/St98j6jXsqlkllIZzw24h/t/9NewZE?=
 =?us-ascii?Q?Kb+XBYIsDMpZ3gQOnKQCu69IaHuWlLz3FIs3DR3YuXrBPZXqlhLNtKinRr6G?=
 =?us-ascii?Q?FG7iLKNRCjcIXqrJD99zfTjd/YjYdQMUa3xXk3STf76K93jIRytmhKnpDlBz?=
 =?us-ascii?Q?Xs1Czq78EZsuh977fNFuMbdNmQ2kbI4qE6iYsKGrvec56u0tdvrwGPVXIxg9?=
 =?us-ascii?Q?May9L7AASnuh73Kg7GCwfAvTqBNFE/XYdiOr2E5qltHUwB9r6K84e90uLjVF?=
 =?us-ascii?Q?SIDgDaWpf2jEZMNgUcBHBoxdslKTwtOaUttZ4xETntFEDMdOR1HVpSl0i/+G?=
 =?us-ascii?Q?iwEi7XHOzhv1Mdb5YkTVzKE0yYFxMwHDR0/WlxU0S3fAqr0kk4zTLaebQnDq?=
 =?us-ascii?Q?MIvGV4Jd0XT0NRHfuzJ79Iuj8/TsoTc9SvaDEn3Eue/BdYgz4gWk4tKzvWZu?=
 =?us-ascii?Q?dIovkJckQCYd8djbPzDx+/or9vv9xtBNsl0vWp+MehTSUDEAC9TH/4myjSAN?=
 =?us-ascii?Q?B0IohtW0mTFIeHFqrJvG2E22Lp4sChLdbr6o8Y3WgKyosQ6jmpgM4f1avhHY?=
 =?us-ascii?Q?FBd98ZlDZxWdITRY5ZFtGp28kmEyY3QCRETqMr4Xyp//lal4xLuJMunWQwMG?=
 =?us-ascii?Q?ucF5nXIWLrFTDjHQHXO08I88m0P2RxuZuGhjvbImuKdelrXPCVjEeydLfEno?=
 =?us-ascii?Q?vmFLIaYyP34zj+T53rQlnIKPCUXGFo6NPPno+1y3tbb2uQGfnELdcAATMXoY?=
 =?us-ascii?Q?/2YyvC+8cRd5OzNJseY7fByjsafnxG7uzSOCiSuIx+AUFxj2RPrqUaThJCh6?=
 =?us-ascii?Q?OWo8hCqbbt7zDtEx3zD05kcW122v8wpZUp847oBkRQ/BgK4PkITuv46ujxkr?=
 =?us-ascii?Q?5oeZGRlHI4ZpndhqaJ0NlSuScd9wFzHWLCFVoO1PZVUDSMQDLGCf6E10s+PW?=
 =?us-ascii?Q?+A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hUuaFDPr4UXYXgnZsZU52c/4Gr1CKN1EKMiZG9k7Zj3ZTqTCCEzIjXtfSnl4AKctyuOWnevJdxSE4xhNH7cRIUwK3vK5KCdyeELMDaFfjsXTrMdwQfqcYHEUeUb6N3A+64bAgXujzkWi82TccKXX1T4r99uPB1+fyfNeWnXELaU4v3tKVVFOX11TOUHvBWec/A7Ecd9NvfG22EfeZLwwMiFhA+4r0pApbUXA+eQrmQ+6rHuuo74nnJdliEupbDzyEqI/iL4h8T3XC6NPuLvB2kj6zzKIjeZGB9af8HWWPCv4meuGlvLGsxdfEKcV/otc0/JWtJUVdTu+NKXI3nIRo05K6NVuS/x1Qd7GwY0u5KJNvGU++eZVFN/XQi88Tq/hCrGNcVPBvCydUYL6nJtHVil+P/yI51vmHJIAPDN3ZeeZFW0LW2f9xCMS5dAk8ti+XRfcZePB3CeJqTwtLwjqnHNfvPtm36jwRTKgI/xWMQ9xmQlI2GKebaQDD+aU5wCBoja9t56yJDm8MZ/iuGuowhdIRNWDNU6gj8p7O+svFEZEwLT3EGEzaqn747EpjML5yZzWSd97ut+v84UElK1xn7YmF7GazRTo93XZ8jCkLV8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3803430f-3127-4c28-368c-08ddeb047d2f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 16:11:07.0743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V+wPEIV485TLPRYp+rhAizyejbrzXKOrDw9JaVNbshKh+CmXralc5Gqq+fz4gTQ14d0sf001z0L6YmJNBj1J0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-03_08,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509030162
X-Proofpoint-GUID: 1ZqnymKuDAo_Y0zCe5Ag8H8CPXu6aWau
X-Authority-Analysis: v=2.4 cv=I7xlRMgg c=1 sm=1 tr=0 ts=68b8689f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=tPU5rVgmF7fRYoHzgjQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMSBTYWx0ZWRfX5v/WOd/mvhvN
 Vfp7/8Y8zalmeq4GMEzSoRLj4y7hN/ndUwNMvWEWpDRQqJKilG9bJ67b8oyk/aEo/HZP1fkCVZG
 lbpwfIjBfbsG5jIA2+5GYhKqwudIAwrey10znP8jicc4SwHlcHFyeoVSgnHlvjNEEnUl2S1OwWm
 1cNpSTmHYcUTdwZMZ6m1RQ7z3Lk0OXfQev6mJEihDCnghvRm0NY2wkXeY4JkdMyRMxzWScJEePb
 oW7wcd1bSKTAYb4Euv6pl3ZHCpiF0g18EfgdKnXIWZw5h5wO1VTy4OPnyoUrL2hJLC1dSKy4jMy
 RYX7akF5wYbgrs3ViOxFwi61yCxGGSkDna1IIka7cBYiR2sSeK02BCmyJ2Pi1L385UIlpECZpSN
 U2yPPmjY
X-Proofpoint-ORIG-GUID: 1ZqnymKuDAo_Y0zCe5Ag8H8CPXu6aWau

All the infrastructure has already been plumbed to support this for
stacked devices, so just enable the request_queue limits features flag.

A note about chunk sectors for linear arrays:
While it is possible to set a chunk sectors param for building a linear
array, this is for specifying the granularity at which data sectors from
the device are used. It is not the same as a stripe size, like for RAID0. 

As such, it is not appropriate to set chunk_sectors request queue limit to
the same value, as chunk_sectors request limit is a boundary for which
requests cannot straddle.

However, request_queue limit max_hw_sectors is set to chunk sectors, which
almost has the same effect as setting chunk_sectors limit.

Signed-off-by: John Garry <john.g.garry@oracle.com>

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 5d9b081153757..30ac29b990c9b 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -74,6 +74,7 @@ static int linear_set_limits(struct mddev *mddev)
 	lim.max_hw_sectors = mddev->chunk_sectors;
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.io_min = mddev->chunk_sectors << 9;
+	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
 		return err;
-- 
2.43.5

