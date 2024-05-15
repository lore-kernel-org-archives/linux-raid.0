Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2047.outbound.protection.outlook.com [40.107.22.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6630C14AB4
	for <linux-raid@vger.kernel.org>; Wed, 15 May 2024 11:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715774227; cv=fail; b=i6NStZJEwBGSQTDQY4yKyYhRsAPAnh7rL6kVk54ovLd1j+Rk51kOyGQ5eZp5v87pGsV369Rak2E4dn/vWoglUud4bE8+QEPhphK7dhdZY7rhUoo3mAVFYOLlvdMI6ODSWWGSBA2t0SyZlLCtfhJb3E6mU1gbYqsA4XP7JWHSiUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715774227; c=relaxed/simple;
	bh=7MKS+Cf7+eeeOpyJAWAxSicVoOEALovZAKrjN2qtkkM=;
	h=Message-ID:Date:From:To:Subject:Cc:Content-Type:MIME-Version; b=nl9CKANU4rfEPJ4ifdM7Q0ZCcBxGq5USwbJmgfgLr1tP1u5Q44e49wd3+LJosqJrxZ40h396Vp/ZujXO25uT1gKxtVPTG81frNLoJQ9+mJT6xGfZnfPUQEeXABY3FcDGUGSzSWzBCPCOg5aiur03NYHskQxzLRBS6Fy8qCIBOTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=axis.com; spf=pass smtp.mailfrom=axis.com; dkim=pass (1024-bit key) header.d=axis.com header.i=@axis.com header.b=XRPjzc7F; arc=fail smtp.client-ip=40.107.22.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=axis.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=axis.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=axis.com header.i=@axis.com header.b="XRPjzc7F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tqt1lwaZOFOPpJhN/n738qXl1FfsC+lrYgyE5qnIaXNRa8Bv1FY1+ADHNVzbzEoKyN48kDQ6ESvex2f3sHoakX+QbojnaxN9oCZ0neFKjSkwKtuNWs4+lwEa/qR8eso7ETDnG/Vh0bDSB/th6HSl/FCOXv4KsMC21j3C1uD3GAXIU7vgFpklG3IxsXSL3fXkE6G6HPT/HAYnVppAzwtXao/PAg9SAkrBiSMxH4DRFW3OSaX0BFz7+bZrFvRqgH81OltZ6PRvqcMni9HdBdqQbRv4/XLCvNvsrK0o7z135D8n9GpqQVv57/UuMkgCgnLQMzTbLv3B50gOxxM/WR3gPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MlIBVuzc7+ey/ZORIB6RMuAo9EzVVJf5N7yQgfX6v2s=;
 b=BZaZW2fVi32xmJXrcJlMBNi82urNEX+SQ2+9hndMmAN8KgDm03aheyYSIAc2m+RRES85+Ryvn4GvpCy03z/xzdrGVK9/v5799MF6cSXYjxtol+rJx3KMj70tZoWgk/dzpTrDAoQCP/iWDX8+sCZaZ7vPnhebkMbi2gCAUuoeGhLln4Yg3Ebuj7zGd+rID9Uf6g1ypvgi1pQvr3aFT5b/zuz7VHSjEuI09LRpmoBhLJLf8/89gsvhGmWYKIVXSx6pxwQ/prM58Zy1tfulbQIXrqgDYmBkKoRWh20kwoaJrFnUz5Ck5HVLY4uTHPG42GrFBzKnsy0DWmoYlyoEYj0CCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=axis.com; dmarc=pass action=none header.from=axis.com;
 dkim=pass header.d=axis.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=axis.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MlIBVuzc7+ey/ZORIB6RMuAo9EzVVJf5N7yQgfX6v2s=;
 b=XRPjzc7F+XQI1NrPpfSPU4fBS/C/xdwRolUZ1VkH5Xt9a1BkjR39lyVa/nGwZeEg0JbLeax3yrhCebNSfXr/MgkT0BUVTeoq0Zd6RWAJApaQS7qYHKXoo5ay7pdV65AGVi3wPVCxcvYRZ0RFT2yBxaduGD81DLrsDKIzhW+vPV8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=axis.com;
Received: from GV1PR02MB10909.eurprd02.prod.outlook.com (2603:10a6:150:16c::9)
 by AS2PR02MB9168.eurprd02.prod.outlook.com (2603:10a6:20b:5fb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 11:57:02 +0000
Received: from GV1PR02MB10909.eurprd02.prod.outlook.com
 ([fe80::42d7:280:d9dc:e5be]) by GV1PR02MB10909.eurprd02.prod.outlook.com
 ([fe80::42d7:280:d9dc:e5be%4]) with mapi id 15.20.7544.052; Wed, 15 May 2024
 11:57:01 +0000
Message-ID: <3bb2549f-846a-4179-9e23-407235a06753@axis.com>
Date: Wed, 15 May 2024 13:57:00 +0200
User-Agent: Mozilla Thunderbird
From: Gustav Ekelund <gustav.ekelund@axis.com>
Content-Language: en-US
To: song@kernel.org, dan@danm.net, junxiao.bi@oracle.com,
 yukuai1@huaweicloud.com
Subject: raid5 hang on kernel v6.1 in combination with ext4lazyinit
Cc: linux-raid@vger.kernel.org, kernel@axis.com,
 Gustav Ekelund <gustav.ekelund@axis.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MM0P280CA0062.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::16) To GV1PR02MB10909.eurprd02.prod.outlook.com
 (2603:10a6:150:16c::9)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR02MB10909:EE_|AS2PR02MB9168:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e53e369-6ec0-4c93-8c12-08dc74d621aa
X-LD-Processed: 78703d3c-b907-432f-b066-88f7af9ca3af,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bUdncHJJUlF1NUNodlJ4NHc2TjJpVGZ5MkZLTVhGZllnOEZDT1Joc3VvMW4z?=
 =?utf-8?B?V2ROVmd4d3dMVFA1MExQRlAyQmFXQ1Z3Y1E5TmdxSm90MXpmYXBaeDU3dVpa?=
 =?utf-8?B?bHNmR295QWlyR1JHWFJhSFdrVEFZV3FHYlBXNStiYlNvN3hRcm50V3gxWWtk?=
 =?utf-8?B?OTVwY0hGQzg1YU5DemlIdkdmc2g0cVNhY0JhNC93UVhjVWE5cE1seDRWTWFV?=
 =?utf-8?B?ZWhhcFYxRmI0N2lzSUxUazFxbERVQnRMUU1PUTZRSU1tRVdiaHJ3Vy9ncDdu?=
 =?utf-8?B?NXpxd0IrWHFzZHJxZlZMdS9hUWt0RW14aEl2NXp2NER0NGFDNUV1enV4RSsx?=
 =?utf-8?B?L3ZQbkNMdmFDWmdmUTUwTUtnQllTUlBqM0creCtRMm11ZmFMRDhnWm1mTGJR?=
 =?utf-8?B?YmpQSmZjS3Rkelc2WWMyclNRYjExTlp2aDZhaUdNdFRHZlE0eXVZc2hFTVN6?=
 =?utf-8?B?dTNZNWhGczByZWx1RjdOOTdTVU9DeGx6RW5xdlpCR3ROK0xQQnJ0WEdMVk9p?=
 =?utf-8?B?TTNTSmcrSnY4enlPUGJWbSttTXlFN01RQmNPRTk2ZXNMNjRrcFRPNUEzTi9u?=
 =?utf-8?B?VTdYMkMwYk1lTzVSdDN6dVhpZXNpSE9lbUJ6ZkxzbS9ORVpabEkveGRXSWpj?=
 =?utf-8?B?WWorYmFHZnlyR09iZExqakY1b0wveVdDV3ZGcEdlTDhOT1FUU3FFY1doVnpB?=
 =?utf-8?B?YTRJWE8wM0dVNGdveURQS0pCMnhUdndTS0prVkNvcElmeTdlMmh3b25BQUhJ?=
 =?utf-8?B?eGdWdHg0SHhuSXZwZldINVI1L0dnbGcvcGgrekloOXUzZnIvaWFCTGhGWXFv?=
 =?utf-8?B?SjErTXZ2K0NaKy85djBKa1owU1AwNHhwMDJEOTNveGxlbUVpKzVUaVBISUha?=
 =?utf-8?B?V1k1dHA5U0E1eUo5SEdBaFRNZ2hxZmNVNS94ZWJzS0dFcURsUjVtTkdYOXo3?=
 =?utf-8?B?TW1EL2VnOCtwNEQ5TXFjcSs3eVZ5cHZvK3VTSVU3Z0ZyYTg5V2xzZWtkTXFQ?=
 =?utf-8?B?ckNhcCtvWXF5azN5SFRLdjUyUUVJVmtKdnRwT0Y5YTY3MDZndWtpZU0zYVF6?=
 =?utf-8?B?dTBPYW40bjJxTjhsRGxnWjRZaTgwMkRQaEEwdlB0VDFuZkJvRWdNUkFQdi83?=
 =?utf-8?B?VFVDTjc3UWo5YUprRGRqMGZncGpQL1Fpc3pERGFrQkhCZE41UWdHaDBhSUVO?=
 =?utf-8?B?KzdrYmRGQms0NjY0YmFFbmNFQThtMDMvL0xBV3lRY2xiYkFydnREdWhvMFFq?=
 =?utf-8?B?VXlPUEk1Q1R5N3lPUXQ0SDdVOFpsYU5wYTVuSmxZbWxHS2k4WlRKZzFSSEpO?=
 =?utf-8?B?V1lTdEZ3a29Wai8xZThQUnhMQkZsRWovTjZPcjVhL2M0ZG5LSS8zenRBN2VP?=
 =?utf-8?B?ejQvbTU0MlJaQnhOMldqdjB6UitSeXdwNlZ6T3ZHaXhNVWJrVERvS0Iwdlhs?=
 =?utf-8?B?cVRIemVEeWZiNFd0b25xc2h6YjVSUFptam9Jc21RcElGZ3lnUk56cktFUXU1?=
 =?utf-8?B?RndsRWNIb0p1ZGZpTW5sVnJLY2RlMWlpM1VhWWpjU0lHek9RM0FDVHRUS0lS?=
 =?utf-8?B?MHZhcmIydjRGWHVYUWR5Z0IxM1FnSlZnUjB6Z2prK3lPZC84UlNVdERMMlBJ?=
 =?utf-8?B?Q3ZyNjdVZ3RJVnNJcEFUb254ZDhYS1E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR02MB10909.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cW9NZ0tIQ1ZOQkNsSlRlZmZpZkxLdXZRNWZDRWZuZGNMaXZmT1ZGbC8zUXZo?=
 =?utf-8?B?c3BIREppNUgzUUJ3cGhlanh6U2txdjdYS080K1VqRmR4M0Z5cTRuUVVxWWlP?=
 =?utf-8?B?b1lhOGVVRmhvYjh4d0lLV0hUbTdBaHVJalgwQURPQUVrQlZ4WUpJUG1kQUFU?=
 =?utf-8?B?V0tSM3J4V2NnQnlPcDFiVW5rVmJ1MzlOVEF3SnhLQS9xVDdhdjFMdndDM29P?=
 =?utf-8?B?S0kveGt0TUY1cFBpdHZzRkJIWlM3NGE5MXZXZTU1TnZTK25RU2VaZ2V5Ympu?=
 =?utf-8?B?eER4K200cW5yaFlZMDlKS05NMDFsRFd5MmFWSnAzOUNBQUJYeGdtSHM0RWdr?=
 =?utf-8?B?TzJuZHA5d3RWUXpKUkxlSGs1QmYzUGNLWWY3Qm9lVFBKWW5XdTl0S1dPbEsw?=
 =?utf-8?B?Y3ZTeVFjbkxvNTZsbnhtUW5lTVV3MENaVUFWbkY2YVBlYjRBK2FPMW9yblMy?=
 =?utf-8?B?TllwRXV3K3ZMSnJpRW1iZ3c1U09DckdXVzVGOGg4Q1hJWFFjT3ZiNUZXRCtx?=
 =?utf-8?B?QXlYRXNSVWVndlo5NGtqOUdGMXhzNEJWdUxPZHdKMmRVVTBYem0rUWFwL0tz?=
 =?utf-8?B?REdKY0NzQ0FBQW1SR3ZNQjRNU0sxSS8zd1JYUnhqbkJxT3BVY0wxNmU2MUNp?=
 =?utf-8?B?K29RM2hUdWJKaFJyaTBkY2dyMndjOFA4KzBEK21ySHRSUjgxOHBVc1hKZ21v?=
 =?utf-8?B?c09CQ0VXS3oxdUI0YzNRc3lDT0pmWTV0VklQVWNYdTh4SnRLN01kcEQ4ekJX?=
 =?utf-8?B?KzI1L2VLMHFPOVFMT3lybFhOWmhZMTR0TGg5VnJqZExNRVM2dU1zRzJrcE8z?=
 =?utf-8?B?bWd4aitvdmF1ZXY1cnhsMnRmRU1JQW50RU1zbkw2U1I3YTZ4NVc3cDFtNGR4?=
 =?utf-8?B?QzRidHZROHNYSFZZMjJqUVNCQlErYStjQWtQYkJXUEVxTko1UVVuYlRiWFkz?=
 =?utf-8?B?Q2ozSUVNU0RBOTVVa24rckV1Z2s5M1NQRlUxbm1Wc2tCQjc0SWpjbWFnV3Mr?=
 =?utf-8?B?bFR5M3VWTnUzRVN3V2orRWlZVjFuQ09GVmtaZXE5aDlFTXowc2t3a0svMmND?=
 =?utf-8?B?WUNxRjdvSG1wNXFTdTgwOXdWQWNVQ0QzQkE1K0VJcWp2T21TNXA1Sm5MOGlT?=
 =?utf-8?B?Vkh6bS9vb2MwbzFZK293MXF1L1NCUC9BSzhlblJ3ZTJFcVR6djlvS1RkQlRm?=
 =?utf-8?B?U1lWRnFaMldmdkkrK1lPUzBqcWk0U28zaGhhVVBMNDVrb3B1YVJxVnFKcSs0?=
 =?utf-8?B?QlF6T0w5TUNadDZCZjhFUmpUK0t1QThIVmw0UERvaHVzWGo0eERpVUpSRWlL?=
 =?utf-8?B?YjJ0UnRIWkZHdmpBell5SlRrNVYyMWJNVnprMkFuNXQvZnVjTGhEMy9wMGpT?=
 =?utf-8?B?dFVHazBhdldibXQ3d2dZTlk1UHlyblV1TW44bGtXY01mL21GZll1aTBWVFNu?=
 =?utf-8?B?SEZBQmNVMkZHSDNpOUpsNTNUWjNWNXVsQmV3OUl1U3p6aUg4K2MwcDFURWFZ?=
 =?utf-8?B?Z3BRbjl1cndQSTlVQ3FmRkVTZGpLOW9tT0dLcDdLd083aWJKSldtcDZMQzN1?=
 =?utf-8?B?ejhOU2NIdEJwTGE0WXAvSkpBTGtFZjBKMEdUczJoUWNmUDZSc1NMNDQwY3Fp?=
 =?utf-8?B?cTVUMUUzaGNsQXQ0Mk9tQStHZkt1VkJENmlQait1ZnRSRVMwSDVtNlh0QjYv?=
 =?utf-8?B?bXJRbzNGdDd4NCtacGpoWlJaN1FkcUhlRFRrcGdwZjRVeDRBb3pBSG9UWlJD?=
 =?utf-8?B?Zk5nQ0hmcVVuSmxxdXFGaXRQSzF4Mjdpb0JDb0piZFJLWjhMRHBjNzdtYTBN?=
 =?utf-8?B?a3NUZmxaSDhhc0lxeVVWSktCTWhLWlhvYmU5SmlDSU43cnZFZndjdElaaDVa?=
 =?utf-8?B?U0laUzluVkRqTDNzbEhRdmxlV2tienB4YUFoZ0ZHL0U4emlMM3hpZEpBSHlY?=
 =?utf-8?B?SmY4dGNCUThweXM3MmkyOHJ4ZWVBbG1KQldUNGFHUXV1UG5LTGpMTDVnSm4w?=
 =?utf-8?B?ZU80a0JORWNLSm9YaENQYjUyOVJxS3d6UVd4Vys0cmYvYTlaeFJtd1hHUytJ?=
 =?utf-8?B?THFERmh0QjdjZmE2bDF3Yk16aW1qbUQ4NlFKWWhDQW5qVGFIMS8rb0g1Z3dn?=
 =?utf-8?Q?EUhc=3D?=
X-OriginatorOrg: axis.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e53e369-6ec0-4c93-8c12-08dc74d621aa
X-MS-Exchange-CrossTenant-AuthSource: GV1PR02MB10909.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 11:57:01.7667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 78703d3c-b907-432f-b066-88f7af9ca3af
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y6QEAViUV55d+FO0Ddeygj5Pwe2kA3JGEjoYiwQSF3vY9GfqDHkxLkuyMdyipzj9urtZeo+rR+tGVrX0nbMRuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR02MB9168

Hi,

With raid5 syncing and ext4lazyinit running in parallel, I have a high
probability of hanging on the 6.1.55 kernel (Log from blocked tasks
below). I do not see this problem on the 5.10 kernel.

In thread [4] patch [2] is described an regression going from 6.7 to
6.7.1, so it is unclear to me if this is the same issue. Let me know if
I should reply on [4] if you think this could be the same issue.

Cherry-picking [2] into 6.1 seems to resolve the hang, but following
your discussion in [4] you later revert this patch in [3]. I tried to
follow the thread, but I cannot figure out which patch is suggested to
be used instead of [2].

Would you advice against running with [2] on v6.1? Should it be used in
combination with [1] in that case?

Best regards
Gustav

[1] commit d6e035aad6c0 ("md: bypass block throttle for superblock update")
[2] commit bed9e27baf52 ("Revert "md/raid5: Wait for
MD_SB_CHANGE_PENDING in raid5d"")
[3] commit 3445139e3a59 ("Revert "Revert "md/raid5: Wait for
MD_SB_CHANGE_PENDING in raid5d""")
[4] https://lore.kernel.org/linux-raid/20240123005700.9302-1-dan@danm.net/

<6>[ 5487.973655][ T9272] sysrq: Show Blocked State
<6>[ 5487.974388][ T9272] task:md127_raid5     state:D stack:0
pid:2619  ppid:2      flags:0x00000008
<6>[ 5487.983896][ T9272] Call trace:
<6>[ 5487.987135][ T9272]  __switch_to+0xc0/0x100
<6>[ 5487.991406][ T9272]  __schedule+0x2a0/0x6b0
<6>[ 5487.995742][ T9272]  schedule+0x54/0xb4
<6>[ 5487.999658][ T9272]  raid5d+0x358/0x56c
<6>[ 5488.003576][ T9272]  md_thread+0xa8/0x15c
<6>[ 5488.007723][ T9272]  kthread+0x104/0x110
<6>[ 5488.011725][ T9272]  ret_from_fork+0x10/0x20
<6>[ 5488.016080][ T9272] task:md127_resync    state:D stack:0
pid:2620  ppid:2      flags:0x00000008
<6>[ 5488.025278][ T9272] Call trace:
<6>[ 5488.028491][ T9272]  __switch_to+0xc0/0x100
<6>[ 5488.032813][ T9272]  __schedule+0x2a0/0x6b0
<6>[ 5488.037075][ T9272]  schedule+0x54/0xb4
<6>[ 5488.041047][ T9272]  raid5_get_active_stripe+0x1f4/0x454
<6>[ 5488.046441][ T9272]  raid5_sync_request+0x350/0x390
<6>[ 5488.051401][ T9272]  md_do_sync+0x8ac/0xcc4
<6>[ 5488.055722][ T9272]  md_thread+0xa8/0x15c
<6>[ 5488.059812][ T9272]  kthread+0x104/0x110
<6>[ 5488.063814][ T9272]  ret_from_fork+0x10/0x20
<6>[ 5488.068225][ T9272] task:jbd2/md127-8    state:D stack:0
pid:2675  ppid:2      flags:0x00000008
<6>[ 5488.077425][ T9272] Call trace:
<6>[ 5488.080641][ T9272]  __switch_to+0xc0/0x100
<6>[ 5488.084906][ T9272]  __schedule+0x2a0/0x6b0
<6>[ 5488.089221][ T9272]  schedule+0x54/0xb4
<6>[ 5488.093135][ T9272]  md_write_start+0xfc/0x360
<6>[ 5488.097676][ T9272]  raid5_make_request+0x68/0x117c
<6>[ 5488.102695][ T9272]  md_handle_request+0x21c/0x354
<6>[ 5488.107565][ T9272]  md_submit_bio+0x74/0xb0
<6>[ 5488.111987][ T9272]  __submit_bio+0x100/0x27c
<6>[ 5488.116432][ T9272]  submit_bio_noacct_nocheck+0xdc/0x260
<6>[ 5488.121910][ T9272]  submit_bio_noacct+0x128/0x2e4
<6>[ 5488.126840][ T9272]  submit_bio+0x34/0xdc
<6>[ 5488.130935][ T9272]  submit_bh_wbc+0x120/0x170
<6>[ 5488.135521][ T9272]  submit_bh+0x14/0x20
<6>[ 5488.139527][ T9272]  jbd2_journal_commit_transaction+0xccc/0x1520
[jbd2]
<6>[ 5488.146400][ T9272]  kjournald2+0xb0/0x250 [jbd2]
<6>[ 5488.151194][ T9272]  kthread+0x104/0x110
<6>[ 5488.155198][ T9272]  ret_from_fork+0x10/0x20
<6>[ 5488.159608][ T9272] task:ext4lazyinit    state:D stack:0
pid:2677  ppid:2      flags:0x00000008
<6>[ 5488.168811][ T9272] Call trace:
<6>[ 5488.172026][ T9272]  __switch_to+0xc0/0x100
<6>[ 5488.176291][ T9272]  __schedule+0x2a0/0x6b0
<6>[ 5488.180618][ T9272]  schedule+0x54/0xb4
<6>[ 5488.184538][ T9272]  io_schedule+0x3c/0x60
<6>[ 5488.188714][ T9272]  bit_wait_io+0x18/0x70
<6>[ 5488.192947][ T9272]  __wait_on_bit+0x50/0x170
<6>[ 5488.197384][ T9272]  out_of_line_wait_on_bit+0x74/0x80
<6>[ 5488.202604][ T9272]  do_get_write_access+0x1e4/0x3c0 [jbd2]
<6>[ 5488.208326][ T9272]  jbd2_journal_get_write_access+0x80/0xc0 [jbd2]
<6>[ 5488.214683][ T9272]  __ext4_journal_get_write_access+0x80/0x1a4 [ext4]
<6>[ 5488.221392][ T9272]  ext4_init_inode_table+0x228/0x3d0 [ext4]
<6>[ 5488.227298][ T9272]  ext4_lazyinit_thread+0x410/0x5f4 [ext4]
<6>[ 5488.233066][ T9272]  kthread+0x104/0x110
<6>[ 5488.237069][ T9272]  ret_from_fork+0x10/0x20
